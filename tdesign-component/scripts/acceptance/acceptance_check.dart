// TDesign Flutter V1.0 组件自动化验收引擎

//

// 基于 component-acceptance-standard.md 验收文档，自动检查全部 11 项验收标准。

// 用法：dart run scripts/acceptance/acceptance_check.dart [--skip-tests] [--skip-build]

//

// 检查项映射：

//   档1 静态核查 → checkStaticGrep()

//   项C export 收敛 → checkExportConvergence()

//   项F resolve 单入口 → checkResolveSingleEntry()

//   项B 禁用写法 → checkDisabledConvention()

//   项A Demo 注册 → checkDemoRegistration()

//   核心3 覆盖率 → checkCoverage()

//   项E analyze → checkAnalyze()

//   项E Golden → checkGoldenExistence()

//   项D API 文档一致性 → checkApiDocConsistency()

//   核心4 文档注释 → checkDocComments()

import 'dart:io';

import 'component_meta.dart';

// ============================================================

// 报告数据结构

// ============================================================

/// 单条检查结果

class CheckResult {
  final String category;

  final String name;

  final bool passed;

  final String detail;

  const CheckResult({
    required this.category,
    required this.name,
    required this.passed,
    required this.detail,
  });
}

/// 全局结果收集器

final List<CheckResult> results = [];

void addResult(String category, String name, bool passed, String detail) {
  results.add(CheckResult(
    category: category,
    name: name,
    passed: passed,
    detail: detail,
  ));

  final status = passed ? '\x1B[32m[PASS]\x1B[0m' : '\x1B[31m[FAIL]\x1B[0m';

  print('  $status $name');

  if (!passed && detail.isNotEmpty) {
    for (final line in detail.split('\n').take(20)) {
      print('         $line');
    }

    if (detail.split('\n').length > 20) {
      print('         ...（更多见报告）');
    }
  }
}

// ============================================================

// 路径辅助

// ============================================================

late String projectRoot;

String get libSrcPath => '$projectRoot/lib/src/components';

String get exportFilePath => '$projectRoot/lib/tdesign_flutter.dart';

String get configDartPath => '$projectRoot/example/lib/config.dart';

String get testComponentsPath => '$projectRoot/test/components';

String get apiOutputPath => '$projectRoot/example/assets/api';

String get docsPath => '$projectRoot/docs/v1.0/components';

/// 递归列出目录下所有 .dart 文件

List<File> listDartFiles(String dirPath) {
  final dir = Directory(dirPath);

  if (!dir.existsSync()) {
    return [];
  }
  return dir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();
}

/// 读取文件全部内容

String readFile(File f) => f.readAsStringSync();

/// 组件目录名 → page 文件名列表（部分组件文件名与 dirName 不一致）

const Map<String, List<String>> _pageFileOverrides = {
  'sidebar': ['t_sidebar_page.dart'],
  'tabbar': ['t_tab_bar_page.dart'],
  'search': ['t_search_bar_page.dart'],
  'tree': ['t_tree_select_page.dart'],
  'navbar': ['t_navbar_page.dart'],
  'cell': ['t_cell_page.dart', 't_cell_group_page.dart'],
};

/// 组件目录名 → 测试文件名列表（部分测试文件在 test/ 根目录或命名不同）

const Map<String, List<String>> _testFileOverrides = {
  'tabbar': ['t_tab_bar_test.dart'],
  'calendar': ['t_calendar_test.dart'],
  'date_time_picker': ['t_date_time_picker_test.dart'],
  'picker': [
    't_picker_theme_test.dart',
    't_picker_types_test.dart',
    't_picker_widget_test.dart',
  ],
  'popup': ['t_popup_test.dart'],
  'navbar': ['t_navbar_test.dart'],
  'tabs': ['t_tab_bar_test.dart', 't_tab_test.dart'],
  'tree': ['t_tree_select_test.dart'],
};

/// 获取相对项目根的路径

String relPath(String absPath) {
  return absPath
      .replaceAll(projectRoot, '')
      .replaceAll('\\', '/')
      .replaceFirst('/', '');
}

// ============================================================

// 检查 1：档1 静态核查（grep 排硬伤）

// ============================================================

void checkStaticGrep() {
  print('\n━━━ 档1 静态核查（grep 排硬伤） ━━━');

  // 1a. 构造器 themeData: 参数检查（应为无）

  final themeDataFiles = <String>[];

  for (final meta in componentList) {
    final compDir = '$libSrcPath/${meta.dirName}';

    for (final f in listDartFiles(compDir)) {
      final content = readFile(f);

      // 排除 theme_data 文件本身（SliderThemeData 的 themeData: this 是传递给 Shape 类，不是 Widget 构造器）

      final fileName = f.path.split(Platform.pathSeparator).last;

      if (fileName.contains('theme.dart') ||
          fileName.contains('theme_data.dart')) {
        continue;
      }
      // 匹配 `themeData:` 作为构造器参数（排除注释行）

      for (final line in content.split('\n')) {
        final trimmed = line.trim();

        if (trimmed.startsWith('//') ||
            trimmed.startsWith('*') ||
            trimmed.startsWith('///')) {
          continue;
        }
        if (RegExp(r'themeData\s*:').hasMatch(trimmed) &&
            !trimmed.contains('SliderThemeData')) {
          themeDataFiles.add('${relPath(f.path)}: ${trimmed.trim()}');
        }
      }
    }
  }

  addResult(
    '档1-静态核查',
    '构造器 themeData: 参数',
    themeDataFiles.isEmpty,
    themeDataFiles.isEmpty
        ? '未发现 themeData: 构造器参数'
        : '发现 ${themeDataFiles.length} 处:\n${themeDataFiles.join('\n')}',
  );

  // 1b. copyWith(extensions: 检查（应为无，改用 mergeExtension）

  final copyWithFiles = <String>[];

  for (final f in listDartFiles('$projectRoot/lib/src')) {
    final content = readFile(f);

    // 排除 t_theme.dart 本身（mergeExtension 实现内部使用 copyWith）

    if (f.path.endsWith('t_theme.dart')) {
      continue;
    }
    for (var i = 0; i < content.split('\n').length; i++) {
      final line = content.split('\n')[i];

      if (line.trim().startsWith('//') ||
          line.trim().startsWith('*') ||
          line.trim().startsWith('///')) {
        continue;
      }
      if (line.contains('copyWith(extensions:')) {
        copyWithFiles.add('${relPath(f.path)}:${i + 1}: ${line.trim()}');
      }
    }
  }

  addResult(
    '档1-静态核查',
    'copyWith(extensions: 禁用',
    copyWithFiles.isEmpty,
    copyWithFiles.isEmpty
        ? '未发现 copyWith(extensions: 使用'
        : '发现 ${copyWithFiles.length} 处:\n${copyWithFiles.join('\n')}',
  );

  // 1c. TTheme.of( 残留检查（应为无）

  final tThemeOfFiles = <String>[];

  for (final f in listDartFiles('$projectRoot/lib/src')) {
    final content = readFile(f);

    if (content.contains('TTheme.of(')) {
      for (var i = 0; i < content.split('\n').length; i++) {
        final line = content.split('\n')[i];

        if (line.trim().startsWith('//') || line.trim().startsWith('///')) {
          continue;
        }
        if (line.contains('TTheme.of(')) {
          tThemeOfFiles.add('${relPath(f.path)}:${i + 1}: ${line.trim()}');
        }
      }
    }
  }

  addResult(
    '档1-静态核查',
    'TTheme.of( 残留',
    tThemeOfFiles.isEmpty,
    tThemeOfFiles.isEmpty
        ? '未发现 TTheme.of( 残留'
        : '发现 ${tThemeOfFiles.length} 处:\n${tThemeOfFiles.join('\n')}',
  );

  // 1d. build 内 Colors./Color( 硬编码检查

  // 白名单：Colors.transparent, Colors.white, Colors.black, Colors.black54, Colors.black87 等

  // 以及 CupertinoColors.*（系统组件默认色）

  // 以及 theme_data/resolve 文件内的默认色

  final hardcodedColorFiles = <String>[];

  final colorWhitelist = RegExp(
      r'Colors\.(transparent|white|black|black54|black87|black12|white12|white24|white30|white60|white70|red|amber|grey)');

  for (final meta in componentList) {
    final compDir = '$libSrcPath/${meta.dirName}';

    for (final f in listDartFiles(compDir)) {
      final fileName = f.path.split(Platform.pathSeparator).last;

      // 排除 theme_data 和 resolve 文件（合法的默认色位置）

      if (fileName.contains('theme_data.dart') ||
          fileName.contains('resolve.dart')) {
        continue;
      }
      // 排除非主 Widget 的辅助文件

      if (fileName.startsWith('t_') && !fileName.contains('_test')) {
        final content = readFile(f);

        final lines = content.split('\n');

        for (var i = 0; i < lines.length; i++) {
          final line = lines[i];

          // 跳过注释

          if (line.trim().startsWith('//') ||
              line.trim().startsWith('///') ||
              line.trim().startsWith('*')) {
            continue;
          }
          // 检查 Colors. 但排除白名单

          if (RegExp(r'Colors\.').hasMatch(line) &&
              !colorWhitelist.hasMatch(line)) {
            // 排除 CupertinoColors

            if (line.contains('CupertinoColors.')) {
              continue;
            }
            hardcodedColorFiles
                .add('${relPath(f.path)}:${i + 1}: ${line.trim()}');
          }
        }
      }
    }
  }

  addResult(
    '档1-静态核查',
    'build 内 Colors. 硬编码（非白名单）',
    hardcodedColorFiles.isEmpty,
    hardcodedColorFiles.isEmpty
        ? '未发现非白名单 Colors. 硬编码'
        : '发现 ${hardcodedColorFiles.length} 处（白名单: transparent/white/black 等）:\n${hardcodedColorFiles.join('\n')}',
  );
}

// ============================================================

// 检查 2：项C export 收敛

// ============================================================

void checkExportConvergence() {
  print('\n━━━ 项C export 收敛 ━━━');

  final exportContent = readFile(File(exportFilePath));

  final lines = exportContent.split('\n');

  final exportedStyles = <String>[];

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i].trim();

    if (!line.startsWith('export ')) {
      continue;
    }

    // 合并多行 export 语句（export '...' \n show ...;）

    var fullLine = line;

    var j = i + 1;

    while (!fullLine.contains(';') && j < lines.length) {
      fullLine += ' ${lines[j].trim()}';

      j++;
    }

    // 检查无 show 子句的文件级 export（可能暴露内部类）

    if (!fullLine.contains(' show ') && !fullLine.contains('show ')) {
      // 检查导出的文件名是否含 _style

      if (fullLine.contains('_style.dart')) {
        exportedStyles.add('行${i + 1}: $line');
      }
    }

    // 检查 show 子句中是否有 *Style 符号

    // 检查所有 export 行（不限文件名），捕获从 _theme_data.dart 等文件导出的旧式 *Style

    // 白名单：TInputCardStyle 是布局子模式枚举，非组件主变体，保留原名

    final styleWhitelist = <String>{'TInputCardStyle'};

    if (fullLine.contains('show ')) {
      final showPart =
          fullLine.split('show ').last.replaceAll(RegExp(r'''[;'"]'''), '');

      final symbols =
          showPart.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty);

      for (final sym in symbols) {
        if (sym.endsWith('Style') &&
            !sym.endsWith('ColorScheme') &&
            !styleWhitelist.contains(sym)) {
          exportedStyles.add('行${i + 1}: $line → 导出 $sym');
        }

        // 检查旧式 *Theme 枚举（非 *ThemeData），如 TTimeCounterTheme

        if (sym.endsWith('Theme') &&
            !sym.endsWith('ThemeData') &&
            !sym.endsWith('ColorScheme')) {
          exportedStyles.add('行${i + 1}: $line → 导出旧式 $sym（建议改为 *Variant）');
        }
      }
    }
  }

  addResult(
    '项C-export收敛',
    '*Style 不 export',
    exportedStyles.isEmpty,
    exportedStyles.isEmpty
        ? 'export 中未发现 *Style 符号'
        : '发现 ${exportedStyles.length} 处 *Style export:\n${exportedStyles.join('\n')}',
  );
}

// ============================================================

// 检查 3：项F resolve 单入口

// ============================================================

void checkResolveSingleEntry() {
  print('\n━━━ 项F resolve 单入口 ━━━');

  final resolveComponents = componentList.where((m) => m.hasResolve).toList();

  final issues = <String>[];

  for (final meta in resolveComponents) {
    final compDir = '$libSrcPath/${meta.dirName}';

    final resolveFile = File('$compDir/t_${meta.dirName}_resolve.dart');

    if (!resolveFile.existsSync()) {
      issues.add('${meta.widgetName}: 缺少 t_${meta.dirName}_resolve.dart');

      continue;
    }

    // 检查主 Widget 文件的 build 方法内是否有内联颜色/尺寸计算

    final mainWidgetFile = File('$compDir/t_${meta.dirName}.dart');

    if (mainWidgetFile.existsSync()) {
      final content = readFile(mainWidgetFile);

      final lines = content.split('\n');

      var inBuild = false;

      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];

        if (RegExp(r'Widget\s+build\s*\(').hasMatch(line)) {
          inBuild = true;
        }

        if (inBuild) {
          // build 方法内不应有内联颜色计算（Colors.xxx.withAlpha/withOpacity 等）

          if (line.contains('Color(0x') || line.contains('Color.fromARGB')) {
            // 排除注释

            if (!line.trim().startsWith('//') &&
                !line.trim().startsWith('///')) {
              issues.add(
                  '${relPath(mainWidgetFile.path)}:${i + 1}: build 内内联 Color 构造: ${line.trim()}');
            }
          }
        }
      }
    }
  }

  addResult(
    '项F-resolve单入口',
    'resolve 文件存在 + build 无内联色值',
    issues.isEmpty,
    issues.isEmpty
        ? '${resolveComponents.length} 个 resolve 组件全部通过'
        : '发现 ${issues.length} 处问题:\n${issues.join('\n')}',
  );
}

// ============================================================

// 检查 4：项B 禁用写法

// ============================================================

void checkDisabledConvention() {
  print('\n━━━ 项B 控制类禁用写法 ━━━');

  final issues = <String>[];

  for (final meta in componentList) {
    final compDir = '$libSrcPath/${meta.dirName}';

    for (final f in listDartFiles(compDir)) {
      final fileName = f.path.split(Platform.pathSeparator).last;

      // 只检查主 Widget 文件，不检查 theme_data/resolve/test

      if (fileName != 't_${meta.dirName}.dart') {
        continue;
      }

      final content = readFile(f);

      final lines = content.split('\n');

      // 追踪当前是否在主 Widget 类内（class T{WidgetName} 到下一个 class 声明之间）

      var inMainWidgetClass = false;

      final mainClassPattern = RegExp(r'^class\s+${meta.widgetName}\b');

      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];

        if (line.trim().startsWith('//') || line.trim().startsWith('///')) {
          continue;
        }

        // 检测主 Widget 类开始

        if (mainClassPattern.hasMatch(line.trim())) {
          inMainWidgetClass = true;

          continue;
        }

        // 检测其他 class 开始（离开主 Widget 类）

        if (inMainWidgetClass &&
            RegExp(r'^class\s+\w+').hasMatch(line.trim())) {
          inMainWidgetClass = false;

          continue;
        }

        // 只在主 Widget 类内检查 disabled 参数

        if (!inMainWidgetClass) {
          continue;
        }

        // 检查是否有 `disabled` 作为构造器参数（A/B/C 类不应有）

        if (meta.controlClass == ControlClass.a ||
            meta.controlClass == ControlClass.bc) {
          // 匹配 this.disabled 或 disabled, 或 disabled: 在构造器参数列表中

          if (RegExp(r'\bthis\.disabled\b').hasMatch(line) ||
              (RegExp(r'^\s+disabled[,:]').hasMatch(line) &&
                  !line.contains('widget.disabled'))) {
            issues.add(
                '${meta.widgetName}(${meta.controlClass.name}类) ${relPath(f.path)}:${i + 1}: 不应暴露 disabled 参数: ${line.trim()}');
          }
        }
      }
    }
  }

  addResult(
    '项B-禁用写法',
    'A/B/C 类不暴露 disabled 构造器',
    issues.isEmpty,
    issues.isEmpty
        ? 'A/B/C 类组件均未暴露 disabled 构造器'
        : '发现 ${issues.length} 处违规:\n${issues.join('\n')}',
  );
}

// ============================================================

// 检查 5：项A Demo 注册

// ============================================================

void checkDemoRegistration() {
  print('\n━━━ 项A Demo 注册 ━━━');

  final configContent = readFile(File(configDartPath));

  final issues = <String>[];

  for (final meta in componentList) {
    if (meta.configKey == null) {
      continue;
    }

    // 检查 config.dart 是否注册

    final hasRegistration =
        configContent.contains("name: '${meta.configKey}'") ||
            configContent.contains('name: "${meta.configKey}"');

    if (!hasRegistration) {
      issues
          .add('${meta.widgetName}: config.dart 未注册 name="${meta.configKey}"');

      continue;
    }

    // 检查是否标 (V1.0)

    // 在 configKey 附近搜索 V1.0 标记

    final lines = configContent.split('\n');

    var foundV10 = false;

    for (var i = 0; i < lines.length; i++) {
      if (lines[i].contains("name: '${meta.configKey}'") ||
          lines[i].contains('name: "${meta.configKey}"')) {
        // 向前向后 5 行搜索 V1.0

        for (var j = (i - 5).clamp(0, lines.length - 1);
            j <= (i + 5).clamp(0, lines.length - 1);
            j++) {
          if (lines[j].contains('(V1.0)')) {
            foundV10 = true;

            break;
          }
        }

        break;
      }
    }

    if (!foundV10) {
      issues.add('${meta.widgetName}: config.dart 注册项未标 (V1.0)');
    }

    // 检查 page 文件是否存在（部分组件 page 文件名与 dirName 不一致）

    final pageFileNames =
        _pageFileOverrides[meta.dirName] ?? ['t_${meta.dirName}_page.dart'];

    var pageFound = false;

    for (final pageName in pageFileNames) {
      // 先在 page/ 根目录找

      if (File('$projectRoot/example/lib/page/$pageName').existsSync()) {
        pageFound = true;

        break;
      }

      // 再在 page/{dirName}/ 子目录找（如 sidebar）

      if (File('$projectRoot/example/lib/page/${meta.dirName}/$pageName')
          .existsSync()) {
        pageFound = true;

        break;
      }
    }

    if (!pageFound) {
      issues.add(
          '${meta.widgetName}: 缺少 example/lib/page/ 下的 page 文件 (${pageFileNames.join(' 或 ')})');
    }
  }

  addResult(
    '项A-Demo注册',
    'config.dart 注册 + V1.0 标记 + page 文件',
    issues.isEmpty,
    issues.isEmpty
        ? '${componentList.length} 个组件全部注册且标 V1.0'
        : '发现 ${issues.length} 处问题:\n${issues.join('\n')}',
  );
}

// ============================================================

// 检查 6：核心3 测试覆盖率（解析 lcov.info）

// ============================================================

void checkCoverage() {
  print('\n━━━ 核心3 测试覆盖率（≥95%） ━━━');

  final lcovFile = File('$projectRoot/coverage/lcov.info');

  if (!lcovFile.existsSync()) {
    addResult(
      '核心3-覆盖率',
      'lcov.info 存在',
      false,
      'coverage/lcov.info 不存在，请先运行: flutter test --coverage',
    );

    return;
  }

  final content = readFile(lcovFile);

  final lines = content.split('\n');

  // 解析 lcov.info: SF:文件路径 / DA:行号,命中次数 / end_of_record

  final fileCoverage = <String, _FileCov>{};

  _FileCov? current;

  for (final line in lines) {
    if (line.startsWith('SF:')) {
      final path = line.substring(3);

      current = _FileCov(path);
    } else if (line.startsWith('DA:')) {
      final parts = line.substring(3).split(',');

      if (current != null && parts.length >= 2) {
        final hitCount = int.tryParse(parts[1]) ?? 0;

        current.totalLines++;

        if (hitCount > 0) {
          current.coveredLines++;
        }
      }
    } else if (line == 'end_of_record') {
      if (current != null) {
        fileCoverage[current.path] = current;

        current = null;
      }
    }
  }

  // 按组件目录聚合覆盖率

  final componentCoverage = <String, _CompCov>{};

  for (final entry in fileCoverage.entries) {
    final path = entry.value.path;

    // 只统计 lib/src/components/ 下的文件

    if (!path.contains('lib/src/components/')) {
      continue;
    }

    // 排除数据类文件（*_theme_data.dart / *_defaults.dart / util 目录），
    // 与项目覆盖率计划（coverage_plan.md）口径一致：这类为 Theme 数据/默认值，
    // 不计入「每组件行覆盖率 ≥ 95%」要求。
    if (path.contains('_theme_data.dart') ||
        path.contains('_defaults.dart') ||
        path.contains('/util/')) {
      continue;
    }

    final parts = path.split('/');

    String? compName;

    for (var i = 0; i < parts.length; i++) {
      if (parts[i] == 'components' && i + 1 < parts.length) {
        compName = parts[i + 1];

        break;
      }
    }

    if (compName == null) {
      continue;
    }
    final compNameStr = compName;

    componentCoverage.putIfAbsent(compNameStr, () => _CompCov(compNameStr));

    componentCoverage[compName]!.totalLines += entry.value.totalLines;

    componentCoverage[compName]!.coveredLines += entry.value.coveredLines;
  }

  // 检查每个组件覆盖率 ≥ 95%

  final belowThreshold = <String>[];

  final allCovered = <String, double>{};

  for (final meta in componentList) {
    final cov = componentCoverage[meta.dirName];

    if (cov == null || cov.totalLines == 0) {
      belowThreshold.add('${meta.widgetName}: 无覆盖率数据');

      continue;
    }

    final rate = cov.coveredLines / cov.totalLines;

    allCovered[meta.widgetName] = rate;

    if (rate < 0.95) {
      belowThreshold.add(
        '${meta.widgetName}: ${(rate * 100).toStringAsFixed(1)}% (${cov.coveredLines}/${cov.totalLines})',
      );
    }
  }

  addResult(
    '核心3-覆盖率',
    '每组件行覆盖率 ≥ 95%',
    belowThreshold.isEmpty,
    belowThreshold.isEmpty
        ? '${allCovered.length} 个组件全部 ≥ 95%'
        : '${belowThreshold.length} 个组件低于 95%:\n${belowThreshold.join('\n')}',
  );
}

class _FileCov {
  final String path;

  int totalLines = 0;

  int coveredLines = 0;

  _FileCov(this.path);
}

class _CompCov {
  final String name;

  int totalLines = 0;

  int coveredLines = 0;

  _CompCov(this.name);
}

// ============================================================

// 检查 7：项E dart analyze 零 ERROR

// ============================================================

void checkAnalyze() {
  print('\n━━━ 项E dart analyze 零 ERROR ━━━');

  // 显式分析 lib/ 目录（避免 analysis_options.yaml 排除范围导致的误报）

  final result = Process.runSync(
      'dart', ['analyze', '--format', 'json', 'lib/'],
      workingDirectory: projectRoot);

  final output = result.stdout.toString();

  final stderr = result.stderr.toString();

  var errorCount = 0;

  final errors = <String>[];

  try {
    // 解析 JSON 输出中的 diagnostics 数组

    final jsonStart = output.indexOf('[');

    final jsonEnd = output.lastIndexOf(']');

    if (jsonStart >= 0 && jsonEnd > jsonStart) {
      final jsonStr = output.substring(jsonStart, jsonEnd + 1);

      // 简单解析：统计 "severity":"error" 出现次数

      final errorRegex = RegExp(r'"severity"\s*:\s*"error"');

      errorCount = errorRegex.allMatches(jsonStr).length;

      // 提取错误详情

      final lines = jsonStr.split('\n');

      for (final line in lines) {
        if (line.contains('"severity"') && line.contains('"error"')) {
          errors.add(line.trim());
        }
      }
    }
  } catch (_) {
    // JSON 解析失败，回退到文本统计

    final errorRegex = RegExp(r'error\s*-', caseSensitive: true);

    errorCount = errorRegex.allMatches(output).length;
  }

  // 进程退出码非零也视为有错误（dart analyze 发现 error 时退出码为 3）

  if (result.exitCode != 0 && errorCount == 0) {
    errorCount = stderr.isNotEmpty ? 1 : 1;

    errors.add('dart analyze 退出码 ${result.exitCode}（非零但未解析到 error）');

    if (stderr.isNotEmpty) {
      errors.add('stderr: ${stderr.substring(0, stderr.length.clamp(0, 500))}');
    }
  }

  addResult(
    '项E-analyze',
    'dart analyze 零 ERROR',
    errorCount == 0,
    errorCount == 0
        ? 'dart analyze 零 ERROR'
        : '发现 $errorCount 个 ERROR:\n${errors.take(20).join('\n')}',
  );
}

// ============================================================

// 检查 8：项E P0 Golden 存在性

// ============================================================

void checkGoldenExistence() {
  print('\n━━━ 项E P0 Golden 存在性 ━━━');

  final p0Components = componentList.where((m) => m.isP0Golden).toList();

  final issues = <String>[];

  for (final meta in p0Components) {
    // 检查 golden 测试文件存在（部分组件文件名不同）

    final goldenNames = _testFileOverrides[meta.dirName]
            ?.map((n) => n.replaceAll('_test.dart', '_golden_test.dart'))
            .toList() ??
        ['t_${meta.dirName}_golden_test.dart'];

    var goldenFound = false;

    for (final gName in goldenNames) {
      final f = File('$testComponentsPath/${meta.dirName}/$gName');

      if (f.existsSync()) {
        goldenFound = true;

        break;
      }
    }

    if (!goldenFound) {
      issues.add(
          '${meta.widgetName}: 缺少 golden 测试文件 (${goldenNames.join(' 或 ')})');

      continue;
    }

    // 检查 golden 基线图片存在

    final goldenDir = Directory('$testComponentsPath/${meta.dirName}/goldens');

    if (!goldenDir.existsSync()) {
      issues.add('${meta.widgetName}: 缺少 goldens/ 目录');

      continue;
    }

    final pngFiles = goldenDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.png'))
        .toList();

    if (pngFiles.isEmpty) {
      issues.add('${meta.widgetName}: goldens/ 目录无 .png 基线文件');
    }
  }

  addResult(
    '项E-Golden',
    'P0 组件 Golden 基线',
    issues.isEmpty,
    issues.isEmpty
        ? '${p0Components.length} 个 P0 组件（TButton/TSlider/TTabBar）均有 golden 测试 + 基线'
        : '发现 ${issues.length} 处问题:\n${issues.join('\n')}',
  );
}

// ============================================================

// 检查 9：项D API 文档一致性（参数名集合比对）

// ============================================================

void checkApiDocConsistency() {
  print('\n━━━ 项D API 文档一致性 ━━━');

  final issues = <String>[];

  var checkedCount = 0;

  for (final meta in componentList) {
    if (meta.apiFolderName == null) {
      continue;
    }

    // 查找生成的 API md 文件

    final apiFile = File('$apiOutputPath/${meta.apiFolderName}_api.md');

    if (!apiFile.existsSync()) {
      // 某些组件可能有不同命名（如 camelCase）

      final altApiFile = File('$apiOutputPath/${meta.configKey}_api.md');

      if (!altApiFile.existsSync()) {
        issues.add(
            '${meta.widgetName}: 缺少生成的 API 文档 ${meta.apiFolderName}_api.md');

        continue;
      }
    }

    checkedCount++;

    // 查找组件设计文档 md

    final docFile = File('$projectRoot/${meta.docPath}');

    if (!docFile.existsSync()) {
      issues.add('${meta.widgetName}: 缺少设计文档 ${meta.docPath}');

      continue;
    }

    // 比对参数名集合

    final apiContent = readFile(apiFile.existsSync()
        ? apiFile
        : File('$apiOutputPath/${meta.configKey}_api.md'));

    final docContent = readFile(docFile);

    // 比对参数名集合（仅提取构造器参数表，过滤枚举值和非参数条目）

    final apiParams = _extractConstructorParams(apiContent, meta.widgetName);

    final docParams = _extractSection1Params(docContent);

    if (apiParams.isEmpty || docParams.isEmpty) {
      continue;
    }

    // 找出差异（仅报告设计文档有但 API 缺失的参数，这是更关键的方向）

    final onlyInDoc = docParams.difference(apiParams);

    if (onlyInDoc.isNotEmpty) {
      issues.add(
          '${meta.widgetName}: 设计文档 §1 有参数但 API 缺失: ${onlyInDoc.join(', ')}');
    }
  }

  addResult(
    '项D-API文档一致',
    '生成 API vs 设计文档 §1 参数一致',
    issues.isEmpty,
    issues.isEmpty
        ? '$checkedCount 个组件 API 文档与 §1 参数一致'
        : '发现 ${issues.length} 处差异:\n${issues.take(30).join('\n')}',
  );
}

/// 从生成 API md 中提取构造器参数名

/// 仅提取主 Widget 构造器参数表中的参数名，过滤枚举值和静态常量

Set<String> _extractConstructorParams(String content, String widgetName) {
  final params = <String>{};

  final lines = content.split('\n');

  // 找到主 Widget 构造器参数表区域

  // 生成文档格式：## 构造器 / ### {WidgetName} 或类似标题下的表格

  var inConstructorSection = false;

  var inTable = false;

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i].trim();

    // 检测进入构造器参数表区域

    if (line.startsWith('##') &&
        (line.contains('构造器') ||
            line.contains('constructor') ||
            line.contains('Constructor'))) {
      inConstructorSection = true;

      inTable = false;

      continue;
    }

    // 检测离开构造器区域（遇到下一个 ## 标题）

    if (line.startsWith('##') && inConstructorSection) {
      inConstructorSection = false;

      inTable = false;

      continue;
    }

    if (!inConstructorSection) {
      continue;
    }

    // 检测表格开始（| 参数名 | 或 | 属性 | 等表头行）

    if (line.startsWith('|') && line.contains('参数')) {
      inTable = true;

      continue;
    }

    // 跳过分隔行 |---|---|

    if (line.startsWith('|') && line.contains('---')) {
      continue;
    }

    if (inTable && line.startsWith('|')) {
      final match = RegExp(r'^\|\s*`?(\w+)`?\s*\|').firstMatch(line);

      if (match != null) {
        final name = match.group(1)!;

        // 排除表头关键词

        if (_isHeaderKeyword(name)) {
          continue;
        }
        // 排除全大写或含下划线的枚举值（如 DEFAULT_SIZE, primary 等）

        if (name == name.toUpperCase() && name.contains('_')) {
          continue;
        }
        params.add(name);
      }
    }
  }

  // 如果没找到构造器区域，回退到通用提取

  if (params.isEmpty) {
    for (final line in lines) {
      final match = RegExp(r'^\|\s*`?(\w+)`?\s*\|').firstMatch(line.trim());

      if (match != null) {
        final name = match.group(1)!;

        if (_isHeaderKeyword(name)) {
          continue;
        }
        if (name == name.toUpperCase() && name.contains('_')) {
          continue;
        }
        // 排除明显的枚举值（全小写单词，如 primary, danger, left, right 等）

        params.add(name);
      }
    }
  }

  return params;
}

/// 判断是否为表格表头关键词

bool _isHeaderKeyword(String name) {
  return name == '参数名' ||
      name == '属性名' ||
      name == '参数' ||
      name == '属性' ||
      name == '名称' ||
      name == '类型' ||
      name == '默认值' ||
      name == '描述' ||
      name == '说明' ||
      name == '---' ||
      name == '字段' ||
      name == '值' ||
      name == '可选值' ||
      name == '必传';
}

/// 从组件设计文档 md §1 的「### 构造器」表中提取参数名。
///
/// §1 后续还会包含 icon 行为、文案、类型、export 等说明表；这些表里的
/// 枚举值或说明项不是构造器参数，不能纳入 API 一致性比对。

Set<String> _extractSection1Params(String content) {
  final params = <String>{};

  final lines = content.split('\n');

  // 找到 §1 区域

  var sectionStart = -1;

  var sectionEnd = lines.length;

  for (var i = 0; i < lines.length; i++) {
    if (RegExp(r'^##\s*1').hasMatch(lines[i]) ||
        lines[i].startsWith('## 1.') ||
        lines[i].startsWith('## 一')) {
      sectionStart = i;
    } else if (sectionStart >= 0 && RegExp(r'^##\s*2').hasMatch(lines[i])) {
      sectionEnd = i;

      break;
    }
  }

  if (sectionStart < 0) {
    return params;
  }

  // 仅进入「### 构造器」子节；遇到下一个同级/更高级标题即停止。

  var inConstructorSection = false;

  for (var i = sectionStart; i < sectionEnd; i++) {
    final line = lines[i];

    final trimmed = line.trim();

    if (trimmed.startsWith('### ')) {
      if (trimmed.contains('构造器')) {
        inConstructorSection = true;

        continue;
      }

      if (inConstructorSection) {
        break;
      }

      continue;
    }

    if (inConstructorSection && trimmed.startsWith('####')) {
      break;
    }

    if (!inConstructorSection) {
      continue;
    }

    // 匹配 markdown 表格行

    final match = RegExp(r'^\|\s*`?(\w+)`?\s*\|').firstMatch(trimmed);

    if (match != null) {
      final name = match.group(1)!;

      if (_isHeaderKeyword(name)) {
        continue;
      }
      // 过滤类型名（大写开头，如 TButtonSize, TLinkVariant）—— 这些不是构造器参数

      if (name[0].toUpperCase() == name[0] && name.length > 1) {
        continue;
      }
      params.add(name);
    }
  }

  return params;
}

// ============================================================

// 检查 10：核心4 文档注释（export 符号有 /// 注释）

// ============================================================

void checkDocComments() {
  print('\n━━━ 核心4 文档注释 ━━━');

  final issues = <String>[];

  for (final meta in componentList) {
    final compDir = '$libSrcPath/${meta.dirName}';

    final mainFile = File('$compDir/t_${meta.dirName}.dart');

    if (!mainFile.existsSync()) {
      continue;
    }

    final content = readFile(mainFile);

    final lines = content.split('\n');

    // 检查主 Widget 类是否有 /// 注释

    var foundClass = false;

    var hasDocComment = false;

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];

      if (RegExp(r'^class\s+${meta.widgetName}\b').hasMatch(line)) {
        foundClass = true;

        // 检查前一行是否有 ///

        if (i > 0 && lines[i - 1].trim().startsWith('///')) {
          hasDocComment = true;
        }

        break;
      }
    }

    if (foundClass && !hasDocComment) {
      issues.add('${meta.widgetName}: 类定义上方缺少 /// 中文注释');
    }
  }

  addResult(
    '核心4-文档注释',
    '主 Widget 类有 /// 中文注释',
    issues.isEmpty,
    issues.isEmpty
        ? '${componentList.length} 个组件主 Widget 均有 /// 注释'
        : '发现 ${issues.length} 处缺失:\n${issues.join('\n')}',
  );
}

// ============================================================

// 检查 11：测试文件存在性

// ============================================================

void checkTestFiles() {
  print('\n━━━ 测试文件存在性 ━━━');

  final issues = <String>[];

  for (final meta in componentList) {
    final testFileNames =
        _testFileOverrides[meta.dirName] ?? ['t_${meta.dirName}_test.dart'];

    var testFound = false;

    for (final testName in testFileNames) {
      // 先在 test/components/{dir}/ 找

      if (File('$testComponentsPath/${meta.dirName}/$testName').existsSync()) {
        testFound = true;

        break;
      }

      // 再在 test/ 根目录找（部分组件测试在根目录）

      if (File('$projectRoot/test/$testName').existsSync()) {
        testFound = true;

        break;
      }
    }

    if (!testFound) {
      issues.add('${meta.widgetName}: 缺少测试文件 (${testFileNames.join(' 或 ')})');
    }
  }

  addResult(
    '测试-文件存在',
    '每组件有测试文件',
    issues.isEmpty,
    issues.isEmpty
        ? '${componentList.length} 个组件均有测试文件'
        : '缺少 ${issues.length} 个测试文件:\n${issues.join('\n')}',
  );
}

// ============================================================

// 报告生成

// ============================================================

String generateReport() {
  final buf = StringBuffer();

  buf.writeln('# TDesign Flutter V1.0 组件自动化验收报告');

  buf.writeln();

  buf.writeln('> 生成时间: ${DateTime.now().toIso8601String()}');

  buf.writeln(
      '> 验收标准: [component-acceptance-standard.md](../../docs/v1.0/guide/component-acceptance-standard.md)');

  buf.writeln('> 组件总数: ${componentList.length}');

  buf.writeln();

  // 汇总表

  final totalChecks = results.length;

  final passedChecks = results.where((r) => r.passed).length;

  final failedChecks = totalChecks - passedChecks;

  final passRate = totalChecks > 0
      ? (passedChecks / totalChecks * 100).toStringAsFixed(1)
      : '0.0';

  buf.writeln('## 汇总');

  buf.writeln();

  buf.writeln('| 指标 | 值 |');

  buf.writeln('|------|----|');

  buf.writeln('| 检查项总数 | $totalChecks |');

  buf.writeln('| 通过 | $passedChecks |');

  buf.writeln('| 失败 | $failedChecks |');

  buf.writeln('| 通过率 | $passRate% |');

  buf.writeln('| 总体结论 | ${failedChecks == 0 ? "✅ **全部通过**" : "❌ **有未通过项**"} |');

  buf.writeln();

  // 按分类分组

  final categories = <String>{};

  for (final r in results) {
    categories.add(r.category);
  }

  buf.writeln('## 详细结果');

  buf.writeln();

  for (final cat in categories) {
    final catResults = results.where((r) => r.category == cat).toList();

    buf.writeln('### $cat');

    buf.writeln();

    buf.writeln('| 检查项 | 结果 | 明细 |');

    buf.writeln('|--------|------|------|');

    for (final r in catResults) {
      final icon = r.passed ? '✅' : '❌';

      final detail = r.detail.replaceAll('|', '\\|').replaceAll('\n', '<br>');

      buf.writeln('| ${r.name} | $icon | $detail |');
    }

    buf.writeln();
  }

  // 验收标准映射表

  buf.writeln('## 验收标准映射');

  buf.writeln();

  buf.writeln('| 验收文档条目 | 对应检查项 | 结果 |');

  buf.writeln('|-------------|-----------|------|');

  buf.writeln(
      '| **核心1** API 实现 + 样式不回退 | 档1 静态核查 + 项F resolve 单入口 | ${_mapResult([
        '档1-静态核查',
        '项F-resolve单入口'
      ])} |');

  buf.writeln(
      '| **核心2** Theme 覆盖（两层注入 + 优先级） | 档1 静态核查 + 档2 Widget 测试 | ${_mapResult([
        '档1-静态核查'
      ])} |');

  buf.writeln('| **核心3** 测试覆盖率 ≥ 95% | 覆盖率解析 | ${_mapResult(['核心3-覆盖率'])} |');

  buf.writeln('| **核心4** 文档注释 | /// 注释检查 | ${_mapResult(['核心4-文档注释'])} |');

  buf.writeln('| **项A** Demo 注册 | config.dart + page 文件 | ${_mapResult([
        '项A-Demo注册'
      ])} |');

  buf.writeln(
      '| **项B** 禁用写法 | A/B/C 类不暴露 disabled | ${_mapResult(['项B-禁用写法'])} |');

  buf.writeln('| **项C** export 收敛 | *Style 不 export | ${_mapResult([
        '项C-export收敛'
      ])} |');

  buf.writeln(
      '| **项D** API 文档一致 | 生成 API vs §1 | ${_mapResult(['项D-API文档一致'])} |');

  buf.writeln(
      '| **项E** CI 双端 + Golden | analyze + Golden + 测试文件 | ${_mapResult([
        '项E-analyze',
        '项E-Golden',
        '测试-文件存在'
      ])} |');

  buf.writeln('| **项F** resolve 单入口 | build 无内联色值 | ${_mapResult([
        '项F-resolve单入口'
      ])} |');

  buf.writeln('| **项G** Web 验收 | flutter build web（在 example/ 下执行） | 见 CI |');

  buf.writeln();

  buf.writeln('## 说明');

  buf.writeln();

  buf.writeln('- **项G（Web 验收）** 和 **双端真机验证** 需在 CI 中执行，本脚本不覆盖。');

  buf.writeln(
      '- **档2 Widget 测试**（Token 读取 + 优先级覆盖）见 `test/acceptance/theme_acceptance_test.dart`。');

  buf.writeln('- **档3 真机/Web 目测** 需人工执行，不在自动化范围内。');

  return buf.toString();
}

String _mapResult(List<String> categories) {
  final relevant = results.where((r) => categories.contains(r.category));

  if (relevant.isEmpty) {
    return '⏳ 未执行';
  }
  final allPassed = relevant.every((r) => r.passed);

  return allPassed ? '✅ 通过' : '❌ 未通过';
}

// ============================================================

// 主入口

// ============================================================

void main(List<String> args) {
  final skipTests = args.contains('--skip-tests');

  final skipBuild = args.contains('--skip-build');

  // 解析项目根目录（脚本位于 scripts/acceptance/ 下）

  final scriptPath = Platform.script.toFilePath();

  projectRoot = scriptPath
      .replaceAll('\\', '/')
      .replaceFirst('/scripts/acceptance/acceptance_check.dart', '')
      .replaceAll('//', '/');

  print('╔══════════════════════════════════════════════════════╗');

  print('║   TDesign Flutter V1.0 组件自动化验收引擎            ║');

  print('╚══════════════════════════════════════════════════════╝');

  print('项目根目录: $projectRoot');

  print('组件总数: ${componentList.length}');

  print('参数: --skip-tests=$skipTests --skip-build=$skipBuild');

  // 执行所有检查

  checkStaticGrep();

  checkExportConvergence();

  checkResolveSingleEntry();

  checkDisabledConvention();

  checkDemoRegistration();

  checkDocComments();

  checkTestFiles();

  if (!skipTests) {
    checkCoverage();

    checkAnalyze();
  } else {
    print('\n⏭️  已跳过测试相关检查（--skip-tests）');
  }

  checkGoldenExistence();

  checkApiDocConsistency();

  // 生成报告

  final report = generateReport();

  final reportFile =
      File('$projectRoot/scripts/acceptance/acceptance-report.md');

  reportFile.writeAsStringSync(report);

  print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

  print('验收报告已生成: ${relPath(reportFile.path)}');

  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

  // 打印汇总

  final total = results.length;

  final passed = results.where((r) => r.passed).length;

  final failed = total - passed;

  print('总计: $total 项 | ✅ $passed 通过 | ❌ $failed 失败');

  // 退出码：有失败项则返回 1

  exit(failed > 0 ? 1 : 0);
}

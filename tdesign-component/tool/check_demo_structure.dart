import 'dart:convert';
import 'dart:io';

final _pageDirectory = Directory('example/lib/page');
final _configFile = File('example/lib/config.dart');
final _codeDirectory = Directory('example/assets/code');
final _manifestFile = File('example/assets/code/manifest.json');

String _normalizeName(String value) =>
    value.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').toLowerCase();

void main() {
  final errors = <String>[];
  final entries = <File>[];
  final annotatedExamples = <File>[];

  for (final entity in _pageDirectory.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) {
      continue;
    }

    final relativePath = entity.path.substring(
      '${_pageDirectory.path}/'.length,
    );
    final segments = relativePath.split(Platform.pathSeparator);
    final fileName = segments.last;
    final source = entity.readAsStringSync();
    final exampleAnnotations = RegExp(
      r'^@ExampleCode\(',
      multiLine: true,
    ).allMatches(source).length;
    if (exampleAnnotations > 0) {
      annotatedExamples.add(entity);
      if (exampleAnnotations != 1) {
        errors.add('公开示例文件必须且只能声明一个 @ExampleCode：$relativePath');
      }
      if (!fileName.endsWith('_example.dart')) {
        errors.add('公开示例文件必须以 _example.dart 结尾：$relativePath');
      }
    }

    if (segments.length == 1 &&
        RegExp(r'^t_.+_page\.dart$').hasMatch(segments.single)) {
      errors.add('页面入口仍平铺在 page 根目录：$relativePath');
    }
    if (RegExp(r'^\s*part(?:\s+of)?\s+', multiLine: true).hasMatch(source)) {
      errors.add('仍使用 part/part of 拆分 Demo：$relativePath');
    }

    if (segments.length != 2) {
      continue;
    }
    final component = segments.first;
    final isEntry = fileName == '${component}_page.dart';
    if (isEntry) {
      entries.add(entity);
      if (!source.contains('@ExampleCodeManifest()')) {
        errors.add('页面入口缺少 @ExampleCodeManifest：$relativePath');
      }
      continue;
    }

    if (exampleAnnotations > 0) {
      final classMatch = RegExp(
        r'@ExampleCode\([\s\S]*?\)\s*class\s+(\w+)',
      ).firstMatch(source);
      final className = classMatch?.group(1);
      if (className == null ||
          !_normalizeName(className).contains(_normalizeName(component))) {
        errors.add(
          '公开示例类名必须包含组件语义：$relativePath'
          '${className == null ? '' : ' ($className)'}',
        );
      }
    }

    final declaresModuleGetter = source.contains('ExampleModule get ');
    final declaresModuleFunction = RegExp(
      r'ExampleModule\s+\w+\s*\(\s*\)',
    ).hasMatch(source);
    if (declaresModuleGetter || declaresModuleFunction) {
      errors.add('分组元数据仍散落在独立文件：$relativePath');
    }
  }

  if (entries.length != 60) {
    errors.add('应包含 57 个组件入口和 3 个额外基础入口，共 60 个；实际 ${entries.length} 个');
  }

  final config = _configFile.readAsStringSync();
  final imports = RegExp(r"import 'page/([^/]+)/([^']+)';")
      .allMatches(config)
      .map((match) => (component: match.group(1)!, fileName: match.group(2)!));
  for (final import in imports) {
    final file = File(
      '${_pageDirectory.path}/${import.component}/${import.fileName}',
    );
    if (!file.existsSync()) {
      errors.add('config.dart 引用了不存在的 Demo 文件：${file.path}');
    }
  }

  for (final path in [
    'example/lib/lunar_data_source_example.dart',
    'example/lib/lunar_info.dart',
  ]) {
    if (File(path).existsSync()) {
      errors.add('Calendar 辅助 example 尚未迁入组件目录：$path');
    }
  }

  var registeredAssetCount = 0;
  if (!_manifestFile.existsSync()) {
    errors.add('缺少代码映射清单：${_manifestFile.path}');
  } else {
    final manifest =
        jsonDecode(_manifestFile.readAsStringSync()) as Map<String, dynamic>;
    final groups = manifest['groups'] as Map<String, dynamic>? ?? const {};
    final legacyGroups = manifest['legacyGroups'] as List<dynamic>? ?? const [];
    if (groups.length != entries.length) {
      errors.add('代码映射清单应包含 ${entries.length} 个页面；实际 ${groups.length} 个');
    }
    if (legacyGroups.isNotEmpty) {
      errors.add('代码映射清单仍包含旧解析页面：${legacyGroups.join(', ')}');
    }

    final registeredAssets = <String>{};
    for (final modules in groups.values.cast<List<dynamic>>()) {
      for (final module in modules.cast<Map<String, dynamic>>()) {
        final items = module['items'] as List<dynamic>? ?? const [];
        for (final item in items.cast<Map<String, dynamic>>()) {
          final assetKey = item['assetKey'] as String?;
          if (assetKey == null || assetKey.isEmpty) {
            errors.add('代码映射清单存在缺少 assetKey 的公开示例');
          } else if (!registeredAssets.add(assetKey)) {
            errors.add('代码映射清单存在重复 assetKey：$assetKey');
          }
        }
      }
    }
    registeredAssetCount = registeredAssets.length;
    if (annotatedExamples.length != registeredAssetCount) {
      errors.add(
        '公开示例应一项一文件：清单 $registeredAssetCount 项，'
        '独立 @ExampleCode 文件 ${annotatedExamples.length} 个',
      );
    }

    final generatedAssets = <String>{};
    for (final entity in _codeDirectory.listSync()) {
      if (entity is! File || !entity.path.endsWith('.txt')) {
        continue;
      }
      final assetKey = entity.uri.pathSegments.last.replaceFirst('.txt', '');
      generatedAssets.add(assetKey);
      final source = entity.readAsStringSync();
      for (final line in const LineSplitter().convert(source)) {
        final trimmed = line.trimLeft();
        if (trimmed.startsWith("import '") &&
            !trimmed.startsWith("import 'dart:") &&
            !trimmed.startsWith("import 'package:")) {
          errors.add('生成代码仍依赖本地相对导入：$assetKey');
          break;
        }
      }
      for (final infrastructure in [
        'CodeWrapper',
        'ExamplePageModel',
        'ExamplePageInheritedTheme',
      ]) {
        if (source.contains(infrastructure)) {
          errors.add('生成代码仍依赖 Demo 容器 $infrastructure：$assetKey');
        }
      }
    }

    for (final missing in registeredAssets.difference(generatedAssets)) {
      errors.add('公开示例缺少生成代码：$missing');
    }
    for (final unregistered in generatedAssets.difference(registeredAssets)) {
      errors.add('生成代码未被公开示例引用：$unregistered');
    }
  }

  if (errors.isNotEmpty) {
    stderr.writeln('Demo 目录结构检查失败：');
    for (final error in errors) {
      stderr.writeln('- $error');
    }
    exitCode = 1;
    return;
  }

  stdout.writeln(
    'Demo 目录结构检查通过：${entries.length} 个入口、0 个旧分组文件、'
    '$registeredAssetCount 个公开 ExampleItem 均一对一映射到完整代码资产。',
  );
}

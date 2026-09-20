import 'dart:io';

final _pageDirectory = Directory('example/lib/page');
final _configFile = File('example/lib/config.dart');

void main() {
  final errors = <String>[];
  final entries = <File>[];
  final modules = <File>[];

  for (final entity in _pageDirectory.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) {
      continue;
    }
    final relativePath = entity.path.substring(
      '${_pageDirectory.path}/'.length,
    );
    final segments = relativePath.split(Platform.pathSeparator);
    if (segments.length == 1 &&
        RegExp(r'^t_.+_page\.dart$').hasMatch(segments.single)) {
      errors.add('页面入口仍平铺在 page 根目录：$relativePath');
      continue;
    }
    if (segments.length != 2) {
      continue;
    }

    final component = segments.first;
    final fileName = segments.last;
    final source = entity.readAsStringSync();
    if (fileName == '${component}_page.dart') {
      entries.add(entity);
      if (source.contains('ExampleModule(')) {
        errors.add('入口文件内仍直接声明 ExampleModule：$relativePath');
      }
    }
    final declaresModuleGetter = source.contains('ExampleModule get ');
    final declaresModuleFunction = RegExp(
      r'ExampleModule\s+\w+\s*\(\s*\)',
    ).hasMatch(source);
    if (declaresModuleGetter || declaresModuleFunction) {
      modules.add(entity);
      if (declaresModuleGetter &&
          !source.contains("part of '${component}_page.dart';")) {
        errors.add('模块文件未归属于语义入口：$relativePath');
      }
      if (fileName.contains('module_')) {
        errors.add('模块文件名不是业务语义：$relativePath');
      }
    }
  }

  if (entries.length != 60) {
    errors.add('应包含 57 个组件入口和 3 个额外基础入口，共 60 个；实际 ${entries.length} 个');
  }
  if (modules.length != 143) {
    errors.add('应包含 143 个按 ExampleModule 拆分的模块文件；实际 ${modules.length} 个');
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

  if (errors.isNotEmpty) {
    stderr.writeln('Demo 目录结构检查失败：');
    for (final error in errors) {
      stderr.writeln('- $error');
    }
    exitCode = 1;
    return;
  }

  stdout.writeln(
    'Demo 目录结构检查通过：${entries.length} 个入口、${modules.length} 个模块，辅助 example 已归位。',
  );
}

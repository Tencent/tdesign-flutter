import 'dart:convert';
import 'dart:io';

import 'package:tdesign_flutter_tools/model.dart';
import 'package:tdesign_flutter_tools/smart_create.dart';

/// 内部批处理入口：仅适配参数，解析和 Markdown 生成继续使用原工具。
Future<void> main() async {
  final tasks = jsonDecode(await stdin.transform(utf8.decoder).join()) as List;
  for (final raw in tasks) {
    final task = raw as Map<String, dynamic>;
    final slug = task['slug'] as String;
    final source = task['sourcePath'] as String;
    final isFile = task['sourceType'] == 'file';
    final names = (task['names'] as List).cast<String>();
    final output = task['output'] as String;
    final command = CommandInfo()
      ..file = isFile ? source : null
      ..folder = isFile ? null : source
      ..widgetNames = names.join(',')
      ..folderName = slug
      ..output = output
      ..isOnlyApi = true
      ..strictNames = true
      ..isGetComments = task['getComments'] as bool;
    try {
      // 每个组件使用新实例并等待完成，保持清单顺序及首个错误中止。
      await SmartCreator(
        isFileMode: isFile,
        onlyApi: true,
        nameList: names,
        basePath: '${Directory.current.path}/',
        path: source,
        output: output,
        commandInfo: command,
        folderName: slug,
      ).run();
    } catch (error) {
      stderr.writeln('$slug: API generation failed: $error');
      exitCode = 1;
      return;
    }
  }
}

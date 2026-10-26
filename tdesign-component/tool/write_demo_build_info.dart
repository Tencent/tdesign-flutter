import 'dart:io';

/// 写入本次构建的版本与时间；时间由构建流程提供，不随应用打开而变化。
void writeDemoBuildInfo({
  required Directory componentDirectory,
  required DateTime builtAt,
}) {
  final pubspec = File(
    '${componentDirectory.path}/pubspec.yaml',
  ).readAsStringSync();
  final version = RegExp(
    r'^version:\s*(\S+)',
    multiLine: true,
  ).firstMatch(pubspec)?.group(1);
  if (version == null) {
    throw const FormatException('Missing component version');
  }
  final assets = Directory('${componentDirectory.path}/example/assets')
    ..createSync(recursive: true);
  File('${assets.path}/version').writeAsStringSync('$version\n');
  File(
    '${assets.path}/publish_time',
  ).writeAsStringSync('${builtAt.toUtc().millisecondsSinceEpoch}\n');
}

void main() {
  writeDemoBuildInfo(
    componentDirectory: File.fromUri(Platform.script).parent.parent,
    builtAt: DateTime.now(),
  );
}

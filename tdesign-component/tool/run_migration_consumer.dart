import 'dart:io';

/// Runs migration examples with an independent package configuration outside
/// the checkout, so tests cannot accidentally rely on library-private imports.
Future<void> main() async {
  final component = File.fromUri(Platform.script).parent.parent;
  final fixture = Directory('${component.path}/tool/fixtures/token_migration');
  final consumer = await Directory.systemTemp.createTemp('tdesign-migration-');
  try {
    await for (final entity in fixture.list(recursive: true)) {
      if (entity is! File) {
        continue;
      }
      final relative = entity.path.substring(fixture.path.length + 1);
      final target = File('${consumer.path}/$relative');
      await target.parent.create(recursive: true);
      if (relative == 'pubspec.yaml') {
        final source = await entity.readAsString();
        final path = component.absolute.path.replaceAll("'", "''");
        await target.writeAsString(source.replaceFirst('../../../', path));
      } else {
        await entity.copy(target.path);
      }
    }
    for (final arguments in [
      ['pub', 'get'],
      ['analyze', '--no-pub', '--fatal-infos'],
      ['test', '--no-pub'],
    ]) {
      stdout.writeln('Migration consumer: flutter ${arguments.join(' ')}');
      final process = await Process.start(
        'flutter',
        arguments,
        workingDirectory: consumer.path,
        mode: ProcessStartMode.inheritStdio,
      );
      final result = await process.exitCode;
      if (result != 0) {
        exitCode = result;
        return;
      }
    }
  } finally {
    await consumer.delete(recursive: true);
  }
}

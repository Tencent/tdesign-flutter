import 'dart:io';

/// Runs migration examples with an independent package configuration outside
/// the checkout, so tests cannot accidentally rely on library-private imports.
Future<void> main() async {
  final sourceProject = File.fromUri(Platform.script).parent;
  final root = sourceProject.parent.parent;
  final component = Directory('${root.path}/tdesign-component');
  final consumer = await Directory.systemTemp.createTemp('tdesign-migration-');
  try {
    await for (final entity in sourceProject.list(recursive: true)) {
      if (entity is! File) {
        continue;
      }
      final relative = entity.path.substring(sourceProject.path.length + 1);
      if (relative != 'pubspec.yaml' &&
          relative != 'analysis_options.yaml' &&
          !relative.startsWith('lib/') &&
          !relative.startsWith('test/')) {
        continue;
      }
      final target = File('${consumer.path}/$relative');
      await target.parent.create(recursive: true);
      if (relative == 'pubspec.yaml') {
        final source = await entity.readAsString();
        final path = component.absolute.path.replaceAll("'", "''");
        await target.writeAsString(
          source.replaceFirst('../../tdesign-component', path),
        );
      } else {
        await entity.copy(target.path);
      }
    }
    // Validate the exact source used to generate the migration guide.
    await File(
      '${component.path}/example/lib/migration_examples.dart',
    ).copy('${consumer.path}/lib/migration_examples.dart');
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

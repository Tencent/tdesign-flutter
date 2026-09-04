import 'dart:io';

import 'component_test_manifest.dart';

Future<int> runExampleRegression() async {
  final testFiles = [
    ...sharedExampleTests,
    for (final component in componentTestManifests) ...component.exampleTests,
  ];
  final process = await Process.start(
    'flutter',
    ['test', '--no-pub', '--exclude-tags', 'golden', ...testFiles],
    workingDirectory: 'example',
    mode: ProcessStartMode.inheritStdio,
  );
  return process.exitCode;
}

Future<void> main() async {
  exitCode = await runExampleRegression();
}

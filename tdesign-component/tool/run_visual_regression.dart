import 'dart:io';

import 'component_test_manifest.dart';

class VisualTestSuite {
  const VisualTestSuite(this.component, this.manifest);

  final String component;
  final VisualTestManifest manifest;

  String get name => manifest.name;
  String get workingDirectory => manifest.workingDirectory;
  List<String> get testFiles => manifest.testFiles;
  List<String> get arguments => manifest.arguments;
}

final visualTestSuites = [
  for (final component in componentTestManifests)
    for (final visualTest in component.visualTests)
      VisualTestSuite(component.name, visualTest),
];

Future<int> runVisualRegression() async {
  final failedSuites = <String>[];

  for (final suite in visualTestSuites) {
    stdout.writeln('\n=== ${suite.name} ===');
    final process = await Process.start(
      'flutter',
      ['test', ...suite.testFiles, '--no-pub', ...suite.arguments],
      workingDirectory: suite.workingDirectory,
      mode: ProcessStartMode.inheritStdio,
    );
    if (await process.exitCode != 0) {
      failedSuites.add(suite.name);
    }
  }

  if (failedSuites.isNotEmpty) {
    stderr.writeln('\nVisual regression failed: ${failedSuites.join(', ')}');
    return 1;
  }

  stdout.writeln('\nAll visual regression suites passed.');
  return 0;
}

Future<void> main() async {
  exitCode = await runVisualRegression();
}

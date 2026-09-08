import 'dart:io';

import 'check_component_coverage.dart' as coverage;
import 'component_test_manifest.dart';

const componentTestSuites = componentTestManifests;

Future<int> runComponentRegression() async {
  final failedComponents = <String>[];

  for (final suite in componentTestSuites) {
    stdout.writeln('\n=== ${suite.name} component regression ===');
    final process = await Process.start('flutter', [
      'test',
      ...suite.componentTests,
      '--no-pub',
      '--exclude-tags',
      'demo',
      '--coverage',
    ], mode: ProcessStartMode.inheritStdio);
    final testExitCode = await process.exitCode;
    if (testExitCode != 0) {
      failedComponents.add(suite.name);
      continue;
    }

    final coverageExitCode = coverage.run([suite.name]);
    if (coverageExitCode != 0) {
      failedComponents.add(suite.name);
    }
  }

  if (failedComponents.isNotEmpty) {
    stderr.writeln(
      '\nComponent regression failed: ${failedComponents.join(', ')}',
    );
    return 1;
  }

  stdout.writeln('\nAll component regression suites passed.');
  return 0;
}

Future<void> main() async {
  exitCode = await runComponentRegression();
}

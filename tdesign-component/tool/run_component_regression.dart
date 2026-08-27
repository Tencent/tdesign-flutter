import 'dart:io';

import 'check_component_coverage.dart' as coverage;

class ComponentTestSuite {
  const ComponentTestSuite(this.component, this.testFiles);

  final String component;
  final List<String> testFiles;
}

const componentTestSuites = <ComponentTestSuite>[
  ComponentTestSuite('refresh', [
    'test/components/refresh/t_refresh_test.dart',
  ]),
  ComponentTestSuite('switch', [
    'test/components/switch/t_switch_test.dart',
    'test/components/switch/t_cupertino_switch_test.dart',
  ]),
  ComponentTestSuite('upload', ['test/components/upload/t_upload_test.dart']),
  ComponentTestSuite('form', ['test/components/form/t_form_test.dart']),
  ComponentTestSuite('input', [
    'test/components/input/t_input_test.dart',
    'test/components/input/t_input_theme_test.dart',
  ]),
  ComponentTestSuite('textarea', [
    'test/components/textarea/t_textarea_test.dart',
  ]),
];

Future<int> runComponentRegression() async {
  final failedComponents = <String>[];

  for (final suite in componentTestSuites) {
    stdout.writeln('\n=== ${suite.component} component regression ===');
    final process = await Process.start('flutter', [
      'test',
      ...suite.testFiles,
      '--no-pub',
      '--exclude-tags',
      'demo',
      '--coverage',
    ], mode: ProcessStartMode.inheritStdio);
    final testExitCode = await process.exitCode;
    if (testExitCode != 0) {
      failedComponents.add(suite.component);
      continue;
    }

    final coverageExitCode = coverage.run([suite.component]);
    if (coverageExitCode != 0) {
      failedComponents.add(suite.component);
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

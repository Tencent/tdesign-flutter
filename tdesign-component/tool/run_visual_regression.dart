import 'dart:io';

class VisualTestSuite {
  const VisualTestSuite(
    this.name, {
    required this.workingDirectory,
    required this.testFiles,
    this.arguments = const [],
  });

  final String name;
  final String workingDirectory;
  final List<String> testFiles;
  final List<String> arguments;
}

const visualTestSuites = <VisualTestSuite>[
  VisualTestSuite(
    'Refresh Demo structure',
    workingDirectory: '.',
    testFiles: ['test/components/refresh/t_refresh_test.dart'],
    arguments: ['--tags', 'demo'],
  ),
  VisualTestSuite(
    'Refresh golden',
    workingDirectory: '.',
    testFiles: ['test/components/refresh/t_refresh_golden_test.dart'],
  ),
  VisualTestSuite(
    'Upload golden',
    workingDirectory: '.',
    testFiles: ['test/components/upload/t_upload_golden_test.dart'],
  ),
  VisualTestSuite(
    'Form Input Textarea page golden',
    workingDirectory: 'example',
    testFiles: ['test/form_input_textarea_page_golden_test.dart'],
  ),
  VisualTestSuite(
    'Switch page and golden',
    workingDirectory: 'example',
    testFiles: ['test/switch_page_test.dart'],
  ),
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

import 'dart:io';

class VisualTestSuite {
  const VisualTestSuite(
    this.component,
    this.name, {
    required this.workingDirectory,
    required this.testFiles,
    this.arguments = const [],
  });

  final String component;
  final String name;
  final String workingDirectory;
  final List<String> testFiles;
  final List<String> arguments;
}

const visualTestSuites = <VisualTestSuite>[
  VisualTestSuite(
    'button',
    'Button Demo',
    workingDirectory: 'example',
    testFiles: ['test/button_demo_test.dart'],
  ),
  VisualTestSuite(
    'checkbox',
    'Checkbox Demo',
    workingDirectory: 'example',
    testFiles: ['test/checkbox_page_test.dart'],
  ),
  VisualTestSuite(
    'divider',
    'Divider Demo',
    workingDirectory: 'example',
    testFiles: ['test/divider_demo_test.dart'],
  ),
  VisualTestSuite(
    'fab',
    'Fab Demo',
    workingDirectory: 'example',
    testFiles: ['test/fab_demo_test.dart'],
  ),
  VisualTestSuite(
    'icon',
    'Icon Demo',
    workingDirectory: 'example',
    testFiles: ['test/icon_demo_test.dart'],
  ),
  VisualTestSuite(
    'link',
    'Link Demo',
    workingDirectory: 'example',
    testFiles: ['test/link_demo_test.dart'],
  ),
  VisualTestSuite(
    'notice_bar',
    'NoticeBar Demo',
    workingDirectory: 'example',
    testFiles: ['test/notice_bar_page_golden_test.dart'],
  ),
  VisualTestSuite(
    'popup',
    'Popup Demo',
    workingDirectory: 'example',
    testFiles: ['test/popup_demo_golden_test.dart'],
  ),
  VisualTestSuite(
    'text',
    'Text Demo',
    workingDirectory: 'example',
    testFiles: ['test/text_demo_test.dart'],
  ),
  VisualTestSuite(
    'form',
    'Form Demo',
    workingDirectory: 'example',
    testFiles: ['test/form_demo_test.dart'],
  ),
  VisualTestSuite(
    'input',
    'Input Demo',
    workingDirectory: 'example',
    testFiles: ['test/input_demo_test.dart'],
  ),
  VisualTestSuite(
    'radio',
    'Radio Demo',
    workingDirectory: 'example',
    testFiles: ['test/radio_page_golden_test.dart'],
  ),
  VisualTestSuite(
    'search',
    'Search Demo',
    workingDirectory: 'example',
    testFiles: ['test/search_demo_test.dart'],
  ),
  VisualTestSuite(
    'switch',
    'Switch Demo',
    workingDirectory: 'example',
    testFiles: ['test/switch_demo_test.dart'],
  ),
  VisualTestSuite(
    'textarea',
    'Textarea Demo',
    workingDirectory: 'example',
    testFiles: ['test/textarea_demo_test.dart'],
  ),
  VisualTestSuite(
    'upload',
    'Upload Demo',
    workingDirectory: 'example',
    testFiles: ['test/upload_demo_test.dart'],
  ),
  VisualTestSuite(
    'refresh',
    'PullDownRefresh Demo',
    workingDirectory: 'example',
    testFiles: ['test/pull_down_refresh_demo_test.dart'],
  ),
  VisualTestSuite(
    'rate',
    'Rate Demo',
    workingDirectory: 'example',
    testFiles: ['test/rate_demo_golden_test.dart'],
  ),
  VisualTestSuite(
    'toast',
    'Toast Demo',
    workingDirectory: 'example',
    testFiles: ['test/toast_demo_test.dart'],
  ),
  VisualTestSuite(
    'swipe_cell',
    'SwipeCell Demo',
    workingDirectory: 'example',
    testFiles: ['test/swipe_cell_demo_test.dart'],
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

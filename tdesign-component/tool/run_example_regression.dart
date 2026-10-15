import 'dart:io';

import 'component_test_manifest.dart';

List<List<String>> exampleRegressionArguments(List<String> testFiles) => [
  [
    'test',
    '--no-pub',
    '--exclude-tags',
    'golden',
    '--dart-define=TDESIGN_DEMO_TEST_MODULES=false',
    ...testFiles,
  ],
  // 公开示例与内部调试开关分别验证，避免内部示例污染组件数量及代码入口断言。
  ['test', '--no-pub', '--tags', 'internal-demo', 'test/widget_test.dart'],
];

Future<int> runExampleRegression() async {
  final testFiles = [
    ...sharedExampleTests,
    for (final component in componentTestManifests) ...component.exampleTests,
  ];
  for (final arguments in exampleRegressionArguments(testFiles)) {
    final process = await Process.start(
      'flutter',
      arguments,
      workingDirectory: 'example',
      mode: ProcessStartMode.inheritStdio,
    );
    final result = await process.exitCode;
    if (result != 0) {
      return result;
    }
  }
  return 0;
}

Future<void> main() async {
  exitCode = await runExampleRegression();
}

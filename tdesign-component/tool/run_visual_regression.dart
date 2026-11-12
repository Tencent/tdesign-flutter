import 'dart:io';

import 'component_test_manifest.dart';
import 'regression_sharding.dart';

class VisualTestSuite {
  const VisualTestSuite(this.component, this.manifest);

  final String component;
  final VisualTestManifest manifest;

  String get name => manifest.name;
  String get workingDirectory => manifest.workingDirectory;
  List<String> get testFiles => manifest.testFiles;
  List<String> get arguments => manifest.arguments;
  VisualTestKind get kind => manifest.kind;

  String get executionKey =>
      [workingDirectory, ...testFiles, '--', ...arguments].join('\u0000');
}

final visualTestSuites = [
  for (final component in componentTestManifests)
    for (final visualTest in component.visualTests)
      VisualTestSuite(component.name, visualTest),
];

/// 先全局去重，共享套件归首个声明组件，再按组件整体分组。
List<VisualTestSuite> visualSuitesForShard(
  int? shard, {
  Iterable<VisualTestSuite>? suites,
}) {
  if (shard != null && shard != 1 && shard != 2) {
    throw ArgumentError.value(shard, 'shard', 'Expected 1 or 2.');
  }
  final unique = <String, VisualTestSuite>{};
  for (final suite in suites ?? visualTestSuites) {
    unique.putIfAbsent(suite.executionKey, () => suite);
  }
  if (shard == null) {
    return unique.values.toList();
  }
  return unique.values
      .where((suite) => regressionShardForComponent(suite.component) == shard)
      .toList();
}

List<String> visualTestArguments(
  VisualTestSuite suite, {
  bool updateGoldens = false,
}) => [
  'test',
  ...suite.testFiles,
  '--no-pub',
  if (suite.kind == VisualTestKind.demo)
    '--dart-define=TDESIGN_DEMO_TEST_MODULES=false',
  ...suite.arguments,
  if (updateGoldens) '--update-goldens',
];

Future<int> runVisualRegression({
  bool updateGoldens = false,
  int? shard,
}) async {
  final failedSuites = <String>[];

  for (final suite in visualSuitesForShard(shard)) {
    stdout.writeln('\n=== ${suite.name} ===');
    final process = await Process.start(
      'flutter',
      visualTestArguments(suite, updateGoldens: updateGoldens),
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

Future<void> main(List<String> arguments) async {
  final int? shard;
  try {
    shard = parseRegressionShard(
      arguments.where((argument) => argument != '--update-goldens').toList(),
    );
  } on FormatException {
    stderr.writeln(
      'Usage: dart run tool/run_visual_regression.dart [--shard=1|--shard=2] [--update-goldens]',
    );
    exitCode = 64;
    return;
  }
  final updateGoldens = arguments.contains('--update-goldens');
  if (updateGoldens) {
    stdout.writeln(
      'Golden update mode enabled; use only in Linux Flutter 3.32.0.',
    );
  }
  exitCode = await runVisualRegression(
    updateGoldens: updateGoldens,
    shard: shard,
  );
}

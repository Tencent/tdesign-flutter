import 'dart:io';

import 'check_component_coverage.dart' as coverage;
import 'component_test_manifest.dart';
import 'regression_sharding.dart';

const componentTestSuites = componentTestManifests;

/// 只筛选组件，不改变逐组件测试及覆盖率检查的范围。
List<ComponentTestManifest> componentSuitesForShard(int? shard) {
  if (shard == null) {
    return componentTestSuites;
  }
  if (shard != 1 && shard != 2) {
    throw ArgumentError.value(shard, 'shard', 'Expected 1 or 2.');
  }
  return componentTestSuites
      .where((suite) => regressionShardForComponent(suite.name) == shard)
      .toList();
}

Future<int> runComponentRegression({int? shard}) async {
  final failedComponents = <String>[];

  for (final suite in componentSuitesForShard(shard)) {
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

Future<void> main(List<String> arguments) async {
  final int? shard;
  try {
    shard = parseRegressionShard(arguments);
  } on FormatException {
    stderr.writeln(
      'Usage: dart run tool/run_component_regression.dart [--shard=1|--shard=2]',
    );
    exitCode = 64;
    return;
  }
  exitCode = await runComponentRegression(shard: shard);
}

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/check_component_coverage.dart';
import '../../tool/run_component_regression.dart';

void main() {
  test('regression suites and coverage targets stay in sync', () {
    final suiteComponents = componentTestSuites
        .map((suite) => suite.component)
        .toSet();

    expect(suiteComponents, componentTargets.keys.toSet());
  });

  test('every configured component test file exists', () {
    for (final suite in componentTestSuites) {
      for (final testFile in suite.testFiles) {
        expect(
          File(testFile).existsSync(),
          isTrue,
          reason: '${suite.component}: $testFile',
        );
      }
    }
  });
}

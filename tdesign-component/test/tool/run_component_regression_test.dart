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

  test('GitHub and CNB example regression test lists stay in sync', () {
    final githubWorkflow = File(
      '../.github/workflows/test-build.yml',
    ).readAsStringSync();
    final cnbStages = File('../.cnb/.reusable-stages.yml').readAsStringSync();

    final githubTests = _extractExampleRegressionTests(
      githubWorkflow,
      r'- name: Run example shared functional tests[\s\S]*?run: flutter test --no-pub ([^\n]+)',
    );
    final cnbTests = _extractExampleRegressionTests(
      cnbStages,
      r'\.example-regression-tests:[\s\S]*?flutter test --no-pub ([^\n]+)',
    );

    expect(githubTests, cnbTests);
    expect(githubTests, contains('test/notice_bar_page_test.dart'));
  });
}

List<String> _extractExampleRegressionTests(String yaml, String pattern) {
  final match = RegExp(pattern).firstMatch(yaml);
  expect(match, isNotNull);
  return match!
      .group(1)!
      .trim()
      .split(RegExp(r'\s+'))
      .where((argument) => argument.endsWith('_test.dart'))
      .toList();
}

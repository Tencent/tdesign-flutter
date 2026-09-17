import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/demo_golden_coverage.dart';
import '../../tool/run_component_regression.dart';
import '../../tool/run_visual_regression.dart';

void main() {
  test('every configured visual regression test file exists', () {
    for (final suite in visualTestSuites) {
      for (final testFile in suite.testFiles) {
        final path = '${suite.workingDirectory}/$testFile';
        expect(File(path).existsSync(), isTrue, reason: '${suite.name}: $path');
      }
    }
  });

  test('visual regression suite names are unique', () {
    final names = visualTestSuites.map((suite) => suite.name).toList();
    expect(names.toSet(), hasLength(names.length));
  });

  test('every regression component owns a visual regression suite', () {
    final componentSuites = componentTestSuites
        .map((suite) => suite.name)
        .toSet();
    final visualSuites = visualTestSuites
        .map((suite) => suite.component)
        .toSet();

    expect(visualSuites, componentSuites);
  });

  test('every public API component has regression and Golden coverage', () {
    final apiManifest =
        jsonDecode(File('tool/components.json').readAsStringSync())
            as Map<String, dynamic>;
    final apiComponents = (apiManifest['components'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map((component) => component['slug'] as String)
        .toList();
    final componentNames = componentTestSuites
        .map((suite) => _publicComponentSlug(suite.name))
        .toList();
    final coverageNames = demoGoldenCoverage
        .map((coverage) => _publicComponentSlug(coverage.component))
        .toList();

    expect(apiComponents.toSet(), hasLength(apiComponents.length));
    expect(componentNames.toSet(), hasLength(componentNames.length));
    expect(coverageNames.toSet(), hasLength(coverageNames.length));
    expect(componentNames.toSet(), apiComponents.toSet());
    expect(coverageNames.toSet(), apiComponents.toSet());
    for (final coverage in demoGoldenCoverage) {
      expect(coverage.states, isNotEmpty, reason: coverage.component);
      expect(coverage.rationale.trim(), isNotEmpty, reason: coverage.component);
    }
  });
}

String _publicComponentSlug(String name) {
  return switch (name) {
    'backtop' => 'back-top',
    'refresh' => 'pull-down-refresh',
    'sidebar' => 'side-bar',
    _ => name.replaceAll('_', '-'),
  };
}

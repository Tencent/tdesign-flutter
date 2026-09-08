import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

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
}

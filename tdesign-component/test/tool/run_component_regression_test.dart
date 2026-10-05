import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/check_component_coverage.dart';
import '../../tool/component_test_manifest.dart';
import '../../tool/generate_theme_extensions.dart' as extension_docs;
import '../../tool/run_component_regression.dart';

void main() {
  test('extension API docs honor public filters and hide implementation', () {
    const source = '''
/// Public helpers.
extension Visible on String {
  /// Character count.
  int get count => length;
  String join(String other) { return this + other; }
  int get _private => 0;
}
extension Hidden on String { int get count => length; }
''';
    final docs = extension_docs.themeExtensionDocs(source, shown: {'Visible'});
    expect(docs, contains('## Visible'));
    expect(docs, contains('Character count.'));
    expect(docs, contains('int get count'));
    expect(docs, contains('String join(String other)'));
    expect(docs, isNot(contains('return this')));
    expect(docs, isNot(contains('_private')));
    expect(docs, isNot(contains('## Hidden')));
    expect(
      extension_docs.themeExtensionDocs(source, hidden: {'Visible'}),
      isNot(contains('## Visible')),
    );
  });

  test('regression suites and coverage targets stay in sync', () {
    final suiteComponents = componentTestSuites
        .map((suite) => suite.name)
        .toSet();

    expect(suiteComponents, componentTargets.keys.toSet());
  });

  test('every configured component test file exists', () {
    for (final suite in componentTestSuites) {
      for (final testFile in suite.componentTests) {
        expect(
          File(testFile).existsSync(),
          isTrue,
          reason: '${suite.name}: $testFile',
        );
      }
    }
  });

  test('component manifest names are unique', () {
    final names = componentTestManifests.map((component) => component.name);
    expect(names.toSet(), hasLength(names.length));
    for (final component in componentTestManifests) {
      expect(component.coverageTargets, isNotEmpty, reason: component.name);
      expect(component.componentTests, isNotEmpty, reason: component.name);
      expect(component.visualTests, isNotEmpty, reason: component.name);
      expect(
        component.componentTests.toSet(),
        hasLength(component.componentTests.length),
        reason: component.name,
      );
      expect(
        component.exampleTests.toSet(),
        hasLength(component.exampleTests.length),
        reason: component.name,
      );
    }
  });

  test('every configured example test file exists', () {
    final testFiles = [
      ...sharedExampleTests,
      for (final component in componentTestManifests) ...component.exampleTests,
    ];
    for (final testFile in testFiles) {
      expect(File('example/$testFile').existsSync(), isTrue, reason: testFile);
    }
  });

  test('GitHub and CNB invoke the shared example regression runner', () {
    final githubWorkflow = File(
      '../.github/workflows/test-build.yml',
    ).readAsStringSync();
    final cnbStages = File('../.cnb/.reusable-stages.yml').readAsStringSync();

    const command = 'dart run tool/run_example_regression.dart';
    expect(githubWorkflow, contains(command));
    expect(cnbStages, contains(command));
    expect(githubWorkflow, isNot(contains('test/widget_test.dart')));
    expect(cnbStages, isNot(contains('test/widget_test.dart')));
  });
}

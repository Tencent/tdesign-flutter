import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/check_component_coverage.dart';
import '../../tool/component_test_manifest.dart';
import '../../tool/regression_sharding.dart';
import '../../tool/run_component_regression.dart';
import '../../tool/run_example_regression.dart';

void main() {
  test('fixed component groups do not change with ordering or new entries', () {
    const expected = {'a': 2, 'b': 1, 'avatar': 2, 'theme': 2};
    Map<String, int> groups(Iterable<String> names) => {
      for (final name in names) name: regressionShardForComponent(name),
    };
    expect(groups(expected.keys), expected);
    expect(groups(expected.keys.toList().reversed), expected);
    final extended = groups([...expected.keys, 'new_component']);
    for (final name in expected.keys) {
      expect(extended[name], expected[name]);
    }
    expect(extended['new_component'], isIn([1, 2]));
  });

  test(
    'shard CLI keeps full execution by default and rejects invalid flags',
    () {
      expect(parseRegressionShard([]), isNull);
      expect(parseRegressionShard(['--shard=1']), 1);
      expect(parseRegressionShard(['--shard=2']), 2);
      for (final args in [
        ['--shard=0'],
        ['--shard=3'],
        ['--shard=01'],
        ['--shard='],
        ['--unknown'],
        ['--shard=1', '--shard=2'],
        ['--shard=1', '--shard=1'],
      ]) {
        expect(() => parseRegressionShard(args), throwsFormatException);
      }
      expect(() => componentSuitesForShard(0), throwsArgumentError);
    },
  );

  test(
    'component shards partition the manifest without changing coverage scope',
    () {
      final first = componentSuitesForShard(1);
      final second = componentSuitesForShard(2);
      final names = componentTestSuites.map((suite) => suite.name).toSet();
      final firstNames = first.map((suite) => suite.name).toSet();
      final secondNames = second.map((suite) => suite.name).toSet();
      expect(firstNames.intersection(secondNames), isEmpty);
      expect(firstNames.union(secondNames), names);
      expect(componentSuitesForShard(null), same(componentTestSuites));
      for (final group in [first, second]) {
        expect(group, orderedEquals(componentTestSuites.where(group.contains)));
        for (final suite in group) {
          expect(componentTargets[suite.name], suite.coverageTargets);
        }
      }
      for (final suite in [...first, ...second]) {
        final group = firstNames.contains(suite.name) ? 1 : 2;
        expect(regressionShardForComponent(suite.name), group);
      }
    },
  );

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

  test(
    'public example assertions and default debug controls run separately',
    () {
      final groups = exampleRegressionArguments([
        'test/widget_test.dart',
        'test/example_test.dart',
      ]);
      expect(groups, hasLength(2));
      expect(
        groups.first,
        contains('--dart-define=TDESIGN_DEMO_TEST_MODULES=false'),
      );
      expect(
        groups.first,
        containsAll(['--exclude-tags', 'golden', 'test/example_test.dart']),
      );
      expect(
        groups.last,
        containsAll(['--tags', 'internal-demo', 'test/widget_test.dart']),
      );
      expect(
        groups.last.where((argument) => argument.startsWith('--dart-define=')),
        isEmpty,
      );
    },
  );

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

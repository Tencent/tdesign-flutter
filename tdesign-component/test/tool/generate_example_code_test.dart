import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/generate_example_code.dart';

void main() {
  late Directory fixtureRoot;
  late Directory sourceDirectory;
  late Directory outputDirectory;

  setUp(() {
    fixtureRoot = Directory.systemTemp.createTempSync(
      'example-code-generator-',
    );
    sourceDirectory = Directory('${fixtureRoot.path}/lib')..createSync();
    outputDirectory = Directory('${fixtureRoot.path}/code')..createSync();
  });

  tearDown(() {
    fixtureRoot.deleteSync(recursive: true);
  });

  void writeSource(String name, String source) {
    File('${sourceDirectory.path}/$name.dart').writeAsStringSync(source);
  }

  void writeManifest(String group, List<String> methodNames) {
    final pageName = '${group[0].toUpperCase()}${group.substring(1)}Page';
    final items = methodNames
        .map(
          (methodName) =>
              '''
          ExampleItem(
            methodName: '$methodName',
            builder: (_) => const $methodName(),
          ),''',
        )
        .join();
    writeSource('${group}_page', '''
@ExampleCodeManifest()
class $pageName {
  Object build(Object context) => ExamplePage(
    exampleCodeGroup: '$group',
    children: [
      ExampleModule(
        title: 'Examples',
        children: [$items
        ],
      ),
    ],
  );
}
''');
  }

  ExampleCodeGenerator createGenerator() => ExampleCodeGenerator(
    sourceDirectory: sourceDirectory,
    outputDirectory: outputDirectory,
  );

  test('exports class and top-level methods without annotation', () {
    writeSource('examples', '''
class Examples {
  @ExampleCode(group: 'button')
  void classDemo() {}
}

@ExampleCode(group: 'button')
void topLevelDemo() {}
''');
    writeManifest('button', <String>['classDemo', 'topLevelDemo']);

    expect(createGenerator().run().isUpToDate, isFalse);
    expect(
      File('${outputDirectory.path}/button.classDemo.txt').readAsStringSync(),
      'void classDemo() {}\n',
    );
    expect(
      File(
        '${outputDirectory.path}/button.topLevelDemo.txt',
      ).readAsStringSync(),
      'void topLevelDemo() {}\n',
    );
  });

  test('check reports changed and stale outputs without writing', () {
    writeSource('examples', '''
@ExampleCode(group: 'button')
void demo() {}
''');
    writeManifest('button', <String>['demo']);
    File('${outputDirectory.path}/stale.txt').writeAsStringSync('stale');

    final checked = createGenerator().run(check: true);
    expect(
      checked.changed,
      containsAll(<String>['button.demo.txt', 'stale:stale.txt']),
    );
    expect(File('${outputDirectory.path}/stale.txt').existsSync(), isTrue);

    createGenerator().run();
    expect(File('${outputDirectory.path}/stale.txt').existsSync(), isFalse);
    expect(createGenerator().run(check: true).isUpToDate, isTrue);
  });

  test('standalone widget includes imports and only its associated State', () {
    writeSource('stateful', '''
import 'package:flutter/material.dart';
import '../annotation/example_code.dart';
import '../base/example_widget.dart';

@ExampleCode(group: 'counter')
class Counter extends StatefulWidget {
  const Counter({super.key});
  @override
  State<Counter> createState() => _CounterState();
}
class _CounterState extends State<Counter> {
  int value = 3;
  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: () => setState(() => value++),
    child: Text(value.toString()),
  );
}
class _OtherState extends State<Other> {}
''');
    writeManifest('counter', <String>['Counter']);
    createGenerator().run();
    final snippet = File(
      '${outputDirectory.path}/counter.Counter.txt',
    ).readAsStringSync();
    expect(snippet, startsWith("import 'package:flutter/material.dart';"));
    expect(snippet, contains('class Counter extends StatefulWidget'));
    expect(snippet, contains('class _CounterState extends State<Counter>'));
    expect(snippet, contains('int value = 3;'));
    expect(snippet, contains('setState(() => value++)'));
    expect(snippet, isNot(contains('_OtherState')));
    expect(snippet, isNot(contains('example_code.dart')));
    expect(snippet, isNot(contains('example_widget.dart')));
    expect(snippet, isNot(contains('@ExampleCode')));
    expect(createGenerator().run(check: true).isUpToDate, isTrue);
  });

  test('verbose mode reports changes and writes files correctly', () {
    writeSource('examples', '''
@ExampleCode(group: 'button')
void demo() {}
''');
    writeManifest('button', <String>['demo']);

    // First verbose run should detect and write the snippet.
    final verboseResult = createGenerator().run(verbose: true);
    expect(verboseResult.changed, <String>['button.demo.txt', 'manifest.json']);
    expect(
      File('${outputDirectory.path}/button.demo.txt').readAsStringSync(),
      'void demo() {}\n',
    );

    // Second verbose run should report everything up to date.
    final secondResult = createGenerator().run(verbose: true);
    expect(secondResult.isUpToDate, isTrue);
  });

  test('rejects duplicate, missing, and invalid groups', () {
    writeSource('invalid', '''
@ExampleCode(group: 'bad/path')
void invalid() {}

@ExampleCode()
void missing() {}

@ExampleCode(group: 'button')
void duplicate() {}

class MoreExamples {
  @ExampleCode(group: 'button')
  void duplicate() {}
}
''');

    expect(
      () => createGenerator().run(),
      throwsA(
        isA<StateError>()
            .having((error) => error.message, 'message', contains('invalid'))
            .having((error) => error.message, 'message', contains('missing'))
            .having((error) => error.message, 'message', contains('duplicate')),
      ),
    );
  });

  test('exports a complete standalone example file', () {
    writeSource('counter_example', '''
import 'package:flutter/material.dart';
import '../annotation/example_code.dart';

const initialValue = 3;

@ExampleCode(group: 'counter')
class CounterExample extends StatelessWidget {
  const CounterExample({super.key});
  @override
  Widget build(BuildContext context) => Text(formatValue(initialValue));
}

String formatValue(int value) => 'value: \$value';
''');
    writeManifest('counter', <String>['CounterExample']);

    createGenerator().run();
    final snippet = File(
      '${outputDirectory.path}/counter.CounterExample.txt',
    ).readAsStringSync();
    expect(snippet, contains('const initialValue = 3;'));
    expect(snippet, contains('String formatValue(int value)'));
    expect(snippet, isNot(contains('example_code.dart')));
    expect(snippet, isNot(contains('@ExampleCode')));
  });

  test('inlines declared sibling helper files into a standalone example', () {
    writeSource('helper', '''
import 'package:flutter/material.dart';

class IncludedHelper extends StatelessWidget {
  const IncludedHelper({super.key});
  @override
  Widget build(BuildContext context) => const Text('helper');
}
''');
    writeSource('included_example', '''
import 'package:flutter/material.dart';
import '../annotation/example_code.dart';
import 'helper.dart';

@ExampleCode(group: 'included', includes: ['helper.dart'])
class IncludedExample extends StatelessWidget {
  const IncludedExample({super.key});
  @override
  Widget build(BuildContext context) => const IncludedHelper();
}
''');
    writeManifest('included', <String>['IncludedExample']);

    createGenerator().run();
    final snippet = File(
      '${outputDirectory.path}/included.IncludedExample.txt',
    ).readAsStringSync();
    expect(snippet, contains('class IncludedExample extends StatelessWidget'));
    expect(snippet, contains('class IncludedHelper extends StatelessWidget'));
    expect(snippet, isNot(contains("import 'helper.dart'")));
  });

  test('generates strict page order with no legacy groups', () {
    writeSource('divider_base_example', '''
@ExampleCode(group: 'divider')
class DividerBaseExample {}
''');
    writeSource('divider_dashed_example', '''
@ExampleCode(group: 'divider')
class DividerDashedExample {}
''');
    writeSource('divider_page', '''
@ExampleCodeManifest()
class DividerPage {
  Object build(Object context) => ExamplePage(
    exampleCodeGroup: 'divider',
    children: [
      ExampleModule(
        title: '组件类型',
        children: [
          ExampleItem(
            desc: '虚线样式',
            methodName: 'DividerDashedExample',
            builder: (_) => const DividerDashedExample(),
          ),
          ExampleItem(
            desc: '水平分割线',
            methodName: 'DividerBaseExample',
            builder: (_) => const DividerBaseExample(),
          ),
        ],
      ),
    ],
  );
}
''');

    createGenerator().run();
    final manifest = File(
      '${outputDirectory.path}/manifest.json',
    ).readAsStringSync();
    expect(
      manifest.indexOf('divider.DividerDashedExample'),
      lessThan(manifest.indexOf('divider.DividerBaseExample')),
    );
    expect(manifest, contains('"legacyGroups": []'));
  });

  test('rejects an example group without a strict page manifest', () {
    writeSource('legacy', '''
@ExampleCode(group: 'legacy')
void legacyDemo() {}
''');

    expect(
      () => createGenerator().run(),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          contains('Missing: legacy'),
        ),
      ),
    );
  });

  test('rejects an invalid strict page mapping', () {
    writeSource('sample_example', '''
@ExampleCode(group: 'sample')
class SampleExample {}
''');
    writeSource('sample_page', '''
@ExampleCodeManifest()
class SamplePage {
  Object build(Object context) => ExamplePage(
    exampleCodeGroup: 'sample',
    children: [
      ExampleModule(
        title: '类型',
        children: [
          ExampleItem(
            methodName: 'WrongExample',
            builder: (_) => const SampleExample(),
          ),
        ],
      ),
    ],
  );
}
''');

    expect(
      () => createGenerator().run(),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          contains('methodName to the directly built Widget class'),
        ),
      ),
    );
  });

  test('strict page skips a conditional internal-only module', () {
    writeSource('sample_example', '''
@ExampleCode(group: 'sample')
class SampleExample {}
''');
    writeSource('sample_page', '''
@ExampleCodeManifest()
class SamplePage {
  final bool showInternal = false;
  Object build(Object context) => ExamplePage(
    exampleCodeGroup: 'sample',
    children: [
      ExampleModule(
        title: '公开示例',
        children: [
          ExampleItem(
            methodName: 'SampleExample',
            builder: (_) => const SampleExample(),
          ),
        ],
      ),
      if (showInternal)
        ExampleModule(
          title: '内部回归',
          children: [
            ExampleItem(ignoreCode: true, builder: (_) => Object()),
          ],
        ),
    ],
  );
}
''');

    createGenerator().run();
    final manifest = File(
      '${outputDirectory.path}/manifest.json',
    ).readAsStringSync();
    expect(manifest, contains('"公开示例"'));
    expect(manifest, isNot(contains('内部回归')));
  });
}

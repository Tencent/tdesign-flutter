import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/generate_example_code.dart';

void main() {
  late Directory fixtureRoot;
  late Directory sourceDirectory;
  late Directory outputDirectory;

  setUp(() {
    fixtureRoot =
        Directory.systemTemp.createTempSync('example-code-generator-');
    sourceDirectory = Directory('${fixtureRoot.path}/lib')..createSync();
    outputDirectory = Directory('${fixtureRoot.path}/code')..createSync();
  });

  tearDown(() {
    fixtureRoot.deleteSync(recursive: true);
  });

  void writeSource(String name, String source) {
    File('${sourceDirectory.path}/$name.dart').writeAsStringSync(source);
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

    expect(createGenerator().run().isUpToDate, isFalse);
    expect(
      File('${outputDirectory.path}/button.classDemo.txt').readAsStringSync(),
      'void classDemo() {}\n',
    );
    expect(
      File('${outputDirectory.path}/button.topLevelDemo.txt')
          .readAsStringSync(),
      'void topLevelDemo() {}\n',
    );
  });

  test('check reports changed and stale outputs without writing', () {
    writeSource('examples', '''
@ExampleCode(group: 'button')
void demo() {}
''');
    File('${outputDirectory.path}/stale.txt').writeAsStringSync('stale');

    final checked = createGenerator().run(check: true);
    expect(checked.changed,
        containsAll(<String>['button.demo.txt', 'stale:stale.txt']));
    expect(File('${outputDirectory.path}/stale.txt').existsSync(), isTrue);

    createGenerator().run();
    expect(File('${outputDirectory.path}/stale.txt').existsSync(), isFalse);
    expect(createGenerator().run(check: true).isUpToDate, isTrue);
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
}

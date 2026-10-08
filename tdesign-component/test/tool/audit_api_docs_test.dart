import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  late Directory fixture;
  late File asset;
  late File source;
  final packageConfig = p.absolute('.dart_tool/package_config.json');

  setUp(() async {
    fixture = await Directory.systemTemp.createTemp('tdesign-api-contract-');
    for (final directory in [
      'tool',
      'lib/src/components/sample',
      'example/assets/api',
    ]) {
      Directory(p.join(fixture.path, directory)).createSync(recursive: true);
    }
    for (final file in ['audit_api_docs.dart', 'api_doc_contract.dart']) {
      File('tool/$file').copySync(p.join(fixture.path, 'tool', file));
    }
    File(
      p.join(fixture.path, 'lib/tdesign_flutter.dart'),
    ).writeAsStringSync("export 'src/components/sample/sample.dart';\n");
    source = File(
      p.join(fixture.path, 'lib/src/components/sample/sample.dart'),
    );
    source.writeAsStringSync(_source);
    File(p.join(fixture.path, 'tool/components.json')).writeAsStringSync(
      jsonEncode({
        'schemaVersion': 1,
        'components': [
          {
            'slug': 'sample',
            'source': {'path': 'lib/src/components/sample', 'type': 'folder'},
            'api': {
              'names': ['Sample'],
            },
          },
        ],
      }),
    );
    asset = File(p.join(fixture.path, 'example/assets/api/sample_api.md'));
    asset.writeAsStringSync(_api);
  });
  tearDown(() => fixture.delete(recursive: true));

  Future<ProcessResult> audit({bool json = false}) =>
      Process.run(_dartExecutable(), [
        '--packages=$packageConfig',
        p.join(fixture.path, 'tool/audit_api_docs.dart'),
        if (json) '--json',
      ]);

  test(
    'accepts complete signatures, positional parameters and escaped pipes',
    () async {
      final result = await audit();
      expect(result.exitCode, 0, reason: '${result.stdout}${result.stderr}');
    },
  );

  test(
    'accepts compact type contracts without a standalone declaration',
    () async {
      asset.writeAsStringSync(
        _api.replaceFirst(
          '#### 声明\n```dart\nclass Sample<T extends Object>\n```',
          '类型参数：`T extends Object`',
        ),
      );
      final result = await audit();
      expect(result.exitCode, 0, reason: '${result.stdout}${result.stderr}');
    },
  );

  test('rejects a missing type bound on compact API pages', () async {
    asset.writeAsStringSync(
      _api.replaceFirst(
        '#### 声明\n```dart\nclass Sample<T extends Object>\n```',
        '类型参数：`T`',
      ),
    );
    final result = await audit();
    expect(result.exitCode, 1, reason: '${result.stdout}${result.stderr}');
    expect(result.stdout, contains('output-signature'));
  });

  test(
    'accepts named constructor tables without a repeated signature',
    () async {
      asset.writeAsStringSync(_api.replaceFirst(_constructorSignature, ''));
      final result = await audit();
      expect(result.exitCode, 0, reason: '${result.stdout}${result.stderr}');
    },
  );

  test('compact constructor tables still reject incorrect types', () async {
    asset.writeAsStringSync(
      _api
          .replaceFirst(_constructorSignature, '')
          .replaceFirst('| value | int |', '| value | String |'),
    );
    final result = await audit();
    expect(result.exitCode, 1);
    expect(result.stdout, contains('output-parameter-类型'));
  });

  for (final shape in {
    'value, label': true,
    'label, value': false,
    'value, {label}': false,
    '': false,
  }.entries) {
    test('checks positional constructor shape ${shape.key}', () async {
      source.writeAsStringSync(
        _source.replaceFirst(
          "{required this.value, this.label = 'a b'}",
          "this.value, [this.label = 'a b']",
        ),
      );
      asset.writeAsStringSync(
        _api.replaceFirst(
          _constructorSignature,
          shape.key.isEmpty ? '' : '位置参数：`${shape.key}`',
        ),
      );
      final result = await audit();
      expect(
        result.exitCode,
        shape.value ? 0 : 1,
        reason: '${result.stdout}${result.stderr}',
      );
      if (!shape.value) {
        expect(result.stdout, contains('output-signature'));
      }
    });
  }

  test(
    'method signatures remain required beside compact constructors',
    () async {
      asset.writeAsStringSync(
        _api
            .replaceFirst(_constructorSignature, '')
            .replaceFirst(
              '```dart\nT? read<E extends Object>(E item, [T? fallback])\n```',
              '',
            ),
      );
      final result = await audit();
      expect(result.exitCode, 1);
      expect(result.stdout, contains('output-signature: Sample.read'));
    },
  );

  final compactMethods = _api
      .replaceFirst(_constructorSignature, '')
      .replaceFirst(
        '```dart\nT? read<E extends Object>(E item, [T? fallback])\n```',
        '类型参数：`E extends Object`\n'
            '位置参数：`item, fallback`\n'
            '返回类型：`T?`',
      )
      .replaceFirst('```dart\nSample<T> copyWith()\n```', '返回类型：`Sample<T>`');
  test('accepts uniformly compact callable contracts', () async {
    asset.writeAsStringSync(compactMethods);
    final result = await audit();
    expect(result.exitCode, 0, reason: '${result.stdout}${result.stderr}');
  });
  for (final entry in {
    'method parameter order': ('item, fallback', 'fallback, item'),
    'method parameter group': ('item, fallback', 'item, {fallback}'),
    'method generic bound': ('E extends Object', 'E'),
    'method return type': ('返回类型：`T?`', '返回类型：`Object?`'),
    'missing method return': ('返回类型：`Sample<T>`', ''),
  }.entries) {
    test('rejects compact ${entry.key}', () async {
      asset.writeAsStringSync(
        compactMethods.replaceFirst(entry.value.$1, entry.value.$2),
      );
      final result = await audit();
      expect(result.exitCode, 1);
      expect(result.stdout, contains('output-signature'));
    });
  }

  final cases = <String, (String, String, String)>{
    'missing method parameter': (_fallbackRow, '', 'output-parameter-count'),
    'wrong parameter type': (
      _fallbackRow,
      _fallbackRow.replaceFirst('| T? |', '| String? |'),
      'output-parameter-类型',
    ),
    'wrong default': (
      "| label | String | 'a b' |",
      "| label | String | 'ab' |",
      'output-parameter-默认值',
    ),
    'wrong required flag': (
      '| value | int | - | 内容。 | 是 |',
      '| value | int | - | 内容。 | 否 |',
      'output-parameter-必填',
    ),
    'duplicate parameter': (
      _fallbackRow,
      '$_fallbackRow\n$_fallbackRow',
      'output-parameter-count',
    ),
    'lost generic bound': (
      'read<E extends Object>',
      'read<E>',
      'output-signature',
    ),
    'lost named parameter kind': (
      '{required this.value, this.label',
      '[this.value, this.label',
      'output-signature',
    ),
    'empty type beside escaped pipe': (
      "| label | String | 'a b' |",
      "| label | - | 'a b' |",
      'output-empty-类型',
    ),
    'extra parameter': (
      _fallbackRow,
      '$_fallbackRow\n| ghost | int | - | 多余参数。 | 否 |',
      'output-extra-parameter',
    ),
  };
  for (final entry in cases.entries) {
    test('rejects ${entry.key}', () async {
      final (before, after, category) = entry.value;
      expect(_api, contains(before));
      asset.writeAsStringSync(_api.replaceFirst(before, after));
      final result = await audit();
      expect(result.exitCode, 1, reason: '${result.stdout}${result.stderr}');
      expect(result.stdout, contains(category));
    });
  }

  test('custom overrides without comments cannot silently disappear', () async {
    source.writeAsStringSync(_source.replaceFirst('  /// 复制配置。\n', ''));
    final result = await audit();
    expect(result.exitCode, 1);
    expect(result.stdout, contains('comment: Sample.copyWith'));
  });

  test('business build methods cannot disappear from documentation', () async {
    source.writeAsStringSync(
      _source.replaceFirst(
        '  /// 复制配置。',
        '  /// 构建业务结果。\n  void build() {}\n  /// 复制配置。',
      ),
    );
    final result = await audit();
    expect(result.exitCode, 1);
    expect(result.stdout, contains('output-callable: Sample.build'));
  });

  test('ordinary custom overrides without comments are reported', () async {
    source.writeAsStringSync(
      _source.replaceFirst(
        '  /// 复制配置。',
        '  @override\n  void close() {}\n  /// 复制配置。',
      ),
    );
    final result = await audit();
    expect(result.exitCode, 1);
    expect(result.stdout, contains('comment: Sample.close'));
  });

  test(
    'function typed callback is accepted and dynamic substitution fails',
    () async {
      source.writeAsStringSync(
        _source.replaceFirst('E item,', 'void callback(int value), E item,'),
      );
      final markdown = _api
          .replaceFirst('E item,', 'void callback(int value), E item,')
          .replaceFirst(
            '| item | E |',
            '| callback | void Function(int value) | - | 回调。 | 是 |\n| item | E |',
          );
      asset.writeAsStringSync(markdown);
      final valid = await audit();
      expect(valid.exitCode, 0, reason: '${valid.stdout}${valid.stderr}');
      asset.writeAsStringSync(
        markdown.replaceFirst(
          '| callback | void Function(int value) |',
          '| callback | dynamic |',
        ),
      );
      final invalid = await audit();
      expect(invalid.exitCode, 1);
      expect(
        invalid.stdout,
        contains('output-parameter-类型: Sample.read.callback'),
      );
    },
  );

  test(
    'child parameter headings and multiline defaults preserve the contract',
    () async {
      const literal = "'''line1\n  line2'''";
      source.writeAsStringSync(_source.replaceAll("'a b'", literal));
      asset.writeAsStringSync(
        _api
            .replaceFirst('#### 参数', '##### 参数')
            .replaceFirst("this.label = 'a b'", 'this.label = $literal')
            .replaceFirst(
              "| label | String | 'a b' |",
              "| label | String | '''line1&#10;  line2''' |",
            ),
      );
      final valid = await audit();
      expect(valid.exitCode, 0, reason: '${valid.stdout}${valid.stderr}');
      asset.writeAsStringSync(
        asset.readAsStringSync().replaceFirst('&#10;  line2', '&#10;line2'),
      );
      final invalid = await audit();
      expect(invalid.exitCode, 1);
      expect(invalid.stdout, contains('output-parameter-默认值'));
    },
  );

  test(
    'JSON inventory also exits unsuccessfully for a missing parameter',
    () async {
      asset.writeAsStringSync(_api.replaceFirst(_fallbackRow, ''));
      final result = await audit(json: true);
      expect(result.exitCode, 1);
      final inventory =
          jsonDecode(result.stdout as String) as Map<String, dynamic>;
      expect(
        (inventory['issues'] as List).any(
          (issue) => issue['category'] == 'output-parameter-count',
        ),
        isTrue,
      );
    },
  );
  test('new exported constants cannot bypass the manifest', () async {
    source.writeAsStringSync(
      '$_source\n/// Public default.\nconst sampleDefault = 1;\n',
    );
    final result = await audit();
    expect(result.exitCode, 1);
    expect(result.stdout, contains('scope: sampleDefault'));
  });

  test('internal declarations are excluded from the public contract', () async {
    source.writeAsStringSync(
      '$_source\n@internal\nclass InternalImplementation {}\n',
    );
    final result = await audit();
    expect(result.exitCode, 0, reason: '${result.stdout}${result.stderr}');
  });
}

String _dartExecutable() {
  final sdk = Platform.environment['DART_SDK'];
  final name = Platform.isWindows ? 'dart.exe' : 'dart';
  if (sdk != null) {
    return p.join(sdk, 'bin', name);
  }
  var folder = File(Platform.resolvedExecutable).parent;
  while (folder.parent.path != folder.path) {
    final candidate = File(p.join(folder.path, 'dart-sdk/bin', name));
    if (candidate.existsSync()) {
      return candidate.path;
    }
    folder = folder.parent;
  }
  return name;
}

const _source = '''
/// 泛型配置。
class Sample<T extends Object> {
  const Sample({required this.value, this.label = 'a b'});
  /// 内容。
  final int value;
  /// 标签，可包含竖线。
  final String label;
  /// 读取泛型内容。
  T? read<E extends Object>(E item, [T? fallback]) => fallback;
  /// 复制配置。
  @override
  Sample<T> copyWith() => this;
}
''';
const _fallbackRow = '| fallback | T? | - | 回退内容。 | 否 |';
const _constructorSignature =
    "```dart\nconst Sample({required this.value, this.label = 'a b'})\n```";
const _api = r'''## API
### Sample
#### 简介
泛型配置。
#### 声明
```dart
class Sample<T extends Object>
```
#### 默认构造方法
```dart
const Sample({required this.value, this.label = 'a b'})
```
#### 参数
| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| value | int | - | 内容。 | 是 |
| label | String | 'a b' | 可包含 a\|b。 | 否 |
#### 实例方法
##### Sample.read
```dart
T? read<E extends Object>(E item, [T? fallback])
```
| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| item | E | - | 泛型内容。 | 是 |
| fallback | T? | - | 回退内容。 | 否 |
##### Sample.copyWith
```dart
Sample<T> copyWith()
```
''';

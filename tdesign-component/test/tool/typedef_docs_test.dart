import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../tool/api_doc_contract.dart';

void main() {
  GenericTypeAlias parse(String source) =>
      parseString(content: source).unit.declarations.single as GenericTypeAlias;
  const source = '''
typedef Callback<T extends Object> = T? Function<R extends num>(
  T value, {required R count, void Function(R)? onResult})?;
''';
  const doc = '''
### Callback
类型参数：`T extends Object`
回调类型参数：`R extends num`
可空：是。
位置参数：`value`
#### 回调参数
| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| value | T | - | Value. | 是 |
| count | R | - | Count. | 是 |
| onResult | void Function(R)? | - | Result callback. | 否 |
#### 返回值
| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | T? | - | Result. | - |
''';
  test('accepts complete callback table contract', () {
    expect(typedefDocumentationIssues(parse(source), doc), isEmpty);
  });
  test('rejects missing wrong duplicate and reordered callback contracts', () {
    for (final mutation in [
      doc.replaceFirst('T extends Object', 'T'),
      doc.replaceFirst('R extends num', 'R'),
      doc.replaceFirst('可空：是。', ''),
      doc.replaceFirst('位置参数：`value`', '位置参数：`count, value`'),
      doc.replaceFirst('| value | T |', '| value | Object |'),
      doc.replaceFirst(
        '| count | R | - | Count. | 是 |',
        '| count | R | - | Count. | 否 |',
      ),
      doc.replaceFirst('| 返回值 | T? |', '| 返回值 | Object? |'),
      doc.replaceFirst('| value | T | - | Value. | 是 |', ''),
      doc.replaceFirst(
        '| value | T | - | Value. | 是 |',
        '| value | T | - | Value. | 是 |\n| value | T | - | Duplicate. | 是 |',
      ),
      doc.replaceFirst(
        '| value | T | - | Value. | 是 |\n| count | R | - | Count. | 是 |',
        '| count | R | - | Count. | 是 |\n| value | T | - | Value. | 是 |',
      ),
    ]) {
      expect(
        typedefDocumentationIssues(parse(source), mutation),
        isNotEmpty,
        reason: mutation,
      );
    }
  });
  test(
    'accepts legacy source declarations and rejects a wrong legacy alias',
    () {
      expect(
        typedefDocumentationIssues(
          parse(source),
          '#### 类型定义\n```dart\n$source\n```',
        ),
        isEmpty,
      );
      expect(
        typedefDocumentationIssues(
          parse(source),
          '#### 类型定义\n```dart\n${source.replaceFirst('T?', 'Object?')}\n```',
        ),
        isNotEmpty,
      );
    },
  );
  test('presentation-only rows cannot supply missing callback parameters', () {
    final mutation = doc.replaceFirst(
      '#### 回调参数\n',
      '#### 回调参数\n<!-- api-table: details -->\n',
    );
    expect(typedefDocumentationIssues(parse(source), mutation), isNotEmpty);
  });
  test('accepts optional unnamed parameters and explicit void return', () {
    final alias = parse('typedef Callback = void Function(int, [String?]);');
    const output = '''
### Callback
位置参数：`参数 1, 参数 2`
#### 回调参数
| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 参数 1 | int | - | Value. | 是 |
| 参数 2 | String? | - | Optional value. | 否 |
#### 返回值
| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | void | - | No result. | - |
''';
    expect(typedefDocumentationIssues(alias, output), isEmpty);
  });
  test(
    'accepts a non function target table and rejects an incorrect target',
    () {
      final alias = parse('typedef Values<T extends num> = List<T?>;');
      const output = '''
### Values
类型参数：`T extends num`
#### 类型定义
| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| Values | List&lt;T?&gt; | - | - | - |
''';
      expect(typedefDocumentationIssues(alias, output), isEmpty);
      expect(
        typedefDocumentationIssues(
          alias,
          output.replaceFirst('T?&gt;', 'num&gt;'),
        ),
        isNotEmpty,
      );
    },
  );
}

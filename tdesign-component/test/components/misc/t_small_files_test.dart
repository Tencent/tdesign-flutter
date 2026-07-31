import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// 覆盖多个小文件的未覆盖行：TFabBounds 构造器、DateTimePickerSteps operator==
void main() {
  group('TFabBounds', () {
    test('构造器正确赋值', () {
      const bounds = TFabBounds(start: 10, end: 20);
      expect(bounds.start, 10);
      expect(bounds.end, 20);
    });

    test('const 构造器相同参数 identical', () {
      const a = TFabBounds(start: 0, end: 100);
      const b = TFabBounds(start: 0, end: 100);
      expect(identical(a, b), isTrue);
    });
  });

  group('DateTimePickerSteps operator ==', () {
    test('所有字段相同返回 true', () {
      const a = DateTimePickerSteps(
        year: 1,
        month: 1,
        day: 1,
        hour: 1,
        minute: 1,
        second: 1,
      );
      const b = DateTimePickerSteps(
        year: 1,
        month: 1,
        day: 1,
        hour: 1,
        minute: 1,
        second: 1,
      );
      expect(a == b, isTrue);
    });

    test('second 不同返回 false', () {
      const a = DateTimePickerSteps(
        year: 1,
        month: 1,
        day: 1,
        hour: 1,
        minute: 1,
        second: 1,
      );
      const b = DateTimePickerSteps(
        year: 1,
        month: 1,
        day: 1,
        hour: 1,
        minute: 1,
        second: 2,
      );
      expect(a == b, isFalse);
    });

    test('identical 返回 true', () {
      const a = DateTimePickerSteps(
        year: 1,
        month: 1,
        day: 1,
        hour: 1,
        minute: 1,
        second: 1,
      );
      expect(a == a, isTrue);
    });

    test('非同类型返回 false', () {
      const a = DateTimePickerSteps(
        year: 1,
        month: 1,
        day: 1,
        hour: 1,
        minute: 1,
        second: 1,
      );
      const Object other = 'string';
      expect(a == other, isFalse);
    });

    test('最后一个字段不同返回 false', () {
      const a = DateTimePickerSteps(second: 1);
      const b = DateTimePickerSteps(second: 2);
      expect(a == b, isFalse);
    });
  });

  group('TPicker types', () {
    test('linked options compare recursively', () {
      const option = TPickerOption(
        label: 'a',
        value: 'a',
        children: [TPickerOption(label: 'b', value: 'b')],
      );
      const same = TPickerOption(
        label: 'a',
        value: 'a',
        children: [TPickerOption(label: 'b', value: 'b')],
      );
      const different = TPickerOption(label: 'a', value: 'other');

      expect(option, same);
      expect(option.hashCode, same.hashCode);
      expect(option, isNot(different));
      expect(const TPickerLinked([option]), const TPickerLinked([same]));
      expect(option.toString(), 'TPickerOption(a, a)');
    });

    test('column data compares by column and item', () {
      const first = TPickerColumns([
        [TPickerOption(label: 'a', value: 1)],
      ]);
      const same = TPickerColumns([
        [TPickerOption(label: 'a', value: 1)],
      ]);
      const different = TPickerColumns([
        [TPickerOption(label: 'b', value: 2)],
      ]);

      expect(first, same);
      expect(first.hashCode, same.hashCode);
      expect(first, isNot(different));
    });
  });
}

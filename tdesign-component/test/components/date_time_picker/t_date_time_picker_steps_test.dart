import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
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
}

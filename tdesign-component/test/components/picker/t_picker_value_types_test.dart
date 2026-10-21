import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
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

import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  test('TPickerOption compares all fields recursively', () {
    const option = TPickerOption(
      label: 'A',
      value: 1,
      disabled: true,
      children: [TPickerOption(label: 'child', value: 2)],
    );
    const same = TPickerOption(
      label: 'A',
      value: 1,
      disabled: true,
      children: [TPickerOption(label: 'child', value: 2)],
    );

    expect(option, same);
    expect(option.hashCode, same.hashCode);
    expect(option, isNot(const TPickerOption(label: 'B', value: 1)));
    expect(option, isNot(const TPickerOption(label: 'A', value: 2)));
    expect(
      option,
      isNot(const TPickerOption(label: 'A', value: 1, disabled: false)),
    );
    expect(
      option,
      isNot(const TPickerOption(
        label: 'A',
        value: 1,
        disabled: true,
        children: [],
      )),
    );
    expect(option.toString(), 'TPickerOption(A, 1)');
  });

  test('TPickerColumns and TPickerLinked use structural equality', () {
    const columns = TPickerColumns([
      [TPickerOption(label: 'A', value: 1)],
    ]);
    const same = TPickerColumns([
      [TPickerOption(label: 'A', value: 1)],
    ]);
    const differentLength = TPickerColumns([]);
    const differentItem = TPickerColumns([
      [TPickerOption(label: 'B', value: 2)],
    ]);

    expect(columns, same);
    expect(columns.hashCode, same.hashCode);
    expect(columns, isNot(differentLength));
    expect(columns, isNot(differentItem));
    const linked = TPickerLinked([]);
    expect(linked, const TPickerLinked([]));
    expect(linked.hashCode, const TPickerLinked([]).hashCode);
    expect(
      const TPickerLinked([TPickerOption(label: 'A', value: 1)]),
      isNot(const TPickerLinked([TPickerOption(label: 'B', value: 2)])),
    );
  });

  test('TPickerValue exposes values and labels', () {
    const value = TPickerValue(
      selectedOptions: [TPickerOption(label: 'A', value: 1)],
      indexes: [0],
    );

    expect(value.values, [1]);
    expect(value.labels, ['A']);
    expect(value.toString(), contains('indexes: [0]'));
  });
}

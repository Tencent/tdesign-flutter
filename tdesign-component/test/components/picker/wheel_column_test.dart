import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/picker/t_picker_types.dart';
import 'package:tdesign_flutter/src/components/picker/wheel_column.dart';

void main() {
  const options = [
    TPickerOption(label: 'A', value: 'a'),
    TPickerOption(label: 'B', value: 'b'),
  ];

  test('nearestEnabledIndex searches both directions', () {
    const values = [
      TPickerOption(label: 'A', value: 0),
      TPickerOption(label: 'B', value: 1, disabled: true),
      TPickerOption(label: 'C', value: 2),
    ];
    expect(WheelColumnState.nearestEnabledIndex(values, 1), 2);
    expect(WheelColumnState.nearestEnabledIndex(values, 2), 0);
    expect(
      WheelColumnState.nearestEnabledIndex(
        const [TPickerOption(label: 'A', value: 0, disabled: true)],
        0,
      ),
      -1,
    );
  });

  testWidgets('nudge moves one item and respects boundaries', (tester) async {
    final key = GlobalKey<WheelColumnState>();
    final controller = FixedExtentScrollController();
    var selected = -1;
    await tester.pumpWidget(MaterialApp(
      home: SizedBox(
        height: 200,
        child: WheelColumn(
          key: key,
          colIndex: 0,
          options: options,
          controller: controller,
          itemHeight: 40,
          disabled: false,
          onItemSelected: (_, index, __) => selected = index,
        ),
      ),
    ));

    expect(key.currentState?.nudge(-1), isFalse);
    expect(key.currentState?.nudge(1), isTrue);
    expect(selected, 1);
    expect(key.currentState?.nudge(1), isFalse);
    controller.dispose();
  });

  testWidgets('updates options and controller without owning disposal',
      (tester) async {
    final key = GlobalKey<WheelColumnState>();
    final first = FixedExtentScrollController();
    final second = FixedExtentScrollController(initialItem: 1);
    await tester.pumpWidget(MaterialApp(
      home: SizedBox(
        height: 200,
        child: WheelColumn(
          key: key,
          colIndex: 0,
          options: options,
          controller: first,
          itemHeight: 40,
          disabled: false,
          onItemSelected: (_, __, ___) {},
        ),
      ),
    ));
    key.currentState?.applyColumnUpdate(options: options, controller: first);
    key.currentState?.applyColumnUpdate(
      options: const [
        TPickerOption(label: 'C', value: 'c'),
        TPickerOption(label: 'D', value: 'd'),
      ],
      controller: second,
    );
    await tester.pump();

    expect(find.text('D'), findsOneWidget);
    first.dispose();
    second.dispose();
  });

  testWidgets('empty and disabled columns do not move', (tester) async {
    final key = GlobalKey<WheelColumnState>();
    final controller = FixedExtentScrollController();
    await tester.pumpWidget(MaterialApp(
      home: WheelColumn(
        key: key,
        colIndex: 0,
        options: const [],
        controller: controller,
        itemHeight: 40,
        disabled: true,
        onItemSelected: (_, __, ___) {},
      ),
    ));

    expect(find.byType(ListWheelScrollView), findsNothing);
    expect(key.currentState?.nudge(1), isFalse);
    controller.dispose();
  });
}

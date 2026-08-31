import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'date_time_picker_demo_test_spec.dart';
import 'demo_page_test_utils.dart';

void main() {
  registerDemoStructureTests(dateTimePickerDemoPageTestSpec);

  testWidgets('DateTimePicker Demo follows the official instance order', (
    tester,
  ) async {
    await pumpFullDemoPage(
      tester,
      dateTimePickerDemoPageTestSpec,
      ThemeMode.light,
    );
    final finders = [
      find.byKey(const ValueKey('date-time-picker-date-trigger')),
      find.byKey(const ValueKey('date-time-picker-month-trigger')),
      find.byKey(const ValueKey('date-time-picker-second-trigger')),
      find.byKey(const ValueKey('date-time-picker-minute-trigger')),
      find.byKey(const ValueKey('date-time-picker-date-time-trigger')),
      find.byKey(const ValueKey('date-time-picker-steps-trigger')),
      find.byKey(const ValueKey('date-time-picker-inline-panel')),
    ];
    final tops = finders.map((f) => tester.getTopLeft(f).dy).toList();
    expect(tops, orderedEquals([...tops]..sort()));
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('DateTimePicker modes and steps remain explicit', (tester) async {
    await pumpFullDemoPage(
      tester,
      dateTimePickerDemoPageTestSpec,
      ThemeMode.light,
    );
    await tester.tap(
      find.byKey(const ValueKey('date-time-picker-date-trigger')),
    );
    await tester.pumpAndSettle();
    var picker = tester.widget<TDateTimePicker>(
      find.byKey(const ValueKey('date-time-picker-date-panel')),
    );
    expect(picker.mode.dateMode, DateMode.date);
    expect(picker.showWeek, isTrue);
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('date-time-picker-steps-trigger')),
    );
    await tester.pumpAndSettle();
    picker = tester.widget<TDateTimePicker>(
      find.byKey(const ValueKey('date-time-picker-steps-panel')),
    );
    expect(picker.mode.timeMode, TimeMode.second);
    expect(picker.steps, const DateTimePickerSteps(minute: 5));
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('DateTimePicker popup commits only after confirm', (
    tester,
  ) async {
    await pumpFullDemoPage(
      tester,
      dateTimePickerDemoPageTestSpec,
      ThemeMode.light,
    );
    final trigger = find.byKey(
      const ValueKey('date-time-picker-month-trigger'),
    );
    await tester.tap(trigger);
    await tester.pumpAndSettle();
    final panel = find.byKey(const ValueKey('date-time-picker-month-panel'));
    tester.widget<TDateTimePicker>(panel).onChanged!(
      const TDateTimePickerValue(year: 2026, month: 8),
    );
    await tester.pump();
    expect(find.text('2021-09'), findsOneWidget);
    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();
    expect(find.text('2026-08'), findsOneWidget);
    await disposeDemoPage(tester);
  }, tags: 'demo');
}

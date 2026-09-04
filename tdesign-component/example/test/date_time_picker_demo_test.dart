import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/base/notification_center.dart';

import 'date_time_picker_demo_test_spec.dart';
import 'demo_page_test_utils.dart';

void main() {
  registerDemoStructureTests(dateTimePickerDemoPageTestSpec);

  testWidgets('DateTimePicker typography preserves title and body hierarchy', (
    tester,
  ) async {
    await pumpFullDemoPage(
      tester,
      dateTimePickerDemoPageTestSpec,
      ThemeMode.light,
    );
    for (final label in ['01 组件类型', '02 组件样式']) {
      final title = tester.widget<Text>(find.text(label));
      expect(title.style?.fontWeight, FontWeight.w600);
      expect(title.style?.fontSize, 18);
      expect(title.style?.height, 26 / 18);
    }
    final trigger = find.byKey(const ValueKey('date-time-picker-date-trigger'));
    for (final label in ['选择时间', '2022-08-10']) {
      final text = tester.widget<Text>(
        find.descendant(of: trigger, matching: find.text(label)),
      );
      expect(text.style?.fontWeight, FontWeight.w400);
      expect(text.style?.fontSize, 16);
      expect(text.style?.height, 24 / 16);
    }
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('all DateTimePicker code panels load the current core snippet', (
    tester,
  ) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      dateTimePickerDemoPageTestSpec,
      ThemeMode.light,
    );
    final source = await rootBundle.loadString(
      'assets/code/date-time-picker._cell.txt',
    );
    expect(source.trim(), isNotEmpty);
    for (final id in [
      'date',
      'month',
      'month-day',
      'second',
      'minute',
      'date-time',
      'week',
      'title',
      'without-title',
    ]) {
      final trigger = find.byKey(ValueKey('date-time-picker-$id-trigger'));
      for (var attempt = 0; attempt < 12; attempt++) {
        if (trigger.evaluate().isNotEmpty &&
            tester.getRect(trigger).bottom < 760) {
          break;
        }
        await tester.drag(
          find.byType(CustomScrollView).first,
          const Offset(0, -240),
        );
        await tester.pumpAndSettle();
      }
      TNotification.postNotification('onApiVisibleChange', {
        'apiVisible': true,
      });
      await tester.pumpAndSettle();
      final wrapper = find.ancestor(
        of: trigger,
        matching: find.byType(CodeWrapper),
      );
      await tester.tap(
        find.descendant(of: wrapper, matching: find.text('code')),
      );
      await tester.pumpAndSettle();
      final panel = find.byType(Markdown);
      expect(tester.widget<Markdown>(panel).data, contains(source));
      Navigator.of(tester.element(panel)).pop();
      await tester.pumpAndSettle();
    }
    expect(tester.takeException(), isNull);
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets(
    'date_time_picker drag drafts are cancelled or committed by the toolbar',
    (tester) async {
      await pumpDemoPageAtPhoneViewport(
        tester,
        dateTimePickerDemoPageTestSpec,
        ThemeMode.light,
      );
      final trigger = find.byKey(
        const ValueKey('date-time-picker-month-trigger'),
      );
      String note() => tester
          .widgetList<Text>(
            find.descendant(of: trigger, matching: find.byType(Text)),
          )
          .map((text) => text.data ?? '')
          .join('|');
      final initial = note();
      await tester.tap(trigger);
      await tester.pumpAndSettle();
      await tester.drag(
        find.byType(ListWheelScrollView).first,
        const Offset(0, 80),
      );
      await tester.pumpAndSettle();
      expect(note(), initial);
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(note(), initial);
      await tester.tap(trigger);
      await tester.pumpAndSettle();
      await tester.drag(
        find.byType(ListWheelScrollView).first,
        const Offset(0, 80),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(note(), isNot(initial));
      await disposeDemoPage(tester);
    },
    tags: 'demo',
  );

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
      find.byKey(const ValueKey('date-time-picker-month-day-trigger')),
      find.byKey(const ValueKey('date-time-picker-second-trigger')),
      find.byKey(const ValueKey('date-time-picker-minute-trigger')),
      find.byKey(const ValueKey('date-time-picker-date-time-trigger')),
      find.byKey(const ValueKey('date-time-picker-week-trigger')),
      find.byKey(const ValueKey('date-time-picker-title-trigger')),
      find.byKey(const ValueKey('date-time-picker-without-title-trigger')),
    ];
    final tops = finders.map((f) => tester.getTopLeft(f).dy).toList();
    expect(tops, orderedEquals([...tops]..sort()));
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('DateTimePicker modes and weekday labels remain explicit', (
    tester,
  ) async {
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
    expect(picker.showWeek, isFalse);
    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('date-time-picker-week-trigger')),
    );
    await tester.pumpAndSettle();
    picker = tester.widget<TDateTimePicker>(
      find.byKey(const ValueKey('date-time-picker-week-panel')),
    );
    expect(picker.mode.dateMode, DateMode.date);
    expect(picker.showWeek, isTrue);
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
    expect(tester.getSize(panel).height, 200);
    tester.widget<TDateTimePicker>(panel).onChanged!(
      const TDateTimePickerValue(year: 2026, month: 8),
    );
    await tester.pump();
    expect(
      find.descendant(of: trigger, matching: find.text('2022-08')),
      findsOneWidget,
    );
    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();
    expect(find.text('2026-08'), findsOneWidget);
    await disposeDemoPage(tester);
  }, tags: 'demo');
}

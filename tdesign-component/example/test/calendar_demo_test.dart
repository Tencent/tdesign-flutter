import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/calendar/t_calendar_cell.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'calendar_demo_test_spec.dart';
import 'demo_page_test_utils.dart';

void main() {
  configureCalendarDemoResources();
  registerDemoStructureTests(calendarDemoPageTestSpec);

  testWidgets('Calendar 日期点击仅在确认后提交，关闭保留原值', (tester) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      calendarDemoPageTestSpec,
      ThemeMode.light,
    );
    final trigger = find.byKey(const ValueKey('calendar-single-trigger'));
    Future<void> choose() async {
      await tester.tap(trigger);
      await tester.pumpAndSettle();
      final day = find.byWidgetPredicate(
        (widget) =>
            widget is TCalendarCell &&
            widget.cell?.date == DateTime(2022, 2, 20),
      );
      await tester.tap(day);
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TCalendar>(
              find.byKey(const ValueKey('calendar-popup-panel')),
            )
            .value,
        [DateTime(2022, 2, 20)],
      );
      expect(
        find.descendant(of: trigger, matching: find.text('2022-02-18')),
        findsOneWidget,
      );
    }

    await choose();
    await tester.tap(find.byTooltip('关闭'));
    await tester.pumpAndSettle();
    await choose();
    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: trigger, matching: find.text('2022-02-20')),
      findsOneWidget,
    );
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('Calendar 按月切换限制边界且保留已选日期', (tester) async {
    await pumpFullDemoPage(tester, calendarDemoPageTestSpec, ThemeMode.light);
    await tester.tap(find.byKey(const ValueKey('calendar-switch-trigger')));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('上个月'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<IconButton>(
            find.ancestor(
              of: find.byTooltip('上个月'),
              matching: find.byType(IconButton),
            ),
          )
          .onPressed,
      isNull,
    );
    final calendar = tester.widget<TCalendar>(
      find.byKey(const ValueKey('calendar-popup-panel')),
    );
    expect(calendar.minDate, DateTime(2022, 1, 10));
    expect(calendar.maxDate, DateTime(2022, 1, 31));
    expect(calendar.value, [DateTime(2022, 2, 18)]);
    await tester.tap(find.byTooltip('下个月'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TCalendar>(find.byKey(const ValueKey('calendar-popup-panel')))
          .maxDate,
      DateTime(2022, 2, 28),
    );
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('Calendar Demo follows the official trigger order', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, calendarDemoPageTestSpec, ThemeMode.light);

    const keys = [
      'calendar-single-trigger',
      'calendar-multiple-trigger',
      'calendar-single-description-trigger',
      'calendar-double-description-trigger',
      'calendar-switch-trigger',
      'calendar-range-trigger',
      'calendar-localized-trigger',
      'calendar-limited-trigger',
      'calendar-inline-panel',
    ];
    final tops = [
      for (final key in keys) tester.getTopLeft(find.byKey(ValueKey(key))).dy,
    ];
    expect(tops, orderedEquals([...tops]..sort()));
    expect(find.text('单选模式'), findsNothing);
    expect(find.text('滚动控制'), findsNothing);
    expect(find.text('单元测试'), findsNothing);

    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('Calendar popup remains controlled until confirm', (
    tester,
  ) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      calendarDemoPageTestSpec,
      ThemeMode.light,
    );

    await tester.tap(find.byKey(const ValueKey('calendar-single-trigger')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('calendar-popup-panel')), findsOneWidget);
    expect(find.byTooltip('关闭'), findsOneWidget);
    expect(find.text('确定'), findsOneWidget);
    expect(find.text('请选择日期'), findsOneWidget);

    final calendar = tester.widget<TCalendar>(
      find.byKey(const ValueKey('calendar-popup-panel')),
    );
    expect(calendar.variant, TCalendarVariant.single);
    expect(calendar.onChanged, isNotNull);

    await tester.tap(find.byTooltip('关闭'));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('calendar-popup-panel')), findsNothing);
    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('Calendar special demos pass the intended contracts', (
    tester,
  ) async {
    await pumpFullDemoPage(tester, calendarDemoPageTestSpec, ThemeMode.light);

    await tester.tap(find.byKey(const ValueKey('calendar-localized-trigger')));
    await tester.pumpAndSettle();
    expect(find.text('Select Date'), findsOneWidget);
    expect(find.text('Confirm'), findsOneWidget);
    expect(find.text('February 2022'), findsOneWidget);
    expect(find.text('SUN'), findsOneWidget);
    expect(find.text('MON'), findsOneWidget);
    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('calendar-switch-trigger')));
    await tester.pumpAndSettle();
    expect(find.byTooltip('上个月'), findsOneWidget);
    expect(find.byTooltip('下个月'), findsOneWidget);
    await tester.tap(find.byTooltip('关闭'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('calendar-limited-trigger')));
    await tester.pumpAndSettle();
    final limited = tester.widget<TCalendar>(
      find.byKey(const ValueKey('calendar-popup-panel')),
    );
    expect(limited.minDate, DateTime(2022, 2, 18));
    expect(limited.maxDate, DateTime(2022, 3));
    await tester.tap(find.byTooltip('关闭'));
    await tester.pumpAndSettle();

    await disposeDemoPage(tester);
  }, tags: 'demo');
}

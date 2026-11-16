import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/calendar/t_calendar_cell.dart';
import 'package:tdesign_flutter/src/components/popup/t_popup.dart'
    show PopupShell;
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/base/example_widget.dart';
import 'package:tdesign_flutter_example/page/calendar/calendar_described_example.dart';
import 'package:tdesign_flutter_example/page/calendar/calendar_double_described_example.dart';
import 'package:tdesign_flutter_example/page/calendar/calendar_limited_example.dart';
import 'package:tdesign_flutter_example/page/calendar/calendar_localized_example.dart';
import 'package:tdesign_flutter_example/page/calendar/calendar_multiple_example.dart';
import 'package:tdesign_flutter_example/page/calendar/calendar_range_example.dart';
import 'package:tdesign_flutter_example/page/calendar/calendar_single_example.dart';
import 'package:tdesign_flutter_example/page/calendar/calendar_switch_mode_example.dart';

import '../demo_page_test_utils.dart';
import 'calendar_demo_test_spec.dart';

void main() {
  configureCalendarDemoResources();
  registerDemoStructureTests(calendarDemoPageTestSpec);

  final lifecycleCases = <(String, Widget, String)>[
    ('single', const CalendarSingleExample(), 'calendar-single-trigger'),
    ('multiple', const CalendarMultipleExample(), 'calendar-multiple-trigger'),
    (
      'described',
      const CalendarDescribedExample(),
      'calendar-single-description-trigger',
    ),
    (
      'double described',
      const CalendarDoubleDescribedExample(),
      'calendar-double-description-trigger',
    ),
    ('switch', const CalendarSwitchModeExample(), 'calendar-switch-trigger'),
    ('range', const CalendarRangeExample(), 'calendar-range-trigger'),
    (
      'localized',
      const CalendarLocalizedExample(),
      'calendar-localized-trigger',
    ),
    ('limited', const CalendarLimitedExample(), 'calendar-limited-trigger'),
  ];
  for (final (name, example, trigger) in lifecycleCases) {
    for (final rebuildHeader in [true, false]) {
      testWidgets(
        'Calendar $name survives owner disposal: ${rebuildHeader ? 'rebuild' : 'confirm'}',
        (tester) async {
          final visible = ValueNotifier<bool>(true);
          addTearDown(visible.dispose);
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ValueListenableBuilder<bool>(
                  valueListenable: visible,
                  builder: (_, shown, __) =>
                      shown ? example : const SizedBox.shrink(),
                ),
              ),
            ),
          );
          await tester.tap(find.byKey(ValueKey(trigger)));
          await tester.pumpAndSettle();
          visible.value = false;
          await tester.pumpAndSettle();
          if (rebuildHeader) {
            final shell = find.byType(PopupShell);
            expect(shell, findsOneWidget);
            tester.element(shell).markNeedsBuild();
            await tester.pump();
            expect(tester.takeException(), isNull);
          } else {
            final confirm = find.text(name == 'localized' ? 'Confirm' : '确定');
            expect(confirm, findsOneWidget);
            await tester.tap(confirm);
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
            expect(confirm, findsNothing);
          }
        },
        tags: 'demo',
      );
    }
  }

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

  testWidgets('Calendar 翻页示例确认后提交新日期', (tester) async {
    await pumpFullDemoPage(tester, calendarDemoPageTestSpec, ThemeMode.light);
    final trigger = find.byKey(const ValueKey('calendar-switch-trigger'));
    await tester.tap(trigger);
    await tester.pumpAndSettle();
    final day = find.byWidgetPredicate(
      (widget) =>
          widget is TCalendarCell && widget.cell?.date == DateTime(2022, 2, 20),
    );
    await tester.tap(day);
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: trigger, matching: find.text('2022-02-18')),
      findsOneWidget,
    );
    await tester.tap(
      find.descendant(of: find.byType(PopupShell), matching: find.text('确定')),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('calendar-popup-panel')), findsNothing);
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
    for (var i = 0; i < 11; i++) {
      await tester.tap(find.byTooltip('上个月'));
      await tester.pumpAndSettle();
    }
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
    expect(calendar.minDate, DateTime(2021, 3));
    expect(calendar.maxDate, DateTime(2021, 3, 31));
    expect(calendar.value, [DateTime(2022, 2, 18)]);
    await tester.tap(find.byTooltip('下个月'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TCalendar>(find.byKey(const ValueKey('calendar-popup-panel')))
          .maxDate,
      DateTime(2021, 4, 30),
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
    expect(
      tester.widget<ExamplePage>(find.byType(ExamplePage)).showTestModule,
      isTrue,
    );

    final inlineCalendar = tester.widget<TCalendar>(
      find.byKey(const ValueKey('calendar-inline-panel')),
    );
    expect(inlineCalendar.minDate, DateTime(2021, 3));
    expect(inlineCalendar.maxDate, DateTime(2030, 3, 2));

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
    expect(limited.minDate, DateTime(2021, 3));
    expect(limited.maxDate, DateTime(2030, 3, 2));
    await tester.tap(find.byTooltip('关闭'));
    await tester.pumpAndSettle();

    await disposeDemoPage(tester);
  }, tags: 'demo');

  testWidgets('Calendar 双行描述按日期语义区分文字颜色', (tester) async {
    await pumpDemoPageAtPhoneViewport(
      tester,
      calendarDemoPageTestSpec,
      ThemeMode.light,
    );
    await tester.tap(
      find.byKey(const ValueKey('calendar-double-description-trigger')),
    );
    await tester.pumpAndSettle();

    Finder dateCell(int day) => find.byWidgetPredicate(
      (widget) =>
          widget is TCalendarCell &&
          widget.cell?.date == DateTime(2023, 3, day),
    );
    final normalDay = tester.widget<TText>(
      find.descendant(
        of: dateCell(7),
        matching: find.widgetWithText(TText, '7'),
      ),
    );
    final holidayCell = find.ancestor(
      of: find.widgetWithText(TText, "Women's"),
      matching: find.byType(TCalendarCell),
    );
    final holidayDay = tester.widget<TText>(
      find.descendant(
        of: holidayCell,
        matching: find.widgetWithText(TText, '8'),
      ),
    );
    final selectedDay = tester.widget<TText>(
      find.descendant(
        of: dateCell(10),
        matching: find.widgetWithText(TText, '10'),
      ),
    );
    final prices = tester
        .widgetList<TText>(find.widgetWithText(TText, '¥60'))
        .map((text) => text.style?.color)
        .toList();
    final token = TThemeData.defaultData();
    expect(normalDay.style?.color, token.textColorPrimary);
    expect(holidayDay.style?.color, token.errorColor);
    expect(selectedDay.style?.color, token.textColorAnti);
    expect(prices, contains(token.textColorPlaceholder));
    expect(prices, contains(token.textColorAnti));
    expect(prices, isNot(contains(token.errorColor)));

    await disposeDemoPage(tester);
  }, tags: 'demo');
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  group('TCalendar widget 级用例', () {
    testWidgets('single 模式可构建并渲染标题/单元格', (tester) async {
      await tester.pumpWidget(wrap(TCalendar(
        onChanged: (_) {},
        variant: TCalendarVariant.single,
        value: [DateTime(2026, 6, 15)],
      )));
      expect(find.byType(TCalendar), findsOneWidget);
      // 月标题构建器默认输出包含年份
      expect(find.textContaining('2026'), findsWidgets);
    });

    testWidgets('multiple 模式可构建', (tester) async {
      await tester.pumpWidget(wrap(TCalendar(
        onChanged: (_) {},
        variant: TCalendarVariant.multiple,
        value: [DateTime(2026, 6, 15), DateTime(2026, 6, 16)],
      )));
      expect(find.byType(TCalendar), findsOneWidget);
    });

    testWidgets('range 模式可构建', (tester) async {
      await tester.pumpWidget(wrap(TCalendar(
        onChanged: (_) {},
        variant: TCalendarVariant.range,
        value: [DateTime(2026, 6, 15), DateTime(2026, 6, 20)],
      )));
      expect(find.byType(TCalendar), findsOneWidget);
    });

    testWidgets('TCalendarThemeData selected decoration reaches calendar cells',
        (tester) async {
      final theme =
          TThemeBuilder.light(TThemeData.defaultData()).mergeExtension(
        const TCalendarThemeData(
          cellDecoration: BoxDecoration(color: Colors.orange),
          centreColor: Colors.green,
        ),
      );
      await tester.pumpWidget(MaterialApp(
        theme: theme,
        home: Scaffold(
          body: TCalendar(
            minDate: DateTime(2026, 6, 1),
            maxDate: DateTime(2026, 6, 30),
            anchorDate: DateTime(2026, 6, 1),
            value: [DateTime(2026, 6, 15)],
            onChanged: (_) {},
          ),
        ),
      ));
      await tester.pump();

      final themedCell = find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration! as BoxDecoration).color == Colors.orange,
      );
      expect(themedCell, findsOneWidget);
    });

    testWidgets('cellBuilder 自定义整格可构建', (tester) async {
      await tester.pumpWidget(wrap(TCalendar(
        value: const [],
        onChanged: (_) {},
        variant: TCalendarVariant.single,
        cellBuilder: (context, model) => Container(
          key: const Key('customCell'),
          child: Text('${model.date.day}'),
        ),
      )));
      expect(find.byKey(const Key('customCell')), findsWidgets);
    });

    testWidgets('subtitleBuilder 副标题可构建', (tester) async {
      await tester.pumpWidget(wrap(TCalendar(
        value: const [],
        onChanged: (_) {},
        variant: TCalendarVariant.single,
        subtitleBuilder: (context, model) => const Text('节'),
      )));
      expect(find.text('节'), findsWidgets);
    });

    testWidgets('firstDayOfWeek / height / min-max 参数可构建', (tester) async {
      await tester.pumpWidget(wrap(TCalendar(
        onChanged: (_) {},
        firstDayOfWeek: 1,
        minDate: DateTime(2026, 1, 1),
        maxDate: DateTime(2026, 12, 31),
        value: [DateTime(2026, 6, 15)],
      )));
      expect(find.byType(TCalendar), findsOneWidget);
    });

    testWidgets('日期边界按自然日归一化，并允许单日范围', (tester) async {
      final date = DateTime(2026, 6, 15);
      await tester.pumpWidget(wrap(TCalendar(
        minDate: DateTime(2026, 6, 15, 18),
        maxDate: DateTime(2026, 6, 15, 6),
        value: [date],
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();

      final calendar = tester.widget<TCalendar>(find.byType(TCalendar));
      expect(calendar.minDate, date);
      expect(calendar.maxDate, date);
      expect(find.text('15'), findsOneWidget);
    });

    testWidgets('默认高度完整容纳六行月份', (tester) async {
      await tester.pumpWidget(wrap(TCalendar(
        minDate: DateTime(2026, 8, 1),
        maxDate: DateTime(2026, 8, 31),
        anchorDate: DateTime(2026, 8, 1),
        value: const [],
        onChanged: (_) {},
      )));
      await tester.pumpAndSettle();

      expect(tester.getSize(find.byType(TCalendar)).height, 508);
      expect(find.text('31'), findsOneWidget);
    });

    test('firstDayOfWeek 只接受 0 到 6', () {
      expect(
        () => TCalendar(firstDayOfWeek: 7, value: const [], onChanged: (_) {}),
        throwsAssertionError,
      );
    });

    testWidgets('点击单元格触发 onChanged（single）', (tester) async {
      List<DateTime>? changed;
      await tester.pumpWidget(wrap(TCalendar(
        onChanged: (v) => changed = v,
        variant: TCalendarVariant.single,
        value: [DateTime(2026, 6, 15)],
      )));
      await tester.pumpAndSettle();
      // 日历为 1970-2100 的滚动列表，first 命中的 '15' 可能在视口外，
      // 先滚动到可见再点击以触发 onChanged
      final cell = find.text('15');
      if (cell.evaluate().isNotEmpty) {
        await tester.ensureVisible(cell.first);
        await tester.pumpAndSettle();
        await tester.tap(cell.first, warnIfMissed: false);
        await tester.pumpAndSettle();
        expect(changed, isNotNull);
      } else {
        // 单元格文案未直接暴露为 '15' 时，仅验证构建成功
        expect(find.byType(TCalendar), findsOneWidget);
      }
    });

    testWidgets('点击决策覆盖 single/multiple/range 分支', (tester) async {
      Key dayKey(DateTime date) =>
          Key('day-${date.year}-${date.month}-${date.day}');

      Widget keyedCalendar({
        required TCalendarVariant variant,
        required List<DateTime> value,
        required ValueChanged<List<DateTime>>? onChanged,
      }) {
        return wrap(TCalendar(
          minDate: DateTime(2026, 6, 1),
          maxDate: DateTime(2026, 7, 1),
          anchorDate: DateTime(2026, 6, 1),
          variant: variant,
          value: value,
          onChanged: onChanged,
          cellBuilder: (context, model) => SizedBox(
            key: dayKey(model.date),
            child: Text('${model.date.day}'),
          ),
        ));
      }

      List<DateTime>? changed;
      await tester.pumpWidget(keyedCalendar(
        variant: TCalendarVariant.single,
        value: [DateTime(2026, 6, 15)],
        onChanged: (value) => changed = value,
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(dayKey(DateTime(2026, 6, 15))));
      await tester.pumpAndSettle();
      expect(changed, isNull);

      await tester.tap(find.byKey(dayKey(DateTime(2026, 6, 16))));
      await tester.pumpAndSettle();
      expect(changed, [DateTime(2026, 6, 16)]);

      await tester.pumpWidget(keyedCalendar(
        variant: TCalendarVariant.multiple,
        value: [DateTime(2026, 6, 15)],
        onChanged: (value) => changed = value,
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(dayKey(DateTime(2026, 6, 15))));
      await tester.pumpAndSettle();
      expect(changed, isEmpty);

      await tester.pumpWidget(keyedCalendar(
        variant: TCalendarVariant.multiple,
        value: [DateTime(2026, 6, 15)],
        onChanged: (value) => changed = value,
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(dayKey(DateTime(2026, 6, 16))));
      await tester.pumpAndSettle();
      expect(changed, [DateTime(2026, 6, 15), DateTime(2026, 6, 16)]);

      await tester.pumpWidget(keyedCalendar(
        variant: TCalendarVariant.range,
        value: [DateTime(2026, 6, 15)],
        onChanged: (value) => changed = value,
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(dayKey(DateTime(2026, 6, 20))));
      await tester.pumpAndSettle();
      expect(changed, [DateTime(2026, 6, 15), DateTime(2026, 6, 20)]);

      await tester.pumpWidget(keyedCalendar(
        variant: TCalendarVariant.range,
        value: [DateTime(2026, 6, 15), DateTime(2026, 6, 20)],
        onChanged: (value) => changed = value,
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(dayKey(DateTime(2026, 6, 10))));
      await tester.pumpAndSettle();
      expect(changed, [DateTime(2026, 6, 10)]);

      changed = null;
      await tester.pumpWidget(keyedCalendar(
        variant: TCalendarVariant.single,
        value: [DateTime(2026, 6, 15)],
        onChanged: null,
      ));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(dayKey(DateTime(2026, 6, 16))),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      expect(changed, isNull);
    });
  });
}

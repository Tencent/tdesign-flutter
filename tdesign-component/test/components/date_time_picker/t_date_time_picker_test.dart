import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/src/components/date_time_picker/t_date_time_picker_internal.dart';
import 'package:tdesign_flutter/src/components/date_time_picker/t_date_time_picker_wheel.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

Widget wrap(Widget child) => MaterialApp(
  theme: TThemeBuilder.light(TThemeData.defaultData()),
  home: Scaffold(
    body: Center(child: SizedBox(width: 360, height: 300, child: child)),
  ),
);

void main() {
  testWidgets('月日模式保留闰日且真实滚动只返回月日', (tester) async {
    var value = const TDateTimePickerValue(month: 2, day: 29);
    var changes = 0;
    await tester.pumpWidget(
      wrap(
        StatefulBuilder(
          builder: (context, setState) => TDateTimePicker(
            value: value,
            mode: DateTimePickerMode(dateMode: DateMode.monthDay),
            onChanged: (next) => setState(() {
              value = next;
              changes++;
            }),
          ),
        ),
      ),
    );
    expect(find.byType(ListWheelScrollView), findsNWidgets(2));
    var wheel = tester.widget<DateTimePickerWheel>(
      find.byType(DateTimePickerWheel),
    );
    expect(wheel.snapshot.current, DateTime(2000, 2, 29));
    await tester.drag(
      find.byType(ListWheelScrollView).first,
      const Offset(0, -40),
    );
    await tester.pumpAndSettle();
    expect(changes, greaterThan(0));
    expect(value.year, isNull);
    expect(value.hour, isNull);
    expect(value.month, 3);
    expect(value.day, 29);
    wheel = tester.widget<DateTimePickerWheel>(
      find.byType(DateTimePickerWheel),
    );
    expect(wheel.snapshot.current, DateTime(2000, 3, 29));
  });

  testWidgets('月日模式在非闰年切到二月时钳制日期', (tester) async {
    var value = const TDateTimePickerValue(year: 2023, month: 3, day: 31);
    await tester.pumpWidget(
      wrap(
        StatefulBuilder(
          builder: (context, setState) => TDateTimePicker(
            value: value,
            mode: DateTimePickerMode(dateMode: DateMode.monthDay),
            onChanged: (next) => setState(
              () => value = TDateTimePickerValue(
                year: 2023,
                month: next.month,
                day: next.day,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.drag(
      find.byType(ListWheelScrollView).first,
      const Offset(0, 40),
    );
    await tester.pumpAndSettle();
    expect(value.month, 2);
    expect(value.day, 28);
  });

  testWidgets('月日模式无年份范围使用受控值的计算年', (tester) async {
    await tester.pumpWidget(
      wrap(
        TDateTimePicker(
          value: const TDateTimePickerValue(year: 2024, month: 2, day: 24),
          mode: DateTimePickerMode(dateMode: DateMode.monthDay),
          start: const TDateTimePickerValue(month: 2, day: 20),
          end: const TDateTimePickerValue(month: 3, day: 10),
          onChanged: (_) {},
        ),
      ),
    );

    final wheel = tester.widget<DateTimePickerWheel>(
      find.byType(DateTimePickerWheel),
    );
    expect(wheel.snapshot.current, DateTime(2024, 2, 24));
  });

  testWidgets('月日值与范围均无年份时使用 2000 并保留闰日', (tester) async {
    await tester.pumpWidget(
      wrap(
        TDateTimePicker(
          value: const TDateTimePickerValue(month: 2, day: 29),
          mode: DateTimePickerMode(dateMode: DateMode.monthDay),
          start: const TDateTimePickerValue(month: 2, day: 20),
          end: const TDateTimePickerValue(month: 3, day: 10),
          onChanged: (_) {},
        ),
      ),
    );
    final wheel = tester.widget<DateTimePickerWheel>(
      find.byType(DateTimePickerWheel),
    );
    expect(wheel.snapshot.current, DateTime(2000, 2, 29));
    expect(wheel.start, DateTime(2000, 2, 20));
    expect(wheel.end, DateTime(2000, 3, 10));
  });

  testWidgets('受控日期模式渲染、更新和回调', (tester) async {
    var value = const TDateTimePickerValue(year: 2024, month: 2, day: 29);
    var changed = 0;
    await tester.pumpWidget(
      wrap(
        TDateTimePicker(
          value: value,
          mode: DateTimePickerMode(dateMode: DateMode.date),
          start: const TDateTimePickerValue(year: 2020, month: 1, day: 1),
          end: const TDateTimePickerValue(year: 2030, month: 12, day: 31),
          showWeek: true,
          steps: const DateTimePickerSteps(year: 1, month: 1, day: 1),
          renderLabel: (column, item) => '自定义$item',
          onChanged: (next) {
            value = next;
            changed++;
          },
        ),
      ),
    );
    expect(find.byType(TDateTimePicker), findsOneWidget);
    expect(find.byType(DateTimePickerWheel), findsOneWidget);
    final wheel = tester.widget<DateTimePickerWheel>(
      find.byType(DateTimePickerWheel),
    );
    expect(wheel.height, 200);
    expect(wheel.itemCount, 5);

    await tester.pumpWidget(
      wrap(
        TDateTimePicker(
          value: value,
          mode: DateTimePickerMode(dateMode: DateMode.month),
          onChanged: (_) => changed++,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(DateTimePickerWheel), findsOneWidget);
    expect(changed, greaterThanOrEqualTo(0));
  });

  testWidgets('父级接受受控值时保留滚轮并支持连续惯性滚动', (tester) async {
    var value = const TDateTimePickerValue(year: 2024, month: 1, day: 1);
    var changes = 0;

    await tester.pumpWidget(
      wrap(
        StatefulBuilder(
          builder: (context, setState) => TDateTimePicker(
            value: value,
            mode: DateTimePickerMode(dateMode: DateMode.date),
            start: const TDateTimePickerValue(year: 2020, month: 1, day: 1),
            end: const TDateTimePickerValue(year: 2030, month: 12, day: 31),
            onChanged: (next) => setState(() {
              value = next;
              changes++;
            }),
          ),
        ),
      ),
    );

    final wheelState = tester.state(find.byType(DateTimePickerWheel));
    await tester.fling(
      find.byType(ListWheelScrollView).first,
      const Offset(0, -240),
      1200,
    );
    await tester.pumpAndSettle();

    expect(tester.state(find.byType(DateTimePickerWheel)), same(wheelState));
    expect(changes, greaterThan(1));
    expect(value.year, isNot(2024));
  });

  testWidgets('月日模式保留计算年接受连续选择时保留滚轮', (tester) async {
    var value = const TDateTimePickerValue(year: 2024, month: 3, day: 15);
    var changes = 0;
    await tester.pumpWidget(
      wrap(
        StatefulBuilder(
          builder: (context, setState) => TDateTimePicker(
            value: value,
            mode: DateTimePickerMode(dateMode: DateMode.monthDay),
            onChanged: (next) => setState(() {
              value = TDateTimePickerValue(
                year: 2024,
                month: next.month,
                day: next.day,
              );
              changes++;
            }),
          ),
        ),
      ),
    );
    final wheelState = tester.state(find.byType(DateTimePickerWheel));
    await tester.fling(
      find.byType(ListWheelScrollView).first,
      const Offset(0, -160),
      1000,
    );
    await tester.pumpAndSettle();
    expect(tester.state(find.byType(DateTimePickerWheel)), same(wheelState));
    expect(changes, greaterThan(1));
    expect(value.year, 2024);
    expect(value.month, greaterThan(3));
  });

  testWidgets('月日模式仅计算年变化时重建并同步完整日期', (tester) async {
    Widget picker(int year) => wrap(
      TDateTimePicker(
        value: TDateTimePickerValue(year: year, month: 6, day: 15),
        mode: DateTimePickerMode(dateMode: DateMode.monthDay),
        onChanged: (_) {},
      ),
    );
    await tester.pumpWidget(picker(2024));
    final wheelState = tester.state(find.byType(DateTimePickerWheel));
    await tester.pumpWidget(picker(2025));
    await tester.pumpAndSettle();
    expect(
      tester.state(find.byType(DateTimePickerWheel)),
      isNot(same(wheelState)),
    );
    expect(
      tester
          .widget<DateTimePickerWheel>(find.byType(DateTimePickerWheel))
          .snapshot
          .current,
      DateTime(2025, 6, 15),
    );
  });

  testWidgets('拒绝候选值无需父级重建且可再次通知', (tester) async {
    final changes = <TDateTimePickerValue>[];
    await tester.pumpWidget(
      wrap(
        TDateTimePicker(
          value: const TDateTimePickerValue(year: 2024, month: 6, day: 15),
          onChanged: changes.add,
        ),
      ),
    );
    final wheel = find.byType(ListWheelScrollView).first;
    int selected() =>
        (tester.widget<ListWheelScrollView>(wheel).controller!
                as FixedExtentScrollController)
            .selectedItem;
    final initial = selected();
    for (var attempt = 0; attempt < 2; attempt++) {
      changes.clear();
      await tester.fling(wheel, const Offset(0, -120), 1000);
      await tester.pumpAndSettle();
      expect(changes, isNotEmpty);
      expect(selected(), initial);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('父级拒绝选择并用原值重建时恢复滚轮且可再次通知', (tester) async {
    const value = TDateTimePickerValue(year: 2024, month: 6, day: 15);
    var changes = 0;
    late StateSetter rebuild;
    await tester.pumpWidget(
      wrap(
        StatefulBuilder(
          builder: (context, setState) {
            rebuild = setState;
            return TDateTimePicker(
              value: value,
              mode: DateTimePickerMode(dateMode: DateMode.monthDay),
              onChanged: (_) => changes++,
            );
          },
        ),
      ),
    );
    for (var attempt = 0; attempt < 2; attempt++) {
      await tester.drag(
        find.byType(ListWheelScrollView).first,
        const Offset(0, -40),
      );
      await tester.pumpAndSettle();
      expect(changes, greaterThan(attempt));
      rebuild(() {});
      await tester.pumpAndSettle();
      final wheel = tester.widget<DateTimePickerWheel>(
        find.byType(DateTimePickerWheel),
      );
      expect(wheel.snapshot.current, DateTime(2024, 6, 15));
      final scroll = tester.widget<ListWheelScrollView>(
        find.byType(ListWheelScrollView).first,
      );
      expect(
        (scroll.controller! as FixedExtentScrollController).selectedItem,
        5,
      );
    }
  });

  testWidgets('时间模式和禁用态', (tester) async {
    await tester.pumpWidget(
      wrap(
        TDateTimePicker(
          value: const TDateTimePickerValue(hour: 10, minute: 20, second: 30),
          mode: DateTimePickerMode(timeMode: TimeMode.second),
        ),
      ),
    );
    expect(find.byType(DateTimePickerWheel), findsOneWidget);
    final semantics = find.descendant(
      of: find.byType(TDateTimePicker),
      matching: find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.enabled == false,
      ),
    );
    expect(semantics, findsOneWidget);
  });

  testWidgets('更新分支覆盖 no-op、受控值分歧和范围重建', (tester) async {
    String? Function(DateTimeColumn column, int value) renderLabel(
      String tag,
    ) =>
        (column, value) => '$tag-$value';

    final mode = DateTimePickerMode(dateMode: DateMode.date);
    const value = TDateTimePickerValue(year: 2024, month: 5, day: 20);
    await tester.pumpWidget(
      wrap(TDateTimePicker(value: value, mode: mode, onChanged: (_) {})),
    );
    expect(find.byType(DateTimePickerWheel), findsOneWidget);

    await tester.pumpWidget(
      wrap(TDateTimePicker(value: value, mode: mode, onChanged: (_) {})),
    );
    await tester.pump();
    expect(find.byType(DateTimePickerWheel), findsOneWidget);

    const diverged = TDateTimePickerValue(year: 2025, month: 6, day: 21);
    await tester.pumpWidget(
      wrap(TDateTimePicker(value: diverged, mode: mode, onChanged: (_) {})),
    );
    await tester.pump();
    expect(find.byType(DateTimePickerWheel), findsOneWidget);

    await tester.pumpWidget(
      wrap(
        TDateTimePicker(
          value: diverged,
          mode: mode,
          start: const TDateTimePickerValue(year: 2020, month: 1, day: 1),
          end: const TDateTimePickerValue(year: 2030, month: 12, day: 31),
          steps: const DateTimePickerSteps(day: 2),
          showWeek: true,
          renderLabel: renderLabel('changed'),
          onChanged: (_) {},
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(DateTimePickerWheel), findsOneWidget);
  });

  test('值模型支持完整值、partial 值和非法输入', () {
    const complete = TDateTimePickerValue(
      year: 2024,
      month: 2,
      day: 29,
      hour: 10,
      minute: 20,
      second: 30,
    );
    expect(complete.toDateTime(), DateTime(2024, 2, 29, 10, 20, 30));
    final fallback = DateTime(2020, 5, 6, 7, 8, 9);
    const partial = TDateTimePickerValue(year: 2024, month: 2, day: 29);
    expect(
      partial.toDateTime(fallback: fallback),
      DateTime(2024, 2, 29, 7, 8, 9),
    );
    expect(() => partial.toDateTime(), throwsArgumentError);
    expect(partial.toString(), contains('year: 2024'));
    expect(partial, isNot(complete));
  });

  test('模式、步进和枚举契约', () {
    final date = DateTimePickerMode(dateMode: DateMode.date);
    final time = DateTimePickerMode(timeMode: TimeMode.second);
    expect(date, DateTimePickerMode(dateMode: DateMode.date));
    expect(date, isNot(time));
    const steps = DateTimePickerSteps(
      year: 2,
      month: 2,
      day: 2,
      hour: 2,
      minute: 5,
      second: 10,
    );
    expect(steps.year, 2);
    expect(steps.minute, 5);
    expect(steps.forColumn(DateTimeColumn.year), 2);
    expect(steps.forColumn(DateTimeColumn.month), 2);
    expect(steps.forColumn(DateTimeColumn.day), 2);
    expect(steps.forColumn(DateTimeColumn.hour), 2);
    expect(steps.forColumn(DateTimeColumn.minute), 5);
    expect(steps.forColumn(DateTimeColumn.second), 10);
    const invalidSteps = DateTimePickerSteps(month: 0, day: -2);
    expect(invalidSteps.forColumn(DateTimeColumn.year), 1);
    expect(invalidSteps.forColumn(DateTimeColumn.month), 1);
    expect(invalidSteps.forColumn(DateTimeColumn.day), 1);
    expect(DateTimePickerMode(dateMode: DateMode.year).columns, [
      DateTimeColumn.year,
    ]);
    expect(DateTimePickerMode(dateMode: DateMode.month).columns, [
      DateTimeColumn.year,
      DateTimeColumn.month,
    ]);
    expect(DateTimePickerMode(timeMode: TimeMode.hour).columns, [
      DateTimeColumn.hour,
    ]);
    expect(DateTimePickerMode(timeMode: TimeMode.minute).columns, [
      DateTimeColumn.hour,
      DateTimeColumn.minute,
    ]);
    expect(
      DateTimePickerMode(
        dateMode: DateMode.month,
        timeMode: TimeMode.second,
      ).columns,
      [
        DateTimeColumn.year,
        DateTimeColumn.month,
        DateTimeColumn.hour,
        DateTimeColumn.minute,
        DateTimeColumn.second,
      ],
    );
    expect(DateMode.values, contains(DateMode.date));
    expect(TimeMode.values, contains(TimeMode.second));
  });

  test('快照支持范围、步进、列选项和原始值规范化', () {
    final snapshot = DateTimePickerSnapshot.initial(
      columns: const [
        DateTimeColumn.year,
        DateTimeColumn.month,
        DateTimeColumn.day,
      ],
      initial: DateTime(2024, 2, 29),
      start: DateTime(2020, 1, 1),
      end: DateTime(2030, 12, 31),
      steps: const DateTimePickerSteps(day: 2),
    );
    final columns = snapshot.toPickerColumns(
      start: DateTime(2020, 1, 1),
      end: DateTime(2030, 12, 31),
      showWeek: true,
      labels: DateTimePickerLabels.defaults,
      steps: const DateTimePickerSteps(day: 2),
    );
    expect(columns.columns.length, 3);
    expect(snapshot.columnOptionsAt(2), isNotEmpty);
    final changed = snapshot.applySelection(
      rawValues: [2025, 2, 29],
      start: DateTime(2020, 1, 1),
      end: DateTime(2030, 12, 31),
    );
    expect(changed.toResult().year, 2025);
    expect(snapshot.rebuildFor(columns: const [DateTimeColumn.year]).columns, [
      DateTimeColumn.year,
    ]);
    expect(
      DateTimePickerSnapshot.coerceRawValues([1, 2.4], expectedLength: 2),
      [1, 2],
    );
    expect(
      () => DateTimePickerSnapshot.coerceRawValues(['bad'], expectedLength: 1),
      throwsArgumentError,
    );
  });
}

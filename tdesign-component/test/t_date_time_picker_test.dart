import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// 测试在包内，可以直接 import @internal 的 Snapshot 做白盒测试。
import 'package:tdesign_flutter/src/components/date_time_picker/t_date_time_picker_internal.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  // ===========================================================================
  // DateTimePickerMode 契约
  // ===========================================================================
  group('DateTimePickerMode', () {
    test('快捷常量按粒度展开（与 mobile-vue 完全等价）', () {
      expect(DateTimePickerMode.year.columns, [DateTimeColumn.year]);
      expect(DateTimePickerMode.month.columns,
          [DateTimeColumn.year, DateTimeColumn.month]);
      expect(DateTimePickerMode.ymd.columns,
          [DateTimeColumn.year, DateTimeColumn.month, DateTimeColumn.day]);
      expect(DateTimePickerMode.hour.columns, [
        DateTimeColumn.year,
        DateTimeColumn.month,
        DateTimeColumn.day,
        DateTimeColumn.hour,
      ]);
      expect(DateTimePickerMode.minute.columns, [
        DateTimeColumn.year,
        DateTimeColumn.month,
        DateTimeColumn.day,
        DateTimeColumn.hour,
        DateTimeColumn.minute,
      ]);
      expect(DateTimePickerMode.second.columns, [
        DateTimeColumn.year,
        DateTimeColumn.month,
        DateTimeColumn.day,
        DateTimeColumn.hour,
        DateTimeColumn.minute,
        DateTimeColumn.second,
      ]);
    });

    test('combined：仅 date 段', () {
      expect(
        DateTimePickerMode.combined(dateMode: DateMode.year).columns,
        [DateTimeColumn.year],
      );
      expect(
        DateTimePickerMode.combined(dateMode: DateMode.month).columns,
        [DateTimeColumn.year, DateTimeColumn.month],
      );
      expect(
        DateTimePickerMode.combined(dateMode: DateMode.date).columns,
        [DateTimeColumn.year, DateTimeColumn.month, DateTimeColumn.day],
      );
    });

    test('combined：仅 time 段（对齐 mobile-vue [null, mode]）', () {
      expect(
        DateTimePickerMode.combined(timeMode: TimeMode.hour).columns,
        [DateTimeColumn.hour],
      );
      expect(
        DateTimePickerMode.combined(timeMode: TimeMode.minute).columns,
        [DateTimeColumn.hour, DateTimeColumn.minute],
      );
      expect(
        DateTimePickerMode.combined(timeMode: TimeMode.second).columns,
        [DateTimeColumn.hour, DateTimeColumn.minute, DateTimeColumn.second],
      );
    });

    test('combined：date + time 组合按 date→time 顺序拼接', () {
      final cols = DateTimePickerMode.combined(
        dateMode: DateMode.date,
        timeMode: TimeMode.minute,
      ).columns;
      expect(cols, [
        DateTimeColumn.year,
        DateTimeColumn.month,
        DateTimeColumn.day,
        DateTimeColumn.hour,
        DateTimeColumn.minute,
      ]);
    });

    test('combined：date 与 time 同时为 null 触发 assert', () {
      expect(
        () => DateTimePickerMode.combined(),
        throwsAssertionError,
      );
    });

    test('快捷模式与组合模式具备稳定相等性与 hashCode', () {
      final a = ShortcutMode(date: DateMode.date, time: TimeMode.minute);
      final b = ShortcutMode(date: DateMode.date, time: TimeMode.minute);
      final c = CombinedMode(date: DateMode.date, time: TimeMode.minute);
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a, isNot(equals(c)));
      final c2 = CombinedMode(date: DateMode.date, time: TimeMode.minute);
      expect(c.hashCode, equals(c2.hashCode));
    });
  });

  // ===========================================================================
  // TDateTimePickerValue
  // ===========================================================================
  group('TDateTimePickerValue', () {
    test('toDateTime 使用 fallback 避免缺字段时溢出', () {
      const v = TDateTimePickerValue(year: 2026, month: 2);
      final dt = v.toDateTime(fallback: DateTime(2000, 1, 1));
      expect(dt, DateTime(2026, 2, 1));
    });

    test('toDateTime 字段溢出陷阱：不带安全 fallback 时可能漂移', () {
      // fallback 为 5/31，month=2 但 day 沿用 31 → 溢出到 3/3
      const v = TDateTimePickerValue(year: 2026, month: 2);
      final dt = v.toDateTime(fallback: DateTime(2026, 5, 31));
      expect(dt.month, 3);
      expect(dt.day, 3);
    });

    test('toDateTime().weekday 用于派生星期', () {
      const v = TDateTimePickerValue(year: 2026, month: 5, day: 15);
      // 2026-05-15 是周五
      expect(v.toDateTime().weekday, 5);
    });

    test('相等性比较包含全部字段', () {
      final a = TDateTimePickerValue(year: 2026, month: 5, day: 15);
      final b = TDateTimePickerValue(year: 2026, month: 5, day: 15);
      final c = TDateTimePickerValue(year: 2026, month: 5, day: 16);
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
      expect(a.hashCode, equals(b.hashCode));
      expect(a.toString(), contains('TDateTimePickerValue(year: 2026'));
    });
  });

  // ===========================================================================
  // DateTimePickerSnapshot - 单一真相源契约（internal 但行为关键）
  // ===========================================================================
  group('DateTimePickerSnapshot', () {
    test('initial 创建时把 current 钳制到 [start, end]', () {
      final s = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode.ymd.columns,
        initial: DateTime(2030, 1, 1),
        end: DateTime(2026, 12, 31),
      );
      expect(s.current, DateTime(2026, 12, 31));
    });

    test('initial 在 start > end 时 debug 下抛 assert', () {
      expect(
        () => DateTimePickerSnapshot.initial(
          columns: DateTimePickerMode.ymd.columns,
          start: DateTime(2027),
          end: DateTime(2025),
        ),
        throwsAssertionError,
      );
    });

    test('values 按 columns 投影 current', () {
      final s = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode.minute.columns,
        initial: DateTime(2026, 5, 15, 10, 30),
      );
      expect(s.values, [2026, 5, 15, 10, 30]);
    });

    test('applySelection：picker rawValues 合并到 snapshot，自动处理日溢出', () {
      final s0 = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode.ymd.columns,
        initial: DateTime(2026, 5, 31),
      );
      // 切到 2 月，应自动 clamp 到 28 日（非闰年）
      final s1 = s0.applySelection(rawValues: const [2026, 2, 31]);
      expect(s1.current, DateTime(2026, 2, 28));
    });

    test('applySelection：钳制到 [start, end]', () {
      final s0 = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode.ymd.columns,
        initial: DateTime(2026, 5, 15),
        start: DateTime(2026, 5, 10),
        end: DateTime(2026, 5, 20),
      );
      final s1 = s0.applySelection(
        rawValues: const [2026, 5, 25],
        start: DateTime(2026, 5, 10),
        end: DateTime(2026, 5, 20),
      );
      expect(s1.current.day, 20);
    });

    test('相等性：同 columns + 同 current → 相等', () {
      final a = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode.ymd.columns,
        initial: DateTime(2026, 5, 15),
      );
      final b = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode.ymd.columns,
        initial: DateTime(2026, 5, 15),
      );
      expect(a, equals(b));
    });

    test('needsColumnRebuildFrom：年/月变化触发', () {
      final s0 = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode.ymd.columns,
        initial: DateTime(2026, 5, 15),
      );
      final s1 = s0.applySelection(rawValues: const [2026, 6, 15]);
      expect(s1.needsColumnRebuildFrom(s0), isTrue);

      final s2 = s0.applySelection(rawValues: const [2026, 5, 20]);
      expect(s2.needsColumnRebuildFrom(s0), isFalse);
    });

    test('needsColumnRebuildFrom：showWeek=true 时 day 变化也触发（label 含周几）',
        () {
      final s0 = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode.ymd.columns,
        initial: DateTime(2026, 5, 15),
      );
      final s1 = s0.applySelection(rawValues: const [2026, 5, 20]);
      expect(s1.needsColumnRebuildFrom(s0, showWeek: true), isTrue);
      expect(s1.needsColumnRebuildFrom(s0, showWeek: false), isFalse);
    });

    test('toPickerColumns：年列默认 ±10 年范围（锚定打开时的年份）', () {
      final s = DateTimePickerSnapshot.initial(
        columns: const [DateTimeColumn.year],
        initial: DateTime(2026, 1, 1),
      );
      final cols = s.toPickerColumns();
      expect(cols.columns[0].first.value, 2016);
      expect(cols.columns[0].last.value, 2036);
    });

    test('滚动年份后年列范围不随 current.year 漂移', () {
      final s0 = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode.ymd.columns,
        initial: DateTime(2026, 5, 15),
      );
      final s1 = s0.applySelection(rawValues: const [2020, 5, 15]);
      final yearCol0 = s0.toPickerColumns().columns[0];
      final yearCol1 = s1.toPickerColumns().columns[0];
      expect(yearCol0.first.value, 2016);
      expect(yearCol0.last.value, 2036);
      expect(yearCol1.first.value, 2016);
      expect(yearCol1.last.value, 2036);
      expect(s1.yearAnchor, 2026);
    });

    test('toPickerColumns：跨年时月列范围为 1-12', () {
      final s = DateTimePickerSnapshot.initial(
        columns: const [DateTimeColumn.year, DateTimeColumn.month],
        initial: DateTime(2026, 5, 15),
        start: DateTime(2024, 6, 1),
        end: DateTime(2026, 8, 31),
      );
      final cols = s.toPickerColumns(
        start: DateTime(2024, 6, 1),
        end: DateTime(2026, 8, 31),
      );
      // current.year = 2026 = end.year，所以 endMonth = 8；不与 start.year 同，
      // 所以 startMonth = 1
      expect(cols.columns[1].first.value, 1);
      expect(cols.columns[1].last.value, 8);
    });

    test('toPickerColumns：当前 = 边界同月时日列只显示边界 day', () {
      final s = DateTimePickerSnapshot.initial(
        columns: const [
          DateTimeColumn.year,
          DateTimeColumn.month,
          DateTimeColumn.day,
        ],
        initial: DateTime(2024, 6, 5),
        start: DateTime(2024, 6, 5),
        end: DateTime(2024, 6, 20),
      );
      final cols = s.toPickerColumns(
        start: DateTime(2024, 6, 5),
        end: DateTime(2024, 6, 20),
      );
      expect(cols.columns[2].first.value, 5);
      expect(cols.columns[2].last.value, 20);
    });

    test('toPickerColumns：showWeek=true 时日列 label 含周几', () {
      // 2026-05-15 是周五
      final s = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode.ymd.columns,
        initial: DateTime(2026, 5, 15),
      );
      final cols = s.toPickerColumns(showWeek: true);
      // 找 value=15 的 option
      final option15 = cols.columns[2].firstWhere((o) => o.value == 15);
      expect(option15.label, '15日 周五');
    });

    test('toPickerColumns：showWeek=false 时日列 label 仅含「N日」', () {
      final s = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode.ymd.columns,
        initial: DateTime(2026, 5, 15),
      );
      final cols = s.toPickerColumns();
      final option15 = cols.columns[2].firstWhere((o) => o.value == 15);
      expect(option15.label, '15日');
    });

    test('toResult 把 snapshot 转回 TDateTimePickerValue（无 week 字段）', () {
      final s = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode.ymd.columns,
        initial: DateTime(2026, 5, 15),
      );
      final r = s.toResult();
      expect(r.year, 2026);
      expect(r.month, 5);
      expect(r.day, 15);
      expect(r.hour, isNull);
      expect(r.minute, isNull);
    });

    test('toResult 在 second 模式返回完整时分秒', () {
      final s = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode.second.columns,
        initial: DateTime(2026, 5, 15, 10, 20, 30),
      );
      final r = s.toResult();
      expect(r.hour, 10);
      expect(r.minute, 20);
      expect(r.second, 30);
    });

    test('coerceRawValues：int / num 可规范为 int', () {
      expect(
        DateTimePickerSnapshot.coerceRawValues(
          [2026.0, 5.0, 15.0],
          expectedLength: 3,
        ),
        [2026, 5, 15],
      );
    });

    test('coerceRawValues：非法类型抛 ArgumentError', () {
      expect(
        () => DateTimePickerSnapshot.coerceRawValues(
          ['bad'],
          expectedLength: 1,
        ),
        throwsArgumentError,
      );
    });

    test('相等性：yearAnchor 纳入比较', () {
      final a = DateTimePickerSnapshot.initial(
        columns: const [DateTimeColumn.year],
        initial: DateTime(2026, 1, 1),
      );
      final b = a.applySelection(rawValues: const [2020]);
      expect(a.yearAnchor, 2026);
      expect(b.yearAnchor, 2026);
      expect(a == b, isFalse);
      expect(a.hashCode, isNot(b.hashCode));
    });

    test('rebuildFor 会保留 yearAnchor 并按新范围钳制 current', () {
      final s0 = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode.ymd.columns,
        initial: DateTime(2026, 5, 15),
      );
      final s1 = s0.rebuildFor(
        columns: DateTimePickerMode.second.columns,
        start: DateTime(2026, 6, 1),
        end: DateTime(2026, 6, 30, 23, 59, 59),
      );
      expect(s1.yearAnchor, s0.yearAnchor);
      expect(s1.current, DateTime(2026, 6, 1));
      expect(s1.columns, DateTimePickerMode.second.columns);
    });

    test('toPickerColumns 在时分秒边界上按同日/同小时/同分钟收紧', () {
      final s = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode.second.columns,
        initial: DateTime(2026, 5, 15, 10, 20, 35),
        start: DateTime(2026, 5, 15, 10, 20, 30),
        end: DateTime(2026, 5, 15, 10, 20, 40),
      );
      final cols = s.toPickerColumns(
        start: DateTime(2026, 5, 15, 10, 20, 30),
        end: DateTime(2026, 5, 15, 10, 20, 40),
      );
      // 年月日
      expect(cols.columns[0].first.value, 2026);
      expect(cols.columns[1].first.value, 5);
      expect(cols.columns[2].first.value, 15);
      // 小时被限定到 10
      expect(cols.columns[3].first.value, 10);
      expect(cols.columns[3].last.value, 10);
      // 分钟被限定到 20
      expect(cols.columns[4].first.value, 20);
      expect(cols.columns[4].last.value, 20);
      // 秒被限定到 30..40
      expect(cols.columns[5].first.value, 30);
      expect(cols.columns[5].last.value, 40);
    });

    test('second 模式 applySelection 会解析时分秒列', () {
      final s0 = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode.second.columns,
        initial: DateTime(2026, 5, 15, 10, 20, 30),
      );
      final s1 = s0.applySelection(
        rawValues: const [2026, 5, 15, 12, 34, 56],
      );
      expect(s1.current, DateTime(2026, 5, 15, 12, 34, 56));
    });

    test('day 列自定义 format 优先于默认文案（含 showWeek）', () {
      final s = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode.ymd.columns,
        initial: DateTime(2026, 5, 15),
      );
      final cols = s.toPickerColumns(
        showWeek: true,
        format: (column, value) =>
            column == DateTimeColumn.day ? 'D$value' : '$value',
      );
      final option15 = cols.columns[2].firstWhere((o) => o.value == 15);
      expect(option15.label, 'D15');
    });

    test('toString 包含关键字段', () {
      final s = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode.ymd.columns,
        initial: DateTime(2026, 5, 15),
      );
      final text = s.toString();
      expect(text, contains('DateTimePickerSnapshot(columns:'));
      expect(text, contains('yearAnchor: 2026'));
    });
  });

  // ===========================================================================
  // TDateTimePicker 集成
  // ===========================================================================
  group('TDateTimePicker 集成', () {
    TPickerValue _pickerValue(List<int> values) {
      final options = values
          .map((v) => TPickerOption(label: '$v', value: v))
          .toList(growable: false);
      return TPickerValue(selectedOptions: options, indexes: List.filled(values.length, 0));
    }

    testWidgets('基础渲染：date 模式产生 3 列（年月日）', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TDateTimePicker(
            mode: DateTimePickerMode.ymd,
            defaultValue: DateTime(2026, 5, 15),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(ListWheelScrollView), findsNWidgets(3));
    });

    testWidgets('combined(timeMode: minute)：只渲染 2 列（时分），对齐 mobile-vue [null, "minute"]',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TDateTimePicker(
            mode: DateTimePickerMode.combined(timeMode: TimeMode.minute),
            defaultValue: DateTime(2026, 5, 15, 10, 30),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(ListWheelScrollView), findsNWidgets(2));
    });

    testWidgets('showWeek=true：列数仍是 3，但日列 label 含周几', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TDateTimePicker(
            mode: DateTimePickerMode.ymd,
            defaultValue: DateTime(2026, 5, 15),
            showWeek: true,
          ),
        ),
      ));
      await tester.pumpAndSettle();
      // 列数：年 + 月 + 日（star，不再有独立 week 列）
      expect(find.byType(ListWheelScrollView), findsNWidgets(3));
      // 2026-05-15 是周五；中央选中日的 label 应含「周五」
      expect(find.textContaining('周五'), findsWidgets);
    });

    testWidgets('点 confirm 插槽派发 TDateTimePickerValue', (tester) async {
      TDateTimePickerValue? captured;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TDateTimePicker(
            mode: DateTimePickerMode.ymd,
            defaultValue: DateTime(2026, 5, 15),
            confirm: const Text('确定'),
            onConfirm: (v) => captured = v,
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text('确定'));
      expect(captured?.year, 2026);
      expect(captured?.month, 5);
      expect(captured?.day, 15);
    });

    testWidgets('confirm Widget 插槽可正常显示并触发', (tester) async {
      var confirmed = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TDateTimePicker(
            mode: DateTimePickerMode.ymd,
            defaultValue: DateTime(2026, 5, 15),
            confirm: const Icon(Icons.check),
            onConfirm: (_) => confirmed = true,
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.check), findsOneWidget);
      await tester.tap(find.byIcon(Icons.check));
      expect(confirmed, isTrue);
    });

    testWidgets('defaultValue 超过 end 时被钳制到 end', (tester) async {
      TDateTimePickerValue? captured;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TDateTimePicker(
            mode: DateTimePickerMode.ymd,
            defaultValue: DateTime(2030, 12, 31),
            end: DateTime(2026, 12, 31),
            confirm: const Text('确定'),
            onConfirm: (v) => captured = v,
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text('确定'));
      expect(captured?.year, 2026);
    });

    testWidgets('format 自定义列 label', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TDateTimePicker(
            mode: DateTimePickerMode.combined(dateMode: DateMode.year),
            defaultValue: DateTime(2026, 1, 1),
            format: (col, v) => 'Y$v',
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Y2026'), findsWidgets);
    });

    testWidgets('onCancel 点击取消按钮触发回调', (tester) async {
      var cancelled = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TDateTimePicker(
            mode: DateTimePickerMode.ymd,
            defaultValue: DateTime(2026, 5, 15),
            cancel: const Text('取消'),
            onCancel: () => cancelled = true,
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text('取消'));
      expect(cancelled, isTrue);
    });

    testWidgets('format 变更后 label 随之更新', (tester) async {
      var useAltFormat = false;
      await tester.pumpWidget(MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              body: Column(
                children: [
                  TextButton(
                    onPressed: () => setState(() => useAltFormat = true),
                    child: const Text('toggle-format'),
                  ),
                  TDateTimePicker(
                    mode: DateTimePickerMode.combined(dateMode: DateMode.year),
                    defaultValue: DateTime(2026, 1, 1),
                    format: useAltFormat
                        ? (col, v) => 'ALT$v'
                        : (col, v) => 'BASE$v',
                  ),
                ],
              ),
            );
          },
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('BASE2026'), findsWidgets);
      expect(find.text('ALT2026'), findsNothing);

      await tester.tap(find.text('toggle-format'));
      await tester.pumpAndSettle();
      expect(find.text('ALT2026'), findsWidgets);
      expect(find.text('BASE2026'), findsNothing);
    });

    testWidgets('TDateTimePicker.weekLabels 与 showWeek 文案一致', (tester) async {
      expect(TDateTimePicker.weekLabels, DateTimePickerSnapshot.weekLabels);
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TDateTimePicker(
            mode: DateTimePickerMode.ymd,
            defaultValue: DateTime(2026, 5, 15),
            showWeek: true,
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(TDateTimePicker.weekLabels[4]), // 2026-05-15 周五
        findsWidgets,
      );
    });

    testWidgets('onChange 对非法日期先回弹，再在有效变化时触发回调', (tester) async {
      TDateTimePickerValue? changed;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TDateTimePicker(
            mode: DateTimePickerMode.ymd,
            defaultValue: DateTime(2026, 2, 28),
            onChange: (v) => changed = v,
          ),
        ),
      ));
      await tester.pumpAndSettle();
      final picker = tester.widget<TPicker>(find.byType(TPicker));
      picker.onChange?.call(_pickerValue([2026, 2, 31]));
      await tester.pump();
      // 2/31 会被归一化回 2/28，与当前值一致，因此不触发 onChange。
      expect(changed, isNull);

      // 传入有效变化值后触发 onChange。
      picker.onChange?.call(_pickerValue([2026, 3, 1]));
      await tester.pump();
      expect(changed?.year, 2026);
      expect(changed?.month, 3);
      expect(changed?.day, 1);
    });

    testWidgets('onConfirm 在值变化时采用归一化结果', (tester) async {
      TDateTimePickerValue? confirmed;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TDateTimePicker(
            mode: DateTimePickerMode.ymd,
            defaultValue: DateTime(2026, 2, 28),
            onConfirm: (v) => confirmed = v,
          ),
        ),
      ));
      await tester.pumpAndSettle();
      final picker = tester.widget<TPicker>(find.byType(TPicker));
      picker.onConfirm?.call(_pickerValue([2026, 3, 1]));
      await tester.pump();
      expect(confirmed?.month, 3);
      expect(confirmed?.day, 1);
    });

    testWidgets('mode/defaultValue 变化会触发内部重建并更新 initialValue', (tester) async {
      var useMonth = false;
      var defaultValue = DateTime(2026, 5, 15);
      await tester.pumpWidget(MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: Column(
              children: [
                TextButton(
                  onPressed: () => setState(() {
                    useMonth = true;
                    defaultValue = DateTime(2027, 6, 1);
                  }),
                  child: const Text('switch'),
                ),
                TDateTimePicker(
                  mode: useMonth ? DateTimePickerMode.month : DateTimePickerMode.ymd,
                  defaultValue: defaultValue,
                ),
              ],
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text('switch'));
      await tester.pumpAndSettle();
      final picker = tester.widget<TPicker>(find.byType(TPicker));
      expect(picker.initialValue, [2027, 6]);
    });

    testWidgets('仅 range 变化时会按新边界收紧列范围', (tester) async {
      DateTime start = DateTime(2024, 1, 1);
      DateTime end = DateTime(2026, 12, 31);
      await tester.pumpWidget(MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: Column(
              children: [
                TextButton(
                  onPressed: () => setState(() {
                    start = DateTime(2026, 1, 1);
                    end = DateTime(2026, 1, 31);
                  }),
                  child: const Text('tighten-range'),
                ),
                TDateTimePicker(
                  mode: DateTimePickerMode.ymd,
                  defaultValue: DateTime(2026, 5, 15),
                  start: start,
                  end: end,
                ),
              ],
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text('tighten-range'));
      await tester.pumpAndSettle();
      final picker = tester.widget<TPicker>(find.byType(TPicker));
      final items = picker.items as TPickerColumns;
      // 收紧后年列仅 2026
      expect(items.columns[0].first.value, 2026);
      expect(items.columns[0].last.value, 2026);
    });
  });
}

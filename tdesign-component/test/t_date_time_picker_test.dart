import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// 测试在包内，可以直接 import @internal 的 Snapshot 做白盒测试。
import 'package:tdesign_flutter/src/components/date_time_picker/t_date_time_picker_internal.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import 'helpers/popup_test_resource.dart';

/// 测试用：从 [DateTime] 构造 [TDateTimePickerValue]。
TDateTimePickerValue valueFromDateTime(DateTime dt) => TDateTimePickerValue(
      year: dt.year,
      month: dt.month,
      day: dt.day,
      hour: dt.hour,
      minute: dt.minute,
      second: dt.second,
    );

/// dateMode × timeMode 全组合及期望列数。
final _allModeColumnCases =
    <({DateTimePickerMode mode, int columns, String label})>[
  (
    mode: DateTimePickerMode(dateMode: DateMode.year),
    columns: 1,
    label: 'year'
  ),
  (
    mode: DateTimePickerMode(dateMode: DateMode.month),
    columns: 2,
    label: 'month'
  ),
  (
    mode: DateTimePickerMode(dateMode: DateMode.date),
    columns: 3,
    label: 'date'
  ),
  (
    mode: DateTimePickerMode(timeMode: TimeMode.hour),
    columns: 1,
    label: 'hour'
  ),
  (
    mode: DateTimePickerMode(timeMode: TimeMode.minute),
    columns: 2,
    label: 'minute'
  ),
  (
    mode: DateTimePickerMode(timeMode: TimeMode.second),
    columns: 3,
    label: 'second'
  ),
  (
    mode: DateTimePickerMode(dateMode: DateMode.year, timeMode: TimeMode.hour),
    columns: 2,
    label: 'year+hour',
  ),
  (
    mode:
        DateTimePickerMode(dateMode: DateMode.year, timeMode: TimeMode.minute),
    columns: 3,
    label: 'year+minute',
  ),
  (
    mode:
        DateTimePickerMode(dateMode: DateMode.year, timeMode: TimeMode.second),
    columns: 4,
    label: 'year+second',
  ),
  (
    mode: DateTimePickerMode(dateMode: DateMode.month, timeMode: TimeMode.hour),
    columns: 3,
    label: 'month+hour',
  ),
  (
    mode:
        DateTimePickerMode(dateMode: DateMode.month, timeMode: TimeMode.minute),
    columns: 4,
    label: 'month+minute',
  ),
  (
    mode:
        DateTimePickerMode(dateMode: DateMode.month, timeMode: TimeMode.second),
    columns: 5,
    label: 'month+second',
  ),
  (
    mode: DateTimePickerMode(dateMode: DateMode.date, timeMode: TimeMode.hour),
    columns: 4,
    label: 'date+hour',
  ),
  (
    mode:
        DateTimePickerMode(dateMode: DateMode.date, timeMode: TimeMode.minute),
    columns: 5,
    label: 'date+minute',
  ),
  (
    mode:
        DateTimePickerMode(dateMode: DateMode.date, timeMode: TimeMode.second),
    columns: 6,
    label: 'date+second',
  ),
];

/// 挂载 [TDateTimePicker] 并等待布局稳定。
Future<void> pumpDateTimePicker(
  WidgetTester tester, {
  required DateTimePickerMode mode,
  TDateTimePickerValue? value,
  TDateTimePickerValue? start,
  TDateTimePickerValue? end,
  bool showWeek = false,
  DateTimePickerSteps? steps,
  DateTimePickerRenderLabel? renderLabel,
  void Function(TDateTimePickerValue)? onChanged,
  double? height,
  int? itemCount,
}) async {
  await tester.pumpWidget(MaterialApp(
    theme: ThemeData(
      extensions: [
        TThemeData.defaultData(),
        TPickerThemeData(height: height, itemCount: itemCount),
      ],
    ),
    home: Scaffold(
      body: TDateTimePicker(
        mode: mode,
        value: value ?? valueFromDateTime(DateTime(2025, 1, 1)),
        start: start,
        end: end,
        showWeek: showWeek,
        steps: steps,
        renderLabel: renderLabel,
        onChanged: onChanged,
      ),
    ),
  ));
  await tester.pumpAndSettle();
}

void main() {
  // ===========================================================================
  // DateTimePickerMode 契约
  // ===========================================================================
  group('DateTimePickerMode', () {
    test('dateMode / timeMode 组合展开列（与 mobile-vue 等价）', () {
      expect(DateTimePickerMode(dateMode: DateMode.year).columns,
          [DateTimeColumn.year]);
      expect(DateTimePickerMode(dateMode: DateMode.month).columns,
          [DateTimeColumn.year, DateTimeColumn.month]);
      expect(DateTimePickerMode(dateMode: DateMode.date).columns,
          [DateTimeColumn.year, DateTimeColumn.month, DateTimeColumn.day]);
      expect(
          DateTimePickerMode(dateMode: DateMode.date, timeMode: TimeMode.hour)
              .columns,
          [
            DateTimeColumn.year,
            DateTimeColumn.month,
            DateTimeColumn.day,
            DateTimeColumn.hour,
          ]);
      expect(
          DateTimePickerMode(dateMode: DateMode.date, timeMode: TimeMode.minute)
              .columns,
          [
            DateTimeColumn.year,
            DateTimeColumn.month,
            DateTimeColumn.day,
            DateTimeColumn.hour,
            DateTimeColumn.minute,
          ]);
      expect(
          DateTimePickerMode(dateMode: DateMode.date, timeMode: TimeMode.second)
              .columns,
          [
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
        DateTimePickerMode(dateMode: DateMode.year).columns,
        [DateTimeColumn.year],
      );
      expect(
        DateTimePickerMode(dateMode: DateMode.month).columns,
        [DateTimeColumn.year, DateTimeColumn.month],
      );
      expect(
        DateTimePickerMode(dateMode: DateMode.date).columns,
        [DateTimeColumn.year, DateTimeColumn.month, DateTimeColumn.day],
      );
    });

    test('combined：仅 time 段（对齐 mobile-vue [null, mode]）', () {
      expect(
        DateTimePickerMode(timeMode: TimeMode.hour).columns,
        [DateTimeColumn.hour],
      );
      expect(
        DateTimePickerMode(timeMode: TimeMode.minute).columns,
        [DateTimeColumn.hour, DateTimeColumn.minute],
      );
      expect(
        DateTimePickerMode(timeMode: TimeMode.second).columns,
        [DateTimeColumn.hour, DateTimeColumn.minute, DateTimeColumn.second],
      );
    });

    test('combined：date + time 组合按 date→time 顺序拼接', () {
      final cols = DateTimePickerMode(
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

    test('combined：dateMode 与 timeMode 同时为 null 触发 assert', () {
      expect(
        DateTimePickerMode.new,
        throwsAssertionError,
      );
    });

    test('同配置 factory 在 == / hashCode 上一致', () {
      expect(
        DateTimePickerMode(dateMode: DateMode.date),
        equals(DateTimePickerMode(dateMode: DateMode.date)),
      );
      expect(
        DateTimePickerMode(dateMode: DateMode.date).hashCode,
        DateTimePickerMode(dateMode: DateMode.date).hashCode,
      );
      expect(
        DateTimePickerMode(dateMode: DateMode.date, timeMode: TimeMode.minute),
        equals(DateTimePickerMode(
          dateMode: DateMode.date,
          timeMode: TimeMode.minute,
        )),
      );
    });

    test('同配置 mode 在 Set 中去重', () {
      final modes = {
        DateTimePickerMode(dateMode: DateMode.date),
        DateTimePickerMode(dateMode: DateMode.date),
      };
      expect(modes.length, 1);
    });

    test('不同配置的 mode 仍不相等', () {
      expect(
        DateTimePickerMode(dateMode: DateMode.date),
        isNot(equals(DateTimePickerMode(dateMode: DateMode.month))),
      );
      expect(
        DateTimePickerMode(timeMode: TimeMode.minute),
        isNot(equals(DateTimePickerMode(timeMode: TimeMode.hour))),
      );
    });

    test('dateMode × timeMode 全组合列数', () {
      for (final c in _allModeColumnCases) {
        expect(
          c.mode.columns.length,
          c.columns,
          reason: '${c.label} 期望 ${c.columns} 列',
        );
      }
    });
  });

  group('DateTimePickerSteps', () {
    test('forColumn 未配置或非法步进时返回 1', () {
      const steps = DateTimePickerSteps();
      expect(steps.forColumn(DateTimeColumn.year), 1);
      expect(steps.forColumn(DateTimeColumn.minute), 1);
      expect(
        const DateTimePickerSteps(minute: 0).forColumn(DateTimeColumn.minute),
        1,
      );
      expect(
        const DateTimePickerSteps(hour: -3).forColumn(DateTimeColumn.hour),
        1,
      );
    });

    test('相等性与 hashCode', () {
      const a = DateTimePickerSteps(minute: 5, second: 10);
      const b = DateTimePickerSteps(minute: 5, second: 10);
      const c = DateTimePickerSteps(minute: 10);
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(equals(c)));
    });
  });

  group('DateTimePickerLabels', () {
    test('fromResource：中文与 defaults 一致', () {
      final labels =
          DateTimePickerLabels.fromResource(PopupTestResourceDelegate.zh());
      expect(labels, equals(DateTimePickerLabels.defaults));
      expect(labels.formatColumn(DateTimeColumn.year, 2026), '2026年');
      expect(labels.weekdayLabel(5), '周五');
    });

    test('fromResource：英文缩写', () {
      final labels =
          DateTimePickerLabels.fromResource(PopupTestResourceDelegate.en());
      expect(labels.formatColumn(DateTimeColumn.year, 2026), '2026y');
      expect(labels.formatColumn(DateTimeColumn.day, 15), '15d');
      expect(labels.formatColumn(DateTimeColumn.hour, 10), '10h');
      expect(labels.weekdayLabel(5), 'FRI');
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

    test('toDateTime 字段溢出陷阱：不安全 fallback 仍可能漂移', () {
      // fallback 为 5/31，month=2 但 day 沿用 31 → 溢出到 3/3
      const v = TDateTimePickerValue(year: 2026, month: 2);
      final dt = v.toDateTime(fallback: DateTime(2026, 5, 31));
      expect(dt.month, 3);
      expect(dt.day, 3);
    });

    test('toDateTime partial 未传 fallback 时抛出 ArgumentError', () {
      const v = TDateTimePickerValue(year: 2026, month: 2);
      expect(() => v.toDateTime(), throwsArgumentError);
    });

    test('toDateTime(fallback) 用户传入时补齐缺字段', () {
      const v = TDateTimePickerValue(year: 2026, month: 2);
      expect(
        v.toDateTime(fallback: DateTime(2000, 1, 15, 12, 0, 0)),
        DateTime(2026, 2, 15, 12, 0, 0),
      );
    });

    test('toDateTime(fallback) 用于派生 weekday', () {
      const v = TDateTimePickerValue(year: 2026, month: 5, day: 15);
      // 2026-05-15 是周五
      expect(v.toDateTime(fallback: DateTime(2000, 1, 1)).weekday, 5);
    });

    test('toDateTime 完整六元组忽略 fallback', () {
      const v = TDateTimePickerValue(
        year: 2026,
        month: 5,
        day: 15,
        hour: 10,
        minute: 30,
        second: 0,
      );
      expect(
        v.toDateTime(fallback: DateTime(2000, 1, 1)),
        DateTime(2026, 5, 15, 10, 30, 0),
      );
    });

    test('六元组构造后可 toDateTime', () {
      const v = TDateTimePickerValue(
        year: 2026,
        month: 5,
        day: 15,
        hour: 10,
        minute: 30,
        second: 5,
      );
      expect(v.toDateTime(), DateTime(2026, 5, 15, 10, 30, 5));
    });

    test('相等性比较包含全部字段', () {
      const a = TDateTimePickerValue(year: 2026, month: 5, day: 15);
      const b = TDateTimePickerValue(year: 2026, month: 5, day: 15);
      const c = TDateTimePickerValue(year: 2026, month: 5, day: 16);
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
        columns: DateTimePickerMode(dateMode: DateMode.date).columns,
        initial: DateTime(2030, 1, 1),
        end: DateTime(2026, 12, 31),
      );
      expect(s.current, DateTime(2026, 12, 31));
    });

    test('initial 在 start > end 时 debug 下抛 assert', () {
      expect(
        () => DateTimePickerSnapshot.initial(
          columns: DateTimePickerMode(dateMode: DateMode.date).columns,
          start: DateTime(2027),
          end: DateTime(2025),
        ),
        throwsAssertionError,
      );
    });

    test('values 按 columns 投影 current', () {
      final s = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode(
                dateMode: DateMode.date, timeMode: TimeMode.minute)
            .columns,
        initial: DateTime(2026, 5, 15, 10, 30),
      );
      expect(s.values, [2026, 5, 15, 10, 30]);
    });

    test('applySelection：picker rawValues 合并到 snapshot，自动处理日溢出', () {
      final s0 = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode(dateMode: DateMode.date).columns,
        initial: DateTime(2026, 5, 31),
      );
      // 切到 2 月，应自动 clamp 到 28 日（非闰年）
      final s1 = s0.applySelection(rawValues: const [2026, 2, 31]);
      expect(s1.current, DateTime(2026, 2, 28));
    });

    test('applySelection：钳制到 [start, end]', () {
      final s0 = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode(dateMode: DateMode.date).columns,
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
        columns: DateTimePickerMode(dateMode: DateMode.date).columns,
        initial: DateTime(2026, 5, 15),
      );
      final b = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode(dateMode: DateMode.date).columns,
        initial: DateTime(2026, 5, 15),
      );
      expect(a, equals(b));
    });

    test('needsColumnRebuildFrom：年/月变化触发', () {
      final s0 = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode(dateMode: DateMode.date).columns,
        initial: DateTime(2026, 5, 15),
      );
      final s1 = s0.applySelection(rawValues: const [2026, 6, 15]);
      expect(s1.needsColumnRebuildFrom(s0), isTrue);

      final s2 = s0.applySelection(rawValues: const [2026, 5, 20]);
      expect(s2.needsColumnRebuildFrom(s0), isFalse);
    });

    test('columnIndicesWithChangedOptions：月变仅日列，日变默认无列', () {
      final cols = DateTimePickerMode(dateMode: DateMode.date).columns;
      final s0 = DateTimePickerSnapshot.initial(
        columns: cols,
        initial: DateTime(2026, 5, 15),
      );
      final s1 = s0.applySelection(rawValues: const [2026, 6, 15]);
      expect(
        s1.columnIndicesWithChangedOptions(s0),
        {cols.indexOf(DateTimeColumn.day)},
      );

      final s2 = s0.applySelection(rawValues: const [2026, 5, 20]);
      expect(s2.columnIndicesWithChangedOptions(s0), isEmpty);
    });

    test('columnIndicesWithChangedOptions：列结构变化返回全部新列', () {
      final date = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode(dateMode: DateMode.date).columns,
        initial: DateTime(2026, 5, 15),
      );
      final month = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode(dateMode: DateMode.month).columns,
        initial: DateTime(2026, 5, 1),
      );

      expect(month.columnIndicesWithChangedOptions(date), {0, 1});
    });

    test('窄范围内没有步进倍数时保留范围起点', () {
      final snapshot = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode(timeMode: TimeMode.minute).columns,
        initial: DateTime(2026, 1, 1, 10, 2),
        start: DateTime(2026, 1, 1, 10, 2),
        end: DateTime(2026, 1, 1, 10, 3),
      );
      final columns = snapshot.toPickerColumns(
        start: DateTime(2026, 1, 1, 10, 2),
        end: DateTime(2026, 1, 1, 10, 3),
        steps: const DateTimePickerSteps(minute: 5),
      );

      expect(columns.columns.last.single.value, 2);
    });

    test('needsColumnRebuildFrom：showWeek=true 时 day 变化也触发（label 含周几）', () {
      final s0 = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode(dateMode: DateMode.date).columns,
        initial: DateTime(2026, 5, 15),
      );
      final s1 = s0.applySelection(rawValues: const [2026, 5, 20]);
      expect(s1.needsColumnRebuildFrom(s0, showWeek: true), isTrue);
      expect(s1.needsColumnRebuildFrom(s0, showWeek: false), isFalse);
    });

    test('needsColumnRebuildFrom：showWeek=true 时年/月变化也触发日列 label 重建', () {
      final cols = DateTimePickerMode(dateMode: DateMode.date).columns;
      final s0 = DateTimePickerSnapshot.initial(
        columns: cols,
        initial: DateTime(2026, 5, 15),
      );
      final s1 = s0.applySelection(rawValues: const [2025, 5, 15]);
      expect(s1.needsColumnRebuildFrom(s0, showWeek: true), isTrue);
      expect(
        s1.columnIndicesWithChangedOptions(s0, showWeek: true),
        {cols.indexOf(DateTimeColumn.day)},
      );
      expect(s1.needsColumnRebuildFrom(s0, showWeek: false), isFalse);
    });

    test('toPickerColumns：showWeek=true 时切换年份后日列 label 随 weekday 更新', () {
      // 2026-05-15 周五；2025-05-15 周四
      final s0 = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode(dateMode: DateMode.date).columns,
        initial: DateTime(2026, 5, 15),
      );
      final s1 = s0.applySelection(rawValues: const [2025, 5, 15]);
      final dayCol0 = s0.toPickerColumns(showWeek: true).columns[2];
      final dayCol1 = s1.toPickerColumns(showWeek: true).columns[2];
      final opt0 = dayCol0.firstWhere((o) => o.value == 15);
      final opt1 = dayCol1.firstWhere((o) => o.value == 15);
      expect(opt0.label, '15日 周五');
      expect(opt1.label, '15日 周四');
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
        columns: DateTimePickerMode(dateMode: DateMode.date).columns,
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
        columns: DateTimePickerMode(dateMode: DateMode.date).columns,
        initial: DateTime(2026, 5, 15),
      );
      final cols = s.toPickerColumns(showWeek: true);
      // 找 value=15 的 option
      final option15 = cols.columns[2].firstWhere((o) => o.value == 15);
      expect(option15.label, '15日 周五');
    });

    test('toPickerColumns：showWeek=false 时日列 label 仅含「N日」', () {
      final s = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode(dateMode: DateMode.date).columns,
        initial: DateTime(2026, 5, 15),
      );
      final cols = s.toPickerColumns();
      final option15 = cols.columns[2].firstWhere((o) => o.value == 15);
      expect(option15.label, '15日');
    });

    test('toResult 把 snapshot 转回 TDateTimePickerValue（无 week 字段）', () {
      final s = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode(dateMode: DateMode.date).columns,
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
        columns: DateTimePickerMode(
                dateMode: DateMode.date, timeMode: TimeMode.second)
            .columns,
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
        columns: DateTimePickerMode(dateMode: DateMode.date).columns,
        initial: DateTime(2026, 5, 15),
      );
      final s1 = s0.rebuildFor(
        columns: DateTimePickerMode(
                dateMode: DateMode.date, timeMode: TimeMode.second)
            .columns,
        start: DateTime(2026, 6, 1),
        end: DateTime(2026, 6, 30, 23, 59, 59),
      );
      expect(s1.yearAnchor, s0.yearAnchor);
      expect(s1.current, DateTime(2026, 6, 1));
      expect(
          s1.columns,
          DateTimePickerMode(dateMode: DateMode.date, timeMode: TimeMode.second)
              .columns);
    });

    test('toPickerColumns 在时分秒边界上按同日/同小时/同分钟收紧', () {
      final s = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode(
                dateMode: DateMode.date, timeMode: TimeMode.second)
            .columns,
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
        columns: DateTimePickerMode(
                dateMode: DateMode.date, timeMode: TimeMode.second)
            .columns,
        initial: DateTime(2026, 5, 15, 10, 20, 30),
      );
      final s1 = s0.applySelection(
        rawValues: const [2026, 5, 15, 12, 34, 56],
      );
      expect(s1.current, DateTime(2026, 5, 15, 12, 34, 56));
    });

    test('renderLabel 优先于默认文案（含 showWeek）', () {
      final s = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode(dateMode: DateMode.date).columns,
        initial: DateTime(2026, 5, 15),
      );
      final cols = s.toPickerColumns(
        showWeek: true,
        renderLabel: (column, value) =>
            column == DateTimeColumn.day ? 'D$value' : '$value',
      );
      final option15 = cols.columns[2].firstWhere((o) => o.value == 15);
      expect(option15.label, 'D15');
    });

    test('toString 包含关键字段', () {
      final s = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode(dateMode: DateMode.date).columns,
        initial: DateTime(2026, 5, 15),
      );
      final text = s.toString();
      expect(text, contains('DateTimePickerSnapshot(columns:'));
      expect(text, contains('yearAnchor: 2026'));
    });

    test('steps：分钟步进 5 且 respect start/end', () {
      final s = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode(timeMode: TimeMode.minute).columns,
        initial: DateTime(2000, 1, 1, 10, 7),
        start: DateTime(2000, 1, 1, 9, 30),
        end: DateTime(2000, 1, 1, 10, 45),
        steps: const DateTimePickerSteps(minute: 5),
      );
      final cols = s.toPickerColumns(
        start: DateTime(2000, 1, 1, 9, 30),
        end: DateTime(2000, 1, 1, 10, 45),
        steps: const DateTimePickerSteps(minute: 5),
      );
      final minuteValues = cols.columns[1].map((o) => o.value).toList();
      expect(minuteValues, [0, 5, 10, 15, 20, 25, 30, 35, 40, 45]);
      expect(s.current.minute, 5);
    });

    test('steps：applySelection 吸附到最近步进点', () {
      final s0 = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode(timeMode: TimeMode.minute).columns,
        initial: DateTime(2000, 1, 1, 10, 0),
        steps: const DateTimePickerSteps(minute: 5),
      );
      final s1 = s0.applySelection(
        rawValues: const [10, 7],
        steps: const DateTimePickerSteps(minute: 5),
      );
      expect(s1.current.minute, 5);
    });

    test('仅时分模式：start/end 按时钟分量收紧', () {
      final s = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode(timeMode: TimeMode.minute).columns,
        initial: DateTime(2000, 1, 1, 10, 30),
        start: DateTime(2000, 1, 1, 9, 0),
        end: DateTime(2000, 1, 1, 18, 0),
      );
      final cols = s.toPickerColumns(
        start: DateTime(2000, 1, 1, 9, 0),
        end: DateTime(2000, 1, 1, 18, 0),
      );
      expect(cols.columns[0].first.value, 9);
      expect(cols.columns[0].last.value, 18);
    });

    test('边界年：起始年月份从 start.month 起', () {
      final s = DateTimePickerSnapshot.initial(
        columns: const [DateTimeColumn.year, DateTimeColumn.month],
        initial: DateTime(2024, 8, 1),
        start: DateTime(2024, 6, 1),
        end: DateTime(2026, 8, 31),
      );
      final cols = s.toPickerColumns(
        start: DateTime(2024, 6, 1),
        end: DateTime(2026, 8, 31),
      );
      expect(cols.columns[1].first.value, 6);
      expect(cols.columns[1].last.value, 12);
    });

    test('toPickerColumns 与 columnOptionsAt 生成等价 options', () {
      final s = DateTimePickerSnapshot.initial(
        columns: const [
          DateTimeColumn.year,
          DateTimeColumn.month,
          DateTimeColumn.day,
        ],
        initial: DateTime(2026, 5, 15),
        start: DateTime(2024, 1, 1),
        end: DateTime(2028, 12, 31),
      );
      final batch = s.toPickerColumns(
        start: DateTime(2024, 1, 1),
        end: DateTime(2028, 12, 31),
      );
      for (var i = 0; i < s.columns.length; i++) {
        final single = s.columnOptionsAt(
          i,
          start: DateTime(2024, 1, 1),
          end: DateTime(2028, 12, 31),
        );
        expect(
          single.map((o) => o.value),
          batch.columns[i].map((o) => o.value),
        );
        expect(
          single.map((o) => o.label),
          batch.columns[i].map((o) => o.label),
        );
      }
    });

    test('needsColumnRebuildFrom：showWeek=true 时月变化也触发日列 label 重建', () {
      final cols = DateTimePickerMode(dateMode: DateMode.date).columns;
      final s0 = DateTimePickerSnapshot.initial(
        columns: cols,
        initial: DateTime(2026, 5, 15),
      );
      final s1 = s0.applySelection(rawValues: const [2026, 6, 15]);
      expect(s1.needsColumnRebuildFrom(s0, showWeek: true), isTrue);
      expect(
        s1.columnIndicesWithChangedOptions(s0, showWeek: true),
        {cols.indexOf(DateTimeColumn.day)},
      );
    });

    test('needsColumnRebuildFrom：年变化触发月列及日列重建', () {
      final cols = DateTimePickerMode(dateMode: DateMode.date).columns;
      final s0 = DateTimePickerSnapshot.initial(
        columns: cols,
        initial: DateTime(2026, 5, 15),
        start: DateTime(2024, 6, 1),
        end: DateTime(2026, 8, 31),
      );
      final s1 = s0.applySelection(
        rawValues: const [2024, 5, 15],
        start: DateTime(2024, 6, 1),
        end: DateTime(2026, 8, 31),
      );
      expect(
        s1.columnIndicesWithChangedOptions(
          s0,
          start: DateTime(2024, 6, 1),
          end: DateTime(2026, 8, 31),
        ),
        {
          cols.indexOf(DateTimeColumn.month),
          cols.indexOf(DateTimeColumn.day),
        },
      );
    });

    test('needsColumnRebuildFrom：date+time 模式下日变化触发时列重建', () {
      final cols =
          DateTimePickerMode(dateMode: DateMode.date, timeMode: TimeMode.minute)
              .columns;
      final s0 = DateTimePickerSnapshot.initial(
        columns: cols,
        initial: DateTime(2026, 5, 15, 10, 30),
        start: DateTime(2026, 5, 15, 9, 0),
        end: DateTime(2026, 5, 16, 18, 0),
      );
      final s1 = s0.applySelection(
        rawValues: const [2026, 5, 16, 10, 30],
        start: DateTime(2026, 5, 15, 9, 0),
        end: DateTime(2026, 5, 16, 18, 0),
      );
      final changed = s1.columnIndicesWithChangedOptions(
        s0,
        start: DateTime(2026, 5, 15, 9, 0),
        end: DateTime(2026, 5, 16, 18, 0),
      );
      expect(changed, {cols.indexOf(DateTimeColumn.hour)});
    });

    test('跨月自定义范围：中间月日/时/分/秒不受边界收紧', () {
      final start = DateTime(2025, 6, 10, 9, 30, 0);
      final end = DateTime(2025, 8, 25, 18, 45, 30);
      final cols = DateTimePickerMode(
        dateMode: DateMode.date,
        timeMode: TimeMode.second,
      ).columns;
      final s = DateTimePickerSnapshot.initial(
        columns: cols,
        initial: DateTime(2025, 7, 15, 12, 0, 0),
        start: start,
        end: end,
      );
      final pickerCols = s.toPickerColumns(start: start, end: end);
      expect(pickerCols.columns[1].first.value, 6);
      expect(pickerCols.columns[1].last.value, 8);
      expect(pickerCols.columns[2].first.value, 1);
      expect(pickerCols.columns[2].last.value, 31);
      expect(pickerCols.columns[3].first.value, 0);
      expect(pickerCols.columns[3].last.value, 23);
      expect(pickerCols.columns[4].first.value, 0);
      expect(pickerCols.columns[4].last.value, 59);
      expect(pickerCols.columns[5].first.value, 0);
      expect(pickerCols.columns[5].last.value, 59);
    });

    test('跨月自定义范围：起始边界日逐级收紧', () {
      final start = DateTime(2025, 6, 10, 9, 30, 0);
      final end = DateTime(2025, 8, 25, 18, 45, 30);
      final cols = DateTimePickerMode(
        dateMode: DateMode.date,
        timeMode: TimeMode.second,
      ).columns;
      final s = DateTimePickerSnapshot.initial(
        columns: cols,
        initial: DateTime(2025, 6, 10, 9, 30, 0),
        start: start,
        end: end,
      );
      final pickerCols = s.toPickerColumns(start: start, end: end);
      expect(pickerCols.columns[2].first.value, 10);
      expect(pickerCols.columns[2].last.value, 30);
      expect(pickerCols.columns[3].first.value, 9);
      expect(pickerCols.columns[3].last.value, 23);
      expect(pickerCols.columns[4].first.value, 30);
      expect(pickerCols.columns[4].last.value, 59);
      expect(pickerCols.columns[5].first.value, 0);
      expect(pickerCols.columns[5].last.value, 59);
    });

    test('跨月自定义范围：结束边界日逐级收紧', () {
      final start = DateTime(2025, 6, 10, 9, 30, 0);
      final end = DateTime(2025, 8, 25, 18, 45, 30);
      final cols = DateTimePickerMode(
        dateMode: DateMode.date,
        timeMode: TimeMode.second,
      ).columns;
      final s = DateTimePickerSnapshot.initial(
        columns: cols,
        initial: DateTime(2025, 8, 25, 18, 45, 30),
        start: start,
        end: end,
      );
      final pickerCols = s.toPickerColumns(start: start, end: end);
      expect(pickerCols.columns[2].first.value, 1);
      expect(pickerCols.columns[2].last.value, 25);
      expect(pickerCols.columns[3].first.value, 0);
      expect(pickerCols.columns[3].last.value, 18);
      expect(pickerCols.columns[4].first.value, 0);
      expect(pickerCols.columns[4].last.value, 45);
      expect(pickerCols.columns[5].first.value, 0);
      expect(pickerCols.columns[5].last.value, 30);
    });

    test('showWeek 在无日列的 month 模式下不影响月列 label', () {
      final s = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode(dateMode: DateMode.month).columns,
        initial: DateTime(2026, 5, 15),
      );
      final cols = s.toPickerColumns(showWeek: true);
      expect(cols.columns.length, 2);
      expect(cols.columns[1].every((o) => !o.label.contains('周')), isTrue);
    });

    test('daysInMonth 闰年与大小月', () {
      expect(DateTimePickerSnapshot.daysInMonth(2024, 2), 29);
      expect(DateTimePickerSnapshot.daysInMonth(2026, 2), 28);
      expect(DateTimePickerSnapshot.daysInMonth(2026, 4), 30);
      expect(DateTimePickerSnapshot.daysInMonth(2026, 1), 31);
    });

    test('clampDateTime 同时受 start/end 约束', () {
      expect(
        DateTimePickerSnapshot.clampDateTime(
          DateTime(2026, 5, 15),
          start: DateTime(2026, 5, 10),
          end: DateTime(2026, 5, 20),
        ),
        DateTime(2026, 5, 15),
      );
      expect(
        DateTimePickerSnapshot.clampDateTime(
          DateTime(2026, 5, 5),
          start: DateTime(2026, 5, 10),
          end: DateTime(2026, 5, 20),
        ),
        DateTime(2026, 5, 10),
      );
      expect(
        DateTimePickerSnapshot.clampDateTime(
          DateTime(2026, 5, 25),
          start: DateTime(2026, 5, 10),
          end: DateTime(2026, 5, 20),
        ),
        DateTime(2026, 5, 20),
      );
    });

    test('toResult 仅投影当前 mode 所含列', () {
      final yearOnly = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode(dateMode: DateMode.year).columns,
        initial: DateTime(2026, 5, 15, 10, 30, 5),
      ).toResult();
      expect(yearOnly.year, 2026);
      expect(yearOnly.month, isNull);
      expect(yearOnly.day, isNull);
      expect(yearOnly.hour, isNull);

      final timeOnly = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode(timeMode: TimeMode.minute).columns,
        initial: DateTime(2026, 5, 15, 10, 30),
      ).toResult();
      expect(timeOnly.year, isNull);
      expect(timeOnly.hour, 10);
      expect(timeOnly.minute, 30);
    });

    test('applySelection 闰年 2/29 切到非闰年钳到 2/28', () {
      final s0 = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode(dateMode: DateMode.date).columns,
        initial: DateTime(2024, 2, 29),
      );
      final s1 = s0.applySelection(rawValues: const [2026, 2, 29]);
      expect(s1.current, DateTime(2026, 2, 28));
    });

    test('steps：秒列步进 10', () {
      const steps = DateTimePickerSteps(second: 10);
      final s = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode(timeMode: TimeMode.second).columns,
        initial: DateTime(2000, 1, 1, 10, 0, 7),
        steps: steps,
      );
      final cols = s.toPickerColumns(steps: steps);
      expect(
        cols.columns[2].map((o) => o.value),
        [0, 10, 20, 30, 40, 50],
      );
      expect(s.current.second, 10);
    });

    test('time-only second：切换小时后分钟/秒列范围变化', () {
      final cols = DateTimePickerMode(timeMode: TimeMode.second).columns;
      final s0 = DateTimePickerSnapshot.initial(
        columns: cols,
        initial: DateTime(2000, 1, 1, 10, 20, 30),
        start: DateTime(2000, 1, 1, 9, 15, 0),
        end: DateTime(2000, 1, 1, 10, 45, 50),
      );
      final s1 = s0.applySelection(
        rawValues: const [9, 20, 30],
        start: DateTime(2000, 1, 1, 9, 15, 0),
        end: DateTime(2000, 1, 1, 10, 45, 50),
      );
      final minuteCol = s1
          .toPickerColumns(
            start: DateTime(2000, 1, 1, 9, 15, 0),
            end: DateTime(2000, 1, 1, 10, 45, 50),
          )
          .columns[1];
      final secondCol = s1
          .toPickerColumns(
            start: DateTime(2000, 1, 1, 9, 15, 0),
            end: DateTime(2000, 1, 1, 10, 45, 50),
          )
          .columns[2];
      expect(minuteCol.first.value, 15);
      expect(minuteCol.last.value, 59);
      expect(secondCol.first.value, 0);
      expect(secondCol.last.value, 59);
    });

    test('coerceRawValues：长度不足时按实际 raw 长度返回', () {
      expect(
        DateTimePickerSnapshot.coerceRawValues([2026], expectedLength: 3),
        [2026],
      );
    });

    test('applySelection 相同 rawValues 返回相等 snapshot', () {
      final s0 = DateTimePickerSnapshot.initial(
        columns: DateTimePickerMode(dateMode: DateMode.date).columns,
        initial: DateTime(2026, 5, 15),
      );
      final s1 = s0.applySelection(rawValues: const [2026, 5, 15]);
      expect(s1, equals(s0));
    });
  });

  // ===========================================================================
  // TDateTimePicker 集成
  // ===========================================================================
  group('TDateTimePicker 集成', () {
    testWidgets('基础渲染：date 模式产生 3 列（年月日）', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TDateTimePicker(
            mode: DateTimePickerMode(dateMode: DateMode.date),
            value: valueFromDateTime(DateTime(2026, 5, 15)),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(ListWheelScrollView), findsNWidgets(3));
    });

    testWidgets(
        'combined(timeMode: minute)：只渲染 2 列（时分），对齐 mobile-vue [null, "minute"]',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TDateTimePicker(
            mode: DateTimePickerMode(timeMode: TimeMode.minute),
            value: valueFromDateTime(DateTime(2026, 5, 15, 10, 30)),
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
            mode: DateTimePickerMode(dateMode: DateMode.date),
            value: valueFromDateTime(DateTime(2026, 5, 15)),
            showWeek: true,
          ),
        ),
      ));
      await tester.pumpAndSettle();
      // 列数：年 + 月 + 日（不再有独立 week 列）
      expect(find.byType(ListWheelScrollView), findsNWidgets(3));
      // 2026-05-15 是周五；中央选中日的 label 应含「周五」
      expect(find.textContaining('周五'), findsWidgets);
    });

    testWidgets('不渲染确定/取消工具栏', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TDateTimePicker(
            mode: DateTimePickerMode(dateMode: DateMode.date),
            value: valueFromDateTime(DateTime(2026, 5, 15)),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('确定'), findsNothing);
      expect(find.text('取消'), findsNothing);
    });

    testWidgets('mode 缺省为 date（年月日）', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TDateTimePicker(
            value: valueFromDateTime(DateTime(2026, 5, 15)),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(ListWheelScrollView), findsNWidgets(3));
    });

    testWidgets('renderLabel 自定义列 label', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TDateTimePicker(
            mode: DateTimePickerMode(dateMode: DateMode.year),
            value: valueFromDateTime(DateTime(2026, 1, 1)),
            renderLabel: (column, v) =>
                column == DateTimeColumn.year ? 'Y$v' : null,
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Y2026'), findsWidgets);
    });

    testWidgets('英文 resource 下渲染英文列 label', (tester) async {
      bindPopupTestResource(PopupTestResourceDelegate.en());
      addTearDown(resetPopupTestResource);
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TDateTimePicker(
            mode: DateTimePickerMode(dateMode: DateMode.date),
            value: valueFromDateTime(DateTime(2026, 5, 15)),
            showWeek: true,
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.textContaining('2026y'), findsWidgets);
      expect(find.textContaining('FRI'), findsWidgets);
    });

    testWidgets('showWeek 默认中文日列 label 含周几', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TDateTimePicker(
            mode: DateTimePickerMode(dateMode: DateMode.date),
            value: valueFromDateTime(DateTime(2026, 5, 15)),
            showWeek: true,
          ),
        ),
      ));
      await tester.pumpAndSettle();
      // 2026-05-15 是周五
      expect(find.textContaining('周五'), findsWidgets);
    });

    testWidgets('onChanged 滚动后触发回调', (tester) async {
      TDateTimePickerValue? changed;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TDateTimePicker(
            mode: DateTimePickerMode(dateMode: DateMode.date),
            value: valueFromDateTime(DateTime(2026, 2, 28)),
            onChanged: (v) => changed = v,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      final wheels = find.byType(ListWheelScrollView);
      expect(wheels, findsNWidgets(3));
      await tester.drag(wheels.at(1), const Offset(0, -80));
      await tester.pumpAndSettle();

      expect(changed, isNotNull);
      expect(changed!.month, isNot(2));
    });

    testWidgets('onChanged 初始挂载与相同 props 的父 rebuild 不重复触发', (tester) async {
      var callCount = 0;
      await tester.pumpWidget(MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: Column(
              children: [
                TextButton(
                  onPressed: () => setState(() {}),
                  child: const Text('rebuild'),
                ),
                TDateTimePicker(
                  mode: DateTimePickerMode(dateMode: DateMode.date),
                  value: valueFromDateTime(DateTime(2026, 5, 15)),
                  onChanged: (_) => callCount++,
                ),
              ],
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(callCount, 0);

      await tester.tap(find.text('rebuild'));
      await tester.pumpAndSettle();
      expect(callCount, 0);
    });

    testWidgets('onChanged 为滚轮列提供 Semantics', (tester) async {
      final semanticsHandle = tester.ensureSemantics();
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TDateTimePicker(
            mode: DateTimePickerMode(dateMode: DateMode.date),
            value: valueFromDateTime(DateTime(2026, 5, 15)),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('日期时间选择器'), findsOneWidget);
      expect(find.bySemanticsLabel(RegExp('年份')), findsWidgets);
      semanticsHandle.dispose();
    });

    testWidgets('partial value 年月回显到滚轮', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TDateTimePicker(
            mode: DateTimePickerMode(dateMode: DateMode.month),
            value: const TDateTimePickerValue(year: 2026, month: 2),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.textContaining('2026'), findsWidgets);
      expect(find.textContaining('2月'), findsWidgets);
    });

    testWidgets('mode 从 date 切换为 time 时滚轮重建', (tester) async {
      var mode = DateTimePickerMode(dateMode: DateMode.date);
      await tester.pumpWidget(MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: Column(
              children: [
                TextButton(
                  onPressed: () => setState(() {
                    mode = DateTimePickerMode(timeMode: TimeMode.minute);
                  }),
                  child: const Text('to-time'),
                ),
                TDateTimePicker(
                  mode: mode,
                  value: valueFromDateTime(
                    DateTime(2026, 5, 15, 10, 30),
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(ListWheelScrollView), findsNWidgets(3));

      await tester.tap(find.text('to-time'));
      await tester.pumpAndSettle();
      expect(find.byType(ListWheelScrollView), findsNWidgets(2));
    });

    testWidgets('滚动日列触发 onChanged 并更新 day', (tester) async {
      TDateTimePickerValue? changed;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TDateTimePicker(
            mode: DateTimePickerMode(dateMode: DateMode.date),
            value: valueFromDateTime(DateTime(2024, 2, 15)),
            onChanged: (v) => changed = v,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      final wheels = find.byType(ListWheelScrollView);
      await tester.drag(wheels.at(2), const Offset(0, -80));
      await tester.pumpAndSettle();

      expect(changed, isNotNull);
      expect(changed!.day, isNot(15));
    });

    testWidgets('steps 分钟步进 5 时滚轮仍正常渲染', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TDateTimePicker(
            mode: DateTimePickerMode(timeMode: TimeMode.minute),
            value: valueFromDateTime(DateTime(2026, 5, 15, 10, 30)),
            steps: const DateTimePickerSteps(minute: 5),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(ListWheelScrollView), findsNWidgets(2));
      expect(find.textContaining('30分'), findsWidgets);
    });

    testWidgets('value 变化会同步滚轮选中', (tester) async {
      var value = const TDateTimePickerValue(year: 2026, month: 5, day: 15);
      await tester.pumpWidget(MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: Column(
              children: [
                TextButton(
                  onPressed: () => setState(() {
                    value = const TDateTimePickerValue(
                        year: 2027, month: 6, day: 1);
                  }),
                  child: const Text('reset-picker'),
                ),
                TDateTimePicker(
                  mode: DateTimePickerMode(dateMode: DateMode.date),
                  value: value,
                ),
              ],
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.textContaining('2026'), findsWidgets);

      await tester.tap(find.text('reset-picker'));
      await tester.pumpAndSettle();
      expect(find.textContaining('2027'), findsWidgets);
      expect(find.textContaining('6月'), findsWidgets);
    });

    testWidgets('mode/value 变化会同步重建滚轮', (tester) async {
      var useMonth = false;
      var value = valueFromDateTime(DateTime(2026, 5, 15));
      await tester.pumpWidget(MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: Column(
              children: [
                TextButton(
                  onPressed: () => setState(() {
                    useMonth = true;
                    value = valueFromDateTime(DateTime(2027, 6, 1));
                  }),
                  child: const Text('switch'),
                ),
                TDateTimePicker(
                  mode: useMonth
                      ? DateTimePickerMode(dateMode: DateMode.month)
                      : DateTimePickerMode(dateMode: DateMode.date),
                  value: value,
                ),
              ],
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text('switch'));
      await tester.pumpAndSettle();
      expect(find.byType(ListWheelScrollView), findsNWidgets(2));
    });

    testWidgets('仅 range 变化时会按新边界收紧列范围', (tester) async {
      var start = valueFromDateTime(DateTime(2024, 1, 1));
      var end = valueFromDateTime(DateTime(2026, 12, 31));
      await tester.pumpWidget(MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: Column(
              children: [
                TextButton(
                  onPressed: () => setState(() {
                    start = valueFromDateTime(DateTime(2026, 1, 1));
                    end = valueFromDateTime(DateTime(2026, 1, 31));
                  }),
                  child: const Text('tighten-range'),
                ),
                TDateTimePicker(
                  mode: DateTimePickerMode(dateMode: DateMode.date),
                  value: valueFromDateTime(DateTime(2026, 5, 15)),
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
      // 收紧后年列仅 2026（月列在 2026-01 下从 1 月起）
      expect(find.textContaining('2026'), findsWidgets);
      expect(find.textContaining('1月'), findsWidgets);
    });

    testWidgets('滚回同一选中值时不重复触发 onChanged', (tester) async {
      var changeCount = 0;
      TDateTimePickerValue? last;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TDateTimePicker(
            mode: DateTimePickerMode(dateMode: DateMode.date),
            value: valueFromDateTime(DateTime(2024, 2, 15)),
            onChanged: (v) {
              changeCount++;
              last = v;
            },
          ),
        ),
      ));
      await tester.pumpAndSettle();

      final wheels = find.byType(ListWheelScrollView);
      await tester.drag(wheels.at(2), const Offset(0, -80));
      await tester.pumpAndSettle();
      final afterDrag = last;
      expect(changeCount, greaterThan(0));

      await tester.drag(wheels.at(2), const Offset(0, 80));
      await tester.pumpAndSettle();
      if (afterDrag != null && last == afterDrag) {
        expect(changeCount, 1);
      }
    });

    for (final c in _allModeColumnCases) {
      testWidgets('全组合渲染：${c.label} 共 ${c.columns} 列', (tester) async {
        await pumpDateTimePicker(
          tester,
          mode: c.mode,
          value: valueFromDateTime(DateTime(2026, 5, 15, 10, 30, 45)),
        );
        expect(find.byType(ListWheelScrollView), findsNWidgets(c.columns));
      });
    }

    testWidgets('date+second 模式滚动时列触发 onChanged', (tester) async {
      TDateTimePickerValue? changed;
      await pumpDateTimePicker(
        tester,
        mode: DateTimePickerMode(
          dateMode: DateMode.date,
          timeMode: TimeMode.second,
        ),
        value: valueFromDateTime(DateTime(2026, 5, 15, 10, 30, 0)),
        onChanged: (v) => changed = v,
      );
      final wheels = find.byType(ListWheelScrollView);
      expect(wheels, findsNWidgets(6));

      await tester.drag(wheels.at(3), const Offset(0, -80));
      await tester.pumpAndSettle();
      expect(changed, isNotNull);
      expect(changed!.hour, isNot(10));

      await tester.drag(wheels.at(5), const Offset(0, -80));
      await tester.pumpAndSettle();
      expect(changed!.second, isNot(0));
    });

    testWidgets('showWeek 切换年份后日列星期 label 更新', (tester) async {
      await pumpDateTimePicker(
        tester,
        mode: DateTimePickerMode(dateMode: DateMode.date),
        value: valueFromDateTime(DateTime(2026, 5, 15)),
        showWeek: true,
      );
      expect(find.textContaining('周五'), findsWidgets);

      final wheels = find.byType(ListWheelScrollView);
      await tester.drag(wheels.at(0), const Offset(0, 80));
      await tester.pumpAndSettle();
      expect(find.textContaining('周四'), findsWidgets);
    });

    testWidgets('showWeek 在 month 模式下不展示星期', (tester) async {
      await pumpDateTimePicker(
        tester,
        mode: DateTimePickerMode(dateMode: DateMode.month),
        value: const TDateTimePickerValue(year: 2026, month: 5),
        showWeek: true,
      );
      expect(find.byType(ListWheelScrollView), findsNWidgets(2));
      expect(find.textContaining('周'), findsNothing);
    });

    testWidgets('showWeek 从 false 切 true 会重建日列 label', (tester) async {
      var showWeek = false;
      await tester.pumpWidget(MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: Column(
              children: [
                TextButton(
                  onPressed: () => setState(() => showWeek = true),
                  child: const Text('toggle-week'),
                ),
                TDateTimePicker(
                  mode: DateTimePickerMode(dateMode: DateMode.date),
                  value: valueFromDateTime(DateTime(2026, 5, 15)),
                  showWeek: showWeek,
                ),
              ],
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.textContaining('周五'), findsNothing);

      await tester.tap(find.text('toggle-week'));
      await tester.pumpAndSettle();
      expect(find.textContaining('周五'), findsWidgets);
    });

    testWidgets('start/end partial 值通过 fallback 解析边界', (tester) async {
      await pumpDateTimePicker(
        tester,
        mode: DateTimePickerMode(dateMode: DateMode.date),
        value: valueFromDateTime(DateTime(2026, 5, 15)),
        start: const TDateTimePickerValue(year: 2026, month: 5, day: 10),
        end: const TDateTimePickerValue(year: 2026, month: 5, day: 20),
      );
      expect(find.textContaining('2026'), findsWidgets);
      expect(find.textContaining('5月'), findsWidgets);
    });

    testWidgets('onChanged 按 mode 仅返回相关字段', (tester) async {
      TDateTimePickerValue? yearResult;
      await pumpDateTimePicker(
        tester,
        mode: DateTimePickerMode(dateMode: DateMode.year),
        value: valueFromDateTime(DateTime(2026, 1, 1)),
        onChanged: (v) => yearResult = v,
      );
      final wheels = find.byType(ListWheelScrollView);
      await tester.drag(wheels.first, const Offset(0, -80));
      await tester.pumpAndSettle();
      expect(yearResult, isNotNull);
      expect(yearResult!.year, isNotNull);
      expect(yearResult!.month, isNull);
      expect(yearResult!.hour, isNull);

      TDateTimePickerValue? timeResult;
      await pumpDateTimePicker(
        tester,
        mode: DateTimePickerMode(timeMode: TimeMode.minute),
        value: valueFromDateTime(DateTime(2026, 5, 15, 10, 30)),
        onChanged: (v) => timeResult = v,
      );
      final timeWheels = find.byType(ListWheelScrollView);
      await tester.drag(timeWheels.at(1), const Offset(0, -80));
      await tester.pumpAndSettle();
      expect(timeResult, isNotNull);
      expect(timeResult!.year, isNull);
      expect(timeResult!.hour, isNotNull);
      expect(timeResult!.minute, isNotNull);
    });

    testWidgets('自定义 height / itemCount 正常渲染', (tester) async {
      await pumpDateTimePicker(
        tester,
        mode: DateTimePickerMode(dateMode: DateMode.date),
        value: valueFromDateTime(DateTime(2026, 5, 15)),
        height: 240,
        itemCount: 7,
      );
      expect(find.byType(ListWheelScrollView), findsNWidgets(3));
      final sizedBox = tester.widget<SizedBox>(
        find
            .descendant(
              of: find.byType(TDateTimePicker),
              matching: find.byWidgetPredicate(
                (w) => w is SizedBox && w.height == 240,
              ),
            )
            .first,
      );
      expect(sizedBox.height, 240);
    });

    testWidgets('steps 变化会重建滚轮', (tester) async {
      var steps = const DateTimePickerSteps(minute: 5);
      await tester.pumpWidget(MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: Column(
              children: [
                TextButton(
                  onPressed: () => setState(
                      () => steps = const DateTimePickerSteps(minute: 15)),
                  child: const Text('change-steps'),
                ),
                TDateTimePicker(
                  mode: DateTimePickerMode(timeMode: TimeMode.minute),
                  value: valueFromDateTime(DateTime(2026, 5, 15, 10, 30)),
                  steps: steps,
                ),
              ],
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.textContaining('30分'), findsWidgets);

      await tester.tap(find.text('change-steps'));
      await tester.pumpAndSettle();
      expect(find.textContaining('30分'), findsWidgets);
    });

    testWidgets('month+minute 组合滚动月列触发 onChanged', (tester) async {
      TDateTimePickerValue? changed;
      await pumpDateTimePicker(
        tester,
        mode: DateTimePickerMode(
          dateMode: DateMode.month,
          timeMode: TimeMode.minute,
        ),
        value: valueFromDateTime(DateTime(2026, 5, 15, 10, 30)),
        onChanged: (v) => changed = v,
      );
      expect(find.byType(ListWheelScrollView), findsNWidgets(4));

      final wheels = find.byType(ListWheelScrollView);
      await tester.drag(wheels.at(1), const Offset(0, -80));
      await tester.pumpAndSettle();
      expect(changed, isNotNull);
      expect(changed!.month, isNot(5));
      expect(changed!.hour, 10);
      expect(changed!.minute, 30);
      expect(changed!.day, isNull);
    });

    testWidgets('time-only Semantics 含小时列', (tester) async {
      final semanticsHandle = tester.ensureSemantics();
      await pumpDateTimePicker(
        tester,
        mode: DateTimePickerMode(timeMode: TimeMode.minute),
        value: valueFromDateTime(DateTime(2026, 5, 15, 10, 30)),
      );
      expect(find.bySemanticsLabel(RegExp('小时')), findsWidgets);
      semanticsHandle.dispose();
    });

    testWidgets('滚动年列触发 showWeek 日列 label 更新（integration）', (tester) async {
      TDateTimePickerValue? changed;
      await pumpDateTimePicker(
        tester,
        mode: DateTimePickerMode(dateMode: DateMode.date),
        value: valueFromDateTime(DateTime(2026, 5, 15)),
        showWeek: true,
        onChanged: (v) => changed = v,
      );
      final wheels = find.byType(ListWheelScrollView);
      await tester.drag(wheels.at(0), const Offset(0, 80));
      await tester.pumpAndSettle();
      expect(changed, isNotNull);
      expect(changed!.year, isNot(2026));
      expect(find.textContaining('周四'), findsWidgets);
    });
  });
}

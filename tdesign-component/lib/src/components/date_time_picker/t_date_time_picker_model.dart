import 'package:flutter/foundation.dart';

import '../picker/t_picker_items.dart';
import '../picker/t_picker_option.dart';

/// 日期时间列类型枚举
enum DateTimeColumn {
  year,
  month,
  day,
  hour,
  minute,
  second,
  week,
}

/// 时间选择器模式
///
/// 支持两种用法：
///
/// 1. **快捷模式**（字符串）— 自动包含从年到指定粒度的所有列：
///    - `DateTimePickerMode.year` → 年
///    - `DateTimePickerMode.month` → 年月
///    - `DateTimePickerMode.date` → 年月日
///    - `DateTimePickerMode.hour` → 年月日时
///    - `DateTimePickerMode.minute` → 年月日时分
///    - `DateTimePickerMode.second` → 年月日时分秒
///
/// 2. **数组模式** — 精确控制显示哪些列：
///    - 第一个值控制日期粒度（year/month/date），第二个值控制时间粒度（hour/minute/second）
///    - 支持附加 `week` 列：`DateTimePickerMode.array(['date', 'week'])`
///
/// 示例：
/// ```dart
/// // 快捷：年月日
/// DateTimePickerMode.date
///
/// // 数组：年月日 + 时分
/// DateTimePickerMode.array(['date', 'minute'])
///
/// // 数组：年月日 + 星期
/// DateTimePickerMode.array(['date', 'week'])
/// ```
sealed class DateTimePickerMode {
  const DateTimePickerMode();

  /// 仅显示年
  static const year = ShortcutMode._('year');

  /// 年月
  static const month = ShortcutMode._('month');

  /// 年月日
  static const date = ShortcutMode._('date');

  /// 年月日时
  static const hour = ShortcutMode._('hour');

  /// 年月日时分
  static const minute = ShortcutMode._('minute');

  /// 年月日时分秒
  static const second = ShortcutMode._('second');

  /// 数组模式：精确控制列组合
  const factory DateTimePickerMode.array(List<String> values) = ArrayMode;

  /// 解析 mode 为列类型列表
  List<DateTimeColumn> get columns;
}

/// 快捷模式：按粒度自动包含从年到指定类型的所有列
class ShortcutMode extends DateTimePickerMode {
  const ShortcutMode._(this.value);

  final String value;

  static const _shortcutColumns = <String, List<DateTimeColumn>>{
    'year': [DateTimeColumn.year],
    'month': [DateTimeColumn.year, DateTimeColumn.month],
    'date': [DateTimeColumn.year, DateTimeColumn.month, DateTimeColumn.day],
    'hour': [
      DateTimeColumn.year,
      DateTimeColumn.month,
      DateTimeColumn.day,
      DateTimeColumn.hour,
    ],
    'minute': [
      DateTimeColumn.year,
      DateTimeColumn.month,
      DateTimeColumn.day,
      DateTimeColumn.hour,
      DateTimeColumn.minute,
    ],
    'second': [
      DateTimeColumn.year,
      DateTimeColumn.month,
      DateTimeColumn.day,
      DateTimeColumn.hour,
      DateTimeColumn.minute,
      DateTimeColumn.second,
    ],
  };

  @override
  List<DateTimeColumn> get columns {
    // 私有构造保证 value 必为 _shortcutColumns 中的合法 key
    final cols = _shortcutColumns[value];
    assert(cols != null, 'ShortcutMode 未知 value: "$value"，必须使用 DateTimePickerMode 提供的静态常量');
    return cols!;
  }
}

/// 数组模式：精确控制列组合
///
/// - 第一个值控制日期粒度（year/month/date）
/// - 第二个值控制时间粒度（hour/minute/second）
/// - 可附加 `week` 列
class ArrayMode extends DateTimePickerMode {
  const ArrayMode(this.values);

  final List<String> values;

  /// 合法值集合
  static const _validValues = <String>{
    'year',
    'month',
    'date',
    'hour',
    'minute',
    'second',
    'week',
  };

  static const _dateColumns = <String, List<DateTimeColumn>>{
    'year': [DateTimeColumn.year],
    'month': [DateTimeColumn.year, DateTimeColumn.month],
    'date': [DateTimeColumn.year, DateTimeColumn.month, DateTimeColumn.day],
  };

  static const _timeColumns = <String, List<DateTimeColumn>>{
    'hour': [DateTimeColumn.hour],
    'minute': [DateTimeColumn.hour, DateTimeColumn.minute],
    'second': [
      DateTimeColumn.hour,
      DateTimeColumn.minute,
      DateTimeColumn.second,
    ],
  };

  @override
  List<DateTimeColumn> get columns {
    assert(values.isNotEmpty, 'ArrayMode.values 不能为空');
    final result = <DateTimeColumn>[];
    final seen = <DateTimeColumn>{};
    for (final v in values) {
      assert(
        _validValues.contains(v),
        'ArrayMode 不支持的值: "$v"，合法值: $_validValues',
      );
      List<DateTimeColumn>? cols;
      if (_dateColumns.containsKey(v)) {
        cols = _dateColumns[v];
      } else if (_timeColumns.containsKey(v)) {
        cols = _timeColumns[v];
      } else if (v == 'week') {
        cols = const [DateTimeColumn.week];
      }
      if (cols == null) {
        continue;
      }
      // 去重保持顺序
      for (final c in cols) {
        if (seen.add(c)) {
          result.add(c);
        }
      }
    }
    return result;
  }
}

/// 日期时间选择器的回调结果
///
/// 所有字段均为 **nullable**——字段为 `null` 表示当前 [DateTimePickerMode] 下
/// 未包含该列，不是"用户选了 null"。
///
/// 示例：
/// ```dart
/// TDateTimePicker(
///   mode: DateTimePickerMode.date,
///   onConfirm: (v) {
///     print(v.year);   // 2025
///     print(v.month);  // 6
///     print(v.day);    // 15
///     print(v.hour);   // null（date 模式不含时）
///   },
/// )
/// ```
///
/// 通过 [toDateTime] 可将结果重组为 `DateTime`：
/// ```dart
/// onConfirm: (v) {
///   final dt = v.toDateTime(); // DateTime(2025, 6, 15)
/// },
/// ```
@immutable
class TDateTimePickerValue {
  const TDateTimePickerValue({
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.second,
    this.week,
  });

  /// 年（模式包含 year 列时有值）
  final int? year;

  /// 月（模式包含 month 列时有值）
  final int? month;

  /// 日（模式包含 day 列时有值）
  final int? day;

  /// 时（模式包含 hour 列时有值）
  final int? hour;

  /// 分（模式包含 minute 列时有值）
  final int? minute;

  /// 秒（模式包含 second 列时有值）
  final int? second;

  /// 星期（模式包含 week 列时有值，1=周一 … 7=周日）
  ///
  /// 注意：week 列为只读显示，随 year/month/day 变化自动联动，
  /// 其值等价于 [toDateTime]?.weekday，不可独立选择。
  final int? week;

  /// 将选中结果重组为 [DateTime]
  ///
  /// 缺失字段使用 [fallback] 对应字段填充（默认 [DateTime.now]）。
  ///
  /// ```dart
  /// // mode = DateTimePickerMode.date
  /// // value = TDateTimePickerValue(year: 2025, month: 6, day: 15)
  /// value.toDateTime(); // DateTime(2025, 6, 15, 0, 0, 0)
  /// ```
  DateTime toDateTime({DateTime? fallback}) {
    final fb = fallback ?? DateTime.now();
    return DateTime(
      year ?? fb.year,
      month ?? fb.month,
      day ?? fb.day,
      hour ?? fb.hour,
      minute ?? fb.minute,
      second ?? fb.second,
    );
  }

  /// 从 [DateTimeColumn] 列表和对应的 int 值列表构建结果
  factory TDateTimePickerValue.fromColumns({
    required List<DateTimeColumn> columns,
    required List<dynamic> values,
  }) {
    int? year, month, day, hour, minute, second, week;
    for (var i = 0; i < columns.length && i < values.length; i++) {
      final v = values[i];
      if (v is! int) {
        continue;
      }
      switch (columns[i]) {
        case DateTimeColumn.year:
          year = v;
        case DateTimeColumn.month:
          month = v;
        case DateTimeColumn.day:
          day = v;
        case DateTimeColumn.hour:
          hour = v;
        case DateTimeColumn.minute:
          minute = v;
        case DateTimeColumn.second:
          second = v;
        case DateTimeColumn.week:
          week = v;
      }
    }
    return TDateTimePickerValue(
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      second: second,
      week: week,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TDateTimePickerValue &&
          year == other.year &&
          month == other.month &&
          day == other.day &&
          hour == other.hour &&
          minute == other.minute &&
          second == other.second &&
          week == other.week;

  @override
  int get hashCode => Object.hash(year, month, day, hour, minute, second, week);

  @override
  String toString() =>
      'TDateTimePickerValue(year: $year, month: $month, day: $day, '
      'hour: $hour, minute: $minute, second: $second, week: $week)';
}

/// 日期时间列数据生成器
///
/// 纯数据工具类，根据列类型列表、范围和格式化函数生成 `TPickerColumns`。
/// 不管理任何 UI 状态（controller 等由 `TPicker` 内部处理）。
abstract final class DateTimePickerDataHelper {
  /// 默认年范围相对于当前年份的偏移（前后各 10 年）
  static const int defaultYearOffset = 10;

  /// 计算默认起始年（当前年 - [defaultYearOffset]）
  static int defaultStartYear([DateTime? now]) =>
      (now ?? DateTime.now()).year - defaultYearOffset;

  /// 计算默认结束年（当前年 + [defaultYearOffset]）
  static int defaultEndYear([DateTime? now]) =>
      (now ?? DateTime.now()).year + defaultYearOffset;

  /// 默认单位
  static const Map<DateTimeColumn, String> defaultUnits = {
    DateTimeColumn.year: '年',
    DateTimeColumn.month: '月',
    DateTimeColumn.day: '日',
    DateTimeColumn.hour: '时',
    DateTimeColumn.minute: '分',
    DateTimeColumn.second: '秒',
    DateTimeColumn.week: '',
  };

  /// 星期文案
  static const List<String> weekLabels = [
    '周一',
    '周二',
    '周三',
    '周四',
    '周五',
    '周六',
    '周日',
  ];

  /// 根据列类型、范围和当前选中值生成 [TPickerColumns]
  ///
  /// [columns] 需要生成的列类型列表
  /// [start] 可选范围起始
  /// [end] 可选范围结束
  /// [current] 当前选中值（用于计算日列天数和星期列）
  /// [format] 自定义格式化函数
  ///
  /// 当 [start] 晚于 [end] 时：debug 模式下会触发 assert，release 模式下会忽略 [end]，
  /// 仅以 [start] 作为下界，避免崩溃。
  static TPickerColumns buildColumns({
    required List<DateTimeColumn> columns,
    DateTime? start,
    DateTime? end,
    DateTime? current,
    String Function(DateTimeColumn column, int value)? format,
  }) {
    assert(
      start == null || end == null || !start.isAfter(end),
      'DateTimePickerDataHelper.buildColumns: start ($start) 不能晚于 end ($end)',
    );
    // release 模式下若 start > end，丢弃 end 以避免空区间崩溃
    final safeEnd = (start != null && end != null && start.isAfter(end))
        ? null
        : end;
    final now = current ?? DateTime.now();
    final result = <List<TPickerOption>>[];

    for (final col in columns) {
      switch (col) {
        case DateTimeColumn.year:
          result.add(_buildYearColumn(start, safeEnd, now, format));
        case DateTimeColumn.month:
          result.add(_buildMonthColumn(start, safeEnd, now, format));
        case DateTimeColumn.day:
          result.add(_buildDayColumn(start, safeEnd, now, format));
        case DateTimeColumn.hour:
          result.add(_buildHourColumn(start, safeEnd, now, format));
        case DateTimeColumn.minute:
          result.add(_buildMinuteColumn(start, safeEnd, now, format));
        case DateTimeColumn.second:
          result.add(_buildSecondColumn(start, safeEnd, now, format));
        case DateTimeColumn.week:
          result.add(_buildWeekColumn(now, format));
      }
    }

    return TPickerColumns(result);
  }

  /// 根据列类型列表和当前选中值，计算 `TPicker` 的 initialValue
  static List<dynamic> buildInitialValue({
    required List<DateTimeColumn> columns,
    required DateTime value,
  }) {
    final result = <dynamic>[];
    for (final col in columns) {
      switch (col) {
        case DateTimeColumn.year:
          result.add(value.year);
        case DateTimeColumn.month:
          result.add(value.month);
        case DateTimeColumn.day:
          result.add(value.day);
        case DateTimeColumn.hour:
          result.add(value.hour);
        case DateTimeColumn.minute:
          result.add(value.minute);
        case DateTimeColumn.second:
          result.add(value.second);
        case DateTimeColumn.week:
          result.add(value.weekday);
      }
    }
    return result;
  }

  /// 将 TPicker 回调的 values 转为 [TDateTimePickerValue]
  ///
  /// 推荐直接使用 [TDateTimePickerValue.fromColumns]，此方法为便利封装。
  static TDateTimePickerValue toResult({
    required List<DateTimeColumn> columns,
    required List<dynamic> values,
  }) {
    return TDateTimePickerValue.fromColumns(
      columns: columns,
      values: values,
    );
  }

  /// 从 TPicker 回调的 values 中恢复出当前选中的 DateTime
  ///
  /// 用于联动刷新时重新计算日列天数和星期列。
  static DateTime resolveCurrentDateTime({
    required List<DateTimeColumn> columns,
    required List<dynamic> values,
    DateTime? fallback,
  }) {
    final fb = fallback ?? DateTime.now();
    var year = fb.year;
    var month = fb.month;
    var day = fb.day;
    var hour = fb.hour;
    var minute = fb.minute;
    var second = fb.second;

    for (var i = 0; i < columns.length && i < values.length; i++) {
      final v = values[i];
      if (v is! int) {
        continue;
      }
      switch (columns[i]) {
        case DateTimeColumn.year:
          year = v;
        case DateTimeColumn.month:
          month = v;
        case DateTimeColumn.day:
          day = v;
        case DateTimeColumn.hour:
          hour = v;
        case DateTimeColumn.minute:
          minute = v;
        case DateTimeColumn.second:
          second = v;
        case DateTimeColumn.week:
          break;
      }
    }

    // 修正日期（如 2 月 30 日 → 2 月 28/29 日）
    final maxDay = _daysInMonth(year, month);
    if (day > maxDay) {
      day = maxDay;
    }

    return DateTime(year, month, day, hour, minute, second);
  }

  /// 检查年/月列是否发生变化（决定是否需要联动刷新）
  static bool needsRefresh(
    List<DateTimeColumn> columns,
    List<dynamic> oldValues,
    List<dynamic> newValues,
  ) {
    for (var i = 0; i < columns.length && i < oldValues.length && i < newValues.length; i++) {
      final col = columns[i];
      if ((col == DateTimeColumn.year || col == DateTimeColumn.month) &&
          oldValues[i] != newValues[i]) {
        return true;
      }
    }
    return false;
  }

  // ──────── 列数据生成 ────────

  static List<TPickerOption> _buildYearColumn(
    DateTime? start,
    DateTime? end,
    DateTime current,
    String Function(DateTimeColumn, int)? format,
  ) {
    final startYear = start?.year ?? defaultStartYear(current);
    final endYear = end?.year ?? defaultEndYear(current);
    return [
      for (var y = startYear; y <= endYear; y++)
        TPickerOption(
          label: format?.call(DateTimeColumn.year, y) ??
              '$y${defaultUnits[DateTimeColumn.year]}',
          value: y,
        ),
    ];
  }

  static List<TPickerOption> _buildMonthColumn(
    DateTime? start,
    DateTime? end,
    DateTime current,
    String Function(DateTimeColumn, int)? format,
  ) {
    var startMonth = 1;
    var endMonth = 12;

    // 当前年 == 起始年时，裁剪起始月
    if (start != null && current.year == start.year) {
      startMonth = start.month;
    }
    // 当前年 == 结束年时，裁剪结束月
    if (end != null && current.year == end.year) {
      endMonth = end.month;
    }

    return [
      for (var m = startMonth; m <= endMonth; m++)
        TPickerOption(
          label: format?.call(DateTimeColumn.month, m) ??
              '$m${defaultUnits[DateTimeColumn.month]}',
          value: m,
        ),
    ];
  }

  static List<TPickerOption> _buildDayColumn(
    DateTime? start,
    DateTime? end,
    DateTime current,
    String Function(DateTimeColumn, int)? format,
  ) {
    final maxDay = _daysInMonth(current.year, current.month);
    var startDay = 1;
    var endDay = maxDay;

    if (start != null &&
        current.year == start.year &&
        current.month == start.month) {
      startDay = start.day;
    }
    if (end != null &&
        current.year == end.year &&
        current.month == end.month) {
      endDay = end.day.clamp(1, maxDay);
    }

    return [
      for (var d = startDay; d <= endDay; d++)
        TPickerOption(
          label: format?.call(DateTimeColumn.day, d) ??
              '$d${defaultUnits[DateTimeColumn.day]}',
          value: d,
        ),
    ];
  }

  static List<TPickerOption> _buildHourColumn(
    DateTime? start,
    DateTime? end,
    DateTime current,
    String Function(DateTimeColumn, int)? format,
  ) {
    var startHour = 0;
    var endHour = 23;

    if (start != null && _isSameDate(current, start)) {
      startHour = start.hour;
    }
    if (end != null && _isSameDate(current, end)) {
      endHour = end.hour;
    }

    return [
      for (var h = startHour; h <= endHour; h++)
        TPickerOption(
          label: format?.call(DateTimeColumn.hour, h) ??
              '$h${defaultUnits[DateTimeColumn.hour]}',
          value: h,
        ),
    ];
  }

  static List<TPickerOption> _buildMinuteColumn(
    DateTime? start,
    DateTime? end,
    DateTime current,
    String Function(DateTimeColumn, int)? format,
  ) {
    var startMinute = 0;
    var endMinute = 59;

    if (start != null &&
        _isSameDate(current, start) &&
        current.hour == start.hour) {
      startMinute = start.minute;
    }
    if (end != null &&
        _isSameDate(current, end) &&
        current.hour == end.hour) {
      endMinute = end.minute;
    }

    return [
      for (var m = startMinute; m <= endMinute; m++)
        TPickerOption(
          label: format?.call(DateTimeColumn.minute, m) ??
              '$m${defaultUnits[DateTimeColumn.minute]}',
          value: m,
        ),
    ];
  }

  static List<TPickerOption> _buildSecondColumn(
    DateTime? start,
    DateTime? end,
    DateTime current,
    String Function(DateTimeColumn, int)? format,
  ) {
    var startSecond = 0;
    var endSecond = 59;

    if (start != null &&
        _isSameDate(current, start) &&
        current.hour == start.hour &&
        current.minute == start.minute) {
      startSecond = start.second;
    }
    if (end != null &&
        _isSameDate(current, end) &&
        current.hour == end.hour &&
        current.minute == end.minute) {
      endSecond = end.second;
    }

    return [
      for (var s = startSecond; s <= endSecond; s++)
        TPickerOption(
          label: format?.call(DateTimeColumn.second, s) ??
              '$s${defaultUnits[DateTimeColumn.second]}',
          value: s,
        ),
    ];
  }

  static List<TPickerOption> _buildWeekColumn(
    DateTime current,
    String Function(DateTimeColumn, int)? format,
  ) {
    // 星期列固定只显示当前日期对应的星期几
    final weekday = current.weekday; // 1=周一 ... 7=周日
    return [
      TPickerOption(
        label: format?.call(DateTimeColumn.week, weekday) ??
            weekLabels[weekday - 1],
        value: weekday,
      ),
    ];
  }

  // ──────── 工具方法 ────────

  static int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  static bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

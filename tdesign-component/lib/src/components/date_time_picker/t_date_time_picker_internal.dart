import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../theme/resource_delegate.dart';
import '../picker/t_picker_items.dart';
import '../picker/t_picker_option.dart';
import 't_date_time_picker_enums.dart';
import 't_date_time_picker_model.dart';

// =============================================================================
// DateTimePickerMode 的内部子类实现（@internal）
// =============================================================================
//
// 业务方通过 `DateTimePickerMode.year / .month / .ymd / ... / .combined(...)` 访问，
// 不应直接构造这两个类型。整个文件 **不被 umbrella 导出**——外部即使想 import
// 也只能走 `package:tdesign_flutter/src/...` 这种私有路径，并会被 lint 警告。

/// [TDateTimePicker] 各列默认 label 的文案配置（@internal）。
///
/// build 时由 [fromResource] 从 [TResourceDelegate] 生成；缺省文案见
/// [TResourceManager.defaultDelegate]（[_DefaultResourceDelegate]）。
@internal
@immutable
class DateTimePickerLabels {
  const DateTimePickerLabels({
    required this.unitSuffix,
    required this.weekLabels,
  });

  /// 未注入 [TResourceManager.setResourceBuilder] 时的 label（派生自 [_DefaultResourceDelegate]）。
  static final DateTimePickerLabels defaults =
      DateTimePickerLabels.fromResource(TResourceManager.defaultDelegate);

  final Map<DateTimeColumn, String> unitSuffix;
  final List<String> weekLabels;

  factory DateTimePickerLabels.fromResource(TResourceDelegate resource) {
    return DateTimePickerLabels(
      unitSuffix: {
        DateTimeColumn.year: resource.yearLabel,
        DateTimeColumn.month: resource.monthLabel,
        DateTimeColumn.day: resource.dateLabel,
        DateTimeColumn.hour: resource.hours,
        DateTimeColumn.minute: resource.minutes,
        DateTimeColumn.second: resource.seconds,
      },
      weekLabels: _weekLabelsFromResource(resource),
    );
  }

  String formatColumn(DateTimeColumn column, int value) =>
      '$value${unitSuffix[column]}';

  String weekdayLabel(int weekday) => weekLabels[weekday - 1];

  static List<String> _weekLabelsFromResource(TResourceDelegate resource) {
    String label(String shortName) {
      if (shortName.length == 1 && resource.weeksLabel.isNotEmpty) {
        return '${resource.weeksLabel}$shortName';
      }
      return shortName;
    }

    return [
      label(resource.monday),
      label(resource.tuesday),
      label(resource.wednesday),
      label(resource.thursday),
      label(resource.friday),
      label(resource.saturday),
      label(resource.sunday),
    ];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateTimePickerLabels &&
          mapEquals(unitSuffix, other.unitSuffix) &&
          listEquals(weekLabels, other.weekLabels);

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(unitSuffix.entries), Object.hashAll(weekLabels));
}

/// 快捷模式：`DateTimePickerMode.year / .month / .ymd / .hour / .minute / .second`
/// 静态常量背后的实现。
///
/// 与 [CombinedMode] 语义等价（都是「date 粒度 + time 粒度」展开成列）；
/// 判等由 [DateTimePickerMode] 基类按 [dateGranularity] / [timeGranularity] 统一处理。
@internal
@immutable
class ShortcutMode extends DateTimePickerMode {
  const ShortcutMode({this.date, this.time});

  final DateMode? date;
  final TimeMode? time;

  @override
  DateMode? get dateGranularity => date;

  @override
  TimeMode? get timeGranularity => time;

  @override
  List<DateTimeColumn> get columns => _expand(date, time);
}

/// 组合模式：`DateTimePickerMode.combined(dateMode: ..., timeMode: ...)` 工厂的返回值。
@internal
@immutable
class CombinedMode extends DateTimePickerMode {
  const CombinedMode({this.date, this.time});

  final DateMode? date;
  final TimeMode? time;

  @override
  DateMode? get dateGranularity => date;

  @override
  TimeMode? get timeGranularity => time;

  @override
  List<DateTimeColumn> get columns => _expand(date, time);
}

/// 把日期粒度 + 时间粒度展开成 [DateTimeColumn] 序列。
List<DateTimeColumn> _expand(DateMode? date, TimeMode? time) {
  final cols = <DateTimeColumn>[];
  switch (date) {
    case DateMode.year:
      cols.add(DateTimeColumn.year);
    case DateMode.month:
      cols
        ..add(DateTimeColumn.year)
        ..add(DateTimeColumn.month);
    case DateMode.date:
      cols
        ..add(DateTimeColumn.year)
        ..add(DateTimeColumn.month)
        ..add(DateTimeColumn.day);
    case null:
      break;
  }
  switch (time) {
    case TimeMode.hour:
      cols.add(DateTimeColumn.hour);
    case TimeMode.minute:
      cols
        ..add(DateTimeColumn.hour)
        ..add(DateTimeColumn.minute);
    case TimeMode.second:
      cols
        ..add(DateTimeColumn.hour)
        ..add(DateTimeColumn.minute)
        ..add(DateTimeColumn.second);
    case null:
      break;
  }
  assert(
    cols.isNotEmpty,
    'DateTimePickerMode: dateMode 与 timeMode 不能同时为 null',
  );
  return List<DateTimeColumn>.unmodifiable(cols);
}

// =============================================================================
// DateTimePickerSnapshot —— 单一真相源（@internal）
// =============================================================================

/// `TDateTimePicker` 内部的**不可变状态快照**（@internal，业务侧无需关心）。
///
/// 替代旧设计中并行存在的 `_current` / `_initialValue` / `_pickerColumns` /
/// `_lastValues` 四字段——它们之间任何一个落后/超前都会引发 bug。新设计把
/// 「列结构 + 当前选中 DateTime」收敛到一个 immutable value object 内：
///
/// - 任何中间派生值（picker initial values / picker columns / 回调结果）
///   都是 snapshot 的派生方法，单一真相源；
/// - 用户选了新值时，调用 [applySelection] 得到一个**新的** snapshot；
///   旧 snapshot 与新 snapshot 之间用 `==` 比较即可决定是否需要 setState。
@internal
@immutable
class DateTimePickerSnapshot {
  DateTimePickerSnapshot._({
    required this.columns,
    required this.current,
    required this.yearAnchor,
  }) : values = _extractValues(columns, current);

  /// 创建一个钳制到 `[start, end]` 范围内的初始快照。
  ///
  /// - [initial] 缺省时使用 [DateTime.now]；
  /// - 当 `start.isAfter(end)` 时，debug 下触发 `assert`，release 下忽略 `end`。
  factory DateTimePickerSnapshot.initial({
    required List<DateTimeColumn> columns,
    DateTime? initial,
    DateTime? start,
    DateTime? end,
  }) {
    assert(columns.isNotEmpty,
        'DateTimePickerSnapshot: columns must not be empty');
    assert(
      start == null || end == null || !start.isAfter(end),
      'DateTimePickerSnapshot: start ($start) must not be after end ($end)',
    );
    final safeEnd =
        (start != null && end != null && start.isAfter(end)) ? null : end;
    final clamped =
        _clamp(initial ?? DateTime.now(), start: start, end: safeEnd);
    return DateTimePickerSnapshot._(
      columns: List<DateTimeColumn>.unmodifiable(columns),
      current: clamped,
      // 年列默认范围锚定在「打开时」的选中年，滚动年份时不再以 current.year 为中心漂移。
      yearAnchor: clamped.year,
    );
  }

  /// 显示的列结构（按显示顺序，与 [DateTimePickerMode.columns] 等价）。
  final List<DateTimeColumn> columns;

  /// 当前选中的完整 [DateTime]。
  final DateTime current;

  /// 年列默认 ±[_kDefaultYearOffset] 范围的锚定年份（打开时确定，随滚动不变）。
  ///
  /// 仅当未提供 [start]/[end] 的年边界时使用；避免 `current.year ± 10` 随滚动漂移。
  final int yearAnchor;

  /// 各列对应的选中值数组（顺序与 [columns] 一致）。
  /// 等价于把 [current] 按 [columns] 投影一遍。
  final List<int> values;

  /// 将 [TPicker] 回调中的原始值列表规范为 `int`（与 [columns] 长度对齐）。
  ///
  /// 列 value 约定为 `int`；若收到 [num] 会取整。类型不符时抛出 [ArgumentError]。
  static List<int> coerceRawValues(
    List<dynamic> raw, {
    required int expectedLength,
  }) {
    final out = <int>[];
    for (var i = 0; i < expectedLength; i++) {
      if (i >= raw.length) {
        break;
      }
      final v = raw[i];
      out.add(switch (v) {
        final int value => value,
        final num n => n.round(),
        _ => throw ArgumentError.value(
            v,
            'raw[$i]',
            'TDateTimePicker expects int column values',
          ),
      });
    }
    return out;
  }

  /// 应用一次用户选择：把 picker 报上来的原始 [rawValues] 合并入快照、
  /// 钳制到 `[start, end]`、归一化（如 2 月 30 日 → 28 日），返回新 snapshot。
  ///
  /// 若新旧 snapshot 在 [columns] 投影上相同，仍然返回新实例（但 `==` 为 true），
  /// 上层可据此跳过 `setState`。
  DateTimePickerSnapshot applySelection({
    required List<int> rawValues,
    DateTime? start,
    DateTime? end,
  }) {
    final raw = _resolveDateTime(columns, rawValues, fallback: current);
    final clamped = _clamp(raw, start: start, end: end);
    return DateTimePickerSnapshot._(
      columns: columns,
      current: clamped,
      yearAnchor: yearAnchor,
    );
  }

  /// 模式 / 范围变更时，基于现有 [current] 重建一个新 snapshot。
  ///
  /// [columns] / [start] / [end] 任一变化时上层调用本方法。
  DateTimePickerSnapshot rebuildFor({
    required List<DateTimeColumn> columns,
    DateTime? start,
    DateTime? end,
  }) {
    final clamped = _clamp(current, start: start, end: end);
    return DateTimePickerSnapshot._(
      columns: List<DateTimeColumn>.unmodifiable(columns),
      current: clamped,
      yearAnchor: yearAnchor,
    );
  }

  /// 根据当前快照计算 `TPickerColumns`（给 picker 的 items）。
  ///
  /// 各列范围裁剪规则：
  /// - **年**：`[start.year, end.year]`；缺省一侧时以 [yearAnchor] ± [_kDefaultYearOffset] 推算（不随滚动漂移）。
  /// - **月**：当 `current.year == start.year` 时下界收紧到 `start.month`；
  ///   `current.year == end.year` 时上界收紧到 `end.month`；其它年份保持 1–12。
  /// - **日**：仅当 `current` 与 `start` / `end` 同月时按日裁剪。
  /// - **时 / 分 / 秒**：在与边界处于同一自然日 / 同一小时 / 同一分钟时收紧。
  ///
  /// [showWeek] 为 `true` 时，**日列**的默认 label 追加星期（如 "19日 周六"）；
  /// 自定义 [format] 优先于本规则。
  /// [labels] 缺省时使用 [DateTimePickerLabels.defaults]。
  TPickerColumns toPickerColumns({
    DateTime? start,
    DateTime? end,
    String Function(DateTimeColumn column, int value)? format,
    bool showWeek = false,
    DateTimePickerLabels? labels,
  }) {
    final resolvedLabels = labels ?? DateTimePickerLabels.defaults;
    final safeEnd =
        (start != null && end != null && start.isAfter(end)) ? null : end;
    final cols = <List<TPickerOption>>[];
    for (final col in columns) {
      cols.add(_buildColumnOptions(
        col,
        start,
        safeEnd,
        current,
        yearAnchor,
        format,
        labels: resolvedLabels,
        showWeek: showWeek,
      ));
    }
    return TPickerColumns(cols);
  }

  /// 转换为业务侧的 [TDateTimePickerValue]。
  TDateTimePickerValue toResult() {
    int? y, m, d, h, mi, s;
    for (var i = 0; i < columns.length; i++) {
      final v = values[i];
      switch (columns[i]) {
        case DateTimeColumn.year:
          y = v;
        case DateTimeColumn.month:
          m = v;
        case DateTimeColumn.day:
          d = v;
        case DateTimeColumn.hour:
          h = v;
        case DateTimeColumn.minute:
          mi = v;
        case DateTimeColumn.second:
          s = v;
      }
    }
    return TDateTimePickerValue(
      year: y,
      month: m,
      day: d,
      hour: h,
      minute: mi,
      second: s,
    );
  }

  /// 判断从 [other] → `this`，picker 的列结构是否需要重建。
  ///
  /// 列结构变化触发条件：
  /// - **年 / 月**变化（日列天数可能变）；
  /// - [showWeek] 为 true 时，**年 / 月 / 日**任一变化（日列 label 含周几）。
  bool needsColumnRebuildFrom(
    DateTimePickerSnapshot other, {
    bool showWeek = false,
  }) {
    if (!listEquals(columns, other.columns)) {
      return true;
    }
    if (current.year != other.current.year ||
        current.month != other.current.month) {
      return true;
    }
    if (showWeek && current.day != other.current.day) {
      return true;
    }
    return false;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateTimePickerSnapshot &&
          listEquals(columns, other.columns) &&
          current == other.current &&
          yearAnchor == other.yearAnchor;

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(columns), current, yearAnchor);

  @override
  String toString() =>
      'DateTimePickerSnapshot(columns: $columns, current: $current, '
      'yearAnchor: $yearAnchor)';

  /// 年范围相对当前年份的默认偏移（前后各 10 年）。
  static const int _kDefaultYearOffset = 10;

  /// 把 [dt] 钳制到 `[start, end]` 闭区间。
  static DateTime _clamp(DateTime dt, {DateTime? start, DateTime? end}) {
    if (start != null && dt.isBefore(start)) {
      return start;
    }
    if (end != null && dt.isAfter(end)) {
      return end;
    }
    return dt;
  }

  /// 按 [columns] 把 [current] 投影成 int 数组。
  static List<int> _extractValues(
      List<DateTimeColumn> columns, DateTime current) {
    final r = <int>[];
    for (final c in columns) {
      r.add(switch (c) {
        DateTimeColumn.year => current.year,
        DateTimeColumn.month => current.month,
        DateTimeColumn.day => current.day,
        DateTimeColumn.hour => current.hour,
        DateTimeColumn.minute => current.minute,
        DateTimeColumn.second => current.second,
      });
    }
    return List<int>.unmodifiable(r);
  }

  /// 把 picker 报上来的 [rawValues] 合并入 [fallback]，处理日溢出。
  static DateTime _resolveDateTime(
    List<DateTimeColumn> columns,
    List<int> rawValues, {
    required DateTime fallback,
  }) {
    var y = fallback.year;
    var m = fallback.month;
    var d = fallback.day;
    var h = fallback.hour;
    var mi = fallback.minute;
    var s = fallback.second;
    for (var i = 0; i < columns.length && i < rawValues.length; i++) {
      switch (columns[i]) {
        case DateTimeColumn.year:
          y = rawValues[i];
        case DateTimeColumn.month:
          m = rawValues[i];
        case DateTimeColumn.day:
          d = rawValues[i];
        case DateTimeColumn.hour:
          h = rawValues[i];
        case DateTimeColumn.minute:
          mi = rawValues[i];
        case DateTimeColumn.second:
          s = rawValues[i];
      }
    }
    final maxDay = _daysInMonth(y, m);
    if (d > maxDay) {
      d = maxDay;
    }
    return DateTime(y, m, d, h, mi, s);
  }

  /// 单列 option 构造。
  ///
  /// [showWeek] 仅影响 [DateTimeColumn.day] 列的 label fallback——
  /// `"19日"` → `"19日 周六"`；自定义 [format] 永远优先。
  static List<TPickerOption> _buildColumnOptions(
    DateTimeColumn col,
    DateTime? start,
    DateTime? end,
    DateTime current,
    int yearAnchor,
    String Function(DateTimeColumn, int)? format, {
    required DateTimePickerLabels labels,
    required bool showWeek,
  }) {
    return switch (col) {
      DateTimeColumn.year => _buildIntRange(
          col,
          start?.year ?? (yearAnchor - _kDefaultYearOffset),
          end?.year ?? (yearAnchor + _kDefaultYearOffset),
          format,
          labels,
        ),
      DateTimeColumn.month => _buildIntRange(
          col,
          (start != null && current.year == start.year) ? start.month : 1,
          (end != null && current.year == end.year) ? end.month : 12,
          format,
          labels,
        ),
      DateTimeColumn.day => () {
          final maxDay = _daysInMonth(current.year, current.month);
          final startDay = (start != null && _isSameMonth(current, start))
              ? start.day
              : 1;
          final endDay = (end != null && _isSameMonth(current, end))
              ? end.day.clamp(1, maxDay)
              : maxDay;
          return _buildDayRange(
            current,
            startDay,
            endDay,
            format,
            labels: labels,
            showWeek: showWeek,
          );
        }(),
      DateTimeColumn.hour => _buildIntRange(
          col,
          (start != null && _isSameDate(current, start)) ? start.hour : 0,
          (end != null && _isSameDate(current, end)) ? end.hour : 23,
          format,
          labels,
        ),
      DateTimeColumn.minute => _buildIntRange(
          col,
          (start != null && _isSameHour(current, start)) ? start.minute : 0,
          (end != null && _isSameHour(current, end)) ? end.minute : 59,
          format,
          labels,
        ),
      DateTimeColumn.second => _buildIntRange(
          col,
          (start != null && _isSameMinute(current, start)) ? start.second : 0,
          (end != null && _isSameMinute(current, end)) ? end.second : 59,
          format,
          labels,
        ),
    };
  }

  static List<TPickerOption> _buildIntRange(
    DateTimeColumn column,
    int start,
    int end,
    String Function(DateTimeColumn, int)? format,
    DateTimePickerLabels labels,
  ) {
    if (end < start) {
      // 防御：极端范围导致空列。回填单元素保证 TPickerColumns 非空约束。
      end = start;
    }
    return [
      for (var v = start; v <= end; v++)
        TPickerOption(
          label: format?.call(column, v) ?? labels.formatColumn(column, v),
          value: v,
        ),
    ];
  }

  /// 日列专用构造：在 [showWeek] = true 时把对应日期的星期附加到 label 末尾。
  static List<TPickerOption> _buildDayRange(
    DateTime current,
    int startDay,
    int endDay,
    String Function(DateTimeColumn, int)? format, {
    required DateTimePickerLabels labels,
    required bool showWeek,
  }) {
    if (endDay < startDay) {
      endDay = startDay;
    }
    return [
      for (var d = startDay; d <= endDay; d++)
        TPickerOption(
          label: format?.call(DateTimeColumn.day, d) ??
              _defaultDayLabel(
                current.year,
                current.month,
                d,
                showWeek,
                labels,
              ),
          value: d,
        ),
    ];
  }

  static String _defaultDayLabel(
    int year,
    int month,
    int day,
    bool showWeek,
    DateTimePickerLabels labels,
  ) {
    final base = labels.formatColumn(DateTimeColumn.day, day);
    if (!showWeek) {
      return base;
    }
    final weekday = DateTime(year, month, day).weekday;
    return '$base ${labels.weekdayLabel(weekday)}';
  }

  static int _daysInMonth(int year, int month) =>
      DateTime(year, month + 1, 0).day;

  static bool _isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  static bool _isSameDate(DateTime a, DateTime b) =>
      _isSameMonth(a, b) && a.day == b.day;

  static bool _isSameHour(DateTime a, DateTime b) =>
      _isSameDate(a, b) && a.hour == b.hour;

  static bool _isSameMinute(DateTime a, DateTime b) =>
      _isSameHour(a, b) && a.minute == b.minute;
}

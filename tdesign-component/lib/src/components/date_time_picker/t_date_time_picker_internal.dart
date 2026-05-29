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
// 业务方通过 `DateTimePickerMode(dateMode: ..., timeMode: ...)` 访问；
// [CombinedMode] 不应直接构造。整个文件 **不被 umbrella 导出**。

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

/// `DateTimePickerMode(...)` 工厂返回值。
@internal
@immutable
class CombinedMode extends DateTimePickerMode {
  const CombinedMode({this.date, this.time}) : super.forImplementation();

  final DateMode? date;
  final TimeMode? time;

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
// 列范围 / 步进（@internal）
// =============================================================================

/// 单列可选数值闭区间。
@immutable
class _IntRange {
  const _IntRange(this.min, this.max);

  final int min;
  final int max;

  bool get isValid => min <= max;
}

DateTime? _safeEnd(DateTime? start, DateTime? end) =>
    (start != null && end != null && start.isAfter(end)) ? null : end;

bool _isSameMonth(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month;

bool _isSameDate(DateTime a, DateTime b) =>
    _isSameMonth(a, b) && a.day == b.day;

bool _isSameHour(DateTime a, DateTime b) =>
    _isSameDate(a, b) && a.hour == b.hour;

bool _isSameMinute(DateTime a, DateTime b) =>
    _isSameHour(a, b) && a.minute == b.minute;

bool _isTimeOnlyColumns(List<DateTimeColumn> columns) =>
    !columns.contains(DateTimeColumn.year) &&
    !columns.contains(DateTimeColumn.month) &&
    !columns.contains(DateTimeColumn.day);

/// 在 `[start, end]` 与当前选中上下文下，计算单列的 min/max（闭区间）。
_IntRange columnBounds(
  DateTimeColumn col, {
  required DateTime current,
  required DateTime? start,
  required DateTime? end,
  required int yearAnchor,
  required List<DateTimeColumn> columns,
}) {
  final safeEnd = _safeEnd(start, end);

  if (_isTimeOnlyColumns(columns)) {
    return _timeOnlyColumnBounds(col, current: current, start: start, end: safeEnd);
  }

  return switch (col) {
    DateTimeColumn.year => _IntRange(
        start?.year ?? (yearAnchor - DateTimePickerSnapshot.defaultYearOffset),
        safeEnd?.year ?? (yearAnchor + DateTimePickerSnapshot.defaultYearOffset),
      ),
    DateTimeColumn.month => _IntRange(
        (start != null && current.year == start.year) ? start.month : 1,
        (safeEnd != null && current.year == safeEnd.year) ? safeEnd.month : 12,
      ),
    DateTimeColumn.day => () {
        final maxDay = DateTimePickerSnapshot.daysInMonth(
          current.year,
          current.month,
        );
        final startDay =
            (start != null && _isSameMonth(current, start)) ? start.day : 1;
        final endDay = (safeEnd != null && _isSameMonth(current, safeEnd))
            ? safeEnd.day.clamp(1, maxDay)
            : maxDay;
        return _IntRange(startDay, endDay);
      }(),
    DateTimeColumn.hour => _IntRange(
        (start != null && _isSameDate(current, start)) ? start.hour : 0,
        (safeEnd != null && _isSameDate(current, safeEnd)) ? safeEnd.hour : 23,
      ),
    DateTimeColumn.minute => _IntRange(
        (start != null && _isSameHour(current, start)) ? start.minute : 0,
        (safeEnd != null && _isSameHour(current, safeEnd)) ? safeEnd.minute : 59,
      ),
    DateTimeColumn.second => _IntRange(
        (start != null && _isSameMinute(current, start)) ? start.second : 0,
        (safeEnd != null && _isSameMinute(current, safeEnd))
            ? safeEnd.second
            : 59,
      ),
  };
}

_IntRange _timeOnlyColumnBounds(
  DateTimeColumn col, {
  required DateTime current,
  required DateTime? start,
  required DateTime? end,
}) {
  return switch (col) {
    DateTimeColumn.hour => _IntRange(start?.hour ?? 0, end?.hour ?? 23),
    DateTimeColumn.minute => _IntRange(
        (start != null && current.hour == start.hour) ? start.minute : 0,
        (end != null && current.hour == end.hour) ? end.minute : 59,
      ),
    DateTimeColumn.second => _IntRange(
        (start != null && _isSameHour(current, start)) ? start.second : 0,
        (end != null && _isSameHour(current, end)) ? end.second : 59,
      ),
    _ => const _IntRange(0, 0),
  };
}

int _firstStepValue(int min, int step) {
  if (step <= 1) {
    return min;
  }
  final rem = min % step;
  return rem == 0 ? min : min + (step - rem);
}

int _lastStepValue(int min, int max, int step) {
  if (step <= 1) {
    return max;
  }
  final first = _firstStepValue(min, step);
  if (first > max) {
    return min;
  }
  final count = (max - first) ~/ step;
  return first + count * step;
}

int snapToStep(int value, int min, int max, int step) {
  if (max < min) {
    return min;
  }
  if (step <= 1) {
    return value.clamp(min, max);
  }
  if (value < min) {
    return _firstStepValue(min, step);
  }
  if (value > max) {
    return _lastStepValue(min, max, step);
  }
  final first = _firstStepValue(min, step);
  final snapped = first + (((value - first) / step).round()) * step;
  if (snapped > max) {
    return _lastStepValue(min, max, step);
  }
  if (snapped < min) {
    return first;
  }
  return snapped;
}

DateTime normalizePickerDateTime(
  DateTime dt, {
  required List<DateTimeColumn> columns,
  DateTime? start,
  DateTime? end,
  DateTimePickerSteps? steps,
  required int yearAnchor,
}) {
  final safeEnd = _safeEnd(start, end);
  var result = DateTimePickerSnapshot.clampDateTime(dt, start: start, end: safeEnd);

  var y = result.year;
  var m = result.month;
  var d = result.day;
  var h = result.hour;
  var mi = result.minute;
  var s = result.second;

  for (final col in columns) {
    final bounds = columnBounds(
      col,
      current: result,
      start: start,
      end: safeEnd,
      yearAnchor: yearAnchor,
      columns: columns,
    );
    if (!bounds.isValid) {
      continue;
    }
    final step = steps?.forColumn(col) ?? 1;
    switch (col) {
      case DateTimeColumn.year:
        y = snapToStep(y, bounds.min, bounds.max, step);
      case DateTimeColumn.month:
        m = snapToStep(m, bounds.min, bounds.max, step);
      case DateTimeColumn.day:
        d = snapToStep(d, bounds.min, bounds.max, step);
      case DateTimeColumn.hour:
        h = snapToStep(h, bounds.min, bounds.max, step);
      case DateTimeColumn.minute:
        mi = snapToStep(mi, bounds.min, bounds.max, step);
      case DateTimeColumn.second:
        s = snapToStep(s, bounds.min, bounds.max, step);
    }
    result = DateTime(y, m, d, h, mi, s);
  }

  final maxDay = DateTimePickerSnapshot.daysInMonth(y, m);
  if (d > maxDay) {
    d = maxDay;
  }
  result = DateTime(y, m, d, h, mi, s);
  return DateTimePickerSnapshot.clampDateTime(result, start: start, end: safeEnd);
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
    DateTimePickerSteps? steps,
  }) {
    assert(columns.isNotEmpty,
        'DateTimePickerSnapshot: columns must not be empty');
    assert(
      start == null || end == null || !start.isAfter(end),
      'DateTimePickerSnapshot: start ($start) must not be after end ($end)',
    );
    final safeEnd = _safeEnd(start, end);
    final seed = initial ?? DateTime.now();
    final preClamp =
        DateTimePickerSnapshot.clampDateTime(seed, start: start, end: safeEnd);
    final yearAnchor = preClamp.year;
    final normalized = normalizePickerDateTime(
      preClamp,
      columns: columns,
      start: start,
      end: safeEnd,
      steps: steps,
      yearAnchor: yearAnchor,
    );
    return DateTimePickerSnapshot._(
      columns: List<DateTimeColumn>.unmodifiable(columns),
      current: normalized,
      // 年列默认范围锚定在「打开时」的选中年，滚动年份时不再以 current.year 为中心漂移。
      yearAnchor: yearAnchor,
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
  /// 若合并后 `current` / [columns] / [yearAnchor] 与旧快照相同，则 `==` 为 true，
  /// 上层可据此跳过 `setState`。
  DateTimePickerSnapshot applySelection({
    required List<int> rawValues,
    DateTime? start,
    DateTime? end,
    DateTimePickerSteps? steps,
  }) {
    final raw = _resolveDateTime(columns, rawValues, fallback: current);
    final normalized = normalizePickerDateTime(
      raw,
      columns: columns,
      start: start,
      end: end,
      steps: steps,
      yearAnchor: yearAnchor,
    );
    return DateTimePickerSnapshot._(
      columns: columns,
      current: normalized,
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
    DateTimePickerSteps? steps,
  }) {
    final normalized = normalizePickerDateTime(
      current,
      columns: columns,
      start: start,
      end: end,
      steps: steps,
      yearAnchor: yearAnchor,
    );
    return DateTimePickerSnapshot._(
      columns: List<DateTimeColumn>.unmodifiable(columns),
      current: normalized,
      yearAnchor: yearAnchor,
    );
  }

  /// 根据当前快照计算 `TPickerColumns`（给 picker 的 items）。
  ///
  /// 各列范围在 `[start, end]` 闭区间内按当前选中上下文收紧（见 [columnBounds]）。
  /// 仅含时间列时，按 [start]/[end] 的时钟分量收紧。
  ///
  /// [showWeek] 为 `true` 时，**日列**的默认 label 追加星期（如 "19日 周六"）。
  /// [renderLabel] 返回非 null 时优先于默认文案；日列返回非 null 时不追加星期。
  /// [labels] 缺省时使用 [DateTimePickerLabels.defaults]。
  TPickerColumns toPickerColumns({
    DateTime? start,
    DateTime? end,
    bool showWeek = false,
    DateTimePickerLabels? labels,
    DateTimePickerRenderLabel? renderLabel,
    DateTimePickerSteps? steps,
  }) {
    final resolvedLabels = labels ?? DateTimePickerLabels.defaults;
    final safeEnd = _safeEnd(start, end);
    final cols = <List<TPickerOption>>[];
    for (final col in columns) {
      cols.add(_buildColumnOptions(
        col,
        start: start,
        end: safeEnd,
        current: current,
        yearAnchor: yearAnchor,
        columns: columns,
        labels: resolvedLabels,
        showWeek: showWeek,
        renderLabel: renderLabel,
        steps: steps,
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

  /// 年范围相对锚定年份的默认偏移（前后各 10 年）。
  static const int defaultYearOffset = 10;

  /// 把 [dt] 钳制到 `[start, end]` 闭区间。
  static DateTime clampDateTime(DateTime dt, {DateTime? start, DateTime? end}) {
    if (start != null && dt.isBefore(start)) {
      return start;
    }
    if (end != null && dt.isAfter(end)) {
      return end;
    }
    return dt;
  }

  static int daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

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
    final maxDay = DateTimePickerSnapshot.daysInMonth(y, m);
    if (d > maxDay) {
      d = maxDay;
    }
    return DateTime(y, m, d, h, mi, s);
  }

  /// 单列 option 构造。
  ///
  /// [showWeek] 仅影响 [DateTimeColumn.day] 列的 label——`"19日"` → `"19日 周六"`。
  static List<TPickerOption> _buildColumnOptions(
    DateTimeColumn col, {
    required DateTime? start,
    required DateTime? end,
    required DateTime current,
    required int yearAnchor,
    required List<DateTimeColumn> columns,
    required DateTimePickerLabels labels,
    required bool showWeek,
    DateTimePickerRenderLabel? renderLabel,
    DateTimePickerSteps? steps,
  }) {
    if (col == DateTimeColumn.day) {
      final bounds = columnBounds(
        col,
        current: current,
        start: start,
        end: end,
        yearAnchor: yearAnchor,
        columns: columns,
      );
      if (!bounds.isValid) {
        return [
          TPickerOption(
            label: _resolveColumnLabel(
              col,
              current.day,
              labels,
              renderLabel: renderLabel,
            ),
            value: current.day,
          ),
        ];
      }
      return _buildDayRange(
        current,
        bounds.min,
        bounds.max,
        labels: labels,
        showWeek: showWeek,
        renderLabel: renderLabel,
        step: steps?.forColumn(col) ?? 1,
      );
    }

    final bounds = columnBounds(
      col,
      current: current,
      start: start,
      end: end,
      yearAnchor: yearAnchor,
      columns: columns,
    );
    if (!bounds.isValid) {
      final v = switch (col) {
        DateTimeColumn.year => current.year,
        DateTimeColumn.month => current.month,
        DateTimeColumn.hour => current.hour,
        DateTimeColumn.minute => current.minute,
        DateTimeColumn.second => current.second,
        DateTimeColumn.day => current.day,
      };
      return [
        TPickerOption(
          label: _resolveColumnLabel(col, v, labels, renderLabel: renderLabel),
          value: v,
        ),
      ];
    }
    return _buildIntRange(
      col,
      bounds.min,
      bounds.max,
      labels,
      renderLabel: renderLabel,
      step: steps?.forColumn(col) ?? 1,
    );
  }

  static String _resolveColumnLabel(
    DateTimeColumn column,
    int value,
    DateTimePickerLabels labels, {
    DateTimePickerRenderLabel? renderLabel,
  }) {
    final custom = renderLabel?.call(column, value);
    if (custom != null) {
      return custom;
    }
    return labels.formatColumn(column, value);
  }

  static List<TPickerOption> _buildIntRange(
    DateTimeColumn column,
    int min,
    int max,
    DateTimePickerLabels labels, {
    DateTimePickerRenderLabel? renderLabel,
    int step = 1,
  }) {
    if (max < min) {
      max = min;
    }
    if (step < 1) {
      step = 1;
    }
    if (step <= 1) {
      return [
        for (var v = min; v <= max; v++)
          TPickerOption(
            label: _resolveColumnLabel(
              column,
              v,
              labels,
              renderLabel: renderLabel,
            ),
            value: v,
          ),
      ];
    }
    final first = _firstStepValue(min, step);
    if (first > max) {
      final only = min.clamp(min, max);
      return [
        TPickerOption(
          label: _resolveColumnLabel(
            column,
            only,
            labels,
            renderLabel: renderLabel,
          ),
          value: only,
        ),
      ];
    }
    return [
      for (var v = first; v <= max; v += step)
        TPickerOption(
          label: _resolveColumnLabel(
            column,
            v,
            labels,
            renderLabel: renderLabel,
          ),
          value: v,
        ),
    ];
  }

  /// 日列专用构造：在 [showWeek] = true 时把对应日期的星期附加到 label 末尾。
  static List<TPickerOption> _buildDayRange(
    DateTime current,
    int startDay,
    int endDay, {
    required DateTimePickerLabels labels,
    required bool showWeek,
    DateTimePickerRenderLabel? renderLabel,
    int step = 1,
  }) {
    if (endDay < startDay) {
      endDay = startDay;
    }
    if (step < 1) {
      step = 1;
    }
    final first = step <= 1 ? startDay : _firstStepValue(startDay, step);
    if (first > endDay) {
      final only = startDay;
      return [
        TPickerOption(
          label: _dayOptionLabel(
            current.year,
            current.month,
            only,
            showWeek,
            labels,
            renderLabel,
          ),
          value: only,
        ),
      ];
    }
    return [
      for (var d = first; d <= endDay; d += step)
        TPickerOption(
          label: _dayOptionLabel(
            current.year,
            current.month,
            d,
            showWeek,
            labels,
            renderLabel,
          ),
          value: d,
        ),
    ];
  }

  static String _dayOptionLabel(
    int year,
    int month,
    int day,
    bool showWeek,
    DateTimePickerLabels labels,
    DateTimePickerRenderLabel? renderLabel,
  ) {
    final custom = renderLabel?.call(DateTimeColumn.day, day);
    if (custom != null) {
      return custom;
    }
    return _defaultDayLabel(year, month, day, showWeek, labels);
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

}

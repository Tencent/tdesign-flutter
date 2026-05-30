part of 't_date_time_picker_internal.dart';
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

  /// 构建单列 options（供滚轮局部更新）。
  List<TPickerOption> columnOptionsAt(
    int index, {
    DateTime? start,
    DateTime? end,
    bool showWeek = false,
    DateTimePickerLabels? labels,
    DateTimePickerRenderLabel? renderLabel,
    DateTimePickerSteps? steps,
  }) {
    assert(index >= 0 && index < columns.length);
    final resolvedLabels = labels ?? DateTimePickerLabels.defaults;
    final safeEnd = _safeEnd(start, end);
    return _buildColumnOptions(
      columns[index],
      start: start,
      end: safeEnd,
      current: current,
      yearAnchor: yearAnchor,
      columns: columns,
      labels: resolvedLabels,
      showWeek: showWeek,
      renderLabel: renderLabel,
      steps: steps,
    );
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
  /// 等价于 [columnIndicesWithChangedOptions] 非空（保留旧 API 语义）。
  bool needsColumnRebuildFrom(
    DateTimePickerSnapshot other, {
    bool showWeek = false,
    DateTime? start,
    DateTime? end,
  }) =>
      columnIndicesWithChangedOptions(
        other,
        showWeek: showWeek,
        start: start,
        end: end,
      ).isNotEmpty;

  /// 从 [other] → `this` 时，选项列表发生变化的列索引（按 [columns] 顺序）。
  ///
  /// 依据各列 [columnBounds] 是否变化；[showWeek] 时日列在「日」变化时也会重建 label。
  Set<int> columnIndicesWithChangedOptions(
    DateTimePickerSnapshot other, {
    bool showWeek = false,
    DateTime? start,
    DateTime? end,
  }) {
    if (!listEquals(columns, other.columns)) {
      return {for (var i = 0; i < columns.length; i++) i};
    }
    final safeEnd = _safeEnd(start, end);
    final changed = <int>{};
    for (var i = 0; i < columns.length; i++) {
      final col = columns[i];
      if (col == DateTimeColumn.day &&
          showWeek &&
          current.day != other.current.day) {
        changed.add(i);
        continue;
      }
      final ob = columnBounds(
        col,
        current: other.current,
        start: start,
        end: safeEnd,
        yearAnchor: yearAnchor,
        columns: columns,
      );
      final tb = columnBounds(
        col,
        current: current,
        start: start,
        end: safeEnd,
        yearAnchor: yearAnchor,
        columns: columns,
      );
      if (ob.min != tb.min || ob.max != tb.max) {
        changed.add(i);
      }
    }
    return changed;
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

part of 't_date_time_picker_internal.dart';
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
    return _timeOnlyColumnBounds(
      col,
      current: current,
      start: start,
      end: safeEnd,
    );
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
      final startDay = (start != null && _isSameMonth(current, start))
          ? start.day
          : 1;
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
  // coverage:ignore-line
  if (step <= 1) {
    // coverage:ignore-line
    return max;
  }
  final first = _firstStepValue(min, step); // coverage:ignore-line
  if (first > max) {
    // coverage:ignore-line
    return min;
  }
  final count = (max - first) ~/ step; // coverage:ignore-line
  return first + count * step; // coverage:ignore-line
}

int snapToStep(int value, int min, int max, int step) {
  if (max < min) {
    return min;
  }
  if (step <= 1) {
    return value.clamp(min, max);
  }
  final first = _firstStepValue(min, step);
  if (value < min) {
    return first > max ? min : first; // coverage:ignore-line
  }
  if (value > max) {
    return _lastStepValue(min, max, step); // coverage:ignore-line
  }
  final snapped = first + (((value - first) / step).round()) * step;
  if (snapped > max) {
    return _lastStepValue(min, max, step); // coverage:ignore-line
  }
  if (snapped < min) {
    return first > max ? min : first;
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
  var result = DateTimePickerSnapshot.clampDateTime(
    dt,
    start: start,
    end: safeEnd,
  );

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
  return DateTimePickerSnapshot.clampDateTime(
    result,
    start: start,
    end: safeEnd,
  );
}

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 't_date_time_picker_enums.dart';
import 't_date_time_picker_internal.dart';

// =============================================================================
// 模式
// =============================================================================

/// 列结构模式。
///
/// 通过 [DateMode]、[TimeMode] 组合列，至少传其一。相同列配置在 `==` / `hashCode`
/// 上相等。
///
/// ```dart
/// DateTimePickerMode(dateMode: DateMode.date) // 年月日
/// DateTimePickerMode(timeMode: TimeMode.minute) // 时分
/// DateTimePickerMode(dateMode: DateMode.date, timeMode: TimeMode.minute)
/// ```
abstract class DateTimePickerMode {
  @internal
  const DateTimePickerMode.forImplementation();

  /// 组合列结构。
  ///
  /// [dateMode]、[timeMode] 至少传其一，列按 date → time 顺序拼接。
  factory DateTimePickerMode({DateMode? dateMode, TimeMode? timeMode}) {
    assert(
      dateMode != null || timeMode != null,
      'DateTimePickerMode: dateMode 与 timeMode 不能同时为 null',
    );
    return CombinedMode(date: dateMode, time: timeMode);
  }

  /// 按显示顺序展开的列列表。
  List<DateTimeColumn> get columns;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateTimePickerMode && listEquals(columns, other.columns);

  @override
  int get hashCode => Object.hashAll(columns);
}

// =============================================================================
// 回调结果
// =============================================================================

/// 选择结果。
///
/// 字段为 `null` 表示当前 [DateTimePickerMode] 不含该列。
@immutable
class TDateTimePickerValue {
  /// 创建选择结果。
  const TDateTimePickerValue({
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.second,
  });

  /// 选中的年；当前 mode 不含该列时为 `null`。
  final int? year;

  /// 选中的月（1–12）；当前 mode 不含该列时为 `null`。
  final int? month;

  /// 选中的日（1–31）；当前 mode 不含该列时为 `null`。
  final int? day;

  /// 选中的时（0–23）；当前 mode 不含该列时为 `null`。
  final int? hour;

  /// 选中的分（0–59）；当前 mode 不含该列时为 `null`。
  final int? minute;

  /// 选中的秒（0–59）；当前 mode 不含该列时为 `null`。
  final int? second;

  /// 重组为 [DateTime]。
  ///
  /// mode 未包含的字段由 [fallback] 补齐；[fallback] 为 `null` 时使用 [DateTime.now]。
  /// 仅含部分列时建议传入安全 fallback（如 `DateTime(2000, 1, 1)`），
  /// 避免缺字段导致日期静默溢出。
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TDateTimePickerValue &&
          year == other.year &&
          month == other.month &&
          day == other.day &&
          hour == other.hour &&
          minute == other.minute &&
          second == other.second;

  @override
  int get hashCode => Object.hash(year, month, day, hour, minute, second);

  @override
  String toString() =>
      'TDateTimePickerValue(year: $year, month: $month, day: $day, '
      'hour: $hour, minute: $minute, second: $second)';
}

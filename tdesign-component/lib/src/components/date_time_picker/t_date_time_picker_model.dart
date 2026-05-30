import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import 't_date_time_picker_enums.dart';
import 't_date_time_picker_internal.dart';

// =============================================================================
// 模式
// =============================================================================

/// 滚轮列结构，由 [DateMode]、[TimeMode] 组合；通过 `DateTimePickerMode(dateMode:, timeMode:)` 构造。
abstract class DateTimePickerMode {
  @internal
  const DateTimePickerMode.forImplementation();

  /// 组合列结构，[dateMode]、[timeMode] 至少传其一。
  ///
  /// [dateMode] 日期段粒度，见 [DateMode]。
  /// [timeMode] 时间段粒度，见 [TimeMode]。
  factory DateTimePickerMode({DateMode? dateMode, TimeMode? timeMode}) {
    assert(
      dateMode != null || timeMode != null,
      'DateTimePickerMode: dateMode 与 timeMode 不能同时为 null',
    );
    return CombinedMode(date: dateMode, time: timeMode);
  }
}

// =============================================================================
// 回调结果
// =============================================================================

/// [TDateTimePicker.onChange] 返回值；`null` 字段表示当前 mode 不含该列。
/// 提交后端时调用 [toDateTime]；从 [DateTime] 初始化用 [fromDateTime]。
@immutable
class TDateTimePickerValue {
  /// 创建选中值，仅传当前 mode 涉及的字段。
  const TDateTimePickerValue({
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.second,
  });

  /// 从 [DateTime] 构造，用于 [TDateTimePicker.initialValue] 或 [TDateTimePicker.start]/[end]。
  factory TDateTimePickerValue.fromDateTime(DateTime dateTime) {
    return TDateTimePickerValue(
      year: dateTime.year,
      month: dateTime.month,
      day: dateTime.day,
      hour: dateTime.hour,
      minute: dateTime.minute,
      second: dateTime.second,
    );
  }

  /// 年。
  final int? year;

  /// 月。
  final int? month;

  /// 日。
  final int? day;

  /// 时。
  final int? hour;

  /// 分。
  final int? minute;

  /// 秒。
  final int? second;

  /// 年月日时分秒是否均已选中。
  bool get isComplete =>
      year != null &&
      month != null &&
      day != null &&
      hour != null &&
      minute != null &&
      second != null;

  /// 转为 [DateTime]；提交后端时使用，partial 值缺字段用 [fallback] 补齐。
  DateTime toDateTime({DateTime? fallback}) {
    if (isComplete) {
      return DateTime(year!, month!, day!, hour!, minute!, second!);
    }
    final resolved = fallback ?? kDateTimePickerDefaultFallback;
    return DateTime(
      year ?? resolved.year,
      month ?? resolved.month,
      day ?? resolved.day,
      hour ?? resolved.hour,
      minute ?? resolved.minute,
      second ?? resolved.second,
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

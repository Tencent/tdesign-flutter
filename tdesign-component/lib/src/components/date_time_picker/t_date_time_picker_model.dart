import 'package:flutter/foundation.dart';

import 't_date_time_picker_enums.dart';
import 't_date_time_picker_internal.dart';

// =============================================================================
// 模式
// =============================================================================

/// 滚轮列结构，由 [DateMode]、[TimeMode] 组合；通过 `DateTimePickerMode(dateMode:, timeMode:)` 构造。
abstract class DateTimePickerMode {
  /// 组合列结构，[dateMode]、[timeMode] 至少传其一。
  factory DateTimePickerMode({
    DateMode? dateMode,
    TimeMode? timeMode,
  }) {
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
///
/// 初始化 [TDateTimePicker.initialValue]、[start]、[end] 时仅传相关字段即可；
/// 提交后端时使用 [toDateTime]，partial 值须显式传入 [fallback]。
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

  /// 转为 [DateTime]；六元组完整时直接构造，否则用 [fallback] 补齐缺字段。
  ///
  /// partial 值未传 [fallback] 时将抛出 [ArgumentError]。
  DateTime toDateTime({DateTime? fallback}) {
    if (year != null &&
        month != null &&
        day != null &&
        hour != null &&
        minute != null &&
        second != null) {
      return DateTime(year!, month!, day!, hour!, minute!, second!);
    }
    if (fallback == null) {
      throw ArgumentError(
        'TDateTimePickerValue 为 partial 值，调用 toDateTime 须显式传入 fallback',
      );
    }
    return DateTime(
      year ?? fallback.year,
      month ?? fallback.month,
      day ?? fallback.day,
      hour ?? fallback.hour,
      minute ?? fallback.minute,
      second ?? fallback.second,
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

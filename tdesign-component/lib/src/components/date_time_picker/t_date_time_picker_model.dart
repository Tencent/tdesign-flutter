import 'package:flutter/foundation.dart';

import 't_date_time_picker_enums.dart';
import 't_date_time_picker_internal.dart';

// =============================================================================
// 模式
// =============================================================================

/// 滚轮列结构，由 [DateMode]、[TimeMode] 组合。
///
/// 通过 `DateTimePickerMode(dateMode:, timeMode:)` 构造，至少传其一：
/// - `dateMode`：日期段粒度（年 / 年月 / 年月日 / 月日）；不传则不展示日期列
/// - `timeMode`：时间段粒度（时 / 时分 / 时分秒）；不传则不展示时间列
@immutable
class DateTimePickerMode {
  /// 创建滚轮列结构；[dateMode]、[timeMode] 至少传其一。
  factory DateTimePickerMode({
    /// 日期段粒度；为 null 时不展示日期列。
    DateMode? dateMode,

    /// 时间段粒度；为 null 时不展示时间列。
    TimeMode? timeMode,
  }) {
    assert(
      dateMode != null || timeMode != null,
      'DateTimePickerMode: dateMode 与 timeMode 不能同时为 null',
    );
    return DateTimePickerMode._(dateMode, timeMode);
  }

  const DateTimePickerMode._(this.dateMode, this.timeMode);

  /// 日期段粒度；为 null 时不展示日期列。
  final DateMode? dateMode;

  /// 时间段粒度；为 null 时不展示时间列。
  final TimeMode? timeMode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateTimePickerMode &&
          dateMode == other.dateMode &&
          timeMode == other.timeMode;

  @override
  int get hashCode => Object.hash(dateMode, timeMode);
}

// =============================================================================
// 回调结果
// =============================================================================

/// `TDateTimePicker.onChanged` 返回值；`null` 字段表示当前 mode 不含该列。
///
/// 初始化 `TDateTimePicker.value`、`start`、`end` 时仅传相关字段即可；
/// 提交后端时使用 `toDateTime`，partial 值须显式传入 `fallback`。
@immutable
class TDateTimePickerValue {
  const TDateTimePickerValue({
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.second,
  });

  /// 年（1–9999）；当前 mode 不含年列或未赋值时为 null。
  final int? year;

  /// 月（1–12）；当前 mode 不含月列或未赋值时为 null。
  final int? month;

  /// 日（1–31）；当前 mode 不含日列或未赋值时为 null。
  final int? day;

  /// 时（0–23）；当前 mode 不含时列或未赋值时为 null。
  final int? hour;

  /// 分（0–59）；当前 mode 不含分列或未赋值时为 null。
  final int? minute;

  /// 秒（0–59）；当前 mode 不含秒列或未赋值时为 null。
  final int? second;

  /// 转为 [DateTime]
  ///
  /// - **完整值**：六元组均有值时直接构造
  /// - **partial 值**：缺字段用 [fallback] 补齐；未传 [fallback] 时抛出 [ArgumentError]
  /// - **典型用法**：提交后端前调用；partial 值须传入业务基准 [fallback]
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

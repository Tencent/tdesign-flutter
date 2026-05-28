import 'package:flutter/foundation.dart';

import 't_date_time_picker_enums.dart';
import 't_date_time_picker_internal.dart';

// =============================================================================
// 模式：sealed 类型
// =============================================================================

/// 列结构模式。快捷常量见下方静态成员；自定义组合用 [DateTimePickerMode.combined]。
abstract class DateTimePickerMode {
  const DateTimePickerMode();

  /// 快捷模式：年（只选年份）。
  static const DateTimePickerMode year = ShortcutMode(date: DateMode.year);

  /// 快捷模式：年 + 月（只选年月）。
  static const DateTimePickerMode month = ShortcutMode(date: DateMode.month);

  /// 快捷模式：年月日（Year-Month-Day，对齐 mobile-vue `mode: 'date'`）；等价于 `combined(dateMode: DateMode.date)`。
  static const DateTimePickerMode ymd = ShortcutMode(date: DateMode.date);

  /// 快捷模式：年 + 月 + 日 + 时（日期 + 小时）。
  static const DateTimePickerMode hour =
      ShortcutMode(date: DateMode.date, time: TimeMode.hour);

  /// 快捷模式：年 + 月 + 日 + 时 + 分（日期 + 时分）。
  static const DateTimePickerMode minute =
      ShortcutMode(date: DateMode.date, time: TimeMode.minute);

  /// 快捷模式：年 + 月 + 日 + 时 + 分 + 秒（日期 + 时分秒）。
  static const DateTimePickerMode second =
      ShortcutMode(date: DateMode.date, time: TimeMode.second);

  /// 组合模式：通过 [dateMode]、[timeMode] 自由搭配列结构。
  ///
  /// [dateMode] `DateMode.year`（年）、`DateMode.month`（年+月）、`DateMode.date`（年月日）；null 表示不含日期列。
  /// [timeMode] `TimeMode.hour`（时）、`TimeMode.minute`（时分）、`TimeMode.second`（时分秒）；null 表示不含时间列。
  ///
  /// 至少传其一（否则 assert）；两者都有时按 date→time 顺序拼接列。
  factory DateTimePickerMode.combined({DateMode? dateMode, TimeMode? timeMode}) {
    assert(
      dateMode != null || timeMode != null,
      'DateTimePickerMode.combined: dateMode 与 timeMode 不能同时为 null',
    );
    return CombinedMode(date: dateMode, time: timeMode);
  }

  /// 解析列结构（内部使用，业务方请用快捷常量或 [DateTimePickerMode.combined]）。
  List<DateTimeColumn> get columns;
}

// =============================================================================
// 回调结果
// =============================================================================

/// 选择结果；字段为 null 表示当前 [DateTimePickerMode] 不含该列；需 [DateTime] 时调用 [toDateTime]。
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
  /// mode 未包含的列用 [fallback] 对应字段补齐（null 则用 DateTime.now）。
  /// 仅含部分列时建议传入安全 fallback（如 `DateTime(2000, 1, 1)`），避免缺字段导致 [DateTime] 静默溢出。
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

// =============================================================================
// 枚举：日期·时间粒度 / 步进
// =============================================================================

import 'package:meta/meta.dart';

import 't_date_time_picker_column.dart';

/// 日期段粒度，用于 `DateTimePickerMode` 的 `DateMode` 参数。
enum DateMode {
  /// 年。
  year,

  /// 年 + 月。
  month,

  /// 年 + 月 + 日。
  date,
}

/// 时间段粒度，用于 `DateTimePickerMode` 的 `TimeMode` 参数。
enum TimeMode {
  /// 时。
  hour,

  /// 时 + 分。
  minute,

  /// 时 + 分 + 秒。
  second,
}

/// 各列选项步进，未配置的列步进为 1。
@immutable
class DateTimePickerSteps {
  /// 创建步进配置。
  const DateTimePickerSteps({
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.second,
  });

  /// 年列步进。
  final int? year;

  /// 月列步进。
  final int? month;

  /// 日列步进。
  final int? day;

  /// 时列步进。
  final int? hour;

  /// 分列步进。
  final int? minute;

  /// 秒列步进。
  final int? second;

  @internal
  int forColumn(DateTimeColumn column) {
    final step = switch (column) {
      DateTimeColumn.year => year,
      DateTimeColumn.month => month,
      DateTimeColumn.day => day,
      DateTimeColumn.hour => hour,
      DateTimeColumn.minute => minute,
      DateTimeColumn.second => second,
    };
    return step == null
        ? 1
        : step < 1
            ? 1
            : step;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateTimePickerSteps &&
          year == other.year &&
          month == other.month &&
          day == other.day &&
          hour == other.hour &&
          minute == other.minute &&
          second == other.second;

  @override
  int get hashCode => Object.hash(year, month, day, hour, minute, second);
}

// =============================================================================
// 枚举：列类型 / 日期·时间粒度 / 步进 / 自定义 label
// =============================================================================

import 'package:flutter/foundation.dart';

/// 自定义列 label。
///
/// [column] 为列类型，[value] 为该列数值；返回 `null` 时使用默认文案。
typedef DateTimePickerRenderLabel = String? Function(
  DateTimeColumn column,
  int value,
);

/// 选择器列类型。
enum DateTimeColumn {
  /// 年。
  year,

  /// 月（1–12）。
  month,

  /// 日（1–31，按该年该月实际天数）。
  day,

  /// 时（0–23）。
  hour,

  /// 分（0–59）。
  minute,

  /// 秒（0–59）。
  second,
}

/// [DateTimePickerMode] 的日期段粒度。
enum DateMode {
  /// 年。
  year,

  /// 年 + 月。
  month,

  /// 年 + 月 + 日。
  date,
}

/// [DateTimePickerMode] 的时间段粒度。
enum TimeMode {
  /// 时。
  hour,

  /// 时 + 分。
  minute,

  /// 时 + 分 + 秒。
  second,
}

/// 各列选项步进。
///
/// 对齐 mobile-vue `steps`（如 `{ minute: 5 }`）。未配置的列步进为 1。
/// 与 [TDateTimePicker.start]、[end] 同时使用时，在闭区间内按步进生成选项，
/// 选中值吸附到最近合法步进点。
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

  /// 返回 [column] 对应步进，最小为 1。
  int forColumn(DateTimeColumn column) {
    final step = switch (column) {
      DateTimeColumn.year => year,
      DateTimeColumn.month => month,
      DateTimeColumn.day => day,
      DateTimeColumn.hour => hour,
      DateTimeColumn.minute => minute,
      DateTimeColumn.second => second,
    };
    return step == null ? 1 : step < 1 ? 1 : step;
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
  int get hashCode =>
      Object.hash(year, month, day, hour, minute, second);
}

// =============================================================================
// 枚举：列类型 / 日期·时间粒度
// =============================================================================

/// `TDateTimePicker` 内部可显示的列类型。
enum DateTimeColumn {
  /// 年。
  year,

  /// 月（1–12）。
  month,

  /// 日（1–31，依据该年该月的实际天数）。
  day,

  /// 时（0–23）。
  hour,

  /// 分（0–59）。
  minute,

  /// 秒（0–59）。
  second,
}

/// [DateTimePickerMode.combined] 的 `dateMode` 参数：日期段粒度。
enum DateMode {
  /// 年。
  year,

  /// 年 + 月。
  month,

  /// 年 + 月 + 日。
  date,
}

/// [DateTimePickerMode.combined] 的 `timeMode` 参数：时间段粒度。
enum TimeMode {
  /// 时。
  hour,

  /// 时 + 分。
  minute,

  /// 时 + 分 + 秒。
  second,
}

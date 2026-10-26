/// 日期在日历格中的选中和展示状态。
enum DateSelectType {
  /// 单选或多选下的选中。
  selected,

  /// 超出可选日期范围。
  disabled,

  /// 区间起点。
  start,

  /// 区间中间日期。
  centre,

  /// 区间终点。
  end,

  /// 未选中且可选。
  empty,
}

/// 每周的起始日。
enum TCalendarFirstDayOfWeek {
  /// 星期日作为一周第一天。
  sunday,

  /// 星期一作为一周第一天。
  monday,

  /// 星期二作为一周第一天。
  tuesday,

  /// 星期三作为一周第一天。
  wednesday,

  /// 星期四作为一周第一天。
  thursday,

  /// 星期五作为一周第一天。
  friday,

  /// 星期六作为一周第一天。
  saturday,
}

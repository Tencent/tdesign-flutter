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

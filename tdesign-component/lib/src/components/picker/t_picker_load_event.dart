/// 列选中变化的事件参数
///
/// 每当用户在某一列滚动到一个 enabled 项后，`TPicker.onLoad` 会收到一个该事件实例。
/// 事件里携带了"列索引、当前列总数、距底部剩余项数、联动模式下父级选中值"等
/// 上下文信息，业务层据此自行决定是否加载更多数据（例如：
/// `if (e.remaining > 5) return;`）。
class TPickerLoadEvent {
  const TPickerLoadEvent({
    required this.column,
    this.parentValue,
    required this.displayedCount,
    required this.remaining,
  });

  /// 触发事件的列索引（0 表示第一列）
  final int column;

  /// 当前列的父级选中值（联动模式下使用）
  ///
  /// 第一列时为 null；业务层可用此值从原始数据中筛选子级选项。
  final dynamic parentValue;

  /// 当前列已展示的选项总数
  final int displayedCount;

  /// 距底部剩余的选项数（业务可用此值做"接近底部时加载"判断）
  final int remaining;

  @override
  String toString() =>
      'TPickerLoadEvent(column: $column, parentValue: $parentValue, '
      'displayedCount: $displayedCount, remaining: $remaining)';
}

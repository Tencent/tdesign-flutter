import 't_picker_option.dart';

/// onChange 回调返回的选中信息
///
/// 只包含"选了什么"，不包含滚动位置信息
/// 滚动位置相关请使用 onLoad
class TPickerValue {
  /// 当前选中的 value 列表（每列的 TPickerOption.value）
  final List<dynamic> values;

  /// 当前选中的索引列表
  final List<int> indexes;

  TPickerValue({
    required this.values,
    required this.indexes,
  });

  @override
  String toString() => 'TPickerValue($values, indexes: $indexes)';
}

/// onLoad 回调参数 — 滚动接近底部时触发
///
/// 包含滚动位置信息，用于按需加载更多数据
class TPickerLoadEvent {
  /// 当前是第几列（从 0 开始）
  final int column;

  /// 该列的父级选中值（第一列为 null）
  final dynamic parentValue;

  /// 该列当前已显示的数据量
  final int displayedCount;

  /// 距离底部还有多少项
  final int remaining;

  TPickerLoadEvent({
    required this.column,
    required this.parentValue,
    required this.displayedCount,
    required this.remaining,
  });

  @override
  String toString() =>
      'TPickerLoadEvent(col:$column, parent:$parentValue, '
      'displayed:$displayedCount, remaining:$remaining)';
}

import 't_picker_option.dart';

/// onChange 回调返回的选中信息
///
/// 每列返回完整的 [TPickerOption]，包含 label、value、disabled 等全部字段。
/// 调用方可按需取值：
/// ```dart
/// onChange: (v) {
///   // 取显示文本
///   final labels = v.selectedOptions.map((o) => o.label).join(' / ');
///   // 取业务值
///   final values = v.selectedOptions.map((o) => o.value).toList();
/// }
/// ```
class TPickerValue {
  /// 每列选中的完整 option（顺序对应列号）
  final List<TPickerOption> selectedOptions;

  /// 每列在当前数据列表中的索引（便捷访问）
  final List<int> indexes;

  /// 便捷属性：所有 value 的列表（向后兼容）
  List<dynamic> get values => selectedOptions.map((o) => o.value).toList();

  /// 便捷属性：所有 label 的列表
  List<String> get labels => selectedOptions.map((o) => o.label).toList();

  TPickerValue({
    required this.selectedOptions,
    required this.indexes,
  });

  @override
  String toString() =>
      'TPickerValue(labels: $labels, values: $values, indexes: $indexes)';
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

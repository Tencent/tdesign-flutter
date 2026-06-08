import 'package:flutter/foundation.dart';

import 'picker_option.dart';

/// onChange 回调返回的选中信息
///
/// ```dart
/// onChange: (col, v) => setState(() => _lastValue = v);
/// Text(_lastValue?.labels.join(' / ') ?? '');
/// ```
@immutable
class TPickerValue {
  TPickerValue({
    required this.selectedOptions,
    required this.indexes,
  });

  /// 每列选中的完整 option
  ///
  /// - **类型**：`List<TPickerOption>`，顺序与列顺序对应
  /// - **用途**：拿到原始 option 以便读取 `disabled`、自定义展示等扩展字段
  final List<TPickerOption> selectedOptions;

  /// 每列选中项的索引
  ///
  /// - **类型**：`List<int>`，顺序与列顺序对应
  /// - **典型用法**：`value.indexes[col]` 配合 `TPicker.onColumnScrollEnd` 判定是否接近列底触发分页
  final List<int> indexes;

  /// 所有选中项的 value（提交表单用）
  ///
  /// - **类型**：`List<dynamic>`，顺序与列顺序对应
  /// - **懒计算**：`late final` 首次访问时构造 `UnmodifiableListView` 并缓存
  /// - **不可变**：禁止外部赋值（违反 `late final` 契约会抛 `LateInitializationError`），如需新值请构造新 [TPickerValue]
  late final List<dynamic> values =
      List.unmodifiable(selectedOptions.map((o) => o.value));

  /// 所有选中项的 label（展示用）
  ///
  /// - **类型**：`List<String>`，顺序与列顺序对应
  /// - **懒计算**：同 [values]
  /// - **典型用法**：`labels.join(' / ')` 直接渲染为 "广东 / 深圳 / 南山"
  late final List<String> labels =
      List.unmodifiable(selectedOptions.map((o) => o.label));

  @override
  String toString() =>
      'TPickerValue(labels: $labels, values: $values, indexes: $indexes)';
}

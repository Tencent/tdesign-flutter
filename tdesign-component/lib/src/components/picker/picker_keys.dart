import 'package:flutter/foundation.dart';

/// 字段映射配置
///
/// 当 picker 数据源不是 `TPickerOption` 时，用于声明原始结构中的字段名。
///
/// ```dart
/// // 数据：[{ id: '1', name: '选项A', readonly: false }]
/// const keys = TPickerKeys(label: 'name', value: 'id', disabled: 'readonly');
/// ```
@immutable
class TPickerKeys {
  const TPickerKeys({
    this.label = 'label',
    this.value = 'value',
    this.disabled = 'disabled',
    this.children = 'children',
  });

  /// 展示文案对应的字段名，默认 `label`
  ///
  /// - **生效范围**：`TPickerColumns.fromRaw` / `TPickerLinked.fromRaw` 解析 raw 元素时
  /// - **回退**：raw 为非 Map 时使用 `raw.toString()` 作为 label
  final String label;

  /// 业务值对应的字段名，默认 `value`
  ///
  /// - **生效范围**：`TPickerColumns.fromRaw` / `TPickerLinked.fromRaw` 解析 raw 元素时
  /// - **类型**：`dynamic`，保留原始类型（`int` / `String` / enum 等）
  final String value;

  /// 禁用标记对应的字段名，默认 `disabled`
  ///
  /// - **生效范围**：`TPickerColumns.fromRaw` / `TPickerLinked.fromRaw` 解析 raw 元素时
  /// - **判别**：字段值必须为 `bool`；非 `bool` 视为未禁用
  final String disabled;

  /// 联动模式下子级数据对应的字段名，默认 `children`
  ///
  /// - **生效范围**：`TPickerLinked.fromRaw` 解析 raw `Map` value 时
  /// - **要求**：子级 value 须为 `Map`（继续下钻）或 `List`（叶子级选项）
  final String children;

  /// 默认配置（`label / value / disabled / children`）
  static const TPickerKeys defaults = TPickerKeys();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TPickerKeys &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          value == other.value &&
          disabled == other.disabled &&
          children == other.children;

  @override
  int get hashCode => Object.hash(label, value, disabled, children);

  @override
  String toString() =>
      'TPickerKeys(label: $label, value: $value, disabled: $disabled, children: $children)';
}

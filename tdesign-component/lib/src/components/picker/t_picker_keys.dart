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
  final String label;

  /// 业务值对应的字段名，默认 `value`
  final String value;

  /// 禁用标记对应的字段名，默认 `disabled`
  final String disabled;

  /// 联动模式下子级数据对应的字段名，默认 `children`
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

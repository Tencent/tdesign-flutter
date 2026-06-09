import 'package:flutter/foundation.dart';

/// `fromRaw` 字段名映射；接口字段非默认 label/value/disabled/children 时使用。
@immutable
class TPickerKeys {
  const TPickerKeys({
    this.label = 'label',
    this.value = 'value',
    this.disabled = 'disabled',
    this.children = 'children',
  });

  /// 展示文案字段名，默认 `label`
  final String label;

  /// 业务值字段名，默认 `value`
  final String value;

  /// 禁用标记字段名，默认 `disabled`
  final String disabled;

  /// 联动子级字段名，默认 `children`
  final String children;

  /// 默认配置
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

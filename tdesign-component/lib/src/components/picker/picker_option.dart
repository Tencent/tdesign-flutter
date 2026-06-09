import 'package:flutter/foundation.dart';

/// 选择器选项。`label` 用于展示，`value` 用于 onChange 回传。
@immutable
class TPickerOption {
  const TPickerOption({
    required this.label,
    required this.value,
    this.disabled = false,
  });

  /// 展示文字（可含 emoji、单位等）
  final String label;

  /// 业务值（[TPickerValue.values] 按列回传）
  final dynamic value;

  /// 是否禁用该项（置灰且不可选中），默认 false
  final bool disabled;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TPickerOption &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          value == other.value &&
          disabled == other.disabled;

  @override
  int get hashCode => Object.hash(label, value, disabled);

  @override
  String toString() => 'TPickerOption($label, $value)';
}

import 'package:flutter/foundation.dart';

/// 选择器选项
///
/// label 用于显示，value 用于 onChange 返回，两者分离
/// 支持自定义显示（emoji、单位、国际化）同时保持纯净的业务值
///
/// ```dart
/// TPickerOption(label: '👨 男性', value: 'M')
/// TPickerOption(label: '18岁', value: 18)
/// TPickerOption(label: '广东省', value: 'GD', disabled: true)
/// ```
@immutable
class TPickerOption {
  const TPickerOption({
    required this.label,
    required this.value,
    this.disabled = false,
  });

  /// 显示文字（可包含 emoji、单位、国际化等）
  final String label;

  /// 实际值（onChange 回调返回此字段）
  final dynamic value;

  /// 是否禁用（不可选中/置灰显示），默认 false
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

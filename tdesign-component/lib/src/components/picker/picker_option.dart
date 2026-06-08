import 'package:flutter/foundation.dart';

/// 选择器选项
///
/// label 用于显示，value 用于 onChange 返回，两者分离以便自定义展示
/// （emoji、单位、国际化）同时保持纯净的业务值。
///
/// ```dart
/// TPickerOption(label: '👨 男性', value: 'M')
/// TPickerOption(label: '广东省', value: 'GD', disabled: true)
/// ```
@immutable
class TPickerOption {
  const TPickerOption({
    required this.label,
    required this.value,
    this.disabled = false,
  });

  /// 展示文字（可包含 emoji、单位、国际化等）
  ///
  /// - **用途**：用户可见的选项文案
  /// - **建议**：emoji / 单位放在 label 保持纯净的业务值
  final String label;

  /// 业务值（onChange 回调返回此字段）
  ///
  /// - **类型**：`dynamic` 以兼容 `String` / `int` / 枚举 / 自定义 model
  /// - **回传**：`TPickerValue.values` 中按列顺序返回该字段
  final dynamic value;

  /// 是否禁用（不可选中 / 置灰显示），默认 false
  ///
  /// - **禁用态**：滚动经过时不立刻修正，等滚动结束由 `TPicker.onColumnScrollEnd` 收口
  /// - **视觉**：透明度降为 0.5，文字色降为 `textDisabledColor`
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

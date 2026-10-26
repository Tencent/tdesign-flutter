import 'package:flutter/material.dart';

import 't_tag.dart';
import 't_tag_types.dart';

/// 严格受控的可选标签。
class TSelectTag extends StatelessWidget {
  const TSelectTag(
    this.text, {
    super.key,
    required this.value,
    this.onChanged,
    this.colorPreset = TTagColorPreset.primary,
    this.variant = TTagVariant.dark,
    this.icon,
    this.size = TTagSize.medium,
    this.shape = TTagShape.square,
  });

  /// 标签内容。
  final String text;

  /// 当前选中状态。
  final bool value;

  /// 选中状态变更回调；为空时禁用交互。
  final ValueChanged<bool>? onChanged;

  /// 选中态预设配色。
  final TTagColorPreset colorPreset;

  /// 标签绘制形态。
  final TTagVariant variant;

  /// 标签图标。
  final IconData? icon;

  /// 标签尺寸。
  final TTagSize size;

  /// 标签外形；具体圆角值由组件 Theme 或全局 Token 决定。
  final TTagShape shape;

  @override
  Widget build(BuildContext context) {
    final effectiveColorPreset = value
        ? colorPreset
        : TTagColorPreset.defaultTheme;

    return Semantics(
      enabled: onChanged != null,
      selected: value,
      child: TTag(
        text,
        colorPreset: effectiveColorPreset,
        variant: variant,
        icon: icon,
        size: size,
        shape: shape,
        enabled: onChanged != null,
        onTap: onChanged == null ? null : () => onChanged!(!value),
      ),
    );
  }
}

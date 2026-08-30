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
    this.colorScheme = TTagColorScheme.primary,
    this.variant = TTagVariant.dark,
    this.icon,
    this.size = TTagSize.medium,
  });

  /// 标签内容。
  final String text;

  /// 当前选中状态。
  final bool value;

  /// 选中状态变更回调；为空时禁用交互。
  final ValueChanged<bool>? onChanged;

  /// 选中态预设配色。
  final TTagColorScheme colorScheme;

  /// 标签绘制形态。
  final TTagVariant variant;

  /// 标签图标。
  final IconData? icon;

  /// 标签尺寸。
  final TTagSize size;

  @override
  Widget build(BuildContext context) {
    final effectiveColorScheme = value
        ? colorScheme
        : TTagColorScheme.defaultTheme;

    return Semantics(
      enabled: onChanged != null,
      selected: value,
      child: TTag(
        text,
        colorScheme: effectiveColorScheme,
        variant: variant,
        icon: icon,
        size: size,
        enabled: onChanged != null,
        onTap: onChanged == null ? null : () => onChanged!(!value),
      ),
    );
  }
}

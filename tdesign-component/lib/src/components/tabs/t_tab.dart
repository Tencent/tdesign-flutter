import 'package:flutter/material.dart';

import '../badge/t_badge.dart';

/// Tab 组件 v1.0
///
/// Material Tab 薄包装。禁用：`enabled: false`。
class TTab extends Tab {
  /// 文字内容
  @override
  final String? text;

  /// 子widget
  @override
  final Widget? child;

  /// 图标
  @override
  final Widget? icon;

  /// 徽标
  final TBadge? badge;

  /// 是否可用，默认 true；`false` 即禁用
  final bool enabled;

  @override
  const TTab({
    Key? key,
    this.text,
    this.child,
    this.icon,
    this.badge,
    this.enabled = true,
  })  : assert(
          text == null || child == null,
          'text and child cannot be provided together.',
        ),
        assert(
          text != null || child != null || icon != null,
          'Provide text, child, or icon.',
        ),
        super(
          key: key,
          text: text,
          child: child,
          icon: icon,
        );

  @override
  Size get preferredSize => const Size.fromHeight(46);

  @override
  Widget build(BuildContext context) {
    var label = text != null || child != null ? _buildLabelContent() : null;
    if (icon != null) {
      label = label == null
          ? icon!
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[icon!, const SizedBox(width: 4), label],
            );
    }
    if (badge != null) {
      // Let Material's Badge lay out against the complete tab content. A
      // positioned standalone badge does not contribute to Stack's size and
      // can cover an icon or label.
      label = TBadge(
        label: badge!.label,
        variant: badge!.variant,
        border: badge!.border,
        showZero: badge!.showZero,
        onTap: badge!.onTap,
        child: label!,
      );
    }

    return IgnorePointer(
      ignoring: !enabled,
      child: Center(widthFactor: 1.0, child: label),
    );
  }

  Widget _buildLabelContent() {
    if (child != null) {
      return child!;
    }
    return Text(
      text!,
      softWrap: false,
      overflow: TextOverflow.fade,
    );
  }
}

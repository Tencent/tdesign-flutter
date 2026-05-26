import 'package:flutter/material.dart';

import '../theme/t_spacers.dart';
import '../theme/t_theme.dart';

/// 工具栏文字/图标按钮统一按压反馈：按下时整体透明度动画。
///
/// 用于 [TPicker]、[TPopup] 等「取消 | 标题 | 确认」类工具栏，后续组件请复用。
class TToolbarPressable extends StatefulWidget {
  const TToolbarPressable({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.enabled = true,
    this.pressDuration = kToolbarPressDuration,
    this.pressedOpacity = kToolbarPressedOpacity,
    this.mergeTextStyle,
    this.mergeIconTheme,
  });

  /// 按压动画时长（与 TDesign 工具栏规范一致）。
  static const Duration kToolbarPressDuration = Duration(milliseconds: 100);

  /// 按下时的目标透明度。
  static const double kToolbarPressedOpacity = 0.5;

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final bool enabled;
  final Duration pressDuration;
  final double pressedOpacity;

  /// 为子树 [Text] 提供默认样式（merge 语义，子控件已有样式优先）。
  final TextStyle? mergeTextStyle;

  /// 为子树 [Icon] 提供默认样式。
  final IconThemeData? mergeIconTheme;

  @override
  State<TToolbarPressable> createState() => _TToolbarPressableState();
}

class _TToolbarPressableState extends State<TToolbarPressable> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (!widget.enabled || widget.onTap == null) {
      return;
    }
    if (_pressed == value) {
      return;
    }
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = TTheme.of(context);
    final padding = widget.padding ??
        EdgeInsets.symmetric(
          horizontal: theme.spacer8,
          vertical: theme.spacer12,
        );

    Widget child = widget.child;
    if (widget.mergeTextStyle != null) {
      child = DefaultTextStyle.merge(
        style: widget.mergeTextStyle!,
        child: child,
      );
    }
    if (widget.mergeIconTheme != null) {
      child = IconTheme.merge(
        data: widget.mergeIconTheme!,
        child: child,
      );
    }

    final enabled = widget.enabled && widget.onTap != null;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? (_) => _setPressed(true) : null,
      onTapUp: enabled ? (_) => _setPressed(false) : null,
      onTapCancel: enabled ? () => _setPressed(false) : null,
      onTap: enabled ? widget.onTap : null,
      child: AnimatedOpacity(
        duration: widget.pressDuration,
        opacity: _pressed ? widget.pressedOpacity : 1,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

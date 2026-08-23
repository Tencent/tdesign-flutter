import 'package:flutter/material.dart';

import 't_link_resolve.dart';
import 't_link_theme_data.dart';
import 't_link_types.dart';

/// 文字超链接用于跳转一个新页面，如当前项目跳转、友情链接等。
///
/// 下划线、前置图标和后置图标可独立组合；路由行为由 [onPressed] 与 Flutter
/// Navigator / Router 组合。
class TLink extends StatelessWidget {
  const TLink({
    super.key,
    this.child,
    this.prefixIcon,
    this.suffixIcon,
    this.underline,
    this.colorScheme,
    this.size,
    this.onPressed,
    this.semanticLabel,
    this.tooltip,
  });

  /// 链接内容，通常为 [Text]。
  final Widget? child;

  /// 前置图标；为 null 时不占位。
  final Widget? prefixIcon;

  /// 后置图标；为 null 时不占位。
  final Widget? suffixIcon;

  /// 是否显示下划线；未设置时读取 [TLinkThemeData.underline]，最终回退 false。
  final bool? underline;

  /// 语义颜色方案；未设置时默认为 [TLinkColorScheme.defaultTheme]。
  final TLinkColorScheme? colorScheme;

  /// 链接尺寸；未设置时默认为 [TLinkSize.medium]。
  final TLinkSize? size;

  /// 点击回调；为 null 时链接为禁用态。
  final VoidCallback? onPressed;

  /// 无障碍语义标签。
  final String? semanticLabel;

  /// 鼠标悬浮提示。
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TLinkThemeData>();
    return _TLinkInteraction(
      child: child,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      underline: underline ?? theme?.underline ?? false,
      colorScheme:
          colorScheme ??
          theme?.defaultColorScheme ??
          TLinkColorScheme.defaultTheme,
      size: size ?? theme?.defaultSize ?? TLinkSize.medium,
      onPressed: onPressed,
      semanticLabel: semanticLabel,
      tooltip: tooltip,
      theme: theme,
    );
  }
}

class _TLinkInteraction extends StatefulWidget {
  const _TLinkInteraction({
    required this.child,
    required this.prefixIcon,
    required this.suffixIcon,
    required this.underline,
    required this.colorScheme,
    required this.size,
    required this.onPressed,
    required this.semanticLabel,
    required this.tooltip,
    required this.theme,
  });

  final Widget? child;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool underline;
  final TLinkColorScheme colorScheme;
  final TLinkSize size;
  final VoidCallback? onPressed;
  final String? semanticLabel;
  final String? tooltip;
  final TLinkThemeData? theme;

  @override
  State<_TLinkInteraction> createState() => _TLinkInteractionState();
}

class _TLinkInteractionState extends State<_TLinkInteraction> {
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null;
    final color = TLinkResolve.resolveColor(
      context: context,
      colorScheme: widget.colorScheme,
      theme: widget.theme,
      isDisabled: disabled,
      isActive: !disabled && (_hovered || _focused || _pressed),
    );
    final textStyle = TLinkResolve.resolveTextStyle(
      context: context,
      size: widget.size,
      theme: widget.theme,
      color: color,
    );
    final iconSize = TLinkResolve.resolveIconSize(
      size: widget.size,
      theme: widget.theme,
    );
    final iconGap = TLinkResolve.resolveIconGap(
      context: context,
      theme: widget.theme,
    );

    var content = IconTheme.merge(
      data: IconThemeData(color: color, size: iconSize),
      child: DefaultTextStyle.merge(
        style: textStyle,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.prefixIcon != null) ...[
              widget.prefixIcon!,
              if (widget.child != null) SizedBox(width: iconGap),
            ],
            if (widget.child != null) Flexible(child: widget.child!),
            if (widget.suffixIcon != null) ...[
              if (widget.child != null) SizedBox(width: iconGap),
              widget.suffixIcon!,
            ],
          ],
        ),
      ),
    );

    if (widget.underline) {
      content = DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: color)),
        ),
        child: content,
      );
    }

    content = InkWell(
      onTap: widget.onPressed,
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      onHover: (value) => _updateInteraction(_Interaction.hover, value),
      onFocusChange: (value) => _updateInteraction(_Interaction.focus, value),
      onHighlightChanged: (value) =>
          _updateInteraction(_Interaction.press, value),
      child: content,
    );

    if (widget.tooltip != null) {
      content = Tooltip(message: widget.tooltip!, child: content);
    }
    return Semantics(
      link: true,
      enabled: !disabled,
      label: widget.semanticLabel,
      child: content,
    );
  }

  void _updateInteraction(_Interaction interaction, bool value) {
    if (!mounted || widget.onPressed == null) {
      return;
    }
    setState(() {
      switch (interaction) {
        case _Interaction.hover:
          _hovered = value;
          break;
        case _Interaction.focus:
          _focused = value;
          break;
        case _Interaction.press:
          _pressed = value;
          break;
      }
    });
  }
}

enum _Interaction { hover, focus, press }

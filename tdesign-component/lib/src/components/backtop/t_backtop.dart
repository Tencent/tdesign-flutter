import 'package:flutter/material.dart';
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../text/t_text.dart';
import 't_backtop_theme_data.dart';

/// 返回顶部组件。
///
/// 绑定 [controller] 后，滚动偏移达到 [visibilityOffset] 时显示；点击时先
/// 动画回到顶部，再触发可选的 [onPressed] 完成通知。
class TBackTop extends StatefulWidget {
  const TBackTop({
    Key? key,
    this.controller,
    this.onPressed,
    this.showText = false,
    this.visibilityOffset = 200,
    this.tooltip,
    this.shape = TBackTopShape.circle,
    this.colorScheme = TBackTopColorScheme.light,
  }) : assert(visibilityOffset >= 0),
       super(key: key);

  /// 页面滚动控制器。
  ///
  /// 未传时组件始终可见，点击只触发 [onPressed]；传入后组件监听滚动偏移并
  /// 在点击时动画回到该滚动位置的最小边界。
  final ScrollController? controller;

  /// 回顶动画完成后的通知。
  ///
  /// `null` 不表示禁用；只要提供 [controller]，组件仍可点击并执行回顶。
  final VoidCallback? onPressed;

  /// 是否显示设计内置文案。
  ///
  /// 圆形显示“顶部”，半圆形显示“返回/顶部”，文案来自当前资源代理。
  final bool showText;

  /// 绑定 [controller] 时的显示阈值，默认 200。
  ///
  /// 滚动偏移大于或等于该值时显示；未绑定 [controller] 时不参与显隐。
  final double visibilityOffset;

  /// 读屏和 Tooltip 提示；未传时使用当前资源代理的“返回顶部”。
  final String? tooltip;

  /// 结构形态，默认 [TBackTopShape.circle]。
  final TBackTopShape shape;

  /// 预设配色，默认 [TBackTopColorScheme.light]。
  final TBackTopColorScheme colorScheme;

  @override
  State<TBackTop> createState() => _TBackTopState();
}

class _TBackTopState extends State<TBackTop> {
  bool _isAnimating = false;
  bool _isVisible = false;

  TBackTopThemeData get _themeData =>
      Theme.of(context).extension<TBackTopThemeData>() ??
      const TBackTopThemeData();

  @override
  void initState() {
    super.initState();
    _isVisible = widget.controller == null;
    _attachScrollListener(widget.controller);
    _scheduleVisibilitySync();
  }

  @override
  void didUpdateWidget(covariant TBackTop oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _detachScrollListener(oldWidget.controller);
      _attachScrollListener(widget.controller);
    }
    if (oldWidget.controller != widget.controller ||
        oldWidget.visibilityOffset != widget.visibilityOffset) {
      _syncVisibility();
      _scheduleVisibilitySync();
    }
  }

  @override
  void dispose() {
    _detachScrollListener(widget.controller);
    super.dispose();
  }

  void _attachScrollListener(ScrollController? controller) {
    controller?.addListener(_syncVisibility);
  }

  void _detachScrollListener(ScrollController? controller) {
    controller?.removeListener(_syncVisibility);
  }

  void _scheduleVisibilitySync() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _syncVisibility();
      }
    });
  }

  void _syncVisibility() {
    final controller = widget.controller;
    final shouldShow = controller == null
        ? true
        : controller.hasClients && controller.offset >= widget.visibilityOffset;
    if (shouldShow != _isVisible && mounted) {
      setState(() => _isVisible = shouldShow);
    }
  }

  String _resolveTooltip(BuildContext context) {
    return widget.tooltip ?? '${context.resource.back}${context.resource.top}';
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return const SizedBox.shrink();
    }

    final hasAction = widget.controller != null || widget.onPressed != null;
    final child = widget.shape == TBackTopShape.circle
        ? _buildCircleWidget(context)
        : _buildHalfCircleWidget(context);

    return Semantics(
      button: true,
      enabled: hasAction,
      label: _resolveTooltip(context),
      child: Tooltip(
        message: _resolveTooltip(context),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: hasAction ? _handleTap : null,
          child: child,
        ),
      ),
    );
  }

  Future<void> _handleTap() async {
    if (_isAnimating) {
      return;
    }

    final controller = widget.controller;
    if (controller != null && controller.hasClients) {
      _isAnimating = true;
      try {
        await controller.animateTo(
          controller.position.minScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      } finally {
        _isAnimating = false;
      }
    }

    if (mounted) {
      widget.onPressed?.call();
    }
  }

  _BackTopVisualStyle _resolveStyle(BuildContext context) {
    final token = context.tTheme;
    final theme = _themeData;
    final isDark = widget.colorScheme == TBackTopColorScheme.dark;
    final defaultBackground = isDark
        ? widget.shape == TBackTopShape.circle
              ? token.grayColor13
              : token.grayColor14
        : token.bgColorContainer;
    final defaultContent = isDark
        ? token.textColorAnti
        : token.textColorPrimary;
    return _BackTopVisualStyle(
      backgroundColor: theme.backgroundColor ?? defaultBackground,
      borderColor:
          theme.borderColor ??
          (isDark ? token.grayColor9 : token.componentBorderColor),
      contentColor: theme.contentColor ?? defaultContent,
      roundSize: theme.roundSize ?? 48,
      halfCircleHeight: theme.halfCircleHeight ?? 40,
      halfCircleMinWidth: theme.halfCircleMinWidth ?? 38,
      iconSize: theme.iconSize ?? 20,
      borderWidth: theme.borderWidth ?? 0.5,
      halfCircleHorizontalPadding: theme.halfCircleHorizontalPadding ?? 8,
      contentGap: theme.contentGap ?? 2,
      textStyle: TextStyle(
        fontSize: token.fontMarkExtraSmall?.size ?? 10,
        height: 1.2,
        fontWeight: token.fontMarkExtraSmall?.fontWeight ?? FontWeight.w600,
        color: theme.contentColor ?? defaultContent,
      ).merge(theme.textStyle),
    );
  }

  Widget _buildCircleWidget(BuildContext context) {
    final style = _resolveStyle(context);
    return Container(
      width: style.roundSize,
      height: style.roundSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.tTheme.radiusCircle),
        border: Border.all(color: style.borderColor, width: style.borderWidth),
        color: style.backgroundColor,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              TIcons.backtop,
              size: style.iconSize,
              color: style.contentColor,
            ),
            if (widget.showText)
              TText(
                context.resource.top,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: style.textStyle,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHalfCircleWidget(BuildContext context) {
    final style = _resolveStyle(context);
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: style.halfCircleMinWidth),
      child: Container(
        height: style.halfCircleHeight,
        padding: EdgeInsets.symmetric(
          horizontal: style.halfCircleHorizontalPadding,
        ),
        decoration: BoxDecoration(
          color: style.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(context.tTheme.radiusCircle),
            bottomLeft: Radius.circular(context.tTheme.radiusCircle),
          ),
          border: Border.all(
            color: style.borderColor,
            width: style.borderWidth,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              TIcons.backtop,
              size: style.iconSize,
              color: style.contentColor,
            ),
            if (widget.showText) ...[
              SizedBox(width: style.contentGap),
              TText(
                '${context.resource.back}\n${context.resource.top}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: style.textStyle,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BackTopVisualStyle {
  const _BackTopVisualStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.contentColor,
    required this.roundSize,
    required this.halfCircleHeight,
    required this.halfCircleMinWidth,
    required this.iconSize,
    required this.borderWidth,
    required this.halfCircleHorizontalPadding,
    required this.contentGap,
    required this.textStyle,
  });

  final Color backgroundColor;
  final Color borderColor;
  final Color contentColor;
  final double roundSize;
  final double halfCircleHeight;
  final double halfCircleMinWidth;
  final double iconSize;
  final double borderWidth;
  final double halfCircleHorizontalPadding;
  final double contentGap;
  final TextStyle textStyle;
}

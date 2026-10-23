import 'dart:math' as math;

import 'package:flutter/foundation.dart' show precisionErrorTolerance;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show OverflowBoxFit;
import 'package:tdesign_flutter_icons/tdesign_flutter_icons.dart' show TIcons;

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_internal_material.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_sizes.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../text/t_text_styled.dart';
import 't_backtop_theme_data.dart';

class TBackTop extends StatefulWidget {
  const TBackTop({
    Key? key,
    this.controller,
    this.onPressed,
    this.onCompleted,
    this.showText = false,
    this.visibilityOffset = 200,
    this.tooltip,
    this.shape = TBackTopShape.circle,
    this.colorPreset = TBackTopColorPreset.light,
  }) : assert(visibilityOffset >= 0),
       super(key: key);

  /// 页面滚动控制器。
  ///
  /// 未传时组件始终可见，点击只触发 [onPressed]；传入后组件监听滚动偏移并
  /// 在点击时以 500 毫秒、Curves.easeIn 动画回到该滚动位置的最小边界。
  /// 控制器由调用方创建和释放，组件只管理自己的滚动监听。
  final ScrollController? controller;

  /// 回顶操作结束后的通知。
  ///
  /// 未绑定滚动位置时，点击后立即触发；已绑定时，等待回顶动画返回的
  /// Future 结束后触发。动画被中断也可能通知，不代表成功回顶；
  /// 成功回顶通知使用 [onCompleted]。
  ///
  /// 计划在 2.0 将本回调统一为点击时触发，成功回顶通知使用 [onCompleted]。
  ///
  /// `null` 不表示禁用；只要提供 [controller]，组件仍可点击并执行回顶。
  final VoidCallback? onPressed;

  /// 本组件成功回顶后触发的通知。
  ///
  /// 操作结束时，组件必须仍挂载；原滚动位置仍绑定于原控制器，且原控制器
  /// 仍是当前 [controller]，原位置已到达最小滚动边界。
  /// 允许完成前临时解绑再绑定原位置；完成时仍解绑、原位置被替换、
  /// 未到顶的中断或组件卸载均不触发。
  /// 已在顶部的有效回顶操作也触发一次；仅提供本回调不会启用按钮。
  ///
  /// 先记录回顶结果，再按原时机调用 [onPressed]；触发本回调前，
  /// 再次检查组件挂载和原绑定是否有效。[onPressed] 改变偏移不会
  /// 改写已记录的结果。
  ///
  /// 与 [onPressed] 的现有通知时机不同，不能等价替换。计划在 2.0
  /// 将 [onPressed] 统一为点击时触发，成功回顶通知继续使用本回调。
  final VoidCallback? onCompleted;

  /// 是否显示设计内置文案。
  ///
  /// 圆形显示“顶部”，半圆形显示“返回/顶部”，文案来自当前资源代理。
  final bool showText;

  /// 绑定 [controller] 时的显示阈值，默认 200；必须大于或等于 0。
  ///
  /// 滚动偏移大于或等于该值时显示；未绑定 [controller] 时不参与显隐。
  final double visibilityOffset;

  /// 读屏和 Tooltip 提示；未传时使用当前资源代理的“返回顶部”。
  final String? tooltip;

  /// 结构形态，默认 [TBackTopShape.circle]。
  final TBackTopShape shape;

  /// 局部配色预设，默认 [TBackTopColorPreset.light]；不切换全局明暗主题。
  final TBackTopColorPreset colorPreset;

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
      child: TInternalTooltip(
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
    ScrollPosition? position;

    bool isCurrentBinding() =>
        mounted &&
        identical(controller, widget.controller) &&
        position != null &&
        controller!.positions.contains(position);

    if (controller != null && controller.hasClients) {
      position = controller.position;
      _isAnimating = true;
      try {
        await controller.animateTo(
          position.minScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      } finally {
        _isAnimating = false;
      }
    }

    // The legacy callback may change scroll pixels. Record this operation's
    // result first, while keeping the historical notification order/timing.
    final completed =
        isCurrentBinding() &&
        (position!.pixels - position.minScrollExtent).abs() <=
            precisionErrorTolerance;
    if (mounted) {
      widget.onPressed?.call();
      if (completed && isCurrentBinding()) {
        widget.onCompleted?.call();
      }
    }
  }

  _BackTopVisualStyle _resolveStyle(BuildContext context) {
    final token = context.tTheme;
    final theme = _themeData;
    final isDark = widget.colorPreset == TBackTopColorPreset.dark;
    final defaultBackground = isDark
        ? widget.shape == TBackTopShape.circle
              ? token.grayColor13
              : token.grayColor14
        : token.bgColorContainer;
    final defaultContent = isDark ? token.whiteColor1 : token.textColorPrimary;
    return _BackTopVisualStyle(
      backgroundColor: theme.backgroundColor ?? defaultBackground,
      borderColor:
          theme.borderColor ??
          (isDark ? token.grayColor9 : token.componentBorder),
      contentColor: theme.contentColor ?? defaultContent,
      halfCircleMinWidth: theme.halfCircleMinWidth ?? 38,
      iconSize: theme.iconSize ?? 22,
      borderWidth: theme.borderWidth ?? 0.5,
      halfCircleHorizontalPadding: theme.resolveHalfCircleHorizontalPadding(
        token.size4,
      ),
      contentGap: theme.resolveContentGap(token.size1),
      textStyle:
          TextStyle(
                fontSize: token.fontMarkExtraSmall?.size ?? 10,
                height: 1.2,
                fontWeight:
                    token.fontMarkExtraSmall?.fontWeight ?? FontWeight.w600,
              )
              .merge(theme.textStyle)
              .copyWith(color: theme.contentColor ?? defaultContent),
    );
  }

  Widget _buildCircleWidget(BuildContext context) {
    final style = _resolveStyle(context);
    final theme = Theme.of(context).extension<TBackTopThemeData>();
    final textSize = widget.showText
        ? TTextStyled(
            context.resource.top,
            maxLines: 1,
            style: style.textStyle,
          ).naturalSize(context)
        : Size.zero;
    final contentWidth = math.max(style.iconSize, textSize.width);
    final contentHeight = style.iconSize + textSize.height;
    final defaultRoundSize = math.max(
      context.tTheme.size13,
      math.sqrt(contentWidth * contentWidth + contentHeight * contentHeight) +
          style.borderWidth * 2,
    );
    final roundSize =
        theme?.resolveRoundSize(defaultRoundSize) ?? defaultRoundSize;
    return Container(
      width: roundSize,
      height: roundSize,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.tTheme.radiusCircle),
          side: BorderSide(color: style.borderColor, width: style.borderWidth),
        ),
        color: style.backgroundColor,
      ),
      child: Center(
        child: OverflowBox(
          fit: OverflowBoxFit.deferToChild,
          minHeight: 0,
          maxHeight: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TInternalIcon(
                TIcons.backtop,
                size: style.iconSize,
                color: style.contentColor,
              ),
              if (widget.showText)
                TTextStyled(
                  context.resource.top,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: style.textStyle,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHalfCircleWidget(BuildContext context) {
    final style = _resolveStyle(context);
    final theme = Theme.of(context).extension<TBackTopThemeData>();
    final textSize = widget.showText
        ? TTextStyled(
            '${context.resource.back}\n${context.resource.top}',
            maxLines: 2,
            style: style.textStyle,
          ).naturalSize(context)
        : Size.zero;
    final defaultHeight = math.max(
      context.tTheme.size12,
      math.max(style.iconSize, textSize.height) + style.borderWidth * 2,
    );
    final height =
        theme?.resolveHalfCircleHeight(defaultHeight) ?? defaultHeight;
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: style.halfCircleMinWidth),
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(
          horizontal: style.halfCircleHorizontalPadding,
        ),
        decoration: ShapeDecoration(
          color: style.backgroundColor,
          // 半圆形使用 radiusRound；正圆形使用 radiusCircle。
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(context.tTheme.radiusRound),
              bottomLeft: Radius.circular(context.tTheme.radiusRound),
            ),
            side: BorderSide(
              color: style.borderColor,
              width: style.borderWidth,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TInternalIcon(
              TIcons.backtop,
              size: style.iconSize,
              color: style.contentColor,
            ),
            if (widget.showText) ...[
              SizedBox(width: style.contentGap),
              OverflowBox(
                fit: OverflowBoxFit.deferToChild,
                minHeight: 0,
                maxHeight: double.infinity,
                child: TTextStyled(
                  '${context.resource.back}\n${context.resource.top}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: style.textStyle,
                ),
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
  final double halfCircleMinWidth;
  final double iconSize;
  final double borderWidth;
  final double halfCircleHorizontalPadding;
  final double contentGap;
  final TextStyle textStyle;
}

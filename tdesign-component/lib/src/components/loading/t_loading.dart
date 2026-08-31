/*
 * Created by haozhicao@tencent.com on 6/29/22.
 * t_loading.dart
 *
 */

import 'package:flutter/material.dart';

import '../../theme/basic.dart';
import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../text/t_text.dart';
import 't_activity_indicator.dart';
import 't_circle_indicator.dart';
import 't_loading_theme_data.dart';
import 't_point_indicator.dart';

/// Loading图标
enum TLoadingIcon {
  /// 圆形
  circle,

  /// 点状
  point,

  /// 菊花状
  activity,
}

/// 展示局部或全屏加载状态的组件。
class TLoading extends StatelessWidget {
  const TLoading({
    Key? key,
    this.size = 20,
    this.icon = TLoadingIcon.circle,
    this.text,
    this.customIcon,
    this.refreshWidget,
  }) : assert(size > 0),
       super(key: key);

  /// 加载指示器的外部尺寸，单位为逻辑像素，默认为 20。
  final double size;

  /// 预设图标，支持圆形、点状、菊花状；为 null 时不显示预设图标。
  ///
  /// [customIcon] 不为 null 时仍优先显示自定义图标。
  final TLoadingIcon? icon;

  /// 文案
  final String? text;

  /// 自定义加载图标，优先于 [icon]，并按当前 Loading 动画时长持续旋转。
  final Widget? customIcon;

  /// 文案后的自定义操作内容
  final Widget? refreshWidget;

  /// 获取生效的 Theme（Theme Extension > 默认值）
  ///
  /// 按文档 §2.1 裁决：样式默认只从 `Theme.of(context)` 读取，
  /// 子树覆盖使用 `Theme.of(context).mergeExtension(...)`。
  TLoadingThemeData _effectiveTheme(BuildContext context) {
    return Theme.of(context).extension<TLoadingThemeData>() ??
        const TLoadingThemeData();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [_contentWidget(context)]);
  }

  Widget _contentWidget(BuildContext context) {
    final theme = _effectiveTheme(context);
    final materialTheme = Theme.of(context);
    final colorScheme = materialTheme.tExplicitColorScheme;
    final effectiveAxis = theme.axis ?? Axis.horizontal;
    final effectiveIconColor =
        theme.iconColor ??
        materialTheme.progressIndicatorTheme.color ??
        colorScheme?.primary ??
        context.tTheme.brandNormalColor;
    final effectiveCustomIcon = customIcon;
    final effectiveDuration = theme.duration ?? 800;
    final effectiveRefreshWidget = refreshWidget;
    final innerDuration = effectiveDuration > 0 ? effectiveDuration : 1;

    Widget? indicator;
    if (effectiveCustomIcon != null) {
      indicator = _TLoadingCustomIndicator(
        size: size,
        duration: innerDuration,
        child: effectiveCustomIcon,
      );
    } else if (icon != null) {
      switch (icon!) {
        case TLoadingIcon.activity:
          indicator = TCupertinoActivityIndicator(
            activeColor: effectiveIconColor,
            radius: size / 2,
            duration: innerDuration,
          );
          break;
        case TLoadingIcon.circle:
          indicator = TCircleIndicator(
            color: effectiveIconColor,
            size: size,
            lineWidth: size / 8,
            duration: innerDuration,
          );
          break;
        case TLoadingIcon.point:
          indicator = TPointBounceIndicator(
            color: effectiveIconColor,
            size: size,
            duration: innerDuration,
          );
          break;
      }
    }

    if (indicator == null) {
      return _textWidget(context, theme, effectiveRefreshWidget);
    }
    if (text == null) {
      return indicator;
    }

    return Flex(
      mainAxisSize: MainAxisSize.min,
      direction: effectiveAxis,
      children: [
        indicator,
        effectiveAxis == Axis.vertical
            ? const SizedBox(height: 6)
            : const SizedBox(width: 8),
        _textWidget(context, theme, effectiveRefreshWidget),
      ],
    );
  }

  Widget _textWidget(
    BuildContext context,
    TLoadingThemeData theme,
    Widget? refreshWidget,
  ) {
    Widget result = TText(
      text ?? '',
      textColor:
          theme.textColor ??
          Theme.of(context).tExplicitColorScheme?.onSurface ??
          context.tTheme.textColorPrimary,
      fontWeight: FontWeight.w400,
      font: context.tTheme.fontBodyMedium ?? Font(size: 14, lineHeight: 22),
      textAlign: TextAlign.center,
    );
    if (refreshWidget != null) {
      result = Row(
        mainAxisSize: MainAxisSize.min,
        children: [result, const SizedBox(width: 8), refreshWidget],
      );
    }
    return result;
  }
}

class _TLoadingCustomIndicator extends StatefulWidget {
  const _TLoadingCustomIndicator({
    required this.size,
    required this.duration,
    required this.child,
  });

  final double size;
  final int duration;
  final Widget child;

  @override
  State<_TLoadingCustomIndicator> createState() =>
      _TLoadingCustomIndicatorState();
}

class _TLoadingCustomIndicatorState extends State<_TLoadingCustomIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration),
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant _TLoadingCustomIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = Duration(milliseconds: widget.duration);
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.size,
      child: RotationTransition(turns: _controller, child: widget.child),
    );
  }
}

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

/// Loading 尺寸
enum TLoadingSize {
  /// 小尺寸
  small,

  /// 中尺寸
  medium,

  /// 大尺寸
  large,
}

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
    required this.size,
    this.icon = TLoadingIcon.circle,
    this.text,
    this.customIcon,
    this.refreshWidget,
  }) : super(key: key);

  /// 尺寸
  final TLoadingSize size;

  /// 图标，支持圆形、点状、菊花状
  final TLoadingIcon? icon;

  /// 文案
  final String? text;

  /// 自定义加载图标，优先于 [icon]
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
    final effectiveAxis = theme.axis ?? Axis.vertical;
    final effectiveIconColor =
        theme.iconColor ??
        materialTheme.progressIndicatorTheme.color ??
        colorScheme?.primary ??
        context.tTheme.brandNormalColor;
    final effectiveCustomIcon = customIcon;
    final effectiveDuration = theme.duration ?? 2000;
    final effectiveRefreshWidget = refreshWidget;
    final innerDuration = effectiveDuration > 0 ? effectiveDuration : 1;

    if (icon == null) {
      return _textWidget(context, theme, effectiveRefreshWidget);
    } else {
      Widget? indicator;
      if (effectiveCustomIcon != null) {
        indicator = effectiveCustomIcon;
      } else {
        switch (icon!) {
          case TLoadingIcon.activity:
            indicator = TCupertinoActivityIndicator(
              activeColor: effectiveIconColor,
              radius: size == TLoadingSize.small
                  ? 10
                  : (size == TLoadingSize.medium ? 11 : 13),
              duration: innerDuration,
            );
            break;
          case TLoadingIcon.circle:
            indicator = _getCircleIndicator(effectiveIconColor, innerDuration);
            break;
          case TLoadingIcon.point:
            indicator = TPointBounceIndicator(
              color: effectiveIconColor,
              size: size == TLoadingSize.small
                  ? 12
                  : (size == TLoadingSize.medium ? 16 : 20),
              duration: innerDuration,
            );
            break;
        }
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
              ? SizedBox(height: _getPaddingSize())
              : SizedBox(width: _getPaddingSize()),
          _textWidget(context, theme, effectiveRefreshWidget),
        ],
      );
    }
  }

  Widget _getCircleIndicator(Color? iconColor, int duration) {
    switch (size) {
      case TLoadingSize.large:
        return TCircleIndicator(
          color: iconColor,
          size: 24,
          lineWidth: 3 * 4 / 3, // 根据small等等比缩放
          duration: duration,
        );
      case TLoadingSize.medium:
        return TCircleIndicator(
          color: iconColor,
          size: 21,
          lineWidth: 3 * 7 / 6, // 根据small等等比缩放
          duration: duration,
        );
      case TLoadingSize.small:
        return TCircleIndicator(
          color: iconColor,
          size: 18, // 设计稿框为24，图形宽为19.5，推导lineWidth为3时，size为18
          lineWidth: 3,
          duration: duration,
        );
    }
  }

  double _getPaddingSize() {
    switch (size) {
      case TLoadingSize.large:
        return 10;
      case TLoadingSize.medium:
        return 8;
      case TLoadingSize.small:
        return 6;
    }
  }

  Widget _textWidget(
    BuildContext context,
    TLoadingThemeData theme,
    Widget? refreshWidget,
  ) {
    final font = switch (size) {
      TLoadingSize.large =>
        context.tTheme.fontBodyLarge ?? Font(size: 16, lineHeight: 24),
      TLoadingSize.medium =>
        context.tTheme.fontBodyMedium ?? Font(size: 14, lineHeight: 22),
      TLoadingSize.small =>
        context.tTheme.fontBodySmall ?? Font(size: 12, lineHeight: 20),
    };

    Widget result = TText(
      text ?? '',
      textColor:
          theme.textColor ??
          Theme.of(context).tExplicitColorScheme?.onSurface ??
          context.tTheme.textColorPrimary,
      fontWeight: FontWeight.w400,
      font: font,
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

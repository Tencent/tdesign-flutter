/*
 * Created by haozhicao@tencent.com on 6/29/22.
 * td_loading.dart
 * 
 */

import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 'td_activity_indicator.dart';
import 'td_point_indicator.dart';

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

class TLoading extends StatelessWidget {
  const TLoading({
    Key? key,
    required this.size,
    this.icon = TLoadingIcon.circle,
    this.iconColor,
    this.axis = Axis.vertical,
    this.text,
    this.refreshWidget,
    this.customIcon,
    this.textColor,
    this.duration = 2000,
  }) : super(key: key);

  /// 尺寸
  final TLoadingSize size;

  /// 图标，支持圆形、点状、菊花状
  final TLoadingIcon? icon;

  /// 图标颜色
  final Color? iconColor;

  /// 文案
  final String? text;

  /// 失败刷新组件
  final Widget? refreshWidget;

  /// 文案颜色
  final Color? textColor;

  /// 文案和图标相对方向
  final Axis axis;

  /// 自定义图标，优先级高于icon
  final Widget? customIcon;

  /// 一次刷新的时间，控制动画速度
  final int duration;

  int get _innerDuration => duration > 0 ? duration : 1;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [_contentWidget(context)],
    );
  }

  Widget _contentWidget(BuildContext context) {
    if (icon == null) {
      return textWidget(context);
    } else {
      Widget? indicator;
      if (customIcon != null) {
        indicator = customIcon!;
      } else {
        switch (icon!) {
          case TLoadingIcon.activity:
            indicator = TCupertinoActivityIndicator(
              activeColor: iconColor,
              radius: size == TLoadingSize.small
                  ? 10
                  : (size == TLoadingSize.medium ? 11 : 13),
              duration: _innerDuration,
            );
            break;
          case TLoadingIcon.circle:
            indicator = _getCircleIndicator();
            break;
          case TLoadingIcon.point:
            indicator = TPointBounceIndicator(
              color: iconColor,
              size: size == TLoadingSize.small
                  ? 12
                  : (size == TLoadingSize.medium ? 16 : 20),
              duration: _innerDuration,
            );
            break;
          default:
            indicator = _getCircleIndicator();
            break;
        }
      }

      if (text == null) {
        return indicator;
      }

      return Flex(
        // spacing: _getPaddingSize(),
        mainAxisSize: MainAxisSize.min,
        direction: axis,
        children: [
          indicator,
          axis == Axis.vertical
              ? SizedBox(height: _getPaddingSize())
              : SizedBox(width: _getPaddingSize()),
          textWidget(context),
        ],
      );
    }
  }

  Widget _getCircleIndicator() {
    switch (size) {
      case TLoadingSize.large:
        return TCircleIndicator(
          color: iconColor,
          size: 24,
          lineWidth: 3 * 4 / 3, // 根据small等等比缩放
          duration: _innerDuration,
        );
      case TLoadingSize.medium:
        return TCircleIndicator(
          color: iconColor,
          size: 21,
          lineWidth: 3 * 7 / 6, // 根据small等等比缩放
          duration: _innerDuration,
        );
      case TLoadingSize.small:
        return TCircleIndicator(
          color: iconColor,
          size: 18, // 设计稿框为24，图形宽为19.5，推导lineWidth为3时，size为18
          lineWidth: 3,
          duration: _innerDuration,
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

  Widget textWidget(BuildContext context) {
    final font = switch (size) {
      TLoadingSize.large =>
        TTheme.of(context).fontBodyLarge ?? Font(size: 16, lineHeight: 24),
      TLoadingSize.medium =>
        TTheme.of(context).fontBodyMedium ?? Font(size: 14, lineHeight: 22),
      TLoadingSize.small =>
        TTheme.of(context).fontBodySmall ?? Font(size: 12, lineHeight: 20),
    };

    Widget result = TText(
      text,
      textColor: textColor ?? TTheme.of(context).textColorPrimary,
      fontWeight: FontWeight.w400,
      font: font,
      textAlign: TextAlign.center,
    );
    if (refreshWidget != null) {
      result = Row(
        // spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          result,
          const SizedBox(width: 8),
          refreshWidget!,
        ],
      );
    }
    return result;
  }
}

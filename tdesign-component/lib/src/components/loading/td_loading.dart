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
enum TDLoadingSize {
  /// 小尺寸
  small,

  /// 中尺寸
  medium,

  /// 大尺寸
  large,
}

/// Loading图标
enum TDLoadingIcon {
  /// 圆形
  circle,

  /// 点状
  point,

  /// 菊花状
  activity,
}

class TDLoading extends StatelessWidget {
  const TDLoading({
    Key? key,
    required this.size,
    this.icon = TDLoadingIcon.circle,
    this.iconColor,
    this.axis = Axis.vertical,
    this.text,
    this.refreshWidget,
    this.customIcon,
    this.textColor,
    this.duration = 2000,
  }) : super(key: key);

  /// 尺寸
  final TDLoadingSize size;

  /// 图标，支持圆形、点状、菊花状
  final TDLoadingIcon? icon;

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
          case TDLoadingIcon.activity:
            indicator = TDCupertinoActivityIndicator(
              activeColor: iconColor,
              radius: size == TDLoadingSize.small
                  ? 10
                  : (size == TDLoadingSize.medium ? 11 : 13),
              duration: _innerDuration,
            );
            break;
          case TDLoadingIcon.circle:
            indicator = _getCircleIndicator();
            break;
          case TDLoadingIcon.point:
            indicator = TDPointBounceIndicator(
              color: iconColor,
              size: size == TDLoadingSize.small
                  ? 12
                  : (size == TDLoadingSize.medium ? 16 : 20),
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
      case TDLoadingSize.large:
        return TDCircleIndicator(
          color: iconColor,
          size: 24,
          lineWidth: 3 * 4 / 3, // 根据small等等比缩放
          duration: _innerDuration,
        );
      case TDLoadingSize.medium:
        return TDCircleIndicator(
          color: iconColor,
          size: 21,
          lineWidth: 3 * 7 / 6, // 根据small等等比缩放
          duration: _innerDuration,
        );
      case TDLoadingSize.small:
        return TDCircleIndicator(
          color: iconColor,
          size: 18, // 设计稿框为24，图形宽为19.5，推导lineWidth为3时，size为18
          lineWidth: 3,
          duration: _innerDuration,
        );
    }
  }

  double _getPaddingSize() {
    switch (size) {
      case TDLoadingSize.large:
        return 10;
      case TDLoadingSize.medium:
        return 8;
      case TDLoadingSize.small:
        return 6;
    }
  }

  Widget textWidget(BuildContext context) {
    final font = switch (size) {
      TDLoadingSize.large =>
        TDTheme.of(context).fontBodyLarge ?? Font(size: 16, lineHeight: 24),
      TDLoadingSize.medium =>
        TDTheme.of(context).fontBodyMedium ?? Font(size: 14, lineHeight: 22),
      TDLoadingSize.small =>
        TDTheme.of(context).fontBodySmall ?? Font(size: 12, lineHeight: 20),
    };

    Widget result = TDText(
      text,
      textColor: textColor ?? TDTheme.of(context).textColorPrimary,
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

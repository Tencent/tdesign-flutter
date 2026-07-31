import 'package:flutter/material.dart';

import 't_collapse_types.dart';

/// 折叠面板组件级 ThemeExtension
class TCollapseThemeData extends ThemeExtension<TCollapseThemeData> {
  /// 面板风格（block/card）
  final TCollapseVariant? variant;

  /// 默认面板背景色
  final Color? backgroundColor;

  /// 动画时长
  final Duration? animationDuration;

  /// 阴影
  final double? elevation;

  /// 标题文字样式。
  final TextStyle? headerTextStyle;

  /// 内容文字样式。
  final TextStyle? contentTextStyle;

  /// 禁用状态标题文字样式。
  final TextStyle? disabledHeaderTextStyle;

  /// 展开图标颜色。
  final Color? iconColor;

  /// 禁用状态展开图标颜色。
  final Color? disabledIconColor;

  /// 分隔线颜色。
  final Color? dividerColor;

  /// 内容内边距。
  final EdgeInsetsGeometry? contentPadding;

  /// 卡片外边距。
  final EdgeInsetsGeometry? cardMargin;

  /// 卡片圆角。
  final BorderRadius? cardBorderRadius;

  const TCollapseThemeData({
    this.variant,
    this.backgroundColor,
    this.animationDuration,
    this.elevation,
    this.headerTextStyle,
    this.contentTextStyle,
    this.disabledHeaderTextStyle,
    this.iconColor,
    this.disabledIconColor,
    this.dividerColor,
    this.contentPadding,
    this.cardMargin,
    this.cardBorderRadius,
  });

  @override
  TCollapseThemeData copyWith({
    TCollapseVariant? variant,
    Color? backgroundColor,
    Duration? animationDuration,
    double? elevation,
    TextStyle? headerTextStyle,
    TextStyle? contentTextStyle,
    TextStyle? disabledHeaderTextStyle,
    Color? iconColor,
    Color? disabledIconColor,
    Color? dividerColor,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? cardMargin,
    BorderRadius? cardBorderRadius,
  }) {
    return TCollapseThemeData(
      variant: variant ?? this.variant,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      animationDuration: animationDuration ?? this.animationDuration,
      elevation: elevation ?? this.elevation,
      headerTextStyle: headerTextStyle ?? this.headerTextStyle,
      contentTextStyle: contentTextStyle ?? this.contentTextStyle,
      disabledHeaderTextStyle:
          disabledHeaderTextStyle ?? this.disabledHeaderTextStyle,
      iconColor: iconColor ?? this.iconColor,
      disabledIconColor: disabledIconColor ?? this.disabledIconColor,
      dividerColor: dividerColor ?? this.dividerColor,
      contentPadding: contentPadding ?? this.contentPadding,
      cardMargin: cardMargin ?? this.cardMargin,
      cardBorderRadius: cardBorderRadius ?? this.cardBorderRadius,
    );
  }

  @override
  TCollapseThemeData lerp(ThemeExtension<TCollapseThemeData>? other, double t) {
    if (other is! TCollapseThemeData) {
      return this;
    }
    return TCollapseThemeData(
      variant: t < 0.5 ? variant : other.variant,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      animationDuration: t < 0.5 ? animationDuration : other.animationDuration,
      elevation: t < 0.5 ? elevation : other.elevation,
      headerTextStyle:
          TextStyle.lerp(headerTextStyle, other.headerTextStyle, t),
      contentTextStyle:
          TextStyle.lerp(contentTextStyle, other.contentTextStyle, t),
      disabledHeaderTextStyle: TextStyle.lerp(
          disabledHeaderTextStyle, other.disabledHeaderTextStyle, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      disabledIconColor:
          Color.lerp(disabledIconColor, other.disabledIconColor, t),
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t),
      contentPadding:
          EdgeInsetsGeometry.lerp(contentPadding, other.contentPadding, t),
      cardMargin: EdgeInsetsGeometry.lerp(cardMargin, other.cardMargin, t),
      cardBorderRadius:
          BorderRadius.lerp(cardBorderRadius, other.cardBorderRadius, t),
    );
  }
}

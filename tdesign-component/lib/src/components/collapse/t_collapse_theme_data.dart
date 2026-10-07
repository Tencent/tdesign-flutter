import 'package:flutter/material.dart';

/// 折叠面板组件级 ThemeExtension
class TCollapseThemeData extends ThemeExtension<TCollapseThemeData> {
  /// 默认面板背景色
  final Color? backgroundColor;

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
    this.backgroundColor,
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

  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TCollapseThemeData copyWith({
    Color? backgroundColor,
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
      backgroundColor: backgroundColor ?? this.backgroundColor,
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

  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TCollapseThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TCollapseThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TCollapseThemeData) {
      return this;
    }
    return TCollapseThemeData(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      elevation: t < 0.5 ? elevation : other.elevation,
      headerTextStyle: TextStyle.lerp(
        headerTextStyle,
        other.headerTextStyle,
        t,
      ),
      contentTextStyle: TextStyle.lerp(
        contentTextStyle,
        other.contentTextStyle,
        t,
      ),
      disabledHeaderTextStyle: TextStyle.lerp(
        disabledHeaderTextStyle,
        other.disabledHeaderTextStyle,
        t,
      ),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      disabledIconColor: Color.lerp(
        disabledIconColor,
        other.disabledIconColor,
        t,
      ),
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t),
      contentPadding: EdgeInsetsGeometry.lerp(
        contentPadding,
        other.contentPadding,
        t,
      ),
      cardMargin: EdgeInsetsGeometry.lerp(cardMargin, other.cardMargin, t),
      cardBorderRadius: BorderRadius.lerp(
        cardBorderRadius,
        other.cardBorderRadius,
        t,
      ),
    );
  }
}

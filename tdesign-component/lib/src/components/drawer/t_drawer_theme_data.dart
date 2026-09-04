import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// 抽屉组件 ThemeExtension。
///
/// 只保存子树级具体视觉默认值。方向、蒙层、边框开关、末行边框和按压反馈
/// 由组件实例唯一拥有；构造器具体视觉参数优先级高于 ThemeData。
class TDrawerThemeData extends ThemeExtension<TDrawerThemeData> {
  /// 默认宽度，默认 280。
  final double? width;

  /// 默认背景颜色。
  final Color? backgroundColor;

  /// 抽屉标题样式。
  final TextStyle? titleStyle;

  /// 标题内边距，默认 `EdgeInsets.fromLTRB(16, 24, 16, 8)`。
  final EdgeInsetsGeometry? titlePadding;

  /// 菜单正文样式。
  final TextStyle? itemTextStyle;

  /// 菜单项背景色。
  final Color? itemBackgroundColor;

  /// 菜单项按压背景色。
  final Color? itemPressedColor;

  /// 菜单项内边距，默认 `EdgeInsets.fromLTRB(16, 16, 0, 16)`。
  final EdgeInsetsGeometry? itemPadding;

  /// 菜单项图标颜色。
  final Color? itemIconColor;

  /// 菜单项图标尺寸，默认 24。
  final double? itemIconSize;

  /// 菜单项图标与正文间距，默认 8。
  final double? itemIconGap;

  /// 菜单项分隔线颜色。
  final Color? dividerColor;

  /// 菜单项分隔线起始缩进，默认 16。
  final double? dividerIndent;

  /// 菜单项分隔线厚度，默认 0.5。
  final double? dividerThickness;

  /// 底部区内边距，默认仅保留 20 的底边距。
  final EdgeInsetsGeometry? footerPadding;

  const TDrawerThemeData({
    this.width,
    this.backgroundColor,
    this.titleStyle,
    this.titlePadding,
    this.itemTextStyle,
    this.itemBackgroundColor,
    this.itemPressedColor,
    this.itemPadding,
    this.itemIconColor,
    this.itemIconSize,
    this.itemIconGap,
    this.dividerColor,
    this.dividerIndent,
    this.dividerThickness,
    this.footerPadding,
  });

  @override
  TDrawerThemeData copyWith({
    double? width,
    Color? backgroundColor,
    TextStyle? titleStyle,
    EdgeInsetsGeometry? titlePadding,
    TextStyle? itemTextStyle,
    Color? itemBackgroundColor,
    Color? itemPressedColor,
    EdgeInsetsGeometry? itemPadding,
    Color? itemIconColor,
    double? itemIconSize,
    double? itemIconGap,
    Color? dividerColor,
    double? dividerIndent,
    double? dividerThickness,
    EdgeInsetsGeometry? footerPadding,
  }) {
    return TDrawerThemeData(
      width: width ?? this.width,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleStyle: titleStyle ?? this.titleStyle,
      titlePadding: titlePadding ?? this.titlePadding,
      itemTextStyle: itemTextStyle ?? this.itemTextStyle,
      itemBackgroundColor: itemBackgroundColor ?? this.itemBackgroundColor,
      itemPressedColor: itemPressedColor ?? this.itemPressedColor,
      itemPadding: itemPadding ?? this.itemPadding,
      itemIconColor: itemIconColor ?? this.itemIconColor,
      itemIconSize: itemIconSize ?? this.itemIconSize,
      itemIconGap: itemIconGap ?? this.itemIconGap,
      dividerColor: dividerColor ?? this.dividerColor,
      dividerIndent: dividerIndent ?? this.dividerIndent,
      dividerThickness: dividerThickness ?? this.dividerThickness,
      footerPadding: footerPadding ?? this.footerPadding,
    );
  }

  @override
  TDrawerThemeData lerp(ThemeExtension<TDrawerThemeData>? other, double t) {
    if (other is! TDrawerThemeData) {
      return this;
    }
    return TDrawerThemeData(
      width: lerpDouble(width, other.width, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
      titlePadding: EdgeInsetsGeometry.lerp(
        titlePadding,
        other.titlePadding,
        t,
      ),
      itemTextStyle: TextStyle.lerp(itemTextStyle, other.itemTextStyle, t),
      itemBackgroundColor: Color.lerp(
        itemBackgroundColor,
        other.itemBackgroundColor,
        t,
      ),
      itemPressedColor: Color.lerp(itemPressedColor, other.itemPressedColor, t),
      itemPadding: EdgeInsetsGeometry.lerp(itemPadding, other.itemPadding, t),
      itemIconColor: Color.lerp(itemIconColor, other.itemIconColor, t),
      itemIconSize: lerpDouble(itemIconSize, other.itemIconSize, t),
      itemIconGap: lerpDouble(itemIconGap, other.itemIconGap, t),
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t),
      dividerIndent: lerpDouble(dividerIndent, other.dividerIndent, t),
      dividerThickness: lerpDouble(dividerThickness, other.dividerThickness, t),
      footerPadding: EdgeInsetsGeometry.lerp(
        footerPadding,
        other.footerPadding,
        t,
      ),
    );
  }
}

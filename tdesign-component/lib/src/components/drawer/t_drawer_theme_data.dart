import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// 抽屉组件 ThemeExtension
///
/// 管理 TDrawer 的子树级默认样式（宽度、背景色、边框、点击反馈等）。
/// 构造器参数优先级高于 ThemeData。
class TDrawerThemeData extends ThemeExtension<TDrawerThemeData> {
  /// 默认宽度
  final double? width;

  /// 默认顶部偏移
  final double? drawerTop;

  /// 默认背景颜色
  final Color? backgroundColor;

  /// 是否默认显示边框
  final bool? bordered;

  /// 是否默认显示最后一行分割线
  final bool? isShowLastBordered;

  /// 是否默认开启点击反馈
  final bool? hover;

  /// 抽屉标题样式。
  final TextStyle? titleStyle;

  /// 菜单正文样式。
  final TextStyle? itemTextStyle;

  /// 菜单项背景色。
  final Color? itemBackgroundColor;

  /// 菜单项按压背景色。
  final Color? itemPressedColor;

  /// 菜单项内边距。
  final EdgeInsetsGeometry? itemPadding;

  /// 菜单项分隔线颜色。
  final Color? dividerColor;

  const TDrawerThemeData({
    this.width,
    this.drawerTop,
    this.backgroundColor,
    this.bordered,
    this.isShowLastBordered,
    this.hover,
    this.titleStyle,
    this.itemTextStyle,
    this.itemBackgroundColor,
    this.itemPressedColor,
    this.itemPadding,
    this.dividerColor,
  });

  @override
  TDrawerThemeData copyWith({
    double? width,
    double? drawerTop,
    Color? backgroundColor,
    bool? bordered,
    bool? isShowLastBordered,
    bool? hover,
    TextStyle? titleStyle,
    TextStyle? itemTextStyle,
    Color? itemBackgroundColor,
    Color? itemPressedColor,
    EdgeInsetsGeometry? itemPadding,
    Color? dividerColor,
  }) {
    return TDrawerThemeData(
      width: width ?? this.width,
      drawerTop: drawerTop ?? this.drawerTop,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      bordered: bordered ?? this.bordered,
      isShowLastBordered: isShowLastBordered ?? this.isShowLastBordered,
      hover: hover ?? this.hover,
      titleStyle: titleStyle ?? this.titleStyle,
      itemTextStyle: itemTextStyle ?? this.itemTextStyle,
      itemBackgroundColor: itemBackgroundColor ?? this.itemBackgroundColor,
      itemPressedColor: itemPressedColor ?? this.itemPressedColor,
      itemPadding: itemPadding ?? this.itemPadding,
      dividerColor: dividerColor ?? this.dividerColor,
    );
  }

  @override
  TDrawerThemeData lerp(ThemeExtension<TDrawerThemeData>? other, double t) {
    if (other is! TDrawerThemeData) {
      return this;
    }
    return TDrawerThemeData(
      width: lerpDouble(width, other.width, t),
      drawerTop: lerpDouble(drawerTop, other.drawerTop, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      bordered: t < 0.5 ? bordered : other.bordered,
      isShowLastBordered:
          t < 0.5 ? isShowLastBordered : other.isShowLastBordered,
      hover: t < 0.5 ? hover : other.hover,
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
      itemTextStyle: TextStyle.lerp(itemTextStyle, other.itemTextStyle, t),
      itemBackgroundColor:
          Color.lerp(itemBackgroundColor, other.itemBackgroundColor, t),
      itemPressedColor: Color.lerp(itemPressedColor, other.itemPressedColor, t),
      itemPadding: EdgeInsetsGeometry.lerp(itemPadding, other.itemPadding, t),
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t),
    );
  }
}

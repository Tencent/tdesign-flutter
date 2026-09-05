import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../../theme/basic.dart';

/// NavBar 边框配置（迁入 ThemeData）
class TNavBarBorder {
  /// 边框宽度
  final double width;

  /// 边框圆角
  final double radius;

  /// 边框颜色
  final Color? color;

  /// 内部填充
  final EdgeInsetsGeometry? padding;

  const TNavBarBorder({
    this.width = 1.0,
    this.radius = 22.0,
    this.color,
    this.padding,
  });
}

/// NavBar 组件 ThemeExtension
///
/// 管理 TNavBar 的子树级默认样式（标题颜色/字体、背景、内边距、阴影、边框等）。
/// 构造器参数优先级高于 ThemeData。高度属于 PreferredSizeWidget 契约，只能通过 TNavBar.height 设置。
class TNavBarThemeData extends ThemeExtension<TNavBarThemeData> {
  /// 标题颜色
  final Color? titleColor;

  /// 返回图标颜色
  final Color? backIconColor;

  /// 标题字体尺寸
  final Font? titleFont;

  /// 标题字体粗细
  final FontWeight? titleFontWeight;

  /// 标题字体样式
  final FontFamily? titleFontFamily;

  /// 背景颜色
  final Color? backgroundColor;

  /// 内部填充
  final EdgeInsetsGeometry? padding;

  /// 中间文案左右两边间距
  final double? titleMargin;

  /// 透明度
  final double? opacity;

  /// 操作项边框配置
  final TNavBarBorder? border;

  /// 底部阴影
  final List<BoxShadow>? boxShadow;

  const TNavBarThemeData({
    this.titleColor,
    this.backIconColor,
    this.titleFont,
    this.titleFontWeight,
    this.titleFontFamily,
    this.backgroundColor,
    this.padding,
    this.titleMargin,
    this.opacity,
    this.border,
    this.boxShadow,
  });

  @override
  TNavBarThemeData copyWith({
    Color? titleColor,
    Color? backIconColor,
    Font? titleFont,
    FontWeight? titleFontWeight,
    FontFamily? titleFontFamily,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    double? titleMargin,
    double? opacity,
    TNavBarBorder? border,
    List<BoxShadow>? boxShadow,
  }) {
    return TNavBarThemeData(
      titleColor: titleColor ?? this.titleColor,
      backIconColor: backIconColor ?? this.backIconColor,
      titleFont: titleFont ?? this.titleFont,
      titleFontWeight: titleFontWeight ?? this.titleFontWeight,
      titleFontFamily: titleFontFamily ?? this.titleFontFamily,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      padding: padding ?? this.padding,
      titleMargin: titleMargin ?? this.titleMargin,
      opacity: opacity ?? this.opacity,
      border: border ?? this.border,
      boxShadow: boxShadow ?? this.boxShadow,
    );
  }

  @override
  TNavBarThemeData lerp(ThemeExtension<TNavBarThemeData>? other, double t) {
    if (other is! TNavBarThemeData) {
      return this;
    }
    return TNavBarThemeData(
      titleColor: Color.lerp(titleColor, other.titleColor, t),
      backIconColor: Color.lerp(backIconColor, other.backIconColor, t),
      titleFont: t < 0.5 ? titleFont : other.titleFont,
      titleFontWeight: t < 0.5 ? titleFontWeight : other.titleFontWeight,
      titleFontFamily: t < 0.5 ? titleFontFamily : other.titleFontFamily,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      padding: t < 0.5 ? padding : other.padding,
      titleMargin: lerpDouble(titleMargin, other.titleMargin, t),
      opacity: lerpDouble(opacity, other.opacity, t),
      border: t < 0.5 ? border : other.border,
      boxShadow: t < 0.5 ? boxShadow : other.boxShadow,
    );
  }
}

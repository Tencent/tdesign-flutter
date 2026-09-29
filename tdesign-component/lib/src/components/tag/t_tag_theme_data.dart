import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../../theme/basic.dart' show Font;
import 't_tag_types.dart';

/// 标签组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认样式。
/// 构造器参数优先于 Theme。
class TTagThemeData extends ThemeExtension<TTagThemeData> {
  /// 文字颜色
  final Color? textColor;

  /// 背景颜色
  final Color? backgroundColor;

  /// 字体尺寸和行高；未设置时随标签尺寸使用对应的全局字体 Token。
  final Font? font;

  /// 字体粗细
  final FontWeight? fontWeight;

  /// 自定义间距
  final EdgeInsets? padding;

  /// 标签形状
  final TTagShape? shape;

  /// 方形标签圆角，单位为逻辑像素；未设置时所有尺寸均读取全局
  /// `radiusSmall`（当前默认 3dp）。
  final double? squareBorderRadius;

  /// 文字溢出处理
  final TextOverflow? overflow;

  /// 文字最大行数。
  ///
  /// 未设置时组件默认按紧凑标签语义使用单行。
  final int? maxLines;

  /// 标签固定宽度
  final double? fixedWidth;

  const TTagThemeData({
    this.textColor,
    this.backgroundColor,
    this.font,
    this.fontWeight,
    this.padding,
    this.shape,
    this.squareBorderRadius,
    this.overflow,
    this.maxLines,
    this.fixedWidth,
  });

  @override
  TTagThemeData copyWith({
    Color? textColor,
    Color? backgroundColor,
    Font? font,
    FontWeight? fontWeight,
    EdgeInsets? padding,
    TTagShape? shape,
    double? squareBorderRadius,
    TextOverflow? overflow,
    int? maxLines,
    double? fixedWidth,
  }) {
    return TTagThemeData(
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      font: font ?? this.font,
      fontWeight: fontWeight ?? this.fontWeight,
      padding: padding ?? this.padding,
      shape: shape ?? this.shape,
      squareBorderRadius: squareBorderRadius ?? this.squareBorderRadius,
      overflow: overflow ?? this.overflow,
      maxLines: maxLines ?? this.maxLines,
      fixedWidth: fixedWidth ?? this.fixedWidth,
    );
  }

  @override
  TTagThemeData lerp(ThemeExtension<TTagThemeData>? other, double t) {
    if (other is! TTagThemeData) {
      return this;
    }
    return TTagThemeData(
      textColor: Color.lerp(textColor, other.textColor, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      font: t < 0.5 ? font : other.font,
      fontWeight: t < 0.5 ? fontWeight : other.fontWeight,
      padding:
          EdgeInsetsGeometry.lerp(padding, other.padding, t) as EdgeInsets?,
      shape: t < 0.5 ? shape : other.shape,
      // null 表示继承当前子树的 radiusSmall，不能当作 0dp 参与插值。
      squareBorderRadius:
          squareBorderRadius == null || other.squareBorderRadius == null
          ? (t < 0.5 ? squareBorderRadius : other.squareBorderRadius)
          : lerpDouble(squareBorderRadius, other.squareBorderRadius, t),
      overflow: t < 0.5 ? overflow : other.overflow,
      maxLines: t < 0.5 ? maxLines : other.maxLines,
      fixedWidth: lerpDouble(fixedWidth, other.fixedWidth, t),
    );
  }
}

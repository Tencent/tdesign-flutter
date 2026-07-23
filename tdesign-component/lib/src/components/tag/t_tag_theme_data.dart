import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../../theme/basic.dart' show Font;
import 't_tag_types.dart';

/// 标签组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认样式。
/// 构造器参数优先于 Theme。
class TTagThemeData extends ThemeExtension<TTagThemeData> {
  /// 未传实例 colorScheme 时的默认语义色
  final TTagColorScheme? colorScheme;

  /// 文字颜色
  final Color? textColor;

  /// 背景颜色
  final Color? backgroundColor;

  /// 字体尺寸
  final Font? font;

  /// 字体粗细
  final FontWeight? fontWeight;

  /// 自定义间距
  final EdgeInsets? padding;

  /// 是否为描边类型
  final bool? isOutline;

  /// 标签形状
  final TTagShape? shape;

  /// 是否为浅色
  final bool? isLight;

  /// 文字溢出处理
  final TextOverflow? overflow;

  /// 文字最大行数。
  ///
  /// 未设置时组件默认按紧凑标签语义使用单行。
  final int? maxLines;

  /// 标签固定宽度
  final double? fixedWidth;

  const TTagThemeData({
    this.colorScheme,
    this.textColor,
    this.backgroundColor,
    this.font,
    this.fontWeight,
    this.padding,
    this.isOutline,
    this.shape,
    this.isLight,
    this.overflow,
    this.maxLines,
    this.fixedWidth,
  });

  @override
  TTagThemeData copyWith({
    TTagColorScheme? colorScheme,
    Color? textColor,
    Color? backgroundColor,
    Font? font,
    FontWeight? fontWeight,
    EdgeInsets? padding,
    bool? isOutline,
    TTagShape? shape,
    bool? isLight,
    TextOverflow? overflow,
    int? maxLines,
    double? fixedWidth,
  }) {
    return TTagThemeData(
      colorScheme: colorScheme ?? this.colorScheme,
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      font: font ?? this.font,
      fontWeight: fontWeight ?? this.fontWeight,
      padding: padding ?? this.padding,
      isOutline: isOutline ?? this.isOutline,
      shape: shape ?? this.shape,
      isLight: isLight ?? this.isLight,
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
      colorScheme: t < 0.5 ? colorScheme : other.colorScheme,
      textColor: Color.lerp(textColor, other.textColor, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      font: t < 0.5 ? font : other.font,
      fontWeight: t < 0.5 ? fontWeight : other.fontWeight,
      padding:
          EdgeInsetsGeometry.lerp(padding, other.padding, t) as EdgeInsets?,
      isOutline: t < 0.5 ? isOutline : other.isOutline,
      shape: t < 0.5 ? shape : other.shape,
      isLight: t < 0.5 ? isLight : other.isLight,
      overflow: t < 0.5 ? overflow : other.overflow,
      maxLines: t < 0.5 ? maxLines : other.maxLines,
      fixedWidth: lerpDouble(fixedWidth, other.fixedWidth, t),
    );
  }
}

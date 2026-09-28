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

  /// danger 预设的基础色，对应小程序的 `--td-tag-danger-color`。
  ///
  /// 未设置时沿显式 Material `ColorScheme.error`、全局 `errorColor` 回退。
  /// 仅影响 danger 预设；浅色填充仍使用 danger 浅色默认值。
  final Color? dangerColor;

  /// 字体尺寸
  final Font? font;

  /// 字体粗细
  final FontWeight? fontWeight;

  /// 自定义间距
  final EdgeInsets? padding;

  /// 方形标签圆角，对应小程序的 `--td-tag-square-border-radius`。
  ///
  /// 未设置时为 4 逻辑像素（375px 基准下的 8rpx）；不影响圆角和标记形状。
  final double? squareBorderRadius;

  /// 标签形状
  final TTagShape? shape;

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
    this.dangerColor,
    this.font,
    this.fontWeight,
    this.padding,
    this.squareBorderRadius,
    this.shape,
    this.overflow,
    this.maxLines,
    this.fixedWidth,
  }) : assert(squareBorderRadius == null || squareBorderRadius >= 0);

  @override
  TTagThemeData copyWith({
    Color? textColor,
    Color? backgroundColor,
    Color? dangerColor,
    Font? font,
    FontWeight? fontWeight,
    EdgeInsets? padding,
    double? squareBorderRadius,
    TTagShape? shape,
    TextOverflow? overflow,
    int? maxLines,
    double? fixedWidth,
  }) {
    return TTagThemeData(
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      dangerColor: dangerColor ?? this.dangerColor,
      font: font ?? this.font,
      fontWeight: fontWeight ?? this.fontWeight,
      padding: padding ?? this.padding,
      squareBorderRadius: squareBorderRadius ?? this.squareBorderRadius,
      shape: shape ?? this.shape,
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
      // null 表示动态继承全局/Material 色，ThemeExtension.lerp 没有 BuildContext；
      // 与显式颜色切换时使用离散值，避免把 null 插值成透明色。
      dangerColor: dangerColor == null || other.dangerColor == null
          ? (t < 0.5 ? dangerColor : other.dangerColor)
          : Color.lerp(dangerColor, other.dangerColor, t),
      font: t < 0.5 ? font : other.font,
      fontWeight: t < 0.5 ? fontWeight : other.fontWeight,
      padding:
          EdgeInsetsGeometry.lerp(padding, other.padding, t) as EdgeInsets?,
      squareBorderRadius:
          squareBorderRadius == null && other.squareBorderRadius == null
          ? null
          : lerpDouble(
              squareBorderRadius ?? 4,
              other.squareBorderRadius ?? 4,
              t,
            ),
      shape: t < 0.5 ? shape : other.shape,
      overflow: t < 0.5 ? overflow : other.overflow,
      maxLines: t < 0.5 ? maxLines : other.maxLines,
      fixedWidth: lerpDouble(fixedWidth, other.fixedWidth, t),
    );
  }
}

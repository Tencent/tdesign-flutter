import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../../theme/basic.dart' show Font;
import 't_tag_types.dart';

/// 标签组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认样式。
/// 具体视觉值由组件 Theme 控制，未指定时回退全局 Token。
class TTagThemeData extends ThemeExtension<TTagThemeData> {
  /// 所有启用 Tag 的统一文字颜色；优先于各配色预设的文字色。
  ///
  /// 禁用态仍使用禁用 Token。只修改 success 预设时使用 [successColor]。
  final Color? textColor;

  /// 所有启用 Tag 的统一背景色；优先于各配色预设的填充色。
  ///
  /// 禁用态仍使用禁用 Token。只修改 success 浅色填充时使用 [successLightColor]。
  final Color? backgroundColor;

  /// danger 预设的基础色，对应小程序的 `--td-tag-danger-color`。
  ///
  /// 未设置时沿显式 Material `ColorScheme.error`、全局 `errorColor` 回退。
  /// 仅影响 danger 预设；浅色填充仍使用 danger 浅色默认值。
  final Color? dangerColor;

  /// success 预设的基础色，对应 `--td-tag-success-color`。
  ///
  /// 未设置时回退全局 `successColor`；不改变禁用态。
  final Color? successColor;

  /// success 预设的浅色填充，对应 `--td-tag-success-light-color`。
  ///
  /// 未设置时回退全局 `successColor1`；不改变基础色或禁用态。
  final Color? successLightColor;

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
    this.successColor,
    this.successLightColor,
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
    Color? successColor,
    Color? successLightColor,
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
      successColor: successColor ?? this.successColor,
      successLightColor: successLightColor ?? this.successLightColor,
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
      successColor: successColor == null || other.successColor == null
          ? (t < 0.5 ? successColor : other.successColor)
          : Color.lerp(successColor, other.successColor, t),
      successLightColor:
          successLightColor == null || other.successLightColor == null
          ? (t < 0.5 ? successLightColor : other.successLightColor)
          : Color.lerp(successLightColor, other.successLightColor, t),
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

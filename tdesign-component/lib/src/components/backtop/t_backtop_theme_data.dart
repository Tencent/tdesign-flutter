import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// 返回顶部结构形态。
enum TBackTopShape {
  /// 48 × 48 的圆形返回顶部。
  circle,

  /// 贴靠屏幕右侧的半圆形返回顶部。
  halfCircle,
}

/// 返回顶部预设配色。
///
/// 只选择一组协调的背景、边框和内容颜色，不改变组件结构或交互。
enum TBackTopColorScheme {
  /// 浅色容器配色。
  light,

  /// 深色容器配色。
  dark,
}

/// 返回顶部组件 ThemeExtension。
///
/// 只承载子树级具体视觉默认值；结构形态、配色选择和滚动显隐行为由
/// `TBackTop` 实例唯一拥有。
class TBackTopThemeData extends ThemeExtension<TBackTopThemeData> {
  /// 背景色；未设置时根据实例配色读取 TDesign 语义 Token。
  final Color? backgroundColor;

  /// 边框色；未设置时根据实例配色读取 TDesign 语义 Token。
  final Color? borderColor;

  /// 图标和文字颜色；未设置时根据实例配色读取 TDesign 语义 Token。
  final Color? contentColor;

  /// 圆形宽高，默认 48。
  final double? roundSize;

  /// 半圆形高度，默认 40。
  final double? halfCircleHeight;

  /// 半圆形无文字时的最小宽度，默认 38。
  final double? halfCircleMinWidth;

  /// 图标尺寸，默认 20。
  final double? iconSize;

  /// 边框宽度，默认 0.5。
  final double? borderWidth;

  /// 半圆形水平内边距，默认 8。
  final double? halfCircleHorizontalPadding;

  /// 半圆形图标与文字间距，默认 2。
  final double? contentGap;

  /// 文案字体样式；未设置字段回退 Mark Extra Small 字体。
  ///
  /// 文字颜色与图标颜色统一由 [contentColor] 控制，传入样式中的 `color`
  /// 不参与解析，避免同一内容色存在两个 Theme 状态源。
  final TextStyle? textStyle;

  const TBackTopThemeData({
    this.backgroundColor,
    this.borderColor,
    this.contentColor,
    this.roundSize,
    this.halfCircleHeight,
    this.halfCircleMinWidth,
    this.iconSize,
    this.borderWidth,
    this.halfCircleHorizontalPadding,
    this.contentGap,
    this.textStyle,
  });

  @override
  TBackTopThemeData copyWith({
    Color? backgroundColor,
    Color? borderColor,
    Color? contentColor,
    double? roundSize,
    double? halfCircleHeight,
    double? halfCircleMinWidth,
    double? iconSize,
    double? borderWidth,
    double? halfCircleHorizontalPadding,
    double? contentGap,
    TextStyle? textStyle,
  }) {
    return TBackTopThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      contentColor: contentColor ?? this.contentColor,
      roundSize: roundSize ?? this.roundSize,
      halfCircleHeight: halfCircleHeight ?? this.halfCircleHeight,
      halfCircleMinWidth: halfCircleMinWidth ?? this.halfCircleMinWidth,
      iconSize: iconSize ?? this.iconSize,
      borderWidth: borderWidth ?? this.borderWidth,
      halfCircleHorizontalPadding:
          halfCircleHorizontalPadding ?? this.halfCircleHorizontalPadding,
      contentGap: contentGap ?? this.contentGap,
      textStyle: textStyle ?? this.textStyle,
    );
  }

  @override
  TBackTopThemeData lerp(ThemeExtension<TBackTopThemeData>? other, double t) {
    if (other is! TBackTopThemeData) {
      return this;
    }
    return TBackTopThemeData(
      backgroundColor: _lerpOptionalColor(
        backgroundColor,
        other.backgroundColor,
        t,
      ),
      borderColor: _lerpOptionalColor(borderColor, other.borderColor, t),
      contentColor: _lerpOptionalColor(contentColor, other.contentColor, t),
      roundSize: _lerpOptionalDouble(roundSize, other.roundSize, 48, t),
      halfCircleHeight: _lerpOptionalDouble(
        halfCircleHeight,
        other.halfCircleHeight,
        40,
        t,
      ),
      halfCircleMinWidth: _lerpOptionalDouble(
        halfCircleMinWidth,
        other.halfCircleMinWidth,
        38,
        t,
      ),
      iconSize: _lerpOptionalDouble(iconSize, other.iconSize, 20, t),
      borderWidth: _lerpOptionalDouble(borderWidth, other.borderWidth, 0.5, t),
      halfCircleHorizontalPadding: _lerpOptionalDouble(
        halfCircleHorizontalPadding,
        other.halfCircleHorizontalPadding,
        8,
        t,
      ),
      contentGap: _lerpOptionalDouble(contentGap, other.contentGap, 2, t),
      textStyle: _lerpOptionalTextStyle(textStyle, other.textStyle, t),
    );
  }
}

double? _lerpOptionalDouble(double? a, double? b, double fallback, double t) {
  if (a == null && b == null) {
    return null;
  }
  return lerpDouble(a ?? fallback, b ?? fallback, t);
}

Color? _lerpOptionalColor(Color? a, Color? b, double t) {
  if (a == null && b == null) {
    return null;
  }
  if (a == null || b == null) {
    return t < 0.5 ? a : b;
  }
  return Color.lerp(a, b, t);
}

TextStyle? _lerpOptionalTextStyle(TextStyle? a, TextStyle? b, double t) {
  if (a == null && b == null) {
    return null;
  }
  const fallback = TextStyle(
    fontSize: 10,
    height: 1.2,
    fontWeight: FontWeight.w600,
  );
  return TextStyle.lerp(a ?? fallback, b ?? fallback, t);
}

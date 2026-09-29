import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// 计时器组件的具体视觉默认值。
///
/// 尺寸档位与形态由 `TTimeCounter.size` / `variant` 唯一选择；未设置的视觉值
/// 在使用时回退当前 TDesign 全局 Token，而不是在 Theme 中冻结默认值。
@immutable
class TTimeCounterThemeData extends ThemeExtension<TTimeCounterThemeData> {
  const TTimeCounterThemeData({
    this.defaultTextColor,
    this.blockTextColor,
    this.blockBackgroundColor,
    this.squareBorderRadius,
    this.roundBorderRadius,
  }) : assert(squareBorderRadius == null || squareBorderRadius >= 0),
       assert(roundBorderRadius == null || roundBorderRadius >= 0);

  /// 纯文本计时数字颜色；未设置时回退 `textColorPrimary`。
  final Color? defaultTextColor;

  /// 圆形、方形数字块的文字颜色；未设置时回退 `textColorAnti`。
  final Color? blockTextColor;

  /// 圆形、方形数字块的背景色；未设置时回退 `errorColor`。
  final Color? blockBackgroundColor;

  /// 方形数字块的圆角，单位为逻辑像素；未设置时回退 `radiusSmall`。
  final double? squareBorderRadius;

  /// 圆形数字块的圆角，单位为逻辑像素；未设置时回退 `radiusCircle`。
  ///
  /// 默认数字块宽高相等，故固定大半径显示为正圆。自定义较小半径时显示
  /// 对应的圆角方块，不再被固定 `BoxShape.circle` 忽略。
  final double? roundBorderRadius;

  @override
  TTimeCounterThemeData copyWith({
    Color? defaultTextColor,
    Color? blockTextColor,
    Color? blockBackgroundColor,
    double? squareBorderRadius,
    double? roundBorderRadius,
  }) => TTimeCounterThemeData(
    defaultTextColor: defaultTextColor ?? this.defaultTextColor,
    blockTextColor: blockTextColor ?? this.blockTextColor,
    blockBackgroundColor: blockBackgroundColor ?? this.blockBackgroundColor,
    squareBorderRadius: squareBorderRadius ?? this.squareBorderRadius,
    roundBorderRadius: roundBorderRadius ?? this.roundBorderRadius,
  );

  @override
  TTimeCounterThemeData lerp(
    ThemeExtension<TTimeCounterThemeData>? other,
    double t,
  ) {
    if (other is! TTimeCounterThemeData) {
      return this;
    }
    if (t == 0) {
      return this;
    }
    if (t == 1) {
      return other;
    }
    return TTimeCounterThemeData(
      defaultTextColor: _color(defaultTextColor, other.defaultTextColor, t),
      blockTextColor: _color(blockTextColor, other.blockTextColor, t),
      blockBackgroundColor: _color(
        blockBackgroundColor,
        other.blockBackgroundColor,
        t,
      ),
      squareBorderRadius: _radius(
        squareBorderRadius,
        other.squareBorderRadius,
        t,
      ),
      roundBorderRadius: _radius(roundBorderRadius, other.roundBorderRadius, t),
    );
  }

  static Color? _color(Color? a, Color? b, double t) =>
      a == null || b == null ? (t < 0.5 ? a : b) : Color.lerp(a, b, t);

  static double? _radius(double? a, double? b, double t) =>
      a == null || b == null ? (t < 0.5 ? a : b) : lerpDouble(a, b, t);
}

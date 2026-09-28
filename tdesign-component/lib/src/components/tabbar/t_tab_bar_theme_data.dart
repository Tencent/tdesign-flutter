import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// 底部标签栏 ThemeExtension
///
/// 管理 TTabBar 的子树级视觉默认值（高度、颜色与边线等）。
///
/// 实例负责内容、状态和行为；单实例定制可用局部 Theme 注入此扩展。
/// 各字段为 null 时沿全局 Token 或下述组件内置值回退。
class TTabBarThemeData extends ThemeExtension<TTabBarThemeData> {
  /// 标签栏高度；未设置时为 56 逻辑像素。
  final double? barHeight;

  /// Label 选中项背景色；未设置时回退全局 `brandColorLight`。
  final Color? selectedBgColor;

  /// Label 未选中项背景色；未设置时不额外绘制背景。
  final Color? unselectedBgColor;

  /// 标签栏容器背景色；未设置时回退全局 `bgColorContainer`。
  final Color? backgroundColor;

  /// 竖向分割线高度；未设置时为 32 逻辑像素，仅在实例 `split` 生效时使用。
  final double? dividerHeight;

  /// 竖向分割线厚度；未设置时为 0.5 逻辑像素，仅在实例 `split` 生效时使用。
  final double? dividerThickness;

  /// 竖向分割线颜色；未设置时回退全局 `componentStroke`。
  final Color? dividerColor;

  /// 顶部边线样式；未设置时使用 `componentStroke`、0.5 逻辑像素。
  ///
  /// 仅在实例 `showTopBorder` 为 true 且不是胶囊样式时绘制。
  final BorderSide? topBorder;

  const TTabBarThemeData({
    this.barHeight,
    this.selectedBgColor,
    this.unselectedBgColor,
    this.backgroundColor,
    this.dividerHeight,
    this.dividerThickness,
    this.dividerColor,
    this.topBorder,
  });

  @override
  TTabBarThemeData copyWith({
    double? barHeight,
    Color? selectedBgColor,
    Color? unselectedBgColor,
    Color? backgroundColor,
    double? dividerHeight,
    double? dividerThickness,
    Color? dividerColor,
    BorderSide? topBorder,
  }) {
    return TTabBarThemeData(
      barHeight: barHeight ?? this.barHeight,
      selectedBgColor: selectedBgColor ?? this.selectedBgColor,
      unselectedBgColor: unselectedBgColor ?? this.unselectedBgColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      dividerHeight: dividerHeight ?? this.dividerHeight,
      dividerThickness: dividerThickness ?? this.dividerThickness,
      dividerColor: dividerColor ?? this.dividerColor,
      topBorder: topBorder ?? this.topBorder,
    );
  }

  @override
  TTabBarThemeData lerp(ThemeExtension<TTabBarThemeData>? other, double t) {
    if (other is! TTabBarThemeData) {
      return this;
    }
    return TTabBarThemeData(
      barHeight: _lerpDoubleWithDefault(barHeight, other.barHeight, 56, t),
      selectedBgColor: _lerpOptionalColor(
        selectedBgColor,
        other.selectedBgColor,
        t,
      ),
      unselectedBgColor: _lerpOptionalColor(
        unselectedBgColor,
        other.unselectedBgColor,
        t,
      ),
      backgroundColor: _lerpOptionalColor(
        backgroundColor,
        other.backgroundColor,
        t,
      ),
      dividerHeight: _lerpDoubleWithDefault(
        dividerHeight,
        other.dividerHeight,
        32,
        t,
      ),
      dividerThickness: _lerpDoubleWithDefault(
        dividerThickness,
        other.dividerThickness,
        0.5,
        t,
      ),
      dividerColor: _lerpOptionalColor(dividerColor, other.dividerColor, t),
      topBorder: _lerpOptionalBorderSide(topBorder, other.topBorder, t),
    );
  }

  static double? _lerpDoubleWithDefault(
    double? a,
    double? b,
    double defaultValue,
    double t,
  ) {
    if (a == null && b == null) {
      return null;
    }
    return lerpDouble(a ?? defaultValue, b ?? defaultValue, t);
  }

  // null delegates to the lower-priority TDesign token. That token is only
  // available from BuildContext, so interpolating it as transparent here would
  // create a false style override during an animated theme transition.
  static Color? _lerpOptionalColor(Color? a, Color? b, double t) {
    if (a == null || b == null) {
      return t < 0.5 ? a : b;
    }
    return Color.lerp(a, b, t);
  }

  static BorderSide? _lerpOptionalBorderSide(
    BorderSide? a,
    BorderSide? b,
    double t,
  ) {
    if (a == null || b == null) {
      return t < 0.5 ? a : b;
    }
    return BorderSide.lerp(a, b, t);
  }
}

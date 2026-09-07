import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// 底部标签栏 ThemeExtension
///
/// 管理 TTabBar 的子树级视觉默认值（高度、颜色、间距与分割线等）。
/// 构造器参数优先级高于 ThemeData。
class TTabBarThemeData extends ThemeExtension<TTabBarThemeData> {
  /// 默认高度
  final double? barHeight;

  /// 默认选中时背景颜色
  final Color? selectedBgColor;

  /// 默认未选中时背景颜色
  final Color? unselectedBgColor;

  /// 默认背景颜色
  final Color? backgroundColor;

  /// 默认 icon 与文本中间距离
  final double? centerDistance;

  /// 默认分割线高度
  final double? dividerHeight;

  /// 默认分割线厚度
  final double? dividerThickness;

  /// 默认分割线颜色
  final Color? dividerColor;

  /// 默认上边线样式
  final BorderSide? topBorder;

  const TTabBarThemeData({
    this.barHeight,
    this.selectedBgColor,
    this.unselectedBgColor,
    this.backgroundColor,
    this.centerDistance,
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
    double? centerDistance,
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
      centerDistance: centerDistance ?? this.centerDistance,
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
      centerDistance: _lerpDoubleWithDefault(
        centerDistance,
        other.centerDistance,
        0,
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

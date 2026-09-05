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
      barHeight: lerpDouble(barHeight, other.barHeight, t),
      selectedBgColor: Color.lerp(selectedBgColor, other.selectedBgColor, t),
      unselectedBgColor: Color.lerp(
        unselectedBgColor,
        other.unselectedBgColor,
        t,
      ),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      centerDistance: lerpDouble(centerDistance, other.centerDistance, t),
      dividerHeight: lerpDouble(dividerHeight, other.dividerHeight, t),
      dividerThickness: lerpDouble(dividerThickness, other.dividerThickness, t),
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t),
      topBorder: BorderSide.lerp(
        topBorder ?? BorderSide.none,
        other.topBorder ?? BorderSide.none,
        t,
      ),
    );
  }
}

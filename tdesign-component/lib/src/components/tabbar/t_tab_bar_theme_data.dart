import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// 底部标签栏 ThemeExtension
///
/// 管理 TTabBar 的子树级默认样式（高度、颜色、分割线、指示器动画等）。
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

  /// 默认是否使用竖线分隔
  final bool? useVerticalDivider;

  /// 默认分割线高度
  final double? dividerHeight;

  /// 默认分割线厚度
  final double? dividerThickness;

  /// 默认分割线颜色
  final Color? dividerColor;

  /// 默认是否展示 bar 上边线
  final bool? showTopBorder;

  /// 默认上边线样式
  final BorderSide? topBorder;

  /// 默认是否需要水波纹效果
  final bool? needInkWell;

  /// 默认动画时长
  final Duration? animationDuration;

  /// 默认动画曲线
  final Curve? animationCurve;

  const TTabBarThemeData({
    this.barHeight,
    this.selectedBgColor,
    this.unselectedBgColor,
    this.backgroundColor,
    this.centerDistance,
    this.useVerticalDivider,
    this.dividerHeight,
    this.dividerThickness,
    this.dividerColor,
    this.showTopBorder,
    this.topBorder,
    this.needInkWell,
    this.animationDuration,
    this.animationCurve,
  });

  @override
  TTabBarThemeData copyWith({
    double? barHeight,
    Color? selectedBgColor,
    Color? unselectedBgColor,
    Color? backgroundColor,
    double? centerDistance,
    bool? useVerticalDivider,
    double? dividerHeight,
    double? dividerThickness,
    Color? dividerColor,
    bool? showTopBorder,
    BorderSide? topBorder,
    bool? needInkWell,
    Duration? animationDuration,
    Curve? animationCurve,
  }) {
    return TTabBarThemeData(
      barHeight: barHeight ?? this.barHeight,
      selectedBgColor: selectedBgColor ?? this.selectedBgColor,
      unselectedBgColor: unselectedBgColor ?? this.unselectedBgColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      centerDistance: centerDistance ?? this.centerDistance,
      useVerticalDivider: useVerticalDivider ?? this.useVerticalDivider,
      dividerHeight: dividerHeight ?? this.dividerHeight,
      dividerThickness: dividerThickness ?? this.dividerThickness,
      dividerColor: dividerColor ?? this.dividerColor,
      showTopBorder: showTopBorder ?? this.showTopBorder,
      topBorder: topBorder ?? this.topBorder,
      needInkWell: needInkWell ?? this.needInkWell,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
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
      unselectedBgColor:
          Color.lerp(unselectedBgColor, other.unselectedBgColor, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      centerDistance: lerpDouble(centerDistance, other.centerDistance, t),
      useVerticalDivider:
          t <= 0.5 ? useVerticalDivider : other.useVerticalDivider,
      dividerHeight: lerpDouble(dividerHeight, other.dividerHeight, t),
      dividerThickness: lerpDouble(dividerThickness, other.dividerThickness, t),
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t),
      showTopBorder: t <= 0.5 ? showTopBorder : other.showTopBorder,
      topBorder: BorderSide.lerp(
          topBorder ?? BorderSide.none, other.topBorder ?? BorderSide.none, t),
      needInkWell: t <= 0.5 ? needInkWell : other.needInkWell,
      animationDuration: t <= 0.5 ? animationDuration : other.animationDuration,
      animationCurve: t <= 0.5 ? animationCurve : other.animationCurve,
    );
  }
}

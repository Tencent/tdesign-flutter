import 'package:flutter/material.dart';

import 't_swiper_types.dart';

/// 轮播组件级 ThemeExtension。
///
/// 仅保存页面效果和指示器的视觉默认值。
class TSwiperThemeData extends ThemeExtension<TSwiperThemeData> {
  const TSwiperThemeData({
    this.pagination,
    this.pageEffect,
    this.paginationMargin,
    this.activeColor,
    this.inactiveColor,
    this.dotSize,
    this.activeDotWidth,
    this.dotSpacing,
    this.fractionStyle,
    this.fractionBackgroundColor,
  });

  /// 默认指示器形态。
  final TSwiperPaginationVariant? pagination;

  /// 默认页面切换效果。
  final TSwiperPageEffect? pageEffect;

  /// 指示器外边距。
  final EdgeInsetsGeometry? paginationMargin;

  /// 激活项颜色。
  final Color? activeColor;

  /// 未激活项颜色。
  final Color? inactiveColor;

  /// 圆点直径。
  final double? dotSize;

  /// 长条激活项宽度。
  final double? activeDotWidth;

  /// 圆点间距。
  final double? dotSpacing;

  /// 数字指示器文字样式。
  final TextStyle? fractionStyle;

  /// 数字指示器背景色。
  final Color? fractionBackgroundColor;

  @override
  TSwiperThemeData copyWith({
    TSwiperPaginationVariant? pagination,
    TSwiperPageEffect? pageEffect,
    EdgeInsetsGeometry? paginationMargin,
    Color? activeColor,
    Color? inactiveColor,
    double? dotSize,
    double? activeDotWidth,
    double? dotSpacing,
    TextStyle? fractionStyle,
    Color? fractionBackgroundColor,
  }) {
    return TSwiperThemeData(
      pagination: pagination ?? this.pagination,
      pageEffect: pageEffect ?? this.pageEffect,
      paginationMargin: paginationMargin ?? this.paginationMargin,
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      dotSize: dotSize ?? this.dotSize,
      activeDotWidth: activeDotWidth ?? this.activeDotWidth,
      dotSpacing: dotSpacing ?? this.dotSpacing,
      fractionStyle: fractionStyle ?? this.fractionStyle,
      fractionBackgroundColor:
          fractionBackgroundColor ?? this.fractionBackgroundColor,
    );
  }

  @override
  TSwiperThemeData lerp(TSwiperThemeData? other, double t) {
    if (other == null) {
      return this;
    }
    return TSwiperThemeData(
      pagination: t < 0.5 ? pagination : other.pagination,
      pageEffect: t < 0.5 ? pageEffect : other.pageEffect,
      paginationMargin:
          EdgeInsetsGeometry.lerp(paginationMargin, other.paginationMargin, t),
      activeColor: Color.lerp(activeColor, other.activeColor, t),
      inactiveColor: Color.lerp(inactiveColor, other.inactiveColor, t),
      dotSize: _lerp(dotSize, other.dotSize, t),
      activeDotWidth: _lerp(activeDotWidth, other.activeDotWidth, t),
      dotSpacing: _lerp(dotSpacing, other.dotSpacing, t),
      fractionStyle: TextStyle.lerp(fractionStyle, other.fractionStyle, t),
      fractionBackgroundColor: Color.lerp(
        fractionBackgroundColor,
        other.fractionBackgroundColor,
        t,
      ),
    );
  }

  double? _lerp(double? a, double? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return (a ?? 0) + ((b ?? 0) - (a ?? 0)) * t;
  }
}

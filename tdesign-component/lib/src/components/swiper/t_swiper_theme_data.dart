import 'package:flutter/material.dart';

import 't_swiper_types.dart';

/// 轮播组件级 ThemeExtension。
///
/// 保存页面效果、指示器和切换按钮的视觉默认值。
class TSwiperThemeData extends ThemeExtension<TSwiperThemeData> {
  const TSwiperThemeData({
    this.pagination,
    this.pageEffect,
    this.paginationPlacement,
    this.paginationAlignment,
    this.paginationMargin,
    this.activeColor,
    this.inactiveColor,
    this.dotSize,
    this.activeDotExtent,
    this.dotSpacing,
    this.fractionStyle,
    this.fractionBackgroundColor,
    this.controlStyle,
    this.controlIconSize,
  });

  /// 默认指示器形态。
  final TSwiperPaginationVariant? pagination;

  /// 默认页面切换效果。
  final TSwiperPageEffect? pageEffect;

  /// 默认指示器位置。
  final TSwiperPaginationPlacement? paginationPlacement;

  /// 默认指示器对齐方式。
  final AlignmentGeometry? paginationAlignment;

  /// 指示器外边距。
  final EdgeInsetsGeometry? paginationMargin;

  /// 激活项颜色。
  final Color? activeColor;

  /// 未激活项颜色。
  final Color? inactiveColor;

  /// 圆点直径。
  final double? dotSize;

  /// 长条激活项在滚动主轴上的长度。
  final double? activeDotExtent;

  /// 圆点间距。
  final double? dotSpacing;

  /// 数字指示器文字样式。
  final TextStyle? fractionStyle;

  /// 数字指示器背景色。
  final Color? fractionBackgroundColor;

  /// 控制按钮样式。
  final ButtonStyle? controlStyle;

  /// 控制按钮图标尺寸。
  final double? controlIconSize;

  @override
  TSwiperThemeData copyWith({
    TSwiperPaginationVariant? pagination,
    TSwiperPageEffect? pageEffect,
    TSwiperPaginationPlacement? paginationPlacement,
    AlignmentGeometry? paginationAlignment,
    EdgeInsetsGeometry? paginationMargin,
    Color? activeColor,
    Color? inactiveColor,
    double? dotSize,
    double? activeDotExtent,
    double? dotSpacing,
    TextStyle? fractionStyle,
    Color? fractionBackgroundColor,
    ButtonStyle? controlStyle,
    double? controlIconSize,
  }) {
    return TSwiperThemeData(
      pagination: pagination ?? this.pagination,
      pageEffect: pageEffect ?? this.pageEffect,
      paginationPlacement: paginationPlacement ?? this.paginationPlacement,
      paginationAlignment: paginationAlignment ?? this.paginationAlignment,
      paginationMargin: paginationMargin ?? this.paginationMargin,
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      dotSize: dotSize ?? this.dotSize,
      activeDotExtent: activeDotExtent ?? this.activeDotExtent,
      dotSpacing: dotSpacing ?? this.dotSpacing,
      fractionStyle: fractionStyle ?? this.fractionStyle,
      fractionBackgroundColor:
          fractionBackgroundColor ?? this.fractionBackgroundColor,
      controlStyle: controlStyle ?? this.controlStyle,
      controlIconSize: controlIconSize ?? this.controlIconSize,
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
      paginationPlacement:
          t < 0.5 ? paginationPlacement : other.paginationPlacement,
      paginationAlignment: AlignmentGeometry.lerp(
        paginationAlignment,
        other.paginationAlignment,
        t,
      ),
      paginationMargin:
          EdgeInsetsGeometry.lerp(paginationMargin, other.paginationMargin, t),
      activeColor: Color.lerp(activeColor, other.activeColor, t),
      inactiveColor: Color.lerp(inactiveColor, other.inactiveColor, t),
      dotSize: _lerp(dotSize, other.dotSize, t),
      activeDotExtent: _lerp(activeDotExtent, other.activeDotExtent, t),
      dotSpacing: _lerp(dotSpacing, other.dotSpacing, t),
      fractionStyle: TextStyle.lerp(fractionStyle, other.fractionStyle, t),
      fractionBackgroundColor: Color.lerp(
        fractionBackgroundColor,
        other.fractionBackgroundColor,
        t,
      ),
      controlStyle: ButtonStyle.lerp(controlStyle, other.controlStyle, t),
      controlIconSize: _lerp(controlIconSize, other.controlIconSize, t),
    );
  }

  double? _lerp(double? a, double? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return (a ?? 0) + ((b ?? 0) - (a ?? 0)) * t;
  }
}

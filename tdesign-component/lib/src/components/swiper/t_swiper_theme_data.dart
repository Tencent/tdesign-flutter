import 'package:flutter/material.dart';

import 't_swiper_types.dart';

/// 轮播组件级 ThemeExtension。
///
/// 保存指示器、内容圆角和切换按钮的视觉默认值。
class TSwiperThemeData extends ThemeExtension<TSwiperThemeData> {
  const TSwiperThemeData({
    this.paginationAlignment,
    this.paginationMargin,
    this.borderRadius,
    this.activeColor,
    this.inactiveColor,
    this.dotSize,
    this.activeDotExtent,
    this.dotSpacing,
    this.fractionStyle,
    this.fractionBackgroundColor,
    this.controlStyle,
    this.controlIconSize,
  }) : assert(dotSize == null || dotSize > 0),
       assert(activeDotExtent == null || activeDotExtent > 0),
       assert(dotSpacing == null || dotSpacing >= 0),
       assert(controlIconSize == null || controlIconSize > 0);

  /// 默认指示器对齐方式。
  final AlignmentGeometry? paginationAlignment;

  /// 指示器外边距。
  final EdgeInsetsGeometry? paginationMargin;

  /// 轮播内容圆角。
  final BorderRadiusGeometry? borderRadius;

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
    AlignmentGeometry? paginationAlignment,
    EdgeInsetsGeometry? paginationMargin,
    BorderRadiusGeometry? borderRadius,
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
      paginationAlignment: paginationAlignment ?? this.paginationAlignment,
      paginationMargin: paginationMargin ?? this.paginationMargin,
      borderRadius: borderRadius ?? this.borderRadius,
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
      paginationAlignment: AlignmentGeometry.lerp(
        paginationAlignment,
        other.paginationAlignment,
        t,
      ),
      paginationMargin: EdgeInsetsGeometry.lerp(
        paginationMargin,
        other.paginationMargin,
        t,
      ),
      borderRadius: BorderRadiusGeometry.lerp(
        borderRadius,
        other.borderRadius,
        t,
      ),
      activeColor: Color.lerp(activeColor, other.activeColor, t),
      inactiveColor: Color.lerp(inactiveColor, other.inactiveColor, t),
      dotSize: _lerpNullableDouble(dotSize, other.dotSize, t),
      activeDotExtent: _lerpNullableDouble(
        activeDotExtent,
        other.activeDotExtent,
        t,
      ),
      dotSpacing: _lerpNullableDouble(dotSpacing, other.dotSpacing, t),
      fractionStyle: TextStyle.lerp(fractionStyle, other.fractionStyle, t),
      fractionBackgroundColor: Color.lerp(
        fractionBackgroundColor,
        other.fractionBackgroundColor,
        t,
      ),
      controlStyle: ButtonStyle.lerp(controlStyle, other.controlStyle, t),
      controlIconSize: _lerpNullableDouble(
        controlIconSize,
        other.controlIconSize,
        t,
      ),
    );
  }

  double? _lerpNullableDouble(double? a, double? b, double t) {
    if (a == null || b == null) {
      return t < 0.5 ? a : b;
    }
    return a + (b - a) * t;
  }
}

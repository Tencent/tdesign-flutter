import 'package:flutter/material.dart';

import 't_swiper_types.dart';

const _defaultDotSize = 6.0;
const _defaultActiveDotExtent = 20.0;
const _defaultDotSpacing = 5.0;
const _defaultControlIconSize = 18.0;

/// 轮播组件级 ThemeExtension。
///
/// 保存指示器、内容圆角和切换按钮的视觉默认值。
///
/// {@category ComponentTheme}
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
  /// 未配置时 controls 居中，其他类型横向轮播为 bottomCenter、纵向轮播为 centerRight。
  final AlignmentGeometry? paginationAlignment;

  /// 指示器外边距。
  /// 未配置时普通指示器四边为 12；controls 沿滚动轴两端为 15 逻辑像素。
  final EdgeInsetsGeometry? paginationMargin;

  /// 轮播内容圆角。
  /// null 时使用 radiusLarge Token 构造圆角。
  final BorderRadiusGeometry? borderRadius;

  /// 激活项颜色。
  /// null 时使用 textColorAnti Token。
  final Color? activeColor;

  /// 未激活项颜色。
  final Color? inactiveColor;

  /// 圆点直径。
  /// 未配置时为 6 逻辑像素，必须大于 0。
  final double? dotSize;

  /// 长条激活项在滚动主轴上的长度。
  /// 未配置时为 20 逻辑像素，必须大于 0。
  final double? activeDotExtent;

  /// 圆点间距。
  /// 未配置时为 5 逻辑像素，必须大于或等于 0。
  final double? dotSpacing;

  /// 数字指示器文字样式。
  final TextStyle? fractionStyle;

  /// 数字指示器背景色。
  /// null 时使用 textColorPlaceholder Token。
  final Color? fractionBackgroundColor;

  /// 控制按钮样式。
  final ButtonStyle? controlStyle;

  /// 控制按钮图标尺寸。
  /// 未配置时为 18 逻辑像素，必须大于 0。
  final double? controlIconSize;

  /// 复制主题配置。
  ///
  /// ## 返回值
  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
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

  /// 生成主题过渡配置。
  ///
  /// ## 返回值
  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TSwiperThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    TSwiperThemeData? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
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
      dotSize: _lerpNullableDouble(dotSize, other.dotSize, t, _defaultDotSize),
      activeDotExtent: _lerpNullableDouble(
        activeDotExtent,
        other.activeDotExtent,
        t,
        _defaultActiveDotExtent,
      ),
      dotSpacing: _lerpNullableDouble(
        dotSpacing,
        other.dotSpacing,
        t,
        _defaultDotSpacing,
      ),
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
        _defaultControlIconSize,
      ),
    );
  }

  double? _lerpNullableDouble(
    double? a,
    double? b,
    double t,
    double defaultValue,
  ) {
    if (a == null && b == null) {
      return null;
    }
    return (a ?? defaultValue) +
        ((b ?? defaultValue) - (a ?? defaultValue)) * t;
  }
}

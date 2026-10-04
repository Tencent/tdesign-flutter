import 'package:flutter/material.dart';

/// TSlider 与 TRangeSlider 共用的组件级 ThemeExtension。
///
/// 轨道、滑块和提示标签由组件 Theme 控制，不读取 Material SliderTheme。
class TSliderThemeData extends ThemeExtension<TSliderThemeData> {
  const TSliderThemeData({
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.thumbColor,
    this.disabledThumbColor,
    this.thumbBorderColor,
    this.disabledThumbBorderColor,
    this.overlayColor,
    this.valueIndicatorColor,
    this.valueIndicatorTextColor,
    this.trackHeight,

    /// 滑块外层装饰。
    this.decoration,
  });

  /// 选中轨道颜色；为空时使用全局品牌色。
  final Color? activeTrackColor;

  /// 未选中轨道颜色；为空时使用全局组件边框色。
  final Color? inactiveTrackColor;

  /// 滑块填充颜色；为空时使用全局反色文字色。
  final Color? thumbColor;

  /// 禁用滑块填充颜色；为空时使用全局反色文字色。
  final Color? disabledThumbColor;

  /// 滑块描边颜色；为空时使用全局灰阶色。
  final Color? thumbBorderColor;

  /// 禁用滑块描边颜色；为空时使用全局禁用背景色。
  final Color? disabledThumbBorderColor;

  /// 交互反馈颜色；为空时使用品牌色的透明层。
  final Color? overlayColor;

  /// 数值提示背景颜色；为空时使用全局品牌色。
  final Color? valueIndicatorColor;

  /// 数值提示文字颜色；为空时使用全局主要文字色。
  final Color? valueIndicatorTextColor;

  /// 普通轨道粗细；胶囊形态仍使用其内置规格。
  final double? trackHeight;

  /// 滑块外层装饰。
  final Decoration? decoration;

  @override
  TSliderThemeData copyWith({
    Color? activeTrackColor,
    Color? inactiveTrackColor,
    Color? thumbColor,
    Color? disabledThumbColor,
    Color? thumbBorderColor,
    Color? disabledThumbBorderColor,
    Color? overlayColor,
    Color? valueIndicatorColor,
    Color? valueIndicatorTextColor,
    double? trackHeight,
    Decoration? decoration,
  }) {
    return TSliderThemeData(
      activeTrackColor: activeTrackColor ?? this.activeTrackColor,
      inactiveTrackColor: inactiveTrackColor ?? this.inactiveTrackColor,
      thumbColor: thumbColor ?? this.thumbColor,
      disabledThumbColor: disabledThumbColor ?? this.disabledThumbColor,
      thumbBorderColor: thumbBorderColor ?? this.thumbBorderColor,
      disabledThumbBorderColor:
          disabledThumbBorderColor ?? this.disabledThumbBorderColor,
      overlayColor: overlayColor ?? this.overlayColor,
      valueIndicatorColor: valueIndicatorColor ?? this.valueIndicatorColor,
      valueIndicatorTextColor:
          valueIndicatorTextColor ?? this.valueIndicatorTextColor,
      trackHeight: trackHeight ?? this.trackHeight,
      decoration: decoration ?? this.decoration,
    );
  }

  @override
  TSliderThemeData lerp(ThemeExtension<TSliderThemeData>? other, double t) {
    if (other is! TSliderThemeData) {
      return this;
    }
    return TSliderThemeData(
      activeTrackColor: _lerpColor(activeTrackColor, other.activeTrackColor, t),
      inactiveTrackColor: _lerpColor(
        inactiveTrackColor,
        other.inactiveTrackColor,
        t,
      ),
      thumbColor: _lerpColor(thumbColor, other.thumbColor, t),
      disabledThumbColor: _lerpColor(
        disabledThumbColor,
        other.disabledThumbColor,
        t,
      ),
      thumbBorderColor: _lerpColor(thumbBorderColor, other.thumbBorderColor, t),
      disabledThumbBorderColor: _lerpColor(
        disabledThumbBorderColor,
        other.disabledThumbBorderColor,
        t,
      ),
      overlayColor: _lerpColor(overlayColor, other.overlayColor, t),
      valueIndicatorColor: _lerpColor(
        valueIndicatorColor,
        other.valueIndicatorColor,
        t,
      ),
      valueIndicatorTextColor: _lerpColor(
        valueIndicatorTextColor,
        other.valueIndicatorTextColor,
        t,
      ),
      trackHeight: t < 0.5 ? trackHeight : other.trackHeight,
      decoration: Decoration.lerp(decoration, other.decoration, t),
    );
  }

  static Color? _lerpColor(Color? begin, Color? end, double t) {
    if (begin == null || end == null) {
      return t < 0.5 ? begin : end;
    }
    return Color.lerp(begin, end, t);
  }
}

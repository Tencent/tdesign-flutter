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

  /// 禁用滑块描边颜色；为空时浅色使用 componentBorder Token，
  /// 暗色使用 bgColorComponentDisabled Token。
  final Color? disabledThumbBorderColor;

  /// 交互反馈颜色；为空时使用品牌色的透明层。
  final Color? overlayColor;

  /// 数值提示背景颜色；为空时使用全局品牌色。
  final Color? valueIndicatorColor;

  /// 数值提示文字颜色；为空时使用全局主要文字色。
  final Color? valueIndicatorTextColor;

  /// 普通轨道粗细；胶囊形态仍使用其内置规格。
  /// null 时为 4 逻辑像素。
  final double? trackHeight;

  /// 滑块外层装饰。
  final Decoration? decoration;

  /// 复制主题配置。
  ///
  /// ## 返回值
  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
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

  /// 生成主题过渡配置。
  ///
  /// ## 返回值
  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TSliderThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TSliderThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
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

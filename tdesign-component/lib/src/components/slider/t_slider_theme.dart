import 'package:flutter/material.dart';

/// TSlider 与 TRangeSlider 共用的组件级 ThemeExtension。
///
/// 轨道、thumb、overlay、刻度和状态颜色使用 Material [SliderThemeData]；
/// 此扩展只承载 Material Slider 没有的外层装饰。
class TSliderThemeData extends ThemeExtension<TSliderThemeData> {
  const TSliderThemeData({
    /// 滑块外层装饰。
    this.decoration,
  });

  /// 滑块外层装饰。
  final Decoration? decoration;

  @override
  TSliderThemeData copyWith({Decoration? decoration}) {
    return TSliderThemeData(decoration: decoration ?? this.decoration);
  }

  @override
  TSliderThemeData lerp(
    ThemeExtension<TSliderThemeData>? other,
    double t,
  ) {
    if (other is! TSliderThemeData) {
      return this;
    }
    return TSliderThemeData(
      decoration: Decoration.lerp(decoration, other.decoration, t),
    );
  }
}

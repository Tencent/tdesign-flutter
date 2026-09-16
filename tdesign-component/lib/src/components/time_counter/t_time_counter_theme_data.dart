import 'package:flutter/material.dart';

import 't_time_counter_types.dart';

/// 计时器组件的视觉默认值。
@immutable
class TTimeCounterThemeData extends ThemeExtension<TTimeCounterThemeData> {
  const TTimeCounterThemeData({this.defaultVariant, this.defaultSize});

  /// 默认视觉形态。
  final TTimeCounterVariant? defaultVariant;

  /// 默认尺寸。
  final TTimeCounterSize? defaultSize;

  @override
  TTimeCounterThemeData copyWith({
    TTimeCounterVariant? defaultVariant,
    TTimeCounterSize? defaultSize,
  }) {
    return TTimeCounterThemeData(
      defaultVariant: defaultVariant ?? this.defaultVariant,
      defaultSize: defaultSize ?? this.defaultSize,
    );
  }

  @override
  TTimeCounterThemeData lerp(
    ThemeExtension<TTimeCounterThemeData>? other,
    double t,
  ) {
    if (other is! TTimeCounterThemeData) {
      return this;
    }
    return TTimeCounterThemeData(
      defaultVariant: t < 0.5 ? defaultVariant : other.defaultVariant,
      defaultSize: t < 0.5 ? defaultSize : other.defaultSize,
    );
  }
}

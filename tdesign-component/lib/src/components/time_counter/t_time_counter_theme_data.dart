import 'package:flutter/material.dart';

import 't_time_counter_types.dart';

/// 计时器组件的视觉和展示默认值。
@immutable
class TTimeCounterThemeData extends ThemeExtension<TTimeCounterThemeData> {
  const TTimeCounterThemeData({
    this.variant,
    this.size,
    this.showMillisecond,
    this.splitWithUnit,
  });

  /// 默认视觉形态。
  final TTimeCounterVariant? variant;

  /// 默认尺寸。
  final TTimeCounterSize? size;

  /// 默认是否显示毫秒。
  final bool? showMillisecond;

  /// 默认是否使用本地化时间单位分隔。
  final bool? splitWithUnit;

  @override
  TTimeCounterThemeData copyWith({
    TTimeCounterVariant? variant,
    TTimeCounterSize? size,
    bool? showMillisecond,
    bool? splitWithUnit,
  }) {
    return TTimeCounterThemeData(
      variant: variant ?? this.variant,
      size: size ?? this.size,
      showMillisecond: showMillisecond ?? this.showMillisecond,
      splitWithUnit: splitWithUnit ?? this.splitWithUnit,
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
      variant: t < 0.5 ? variant : other.variant,
      size: t < 0.5 ? size : other.size,
      showMillisecond: t < 0.5 ? showMillisecond : other.showMillisecond,
      splitWithUnit: t < 0.5 ? splitWithUnit : other.splitWithUnit,
    );
  }
}

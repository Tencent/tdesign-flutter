import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 't_stepper_types.dart';

/// TStepper 组件级 ThemeExtension。
class TStepperThemeData extends ThemeExtension<TStepperThemeData> {
  const TStepperThemeData({
    /// 默认形态。
    this.variant,

    /// 输入框宽度。
    this.inputWidth,
  });

  /// 默认形态。
  final TStepperVariant? variant;

  /// 输入框宽度。
  final double? inputWidth;

  @override
  TStepperThemeData copyWith({
    TStepperVariant? variant,
    double? inputWidth,
  }) {
    return TStepperThemeData(
      variant: variant ?? this.variant,
      inputWidth: inputWidth ?? this.inputWidth,
    );
  }

  @override
  TStepperThemeData lerp(ThemeExtension<TStepperThemeData>? other, double t) {
    if (other is! TStepperThemeData) {
      return this;
    }
    return TStepperThemeData(
      variant: t < 0.5 ? variant : other.variant,
      inputWidth: lerpDouble(inputWidth, other.inputWidth, t),
    );
  }
}

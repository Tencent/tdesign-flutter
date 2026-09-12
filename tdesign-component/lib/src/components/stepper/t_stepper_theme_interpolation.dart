import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 't_stepper_defaults.dart';
import 't_stepper_theme_data.dart';
import 't_stepper_types.dart';

// Internal interpolation data, deliberately not exported from the package.
// Unset visual fields depend on the consuming widget's size, inherited styles,
// and tokens. Resolve both endpoints there instead of promoting placeholder
// colors or geometry into explicit component overrides.
class StepperThemeInterpolation extends TStepperThemeData {
  StepperThemeInterpolation(this.begin, this.end, this.progress)
    : super(
        size: progress < 0.5 ? begin.size : end.size,
        variant: progress < 0.5 ? begin.variant : end.variant,
        inputWidth: _number(
          begin.inputWidth,
          end.inputWidth,
          stepperGeometry(begin.size).inputWidth,
          stepperGeometry(end.size).inputWidth,
          progress,
        ),
        controlSize: _number(
          begin.controlSize,
          end.controlSize,
          stepperGeometry(begin.size).controlSize,
          stepperGeometry(end.size).controlSize,
          progress,
        ),
        iconSize: _number(
          begin.iconSize,
          end.iconSize,
          stepperGeometry(begin.size).iconSize,
          stepperGeometry(end.size).iconSize,
          progress,
        ),
        spacing: _number(
          begin.spacing,
          end.spacing,
          stepperSpacing,
          stepperSpacing,
          progress,
        ),
        borderRadius: _nullable(
          begin.borderRadius,
          end.borderRadius,
          progress,
          BorderRadius.lerp,
        ),
        borderWidth: _number(
          begin.borderWidth,
          end.borderWidth,
          stepperBorderWidth,
          stepperBorderWidth,
          progress,
        ),
        foregroundColor: _nullable(
          begin.foregroundColor,
          end.foregroundColor,
          progress,
          Color.lerp,
        ),
        disabledForegroundColor: _nullable(
          begin.disabledForegroundColor,
          end.disabledForegroundColor,
          progress,
          Color.lerp,
        ),
        backgroundColor: _nullable(
          begin.backgroundColor,
          end.backgroundColor,
          progress,
          Color.lerp,
        ),
        disabledBackgroundColor: _nullable(
          begin.disabledBackgroundColor,
          end.disabledBackgroundColor,
          progress,
          Color.lerp,
        ),
        borderColor: _nullable(
          begin.borderColor,
          end.borderColor,
          progress,
          Color.lerp,
        ),
        textStyle: _nullable(
          begin.textStyle,
          end.textStyle,
          progress,
          TextStyle.lerp,
        ),
      );

  final TStepperThemeData begin;
  final TStepperThemeData end;
  final double progress;

  @override
  TStepperThemeData copyWith({
    TStepperSize? size,
    TStepperVariant? variant,
    double? inputWidth,
    double? controlSize,
    double? iconSize,
    double? spacing,
    BorderRadius? borderRadius,
    double? borderWidth,
    Color? foregroundColor,
    Color? disabledForegroundColor,
    Color? backgroundColor,
    Color? disabledBackgroundColor,
    Color? borderColor,
    TextStyle? textStyle,
  }) {
    TStepperThemeData copy(TStepperThemeData theme) => theme.copyWith(
      size: size,
      variant: variant,
      inputWidth: inputWidth,
      controlSize: controlSize,
      iconSize: iconSize,
      spacing: spacing,
      borderRadius: borderRadius,
      borderWidth: borderWidth,
      foregroundColor: foregroundColor,
      disabledForegroundColor: disabledForegroundColor,
      backgroundColor: backgroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      borderColor: borderColor,
      textStyle: textStyle,
    );
    return copy(begin).lerp(copy(end), progress);
  }

  static double? _number(
    double? a,
    double? b,
    double defaultA,
    double defaultB,
    double t,
  ) {
    if (a == null && b == null) {
      return null;
    }
    return lerpDouble(a ?? defaultA, b ?? defaultB, t);
  }

  static T? _nullable<T>(
    T? a,
    T? b,
    double t,
    T? Function(T?, T?, double) lerp,
  ) {
    if (a == null || b == null) {
      return t < 0.5 ? a : b;
    }
    return lerp(a, b, t);
  }
}

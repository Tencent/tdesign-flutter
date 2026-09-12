import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// 进度条组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认样式。
/// 构造器参数优先于 Theme。
class TProgressThemeData extends ThemeExtension<TProgressThemeData> {
  /// 进度条粗细
  final double? strokeWidth;

  /// 进度条颜色
  final Color? color;

  /// 进度条背景色
  final Color? backgroundColor;

  /// 条形进度条末端圆角
  final BorderRadiusGeometry? linearBorderRadius;

  /// 环形进度条半径
  final double? circleRadius;

  /// 动画持续时间
  final Duration? animationDuration;

  /// 不确定进度完成一次循环的时长。
  final Duration? indeterminateAnimationDuration;

  /// 不确定线性进度段占轨道宽度的比例。
  final double? indeterminateLinearSegmentFraction;

  /// 不确定环形进度弧占整圈的比例。
  final double? indeterminateCircularValue;

  const TProgressThemeData({
    this.strokeWidth,
    this.color,
    this.backgroundColor,
    this.linearBorderRadius,
    this.circleRadius,
    this.animationDuration,
    this.indeterminateAnimationDuration,
    this.indeterminateLinearSegmentFraction,
    this.indeterminateCircularValue,
  }) : assert(
         indeterminateLinearSegmentFraction == null ||
             (indeterminateLinearSegmentFraction > 0 &&
                 indeterminateLinearSegmentFraction <= 1),
       ),
       assert(
         indeterminateCircularValue == null ||
             (indeterminateCircularValue > 0 && indeterminateCircularValue < 1),
       );

  @override
  TProgressThemeData copyWith({
    double? strokeWidth,
    Color? color,
    Color? backgroundColor,
    BorderRadiusGeometry? linearBorderRadius,
    double? circleRadius,
    Duration? animationDuration,
    Duration? indeterminateAnimationDuration,
    double? indeterminateLinearSegmentFraction,
    double? indeterminateCircularValue,
  }) {
    return TProgressThemeData(
      strokeWidth: strokeWidth ?? this.strokeWidth,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      linearBorderRadius: linearBorderRadius ?? this.linearBorderRadius,
      circleRadius: circleRadius ?? this.circleRadius,
      animationDuration: animationDuration ?? this.animationDuration,
      indeterminateAnimationDuration:
          indeterminateAnimationDuration ?? this.indeterminateAnimationDuration,
      indeterminateLinearSegmentFraction:
          indeterminateLinearSegmentFraction ??
          this.indeterminateLinearSegmentFraction,
      indeterminateCircularValue:
          indeterminateCircularValue ?? this.indeterminateCircularValue,
    );
  }

  @override
  TProgressThemeData lerp(ThemeExtension<TProgressThemeData>? other, double t) {
    if (other is! TProgressThemeData) {
      return this;
    }
    return TProgressThemeData(
      strokeWidth: lerpDouble(strokeWidth, other.strokeWidth, t),
      color: Color.lerp(color, other.color, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      linearBorderRadius: BorderRadiusGeometry.lerp(
        linearBorderRadius,
        other.linearBorderRadius,
        t,
      ),
      circleRadius: lerpDouble(circleRadius, other.circleRadius, t),
      animationDuration: lerpDuration(
        animationDuration,
        other.animationDuration,
        t,
      ),
      indeterminateAnimationDuration: lerpDuration(
        indeterminateAnimationDuration,
        other.indeterminateAnimationDuration,
        t,
      ),
      indeterminateLinearSegmentFraction: lerpDouble(
        indeterminateLinearSegmentFraction,
        other.indeterminateLinearSegmentFraction,
        t,
      ),
      indeterminateCircularValue: lerpDouble(
        indeterminateCircularValue,
        other.indeterminateCircularValue,
        t,
      ),
    );
  }
}

/// 线性插值两个 [Duration]
Duration? lerpDuration(Duration? a, Duration? b, double t) {
  if (a == null && b == null) {
    return null;
  }
  if (a == null) {
    return b;
  }
  if (b == null) {
    return a;
  }
  return Duration(
    milliseconds: (a.inMilliseconds + (b.inMilliseconds - a.inMilliseconds) * t)
        .round(),
  );
}

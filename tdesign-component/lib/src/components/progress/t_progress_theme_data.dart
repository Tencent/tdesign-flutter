import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 't_progress.dart' show TProgressLabelPosition;

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

  /// 是否显示标签
  final bool? showLabel;

  /// 自定义标签宽度
  final double? labelWidgetWidth;

  /// 自定义标签对齐方式
  final Alignment? labelWidgetAlignment;

  /// 标签显示位置
  final TProgressLabelPosition? progressLabelPosition;

  /// 动画持续时间
  final Duration? animationDuration;

  /// 不确定进度完成一次循环的时长。
  final Duration? indeterminateAnimationDuration;

  /// 不确定线性进度段占轨道宽度的比例。
  final double? indeterminateLinearSegmentFraction;

  /// 不确定环形进度弧占整圈的比例。
  final double? indeterminateCircularValue;

  /// 线性和按钮进度条处于横向无界布局时使用的兜底宽度。
  ///
  /// 未设置时使用当前 MediaQuery 的视口宽度；有界布局不使用该字段。
  final double? fallbackLinearWidth;

  const TProgressThemeData({
    this.strokeWidth,
    this.color,
    this.backgroundColor,
    this.linearBorderRadius,
    this.circleRadius,
    this.showLabel,
    this.labelWidgetWidth,
    this.labelWidgetAlignment,
    this.progressLabelPosition,
    this.animationDuration,
    this.indeterminateAnimationDuration,
    this.indeterminateLinearSegmentFraction,
    this.indeterminateCircularValue,
    this.fallbackLinearWidth,
  }) : assert(fallbackLinearWidth == null || fallbackLinearWidth > 0),
       assert(
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
    bool? showLabel,
    double? labelWidgetWidth,
    Alignment? labelWidgetAlignment,
    TProgressLabelPosition? progressLabelPosition,
    Duration? animationDuration,
    Duration? indeterminateAnimationDuration,
    double? indeterminateLinearSegmentFraction,
    double? indeterminateCircularValue,
    double? fallbackLinearWidth,
  }) {
    return TProgressThemeData(
      strokeWidth: strokeWidth ?? this.strokeWidth,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      linearBorderRadius: linearBorderRadius ?? this.linearBorderRadius,
      circleRadius: circleRadius ?? this.circleRadius,
      showLabel: showLabel ?? this.showLabel,
      labelWidgetWidth: labelWidgetWidth ?? this.labelWidgetWidth,
      labelWidgetAlignment: labelWidgetAlignment ?? this.labelWidgetAlignment,
      progressLabelPosition:
          progressLabelPosition ?? this.progressLabelPosition,
      animationDuration: animationDuration ?? this.animationDuration,
      indeterminateAnimationDuration:
          indeterminateAnimationDuration ?? this.indeterminateAnimationDuration,
      indeterminateLinearSegmentFraction:
          indeterminateLinearSegmentFraction ??
          this.indeterminateLinearSegmentFraction,
      indeterminateCircularValue:
          indeterminateCircularValue ?? this.indeterminateCircularValue,
      fallbackLinearWidth: fallbackLinearWidth ?? this.fallbackLinearWidth,
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
      showLabel: t < 0.5 ? showLabel : other.showLabel,
      labelWidgetWidth: lerpDouble(labelWidgetWidth, other.labelWidgetWidth, t),
      labelWidgetAlignment: t < 0.5
          ? labelWidgetAlignment
          : other.labelWidgetAlignment,
      progressLabelPosition: t < 0.5
          ? progressLabelPosition
          : other.progressLabelPosition,
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
      fallbackLinearWidth: lerpDouble(
        fallbackLinearWidth,
        other.fallbackLinearWidth,
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

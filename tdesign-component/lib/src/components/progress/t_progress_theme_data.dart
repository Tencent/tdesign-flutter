import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// 进度条组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认视觉值。
/// 除进度值、状态与线性渐变等实例语义外，具体绘制值优先读取组件 Theme。
class TProgressThemeData extends ThemeExtension<TProgressThemeData> {
  /// 进度条粗细
  final double? strokeWidth;

  /// 进度条颜色
  final Color? color;

  /// 进度条背景色
  final Color? backgroundColor;

  /// 环形进度条内圆背景色。默认浅色读取容器色、暗色透明；
  /// 宿主如需定义暗色内圆，可在组件 Theme 中显式配置。
  final Color? circleInnerBgColor;

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
    this.circleInnerBgColor,
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

  _ProgressColorLerp? get _circleInnerBgLerp => null;

  @internal
  Color resolveCircleInnerBgColor(Color fallback) =>
      _circleInnerBgLerp?.resolve(fallback) ?? circleInnerBgColor ?? fallback;

  @override
  TProgressThemeData copyWith({
    double? strokeWidth,
    Color? color,
    Color? backgroundColor,
    Color? circleInnerBgColor,
    BorderRadiusGeometry? linearBorderRadius,
    double? circleRadius,
    Duration? animationDuration,
    Duration? indeterminateAnimationDuration,
    double? indeterminateLinearSegmentFraction,
    double? indeterminateCircularValue,
  }) {
    return _InterpolatedProgressThemeData(
      strokeWidth: strokeWidth ?? this.strokeWidth,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      circleInnerBgColor: circleInnerBgColor ?? this.circleInnerBgColor,
      circleInnerBgTransition: circleInnerBgColor == null
          ? _circleInnerBgLerp
          : null,
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
    return _InterpolatedProgressThemeData(
      strokeWidth: lerpDouble(strokeWidth, other.strokeWidth, t),
      color: Color.lerp(color, other.color, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      circleInnerBgColor:
          circleInnerBgColor == null || other.circleInnerBgColor == null
          ? null
          : Color.lerp(circleInnerBgColor, other.circleInnerBgColor, t),
      circleInnerBgTransition: _ProgressColorLerp.whenNeeded(
        circleInnerBgColor,
        _circleInnerBgLerp,
        other.circleInnerBgColor,
        other._circleInnerBgLerp,
        t,
      ),
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

class _InterpolatedProgressThemeData extends TProgressThemeData {
  const _InterpolatedProgressThemeData({
    super.strokeWidth,
    super.color,
    super.backgroundColor,
    super.circleInnerBgColor,
    super.linearBorderRadius,
    super.circleRadius,
    super.animationDuration,
    super.indeterminateAnimationDuration,
    super.indeterminateLinearSegmentFraction,
    super.indeterminateCircularValue,
    _ProgressColorLerp? circleInnerBgTransition,
  }) : _circleInnerBgTransition = circleInnerBgTransition;

  final _ProgressColorLerp? _circleInnerBgTransition;

  @override
  _ProgressColorLerp? get _circleInnerBgLerp => _circleInnerBgTransition;
}

class _ProgressColorLerp {
  const _ProgressColorLerp(
    this.begin,
    this.beginTransition,
    this.end,
    this.endTransition,
    this.t,
  );

  static _ProgressColorLerp? whenNeeded(
    Color? begin,
    _ProgressColorLerp? beginTransition,
    Color? end,
    _ProgressColorLerp? endTransition,
    double t,
  ) =>
      beginTransition == null &&
          endTransition == null &&
          ((begin == null && end == null) || (begin != null && end != null))
      ? null
      : _ProgressColorLerp(begin, beginTransition, end, endTransition, t);

  final Color? begin;
  final _ProgressColorLerp? beginTransition;
  final Color? end;
  final _ProgressColorLerp? endTransition;
  final double t;

  Color resolve(Color fallback) => Color.lerp(
    beginTransition?.resolve(fallback) ?? begin ?? fallback,
    endTransition?.resolve(fallback) ?? end ?? fallback,
    t,
  )!;
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

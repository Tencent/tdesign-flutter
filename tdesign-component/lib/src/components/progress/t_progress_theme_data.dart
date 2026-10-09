import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 't_progress_defaults.dart';

/// 进度条组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认视觉值。
/// 除进度值、状态与线性渐变等实例语义外，具体绘制值优先读取组件 Theme。
///
/// {@category ComponentTheme}
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

  /// 环形进度条的正方形边长；未设置时由环形规格决定。
  /// 未配置时 circular 为 112、microCircular / microButton 为 24 逻辑像素。
  final double? circleSize;

  /// 动画持续时间
  /// 未配置时为 300 毫秒。
  final Duration? animationDuration;

  /// 不确定进度完成一次循环的时长。
  /// 未配置时为 1200 毫秒；必须大于 Duration.zero，否则抛出 FlutterError。
  final Duration? indeterminateAnimationDuration;

  /// 不确定线性进度段占轨道宽度的比例。
  /// 未配置时为 0.32；必须大于 0 且不大于 1。
  final double? indeterminateLinearSegmentFraction;

  /// 不确定环形进度弧占整圈的比例。
  /// 未配置时为 0.25；必须大于 0 且小于 1。
  final double? indeterminateCircularValue;

  const TProgressThemeData({
    this.strokeWidth,
    this.color,
    this.backgroundColor,
    this.circleInnerBgColor,
    this.linearBorderRadius,
    this.circleSize,
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
  _ProgressColorLerp? get _colorLerp => null;
  _ProgressColorLerp? get _backgroundColorLerp => null;
  _ProgressDoubleLerp? get _strokeWidthLerp => null;
  _ProgressDoubleLerp? get _circleSizeLerp => null;
  _ProgressBorderRadiusLerp? get _linearBorderRadiusLerp => null;

  @internal
  double resolveStrokeWidth(double fallback) =>
      _strokeWidthLerp?.resolve(fallback) ?? strokeWidth ?? fallback;

  @internal
  double resolveCircleSize(double fallback) =>
      _circleSizeLerp?.resolve(fallback) ?? circleSize ?? fallback;

  @internal
  Color resolveColor(Color fallback) =>
      _colorLerp?.resolve(fallback) ?? color ?? fallback;

  @internal
  Color resolveBackgroundColor(Color fallback) =>
      _backgroundColorLerp?.resolve(fallback) ?? backgroundColor ?? fallback;

  @internal
  BorderRadiusGeometry resolveLinearBorderRadius(
    BorderRadiusGeometry fallback,
  ) =>
      _linearBorderRadiusLerp?.resolve(fallback) ??
      linearBorderRadius ??
      fallback;

  @internal
  Color resolveCircleInnerBgColor(Color fallback) =>
      _circleInnerBgLerp?.resolve(fallback) ?? circleInnerBgColor ?? fallback;

  /// 复制主题配置。
  ///
  /// ## 返回值
  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TProgressThemeData copyWith({
    double? strokeWidth,
    Color? color,
    Color? backgroundColor,
    Color? circleInnerBgColor,
    BorderRadiusGeometry? linearBorderRadius,
    double? circleSize,
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
      strokeWidthTransition: strokeWidth == null ? _strokeWidthLerp : null,
      circleSizeTransition: circleSize == null ? _circleSizeLerp : null,
      colorTransition: color == null ? _colorLerp : null,
      backgroundColorTransition: backgroundColor == null
          ? _backgroundColorLerp
          : null,
      linearBorderRadiusTransition: linearBorderRadius == null
          ? _linearBorderRadiusLerp
          : null,
      linearBorderRadius: linearBorderRadius ?? this.linearBorderRadius,
      circleSize: circleSize ?? this.circleSize,
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

  /// 生成主题过渡配置。
  ///
  /// ## 返回值
  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TProgressThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TProgressThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TProgressThemeData) {
      return this;
    }
    return _InterpolatedProgressThemeData(
      strokeWidth: _lerpExplicitDouble(strokeWidth, other.strokeWidth, t),
      strokeWidthTransition: _ProgressDoubleLerp.whenNeeded(
        strokeWidth,
        _strokeWidthLerp,
        other.strokeWidth,
        other._strokeWidthLerp,
        t,
      ),
      color: _lerpExplicitColor(color, other.color, t),
      colorTransition: _ProgressColorLerp.whenNeeded(
        color,
        _colorLerp,
        other.color,
        other._colorLerp,
        t,
      ),
      backgroundColor: _lerpExplicitColor(
        backgroundColor,
        other.backgroundColor,
        t,
      ),
      backgroundColorTransition: _ProgressColorLerp.whenNeeded(
        backgroundColor,
        _backgroundColorLerp,
        other.backgroundColor,
        other._backgroundColorLerp,
        t,
      ),
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
      linearBorderRadius:
          linearBorderRadius == null || other.linearBorderRadius == null
          ? null
          : BorderRadiusGeometry.lerp(
              linearBorderRadius,
              other.linearBorderRadius,
              t,
            ),
      linearBorderRadiusTransition: _ProgressBorderRadiusLerp.whenNeeded(
        linearBorderRadius,
        _linearBorderRadiusLerp,
        other.linearBorderRadius,
        other._linearBorderRadiusLerp,
        t,
      ),
      circleSize: _lerpExplicitDouble(circleSize, other.circleSize, t),
      circleSizeTransition: _ProgressDoubleLerp.whenNeeded(
        circleSize,
        _circleSizeLerp,
        other.circleSize,
        other._circleSizeLerp,
        t,
      ),
      animationDuration: _lerpDurationWithDefault(
        animationDuration,
        other.animationDuration,
        t,
        TProgressDefaults.animationDuration,
      ),
      indeterminateAnimationDuration: _lerpDurationWithDefault(
        indeterminateAnimationDuration,
        other.indeterminateAnimationDuration,
        t,
        TProgressDefaults.indeterminateAnimationDuration,
      ),
      indeterminateLinearSegmentFraction: _lerpWithDefault(
        indeterminateLinearSegmentFraction,
        other.indeterminateLinearSegmentFraction,
        t,
        TProgressDefaults.indeterminateLinearSegmentFraction,
      ),
      indeterminateCircularValue: _lerpWithDefault(
        indeterminateCircularValue,
        other.indeterminateCircularValue,
        t,
        TProgressDefaults.indeterminateCircularValue,
      ),
    );
  }
}

double? _lerpWithDefault(
  double? begin,
  double? end,
  double t,
  double fallback,
) {
  if (begin == null && end == null) {
    return null;
  }
  return lerpDouble(begin ?? fallback, end ?? fallback, t);
}

double? _lerpExplicitDouble(double? begin, double? end, double t) =>
    begin == null || end == null ? null : lerpDouble(begin, end, t);

Color? _lerpExplicitColor(Color? begin, Color? end, double t) =>
    begin == null || end == null ? null : Color.lerp(begin, end, t);

class _InterpolatedProgressThemeData extends TProgressThemeData {
  const _InterpolatedProgressThemeData({
    super.strokeWidth,
    super.color,
    super.backgroundColor,
    super.circleInnerBgColor,
    super.linearBorderRadius,
    super.circleSize,
    super.animationDuration,
    super.indeterminateAnimationDuration,
    super.indeterminateLinearSegmentFraction,
    super.indeterminateCircularValue,
    _ProgressColorLerp? circleInnerBgTransition,
    _ProgressColorLerp? colorTransition,
    _ProgressColorLerp? backgroundColorTransition,
    _ProgressDoubleLerp? strokeWidthTransition,
    _ProgressDoubleLerp? circleSizeTransition,
    _ProgressBorderRadiusLerp? linearBorderRadiusTransition,
  }) : _circleInnerBgTransition = circleInnerBgTransition,
       _colorTransition = colorTransition,
       _backgroundColorTransition = backgroundColorTransition,
       _strokeWidthTransition = strokeWidthTransition,
       _circleSizeTransition = circleSizeTransition,
       _linearBorderRadiusTransition = linearBorderRadiusTransition;

  final _ProgressColorLerp? _circleInnerBgTransition;
  final _ProgressColorLerp? _colorTransition;
  final _ProgressColorLerp? _backgroundColorTransition;
  final _ProgressDoubleLerp? _strokeWidthTransition;
  final _ProgressDoubleLerp? _circleSizeTransition;
  final _ProgressBorderRadiusLerp? _linearBorderRadiusTransition;

  @override
  _ProgressColorLerp? get _circleInnerBgLerp => _circleInnerBgTransition;
  @override
  _ProgressColorLerp? get _colorLerp => _colorTransition;
  @override
  _ProgressColorLerp? get _backgroundColorLerp => _backgroundColorTransition;
  @override
  _ProgressDoubleLerp? get _strokeWidthLerp => _strokeWidthTransition;
  @override
  _ProgressDoubleLerp? get _circleSizeLerp => _circleSizeTransition;
  @override
  _ProgressBorderRadiusLerp? get _linearBorderRadiusLerp =>
      _linearBorderRadiusTransition;
}

class _ProgressBorderRadiusLerp {
  const _ProgressBorderRadiusLerp(
    this.begin,
    this.beginTransition,
    this.end,
    this.endTransition,
    this.t,
  );

  static _ProgressBorderRadiusLerp? whenNeeded(
    BorderRadiusGeometry? begin,
    _ProgressBorderRadiusLerp? beginTransition,
    BorderRadiusGeometry? end,
    _ProgressBorderRadiusLerp? endTransition,
    double t,
  ) =>
      beginTransition == null &&
          endTransition == null &&
          ((begin == null && end == null) || (begin != null && end != null))
      ? null
      : _ProgressBorderRadiusLerp(
          begin,
          beginTransition,
          end,
          endTransition,
          t,
        );

  final BorderRadiusGeometry? begin;
  final _ProgressBorderRadiusLerp? beginTransition;
  final BorderRadiusGeometry? end;
  final _ProgressBorderRadiusLerp? endTransition;
  final double t;

  BorderRadiusGeometry resolve(BorderRadiusGeometry fallback) =>
      BorderRadiusGeometry.lerp(
        beginTransition?.resolve(fallback) ?? begin ?? fallback,
        endTransition?.resolve(fallback) ?? end ?? fallback,
        t,
      )!;
}

class _ProgressDoubleLerp {
  const _ProgressDoubleLerp(
    this.begin,
    this.beginTransition,
    this.end,
    this.endTransition,
    this.t,
  );

  static _ProgressDoubleLerp? whenNeeded(
    double? begin,
    _ProgressDoubleLerp? beginTransition,
    double? end,
    _ProgressDoubleLerp? endTransition,
    double t,
  ) =>
      beginTransition == null &&
          endTransition == null &&
          ((begin == null && end == null) || (begin != null && end != null))
      ? null
      : _ProgressDoubleLerp(begin, beginTransition, end, endTransition, t);

  final double? begin;
  final _ProgressDoubleLerp? beginTransition;
  final double? end;
  final _ProgressDoubleLerp? endTransition;
  final double t;

  double resolve(double fallback) => lerpDouble(
    beginTransition?.resolve(fallback) ?? begin ?? fallback,
    endTransition?.resolve(fallback) ?? end ?? fallback,
    t,
  )!;
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

Duration? _lerpDurationWithDefault(
  Duration? a,
  Duration? b,
  double t,
  Duration fallback,
) {
  if (a == null && b == null) {
    return null;
  }
  final begin = a ?? fallback;
  final end = b ?? fallback;
  return Duration(
    milliseconds:
        (begin.inMilliseconds + (end.inMilliseconds - begin.inMilliseconds) * t)
            .round(),
  );
}

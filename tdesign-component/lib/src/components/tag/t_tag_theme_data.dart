import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../theme/basic.dart' show Font;

/// 标签组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认样式。
/// 具体视觉值由组件 Theme 控制，未指定时回退全局 Token。
class TTagThemeData extends ThemeExtension<TTagThemeData> {
  /// 所有启用 Tag 的统一文字颜色；优先于各配色预设的文字色。
  final Color? textColor;

  /// 所有启用 Tag 的统一背景色；优先于各配色预设的填充色。
  final Color? backgroundColor;

  /// danger 预设的基础色；未设置时回退显式 Material error 或全局 errorColor。
  final Color? dangerColor;

  /// success 预设的基础色；未设置时回退全局 successColor。
  final Color? successColor;

  /// success 预设的浅色填充；未设置时回退全局 successColor1。
  final Color? successLightColor;

  /// 字体尺寸和行高；未设置时随标签尺寸使用对应的全局字体 Token。
  final Font? font;

  /// 自定义间距
  final EdgeInsets? padding;

  /// 方形标签圆角，单位为逻辑像素；未设置时所有尺寸均读取全局
  /// `radiusSmall`（当前默认 3dp）。
  final double? squareBorderRadius;

  /// 文字溢出处理
  final TextOverflow? overflow;

  /// 文字最大行数。
  ///
  /// 未设置时组件默认按紧凑标签语义使用单行。
  final int? maxLines;

  /// 标签固定宽度
  final double? fixedWidth;

  const TTagThemeData({
    this.textColor,
    this.backgroundColor,
    this.dangerColor,
    this.successColor,
    this.successLightColor,
    this.font,
    this.padding,
    this.squareBorderRadius,
    this.overflow,
    this.maxLines,
    this.fixedWidth,
  }) : assert(squareBorderRadius == null || squareBorderRadius >= 0);

  _TagColorLerp? get _dangerLerp => null;
  _TagColorLerp? get _successLerp => null;
  _TagColorLerp? get _successLightLerp => null;
  _TagDoubleLerp? get _squareBorderRadiusLerp => null;

  @internal
  Color resolveDangerColor(Color fallback) =>
      _dangerLerp?.resolve(fallback) ?? dangerColor ?? fallback;

  @internal
  Color resolveSuccessColor(Color fallback) =>
      _successLerp?.resolve(fallback) ?? successColor ?? fallback;

  @internal
  Color resolveSuccessLightColor(Color fallback) =>
      _successLightLerp?.resolve(fallback) ?? successLightColor ?? fallback;

  @internal
  double resolveSquareBorderRadius(double fallback) =>
      _squareBorderRadiusLerp?.resolve(fallback) ??
      squareBorderRadius ??
      fallback;

  @override
  TTagThemeData copyWith({
    Color? textColor,
    Color? backgroundColor,
    Color? dangerColor,
    Color? successColor,
    Color? successLightColor,
    Font? font,
    EdgeInsets? padding,
    double? squareBorderRadius,
    TextOverflow? overflow,
    int? maxLines,
    double? fixedWidth,
  }) {
    return _InterpolatedTagThemeData(
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      dangerColor: dangerColor ?? this.dangerColor,
      successColor: successColor ?? this.successColor,
      successLightColor: successLightColor ?? this.successLightColor,
      font: font ?? this.font,
      padding: padding ?? this.padding,
      squareBorderRadius: squareBorderRadius ?? this.squareBorderRadius,
      overflow: overflow ?? this.overflow,
      maxLines: maxLines ?? this.maxLines,
      fixedWidth: fixedWidth ?? this.fixedWidth,
      dangerTransition: dangerColor == null ? _dangerLerp : null,
      successTransition: successColor == null ? _successLerp : null,
      successLightTransition: successLightColor == null
          ? _successLightLerp
          : null,
      squareBorderRadiusTransition: squareBorderRadius == null
          ? _squareBorderRadiusLerp
          : null,
    );
  }

  @override
  TTagThemeData lerp(ThemeExtension<TTagThemeData>? other, double t) {
    if (other is! TTagThemeData) {
      return this;
    }
    return _InterpolatedTagThemeData(
      textColor: Color.lerp(textColor, other.textColor, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      dangerColor: _lerpExplicitColor(dangerColor, other.dangerColor, t),
      dangerTransition: _TagColorLerp.whenNeeded(
        dangerColor,
        _dangerLerp,
        other.dangerColor,
        other._dangerLerp,
        t,
      ),
      successColor: _lerpExplicitColor(successColor, other.successColor, t),
      successTransition: _TagColorLerp.whenNeeded(
        successColor,
        _successLerp,
        other.successColor,
        other._successLerp,
        t,
      ),
      successLightColor: _lerpExplicitColor(
        successLightColor,
        other.successLightColor,
        t,
      ),
      successLightTransition: _TagColorLerp.whenNeeded(
        successLightColor,
        _successLightLerp,
        other.successLightColor,
        other._successLightLerp,
        t,
      ),
      font: t < 0.5 ? font : other.font,
      padding:
          EdgeInsetsGeometry.lerp(padding, other.padding, t) as EdgeInsets?,
      squareBorderRadius: _lerpExplicitDouble(
        squareBorderRadius,
        other.squareBorderRadius,
        t,
      ),
      squareBorderRadiusTransition: _TagDoubleLerp.whenNeeded(
        squareBorderRadius,
        _squareBorderRadiusLerp,
        other.squareBorderRadius,
        other._squareBorderRadiusLerp,
        t,
      ),
      overflow: t < 0.5 ? overflow : other.overflow,
      maxLines: t < 0.5 ? maxLines : other.maxLines,
      fixedWidth: lerpDouble(fixedWidth, other.fixedWidth, t),
    );
  }
}

class _InterpolatedTagThemeData extends TTagThemeData {
  const _InterpolatedTagThemeData({
    super.textColor,
    super.backgroundColor,
    super.dangerColor,
    super.successColor,
    super.successLightColor,
    super.font,
    super.padding,
    super.squareBorderRadius,
    super.overflow,
    super.maxLines,
    super.fixedWidth,
    _TagColorLerp? dangerTransition,
    _TagColorLerp? successTransition,
    _TagColorLerp? successLightTransition,
    _TagDoubleLerp? squareBorderRadiusTransition,
  }) : _dangerTransition = dangerTransition,
       _successTransition = successTransition,
       _successLightTransition = successLightTransition,
       _squareBorderRadiusTransition = squareBorderRadiusTransition;

  final _TagColorLerp? _dangerTransition;
  final _TagColorLerp? _successTransition;
  final _TagColorLerp? _successLightTransition;
  final _TagDoubleLerp? _squareBorderRadiusTransition;

  @override
  _TagColorLerp? get _dangerLerp => _dangerTransition;
  @override
  _TagColorLerp? get _successLerp => _successTransition;
  @override
  _TagColorLerp? get _successLightLerp => _successLightTransition;
  @override
  _TagDoubleLerp? get _squareBorderRadiusLerp => _squareBorderRadiusTransition;
}

Color? _lerpExplicitColor(Color? begin, Color? end, double t) =>
    begin == null || end == null ? null : Color.lerp(begin, end, t);

double? _lerpExplicitDouble(double? begin, double? end, double t) =>
    begin == null || end == null ? null : lerpDouble(begin, end, t);

class _TagColorLerp {
  const _TagColorLerp(
    this.begin,
    this.beginTransition,
    this.end,
    this.endTransition,
    this.t,
  );

  static _TagColorLerp? whenNeeded(
    Color? begin,
    _TagColorLerp? beginTransition,
    Color? end,
    _TagColorLerp? endTransition,
    double t,
  ) =>
      beginTransition == null &&
          endTransition == null &&
          ((begin == null && end == null) || (begin != null && end != null))
      ? null
      : _TagColorLerp(begin, beginTransition, end, endTransition, t);

  final Color? begin;
  final _TagColorLerp? beginTransition;
  final Color? end;
  final _TagColorLerp? endTransition;
  final double t;

  Color resolve(Color fallback) => Color.lerp(
    beginTransition?.resolve(fallback) ?? begin ?? fallback,
    endTransition?.resolve(fallback) ?? end ?? fallback,
    t,
  )!;
}

class _TagDoubleLerp {
  const _TagDoubleLerp(
    this.begin,
    this.beginTransition,
    this.end,
    this.endTransition,
    this.t,
  );

  static _TagDoubleLerp? whenNeeded(
    double? begin,
    _TagDoubleLerp? beginTransition,
    double? end,
    _TagDoubleLerp? endTransition,
    double t,
  ) =>
      beginTransition == null &&
          endTransition == null &&
          ((begin == null && end == null) || (begin != null && end != null))
      ? null
      : _TagDoubleLerp(begin, beginTransition, end, endTransition, t);

  final double? begin;
  final _TagDoubleLerp? beginTransition;
  final double? end;
  final _TagDoubleLerp? endTransition;
  final double t;

  double resolve(double fallback) => lerpDouble(
    beginTransition?.resolve(fallback) ?? begin ?? fallback,
    endTransition?.resolve(fallback) ?? end ?? fallback,
    t,
  )!;
}

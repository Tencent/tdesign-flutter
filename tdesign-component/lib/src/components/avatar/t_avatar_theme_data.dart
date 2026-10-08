// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 't_avatar_defaults.dart';
import 't_avatar_types.dart';

/// 头像组件级 ThemeExtension。
///
/// 仅保存视觉默认值，不保存头像内容、回调或头像组成员。
class TAvatarThemeData extends ThemeExtension<TAvatarThemeData> {
  const TAvatarThemeData({
    this.dimension,
    this.iconSize,
    this.circleBorderRadius,
    this.squareBorderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.groupSpacing,
    this.groupBorderWidth,
    this.groupBorderColor,
    this.groupShadow,
  }) : assert(
         dimension == null || (dimension > 0 && dimension != double.infinity),
       ),
       assert(
         iconSize == null || (iconSize >= 0 && iconSize != double.infinity),
       ),
       assert(
         circleBorderRadius == null ||
             (circleBorderRadius >= 0 && circleBorderRadius != double.infinity),
       ),
       assert(
         squareBorderRadius == null ||
             (squareBorderRadius >= 0 && squareBorderRadius != double.infinity),
       ),
       assert(
         groupSpacing == null ||
             (groupSpacing >= 0 && groupSpacing != double.infinity),
       ),
       assert(
         groupBorderWidth == null ||
             (groupBorderWidth >= 0 && groupBorderWidth != double.infinity),
       ),
       assert(
         dimension == null || groupSpacing == null || groupSpacing <= dimension,
       ),
       assert(
         dimension == null ||
             groupBorderWidth == null ||
             groupBorderWidth * 2 <= dimension,
       );

  /// 自定义头像边长；未设置时小、中、大尺寸分别为 40、48、64 逻辑像素。
  final double? dimension;

  /// 默认图标大小；未设置时小、中、大尺寸分别为 20、24、32 逻辑像素。
  final double? iconSize;

  /// 方形头像圆角；未设置时回退全局 `radiusDefault`（默认 6 逻辑像素）。
  final double? squareBorderRadius;

  /// 圆形头像圆角；未设置时回退全局 `radiusCircle`（逻辑像素）。
  final double? circleBorderRadius;

  /// 默认背景色；未设置时回退全局 `brandColorLightActive`。
  final Color? backgroundColor;

  /// 默认图标与继承文字的前景色；未设置时回退全局品牌色。
  final Color? foregroundColor;

  /// 头像组重叠宽度；未设置时为 8 逻辑像素，实例 spacing 优先。
  final double? groupSpacing;

  /// 头像组成员描边宽度。
  /// 未设置时按成员尺寸使用小/中/大 1/2/3 逻辑像素。
  final double? groupBorderWidth;

  /// 头像组成员描边颜色；未设置时使用 `bgColorContainer` Token。
  final Color? groupBorderColor;

  /// 头像组成员阴影；未设置时使用 1px 水平偏移、2px `blurRadius` 和 15% 黑色。
  final BoxShadow? groupShadow;

  // A single nullable double cannot encode an interpolation from a fallback
  // that depends on the avatar size or the current global token. Defer those
  // cases until the component knows the effective fallback.
  _AvatarDoubleLerp? get _dimensionLerp => null;
  _AvatarDoubleLerp? get _iconSizeLerp => null;
  _AvatarDoubleLerp? get _circleBorderRadiusLerp => null;
  _AvatarDoubleLerp? get _squareBorderRadiusLerp => null;
  _AvatarDoubleLerp? get _groupBorderWidthLerp => null;
  _AvatarDoubleLerp? get _groupSpacingLerp => null;

  @internal
  double resolveDimension(TAvatarSize size) =>
      _dimensionLerp?.resolve(TAvatarDefaults.dimensionFor(size)) ??
      dimension ??
      TAvatarDefaults.dimensionFor(size);

  @internal
  double resolveIconSize(TAvatarSize size) =>
      _iconSizeLerp?.resolve(TAvatarDefaults.iconSizeFor(size)) ??
      iconSize ??
      TAvatarDefaults.iconSizeFor(size);

  @internal
  double resolveCircleBorderRadius(double tokenRadius) =>
      _circleBorderRadiusLerp?.resolve(tokenRadius) ??
      circleBorderRadius ??
      tokenRadius;

  @internal
  double resolveSquareBorderRadius(double tokenRadius) =>
      _squareBorderRadiusLerp?.resolve(tokenRadius) ??
      squareBorderRadius ??
      tokenRadius;

  @internal
  double resolveGroupBorderWidth(TAvatarSize size) =>
      _groupBorderWidthLerp?.resolve(
        TAvatarDefaults.groupBorderWidthFor(size),
      ) ??
      groupBorderWidth ??
      TAvatarDefaults.groupBorderWidthFor(size);

  @internal
  double resolveGroupSpacing(double dimension) =>
      (_groupSpacingLerp?.resolve(TAvatarDefaults.groupSpacing) ??
              groupSpacing ??
              TAvatarDefaults.groupSpacing)
          .clamp(0.0, dimension)
          .toDouble();

  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TAvatarThemeData copyWith({
    double? dimension,
    double? iconSize,
    double? circleBorderRadius,
    double? squareBorderRadius,
    Color? backgroundColor,
    Color? foregroundColor,
    double? groupSpacing,
    double? groupBorderWidth,
    Color? groupBorderColor,
    BoxShadow? groupShadow,
  }) {
    return _InterpolatedAvatarThemeData(
      dimension: dimension ?? this.dimension,
      iconSize: iconSize ?? this.iconSize,
      circleBorderRadius: circleBorderRadius ?? this.circleBorderRadius,
      squareBorderRadius: squareBorderRadius ?? this.squareBorderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      groupSpacing: groupSpacing ?? this.groupSpacing,
      groupBorderWidth: groupBorderWidth ?? this.groupBorderWidth,
      groupBorderColor: groupBorderColor ?? this.groupBorderColor,
      groupShadow: groupShadow ?? this.groupShadow,
      dimensionTransition: dimension == null ? _dimensionLerp : null,
      iconSizeTransition: iconSize == null ? _iconSizeLerp : null,
      circleBorderRadiusTransition: circleBorderRadius == null
          ? _circleBorderRadiusLerp
          : null,
      squareBorderRadiusTransition: squareBorderRadius == null
          ? _squareBorderRadiusLerp
          : null,
      groupBorderWidthTransition: groupBorderWidth == null
          ? _groupBorderWidthLerp
          : null,
      groupSpacingTransition: groupSpacing == null ? _groupSpacingLerp : null,
    );
  }

  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TAvatarThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    TAvatarThemeData? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other == null) {
      return this;
    }
    return _InterpolatedAvatarThemeData(
      dimension: _lerpExplicitDouble(dimension, other.dimension, t),
      dimensionTransition: _AvatarDoubleLerp.whenNeeded(
        dimension,
        _dimensionLerp,
        other.dimension,
        other._dimensionLerp,
        t,
      ),
      iconSize: _lerpExplicitDouble(iconSize, other.iconSize, t),
      iconSizeTransition: _AvatarDoubleLerp.whenNeeded(
        iconSize,
        _iconSizeLerp,
        other.iconSize,
        other._iconSizeLerp,
        t,
      ),
      circleBorderRadius: _lerpExplicitDouble(
        circleBorderRadius,
        other.circleBorderRadius,
        t,
      ),
      circleBorderRadiusTransition: _AvatarDoubleLerp.whenNeeded(
        circleBorderRadius,
        _circleBorderRadiusLerp,
        other.circleBorderRadius,
        other._circleBorderRadiusLerp,
        t,
      ),
      squareBorderRadius: _lerpExplicitDouble(
        squareBorderRadius,
        other.squareBorderRadius,
        t,
      ),
      squareBorderRadiusTransition: _AvatarDoubleLerp.whenNeeded(
        squareBorderRadius,
        _squareBorderRadiusLerp,
        other.squareBorderRadius,
        other._squareBorderRadiusLerp,
        t,
      ),
      backgroundColor: _lerpTokenColor(
        backgroundColor,
        other.backgroundColor,
        t,
      ),
      foregroundColor: _lerpTokenColor(
        foregroundColor,
        other.foregroundColor,
        t,
      ),
      groupSpacing: _lerpExplicitDouble(groupSpacing, other.groupSpacing, t),
      groupSpacingTransition: _AvatarDoubleLerp.whenNeeded(
        groupSpacing,
        _groupSpacingLerp,
        other.groupSpacing,
        other._groupSpacingLerp,
        t,
      ),
      groupBorderWidth: _lerpExplicitDouble(
        groupBorderWidth,
        other.groupBorderWidth,
        t,
      ),
      groupBorderWidthTransition: _AvatarDoubleLerp.whenNeeded(
        groupBorderWidth,
        _groupBorderWidthLerp,
        other.groupBorderWidth,
        other._groupBorderWidthLerp,
        t,
      ),
      groupBorderColor: _lerpTokenColor(
        groupBorderColor,
        other.groupBorderColor,
        t,
      ),
      groupShadow: groupShadow == null && other.groupShadow == null
          ? null
          : BoxShadow.lerp(
              groupShadow ?? TAvatarDefaults.groupShadow,
              other.groupShadow ?? TAvatarDefaults.groupShadow,
              t,
            ),
    );
  }
}

class _InterpolatedAvatarThemeData extends TAvatarThemeData {
  const _InterpolatedAvatarThemeData({
    super.dimension,
    super.iconSize,
    super.circleBorderRadius,
    super.squareBorderRadius,
    super.backgroundColor,
    super.foregroundColor,
    super.groupSpacing,
    super.groupBorderWidth,
    super.groupBorderColor,
    super.groupShadow,
    _AvatarDoubleLerp? dimensionTransition,
    _AvatarDoubleLerp? iconSizeTransition,
    _AvatarDoubleLerp? circleBorderRadiusTransition,
    _AvatarDoubleLerp? squareBorderRadiusTransition,
    _AvatarDoubleLerp? groupBorderWidthTransition,
    _AvatarDoubleLerp? groupSpacingTransition,
  }) : _dimensionTransition = dimensionTransition,
       _iconSizeTransition = iconSizeTransition,
       _circleBorderRadiusTransition = circleBorderRadiusTransition,
       _squareBorderRadiusTransition = squareBorderRadiusTransition,
       _groupBorderWidthTransition = groupBorderWidthTransition,
       _groupSpacingTransition = groupSpacingTransition;

  final _AvatarDoubleLerp? _dimensionTransition;
  final _AvatarDoubleLerp? _iconSizeTransition;
  final _AvatarDoubleLerp? _circleBorderRadiusTransition;
  final _AvatarDoubleLerp? _squareBorderRadiusTransition;
  final _AvatarDoubleLerp? _groupBorderWidthTransition;
  final _AvatarDoubleLerp? _groupSpacingTransition;

  @override
  _AvatarDoubleLerp? get _dimensionLerp => _dimensionTransition;
  @override
  _AvatarDoubleLerp? get _iconSizeLerp => _iconSizeTransition;
  @override
  _AvatarDoubleLerp? get _circleBorderRadiusLerp =>
      _circleBorderRadiusTransition;
  @override
  _AvatarDoubleLerp? get _squareBorderRadiusLerp =>
      _squareBorderRadiusTransition;
  @override
  _AvatarDoubleLerp? get _groupBorderWidthLerp => _groupBorderWidthTransition;
  @override
  _AvatarDoubleLerp? get _groupSpacingLerp => _groupSpacingTransition;
}

double? _lerpExplicitDouble(double? begin, double? end, double t) =>
    begin == null || end == null ? null : lerpDouble(begin, end, t);

class _AvatarDoubleLerp {
  const _AvatarDoubleLerp(
    this.begin,
    this.beginTransition,
    this.end,
    this.endTransition,
    this.t,
  );

  static _AvatarDoubleLerp? whenNeeded(
    double? begin,
    _AvatarDoubleLerp? beginTransition,
    double? end,
    _AvatarDoubleLerp? endTransition,
    double t,
  ) {
    if (beginTransition == null &&
        endTransition == null &&
        (begin == null && end == null || begin != null && end != null)) {
      return null;
    }
    return _AvatarDoubleLerp(begin, beginTransition, end, endTransition, t);
  }

  final double? begin;
  final _AvatarDoubleLerp? beginTransition;
  final double? end;
  final _AvatarDoubleLerp? endTransition;
  final double t;

  double resolve(double fallback) => lerpDouble(
    beginTransition?.resolve(fallback) ?? begin ?? fallback,
    endTransition?.resolve(fallback) ?? end ?? fallback,
    t,
  )!;
}

Color? _lerpTokenColor(Color? begin, Color? end, double t) {
  if (begin == null || end == null) {
    return t < 0.5 ? begin : end;
  }
  return Color.lerp(begin, end, t);
}

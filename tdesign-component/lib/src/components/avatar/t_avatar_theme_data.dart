// ignore_for_file: deprecated_member_use_from_same_package

import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

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

  /// 自定义头像边长。
  final double? dimension;

  /// 默认图标大小。
  final double? iconSize;

  /// 方形头像圆角。
  final double? squareBorderRadius;

  /// 圆形头像圆角；未设置时回退全局 `radiusCircle`（逻辑像素）。
  final double? circleBorderRadius;

  /// 默认背景色。
  final Color? backgroundColor;

  /// 默认图标与继承文字的前景色；未设置时回退全局品牌色。
  final Color? foregroundColor;

  /// 头像组重叠宽度。
  final double? groupSpacing;

  /// 头像组成员描边宽度。
  final double? groupBorderWidth;

  /// 头像组成员描边颜色。
  final Color? groupBorderColor;

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
  }) {
    return TAvatarThemeData(
      dimension: dimension ?? this.dimension,
      iconSize: iconSize ?? this.iconSize,
      circleBorderRadius: circleBorderRadius ?? this.circleBorderRadius,
      squareBorderRadius: squareBorderRadius ?? this.squareBorderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      groupSpacing: groupSpacing ?? this.groupSpacing,
      groupBorderWidth: groupBorderWidth ?? this.groupBorderWidth,
      groupBorderColor: groupBorderColor ?? this.groupBorderColor,
    );
  }

  @override
  TAvatarThemeData lerp(TAvatarThemeData? other, double t) {
    if (other == null) {
      return this;
    }
    return TAvatarThemeData(
      dimension: _lerpNullableDouble(
        dimension,
        other.dimension,
        t,
        TAvatarDefaults.mediumDimension,
        TAvatarDefaults.mediumDimension,
      ),
      iconSize: _lerpNullableDouble(
        iconSize,
        other.iconSize,
        t,
        TAvatarDefaults.iconSizeFor(TAvatarSize.medium),
        TAvatarDefaults.iconSizeFor(TAvatarSize.medium),
      ),
      circleBorderRadius: _lerpNullableDouble(
        circleBorderRadius,
        other.circleBorderRadius,
        t,
        9999,
        9999,
      ),
      squareBorderRadius: _lerpNullableDouble(
        squareBorderRadius,
        other.squareBorderRadius,
        t,
        TAvatarDefaults.squareBorderRadius,
        TAvatarDefaults.squareBorderRadius,
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
      groupSpacing: _lerpNullableDouble(
        groupSpacing,
        other.groupSpacing,
        t,
        TAvatarDefaults.groupSpacing,
        TAvatarDefaults.groupSpacing,
      ),
      groupBorderWidth: _lerpNullableDouble(
        groupBorderWidth,
        other.groupBorderWidth,
        t,
        TAvatarDefaults.groupBorderWidth,
        TAvatarDefaults.groupBorderWidth,
      ),
      groupBorderColor: _lerpTokenColor(
        groupBorderColor,
        other.groupBorderColor,
        t,
      ),
    );
  }
}

double? _lerpNullableDouble(
  double? begin,
  double? end,
  double t,
  double defaultBegin,
  double defaultEnd,
) {
  if (begin == null && end == null) {
    return null;
  }
  return lerpDouble(begin ?? defaultBegin, end ?? defaultEnd, t);
}

Color? _lerpTokenColor(Color? begin, Color? end, double t) {
  if (begin == null || end == null) {
    return t < 0.5 ? begin : end;
  }
  return Color.lerp(begin, end, t);
}

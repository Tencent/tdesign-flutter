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
    this.size,
    this.shape,
    this.variant,
    this.dimension,
    this.iconSize,
    this.squareBorderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
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

  /// 默认头像尺寸档位。
  final TAvatarSize? size;

  /// 默认头像形状。
  final TAvatarShape? shape;

  /// 默认头像形状的旧配置。
  @Deprecated('Use shape instead. This property will be removed in 1.0.0.')
  final TAvatarVariant? variant;

  /// 自定义头像边长。
  final double? dimension;

  /// 默认图标大小。
  final double? iconSize;

  /// 方形头像圆角。
  final double? squareBorderRadius;

  /// 默认背景色。
  final Color? backgroundColor;

  /// 默认前景色。
  final Color? foregroundColor;

  /// 字符头像的默认文字样式。
  final TextStyle? textStyle;

  /// 头像组重叠宽度。
  final double? groupSpacing;

  /// 头像组成员描边宽度。
  final double? groupBorderWidth;

  /// 头像组成员描边颜色。
  final Color? groupBorderColor;

  @override
  TAvatarThemeData copyWith({
    TAvatarSize? size,
    TAvatarShape? shape,
    TAvatarVariant? variant,
    double? dimension,
    double? iconSize,
    double? squareBorderRadius,
    Color? backgroundColor,
    Color? foregroundColor,
    TextStyle? textStyle,
    double? groupSpacing,
    double? groupBorderWidth,
    Color? groupBorderColor,
  }) {
    return TAvatarThemeData(
      size: size ?? this.size,
      shape: shape ?? this.shape,
      variant: variant ?? this.variant,
      dimension: dimension ?? this.dimension,
      iconSize: iconSize ?? this.iconSize,
      squareBorderRadius: squareBorderRadius ?? this.squareBorderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      textStyle: textStyle ?? this.textStyle,
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
      size: t < 0.5 ? size : other.size,
      shape: t < 0.5 ? shape : other.shape,
      variant: t < 0.5 ? variant : other.variant,
      dimension: _lerpNullableDouble(
        dimension,
        other.dimension,
        t,
        TAvatarDefaults.dimensionFor(size ?? TAvatarSize.medium),
        TAvatarDefaults.dimensionFor(other.size ?? TAvatarSize.medium),
      ),
      iconSize: _lerpNullableDouble(
        iconSize,
        other.iconSize,
        t,
        TAvatarDefaults.iconSizeFor(size ?? TAvatarSize.medium),
        TAvatarDefaults.iconSizeFor(other.size ?? TAvatarSize.medium),
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
      textStyle: _lerpNullableTextStyle(
        textStyle,
        other.textStyle,
        t,
        TAvatarDefaults.textStyleFor(size ?? TAvatarSize.medium),
        TAvatarDefaults.textStyleFor(other.size ?? TAvatarSize.medium),
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

TextStyle? _lerpNullableTextStyle(
  TextStyle? begin,
  TextStyle? end,
  double t,
  TextStyle defaultBegin,
  TextStyle defaultEnd,
) {
  if (begin == null && end == null) {
    return null;
  }
  return TextStyle.lerp(begin ?? defaultBegin, end ?? defaultEnd, t);
}

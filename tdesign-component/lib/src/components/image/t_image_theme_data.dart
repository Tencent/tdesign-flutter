import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// 图片组件的视觉和解码默认值。
@immutable
class TImageThemeData extends ThemeExtension<TImageThemeData> {
  const TImageThemeData({
    this.color,
    this.colorBlendMode,
    this.centerSlice,
    this.matchTextDirection,
    this.gaplessPlayback,
    this.excludeFromSemantics,
    this.isAntiAlias,
    this.cacheHeight,
    this.cacheWidth,
  });

  /// 图片叠加色。
  final Color? color;

  /// 颜色混合模式。
  final BlendMode? colorBlendMode;

  /// 九宫格中心切片。
  final Rect? centerSlice;

  /// 是否匹配文字方向。
  final bool? matchTextDirection;

  /// 更新 provider 时是否保留上一帧。
  final bool? gaplessPlayback;

  /// 是否从语义树排除图片。
  final bool? excludeFromSemantics;

  /// 是否启用抗锯齿。
  final bool? isAntiAlias;

  /// 解码缓存高度。
  final int? cacheHeight;

  /// 解码缓存宽度。
  final int? cacheWidth;

  @override
  TImageThemeData copyWith({
    Color? color,
    BlendMode? colorBlendMode,
    Rect? centerSlice,
    bool? matchTextDirection,
    bool? gaplessPlayback,
    bool? excludeFromSemantics,
    bool? isAntiAlias,
    int? cacheHeight,
    int? cacheWidth,
  }) {
    return TImageThemeData(
      color: color ?? this.color,
      colorBlendMode: colorBlendMode ?? this.colorBlendMode,
      centerSlice: centerSlice ?? this.centerSlice,
      matchTextDirection: matchTextDirection ?? this.matchTextDirection,
      gaplessPlayback: gaplessPlayback ?? this.gaplessPlayback,
      excludeFromSemantics: excludeFromSemantics ?? this.excludeFromSemantics,
      isAntiAlias: isAntiAlias ?? this.isAntiAlias,
      cacheHeight: cacheHeight ?? this.cacheHeight,
      cacheWidth: cacheWidth ?? this.cacheWidth,
    );
  }

  @override
  TImageThemeData lerp(ThemeExtension<TImageThemeData>? other, double t) {
    if (other is! TImageThemeData) {
      return this;
    }
    return TImageThemeData(
      color: Color.lerp(color, other.color, t),
      colorBlendMode: t < 0.5 ? colorBlendMode : other.colorBlendMode,
      centerSlice: Rect.lerp(centerSlice, other.centerSlice, t),
      matchTextDirection:
          t < 0.5 ? matchTextDirection : other.matchTextDirection,
      gaplessPlayback: t < 0.5 ? gaplessPlayback : other.gaplessPlayback,
      excludeFromSemantics:
          t < 0.5 ? excludeFromSemantics : other.excludeFromSemantics,
      isAntiAlias: t < 0.5 ? isAntiAlias : other.isAntiAlias,
      cacheHeight: lerpDouble(cacheHeight, other.cacheHeight, t)?.round(),
      cacheWidth: lerpDouble(cacheWidth, other.cacheWidth, t)?.round(),
    );
  }
}

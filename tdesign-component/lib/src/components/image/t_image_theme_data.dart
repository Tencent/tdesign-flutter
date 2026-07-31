import 'package:flutter/material.dart';

/// 图片组件的视觉默认值。
@immutable
class TImageThemeData extends ThemeExtension<TImageThemeData> {
  const TImageThemeData({
    this.color,
    this.colorBlendMode,
    this.centerSlice,
    this.matchTextDirection,
    this.gaplessPlayback,
    this.isAntiAlias,
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

  /// 是否启用抗锯齿。
  final bool? isAntiAlias;

  @override
  TImageThemeData copyWith({
    Color? color,
    BlendMode? colorBlendMode,
    Rect? centerSlice,
    bool? matchTextDirection,
    bool? gaplessPlayback,
    bool? isAntiAlias,
  }) {
    return TImageThemeData(
      color: color ?? this.color,
      colorBlendMode: colorBlendMode ?? this.colorBlendMode,
      centerSlice: centerSlice ?? this.centerSlice,
      matchTextDirection: matchTextDirection ?? this.matchTextDirection,
      gaplessPlayback: gaplessPlayback ?? this.gaplessPlayback,
      isAntiAlias: isAntiAlias ?? this.isAntiAlias,
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
      isAntiAlias: t < 0.5 ? isAntiAlias : other.isAntiAlias,
    );
  }
}

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

  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
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

  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TImageThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TImageThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TImageThemeData) {
      return this;
    }
    return TImageThemeData(
      color: Color.lerp(color, other.color, t),
      colorBlendMode: t < 0.5 ? colorBlendMode : other.colorBlendMode,
      centerSlice: Rect.lerp(centerSlice, other.centerSlice, t),
      matchTextDirection: t < 0.5
          ? matchTextDirection
          : other.matchTextDirection,
      gaplessPlayback: t < 0.5 ? gaplessPlayback : other.gaplessPlayback,
      isAntiAlias: t < 0.5 ? isAntiAlias : other.isAntiAlias,
    );
  }
}

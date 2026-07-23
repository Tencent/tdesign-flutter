import 'package:flutter/material.dart';

/// TMessage 语义色
enum TMessageVariant {
  /// 信息
  info,

  /// 成功
  success,

  /// 警告
  warning,

  /// 错误
  error,
}

/// TMessage 组件级 ThemeExtension
class TMessageThemeData extends ThemeExtension<TMessageThemeData> {
  /// 背景色
  final Color? backgroundColor;

  /// 形状
  final ShapeBorder? shape;

  /// 阴影
  final double? elevation;

  /// 默认偏移
  final Offset? defaultOffset;

  const TMessageThemeData({
    this.backgroundColor,
    this.shape,
    this.elevation,
    this.defaultOffset,
  });

  TMessageThemeData merge(TMessageThemeData? other) {
    if (other == null) {
      return this;
    }
    return TMessageThemeData(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      shape: other.shape ?? shape,
      elevation: other.elevation ?? elevation,
      defaultOffset: other.defaultOffset ?? defaultOffset,
    );
  }

  @override
  TMessageThemeData copyWith({
    Color? backgroundColor,
    ShapeBorder? shape,
    double? elevation,
    Offset? defaultOffset,
  }) {
    return TMessageThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      shape: shape ?? this.shape,
      elevation: elevation ?? this.elevation,
      defaultOffset: defaultOffset ?? this.defaultOffset,
    );
  }

  @override
  TMessageThemeData lerp(ThemeExtension<TMessageThemeData>? other, double t) {
    if (other is! TMessageThemeData) {
      return this;
    }
    return TMessageThemeData(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      shape: t < 0.5 ? shape : other.shape,
      elevation: lerpDouble(elevation, other.elevation, t),
      defaultOffset: Offset.lerp(defaultOffset, other.defaultOffset, t),
    );
  }

  static double? lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return (a ?? 0.0) * (1.0 - t) + (b ?? 0.0) * t;
  }
}

import 'package:flutter/material.dart';

/// TMessage 组件级 ThemeExtension
class TMessageThemeData extends ThemeExtension<TMessageThemeData> {
  /// 背景色
  final Color? backgroundColor;

  /// 形状
  final ShapeBorder? shape;

  /// 阴影
  final double? elevation;

  const TMessageThemeData({this.backgroundColor, this.shape, this.elevation});

  TMessageThemeData merge(TMessageThemeData? other) {
    if (other == null) {
      return this;
    }
    return TMessageThemeData(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      shape: other.shape ?? shape,
      elevation: other.elevation ?? elevation,
    );
  }

  @override
  TMessageThemeData copyWith({
    Color? backgroundColor,
    ShapeBorder? shape,
    double? elevation,
  }) {
    return TMessageThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      shape: shape ?? this.shape,
      elevation: elevation ?? this.elevation,
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
    );
  }

  static double? lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return (a ?? 0.0) * (1.0 - t) + (b ?? 0.0) * t;
  }
}

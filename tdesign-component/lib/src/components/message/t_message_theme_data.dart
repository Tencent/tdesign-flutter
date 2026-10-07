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

  /// 返回合并后的主题；[other] 的非空字段覆盖当前字段，other 为空时返回当前主题。
  TMessageThemeData merge(
    /// 要合并的目标主题；为空时保留当前配置。
    TMessageThemeData? other,
  ) {
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

  /// 对 [a] 和 [b] 按 [t] 线性插值；两端均为 null 时返回 null，仅一端为 null 时按 0 参与计算。
  static double? lerpDouble(
    /// 插值起始值；单端为空时按 0 参与插值。
    double? a,

    /// 插值目标值；单端为空时按 0 参与插值。
    double? b,

    /// 插值进度；0 表示起点，1 表示终点。
    double t,
  ) {
    if (a == null && b == null) {
      return null;
    }
    return (a ?? 0.0) * (1.0 - t) + (b ?? 0.0) * t;
  }
}

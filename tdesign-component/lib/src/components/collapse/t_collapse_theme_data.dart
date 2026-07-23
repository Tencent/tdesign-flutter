import 'package:flutter/material.dart';

import 't_collapse_types.dart';

/// 折叠面板组件级 ThemeExtension
class TCollapseThemeData extends ThemeExtension<TCollapseThemeData> {
  /// 面板风格（block/card）
  final TCollapseVariant? variant;

  /// 默认面板背景色
  final Color? backgroundColor;

  /// 动画时长
  final Duration? animationDuration;

  /// 阴影
  final double? elevation;

  const TCollapseThemeData({
    this.variant,
    this.backgroundColor,
    this.animationDuration,
    this.elevation,
  });

  @override
  TCollapseThemeData copyWith({
    TCollapseVariant? variant,
    Color? backgroundColor,
    Duration? animationDuration,
    double? elevation,
  }) {
    return TCollapseThemeData(
      variant: variant ?? this.variant,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      animationDuration: animationDuration ?? this.animationDuration,
      elevation: elevation ?? this.elevation,
    );
  }

  @override
  TCollapseThemeData lerp(ThemeExtension<TCollapseThemeData>? other, double t) {
    if (other is! TCollapseThemeData) {
      return this;
    }
    return TCollapseThemeData(
      variant: t < 0.5 ? variant : other.variant,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      animationDuration: t < 0.5 ? animationDuration : other.animationDuration,
      elevation: t < 0.5 ? elevation : other.elevation,
    );
  }
}

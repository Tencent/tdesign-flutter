import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 't_fab_layout.dart';

/// Fab 定位层 ThemeExtension
///
/// 仅管理 Fab 定位层的默认值（偏移、边界、拖拽阈值等）。
/// 按钮外观走 TButtonThemeData。
class TFabThemeData extends ThemeExtension<TFabThemeData> {
  /// 默认距屏幕右侧偏移（逻辑像素）
  final double? defaultRight;

  /// 默认距屏幕底部偏移（逻辑像素）
  final double? defaultBottom;

  /// 默认水平拖拽边界限制
  final TFabBounds? defaultXBounds;

  /// 默认垂直拖拽边界限制
  final TFabBounds? defaultYBounds;

  /// 吸附动画时长
  final Duration? magnetAnimationDuration;

  /// 点击 vs 拖拽判定阈值（位移逻辑像素）
  final double? dragTapSlop;

  const TFabThemeData({
    this.defaultRight,
    this.defaultBottom,
    this.defaultXBounds,
    this.defaultYBounds,
    this.magnetAnimationDuration,
    this.dragTapSlop,
  });

  @override
  TFabThemeData copyWith({
    double? defaultRight,
    double? defaultBottom,
    TFabBounds? defaultXBounds,
    TFabBounds? defaultYBounds,
    Duration? magnetAnimationDuration,
    double? dragTapSlop,
  }) {
    return TFabThemeData(
      defaultRight: defaultRight ?? this.defaultRight,
      defaultBottom: defaultBottom ?? this.defaultBottom,
      defaultXBounds: defaultXBounds ?? this.defaultXBounds,
      defaultYBounds: defaultYBounds ?? this.defaultYBounds,
      magnetAnimationDuration:
          magnetAnimationDuration ?? this.magnetAnimationDuration,
      dragTapSlop: dragTapSlop ?? this.dragTapSlop,
    );
  }

  @override
  TFabThemeData lerp(ThemeExtension<TFabThemeData>? other, double t) {
    if (other is! TFabThemeData) {
      return this;
    }
    return TFabThemeData(
      defaultRight: lerpDouble(defaultRight, other.defaultRight, t),
      defaultBottom: lerpDouble(defaultBottom, other.defaultBottom, t),
      defaultXBounds: t < 0.5 ? defaultXBounds : other.defaultXBounds,
      defaultYBounds: t < 0.5 ? defaultYBounds : other.defaultYBounds,
      magnetAnimationDuration:
          t < 0.5 ? magnetAnimationDuration : other.magnetAnimationDuration,
      dragTapSlop: lerpDouble(dragTapSlop, other.dragTapSlop, t),
    );
  }
}

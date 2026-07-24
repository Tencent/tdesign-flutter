import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 't_backtop.dart' show TBackTop;

/// 返回顶部形状
enum TBackTopShape {
  /// 圆形
  circle,

  /// 半圆形
  halfCircle,
}

/// 返回顶部组件 ThemeExtension
///
/// 管理 TBackTop 的子树级默认样式（形状、颜色、显隐阈值、定位偏移等）。
class TBackTopThemeData extends ThemeExtension<TBackTopThemeData> {
  /// 默认形状（circle / halfCircle）
  final TBackTopShape? shape;

  /// 背景色；未设置时读取 [ColorScheme.primaryContainer]。
  final Color? backgroundColor;

  /// 边框色；未设置时读取 [ColorScheme.primary]。
  final Color? borderColor;

  /// 图标和文字颜色；未设置时读取 [ColorScheme.onPrimaryContainer]。
  final Color? contentColor;

  /// 默认显示阈值（未传 [TBackTop.visibilityOffset] 时，滚动偏移 ≥ 此值才显示）
  final double? defaultVisibilityOffset;

  /// 默认距屏幕右侧偏移（逻辑像素）
  final double? defaultRight;

  /// 默认距屏幕底部偏移（逻辑像素）
  final double? defaultBottom;

  /// 半圆形态右侧负 inset，用于控制贴边视觉。
  final double? halfCircleRightInset;

  const TBackTopThemeData({
    this.shape,
    this.backgroundColor,
    this.borderColor,
    this.contentColor,
    this.defaultVisibilityOffset,
    this.defaultRight,
    this.defaultBottom,
    this.halfCircleRightInset,
  });

  @override
  TBackTopThemeData copyWith({
    TBackTopShape? shape,
    Color? backgroundColor,
    Color? borderColor,
    Color? contentColor,
    double? defaultVisibilityOffset,
    double? defaultRight,
    double? defaultBottom,
    double? halfCircleRightInset,
  }) {
    return TBackTopThemeData(
      shape: shape ?? this.shape,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      contentColor: contentColor ?? this.contentColor,
      defaultVisibilityOffset:
          defaultVisibilityOffset ?? this.defaultVisibilityOffset,
      defaultRight: defaultRight ?? this.defaultRight,
      defaultBottom: defaultBottom ?? this.defaultBottom,
      halfCircleRightInset: halfCircleRightInset ?? this.halfCircleRightInset,
    );
  }

  @override
  TBackTopThemeData lerp(ThemeExtension<TBackTopThemeData>? other, double t) {
    if (other is! TBackTopThemeData) {
      return this;
    }
    return TBackTopThemeData(
      shape: t < 0.5 ? shape : other.shape,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      borderColor: Color.lerp(borderColor, other.borderColor, t),
      contentColor: Color.lerp(contentColor, other.contentColor, t),
      defaultVisibilityOffset:
          lerpDouble(defaultVisibilityOffset, other.defaultVisibilityOffset, t),
      defaultRight: lerpDouble(defaultRight, other.defaultRight, t),
      defaultBottom: lerpDouble(defaultBottom, other.defaultBottom, t),
      halfCircleRightInset:
          lerpDouble(halfCircleRightInset, other.halfCircleRightInset, t),
    );
  }
}

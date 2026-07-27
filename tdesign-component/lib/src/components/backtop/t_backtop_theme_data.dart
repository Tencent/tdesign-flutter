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
/// 管理 TBackTop 的子树级默认样式（形状、颜色、显隐阈值等）。
class TBackTopThemeData extends ThemeExtension<TBackTopThemeData> {
  /// 默认形状（circle / halfCircle）
  final TBackTopShape? shape;

  /// 背景色；未设置时读取 TDesign 品牌浅色 token。
  final Color? backgroundColor;

  /// 边框色；未设置时读取 TDesign 品牌色 token。
  final Color? borderColor;

  /// 图标和文字颜色；未设置时读取 TDesign 反色文字 token。
  final Color? contentColor;

  /// 默认显示阈值（未传 [TBackTop.visibilityOffset] 时，滚动偏移 ≥ 此值才显示）
  final double? defaultVisibilityOffset;

  const TBackTopThemeData({
    this.shape,
    this.backgroundColor,
    this.borderColor,
    this.contentColor,
    this.defaultVisibilityOffset,
  });

  @override
  TBackTopThemeData copyWith({
    TBackTopShape? shape,
    Color? backgroundColor,
    Color? borderColor,
    Color? contentColor,
    double? defaultVisibilityOffset,
  }) {
    return TBackTopThemeData(
      shape: shape ?? this.shape,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      contentColor: contentColor ?? this.contentColor,
      defaultVisibilityOffset:
          defaultVisibilityOffset ?? this.defaultVisibilityOffset,
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
    );
  }
}

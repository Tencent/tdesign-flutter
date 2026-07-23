import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// 图片预览组件级 ThemeExtension
class TImageViewerThemeData extends ThemeExtension<TImageViewerThemeData> {
  /// 预览页背景色
  final Color? backgroundColor;

  /// 导航栏背景色
  final Color? appBarBackgroundColor;

  /// 图标颜色
  final Color? iconColor;

  /// 标签文字样式
  final TextStyle? labelStyle;

  /// 页码文字样式
  final TextStyle? indexStyle;

  /// 蒙层颜色
  final Color? barrierColor;

  /// 预览区默认宽度
  final double? viewerWidth;

  /// 预览区默认高度
  final double? viewerHeight;

  const TImageViewerThemeData({
    this.backgroundColor,
    this.appBarBackgroundColor,
    this.iconColor,
    this.labelStyle,
    this.indexStyle,
    this.barrierColor,
    this.viewerWidth,
    this.viewerHeight,
  });

  @override
  TImageViewerThemeData copyWith({
    Color? backgroundColor,
    Color? appBarBackgroundColor,
    Color? iconColor,
    TextStyle? labelStyle,
    TextStyle? indexStyle,
    Color? barrierColor,
    double? viewerWidth,
    double? viewerHeight,
  }) {
    return TImageViewerThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      appBarBackgroundColor:
          appBarBackgroundColor ?? this.appBarBackgroundColor,
      iconColor: iconColor ?? this.iconColor,
      labelStyle: labelStyle ?? this.labelStyle,
      indexStyle: indexStyle ?? this.indexStyle,
      barrierColor: barrierColor ?? this.barrierColor,
      viewerWidth: viewerWidth ?? this.viewerWidth,
      viewerHeight: viewerHeight ?? this.viewerHeight,
    );
  }

  @override
  TImageViewerThemeData lerp(
      ThemeExtension<TImageViewerThemeData>? other, double t) {
    if (other is! TImageViewerThemeData) {
      return this;
    }
    return TImageViewerThemeData(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      appBarBackgroundColor:
          Color.lerp(appBarBackgroundColor, other.appBarBackgroundColor, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, t),
      indexStyle: TextStyle.lerp(indexStyle, other.indexStyle, t),
      barrierColor: Color.lerp(barrierColor, other.barrierColor, t),
      viewerWidth: lerpDouble(viewerWidth, other.viewerWidth, t),
      viewerHeight: lerpDouble(viewerHeight, other.viewerHeight, t),
    );
  }
}

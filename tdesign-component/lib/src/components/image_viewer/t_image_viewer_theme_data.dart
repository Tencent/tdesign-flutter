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
    this.viewerWidth,
    this.viewerHeight,
  });

  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TImageViewerThemeData copyWith({
    Color? backgroundColor,
    Color? appBarBackgroundColor,
    Color? iconColor,
    TextStyle? labelStyle,
    TextStyle? indexStyle,
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
      viewerWidth: viewerWidth ?? this.viewerWidth,
      viewerHeight: viewerHeight ?? this.viewerHeight,
    );
  }

  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TImageViewerThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TImageViewerThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TImageViewerThemeData) {
      return this;
    }
    return TImageViewerThemeData(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      appBarBackgroundColor: Color.lerp(
        appBarBackgroundColor,
        other.appBarBackgroundColor,
        t,
      ),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, t),
      indexStyle: TextStyle.lerp(indexStyle, other.indexStyle, t),
      viewerWidth: lerpDouble(viewerWidth, other.viewerWidth, t),
      viewerHeight: lerpDouble(viewerHeight, other.viewerHeight, t),
    );
  }
}

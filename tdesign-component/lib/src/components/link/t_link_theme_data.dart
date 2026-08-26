import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 't_link_types.dart';

/// TLink 组件级主题。
///
/// 通过 Theme 子树注入链接默认视觉，构造器参数优先于主题。
class TLinkThemeData extends ThemeExtension<TLinkThemeData> {
  const TLinkThemeData({
    this.defaultSize,
    this.defaultColorScheme,
    this.underline,
    this.textStyle,
    this.iconSize,
    this.iconGap,
  });

  /// 默认尺寸。
  final TLinkSize? defaultSize;

  /// 默认语义颜色；未设置时使用 [TLinkColorScheme.defaultTheme]。
  final TLinkColorScheme? defaultColorScheme;

  /// 是否默认显示下划线。
  final bool? underline;

  /// 链接文字样式；字号、行高与字重默认由 [defaultSize] 对应 Token 提供。
  final TextStyle? textStyle;

  /// 图标尺寸。
  final double? iconSize;

  /// 前/后图标与内容之间的间距。
  final double? iconGap;

  @override
  TLinkThemeData copyWith({
    TLinkSize? defaultSize,
    TLinkColorScheme? defaultColorScheme,
    bool? underline,
    TextStyle? textStyle,
    double? iconSize,
    double? iconGap,
  }) {
    return TLinkThemeData(
      defaultSize: defaultSize ?? this.defaultSize,
      defaultColorScheme: defaultColorScheme ?? this.defaultColorScheme,
      underline: underline ?? this.underline,
      textStyle: textStyle ?? this.textStyle,
      iconSize: iconSize ?? this.iconSize,
      iconGap: iconGap ?? this.iconGap,
    );
  }

  @override
  TLinkThemeData lerp(ThemeExtension<TLinkThemeData>? other, double t) {
    if (other is! TLinkThemeData) {
      return this;
    }
    return TLinkThemeData(
      defaultSize: t < 0.5 ? defaultSize : other.defaultSize,
      defaultColorScheme: t < 0.5
          ? defaultColorScheme
          : other.defaultColorScheme,
      underline: t < 0.5 ? underline : other.underline,
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      iconSize: lerpDouble(iconSize, other.iconSize, t),
      iconGap: lerpDouble(iconGap, other.iconGap, t),
    );
  }
}

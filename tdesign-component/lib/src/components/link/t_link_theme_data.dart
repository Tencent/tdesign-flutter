import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TLink 组件级主题。
///
/// 通过 Theme 子树注入链接字号样式、图标尺寸和间距等具体视觉值。
/// 尺寸档位、配色预设和下划线选择仅由 `TLink` 实例控制。
///
/// {@category ComponentTheme}
class TLinkThemeData extends ThemeExtension<TLinkThemeData> {
  const TLinkThemeData({this.textStyle, this.iconSize, this.iconGap});

  /// 链接文字样式；字号、行高与字重默认由实例尺寸对应 Token 提供。
  final TextStyle? textStyle;

  /// 图标尺寸；未设置时小、中、大尺寸分别为 14、16、18 逻辑像素。
  final double? iconSize;

  /// 前/后图标与内容之间的间距；未设置时为 4 逻辑像素。
  final double? iconGap;

  /// 复制主题配置。
  ///
  /// ## 返回值
  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TLinkThemeData copyWith({
    TextStyle? textStyle,
    double? iconSize,
    double? iconGap,
  }) {
    return TLinkThemeData(
      textStyle: textStyle ?? this.textStyle,
      iconSize: iconSize ?? this.iconSize,
      iconGap: iconGap ?? this.iconGap,
    );
  }

  /// 生成主题过渡配置。
  ///
  /// ## 返回值
  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TLinkThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TLinkThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TLinkThemeData) {
      return this;
    }
    return TLinkThemeData(
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      iconSize: lerpDouble(iconSize, other.iconSize, t),
      iconGap: lerpDouble(iconGap, other.iconGap, t),
    );
  }
}

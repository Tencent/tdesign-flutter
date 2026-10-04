import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TLink 组件级主题。
///
/// 通过 Theme 子树注入链接字号样式、图标尺寸和间距等具体视觉值。
/// 尺寸档位、配色预设和下划线选择仅由 `TLink` 实例控制。
class TLinkThemeData extends ThemeExtension<TLinkThemeData> {
  const TLinkThemeData({this.textStyle, this.iconSize, this.iconGap});

  /// 链接文字样式；字号、行高与字重默认由实例尺寸对应 Token 提供。
  final TextStyle? textStyle;

  /// 图标尺寸。
  final double? iconSize;

  /// 前/后图标与内容之间的间距。
  final double? iconGap;

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

  @override
  TLinkThemeData lerp(ThemeExtension<TLinkThemeData>? other, double t) {
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

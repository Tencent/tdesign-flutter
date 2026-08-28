import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TRate 组件级 ThemeExtension。
class TRateThemeData extends ThemeExtension<TRateThemeData> {
  const TRateThemeData({
    /// 选中星标颜色。
    this.starColor,

    /// 未选中星标颜色。
    this.inactiveStarColor,

    /// 图标尺寸。
    this.iconSize,

    /// 图标间距。
    this.iconGap,

    /// 文案宽度。
    this.textWidth,

    /// 图标与文案间距。
    this.textGap,

    /// 文案样式。
    this.textStyle,

    /// 半星选择浮层阴影。
    this.overlayBoxShadow,
  });

  /// 选中星标颜色。
  final Color? starColor;

  /// 未选中星标颜色。
  final Color? inactiveStarColor;

  /// 图标尺寸。
  final double? iconSize;

  /// 图标间距。
  final double? iconGap;

  /// 文案宽度。
  final double? textWidth;

  /// 图标与文案间距。
  final double? textGap;

  /// 文案样式。
  final TextStyle? textStyle;

  /// 半星选择浮层阴影。
  final List<BoxShadow>? overlayBoxShadow;

  @override
  TRateThemeData copyWith({
    Color? starColor,
    Color? inactiveStarColor,
    double? iconSize,
    double? iconGap,
    double? textWidth,
    double? textGap,
    TextStyle? textStyle,
    List<BoxShadow>? overlayBoxShadow,
  }) {
    return TRateThemeData(
      starColor: starColor ?? this.starColor,
      inactiveStarColor: inactiveStarColor ?? this.inactiveStarColor,
      iconSize: iconSize ?? this.iconSize,
      iconGap: iconGap ?? this.iconGap,
      textWidth: textWidth ?? this.textWidth,
      textGap: textGap ?? this.textGap,
      textStyle: textStyle ?? this.textStyle,
      overlayBoxShadow: overlayBoxShadow ?? this.overlayBoxShadow,
    );
  }

  @override
  TRateThemeData lerp(ThemeExtension<TRateThemeData>? other, double t) {
    if (other is! TRateThemeData) {
      return this;
    }
    return TRateThemeData(
      starColor: Color.lerp(starColor, other.starColor, t),
      inactiveStarColor: Color.lerp(
        inactiveStarColor,
        other.inactiveStarColor,
        t,
      ),
      iconSize: lerpDouble(iconSize, other.iconSize, t),
      iconGap: lerpDouble(iconGap, other.iconGap, t),
      textWidth: lerpDouble(textWidth, other.textWidth, t),
      textGap: lerpDouble(textGap, other.textGap, t),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      overlayBoxShadow: t < 0.5 ? overlayBoxShadow : other.overlayBoxShadow,
    );
  }
}

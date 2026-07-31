import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Material [BadgeThemeData] 未覆盖的 TDesign 徽标视觉默认值。
@immutable
class TBadgeThemeData extends ThemeExtension<TBadgeThemeData> {
  const TBadgeThemeData({
    this.borderColor,
    this.borderWidth,
  });

  /// 开启边框时使用的颜色。
  final Color? borderColor;

  /// 开启边框时使用的宽度。
  final double? borderWidth;

  @override
  TBadgeThemeData copyWith({
    Color? borderColor,
    double? borderWidth,
  }) {
    return TBadgeThemeData(
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
    );
  }

  @override
  TBadgeThemeData lerp(ThemeExtension<TBadgeThemeData>? other, double t) {
    if (other is! TBadgeThemeData) {
      return this;
    }
    return TBadgeThemeData(
      borderColor: Color.lerp(borderColor, other.borderColor, t),
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t),
    );
  }
}

import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// 页脚组件级 ThemeExtension
class TFooterThemeData extends ThemeExtension<TFooterThemeData> {
  /// 默认高度
  final double? height;

  const TFooterThemeData({
    this.height,
  });

  @override
  TFooterThemeData copyWith({
    double? height,
  }) {
    return TFooterThemeData(
      height: height ?? this.height,
    );
  }

  @override
  TFooterThemeData lerp(ThemeExtension<TFooterThemeData>? other, double t) {
    if (other is! TFooterThemeData) {
      return this;
    }
    return TFooterThemeData(
      height: lerpDouble(height, other.height, t),
    );
  }
}

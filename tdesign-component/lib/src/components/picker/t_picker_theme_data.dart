import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TPicker 组件级 ThemeExtension
///
/// 被 TPicker 和 TDateTimePicker 共用。
class TPickerThemeData extends ThemeExtension<TPickerThemeData> {
  /// 滚轮视窗高度（像素）
  final double? height;

  /// 每屏显示项数
  final int? itemCount;

  const TPickerThemeData({
    /// 滚轮视窗高度（像素）。
    this.height,

    /// 每屏显示项数。
    this.itemCount,
  });

  @override
  TPickerThemeData copyWith({
    double? height,
    int? itemCount,
  }) {
    return TPickerThemeData(
      height: height ?? this.height,
      itemCount: itemCount ?? this.itemCount,
    );
  }

  @override
  TPickerThemeData lerp(ThemeExtension<TPickerThemeData>? other, double t) {
    if (other is! TPickerThemeData) {
      return this;
    }
    return TPickerThemeData(
      height: lerpDouble(height, other.height, t),
      itemCount: t < 0.5 ? itemCount : other.itemCount,
    );
  }
}

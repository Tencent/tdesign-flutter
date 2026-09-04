import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TPicker 组件级 ThemeExtension
///
/// 被 TPicker 和 TDateTimePicker 共用。
class TPickerThemeData extends ThemeExtension<TPickerThemeData> {
  /// 滚轮视窗高度，单位为逻辑像素；null 时使用默认值 200。
  ///
  /// 必须为有限正数，行高由此高度除以 [itemCount]（默认 5）得到。
  final double? height;

  /// 每屏显示项数，null 时使用默认值 5；必须大于零。
  final int? itemCount;

  const TPickerThemeData({
    /// 滚轮视窗高度，默认 200 逻辑像素。
    this.height,

    /// 每屏显示项数，默认 5。
    this.itemCount,
  }) : assert(height == null || (height > 0 && height < double.infinity)),
       assert(itemCount == null || itemCount > 0);

  @override
  TPickerThemeData copyWith({double? height, int? itemCount}) {
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
      height: height == null && other.height == null
          ? null
          : lerpDouble(height ?? 200, other.height ?? 200, t),
      itemCount: t < 0.5 ? itemCount : other.itemCount,
    );
  }
}

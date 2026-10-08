import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'picker_defaults.dart';

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

  const TPickerThemeData({this.height, this.itemCount})
    : assert(height == null || (height > 0 && height < double.infinity)),
      assert(itemCount == null || itemCount > 0);

  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TPickerThemeData copyWith({double? height, int? itemCount}) {
    return TPickerThemeData(
      height: height ?? this.height,
      itemCount: itemCount ?? this.itemCount,
    );
  }

  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TPickerThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TPickerThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TPickerThemeData) {
      return this;
    }
    return TPickerThemeData(
      height: height == null && other.height == null
          ? null
          : lerpDouble(
              height ?? defaultPickerHeight,
              other.height ?? defaultPickerHeight,
              t,
            ),
      itemCount: t < 0.5 ? itemCount : other.itemCount,
    );
  }
}

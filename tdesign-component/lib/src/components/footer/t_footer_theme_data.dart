import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// 页脚组件级 ThemeExtension。
///
/// 未配置 [height] 时，页脚按内容自然撑开；配置后才会约束外层高度。
///
/// {@category ComponentTheme}
class TFooterThemeData extends ThemeExtension<TFooterThemeData> {
  /// 页脚外层高度。
  ///
  /// 默认值为 null，表示由 logo、链接或文字内容自然决定高度。
  final double? height;

  const TFooterThemeData({this.height});

  /// 复制主题配置。
  ///
  /// ## 返回值
  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TFooterThemeData copyWith({double? height}) {
    return TFooterThemeData(height: height ?? this.height);
  }

  /// 生成主题过渡配置。
  ///
  /// ## 返回值
  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TFooterThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TFooterThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TFooterThemeData) {
      return this;
    }
    return TFooterThemeData(height: lerpDouble(height, other.height, t));
  }
}

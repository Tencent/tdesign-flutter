import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// 结果组件级 ThemeExtension
class TResultThemeData extends ThemeExtension<TResultThemeData> {
  /// 默认状态图标尺寸；自定义 icon 不使用该字段。
  final double? iconSize;

  /// 标题文字样式
  final TextStyle? titleStyle;

  /// 描述文字样式
  final TextStyle? descriptionStyle;

  const TResultThemeData({
    this.iconSize,
    this.titleStyle,
    this.descriptionStyle,
  }) : assert(iconSize == null || iconSize > 0);

  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TResultThemeData copyWith({
    double? iconSize,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
  }) {
    return TResultThemeData(
      iconSize: iconSize ?? this.iconSize,
      titleStyle: titleStyle ?? this.titleStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
    );
  }

  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TResultThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TResultThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TResultThemeData) {
      return this;
    }
    return TResultThemeData(
      iconSize: _lerpIconSize(iconSize, other.iconSize, t),
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
      descriptionStyle: TextStyle.lerp(
        descriptionStyle,
        other.descriptionStyle,
        t,
      ),
    );
  }

  static double? _lerpIconSize(double? begin, double? end, double t) {
    if (begin == null && end == null) {
      return null;
    }
    return lerpDouble(begin ?? 80, end ?? 80, t);
  }
}

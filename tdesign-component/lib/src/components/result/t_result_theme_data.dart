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

  @override
  TResultThemeData lerp(ThemeExtension<TResultThemeData>? other, double t) {
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

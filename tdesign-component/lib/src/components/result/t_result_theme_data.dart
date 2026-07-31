import 'package:flutter/material.dart';

/// 结果组件级 ThemeExtension
class TResultThemeData extends ThemeExtension<TResultThemeData> {
  /// 标题文字样式
  final TextStyle? titleStyle;

  const TResultThemeData({
    this.titleStyle,
  });

  @override
  TResultThemeData copyWith({
    TextStyle? titleStyle,
  }) {
    return TResultThemeData(
      titleStyle: titleStyle ?? this.titleStyle,
    );
  }

  @override
  TResultThemeData lerp(ThemeExtension<TResultThemeData>? other, double t) {
    if (other is! TResultThemeData) {
      return this;
    }
    return TResultThemeData(
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
    );
  }
}

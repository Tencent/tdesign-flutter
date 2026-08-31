import 'dart:ui' as ui show TextHeightBehavior;

import 'package:flutter/material.dart';

import '../../theme/basic.dart';

/// TText 组件级主题。
///
/// [font] 用于直接配置 TDesign 字体 Token；[textStyle] 用于配置 Flutter
/// 原生文字样式，并覆盖 [font] 中显式设置的同名字段。
class TTextThemeData extends ThemeExtension<TTextThemeData> {
  const TTextThemeData({
    this.font,
    this.textStyle,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
  });

  /// 默认 TDesign 字体 Token。
  final Font? font;

  /// 默认 Flutter 文字样式。
  final TextStyle? textStyle;

  /// 默认段落支柱样式。
  final StrutStyle? strutStyle;

  /// 默认文本宽度计算方式。
  final TextWidthBasis? textWidthBasis;

  /// 默认文本高度行为。
  final ui.TextHeightBehavior? textHeightBehavior;

  @override
  TTextThemeData copyWith({
    Font? font,
    TextStyle? textStyle,
    StrutStyle? strutStyle,
    TextWidthBasis? textWidthBasis,
    ui.TextHeightBehavior? textHeightBehavior,
  }) {
    return TTextThemeData(
      font: font ?? this.font,
      textStyle: textStyle ?? this.textStyle,
      strutStyle: strutStyle ?? this.strutStyle,
      textWidthBasis: textWidthBasis ?? this.textWidthBasis,
      textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
    );
  }

  @override
  TTextThemeData lerp(ThemeExtension<TTextThemeData>? other, double t) {
    if (other is! TTextThemeData) {
      return this;
    }
    return TTextThemeData(
      font: t < 0.5 ? font : other.font,
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      strutStyle: t < 0.5 ? strutStyle : other.strutStyle,
      textWidthBasis: t < 0.5 ? textWidthBasis : other.textWidthBasis,
      textHeightBehavior: t < 0.5
          ? textHeightBehavior
          : other.textHeightBehavior,
    );
  }
}

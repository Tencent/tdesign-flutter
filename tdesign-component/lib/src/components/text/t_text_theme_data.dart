import 'dart:ui' as ui show TextHeightBehavior;

import 'package:flutter/material.dart';

import '../../theme/basic.dart';

/// TText 子树的组件默认值。
///
/// 仅在对应实例参数未指定时生效；实例 [TextStyle]、字体及段落参数
/// 优先于这里的默认值。Flutter [DefaultTextStyle] 可提供通用文字继承，
/// 本主题额外保留 TDesign [Font] 和 [StrutStyle] 等组件默认能力。
class TTextThemeData extends ThemeExtension<TTextThemeData> {
  const TTextThemeData({
    this.font,
    this.textStyle,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
  });

  /// 子树的 TDesign 字体默认值；[textStyle] 的同名字段优先。
  final Font? font;

  /// 子树的文字样式默认值；实例 `TText.style` 优先。
  final TextStyle? textStyle;

  /// 子树的段落支柱样式默认值；实例 `TText.strutStyle` 优先。
  final StrutStyle? strutStyle;

  /// 子树的文字宽度计算默认值；实例 `TText.textWidthBasis` 优先。
  final TextWidthBasis? textWidthBasis;

  /// 子树的文字高度行为默认值；实例 `TText.textHeightBehavior` 优先。
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

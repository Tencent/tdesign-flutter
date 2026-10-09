import 'dart:ui' as ui show TextHeightBehavior;

import 'package:flutter/material.dart';

/// TText 子树的组件默认值。
///
/// 仅在对应实例参数未指定时生效；实例字体预设和段落参数
/// 优先于这里的默认值。外部 Flutter [DefaultTextStyle] 不会自动覆盖 TDesign 文字。
///
/// {@category ComponentTheme}
class TTextThemeData extends ThemeExtension<TTextThemeData> {
  const TTextThemeData({
    this.textStyle,
    this.strutStyle,
    this.textWidthBasis,
    this.textHeightBehavior,
  });

  /// 子树的完整文字样式；字号、行高和字重也由本字段统一设置。
  /// TText 实例的显式字体参数仍优先于本默认值。
  final TextStyle? textStyle;

  /// 子树的段落支柱样式默认值；实例 `TText.strutStyle` 优先。
  final StrutStyle? strutStyle;

  /// 子树的文字宽度计算默认值；实例 `TText.textWidthBasis` 优先。
  final TextWidthBasis? textWidthBasis;

  /// 子树的文字高度行为默认值；实例 `TText.textHeightBehavior` 优先。
  final ui.TextHeightBehavior? textHeightBehavior;

  /// 复制主题配置。
  ///
  /// ## 返回值
  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TTextThemeData copyWith({
    TextStyle? textStyle,
    StrutStyle? strutStyle,
    TextWidthBasis? textWidthBasis,
    ui.TextHeightBehavior? textHeightBehavior,
  }) {
    return TTextThemeData(
      textStyle: textStyle ?? this.textStyle,
      strutStyle: strutStyle ?? this.strutStyle,
      textWidthBasis: textWidthBasis ?? this.textWidthBasis,
      textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
    );
  }

  /// 生成主题过渡配置。
  ///
  /// ## 返回值
  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TTextThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TTextThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TTextThemeData) {
      return this;
    }
    return TTextThemeData(
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      strutStyle: t < 0.5 ? strutStyle : other.strutStyle,
      textWidthBasis: t < 0.5 ? textWidthBasis : other.textWidthBasis,
      textHeightBehavior: t < 0.5
          ? textHeightBehavior
          : other.textHeightBehavior,
    );
  }
}

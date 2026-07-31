import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TInput 与 TTextarea 共用的组件级 ThemeExtension。
///
/// Material 能表达的边框、颜色、内边距和文本样式可通过输入组件的
/// decoration 显式传入；默认状态不继承全局填充色，避免输入区被
/// [ThemeData.inputDecorationTheme] 污染。
class TInputThemeData extends ThemeExtension<TInputThemeData> {
  const TInputThemeData({
    /// 是否默认显示清除按钮。
    this.showClearButton,

    /// 清除图标尺寸。
    this.clearIconSize,

    /// 多行输入默认最小行数。
    this.multilineMinLines,

    /// 输入文本样式。
    this.textStyle,

    /// 光标颜色。
    this.cursorColor,

    /// 输入装饰的组件级默认值。
    this.decorationTheme,

    /// 清除图标颜色。
    this.clearIconColor,
  });

  /// 是否默认显示清除按钮。
  final bool? showClearButton;

  /// 清除图标尺寸。
  final double? clearIconSize;

  /// 多行输入默认最小行数。
  final int? multilineMinLines;

  /// 输入文本样式。
  final TextStyle? textStyle;

  /// 光标颜色。
  final Color? cursorColor;

  /// 输入装饰的组件级默认值。
  final InputDecorationTheme? decorationTheme;

  /// 清除图标颜色。
  final Color? clearIconColor;

  @override
  TInputThemeData copyWith({
    bool? showClearButton,
    double? clearIconSize,
    int? multilineMinLines,
    TextStyle? textStyle,
    Color? cursorColor,
    InputDecorationTheme? decorationTheme,
    Color? clearIconColor,
  }) {
    return TInputThemeData(
      showClearButton: showClearButton ?? this.showClearButton,
      clearIconSize: clearIconSize ?? this.clearIconSize,
      multilineMinLines: multilineMinLines ?? this.multilineMinLines,
      textStyle: textStyle ?? this.textStyle,
      cursorColor: cursorColor ?? this.cursorColor,
      decorationTheme: decorationTheme ?? this.decorationTheme,
      clearIconColor: clearIconColor ?? this.clearIconColor,
    );
  }

  @override
  TInputThemeData lerp(ThemeExtension<TInputThemeData>? other, double t) {
    if (other is! TInputThemeData) {
      return this;
    }
    return TInputThemeData(
      showClearButton: t < 0.5 ? showClearButton : other.showClearButton,
      clearIconSize: lerpDouble(clearIconSize, other.clearIconSize, t),
      multilineMinLines: t < 0.5 ? multilineMinLines : other.multilineMinLines,
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      cursorColor: Color.lerp(cursorColor, other.cursorColor, t),
      decorationTheme: t < 0.5 ? decorationTheme : other.decorationTheme,
      clearIconColor: Color.lerp(clearIconColor, other.clearIconColor, t),
    );
  }
}

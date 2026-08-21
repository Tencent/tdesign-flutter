import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 't_input_types.dart';

/// TInput 与 TTextarea 共用的组件级 ThemeExtension。
///
/// 输入组件的外层边框、颜色、内边距和文本样式在这里提供组件级默认值；
/// 默认状态不继承全局填充色，避免输入区被 [ThemeData.inputDecorationTheme]
/// 污染。
class TInputThemeData extends ThemeExtension<TInputThemeData> {
  const TInputThemeData({
    /// 清除按钮默认显示模式。
    this.clearButtonMode,

    /// 清除图标尺寸。
    this.clearIconSize,

    /// 多行输入默认最小行数。
    this.multilineMinLines,

    /// 输入文本样式。
    ///
    /// 未指定的字段继承 TDesign `fontBodyLarge`；颜色覆盖所有可用状态的
    /// 输入文字，不影响壳层和提示的语义状态色。
    this.textStyle,

    /// 光标颜色。
    this.cursorColor,

    /// 占位提示文本样式。
    ///
    /// 未指定的字段继承 TDesign 输入框提示词 token。
    this.hintStyle,

    /// 清除图标颜色。
    this.clearIconColor,

    /// 输入区域内边距。
    this.contentPadding,

    /// 输入区域圆角。
    ///
    /// 对非多行、非无边框输入框设置为大于 0 的值时，输入框使用完整边框；
    /// 未设置时保留单行输入框的底部分隔线。
    this.borderRadius,

    /// 输入区域背景色。
    this.backgroundColor,

    /// 输入区域边框颜色。
    this.borderColor,

    /// 输入区域边框宽度。
    this.borderWidth,
  });

  /// 清除按钮默认显示模式。
  final TInputClearButtonMode? clearButtonMode;

  /// 清除图标尺寸。
  final double? clearIconSize;

  /// 多行输入默认最小行数。
  final int? multilineMinLines;

  /// 输入文本样式。
  ///
  /// 未指定的字段继承 TDesign `fontBodyLarge`；颜色覆盖所有可用状态的
  /// 输入文字，不影响壳层和提示的语义状态色。
  final TextStyle? textStyle;

  /// 光标颜色。
  final Color? cursorColor;

  /// 占位提示文本样式。
  ///
  /// 未指定的字段继承 TDesign 输入框提示词 token。
  final TextStyle? hintStyle;

  /// 清除图标颜色。
  final Color? clearIconColor;

  /// 输入区域内边距。
  final EdgeInsetsGeometry? contentPadding;

  /// 输入区域圆角。
  final double? borderRadius;

  /// 输入区域背景色。
  final Color? backgroundColor;

  /// 输入区域边框颜色。
  final Color? borderColor;

  /// 输入区域边框宽度。
  final double? borderWidth;

  @override
  TInputThemeData copyWith({
    TInputClearButtonMode? clearButtonMode,
    double? clearIconSize,
    int? multilineMinLines,
    TextStyle? textStyle,
    Color? cursorColor,
    TextStyle? hintStyle,
    Color? clearIconColor,
    EdgeInsetsGeometry? contentPadding,
    double? borderRadius,
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
  }) {
    return TInputThemeData(
      clearButtonMode: clearButtonMode ?? this.clearButtonMode,
      clearIconSize: clearIconSize ?? this.clearIconSize,
      multilineMinLines: multilineMinLines ?? this.multilineMinLines,
      textStyle: textStyle ?? this.textStyle,
      cursorColor: cursorColor ?? this.cursorColor,
      hintStyle: hintStyle ?? this.hintStyle,
      clearIconColor: clearIconColor ?? this.clearIconColor,
      contentPadding: contentPadding ?? this.contentPadding,
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
    );
  }

  @override
  TInputThemeData lerp(ThemeExtension<TInputThemeData>? other, double t) {
    if (other is! TInputThemeData) {
      return this;
    }
    return TInputThemeData(
      clearButtonMode: t < 0.5 ? clearButtonMode : other.clearButtonMode,
      clearIconSize: lerpDouble(clearIconSize, other.clearIconSize, t),
      multilineMinLines: t < 0.5 ? multilineMinLines : other.multilineMinLines,
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      cursorColor: Color.lerp(cursorColor, other.cursorColor, t),
      hintStyle: TextStyle.lerp(hintStyle, other.hintStyle, t),
      clearIconColor: Color.lerp(clearIconColor, other.clearIconColor, t),
      contentPadding: EdgeInsetsGeometry.lerp(
        contentPadding,
        other.contentPadding,
        t,
      ),
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      borderColor: Color.lerp(borderColor, other.borderColor, t),
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t),
    );
  }
}

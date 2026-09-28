import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TInput 与 TTextarea 共用的组件级 ThemeExtension。
///
/// 输入组件的外层边框、颜色、内边距和文本样式在这里提供组件级默认值；
/// 默认状态不继承全局填充色，避免输入区被 [ThemeData.inputDecorationTheme]
/// 污染。
class TInputThemeData extends ThemeExtension<TInputThemeData> {
  const TInputThemeData({
    /// 清除图标尺寸。
    this.clearIconSize,

    /// 输入文本样式。
    ///
    /// 未指定的字段继承 TDesign `fontBodyLarge`；颜色覆盖可用状态的输入
    /// 文字，不影响禁用态，也不影响壳层和提示的语义状态色。
    this.textStyle,

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

  /// 清除图标尺寸。
  final double? clearIconSize;

  /// 输入文本样式。
  ///
  /// 为子树中的输入框提供默认值；单个 `TInput.style` 优先。
  /// 未指定的字段继承显式 Material 文字主题或 TDesign `fontBodyLarge`；
  /// 颜色覆盖可用状态的输入文字，不影响壳层和提示的语义状态色。
  final TextStyle? textStyle;

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
    double? clearIconSize,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    Color? clearIconColor,
    EdgeInsetsGeometry? contentPadding,
    double? borderRadius,
    Color? backgroundColor,
    Color? borderColor,
    double? borderWidth,
  }) {
    return TInputThemeData(
      clearIconSize: clearIconSize ?? this.clearIconSize,
      textStyle: textStyle ?? this.textStyle,
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
      clearIconSize: lerpDouble(clearIconSize, other.clearIconSize, t),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
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

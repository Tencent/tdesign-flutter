import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TInput 与 TTextarea 共用的组件级 ThemeExtension。
///
/// 输入组件的外层边框、颜色、内边距和提示文字样式在这里提供组件级默认值；
/// 默认状态不继承全局填充色，避免输入区被 [ThemeData.inputDecorationTheme]
/// 污染。
class TInputThemeData extends ThemeExtension<TInputThemeData> {
  const TInputThemeData({
    this.clearIconSize,
    this.hintStyle,
    this.clearIconColor,
    this.contentPadding,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
  });

  /// 清除图标尺寸。
  /// null 时为 20 逻辑像素。
  final double? clearIconSize;

  /// 占位提示文本样式。
  ///
  /// 未指定的字段继承 TDesign 输入框提示词 token。
  final TextStyle? hintStyle;

  /// 清除图标颜色。
  /// null 时错误态使用 errorColor，其他状态使用 textColorPlaceholder Token。
  final Color? clearIconColor;

  /// 输入区域内边距。
  /// null 时在 TFormItem 作用域内为零，独立输入框为四周 16 逻辑像素；Textarea 组合有独立的容器分工。
  final EdgeInsetsGeometry? contentPadding;

  /// 输入区域圆角。
  ///
  /// 对非多行、非无边框输入框设置为大于 0 的值时，输入框使用完整边框；
  /// 未设置时保留单行输入框的底部分隔线。
  final double? borderRadius;

  /// 输入区域背景色。
  /// null 时在 TFormItem 作用域内透明，独立输入框使用 bgColorContainer Token。
  final Color? backgroundColor;

  /// 输入区域边框颜色。
  /// null 时按启用、焦点与语义状态解析边框颜色；禁用态使用 componentStroke Token。
  final Color? borderColor;

  /// 输入区域边框宽度。
  /// null 时为 1 逻辑像素。
  final double? borderWidth;

  /// 复制主题配置。
  ///
  /// ## 返回值
  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TInputThemeData copyWith({
    double? clearIconSize,
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
      hintStyle: hintStyle ?? this.hintStyle,
      clearIconColor: clearIconColor ?? this.clearIconColor,
      contentPadding: contentPadding ?? this.contentPadding,
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
    );
  }

  /// 生成主题过渡配置。
  ///
  /// ## 返回值
  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TInputThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TInputThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TInputThemeData) {
      return this;
    }
    return TInputThemeData(
      clearIconSize: lerpDouble(clearIconSize, other.clearIconSize, t),
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

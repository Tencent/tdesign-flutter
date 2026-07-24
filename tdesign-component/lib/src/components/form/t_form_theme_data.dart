import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// 表单项布局方向。
enum TFormLayout {
  /// 标签与字段水平排列。
  horizontal,

  /// 标签与字段垂直排列。
  vertical,
}

/// TForm 组件级 ThemeExtension。
class TFormThemeData extends ThemeExtension<TFormThemeData> {
  const TFormThemeData({
    /// 是否在标签末尾显示冒号。
    this.showColon,

    /// 默认标签宽度。
    this.labelWidth,

    /// 表单项布局方向。
    this.layout,

    /// 标签对齐方式。
    this.labelAlign,

    /// 标签样式。
    this.labelStyle,

    /// 必填标记样式。
    this.requiredMarkStyle,

    /// 辅助说明样式。
    this.helpStyle,

    /// 错误文案样式。
    this.errorStyle,

    /// 表单项背景色。
    this.backgroundColor,

    /// 表单项内边距。
    this.itemPadding,

    /// 表单项间距。
    this.itemSpacing,

    /// 标签与字段的垂直间距。
    this.labelGap,

    /// 字段与辅助或错误文案的间距。
    this.messageGap,
  });

  /// 是否在标签末尾显示冒号。
  final bool? showColon;

  /// 默认标签宽度。
  final double? labelWidth;

  /// 表单项布局方向。
  final TFormLayout? layout;

  /// 标签对齐方式。
  final TextAlign? labelAlign;

  /// 标签样式。
  final TextStyle? labelStyle;

  /// 必填标记样式。
  final TextStyle? requiredMarkStyle;

  /// 辅助说明样式。
  final TextStyle? helpStyle;

  /// 错误文案样式。
  final TextStyle? errorStyle;

  /// 表单项背景色。
  final Color? backgroundColor;

  /// 表单项内边距。
  final EdgeInsetsGeometry? itemPadding;

  /// 表单项间距。
  final double? itemSpacing;

  /// 标签与字段的垂直间距。
  final double? labelGap;

  /// 字段与辅助或错误文案的间距。
  final double? messageGap;

  @override
  TFormThemeData copyWith({
    bool? showColon,
    double? labelWidth,
    TFormLayout? layout,
    TextAlign? labelAlign,
    TextStyle? labelStyle,
    TextStyle? requiredMarkStyle,
    TextStyle? helpStyle,
    TextStyle? errorStyle,
    Color? backgroundColor,
    EdgeInsetsGeometry? itemPadding,
    double? itemSpacing,
    double? labelGap,
    double? messageGap,
  }) {
    return TFormThemeData(
      showColon: showColon ?? this.showColon,
      labelWidth: labelWidth ?? this.labelWidth,
      layout: layout ?? this.layout,
      labelAlign: labelAlign ?? this.labelAlign,
      labelStyle: labelStyle ?? this.labelStyle,
      requiredMarkStyle: requiredMarkStyle ?? this.requiredMarkStyle,
      helpStyle: helpStyle ?? this.helpStyle,
      errorStyle: errorStyle ?? this.errorStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      itemPadding: itemPadding ?? this.itemPadding,
      itemSpacing: itemSpacing ?? this.itemSpacing,
      labelGap: labelGap ?? this.labelGap,
      messageGap: messageGap ?? this.messageGap,
    );
  }

  @override
  TFormThemeData lerp(ThemeExtension<TFormThemeData>? other, double t) {
    if (other is! TFormThemeData) {
      return this;
    }
    return TFormThemeData(
      showColon: t < 0.5 ? showColon : other.showColon,
      labelWidth: lerpDouble(labelWidth, other.labelWidth, t),
      layout: t < 0.5 ? layout : other.layout,
      labelAlign: t < 0.5 ? labelAlign : other.labelAlign,
      labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, t),
      requiredMarkStyle:
          TextStyle.lerp(requiredMarkStyle, other.requiredMarkStyle, t),
      helpStyle: TextStyle.lerp(helpStyle, other.helpStyle, t),
      errorStyle: TextStyle.lerp(errorStyle, other.errorStyle, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      itemPadding: EdgeInsetsGeometry.lerp(itemPadding, other.itemPadding, t),
      itemSpacing: lerpDouble(itemSpacing, other.itemSpacing, t),
      labelGap: lerpDouble(labelGap, other.labelGap, t),
      messageGap: lerpDouble(messageGap, other.messageGap, t),
    );
  }
}

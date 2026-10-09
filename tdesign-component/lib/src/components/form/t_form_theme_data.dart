import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// 表单项布局方向。
enum TFormLayout {
  /// 标签与字段水平排列。
  horizontal,

  /// 标签与字段垂直排列。
  vertical,
}

/// 表单必填标记的位置。
enum TFormRequiredMarkPosition {
  /// 显示在标签左侧。
  left,

  /// 显示在标签右侧。
  right,
}

/// 水平表单项各区域的纵向对齐方式。
enum TFormItemVerticalAlignment {
  /// 标签、字段内容和额外内容从顶部对齐。
  start,

  /// 标签、字段内容和额外内容垂直居中。
  center,
}

/// 表单项内容区域的水平方向对齐方式。
enum TFormItemContentAlignment {
  /// 内容靠起始侧对齐。
  start,

  /// 内容靠结束侧对齐。
  end,
}

/// TForm 组件级 ThemeExtension。
///
/// 主题过渡中，布局、对齐和必填标记位置在进度 0.5 处切换；
/// 标签宽度、表单项内边距、项间距和标签间距分别按 80、四周 16、0、8
/// 逻辑像素补空值后插值。
///
/// {@category ComponentTheme}
class TFormThemeData extends ThemeExtension<TFormThemeData> {
  const TFormThemeData({
    this.showColon,
    this.labelWidth,
    this.layout,
    this.labelAlign,
    this.requiredMarkPosition,
    this.labelStyle,
    this.requiredMarkStyle,
    this.helpStyle,
    this.errorStyle,
    this.backgroundColor,
    this.borderColor,
    this.itemPadding,
    this.itemSpacing,
    this.labelGap,
    this.leadingGap,
    this.messageGap,
  });

  /// 是否在标签末尾显示冒号。
  final bool? showColon;

  /// 默认标签宽度；为空时表单项使用 80dp。
  final double? labelWidth;

  /// 表单项布局方向。
  /// 未配置时为 TFormLayout.horizontal。
  final TFormLayout? layout;

  /// 标签对齐方式；默认 TextAlign.start，随文字方向对齐起始侧。
  final TextAlign? labelAlign;

  /// 必填标记位置。
  /// null 时使用 TFormRequiredMarkPosition.left。
  final TFormRequiredMarkPosition? requiredMarkPosition;

  /// 标签样式。
  final TextStyle? labelStyle;

  /// 必填标记样式。
  final TextStyle? requiredMarkStyle;

  /// 辅助说明样式。
  final TextStyle? helpStyle;

  /// 错误文案样式。
  final TextStyle? errorStyle;

  /// 表单及表单项背景色。
  /// null 时使用 bgColorContainer Token。
  final Color? backgroundColor;

  /// 表单项底部分隔线颜色。
  /// null 时使用 componentStroke Token。
  final Color? borderColor;

  /// 表单项内边距。
  /// 未配置时左右为 16 逻辑像素；水平布局上下为 14，垂直布局上下为 16。
  final EdgeInsetsGeometry? itemPadding;

  /// 表单项间距。
  /// 未配置时为 0。
  final double? itemSpacing;

  /// 标签与字段的垂直间距。
  /// 未配置时为 8 逻辑像素。
  final double? labelGap;

  /// 前置内容与标签区域的间距。
  /// 未配置时使用 spacer Token。
  final double? leadingGap;

  /// 字段与辅助或错误文案的间距。
  /// 未配置时为 4 逻辑像素。
  final double? messageGap;

  /// 复制主题配置。
  ///
  /// ## 返回值
  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TFormThemeData copyWith({
    bool? showColon,
    double? labelWidth,
    TFormLayout? layout,
    TextAlign? labelAlign,
    TFormRequiredMarkPosition? requiredMarkPosition,
    TextStyle? labelStyle,
    TextStyle? requiredMarkStyle,
    TextStyle? helpStyle,
    TextStyle? errorStyle,
    Color? backgroundColor,
    Color? borderColor,
    EdgeInsetsGeometry? itemPadding,
    double? itemSpacing,
    double? labelGap,
    double? leadingGap,
    double? messageGap,
  }) {
    return TFormThemeData(
      showColon: showColon ?? this.showColon,
      labelWidth: labelWidth ?? this.labelWidth,
      layout: layout ?? this.layout,
      labelAlign: labelAlign ?? this.labelAlign,
      requiredMarkPosition: requiredMarkPosition ?? this.requiredMarkPosition,
      labelStyle: labelStyle ?? this.labelStyle,
      requiredMarkStyle: requiredMarkStyle ?? this.requiredMarkStyle,
      helpStyle: helpStyle ?? this.helpStyle,
      errorStyle: errorStyle ?? this.errorStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      itemPadding: itemPadding ?? this.itemPadding,
      itemSpacing: itemSpacing ?? this.itemSpacing,
      labelGap: labelGap ?? this.labelGap,
      leadingGap: leadingGap ?? this.leadingGap,
      messageGap: messageGap ?? this.messageGap,
    );
  }

  /// 生成主题过渡配置。
  ///
  /// ## 返回值
  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TFormThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TFormThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TFormThemeData) {
      return this;
    }
    return TFormThemeData(
      showColon: t < 0.5 ? showColon : other.showColon,
      labelWidth: _lerpDoubleWithDefault(labelWidth, other.labelWidth, t, 80),
      layout: t < 0.5 ? layout : other.layout,
      labelAlign: t < 0.5 ? labelAlign : other.labelAlign,
      requiredMarkPosition: t < 0.5
          ? requiredMarkPosition
          : other.requiredMarkPosition,
      labelStyle: _lerpNullable(
        labelStyle,
        other.labelStyle,
        t,
        TextStyle.lerp,
      ),
      requiredMarkStyle: _lerpNullable(
        requiredMarkStyle,
        other.requiredMarkStyle,
        t,
        TextStyle.lerp,
      ),
      helpStyle: _lerpNullable(helpStyle, other.helpStyle, t, TextStyle.lerp),
      errorStyle: _lerpNullable(
        errorStyle,
        other.errorStyle,
        t,
        TextStyle.lerp,
      ),
      backgroundColor: _lerpNullable(
        backgroundColor,
        other.backgroundColor,
        t,
        Color.lerp,
      ),
      borderColor: _lerpNullable(borderColor, other.borderColor, t, Color.lerp),
      itemPadding: _lerpEdgeInsetsWithDefault(
        itemPadding,
        other.itemPadding,
        t,
        const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      itemSpacing: _lerpDoubleWithDefault(itemSpacing, other.itemSpacing, t, 0),
      labelGap: _lerpDoubleWithDefault(labelGap, other.labelGap, t, 8),
      leadingGap: _lerpNullable(leadingGap, other.leadingGap, t, lerpDouble),
      messageGap: _lerpNullable(messageGap, other.messageGap, t, lerpDouble),
    );
  }
}

double? _lerpDoubleWithDefault(
  double? begin,
  double? end,
  double t,
  double defaultValue,
) {
  if (begin == null && end == null) {
    return null;
  }
  return lerpDouble(begin ?? defaultValue, end ?? defaultValue, t);
}

EdgeInsetsGeometry? _lerpEdgeInsetsWithDefault(
  EdgeInsetsGeometry? begin,
  EdgeInsetsGeometry? end,
  double t,
  EdgeInsetsGeometry defaultValue,
) {
  if (begin == null && end == null) {
    return null;
  }
  return EdgeInsetsGeometry.lerp(begin ?? defaultValue, end ?? defaultValue, t);
}

T? _lerpNullable<T>(
  T? begin,
  T? end,
  double t,
  T? Function(T?, T?, double) lerp,
) {
  if (begin == null || end == null) {
    return t < 0.5 ? begin : end;
  }
  return lerp(begin, end, t);
}

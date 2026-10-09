import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TDivider 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认样式。
/// 布局、内容和虚线选择由实例控制；视觉值从本主题读取，未配置时回退
/// TDesign Token 或组件内置值，不读取 Material DividerTheme。
///
/// {@category ComponentTheme}
class TDividerThemeData extends ThemeExtension<TDividerThemeData> {
  /// 线条颜色；未设置时使用 `bgColorComponent` Token。
  final Color? color;

  /// 线粗：横线 = 高度，竖线 = 宽度（默认 0.5）
  final double? thickness;

  /// 外边距。未设置时，水平分割线使用上下 10dp，垂直分割线使用左右 16dp。
  final EdgeInsetsGeometry? margin;

  /// 线与中间内容之间的间距，默认左右各使用 `spacer1`（12dp）。
  final EdgeInsetsGeometry? gapPadding;

  /// child 为文本时的默认样式，覆盖 `fontBodySmall` / `textColorPlaceholder` Token。
  final TextStyle? textStyle;

  /// 纯水平线起始侧缩进；未设置时为 0，带内容或垂直线时不生效。
  final double? indent;

  /// 纯水平线结束侧缩进；未设置时为 0，带内容或垂直线时不生效。
  final double? endIndent;

  const TDividerThemeData({
    this.color,
    this.thickness,
    this.margin,
    this.gapPadding,
    this.textStyle,
    this.indent,
    this.endIndent,
  });

  /// 复制主题配置。
  ///
  /// ## 返回值
  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TDividerThemeData copyWith({
    Color? color,
    double? thickness,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? gapPadding,
    TextStyle? textStyle,
    double? indent,
    double? endIndent,
  }) {
    return TDividerThemeData(
      color: color ?? this.color,
      thickness: thickness ?? this.thickness,
      margin: margin ?? this.margin,
      gapPadding: gapPadding ?? this.gapPadding,
      textStyle: textStyle ?? this.textStyle,
      indent: indent ?? this.indent,
      endIndent: endIndent ?? this.endIndent,
    );
  }

  /// 生成主题过渡配置。
  ///
  /// ## 返回值
  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TDividerThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TDividerThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TDividerThemeData) {
      return this;
    }
    return TDividerThemeData(
      color: t < 0.5 ? color : other.color,
      thickness: lerpDouble(thickness, other.thickness, t),
      margin: EdgeInsetsGeometry.lerp(margin, other.margin, t),
      gapPadding: EdgeInsetsGeometry.lerp(gapPadding, other.gapPadding, t),
      textStyle: t < 0.5 ? textStyle : other.textStyle,
      indent: lerpDouble(indent, other.indent, t),
      endIndent: lerpDouble(endIndent, other.endIndent, t),
    );
  }
}

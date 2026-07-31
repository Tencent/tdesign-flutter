import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TDivider 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认样式。
/// 构造器参数优先于 Theme（L1/L2 > Theme > DividerTheme > Token）。
class TDividerThemeData extends ThemeExtension<TDividerThemeData> {
  /// 线条颜色
  final Color? color;

  /// 线粗：横线 = 高度，竖线 = 宽度（默认 0.5）
  final double? thickness;

  /// 外边距
  final EdgeInsetsGeometry? margin;

  /// 线与中间内容之间的间距（默认 horizontal: 8）
  final EdgeInsetsGeometry? gapPadding;

  /// child 为文本时的默认样式
  final TextStyle? textStyle;

  /// 左缩进（对齐 Material [DividerThemeData.indent] 语义）
  final double? indent;

  /// 右缩进（对齐 Material [DividerThemeData.endIndent] 语义）
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

  @override
  TDividerThemeData lerp(ThemeExtension<TDividerThemeData>? other, double t) {
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

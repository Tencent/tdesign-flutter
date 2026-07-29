import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// 表格组件级 ThemeExtension。
///
/// 仅保存表格的视觉默认值。
class TTableThemeData extends ThemeExtension<TTableThemeData> {
  const TTableThemeData({
    this.bordered,
    this.stripe,
    this.rowHeight,
    this.headerHeight,
    this.width,
    this.backgroundColor,
    this.headerColor,
    this.stripeColor,
    this.borderColor,
    this.cellPadding,
  });

  /// 是否显示单元格边框。
  final bool? bordered;

  /// 是否显示斑马纹。
  final bool? stripe;

  /// 数据行高度。
  final double? rowHeight;

  /// 表头高度。
  final double? headerHeight;

  /// 表格宽度。
  final double? width;

  /// 默认行背景色。
  final Color? backgroundColor;

  /// 表头背景色。
  final Color? headerColor;

  /// 斑马纹背景色。
  final Color? stripeColor;

  /// 边框颜色。
  final Color? borderColor;

  /// 单元格内边距。
  final EdgeInsetsGeometry? cellPadding;

  @override
  TTableThemeData copyWith({
    bool? bordered,
    bool? stripe,
    double? rowHeight,
    double? headerHeight,
    double? width,
    Color? backgroundColor,
    Color? headerColor,
    Color? stripeColor,
    Color? borderColor,
    EdgeInsetsGeometry? cellPadding,
  }) {
    return TTableThemeData(
      bordered: bordered ?? this.bordered,
      stripe: stripe ?? this.stripe,
      rowHeight: rowHeight ?? this.rowHeight,
      headerHeight: headerHeight ?? this.headerHeight,
      width: width ?? this.width,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      headerColor: headerColor ?? this.headerColor,
      stripeColor: stripeColor ?? this.stripeColor,
      borderColor: borderColor ?? this.borderColor,
      cellPadding: cellPadding ?? this.cellPadding,
    );
  }

  @override
  TTableThemeData lerp(TTableThemeData? other, double t) {
    if (other == null) {
      return this;
    }
    return TTableThemeData(
      bordered: t < 0.5 ? bordered : other.bordered,
      stripe: t < 0.5 ? stripe : other.stripe,
      rowHeight: lerpDouble(rowHeight, other.rowHeight, t),
      headerHeight: lerpDouble(headerHeight, other.headerHeight, t),
      width: lerpDouble(width, other.width, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      headerColor: Color.lerp(headerColor, other.headerColor, t),
      stripeColor: Color.lerp(stripeColor, other.stripeColor, t),
      borderColor: Color.lerp(borderColor, other.borderColor, t),
      cellPadding: EdgeInsetsGeometry.lerp(cellPadding, other.cellPadding, t),
    );
  }
}

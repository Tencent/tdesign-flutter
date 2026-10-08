import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// 表格组件级 ThemeExtension。
///
/// 仅保存表格的视觉默认值。
class TTableThemeData extends ThemeExtension<TTableThemeData> {
  const TTableThemeData({
    this.rowHeight,
    this.headerHeight,
    this.width,
    this.backgroundColor,
    this.headerColor,
    this.stripeColor,
    this.borderColor,
    this.cellPadding,
  });

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

  /// 复制主题配置。
  ///
  /// ## 返回值
  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TTableThemeData copyWith({
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

  /// 生成主题过渡配置。
  ///
  /// ## 返回值
  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TTableThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    TTableThemeData? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other == null) {
      return this;
    }
    return TTableThemeData(
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

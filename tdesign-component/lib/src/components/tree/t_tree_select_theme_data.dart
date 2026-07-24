import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TTreeSelect 组件级 ThemeExtension。
class TTreeSelectThemeData extends ThemeExtension<TTreeSelectThemeData> {
  const TTreeSelectThemeData({
    /// 面板高度。
    this.height,

    /// 根列宽度。
    this.rootColumnWidth,

    /// 子列宽度。
    this.columnWidth,

    /// 单项最小高度。
    this.itemHeight,

    /// 面板背景色。
    this.backgroundColor,

    /// 根列背景色。
    this.rootBackgroundColor,

    /// 选中项背景色。
    this.selectedBackgroundColor,

    /// 普通文案样式。
    this.textStyle,

    /// 选中文案样式。
    this.selectedTextStyle,

    /// 禁用文案样式。
    this.disabledTextStyle,

    /// 选中图标颜色。
    this.indicatorColor,
  });

  /// 面板高度。
  final double? height;

  /// 根列宽度。
  final double? rootColumnWidth;

  /// 子列宽度。
  final double? columnWidth;

  /// 单项最小高度。
  final double? itemHeight;

  /// 面板背景色。
  final Color? backgroundColor;

  /// 根列背景色。
  final Color? rootBackgroundColor;

  /// 选中项背景色。
  final Color? selectedBackgroundColor;

  /// 普通文案样式。
  final TextStyle? textStyle;

  /// 选中文案样式。
  final TextStyle? selectedTextStyle;

  /// 禁用文案样式。
  final TextStyle? disabledTextStyle;

  /// 选中图标颜色。
  final Color? indicatorColor;

  @override
  TTreeSelectThemeData copyWith({
    double? height,
    double? rootColumnWidth,
    double? columnWidth,
    double? itemHeight,
    Color? backgroundColor,
    Color? rootBackgroundColor,
    Color? selectedBackgroundColor,
    TextStyle? textStyle,
    TextStyle? selectedTextStyle,
    TextStyle? disabledTextStyle,
    Color? indicatorColor,
  }) {
    return TTreeSelectThemeData(
      height: height ?? this.height,
      rootColumnWidth: rootColumnWidth ?? this.rootColumnWidth,
      columnWidth: columnWidth ?? this.columnWidth,
      itemHeight: itemHeight ?? this.itemHeight,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      rootBackgroundColor: rootBackgroundColor ?? this.rootBackgroundColor,
      selectedBackgroundColor:
          selectedBackgroundColor ?? this.selectedBackgroundColor,
      textStyle: textStyle ?? this.textStyle,
      selectedTextStyle: selectedTextStyle ?? this.selectedTextStyle,
      disabledTextStyle: disabledTextStyle ?? this.disabledTextStyle,
      indicatorColor: indicatorColor ?? this.indicatorColor,
    );
  }

  @override
  TTreeSelectThemeData lerp(
    ThemeExtension<TTreeSelectThemeData>? other,
    double t,
  ) {
    if (other is! TTreeSelectThemeData) {
      return this;
    }
    return TTreeSelectThemeData(
      height: lerpDouble(height, other.height, t),
      rootColumnWidth: lerpDouble(rootColumnWidth, other.rootColumnWidth, t),
      columnWidth: lerpDouble(columnWidth, other.columnWidth, t),
      itemHeight: lerpDouble(itemHeight, other.itemHeight, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      rootBackgroundColor:
          Color.lerp(rootBackgroundColor, other.rootBackgroundColor, t),
      selectedBackgroundColor: Color.lerp(
        selectedBackgroundColor,
        other.selectedBackgroundColor,
        t,
      ),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      selectedTextStyle:
          TextStyle.lerp(selectedTextStyle, other.selectedTextStyle, t),
      disabledTextStyle:
          TextStyle.lerp(disabledTextStyle, other.disabledTextStyle, t),
      indicatorColor: Color.lerp(indicatorColor, other.indicatorColor, t),
    );
  }
}

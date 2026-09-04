import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// 级联导航展示形态。
enum TCascaderVariant {
  /// 纵向步骤导航。
  step,

  /// 横向标签导航。
  tab,
}

/// TCascader 组件级 ThemeExtension。
class TCascaderThemeData extends ThemeExtension<TCascaderThemeData> {
  const TCascaderThemeData({
    /// 组件高度。
    this.height,

    /// 背景色。
    this.backgroundColor,

    /// 圆角。
    this.borderRadius,

    /// 普通文案样式。
    this.textStyle,

    /// 当前活动导航文案样式。
    this.activeTextStyle,

    /// 禁用文案样式。
    this.disabledTextStyle,

    /// 末级选中图标颜色。
    this.indicatorColor,

    /// 导航区域内边距。
    this.navigationPadding,

    /// 分隔线颜色。
    this.dividerColor,
  });

  /// 组件高度。
  final double? height;

  /// 背景色。
  final Color? backgroundColor;

  /// 圆角。
  final double? borderRadius;

  /// 普通文案样式。
  final TextStyle? textStyle;

  /// 当前活动导航文案样式。
  final TextStyle? activeTextStyle;

  /// 禁用文案样式。
  final TextStyle? disabledTextStyle;

  /// 末级选中图标颜色。
  final Color? indicatorColor;

  /// 导航区域内边距。
  final EdgeInsetsGeometry? navigationPadding;

  /// 分隔线颜色。
  final Color? dividerColor;

  @override
  TCascaderThemeData copyWith({
    double? height,
    Color? backgroundColor,
    double? borderRadius,
    TextStyle? textStyle,
    TextStyle? activeTextStyle,
    TextStyle? disabledTextStyle,
    Color? indicatorColor,
    EdgeInsetsGeometry? navigationPadding,
    Color? dividerColor,
  }) {
    return TCascaderThemeData(
      height: height ?? this.height,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      textStyle: textStyle ?? this.textStyle,
      activeTextStyle: activeTextStyle ?? this.activeTextStyle,
      disabledTextStyle: disabledTextStyle ?? this.disabledTextStyle,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      navigationPadding: navigationPadding ?? this.navigationPadding,
      dividerColor: dividerColor ?? this.dividerColor,
    );
  }

  @override
  TCascaderThemeData lerp(ThemeExtension<TCascaderThemeData>? other, double t) {
    if (other is! TCascaderThemeData) {
      return this;
    }
    return TCascaderThemeData(
      height: lerpDouble(height, other.height, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      activeTextStyle: TextStyle.lerp(
        activeTextStyle,
        other.activeTextStyle,
        t,
      ),
      disabledTextStyle: TextStyle.lerp(
        disabledTextStyle,
        other.disabledTextStyle,
        t,
      ),
      indicatorColor: Color.lerp(indicatorColor, other.indicatorColor, t),
      navigationPadding: EdgeInsetsGeometry.lerp(
        navigationPadding,
        other.navigationPadding,
        t,
      ),
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t),
    );
  }
}

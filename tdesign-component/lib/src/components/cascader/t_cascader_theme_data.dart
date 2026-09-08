import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

const double _defaultCascaderHeight = 360;

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

    /// 当前活动导航及已选选项文案样式。
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

  /// 当前活动导航及已选选项文案样式。
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
      height: height == null && other.height == null
          ? null
          : lerpDouble(
              height ?? _defaultCascaderHeight,
              other.height ?? _defaultCascaderHeight,
              t,
            ),
      backgroundColor: _lerpNullableOverride(
        backgroundColor,
        other.backgroundColor,
        t,
        Color.lerp,
      ),
      borderRadius: _lerpNullableOverride(
        borderRadius,
        other.borderRadius,
        t,
        lerpDouble,
      ),
      textStyle: _lerpNullableOverride(
        textStyle,
        other.textStyle,
        t,
        TextStyle.lerp,
      ),
      activeTextStyle: _lerpNullableOverride(
        activeTextStyle,
        other.activeTextStyle,
        t,
        TextStyle.lerp,
      ),
      disabledTextStyle: _lerpNullableOverride(
        disabledTextStyle,
        other.disabledTextStyle,
        t,
        TextStyle.lerp,
      ),
      indicatorColor: _lerpNullableOverride(
        indicatorColor,
        other.indicatorColor,
        t,
        Color.lerp,
      ),
      navigationPadding: _lerpNullableOverride(
        navigationPadding,
        other.navigationPadding,
        t,
        EdgeInsetsGeometry.lerp,
      ),
      dividerColor: _lerpNullableOverride(
        dividerColor,
        other.dividerColor,
        t,
        Color.lerp,
      ),
    );
  }
}

T? _lerpNullableOverride<T>(
  T? from,
  T? to,
  double t,
  T? Function(T?, T?, double) lerp,
) {
  if (from == null || to == null) {
    return t < 0.5 ? from : to;
  }
  return lerp(from, to, t);
}

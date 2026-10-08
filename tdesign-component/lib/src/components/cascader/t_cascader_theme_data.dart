import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 't_cascader_defaults.dart';

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
    this.height,
    this.backgroundColor,
    this.borderRadius,
    this.textStyle,
    this.activeTextStyle,
    this.disabledTextStyle,
    this.indicatorColor,
    this.navigationPadding,
    this.dividerColor,
  });

  /// 组件高度。
  /// 未配置时为 360 逻辑像素。
  final double? height;

  /// 背景色。
  /// 未配置时使用 bgColorContainer Token。
  final Color? backgroundColor;

  /// 圆角。
  /// 未配置时使用 radiusDefault Token。
  final double? borderRadius;

  /// 普通文案样式。
  final TextStyle? textStyle;

  /// 当前活动导航及已选选项文案样式。
  final TextStyle? activeTextStyle;

  /// 禁用文案样式。
  final TextStyle? disabledTextStyle;

  /// 末级选中图标颜色。
  /// 未配置时使用 brandColor Token。
  final Color? indicatorColor;

  /// 导航区域内边距。
  final EdgeInsetsGeometry? navigationPadding;

  /// 分隔线颜色。
  /// 未配置时使用 componentStroke Token。
  final Color? dividerColor;

  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
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

  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TCascaderThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TCascaderThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TCascaderThemeData) {
      return this;
    }
    return TCascaderThemeData(
      height: height == null && other.height == null
          ? null
          : lerpDouble(
              height ?? defaultCascaderHeight,
              other.height ?? defaultCascaderHeight,
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

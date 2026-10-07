import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TRadio 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树默认样式。
class TRadioThemeData extends ThemeExtension<TRadioThemeData> {
  /// 选择颜色
  final Color? selectColor;

  /// 禁用颜色
  final Color? disableColor;

  /// 标题文字颜色
  final Color? titleColor;

  /// 副标题文字颜色
  final Color? subTitleColor;

  /// 背景颜色
  final Color? backgroundColor;

  /// icon和文字的距离
  final double? spacing;

  /// 文字和非图标侧的距离
  final double? insetSpacing;

  const TRadioThemeData({
    /// 选中态颜色。
    this.selectColor,

    /// 禁用态颜色。
    this.disableColor,

    /// 主标题颜色。
    this.titleColor,

    /// 副标题颜色。
    this.subTitleColor,

    /// 卡片背景颜色。
    this.backgroundColor,

    /// 指示器与文案间距。
    this.spacing,

    /// 文案与非指示器侧的内边距。
    this.insetSpacing,
  });

  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TRadioThemeData copyWith({
    Color? selectColor,
    Color? disableColor,
    Color? titleColor,
    Color? subTitleColor,
    Color? backgroundColor,
    double? spacing,
    double? insetSpacing,
  }) {
    final resolvedSelectColor = selectColor ?? this.selectColor;
    final resolvedDisableColor = disableColor ?? this.disableColor;
    final resolvedTitleColor = titleColor ?? this.titleColor;
    final resolvedSubTitleColor = subTitleColor ?? this.subTitleColor;
    final resolvedBackgroundColor = backgroundColor ?? this.backgroundColor;
    final resolvedSpacing = spacing ?? this.spacing;
    final resolvedInsetSpacing = insetSpacing ?? this.insetSpacing;
    return TRadioThemeData(
      selectColor: resolvedSelectColor,
      disableColor: resolvedDisableColor,
      titleColor: resolvedTitleColor,
      subTitleColor: resolvedSubTitleColor,
      backgroundColor: resolvedBackgroundColor,
      spacing: resolvedSpacing,
      insetSpacing: resolvedInsetSpacing,
    );
  }

  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TRadioThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TRadioThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TRadioThemeData) {
      return this;
    }
    return TRadioThemeData(
      selectColor: Color.lerp(selectColor, other.selectColor, t),
      disableColor: Color.lerp(disableColor, other.disableColor, t),
      titleColor: Color.lerp(titleColor, other.titleColor, t),
      subTitleColor: Color.lerp(subTitleColor, other.subTitleColor, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      spacing: lerpDouble(spacing, other.spacing, t),
      insetSpacing: lerpDouble(insetSpacing, other.insetSpacing, t),
    );
  }
}

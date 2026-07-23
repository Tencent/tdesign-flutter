import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TCheckbox 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树默认样式。
/// 被 TCheckbox 和 TCheckboxGroup 共用。
class TCheckboxThemeData extends ThemeExtension<TCheckboxThemeData> {
  /// 复选框指示器的默认视觉变体。
  final TCheckboxVariant? variant;

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

  /// 自定义组件间距
  final EdgeInsetsGeometry? customSpace;

  const TCheckboxThemeData({
    /// 复选框指示器的默认视觉变体。
    this.variant,

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

    /// 内容区域内边距。
    this.customSpace,
  });

  @override
  TCheckboxThemeData copyWith({
    TCheckboxVariant? variant,
    Color? selectColor,
    Color? disableColor,
    Color? titleColor,
    Color? subTitleColor,
    Color? backgroundColor,
    double? spacing,
    double? insetSpacing,
    EdgeInsetsGeometry? customSpace,
  }) {
    final resolvedVariant = variant ?? this.variant;
    final resolvedSelectColor = selectColor ?? this.selectColor;
    final resolvedDisableColor = disableColor ?? this.disableColor;
    final resolvedTitleColor = titleColor ?? this.titleColor;
    final resolvedSubTitleColor = subTitleColor ?? this.subTitleColor;
    final resolvedBackgroundColor = backgroundColor ?? this.backgroundColor;
    final resolvedSpacing = spacing ?? this.spacing;
    final resolvedInsetSpacing = insetSpacing ?? this.insetSpacing;
    final resolvedCustomSpace = customSpace ?? this.customSpace;
    return TCheckboxThemeData(
      variant: resolvedVariant,
      selectColor: resolvedSelectColor,
      disableColor: resolvedDisableColor,
      titleColor: resolvedTitleColor,
      subTitleColor: resolvedSubTitleColor,
      backgroundColor: resolvedBackgroundColor,
      spacing: resolvedSpacing,
      insetSpacing: resolvedInsetSpacing,
      customSpace: resolvedCustomSpace,
    );
  }

  @override
  TCheckboxThemeData lerp(ThemeExtension<TCheckboxThemeData>? other, double t) {
    if (other is! TCheckboxThemeData) {
      return this;
    }
    if (t == 0) {
      return this;
    }
    if (t == 1) {
      return other;
    }
    return TCheckboxThemeData(
      variant: t <= 0.5 ? variant : other.variant,
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

/// 复选框指示器的视觉变体。
enum TCheckboxVariant {
  /// 圆形指示器。
  circle,

  /// 方形指示器。
  square,

  /// 仅显示勾选或半选图标。
  check,
}

import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TCheckbox 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树默认样式。
/// 被 TCheckbox 和 TCheckboxGroup 共用。
class TCheckboxThemeData extends ThemeExtension<TCheckboxThemeData> {
  /// 复选框指示器的默认视觉变体；未设置时使用圆形。
  final TCheckboxVariant? variant;

  /// 选中态颜色。
  /// null 时使用 brandColor Token。
  final Color? selectColor;

  /// 禁用态指示器的前景色；未选时用于描边色。
  final Color? disableColor;

  /// 主标题颜色。
  /// 启用态 null 时使用 textColorPrimary Token；禁用态始终使用 textColorDisabled。
  final Color? titleColor;

  /// 副标题颜色。
  /// 启用态 null 时使用 textColorSecondary Token；禁用态始终使用 textColorDisabled。
  final Color? subTitleColor;

  /// 卡片背景颜色。
  /// 卡片模式下生效；null 时使用 bgColorContainer Token。
  final Color? backgroundColor;

  /// 指示器与文案间距。
  /// null 时使用 spacer Token。
  final double? spacing;

  /// 文案与非指示器侧的内边距。
  /// null 时使用 spacer2 Token。
  final double? insetSpacing;

  /// 内容区域内边距。
  /// null 时按是否有文案、卡片模式及当前字号计算内边距；纯指示器不增加文案内边距。
  final EdgeInsetsGeometry? customSpace;

  const TCheckboxThemeData({
    this.variant,
    this.selectColor,
    this.disableColor,
    this.titleColor,
    this.subTitleColor,
    this.backgroundColor,
    this.spacing,
    this.insetSpacing,
    this.customSpace,
  });

  /// 复制主题配置。
  ///
  /// ## 返回值
  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
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

  /// 生成主题过渡配置。
  ///
  /// ## 返回值
  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TCheckboxThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TCheckboxThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
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
      customSpace: EdgeInsetsGeometry.lerp(customSpace, other.customSpace, t),
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

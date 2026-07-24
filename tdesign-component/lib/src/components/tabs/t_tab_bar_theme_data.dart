import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TabsBar 形态枚举。
enum TTabsBarVariant {
  /// 填充样式
  filled,

  /// 胶囊样式
  capsule,

  /// 卡片
  card,
}

/// TabBar 组件 ThemeExtension
///
/// 管理 TTabsBar 的子树级视觉默认样式。
class TTabsBarThemeData extends ThemeExtension<TTabsBarThemeData> {
  /// 栏背景色。
  final Color? backgroundColor;

  /// 选中标签文字样式。
  final TextStyle? labelStyle;

  /// 未选中标签文字样式。
  final TextStyle? unselectedLabelStyle;

  /// 标签内容边距。
  final EdgeInsetsGeometry? labelPadding;

  /// 默认指示器；为空时不展示。
  final Decoration? indicator;

  /// 分割线颜色。
  final Color? dividerColor;

  /// 分割线高度；小于等于 0 时不展示。
  final double? dividerHeight;

  /// capsule 形态下的选中背景色。
  final Color? selectedBgColor;

  /// capsule 形态下的未选中背景色。
  final Color? unSelectedBgColor;

  const TTabsBarThemeData({
    this.backgroundColor,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.labelPadding,
    this.indicator,
    this.dividerColor,
    this.dividerHeight,
    this.selectedBgColor,
    this.unSelectedBgColor,
  });

  @override
  TTabsBarThemeData copyWith({
    Color? backgroundColor,
    TextStyle? labelStyle,
    TextStyle? unselectedLabelStyle,
    EdgeInsetsGeometry? labelPadding,
    Decoration? indicator,
    Color? dividerColor,
    double? dividerHeight,
    Color? selectedBgColor,
    Color? unSelectedBgColor,
  }) {
    return TTabsBarThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      labelStyle: labelStyle ?? this.labelStyle,
      unselectedLabelStyle: unselectedLabelStyle ?? this.unselectedLabelStyle,
      labelPadding: labelPadding ?? this.labelPadding,
      indicator: indicator ?? this.indicator,
      dividerColor: dividerColor ?? this.dividerColor,
      dividerHeight: dividerHeight ?? this.dividerHeight,
      selectedBgColor: selectedBgColor ?? this.selectedBgColor,
      unSelectedBgColor: unSelectedBgColor ?? this.unSelectedBgColor,
    );
  }

  @override
  TTabsBarThemeData lerp(ThemeExtension<TTabsBarThemeData>? other, double t) {
    if (other is! TTabsBarThemeData) {
      return this;
    }
    return TTabsBarThemeData(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      labelStyle: t < 0.5 ? labelStyle : other.labelStyle,
      unselectedLabelStyle:
          t < 0.5 ? unselectedLabelStyle : other.unselectedLabelStyle,
      labelPadding: t < 0.5 ? labelPadding : other.labelPadding,
      indicator: t < 0.5 ? indicator : other.indicator,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t),
      dividerHeight: lerpDouble(dividerHeight, other.dividerHeight, t),
      selectedBgColor: Color.lerp(selectedBgColor, other.selectedBgColor, t),
      unSelectedBgColor:
          Color.lerp(unSelectedBgColor, other.unSelectedBgColor, t),
    );
  }
}

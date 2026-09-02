import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TabsBar 形态枚举。
enum TTabsBarVariant {
  /// 底部指示器样式。
  line,

  /// 胶囊标签样式。
  tag,

  /// 卡片样式。
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

  /// 禁用标签文字和图标样式。
  final TextStyle? disabledLabelStyle;

  /// 标签内容边距。
  final EdgeInsetsGeometry? labelPadding;

  /// 组件主题指示器；非空时覆盖内置形态指示器。
  ///
  /// 为空时 Line 使用 TDesign 默认指示器，Tag 与 Card 不展示指示器。
  final Decoration? indicator;

  /// 分割线颜色。
  final Color? dividerColor;

  /// 分割线高度；小于等于 0 时不展示。
  final double? dividerHeight;

  /// Tag 形态下的选中背景色。
  final Color? selectedTagBackgroundColor;

  /// Tag 形态下的默认背景色。
  final Color? tagBackgroundColor;

  const TTabsBarThemeData({
    this.backgroundColor,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.disabledLabelStyle,
    this.labelPadding,
    this.indicator,
    this.dividerColor,
    this.dividerHeight,
    this.selectedTagBackgroundColor,
    this.tagBackgroundColor,
  });

  @override
  TTabsBarThemeData copyWith({
    Color? backgroundColor,
    TextStyle? labelStyle,
    TextStyle? unselectedLabelStyle,
    TextStyle? disabledLabelStyle,
    EdgeInsetsGeometry? labelPadding,
    Decoration? indicator,
    Color? dividerColor,
    double? dividerHeight,
    Color? selectedTagBackgroundColor,
    Color? tagBackgroundColor,
  }) {
    return TTabsBarThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      labelStyle: labelStyle ?? this.labelStyle,
      unselectedLabelStyle: unselectedLabelStyle ?? this.unselectedLabelStyle,
      disabledLabelStyle: disabledLabelStyle ?? this.disabledLabelStyle,
      labelPadding: labelPadding ?? this.labelPadding,
      indicator: indicator ?? this.indicator,
      dividerColor: dividerColor ?? this.dividerColor,
      dividerHeight: dividerHeight ?? this.dividerHeight,
      selectedTagBackgroundColor:
          selectedTagBackgroundColor ?? this.selectedTagBackgroundColor,
      tagBackgroundColor: tagBackgroundColor ?? this.tagBackgroundColor,
    );
  }

  @override
  TTabsBarThemeData lerp(ThemeExtension<TTabsBarThemeData>? other, double t) {
    if (other is! TTabsBarThemeData) {
      return this;
    }
    return TTabsBarThemeData(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, t),
      unselectedLabelStyle: TextStyle.lerp(
        unselectedLabelStyle,
        other.unselectedLabelStyle,
        t,
      ),
      disabledLabelStyle: TextStyle.lerp(
        disabledLabelStyle,
        other.disabledLabelStyle,
        t,
      ),
      labelPadding: EdgeInsetsGeometry.lerp(
        labelPadding,
        other.labelPadding,
        t,
      ),
      indicator: Decoration.lerp(indicator, other.indicator, t),
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t),
      dividerHeight: lerpDouble(dividerHeight, other.dividerHeight, t),
      selectedTagBackgroundColor: Color.lerp(
        selectedTagBackgroundColor,
        other.selectedTagBackgroundColor,
        t,
      ),
      tagBackgroundColor: Color.lerp(
        tagBackgroundColor,
        other.tagBackgroundColor,
        t,
      ),
    );
  }
}

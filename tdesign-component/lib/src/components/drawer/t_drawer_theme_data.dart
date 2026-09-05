import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// 抽屉组件 ThemeExtension。
///
/// 只保存子树级具体视觉默认值。方向、蒙层与展示生命周期由 `showTDrawer`
/// 负责；分隔线和按压反馈由组件实例负责；构造器具体视觉参数优先级高于 ThemeData。
class TDrawerThemeData extends ThemeExtension<TDrawerThemeData> {
  /// 默认宽度，默认 280。
  final double? width;

  /// 默认背景颜色。
  final Color? backgroundColor;

  /// 抽屉标题样式。
  final TextStyle? titleStyle;

  /// 标题内边距，默认 `EdgeInsets.fromLTRB(16, 24, 16, 8)`。
  final EdgeInsetsGeometry? titlePadding;

  /// 菜单正文样式。
  final TextStyle? itemTextStyle;

  /// 菜单项背景色。
  final Color? itemBackgroundColor;

  /// 菜单项按压背景色。
  final Color? itemPressedColor;

  /// 菜单项内边距，默认 `EdgeInsets.fromLTRB(16, 16, 0, 16)`。
  final EdgeInsetsGeometry? itemPadding;

  /// 菜单项图标颜色。
  final Color? itemIconColor;

  /// 菜单项图标尺寸，默认 24。
  final double? itemIconSize;

  /// 菜单项图标与正文间距，默认 8。
  final double? itemIconGap;

  /// 菜单项分隔线颜色。
  final Color? dividerColor;

  /// 菜单项分隔线起始缩进，默认 16。
  final double? dividerIndent;

  /// 菜单项分隔线厚度，默认 0.5。
  final double? dividerThickness;

  /// 底部区内边距，默认仅保留 20 的底边距。
  final EdgeInsetsGeometry? footerPadding;

  const TDrawerThemeData({
    this.width,
    this.backgroundColor,
    this.titleStyle,
    this.titlePadding,
    this.itemTextStyle,
    this.itemBackgroundColor,
    this.itemPressedColor,
    this.itemPadding,
    this.itemIconColor,
    this.itemIconSize,
    this.itemIconGap,
    this.dividerColor,
    this.dividerIndent,
    this.dividerThickness,
    this.footerPadding,
  }) : assert(width == null || width > 0),
       assert(itemIconSize == null || itemIconSize >= 0),
       assert(itemIconGap == null || itemIconGap >= 0),
       assert(dividerIndent == null || dividerIndent >= 0),
       assert(dividerThickness == null || dividerThickness >= 0);

  @override
  TDrawerThemeData copyWith({
    double? width,
    Color? backgroundColor,
    TextStyle? titleStyle,
    EdgeInsetsGeometry? titlePadding,
    TextStyle? itemTextStyle,
    Color? itemBackgroundColor,
    Color? itemPressedColor,
    EdgeInsetsGeometry? itemPadding,
    Color? itemIconColor,
    double? itemIconSize,
    double? itemIconGap,
    Color? dividerColor,
    double? dividerIndent,
    double? dividerThickness,
    EdgeInsetsGeometry? footerPadding,
  }) {
    return TDrawerThemeData(
      width: width ?? this.width,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      titleStyle: titleStyle ?? this.titleStyle,
      titlePadding: titlePadding ?? this.titlePadding,
      itemTextStyle: itemTextStyle ?? this.itemTextStyle,
      itemBackgroundColor: itemBackgroundColor ?? this.itemBackgroundColor,
      itemPressedColor: itemPressedColor ?? this.itemPressedColor,
      itemPadding: itemPadding ?? this.itemPadding,
      itemIconColor: itemIconColor ?? this.itemIconColor,
      itemIconSize: itemIconSize ?? this.itemIconSize,
      itemIconGap: itemIconGap ?? this.itemIconGap,
      dividerColor: dividerColor ?? this.dividerColor,
      dividerIndent: dividerIndent ?? this.dividerIndent,
      dividerThickness: dividerThickness ?? this.dividerThickness,
      footerPadding: footerPadding ?? this.footerPadding,
    );
  }

  @override
  TDrawerThemeData lerp(ThemeExtension<TDrawerThemeData>? other, double t) {
    if (other is! TDrawerThemeData) {
      return this;
    }
    return TDrawerThemeData(
      width: _lerpDoubleWithDefault(width, other.width, 280, t),
      backgroundColor: _lerpColor(backgroundColor, other.backgroundColor, t),
      titleStyle: _lerpTextStyle(titleStyle, other.titleStyle, t),
      titlePadding: _lerpInsetsWithDefault(
        titlePadding,
        other.titlePadding,
        const EdgeInsets.fromLTRB(16, 24, 16, 8),
        t,
      ),
      itemTextStyle: _lerpTextStyle(itemTextStyle, other.itemTextStyle, t),
      itemBackgroundColor: _lerpColor(
        itemBackgroundColor,
        other.itemBackgroundColor,
        t,
      ),
      itemPressedColor: _lerpColor(itemPressedColor, other.itemPressedColor, t),
      itemPadding: _lerpInsetsWithDefault(
        itemPadding,
        other.itemPadding,
        const EdgeInsets.fromLTRB(16, 16, 0, 16),
        t,
      ),
      itemIconColor: _lerpColor(itemIconColor, other.itemIconColor, t),
      itemIconSize: _lerpDoubleWithDefault(
        itemIconSize,
        other.itemIconSize,
        24,
        t,
      ),
      itemIconGap: _lerpDoubleWithDefault(itemIconGap, other.itemIconGap, 8, t),
      dividerColor: _lerpColor(dividerColor, other.dividerColor, t),
      dividerIndent: _lerpDoubleWithDefault(
        dividerIndent,
        other.dividerIndent,
        16,
        t,
      ),
      dividerThickness: _lerpDoubleWithDefault(
        dividerThickness,
        other.dividerThickness,
        0.5,
        t,
      ),
      footerPadding: _lerpInsetsWithDefault(
        footerPadding,
        other.footerPadding,
        const EdgeInsets.only(bottom: 20),
        t,
      ),
    );
  }

  static double? _lerpDoubleWithDefault(
    double? begin,
    double? end,
    double defaultValue,
    double t,
  ) {
    if (begin == null && end == null) {
      return null;
    }
    return lerpDouble(begin ?? defaultValue, end ?? defaultValue, t);
  }

  static EdgeInsetsGeometry? _lerpInsetsWithDefault(
    EdgeInsetsGeometry? begin,
    EdgeInsetsGeometry? end,
    EdgeInsetsGeometry defaultValue,
    double t,
  ) {
    if (begin == null && end == null) {
      return null;
    }
    return EdgeInsetsGeometry.lerp(
      begin ?? defaultValue,
      end ?? defaultValue,
      t,
    );
  }

  static Color? _lerpColor(Color? begin, Color? end, double t) {
    if (begin == null || end == null) {
      return t < 0.5 ? begin : end;
    }
    return Color.lerp(begin, end, t);
  }

  static TextStyle? _lerpTextStyle(TextStyle? begin, TextStyle? end, double t) {
    if (begin == null || end == null) {
      return t < 0.5 ? begin : end;
    }
    return TextStyle.lerp(begin, end, t);
  }
}

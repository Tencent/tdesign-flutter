import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../theme/t_token_double_lerp.dart';

/// 抽屉组件 ThemeExtension。
///
/// 只保存子树级具体视觉默认值。方向、蒙层与展示生命周期由 `showTDrawer`
/// 负责；分隔线和按压反馈由组件实例负责；构造器具体视觉参数优先级高于 ThemeData。
///
/// {@category ComponentTheme}
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
  /// null 时沿用抽屉实际面板背景色。
  final Color? itemBackgroundColor;

  /// 菜单项按压背景色。
  /// null 时使用 bgColorSecondaryContainer Token。
  final Color? itemPressedColor;

  /// 菜单项内边距，默认 `EdgeInsets.fromLTRB(16, 16, 0, 16)`。
  final EdgeInsetsGeometry? itemPadding;

  /// 菜单项图标颜色。
  /// null 时使用 textColorPrimary Token。
  final Color? itemIconColor;

  /// 菜单项图标尺寸；为空时读取 size8，默认 24。
  final double? itemIconSize;

  /// 菜单项图标与正文间距，默认 8。
  final double? itemIconGap;

  /// 菜单项分隔线颜色。
  /// null 时使用 componentStroke Token。
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

  /// 复制主题配置。
  ///
  /// ## 返回值
  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
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
    return _InterpolatedTDrawerThemeData(
      TDrawerThemeData(
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
      ),
      itemIconSizeLerp: itemIconSize == null
          ? _drawerTransition(this)?._itemIconSizeLerp
          : null,
      titlePaddingTransition: titlePadding == null
          ? _drawerTransition(this)?._titlePaddingTransition
          : null,
      itemPaddingTransition: itemPadding == null
          ? _drawerTransition(this)?._itemPaddingTransition
          : null,
      itemIconGapTransition: itemIconGap == null
          ? _drawerTransition(this)?._itemIconGapTransition
          : null,
    );
  }

  /// 生成主题过渡配置。
  ///
  /// ## 返回值
  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TDrawerThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TDrawerThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TDrawerThemeData) {
      return this;
    }
    return _InterpolatedTDrawerThemeData(
      TDrawerThemeData(
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
        itemPressedColor: _lerpColor(
          itemPressedColor,
          other.itemPressedColor,
          t,
        ),
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
        itemIconGap: _lerpDoubleWithDefault(
          itemIconGap,
          other.itemIconGap,
          8,
          t,
        ),
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
      ),
      itemIconSizeLerp: TokenDoubleLerp.between(
        itemIconSize,
        _drawerTransition(this)?._itemIconSizeLerp,
        other.itemIconSize,
        _drawerTransition(other)?._itemIconSizeLerp,
        t,
      ),
      titlePaddingTransition: TokenValueLerp.between(
        titlePadding,
        _drawerTransition(this)?._titlePaddingTransition,
        other.titlePadding,
        _drawerTransition(other)?._titlePaddingTransition,
        t,
        (a, b, t) => EdgeInsetsGeometry.lerp(a, b, t)!,
      ),
      itemPaddingTransition: TokenValueLerp.between(
        itemPadding,
        _drawerTransition(this)?._itemPaddingTransition,
        other.itemPadding,
        _drawerTransition(other)?._itemPaddingTransition,
        t,
        (a, b, t) => EdgeInsetsGeometry.lerp(a, b, t)!,
      ),
      itemIconGapTransition: TokenValueLerp.between(
        itemIconGap,
        _drawerTransition(this)?._itemIconGapTransition,
        other.itemIconGap,
        _drawerTransition(other)?._itemIconGapTransition,
        t,
        (a, b, t) => lerpDouble(a, b, t)!,
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

class _InterpolatedTDrawerThemeData extends TDrawerThemeData {
  _InterpolatedTDrawerThemeData(
    TDrawerThemeData data, {
    TokenDoubleLerp? itemIconSizeLerp,
    TokenValueLerp<EdgeInsetsGeometry>? titlePaddingTransition,
    TokenValueLerp<EdgeInsetsGeometry>? itemPaddingTransition,
    TokenValueLerp<double>? itemIconGapTransition,
  }) : _titlePaddingTransition = titlePaddingTransition,
       _itemPaddingTransition = itemPaddingTransition,
       _itemIconGapTransition = itemIconGapTransition,
       _itemIconSizeLerp = itemIconSizeLerp,
       super(
         width: data.width,
         backgroundColor: data.backgroundColor,
         titleStyle: data.titleStyle,
         titlePadding: data.titlePadding,
         itemTextStyle: data.itemTextStyle,
         itemBackgroundColor: data.itemBackgroundColor,
         itemPressedColor: data.itemPressedColor,
         itemPadding: data.itemPadding,
         itemIconColor: data.itemIconColor,
         itemIconSize: data.itemIconSize,
         itemIconGap: data.itemIconGap,
         dividerColor: data.dividerColor,
         dividerIndent: data.dividerIndent,
         dividerThickness: data.dividerThickness,
         footerPadding: data.footerPadding,
       );

  final TokenValueLerp<EdgeInsetsGeometry>? _titlePaddingTransition;
  final TokenValueLerp<EdgeInsetsGeometry>? _itemPaddingTransition;
  final TokenValueLerp<double>? _itemIconGapTransition;
  final TokenDoubleLerp? _itemIconSizeLerp;
}

// Only library-owned interpolation objects carry deferred token state.
// External implements satisfy the historic public interface, not private getters.
_InterpolatedTDrawerThemeData? _drawerTransition(TDrawerThemeData theme) =>
    theme is _InterpolatedTDrawerThemeData ? theme : null;

EdgeInsetsGeometry _resolveDrawerTitlePadding(
  TDrawerThemeData theme,
  EdgeInsetsGeometry fallback,
) =>
    _drawerTransition(theme)?._titlePaddingTransition?.resolve(fallback) ??
    theme.titlePadding ??
    fallback;

EdgeInsetsGeometry _resolveDrawerItemPadding(
  TDrawerThemeData theme,
  EdgeInsetsGeometry fallback,
) =>
    _drawerTransition(theme)?._itemPaddingTransition?.resolve(fallback) ??
    theme.itemPadding ??
    fallback;

double _resolveDrawerItemIconGap(TDrawerThemeData theme, double fallback) =>
    _drawerTransition(theme)?._itemIconGapTransition?.resolve(fallback) ??
    theme.itemIconGap ??
    fallback;

double _resolveDrawerItemIconSize(TDrawerThemeData theme, double fallback) =>
    _drawerTransition(theme)?._itemIconSizeLerp?.resolve(fallback) ??
    theme.itemIconSize ??
    fallback;

/// Internal resolution bridge; excluded from the package's public exports.
@internal
extension TDrawerThemeDataResolution on TDrawerThemeData {
  EdgeInsetsGeometry resolveTitlePadding(EdgeInsetsGeometry fallback) =>
      _resolveDrawerTitlePadding(this, fallback);

  EdgeInsetsGeometry resolveItemPadding(EdgeInsetsGeometry fallback) =>
      _resolveDrawerItemPadding(this, fallback);

  double resolveItemIconGap(double fallback) =>
      _resolveDrawerItemIconGap(this, fallback);

  double resolveItemIconSize(double fallback) =>
      _resolveDrawerItemIconSize(this, fallback);
}

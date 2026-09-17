import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// NavBar 边框配置（迁入 ThemeData）
class TNavBarBorder {
  /// 边框宽度
  final double width;

  /// 边框圆角
  final double radius;

  /// 边框颜色
  final Color? color;

  /// 内部填充
  final EdgeInsetsGeometry? padding;

  const TNavBarBorder({
    this.width = 1.0,
    this.radius = 22.0,
    this.color,
    this.padding,
  });
}

/// NavBar 组件 ThemeExtension
///
/// 管理 TNavBar 的子树级默认样式（标题颜色、背景、内边距、阴影、边框等）。
/// 构造器参数优先级高于 ThemeData。高度属于 PreferredSizeWidget 契约，只能通过 TNavBar.height 设置。
class TNavBarThemeData extends ThemeExtension<TNavBarThemeData> {
  /// 标题的子树默认颜色。
  ///
  /// 仅在 NavBar 标题未自行提供前景色时生效；标题 Widget 自身的显式颜色优先。
  final Color? titleColor;

  /// 返回图标颜色
  final Color? backIconColor;

  /// 背景颜色
  final Color? backgroundColor;

  /// 内部填充
  final EdgeInsetsGeometry? padding;

  /// 中间文案左右两边间距
  final double? titleMargin;

  /// 背景颜色透明度，未配置时为 1
  final double? opacity;

  /// 操作项边框配置，仅在 TNavBar.useBorderStyle 为 true 时生效
  final TNavBarBorder? border;

  /// 底部阴影
  final List<BoxShadow>? boxShadow;

  const TNavBarThemeData({
    this.titleColor,
    this.backIconColor,
    this.backgroundColor,
    this.padding,
    this.titleMargin,
    this.opacity,
    this.border,
    this.boxShadow,
  });

  /// 返回只替换非空参数的新主题。
  ///
  /// 参数省略或传入 `null` 都会保留原值，符合 Flutter `copyWith` 的常见语义。
  /// 如需清除某个配置并恢复下层 Theme 或 Token，请重新构造
  /// [TNavBarThemeData]，只传入仍需保留的字段。
  @override
  TNavBarThemeData copyWith({
    Color? titleColor,
    Color? backIconColor,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    double? titleMargin,
    double? opacity,
    TNavBarBorder? border,
    List<BoxShadow>? boxShadow,
  }) {
    return TNavBarThemeData(
      titleColor: titleColor ?? this.titleColor,
      backIconColor: backIconColor ?? this.backIconColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      padding: padding ?? this.padding,
      titleMargin: titleMargin ?? this.titleMargin,
      opacity: opacity ?? this.opacity,
      border: border ?? this.border,
      boxShadow: boxShadow ?? this.boxShadow,
    );
  }

  @override
  TNavBarThemeData lerp(ThemeExtension<TNavBarThemeData>? other, double t) {
    if (other is! TNavBarThemeData) {
      return this;
    }
    return TNavBarThemeData(
      titleColor: _lerpNullableColor(titleColor, other.titleColor, t),
      backIconColor: _lerpNullableColor(backIconColor, other.backIconColor, t),
      backgroundColor: _lerpNullableColor(
        backgroundColor,
        other.backgroundColor,
        t,
      ),
      padding: _lerpNullableInsets(padding, other.padding, t),
      titleMargin: _lerpDoubleWithDefault(
        titleMargin,
        other.titleMargin,
        t,
        16,
      ),
      opacity: _lerpDoubleWithDefault(opacity, other.opacity, t, 1),
      border: _lerpNavBarBorder(border, other.border, t),
      boxShadow: BoxShadow.lerpList(boxShadow, other.boxShadow, t),
    );
  }
}

double? _lerpDoubleWithDefault(
  double? begin,
  double? end,
  double t,
  double defaultValue,
) {
  if (begin == null && end == null) {
    return null;
  }
  return lerpDouble(begin ?? defaultValue, end ?? defaultValue, t);
}

Color? _lerpNullableColor(Color? begin, Color? end, double t) {
  if (begin == null || end == null) {
    return t < 0.5 ? begin : end;
  }
  return Color.lerp(begin, end, t);
}

EdgeInsetsGeometry? _lerpNullableInsets(
  EdgeInsetsGeometry? begin,
  EdgeInsetsGeometry? end,
  double t,
) {
  if (begin == null || end == null) {
    return t < 0.5 ? begin : end;
  }
  return EdgeInsetsGeometry.lerp(begin, end, t);
}

TNavBarBorder? _lerpNavBarBorder(
  TNavBarBorder? begin,
  TNavBarBorder? end,
  double t,
) {
  if (begin == null && end == null) {
    return null;
  }
  if (t == 0) {
    return begin;
  }
  if (t == 1) {
    return end;
  }
  final effectiveBegin = begin ?? const TNavBarBorder();
  final effectiveEnd = end ?? const TNavBarBorder();
  return TNavBarBorder(
    width: lerpDouble(effectiveBegin.width, effectiveEnd.width, t)!,
    radius: lerpDouble(effectiveBegin.radius, effectiveEnd.radius, t)!,
    color: _lerpNullableColor(effectiveBegin.color, effectiveEnd.color, t),
    padding: _lerpNullableInsets(
      effectiveBegin.padding,
      effectiveEnd.padding,
      t,
    ),
  );
}

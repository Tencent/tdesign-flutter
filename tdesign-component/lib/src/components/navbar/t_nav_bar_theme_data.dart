import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

const _unset = Object();

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

  /// 透明度
  final double? opacity;

  /// 操作项边框配置
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

  /// 返回只替换指定字段的新主题。
  ///
  /// 省略参数会保留原值；显式传入 `null` 会清除对应配置，使组件继续回退到
  /// Material Theme 或 TDesign Token。
  @override
  TNavBarThemeData copyWith({
    Object? titleColor = _unset,
    Object? backIconColor = _unset,
    Object? backgroundColor = _unset,
    Object? padding = _unset,
    Object? titleMargin = _unset,
    Object? opacity = _unset,
    Object? border = _unset,
    Object? boxShadow = _unset,
  }) {
    return TNavBarThemeData(
      titleColor: identical(titleColor, _unset)
          ? this.titleColor
          : titleColor as Color?,
      backIconColor: identical(backIconColor, _unset)
          ? this.backIconColor
          : backIconColor as Color?,
      backgroundColor: identical(backgroundColor, _unset)
          ? this.backgroundColor
          : backgroundColor as Color?,
      padding: identical(padding, _unset)
          ? this.padding
          : padding as EdgeInsetsGeometry?,
      titleMargin: identical(titleMargin, _unset)
          ? this.titleMargin
          : titleMargin as double?,
      opacity: identical(opacity, _unset) ? this.opacity : opacity as double?,
      border: identical(border, _unset)
          ? this.border
          : border as TNavBarBorder?,
      boxShadow: identical(boxShadow, _unset)
          ? this.boxShadow
          : boxShadow as List<BoxShadow>?,
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
      padding: t < 0.5 ? padding : other.padding,
      titleMargin: _lerpNullableDouble(titleMargin, other.titleMargin, t),
      opacity: _lerpNullableDouble(opacity, other.opacity, t),
      border: t < 0.5 ? border : other.border,
      boxShadow: t < 0.5 ? boxShadow : other.boxShadow,
    );
  }
}

double? _lerpNullableDouble(double? begin, double? end, double t) {
  if (begin == null || end == null) {
    return t < 0.5 ? begin : end;
  }
  return lerpDouble(begin, end, t);
}

Color? _lerpNullableColor(Color? begin, Color? end, double t) {
  if (begin == null || end == null) {
    return t < 0.5 ? begin : end;
  }
  return Color.lerp(begin, end, t);
}

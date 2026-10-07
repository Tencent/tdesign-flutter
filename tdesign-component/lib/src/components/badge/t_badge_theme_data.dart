import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 't_badge_defaults.dart';

/// TDesign 徽标的子树级视觉默认值。
///
/// 形态、内容、对齐和偏移由实例 API 控制，不从 Material BadgeTheme 读取。
@immutable
class TBadgeThemeData extends ThemeExtension<TBadgeThemeData> {
  const TBadgeThemeData({
    this.backgroundColor,
    this.dotSize,
    this.labelHeight,
    this.textStyle,
    this.padding,
    this.borderColor,
    this.borderWidth,
  });

  /// 徽标背景色；为空时使用全局错误色 Token。
  final Color? backgroundColor;

  /// 圆点直径；为空时使用组件内置尺寸。
  final double? dotSize;

  /// 文字徽标高度；为空时由当前尺寸的字体 Token 决定。
  final double? labelHeight;

  /// 徽标文字的唯一组件级样式入口；未配置字段从字体与反色文字 Token 取得。
  final TextStyle? textStyle;

  /// 文字徽标内边距；为空时由当前尺寸决定。
  final EdgeInsetsGeometry? padding;

  /// 开启描边时使用的颜色；为空时回退到当前容器背景色。
  final Color? borderColor;

  /// 开启描边时使用的宽度；为空时使用 1 逻辑像素。
  final double? borderWidth;

  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TBadgeThemeData copyWith({
    Color? backgroundColor,
    double? dotSize,
    double? labelHeight,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
    Color? borderColor,
    double? borderWidth,
  }) {
    return TBadgeThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      dotSize: dotSize ?? this.dotSize,
      labelHeight: labelHeight ?? this.labelHeight,
      textStyle: textStyle ?? this.textStyle,
      padding: padding ?? this.padding,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
    );
  }

  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TBadgeThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TBadgeThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TBadgeThemeData) {
      return this;
    }
    return TBadgeThemeData(
      backgroundColor: _lerpContextualColor(
        backgroundColor,
        other.backgroundColor,
        t,
      ),
      dotSize: _lerpNullableDouble(dotSize, other.dotSize, t),
      labelHeight: _lerpNullableDouble(labelHeight, other.labelHeight, t),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      // null 表示依赖当前上下文的容器背景色，不能把它当作透明色参与
      // 插值；在动画中点切换配置，才能保留两端各自的运行时回退语义。
      borderColor: _lerpContextualColor(borderColor, other.borderColor, t),
      borderWidth: _lerpBorderWidth(borderWidth, other.borderWidth, t),
    );
  }

  static Color? _lerpContextualColor(Color? begin, Color? end, double t) {
    if (begin == null || end == null) {
      return t < 0.5 ? begin : end;
    }
    return Color.lerp(begin, end, t);
  }

  static double? _lerpBorderWidth(double? begin, double? end, double t) {
    if (begin == null && end == null) {
      return null;
    }
    return lerpDouble(
      begin ?? TBadgeDefaults.borderWidth,
      end ?? TBadgeDefaults.borderWidth,
      t,
    );
  }

  static double? _lerpNullableDouble(double? begin, double? end, double t) {
    if (begin == null || end == null) {
      return t < 0.5 ? begin : end;
    }
    return lerpDouble(begin, end, t);
  }
}

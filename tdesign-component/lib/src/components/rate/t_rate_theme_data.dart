import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TRate 组件级 ThemeExtension。
///
/// {@category ComponentTheme}
class TRateThemeData extends ThemeExtension<TRateThemeData> {
  const TRateThemeData({
    this.starColor,
    this.inactiveStarColor,
    this.iconSize,
    this.iconGap,
    this.textWidth,
    this.textGap,
    this.textStyle,
    this.overlayBoxShadow,
  });

  /// 选中星标颜色。
  /// null 时使用 warningColor5 Token。
  final Color? starColor;

  /// 未选中星标颜色。
  final Color? inactiveStarColor;

  /// 图标尺寸。
  /// null 时使用 spacer3 Token。
  final double? iconSize;

  /// 图标间距。
  /// null 时使用 spacer Token。
  final double? iconGap;

  /// 文案宽度。
  final double? textWidth;

  /// 图标与文案间距。
  /// null 时使用 spacer2 Token。
  final double? textGap;

  /// 文案样式。
  final TextStyle? textStyle;

  /// 当前值提示与半星选择浮层阴影。
  /// null 时使用 shadow1 Token；该 Token 缺失时无阴影。
  final List<BoxShadow>? overlayBoxShadow;

  /// 复制主题配置。
  ///
  /// ## 返回值
  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TRateThemeData copyWith({
    Color? starColor,
    Color? inactiveStarColor,
    double? iconSize,
    double? iconGap,
    double? textWidth,
    double? textGap,
    TextStyle? textStyle,
    List<BoxShadow>? overlayBoxShadow,
  }) {
    return TRateThemeData(
      starColor: starColor ?? this.starColor,
      inactiveStarColor: inactiveStarColor ?? this.inactiveStarColor,
      iconSize: iconSize ?? this.iconSize,
      iconGap: iconGap ?? this.iconGap,
      textWidth: textWidth ?? this.textWidth,
      textGap: textGap ?? this.textGap,
      textStyle: textStyle ?? this.textStyle,
      overlayBoxShadow: overlayBoxShadow ?? this.overlayBoxShadow,
    );
  }

  /// 生成主题过渡配置。
  ///
  /// ## 返回值
  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TRateThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TRateThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TRateThemeData) {
      return this;
    }
    return TRateThemeData(
      starColor: Color.lerp(starColor, other.starColor, t),
      inactiveStarColor: Color.lerp(
        inactiveStarColor,
        other.inactiveStarColor,
        t,
      ),
      iconSize: lerpDouble(iconSize, other.iconSize, t),
      iconGap: lerpDouble(iconGap, other.iconGap, t),
      textWidth: lerpDouble(textWidth, other.textWidth, t),
      textGap: lerpDouble(textGap, other.textGap, t),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      overlayBoxShadow: t < 0.5 ? overlayBoxShadow : other.overlayBoxShadow,
    );
  }
}

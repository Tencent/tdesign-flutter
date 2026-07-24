import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 't_link_types.dart';

/// TLink 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认形态。
/// 构造器参数优先于 Theme。
class TLinkThemeData extends ThemeExtension<TLinkThemeData> {
  /// 未传链接 variant 时的默认链接形态
  final TLinkVariant? defaultVariant;

  /// 未传链接 size 时的默认尺寸
  final TLinkSize? defaultSize;

  /// 未传链接 colorScheme 时的默认语义色
  final TLinkColorScheme? defaultColorScheme;

  /// 链接文本颜色（覆盖 colorScheme 计算色）
  final Color? color;

  /// 图标尺寸
  final double? iconSize;

  /// 文本字号
  final double? fontSize;

  /// 前置图标与文本间距
  final double? leftGapWithIcon;

  /// 后置图标与文本间距
  final double? rightGapWithIcon;

  const TLinkThemeData({
    this.defaultVariant,
    this.defaultSize,
    this.defaultColorScheme,
    this.color,
    this.iconSize,
    this.fontSize,
    this.leftGapWithIcon,
    this.rightGapWithIcon,
  });

  @override
  TLinkThemeData copyWith({
    TLinkVariant? defaultVariant,
    TLinkSize? defaultSize,
    TLinkColorScheme? defaultColorScheme,
    Color? color,
    double? iconSize,
    double? fontSize,
    double? leftGapWithIcon,
    double? rightGapWithIcon,
  }) {
    return TLinkThemeData(
      defaultVariant: defaultVariant ?? this.defaultVariant,
      defaultSize: defaultSize ?? this.defaultSize,
      defaultColorScheme: defaultColorScheme ?? this.defaultColorScheme,
      color: color ?? this.color,
      iconSize: iconSize ?? this.iconSize,
      fontSize: fontSize ?? this.fontSize,
      leftGapWithIcon: leftGapWithIcon ?? this.leftGapWithIcon,
      rightGapWithIcon: rightGapWithIcon ?? this.rightGapWithIcon,
    );
  }

  @override
  TLinkThemeData lerp(ThemeExtension<TLinkThemeData>? other, double t) {
    if (other is! TLinkThemeData) {
      return this;
    }
    return TLinkThemeData(
      defaultVariant: t < 0.5 ? defaultVariant : other.defaultVariant,
      defaultSize: t < 0.5 ? defaultSize : other.defaultSize,
      defaultColorScheme:
          t < 0.5 ? defaultColorScheme : other.defaultColorScheme,
      color: Color.lerp(color, other.color, t),
      iconSize: lerpDouble(iconSize, other.iconSize, t),
      fontSize: lerpDouble(fontSize, other.fontSize, t),
      leftGapWithIcon: lerpDouble(leftGapWithIcon, other.leftGapWithIcon, t),
      rightGapWithIcon: lerpDouble(rightGapWithIcon, other.rightGapWithIcon, t),
    );
  }
}

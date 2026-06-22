import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 't_button.dart';

/// 按钮形状（包内可见，不对外导出）
enum TButtonShape { rectangle, round, square, circle, filled }

/// TButton 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认形态。
/// 构造器参数优先于 Theme，P0 [ButtonStyle] 实例优先于 Theme。
class TButtonThemeData extends ThemeExtension<TButtonThemeData> {
  /// 未传 [TButton.variant] 时的默认变体
  final TButtonVariant defaultVariant;

  /// 未传 [TButton.size] 时的默认尺寸
  final TButtonSize defaultSize;

  /// P2 色板：fill 变体的 [ButtonStyle]（仅颜色相关字段，不含 shape）
  final ButtonStyle? filledStyle;

  /// P2 色板：outline 变体的 [ButtonStyle]（仅颜色相关字段，不含 shape）
  final ButtonStyle? outlinedStyle;

  /// P2 色板：text 变体的 [ButtonStyle]（仅颜色相关字段，不含 shape）
  final ButtonStyle? textButtonStyle;

  /// P2 色板：ghost 变体的 [ButtonStyle]（仅颜色相关字段，不含 shape）
  final ButtonStyle? ghostStyle;

  /// 外形，会展开进 resolves [ButtonStyle.shape]
  final TButtonShape? shape;

  /// 覆盖默认 padding（null 时由 resolve 按 size/shape 推导）
  final EdgeInsetsGeometry? padding;

  /// 外边距
  final EdgeInsetsGeometry? margin;

  /// 图标与文案之间的间距
  final double? iconSpacing;

  /// 渐变背景色（装饰层，非 ButtonStyle 字段）
  final Gradient? gradient;

  /// 默认文案样式
  final TextStyle? textStyle;

  const TButtonThemeData({
    this.defaultVariant = TButtonVariant.fill,
    this.defaultSize = TButtonSize.medium,
    this.filledStyle,
    this.outlinedStyle,
    this.textButtonStyle,
    this.ghostStyle,
    this.shape,
    this.padding,
    this.margin,
    this.iconSpacing,
    this.gradient,
    this.textStyle,
  });

  @override
  TButtonThemeData copyWith({
    TButtonVariant? defaultVariant,
    TButtonSize? defaultSize,
    ButtonStyle? filledStyle,
    ButtonStyle? outlinedStyle,
    ButtonStyle? textButtonStyle,
    ButtonStyle? ghostStyle,
    TButtonShape? shape,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? iconSpacing,
    Gradient? gradient,
    TextStyle? textStyle,
  }) {
    return TButtonThemeData(
      defaultVariant: defaultVariant ?? this.defaultVariant,
      defaultSize: defaultSize ?? this.defaultSize,
      filledStyle: filledStyle ?? this.filledStyle,
      outlinedStyle: outlinedStyle ?? this.outlinedStyle,
      textButtonStyle: textButtonStyle ?? this.textButtonStyle,
      ghostStyle: ghostStyle ?? this.ghostStyle,
      shape: shape ?? this.shape,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      iconSpacing: iconSpacing ?? this.iconSpacing,
      gradient: gradient ?? this.gradient,
      textStyle: textStyle ?? this.textStyle,
    );
  }

  @override
  TButtonThemeData lerp(ThemeExtension<TButtonThemeData>? other, double t) {
    if (other is! TButtonThemeData) {
      return this;
    }
    return TButtonThemeData(
      defaultVariant: t < 0.5 ? defaultVariant : other.defaultVariant,
      defaultSize: t < 0.5 ? defaultSize : other.defaultSize,
      filledStyle: t < 0.5 ? filledStyle : other.filledStyle,
      outlinedStyle: t < 0.5 ? outlinedStyle : other.outlinedStyle,
      textButtonStyle: t < 0.5 ? textButtonStyle : other.textButtonStyle,
      ghostStyle: t < 0.5 ? ghostStyle : other.ghostStyle,
      shape: t < 0.5 ? shape : other.shape,
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      margin: EdgeInsetsGeometry.lerp(margin, other.margin, t),
      iconSpacing: lerpDouble(iconSpacing, other.iconSpacing, t),
      gradient: t < 0.5 ? gradient : other.gradient,
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
    );
  }

  /// 从当前实例推导 shape。未显式设置时返回 [rectangle]。
  TButtonShape get effectiveShape => shape ?? TButtonShape.rectangle;
}

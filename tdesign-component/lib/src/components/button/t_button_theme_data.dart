import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 't_button_types.dart';

/// TButton 组件级 ThemeExtension
///
/// 通过 Theme 子树注入，控制子树的默认形态。
/// 构造器参数优先于 Theme，P0 [ButtonStyle] 实例优先于 Theme。
class TButtonThemeData extends ThemeExtension<TButtonThemeData> {
  /// 未传按钮 variant 时的默认变体
  final TButtonVariant defaultVariant;

  /// 未传按钮 size 时的默认尺寸
  final TButtonSize defaultSize;

  /// P1 组件样式：fill 变体的 [ButtonStyle]。
  ///
  /// 尺寸、形状和 padding 的组件级默认值优先使用 [defaultSize]、[shape]
  /// 和 [padding]；其余标准 [ButtonStyle] 字段按组件主题优先级参与合并。
  final ButtonStyle? filledStyle;

  /// P1 组件样式：outline 变体的 [ButtonStyle]。
  final ButtonStyle? outlinedStyle;

  /// P1 组件样式：text 变体的 [ButtonStyle]。
  final ButtonStyle? textButtonStyle;

  /// P1 组件样式：ghost 变体的 [ButtonStyle]。
  final ButtonStyle? ghostStyle;

  /// 外形，会展开进 resolves [ButtonStyle.shape]。
  ///
  /// [TButtonShape.square] 在纯图标场景表示宽高相等并保留默认圆角，
  /// 不表示直角，也不会裁剪图文内容宽度。
  final TButtonShape? shape;

  /// 覆盖默认 padding（null 时由 resolve 按 size/shape 推导）
  final EdgeInsetsGeometry? padding;

  /// 图标与文案之间的间距，单位为逻辑像素。
  ///
  /// 仅在按钮同时提供 icon 和 child 时生效；该值控制两者
  /// 之间的实际间隔，不会改变按钮整体内边距。
  final double? iconTextSpacing;

  /// 渐变背景色（装饰层，非 ButtonStyle 字段）
  final Gradient? gradient;

  const TButtonThemeData({
    this.defaultVariant = TButtonVariant.fill,
    this.defaultSize = TButtonSize.medium,
    this.filledStyle,
    this.outlinedStyle,
    this.textButtonStyle,
    this.ghostStyle,
    this.shape,
    this.padding,
    this.iconTextSpacing,
    this.gradient,
  }) : assert(
         iconTextSpacing == null ||
             (iconTextSpacing >= 0 && iconTextSpacing < double.infinity),
         'iconTextSpacing must be finite and non-negative',
       );

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
    double? iconTextSpacing,
    Gradient? gradient,
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
      iconTextSpacing: iconTextSpacing ?? this.iconTextSpacing,
      gradient: gradient ?? this.gradient,
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
      iconTextSpacing: lerpDouble(iconTextSpacing, other.iconTextSpacing, t),
      gradient: t < 0.5 ? gradient : other.gradient,
    );
  }

  /// 从当前实例推导 shape。未显式设置时返回 rectangle。
  TButtonShape get effectiveShape => shape ?? TButtonShape.rectangle;
}

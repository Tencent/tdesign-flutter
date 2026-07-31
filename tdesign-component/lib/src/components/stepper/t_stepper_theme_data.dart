import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 't_stepper_types.dart';

/// `TStepper` 的组件级主题。
///
/// 通过 [ThemeData.extensions] 或 `ThemeData.mergeExtension` 注入。实例参数
/// 优先于此主题；未设置字段继续继承 Flutter 的 DefaultTextStyle、
/// IconTheme、InputDecorationTheme 和 ThemeData，最后回退 TDesign token。
class TStepperThemeData extends ThemeExtension<TStepperThemeData> {
  const TStepperThemeData({
    /// 默认尺寸；为空时使用 [TStepperSize.medium]。
    this.size,

    /// 默认形态；为空时使用 [TStepperVariant.normal]。
    this.variant,

    /// 输入段宽度。
    ///
    /// 为空时 small、medium、large 分别使用 34、38、45。
    this.inputWidth,

    /// 控件高度及单个按钮宽度。
    ///
    /// 为空时 small、medium、large 分别使用 20、24、26。
    this.controlSize,

    /// 加减图标尺寸。
    ///
    /// 为空时 small、medium、large 分别使用 12、16、20。
    this.iconSize,

    /// normal 和 filled 形态的分段间距，默认 4。
    ///
    /// outline 始终连续排列，不使用该值。
    this.spacing,

    /// 分段圆角，默认使用 TDesign `radiusSmall`。
    ///
    /// normal 和 filled 应用于每一段；outline 仅保留整组外侧圆角。
    this.borderRadius,

    /// outline 形态的描边宽度，默认 1。
    this.borderWidth,

    /// 输入文字和加减图标的默认前景色。
    this.foregroundColor,

    /// 边界不可操作按钮及整组禁用时的前景色。
    this.disabledForegroundColor,

    /// filled 形态各段的背景色。
    this.backgroundColor,

    /// 整组禁用时 filled 和 outline 形态各段的背景色。
    this.disabledBackgroundColor,

    /// outline 形态的描边颜色。
    this.borderColor,

    /// 输入文字样式。
    ///
    /// 在继承 DefaultTextStyle 和 ThemeData.textTheme 后合并；非空字段可覆盖
    /// 默认字号、行高及 [foregroundColor]。
    this.textStyle,
  })  : assert(inputWidth == null || inputWidth > 0),
        assert(controlSize == null || controlSize > 0),
        assert(iconSize == null || iconSize > 0),
        assert(spacing == null || spacing >= 0),
        assert(borderWidth == null || borderWidth >= 0);

  /// 默认尺寸；为空时使用中尺寸。
  final TStepperSize? size;

  /// 默认形态；为空时使用 normal。
  final TStepperVariant? variant;

  /// 输入段宽度；为空时 small、medium、large 分别为 34、38、45。
  final double? inputWidth;

  /// 控件高度及按钮宽度；为空时三档尺寸分别为 20、24、26。
  final double? controlSize;

  /// 加减图标尺寸；为空时三档尺寸分别为 12、16、20。
  final double? iconSize;

  /// normal 和 filled 形态的分段间距，默认 4；outline 不使用。
  final double? spacing;

  /// 分段圆角，默认使用 TDesign `radiusSmall`。
  final BorderRadius? borderRadius;

  /// outline 形态的描边宽度，默认 1。
  final double? borderWidth;

  /// 输入文字和加减图标的默认前景色。
  final Color? foregroundColor;

  /// 边界按钮及整组禁用时的前景色。
  final Color? disabledForegroundColor;

  /// filled 形态各段的背景色。
  final Color? backgroundColor;

  /// 整组禁用时 filled 和 outline 形态各段的背景色。
  final Color? disabledBackgroundColor;

  /// outline 形态的描边颜色。
  final Color? borderColor;

  /// 输入文本样式，可覆盖继承样式中的字号、行高和前景色。
  final TextStyle? textStyle;

  @override
  TStepperThemeData copyWith({
    TStepperSize? size,
    TStepperVariant? variant,
    double? inputWidth,
    double? controlSize,
    double? iconSize,
    double? spacing,
    BorderRadius? borderRadius,
    double? borderWidth,
    Color? foregroundColor,
    Color? disabledForegroundColor,
    Color? backgroundColor,
    Color? disabledBackgroundColor,
    Color? borderColor,
    TextStyle? textStyle,
  }) {
    return TStepperThemeData(
      size: size ?? this.size,
      variant: variant ?? this.variant,
      inputWidth: inputWidth ?? this.inputWidth,
      controlSize: controlSize ?? this.controlSize,
      iconSize: iconSize ?? this.iconSize,
      spacing: spacing ?? this.spacing,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      disabledForegroundColor:
          disabledForegroundColor ?? this.disabledForegroundColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      disabledBackgroundColor:
          disabledBackgroundColor ?? this.disabledBackgroundColor,
      borderColor: borderColor ?? this.borderColor,
      textStyle: textStyle ?? this.textStyle,
    );
  }

  @override
  TStepperThemeData lerp(ThemeExtension<TStepperThemeData>? other, double t) {
    if (other is! TStepperThemeData) {
      return this;
    }
    return TStepperThemeData(
      size: t < 0.5 ? size : other.size,
      variant: t < 0.5 ? variant : other.variant,
      inputWidth: lerpDouble(inputWidth, other.inputWidth, t),
      controlSize: lerpDouble(controlSize, other.controlSize, t),
      iconSize: lerpDouble(iconSize, other.iconSize, t),
      spacing: lerpDouble(spacing, other.spacing, t),
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t),
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t),
      foregroundColor: Color.lerp(foregroundColor, other.foregroundColor, t),
      disabledForegroundColor: Color.lerp(
        disabledForegroundColor,
        other.disabledForegroundColor,
        t,
      ),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      disabledBackgroundColor: Color.lerp(
        disabledBackgroundColor,
        other.disabledBackgroundColor,
        t,
      ),
      borderColor: Color.lerp(borderColor, other.borderColor, t),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
    );
  }
}

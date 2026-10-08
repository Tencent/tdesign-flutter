import 'package:flutter/material.dart';

import 't_stepper_theme_interpolation.dart';

/// `TStepper` 的组件级主题。
///
/// 通过 [ThemeData.extensions] 或 `ThemeData.mergeExtension` 注入。实例参数
/// 优先于此主题；未设置的文字字段使用全局 TDesign Token，图标及输入装饰
/// 仍按各自 Flutter 主题解析。
class TStepperThemeData extends ThemeExtension<TStepperThemeData> {
  const TStepperThemeData({
    this.inputWidth,
    this.controlSize,
    this.iconSize,
    this.spacing,
    this.borderRadius,
    this.borderWidth,
    this.foregroundColor,
    this.disabledForegroundColor,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.borderColor,
    this.textStyle,
  }) : assert(inputWidth == null || inputWidth > 0),
       assert(controlSize == null || controlSize > 0),
       assert(iconSize == null || iconSize > 0),
       assert(spacing == null || spacing >= 0),
       assert(borderWidth == null || borderWidth >= 0);

  /// 输入段宽度。
  ///
  /// 为空时 small、medium、large 分别使用 34、38、45。
  final double? inputWidth;

  /// 控件高度及单个按钮宽度。
  ///
  /// 为空时 small、medium、large 分别使用 20、24、26。
  final double? controlSize;

  /// 加减图标尺寸。
  ///
  /// 为空时 small、medium、large 分别使用 12、16、20。
  final double? iconSize;

  /// normal 和 filled 形态的分段间距，默认 4。
  ///
  /// outline 始终连续排列，不使用该值。
  final double? spacing;

  /// 分段圆角，默认使用 TDesign `radiusSmall`。
  ///
  /// normal 和 filled 应用于每一段；outline 仅保留整组外侧圆角。
  final BorderRadius? borderRadius;

  /// outline 形态的描边宽度，默认 1。
  final double? borderWidth;

  /// 输入文字和加减图标的默认前景色。
  final Color? foregroundColor;

  /// 边界不可操作按钮及整组禁用时的前景色。
  final Color? disabledForegroundColor;

  /// filled 形态各段的背景色。
  final Color? backgroundColor;

  /// 整组禁用时 filled 和 outline 形态各段的背景色。
  final Color? disabledBackgroundColor;

  /// outline 形态的描边颜色。
  final Color? borderColor;

  /// 输入文字样式。
  ///
  /// 在继承全局 TDesign Token 后合并；非空字段可覆盖
  /// 默认字号、行高及 [foregroundColor]。仅覆盖字号时会按最终字号重新计算
  /// 默认行高倍数；显式设置的 [TextStyle.height] 始终优先。最终字号或显式
  /// 物理行盒超过控件高度属于无效配置，并会在调试模式触发断言。
  final TextStyle? textStyle;

  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TStepperThemeData copyWith({
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

  /// 插值保留未指定字段的继承语义，由组件结合当前实例尺寸与主题解析。
  ///
  /// 两端均未指定的字段仍为 null；端点返回原始配置。
  @override
  TStepperThemeData lerp(
    /// 插值目标主题；为空或类型不匹配时返回当前主题。
    ThemeExtension<TStepperThemeData>? other,

    /// 插值进度；0 表示起点，1 表示终点。
    double t,
  ) {
    if (other is! TStepperThemeData) {
      return this;
    }
    if (t == 0) {
      return this;
    }
    if (t == 1) {
      return other;
    }
    return StepperThemeInterpolation(this, other, t);
  }
}

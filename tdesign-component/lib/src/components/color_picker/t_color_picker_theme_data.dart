import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TColorPicker 组件级 ThemeExtension。
///
/// 通过 Theme 子树注入，控制 [TColorPicker] 的默认外观。
/// 默认值对齐 tdesign-mobile-vue ColorPicker 的 CSS Variables。
class TColorPickerThemeData extends ThemeExtension<TColorPickerThemeData> {
  const TColorPickerThemeData({
    /// 面板背景色（对应 `--td-color-picker-panel-background`）。
    this.panelBackgroundColor,

    /// 面板圆角（对应 `--td-color-picker-panel-radius`）。
    this.panelRadius,

    /// 面板内边距（对应 `--td-color-picker-panel-padding`）。
    this.panelPadding,

    /// 饱和度-明度色板高度（对应 `--td-color-picker-saturation-height`）。
    this.saturationHeight,

    /// 饱和度-明度色板圆角（对应 `--td-color-picker-saturation-radius`）。
    this.saturationRadius,

    /// 饱和度-明度色板拖拽 thumb 尺寸（对应 `--td-color-picker-saturation-thumb-size`）。
    this.saturationThumbSize,

    /// 色相 / 透明条高度（对应 `--td-color-picker-slider-height`）。
    this.sliderHeight,

    /// 色相 / 透明条 thumb 尺寸（对应 `--td-color-picker-slider-thumb-size`）。
    this.sliderThumbSize,

    /// 色相 / 透明条 thumb 内边距（对应 `--td-color-picker-slider-thumb-padding`）。
    this.sliderThumbPadding,

    /// swatch 宽度（对应 `--td-color-picker-swatch-width`）。
    this.swatchWidth,

    /// swatch 高度（对应 `--td-color-picker-swatch-height`）。
    this.swatchHeight,

    /// swatch 圆角（对应 `--td-color-picker-swatch-border-radius`）。
    this.swatchRadius,

    /// swatch 选中描边颜色（对应 `--td-color-picker-swatch-active`）。
    this.swatchActiveBorderColor,
  });

  /// 面板背景色。
  final Color? panelBackgroundColor;

  /// 面板圆角。
  final double? panelRadius;

  /// 面板内边距。
  final EdgeInsets? panelPadding;

  /// 饱和度-明度色板高度。
  final double? saturationHeight;

  /// 饱和度-明度色板圆角。
  final double? saturationRadius;

  /// 饱和度-明度色板拖拽 thumb 尺寸。
  final double? saturationThumbSize;

  /// 色相 / 透明条高度。
  final double? sliderHeight;

  /// 色相 / 透明条 thumb 尺寸。
  final double? sliderThumbSize;

  /// 色相 / 透明条 thumb 内边距。
  final double? sliderThumbPadding;

  /// swatch 宽度。
  final double? swatchWidth;

  /// swatch 高度。
  final double? swatchHeight;

  /// swatch 圆角。
  final double? swatchRadius;

  /// swatch 选中描边颜色。
  final Color? swatchActiveBorderColor;

  @override
  TColorPickerThemeData copyWith({
    Color? panelBackgroundColor,
    double? panelRadius,
    EdgeInsets? panelPadding,
    double? saturationHeight,
    double? saturationRadius,
    double? saturationThumbSize,
    double? sliderHeight,
    double? sliderThumbSize,
    double? sliderThumbPadding,
    double? swatchWidth,
    double? swatchHeight,
    double? swatchRadius,
    Color? swatchActiveBorderColor,
  }) {
    return TColorPickerThemeData(
      panelBackgroundColor: panelBackgroundColor ?? this.panelBackgroundColor,
      panelRadius: panelRadius ?? this.panelRadius,
      panelPadding: panelPadding ?? this.panelPadding,
      saturationHeight: saturationHeight ?? this.saturationHeight,
      saturationRadius: saturationRadius ?? this.saturationRadius,
      saturationThumbSize: saturationThumbSize ?? this.saturationThumbSize,
      sliderHeight: sliderHeight ?? this.sliderHeight,
      sliderThumbSize: sliderThumbSize ?? this.sliderThumbSize,
      sliderThumbPadding: sliderThumbPadding ?? this.sliderThumbPadding,
      swatchWidth: swatchWidth ?? this.swatchWidth,
      swatchHeight: swatchHeight ?? this.swatchHeight,
      swatchRadius: swatchRadius ?? this.swatchRadius,
      swatchActiveBorderColor:
          swatchActiveBorderColor ?? this.swatchActiveBorderColor,
    );
  }

  @override
  TColorPickerThemeData lerp(
    ThemeExtension<TColorPickerThemeData>? other,
    double t,
  ) {
    if (other is! TColorPickerThemeData) {
      return this;
    }
    return TColorPickerThemeData(
      panelBackgroundColor:
          Color.lerp(panelBackgroundColor, other.panelBackgroundColor, t),
      panelRadius: lerpDouble(panelRadius, other.panelRadius, t),
      panelPadding: EdgeInsets.lerp(panelPadding, other.panelPadding, t),
      saturationHeight:
          lerpDouble(saturationHeight, other.saturationHeight, t),
      saturationRadius:
          lerpDouble(saturationRadius, other.saturationRadius, t),
      saturationThumbSize: lerpDouble(
        saturationThumbSize,
        other.saturationThumbSize,
        t,
      ),
      sliderHeight: lerpDouble(sliderHeight, other.sliderHeight, t),
      sliderThumbSize: lerpDouble(sliderThumbSize, other.sliderThumbSize, t),
      sliderThumbPadding:
          lerpDouble(sliderThumbPadding, other.sliderThumbPadding, t),
      swatchWidth: lerpDouble(swatchWidth, other.swatchWidth, t),
      swatchHeight: lerpDouble(swatchHeight, other.swatchHeight, t),
      swatchRadius: lerpDouble(swatchRadius, other.swatchRadius, t),
      swatchActiveBorderColor: Color.lerp(
        swatchActiveBorderColor,
        other.swatchActiveBorderColor,
        t,
      ),
    );
  }
}

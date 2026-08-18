import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import 't_slider_theme.dart';

/// Formats the value shown above a slider thumb.
typedef TSliderThumbFormatter = String Function(double value);

ShowValueIndicator _showValueIndicatorFor(int? divisions) => divisions == null
    ? ShowValueIndicator.onlyForContinuous
    : ShowValueIndicator.onlyForDiscrete;

SliderThemeData _sliderThemeWithTokenFallback(BuildContext context) {
  final inherited = SliderTheme.of(context);
  final token = context.tTheme;
  final brand = token.brandNormalColor;
  final component = token.bgColorComponent;
  final disabled = token.bgColorComponentDisabled;

  return inherited.copyWith(
    activeTrackColor: inherited.activeTrackColor ?? brand,
    inactiveTrackColor: inherited.inactiveTrackColor ?? component,
    secondaryActiveTrackColor:
        inherited.secondaryActiveTrackColor ?? brand.withAlpha(0x8a),
    disabledActiveTrackColor: inherited.disabledActiveTrackColor ?? disabled,
    disabledInactiveTrackColor:
        inherited.disabledInactiveTrackColor ?? disabled,
    disabledSecondaryActiveTrackColor:
        inherited.disabledSecondaryActiveTrackColor ?? disabled,
    activeTickMarkColor: inherited.activeTickMarkColor ?? brand,
    inactiveTickMarkColor: inherited.inactiveTickMarkColor ?? component,
    disabledActiveTickMarkColor:
        inherited.disabledActiveTickMarkColor ?? disabled,
    disabledInactiveTickMarkColor:
        inherited.disabledInactiveTickMarkColor ?? disabled,
    thumbColor: inherited.thumbColor ?? brand,
    disabledThumbColor: inherited.disabledThumbColor ?? disabled,
    overlayColor: inherited.overlayColor ?? brand.withAlpha(0x1f),
    valueIndicatorColor: inherited.valueIndicatorColor ?? brand,
    valueIndicatorStrokeColor: inherited.valueIndicatorStrokeColor ?? brand,
    valueIndicatorTextStyle:
        inherited.valueIndicatorTextStyle ??
        TextStyle(
          color: token.textColorAnti,
          fontSize: token.fontBodyLarge?.size,
          height: token.fontBodyLarge?.height,
          fontWeight: token.fontBodyLarge?.fontWeight,
        ).merge(Theme.of(context).tExplicitTextTheme?.bodyLarge),
  );
}

/// 基于 Material [Slider] 的严格受控单值滑块。
class TSlider extends StatelessWidget {
  const TSlider({
    super.key,

    /// 受控滑块值。
    required this.value,

    /// 值变更回调；为 null 时禁用。
    this.onChanged,

    /// 开始拖动时触发。
    this.onChangeStart,

    /// 结束拖动时触发。
    this.onChangeEnd,

    /// 最小值。
    this.min = 0,

    /// 最大值。
    this.max = 1,

    /// 离散刻度数；null 表示连续。
    this.divisions,

    /// 是否显示拇指上方数值。
    this.showThumbValue = false,

    /// 拇指上方数值格式化回调。
    this.thumbFormatter,

    /// 是否显示刻度值。
    this.showScaleValue = false,

    /// 刻度值格式化回调。
    this.scaleFormatter,
  }) : assert(max > min),
       assert(value >= min && value <= max),
       assert(divisions == null || divisions > 0),
       assert(!showScaleValue || divisions != null);

  /// 受控滑块值。
  final double value;

  /// 值变更回调；为 null 时禁用。
  final ValueChanged<double>? onChanged;

  /// 开始拖动时触发。
  final ValueChanged<double>? onChangeStart;

  /// 结束拖动时触发。
  final ValueChanged<double>? onChangeEnd;

  /// 最小值。
  final double min;

  /// 最大值。
  final double max;

  /// 离散刻度数；null 表示连续。
  final int? divisions;

  /// 是否显示拇指上方数值。
  final bool showThumbValue;

  /// 拇指上方数值格式化回调。
  final TSliderThumbFormatter? thumbFormatter;

  /// 是否显示刻度值；开启时必须提供 [divisions]。
  final bool showScaleValue;

  /// 刻度值格式化回调。
  final TSliderThumbFormatter? scaleFormatter;

  @override
  Widget build(BuildContext context) {
    final slider = Slider(
      value: value,
      onChanged: onChanged,
      onChangeStart: onChangeStart,
      onChangeEnd: onChangeEnd,
      min: min,
      max: max,
      divisions: divisions,
      label: showThumbValue
          ? (thumbFormatter?.call(value) ?? value.toStringAsFixed(2))
          : null,
    );
    final sliderTheme = _sliderThemeWithTokenFallback(context).copyWith(
      showValueIndicator:
          showThumbValue ? _showValueIndicatorFor(divisions) : null,
    );
    final decoration = Theme.of(
      context,
    ).extension<TSliderThemeData>()?.decoration;
    final themedSlider = SliderTheme(data: sliderTheme, child: slider);
    final safeDivisions = divisions != null && divisions! > 0
        ? divisions
        : null;
    final content = showScaleValue && safeDivisions != null
        ? _SliderWithScaleLabels(
            min: min,
            max: max,
            divisions: safeDivisions,
            formatter: scaleFormatter,
            slider: themedSlider,
          )
        : themedSlider;
    return decoration == null
        ? content
        : DecoratedBox(decoration: decoration, child: content);
  }
}

/// 基于 Material [RangeSlider] 的严格受控范围滑块。
class TRangeSlider extends StatelessWidget {
  const TRangeSlider({
    super.key,

    /// 受控范围值。
    required this.value,

    /// 范围变更回调；为 null 时禁用。
    this.onChanged,

    /// 开始拖动时触发。
    this.onChangeStart,

    /// 结束拖动时触发。
    this.onChangeEnd,

    /// 最小值。
    this.min = 0,

    /// 最大值。
    this.max = 1,

    /// 离散刻度数；null 表示连续。
    this.divisions,

    /// 是否显示拇指上方数值。
    this.showThumbValue = false,

    /// 拇指上方数值格式化回调。
    this.thumbFormatter,

    /// 是否显示刻度值。
    this.showScaleValue = false,

    /// 刻度值格式化回调。
    this.scaleFormatter,
  }) : assert(max > min),
       assert(divisions == null || divisions > 0),
       assert(!showScaleValue || divisions != null);

  /// 受控范围值。
  final RangeValues value;

  /// 范围变更回调；为 null 时禁用。
  final ValueChanged<RangeValues>? onChanged;

  /// 开始拖动时触发。
  final ValueChanged<RangeValues>? onChangeStart;

  /// 结束拖动时触发。
  final ValueChanged<RangeValues>? onChangeEnd;

  /// 最小值。
  final double min;

  /// 最大值。
  final double max;

  /// 离散刻度数；null 表示连续。
  final int? divisions;

  /// 是否显示拇指上方数值。
  final bool showThumbValue;

  /// 拇指上方数值格式化回调。
  final TSliderThumbFormatter? thumbFormatter;

  /// 是否显示刻度值；开启时必须提供 [divisions]。
  final bool showScaleValue;

  /// 刻度值格式化回调。
  final TSliderThumbFormatter? scaleFormatter;

  @override
  Widget build(BuildContext context) {
    final slider = RangeSlider(
      values: value,
      onChanged: onChanged,
      onChangeStart: onChangeStart,
      onChangeEnd: onChangeEnd,
      min: min,
      max: max,
      divisions: divisions,
      labels: showThumbValue
          ? RangeLabels(
              thumbFormatter?.call(value.start) ??
                  value.start.toStringAsFixed(2),
              thumbFormatter?.call(value.end) ?? value.end.toStringAsFixed(2),
            )
          : null,
    );
    final sliderTheme = _sliderThemeWithTokenFallback(context).copyWith(
      showValueIndicator:
          showThumbValue ? _showValueIndicatorFor(divisions) : null,
    );
    final decoration = Theme.of(
      context,
    ).extension<TSliderThemeData>()?.decoration;
    final themedSlider = SliderTheme(data: sliderTheme, child: slider);
    final safeDivisions = divisions != null && divisions! > 0
        ? divisions
        : null;
    final content = showScaleValue && safeDivisions != null
        ? _SliderWithScaleLabels(
            min: min,
            max: max,
            divisions: safeDivisions,
            formatter: scaleFormatter,
            slider: themedSlider,
          )
        : themedSlider;
    return decoration == null
        ? content
        : DecoratedBox(decoration: decoration, child: content);
  }
}

class _SliderWithScaleLabels extends StatelessWidget {
  const _SliderWithScaleLabels({
    required this.min,
    required this.max,
    required this.divisions,
    required this.formatter,
    required this.slider,
  });

  final double min;
  final double max;
  final int divisions;
  final TSliderThumbFormatter? formatter;
  final Widget slider;

  @override
  Widget build(BuildContext context) {
    final labels = List<Widget>.generate(divisions + 1, (index) {
      final value = min + (max - min) * index / divisions;
      final text = formatter?.call(value) ?? value.toString();
      return Expanded(
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      );
    });
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        slider,
        Row(children: labels),
      ],
    );
  }
}

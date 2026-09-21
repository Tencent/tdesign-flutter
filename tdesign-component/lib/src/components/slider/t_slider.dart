import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import 't_slider_theme.dart';

/// Formats the value shown above a slider thumb.
typedef TSliderThumbFormatter = String Function(double value);

/// Slider visual structure.
enum TSliderVariant {
  /// Standard thin track.
  normal,

  /// Capsule track with a 3px inset active segment and 20px thumbs.
  capsule,
}

const double _kScaleTickRadius = 3;
const double _kCapsuleTrackHeight = 16;
const double _kCapsuleTrackInset = 3;

SliderThemeData _sliderThemeWithTokenFallback(BuildContext context) {
  final inherited = SliderTheme.of(context);
  final material = Theme.of(context);
  final colorScheme = material.tExplicitColorScheme;
  final token = context.tTheme;
  final brand = token.brandNormalColor;
  final inactiveTrack = token.bgColorComponentHover;
  final disabledComponent = token.bgColorComponentDisabled;
  final disabledBrand = token.brandDisabledColor;
  final thumb = colorScheme?.primary ?? token.textColorAnti;
  final disabledThumb = colorScheme == null
      ? token.textColorAnti
      : colorScheme.onSurface.withValues(alpha: 0.38);
  final thumbBorder = colorScheme?.outline ?? token.grayColor1;
  final disabledThumbBorder =
      colorScheme?.outlineVariant ?? token.bgColorComponentDisabled;

  return inherited.copyWith(
    activeTrackColor:
        inherited.activeTrackColor ?? colorScheme?.primary ?? brand,
    inactiveTrackColor:
        inherited.inactiveTrackColor ??
        colorScheme?.surfaceContainerHighest ??
        inactiveTrack,
    secondaryActiveTrackColor:
        inherited.secondaryActiveTrackColor ??
        colorScheme?.primary.withValues(alpha: 0.54) ??
        brand.withAlpha(0x8a),
    disabledActiveTrackColor:
        inherited.disabledActiveTrackColor ??
        colorScheme?.primary.withValues(alpha: 0.38) ??
        disabledBrand,
    disabledInactiveTrackColor:
        inherited.disabledInactiveTrackColor ??
        colorScheme?.onSurface.withValues(alpha: 0.12) ??
        disabledComponent,
    disabledSecondaryActiveTrackColor:
        inherited.disabledSecondaryActiveTrackColor ??
        colorScheme?.primary.withValues(alpha: 0.38) ??
        disabledBrand,
    activeTickMarkColor:
        inherited.activeTickMarkColor ?? colorScheme?.primary ?? brand,
    inactiveTickMarkColor:
        inherited.inactiveTickMarkColor ??
        colorScheme?.surfaceContainerHighest ??
        inactiveTrack,
    disabledActiveTickMarkColor:
        inherited.disabledActiveTickMarkColor ??
        colorScheme?.primary.withValues(alpha: 0.38) ??
        disabledBrand,
    disabledInactiveTickMarkColor:
        inherited.disabledInactiveTickMarkColor ??
        colorScheme?.onSurface.withValues(alpha: 0.12) ??
        disabledComponent,
    tickMarkShape:
        inherited.tickMarkShape ??
        const RoundSliderTickMarkShape(tickMarkRadius: _kScaleTickRadius),
    rangeTickMarkShape:
        inherited.rangeTickMarkShape ??
        const RoundRangeSliderTickMarkShape(tickMarkRadius: _kScaleTickRadius),
    thumbColor: inherited.thumbColor ?? thumb,
    disabledThumbColor: inherited.disabledThumbColor ?? disabledThumb,
    thumbShape:
        inherited.thumbShape ??
        _TDesignSliderThumbShape(
          borderColor: thumbBorder,
          disabledBorderColor: disabledThumbBorder,
        ),
    rangeThumbShape:
        inherited.rangeThumbShape ??
        _TDesignRangeSliderThumbShape(
          borderColor: thumbBorder,
          disabledBorderColor: disabledThumbBorder,
        ),
    overlayColor:
        inherited.overlayColor ??
        colorScheme?.primary.withValues(alpha: 0.12) ??
        brand.withAlpha(0x1f),
    valueIndicatorColor:
        inherited.valueIndicatorColor ?? colorScheme?.primary ?? brand,
    valueIndicatorStrokeColor:
        inherited.valueIndicatorStrokeColor ?? colorScheme?.primary ?? brand,
    valueIndicatorTextStyle:
        inherited.valueIndicatorTextStyle ??
        TextStyle(
          color: colorScheme?.onSurface ?? token.textColorPrimary,
          fontSize: token.fontBodyMedium?.size,
          height: token.fontBodyMedium?.height,
          fontWeight: token.fontBodyMedium?.fontWeight,
        ).merge(material.tExplicitTextTheme?.bodyMedium),
  );
}

SliderThemeData _resolveSliderTheme(
  BuildContext context,
  TSliderVariant variant,
) {
  final inherited = SliderTheme.of(context);
  final base = _sliderThemeWithTokenFallback(context);
  if (variant == TSliderVariant.normal) {
    return base;
  }
  final token = context.tTheme;
  return base.copyWith(
    trackHeight: _kCapsuleTrackHeight,
    trackShape: const _CapsuleSliderTrackShape(),
    rangeTrackShape: const _CapsuleRangeSliderTrackShape(),
    tickMarkShape: const _CapsuleSliderTickMarkShape(),
    rangeTickMarkShape: const _CapsuleRangeSliderTickMarkShape(),
    activeTickMarkColor:
        inherited.activeTickMarkColor ?? token.bgColorContainer,
    inactiveTickMarkColor:
        inherited.inactiveTickMarkColor ?? token.bgColorSecondaryContainer,
    disabledActiveTickMarkColor:
        inherited.disabledActiveTickMarkColor ?? token.bgColorContainer,
    disabledInactiveTickMarkColor:
        inherited.disabledInactiveTickMarkColor ??
        token.bgColorSecondaryContainer,
  );
}

Color _disabledThumbLabelColor(BuildContext context) {
  final inheritedColor = SliderTheme.of(context).valueIndicatorTextStyle?.color;
  if (inheritedColor != null) {
    return inheritedColor.withValues(alpha: 0.38);
  }
  return Theme.of(
        context,
      ).tExplicitColorScheme?.onSurface.withValues(alpha: 0.38) ??
      context.tTheme.textDisabledColor;
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

    /// 是否持续显示拇指上方数值。
    this.showThumbValue = false,

    /// 拇指上方数值格式化回调。
    this.thumbFormatter,

    /// 是否显示刻度值。
    this.showScaleValue = false,

    /// 刻度值格式化回调。
    this.scaleFormatter,

    /// 滑块视觉结构，默认使用标准细轨道。
    this.variant = TSliderVariant.normal,
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

  /// 是否持续显示拇指上方数值。
  final bool showThumbValue;

  /// 拇指上方数值格式化回调。
  final TSliderThumbFormatter? thumbFormatter;

  /// 是否显示刻度值；开启时必须提供 [divisions]。
  final bool showScaleValue;

  /// 刻度值格式化回调。
  final TSliderThumbFormatter? scaleFormatter;

  /// 滑块视觉结构。
  final TSliderVariant variant;

  @override
  Widget build(BuildContext context) {
    final label = showThumbValue
        ? (thumbFormatter?.call(value) ?? value.toStringAsFixed(2))
        : null;
    final slider = Slider(
      value: value,
      onChanged: onChanged,
      onChangeStart: onChangeStart,
      onChangeEnd: onChangeEnd,
      min: min,
      max: max,
      divisions: divisions,
      label: label,
    );
    final baseTheme = _resolveSliderTheme(context, variant);
    final sliderTheme = baseTheme.copyWith(
      showValueIndicator: showThumbValue ? ShowValueIndicator.never : null,
      thumbShape: label == null
          ? baseTheme.thumbShape
          : _LabeledSliderThumbShape(
              base: baseTheme.thumbShape!,
              label: label,
              disabledLabelColor: _disabledThumbLabelColor(context),
            ),
    );
    final decoration = Theme.of(
      context,
    ).extension<TSliderThemeData>()?.decoration;
    final themedSlider = SliderTheme(data: sliderTheme, child: slider);
    final sliderContent = showThumbValue
        ? Padding(padding: const EdgeInsets.only(top: 20), child: themedSlider)
        : themedSlider;
    final safeDivisions = divisions != null && divisions! > 0
        ? divisions
        : null;
    final content = showScaleValue && safeDivisions != null
        ? _SliderWithScaleLabels(
            min: min,
            max: max,
            divisions: safeDivisions,
            formatter: scaleFormatter,
            slider: sliderContent,
          )
        : sliderContent;
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

    /// 是否持续显示拇指上方数值。
    this.showThumbValue = false,

    /// 拇指上方数值格式化回调。
    this.thumbFormatter,

    /// 是否显示刻度值。
    this.showScaleValue = false,

    /// 刻度值格式化回调。
    this.scaleFormatter,

    /// 滑块视觉结构，默认使用标准细轨道。
    this.variant = TSliderVariant.normal,
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

  /// 是否持续显示拇指上方数值。
  final bool showThumbValue;

  /// 拇指上方数值格式化回调。
  final TSliderThumbFormatter? thumbFormatter;

  /// 是否显示刻度值；开启时必须提供 [divisions]。
  final bool showScaleValue;

  /// 刻度值格式化回调。
  final TSliderThumbFormatter? scaleFormatter;

  /// 滑块视觉结构。
  final TSliderVariant variant;

  @override
  Widget build(BuildContext context) {
    assert(value.start >= min && value.end <= max);
    final labels = showThumbValue
        ? RangeLabels(
            thumbFormatter?.call(value.start) ?? value.start.toStringAsFixed(2),
            thumbFormatter?.call(value.end) ?? value.end.toStringAsFixed(2),
          )
        : null;
    final slider = RangeSlider(
      values: value,
      onChanged: onChanged,
      onChangeStart: onChangeStart,
      onChangeEnd: onChangeEnd,
      min: min,
      max: max,
      divisions: divisions,
      labels: labels,
    );
    final baseTheme = _resolveSliderTheme(context, variant);
    final sliderTheme = baseTheme.copyWith(
      showValueIndicator: showThumbValue ? ShowValueIndicator.never : null,
      rangeThumbShape: labels == null
          ? baseTheme.rangeThumbShape
          : _LabeledRangeSliderThumbShape(
              base: baseTheme.rangeThumbShape!,
              labels: labels,
              disabledLabelColor: _disabledThumbLabelColor(context),
            ),
    );
    final decoration = Theme.of(
      context,
    ).extension<TSliderThemeData>()?.decoration;
    final themedSlider = SliderTheme(data: sliderTheme, child: slider);
    final sliderContent = showThumbValue
        ? Padding(padding: const EdgeInsets.only(top: 20), child: themedSlider)
        : themedSlider;
    final safeDivisions = divisions != null && divisions! > 0
        ? divisions
        : null;
    final content = showScaleValue && safeDivisions != null
        ? _SliderWithScaleLabels(
            min: min,
            max: max,
            divisions: safeDivisions,
            formatter: scaleFormatter,
            slider: sliderContent,
          )
        : sliderContent;
    return decoration == null
        ? content
        : DecoratedBox(decoration: decoration, child: content);
  }
}

class _CapsuleSliderTrackShape extends RoundedRectSliderTrackShape {
  const _CapsuleSliderTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    if (trackRect.isEmpty) {
      return;
    }
    final inactiveColor = Color.lerp(
      sliderTheme.disabledInactiveTrackColor,
      sliderTheme.inactiveTrackColor,
      enableAnimation.value,
    )!;
    final activeColor = Color.lerp(
      sliderTheme.disabledActiveTrackColor,
      sliderTheme.activeTrackColor,
      enableAnimation.value,
    )!;
    final outerRadius = Radius.circular(trackRect.height / 2);
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, outerRadius),
      Paint()..color = inactiveColor,
    );

    final innerTop = trackRect.top + _kCapsuleTrackInset;
    final innerBottom = trackRect.bottom - _kCapsuleTrackInset;
    final activeRect = textDirection == TextDirection.ltr
        ? Rect.fromLTRB(
            trackRect.left + _kCapsuleTrackInset,
            innerTop,
            thumbCenter.dx,
            innerBottom,
          )
        : Rect.fromLTRB(
            thumbCenter.dx,
            innerTop,
            trackRect.right - _kCapsuleTrackInset,
            innerBottom,
          );
    if (activeRect.width > 0 && activeRect.height > 0) {
      context.canvas.drawRRect(
        RRect.fromRectAndRadius(
          activeRect,
          Radius.circular(activeRect.height / 2),
        ),
        Paint()..color = activeColor,
      );
    }
  }
}

class _CapsuleRangeSliderTrackShape extends RoundedRectRangeSliderTrackShape {
  const _CapsuleRangeSliderTrackShape();

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset startThumbCenter,
    required Offset endThumbCenter,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
    double additionalActiveTrackHeight = 2,
  }) {
    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    if (trackRect.isEmpty) {
      return;
    }
    final inactiveColor = Color.lerp(
      sliderTheme.disabledInactiveTrackColor,
      sliderTheme.inactiveTrackColor,
      enableAnimation.value,
    )!;
    final activeColor = Color.lerp(
      sliderTheme.disabledActiveTrackColor,
      sliderTheme.activeTrackColor,
      enableAnimation.value,
    )!;
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, Radius.circular(trackRect.height / 2)),
      Paint()..color = inactiveColor,
    );

    final left = math.min(startThumbCenter.dx, endThumbCenter.dx);
    final right = math.max(startThumbCenter.dx, endThumbCenter.dx);
    final activeRect = Rect.fromLTRB(
      left,
      trackRect.top + _kCapsuleTrackInset,
      right,
      trackRect.bottom - _kCapsuleTrackInset,
    );
    if (activeRect.width > 0 && activeRect.height > 0) {
      context.canvas.drawRRect(
        RRect.fromRectAndRadius(
          activeRect,
          Radius.circular(activeRect.height / 2),
        ),
        Paint()..color = activeColor,
      );
    }
  }
}

class _CapsuleSliderTickMarkShape extends SliderTickMarkShape {
  const _CapsuleSliderTickMarkShape();

  @override
  Size getPreferredSize({
    required SliderThemeData sliderTheme,
    required bool isEnabled,
  }) => const Size(2, _kCapsuleTrackHeight - 2 * _kCapsuleTrackInset);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    required bool isEnabled,
    required TextDirection textDirection,
  }) {
    final active = switch (textDirection) {
      TextDirection.ltr => center.dx <= thumbCenter.dx,
      TextDirection.rtl => center.dx >= thumbCenter.dx,
    };
    final color = Color.lerp(
      active
          ? sliderTheme.disabledActiveTickMarkColor
          : sliderTheme.disabledInactiveTickMarkColor,
      active
          ? sliderTheme.activeTickMarkColor
          : sliderTheme.inactiveTickMarkColor,
      enableAnimation.value,
    )!;
    _paintCapsuleTick(context.canvas, center, color);
  }
}

class _CapsuleRangeSliderTickMarkShape extends RangeSliderTickMarkShape {
  const _CapsuleRangeSliderTickMarkShape();

  @override
  Size getPreferredSize({
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
  }) => const Size(2, _kCapsuleTrackHeight - 2 * _kCapsuleTrackInset);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset startThumbCenter,
    required Offset endThumbCenter,
    bool isEnabled = false,
    required TextDirection textDirection,
  }) {
    final left = math.min(startThumbCenter.dx, endThumbCenter.dx);
    final right = math.max(startThumbCenter.dx, endThumbCenter.dx);
    final active = center.dx >= left && center.dx <= right;
    final color = Color.lerp(
      active
          ? sliderTheme.disabledActiveTickMarkColor
          : sliderTheme.disabledInactiveTickMarkColor,
      active
          ? sliderTheme.activeTickMarkColor
          : sliderTheme.inactiveTickMarkColor,
      enableAnimation.value,
    )!;
    _paintCapsuleTick(context.canvas, center, color);
  }
}

void _paintCapsuleTick(Canvas canvas, Offset center, Color color) {
  final rect = Rect.fromCenter(
    center: center,
    width: 2,
    height: _kCapsuleTrackHeight - 2 * _kCapsuleTrackInset,
  );
  canvas.drawRRect(
    RRect.fromRectAndRadius(rect, const Radius.circular(1)),
    Paint()..color = color,
  );
}

class _TDesignSliderThumbShape extends SliderComponentShape {
  const _TDesignSliderThumbShape({
    required this.borderColor,
    required this.disabledBorderColor,
  });

  final Color borderColor;
  final Color disabledBorderColor;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      const Size.fromRadius(10);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    _paintTDesignThumb(
      context.canvas,
      center,
      enableAnimation: enableAnimation,
      activationAnimation: activationAnimation,
      sliderTheme: sliderTheme,
      borderColor: borderColor,
      disabledBorderColor: disabledBorderColor,
    );
  }
}

class _TDesignRangeSliderThumbShape extends RangeSliderThumbShape {
  const _TDesignRangeSliderThumbShape({
    required this.borderColor,
    required this.disabledBorderColor,
  });

  final Color borderColor;
  final Color disabledBorderColor;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      const Size.fromRadius(10);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool isOnTop = false,
    TextDirection textDirection = TextDirection.ltr,
    required SliderThemeData sliderTheme,
    Thumb thumb = Thumb.start,
    bool isPressed = false,
  }) {
    _paintTDesignThumb(
      context.canvas,
      center,
      enableAnimation: enableAnimation,
      activationAnimation: activationAnimation,
      sliderTheme: sliderTheme,
      borderColor: borderColor,
      disabledBorderColor: disabledBorderColor,
    );
  }
}

void _paintTDesignThumb(
  Canvas canvas,
  Offset center, {
  required Animation<double> enableAnimation,
  required Animation<double> activationAnimation,
  required SliderThemeData sliderTheme,
  required Color borderColor,
  required Color disabledBorderColor,
}) {
  const radius = 10.0;
  final fill = Color.lerp(
    sliderTheme.disabledThumbColor,
    sliderTheme.thumbColor,
    enableAnimation.value,
  )!;
  final border = Color.lerp(
    disabledBorderColor,
    borderColor,
    enableAnimation.value,
  )!;
  final path = Path()..addOval(Rect.fromCircle(center: center, radius: radius));
  canvas.drawShadow(
    path,
    Colors.black,
    1 + 2 * activationAnimation.value,
    true,
  );
  canvas.drawCircle(center, radius, Paint()..color = fill);
  canvas.drawCircle(
    center,
    radius,
    Paint()
      ..color = border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1,
  );
}

class _LabeledSliderThumbShape extends SliderComponentShape {
  const _LabeledSliderThumbShape({
    required this.base,
    required this.label,
    required this.disabledLabelColor,
  });

  final SliderComponentShape base;
  final String label;
  final Color disabledLabelColor;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      base.getPreferredSize(isEnabled, isDiscrete);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    base.paint(
      context,
      center,
      activationAnimation: activationAnimation,
      enableAnimation: enableAnimation,
      isDiscrete: isDiscrete,
      labelPainter: labelPainter,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      textDirection: textDirection,
      value: value,
      textScaleFactor: textScaleFactor,
      sizeWithOverflow: sizeWithOverflow,
    );
    _paintThumbLabel(
      context.canvas,
      center,
      label,
      sliderTheme,
      textDirection,
      enableAnimation: enableAnimation,
      disabledColor: disabledLabelColor,
    );
  }
}

class _LabeledRangeSliderThumbShape extends RangeSliderThumbShape {
  const _LabeledRangeSliderThumbShape({
    required this.base,
    required this.labels,
    required this.disabledLabelColor,
  });

  final RangeSliderThumbShape base;
  final RangeLabels labels;
  final Color disabledLabelColor;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      base.getPreferredSize(isEnabled, isDiscrete);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool isOnTop = false,
    TextDirection textDirection = TextDirection.ltr,
    required SliderThemeData sliderTheme,
    Thumb thumb = Thumb.start,
    bool isPressed = false,
  }) {
    base.paint(
      context,
      center,
      activationAnimation: activationAnimation,
      enableAnimation: enableAnimation,
      isDiscrete: isDiscrete,
      isEnabled: isEnabled,
      isOnTop: isOnTop,
      textDirection: textDirection,
      sliderTheme: sliderTheme,
      thumb: thumb,
      isPressed: isPressed,
    );
    _paintThumbLabel(
      context.canvas,
      center,
      thumb == Thumb.start ? labels.start : labels.end,
      sliderTheme,
      textDirection,
      enableAnimation: enableAnimation,
      disabledColor: disabledLabelColor,
    );
  }
}

void _paintThumbLabel(
  Canvas canvas,
  Offset center,
  String label,
  SliderThemeData sliderTheme,
  TextDirection textDirection, {
  required Animation<double> enableAnimation,
  required Color disabledColor,
}) {
  final enabledStyle = sliderTheme.valueIndicatorTextStyle!;
  final textColor = Color.lerp(
    disabledColor,
    enabledStyle.color ?? disabledColor,
    enableAnimation.value,
  );
  final painter = TextPainter(
    text: TextSpan(
      text: label,
      style: enabledStyle.copyWith(color: textColor),
    ),
    textDirection: textDirection,
    maxLines: 1,
  )..layout();
  painter.paint(
    canvas,
    Offset(center.dx - painter.width / 2, center.dy - painter.height - 16),
  );
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

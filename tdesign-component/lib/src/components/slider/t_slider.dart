import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_spacers.dart';
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
const double _kCapsuleTrackInset = 3;
const double _kCapsuleGapWidth = 2;

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
  int? divisions,
) {
  final inherited = SliderTheme.of(context);
  final base = _sliderThemeWithTokenFallback(context);
  final token = context.tTheme;
  if (variant == TSliderVariant.normal) {
    return base.copyWith(
      trackHeight: inherited.trackHeight ?? token.spacer4,
      trackShape:
          inherited.trackShape ??
          _TDesignSliderTrackShape(horizontalInset: token.spacer16),
      rangeTrackShape:
          inherited.rangeTrackShape ??
          _TDesignRangeSliderTrackShape(horizontalInset: token.spacer16),
    );
  }
  return base.copyWith(
    trackHeight: token.spacer24,
    trackShape: _CapsuleSliderTrackShape(
      horizontalInset: token.spacer16,
      outerColor: token.bgColorComponent,
      divisions: divisions,
    ),
    rangeTrackShape: _CapsuleRangeSliderTrackShape(
      horizontalInset: token.spacer16,
      outerColor: token.bgColorComponent,
      divisions: divisions,
    ),
    tickMarkShape: SliderTickMarkShape.noTickMark,
    rangeTickMarkShape: const _CapsuleRangeSliderTickMarkShape(),
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
    final baseTheme = _resolveSliderTheme(context, variant, divisions);
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
        ? Padding(
            padding: EdgeInsets.only(top: context.tTheme.spacer16),
            child: themedSlider,
          )
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
    final baseTheme = _resolveSliderTheme(context, variant, divisions);
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
        ? Padding(
            padding: EdgeInsets.only(top: context.tTheme.spacer16),
            child: themedSlider,
          )
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

Rect _preferredTrackRect({
  required RenderBox parentBox,
  required Offset offset,
  required SliderThemeData sliderTheme,
  required double horizontalInset,
}) {
  final trackHeight = sliderTheme.trackHeight ?? 0;
  final trackWidth = math.max(0.0, parentBox.size.width - 2 * horizontalInset);
  return Rect.fromLTWH(
    offset.dx + horizontalInset,
    offset.dy + (parentBox.size.height - trackHeight) / 2,
    trackWidth,
    trackHeight,
  );
}

Rect _capsuleMaterialTrackRect({
  required RenderBox parentBox,
  required Offset offset,
  required SliderThemeData sliderTheme,
  required double horizontalInset,
}) {
  final visualRect = _preferredTrackRect(
    parentBox: parentBox,
    offset: offset,
    sliderTheme: sliderTheme,
    horizontalInset: horizontalInset,
  );
  // Material reserves half a track height at each end for discrete values.
  // Extend its coordinate track so values map across the visible inset track.
  final extension = visualRect.height / 2 - _kCapsuleTrackInset;
  return Rect.fromLTRB(
    visualRect.left - extension,
    visualRect.top,
    visualRect.right + extension,
    visualRect.bottom,
  );
}

Rect _capsuleVisualTrackRect(Rect materialRect) {
  final extension = materialRect.height / 2 - _kCapsuleTrackInset;
  return Rect.fromLTRB(
    materialRect.left + extension,
    materialRect.top,
    materialRect.right - extension,
    materialRect.bottom,
  );
}

void _paintCapsuleSegments(
  Canvas canvas, {
  required Rect trackRect,
  required Color outerColor,
  required Color inactiveColor,
  required Color activeColor,
  required double activeLeft,
  required double activeRight,
  required int? divisions,
}) {
  canvas.drawRRect(
    RRect.fromRectAndRadius(trackRect, Radius.circular(trackRect.height / 2)),
    Paint()..color = outerColor,
  );
  final innerRect = trackRect.deflate(_kCapsuleTrackInset);
  if (innerRect.isEmpty) {
    return;
  }

  canvas.save();
  canvas.clipRRect(
    RRect.fromRectAndRadius(innerRect, Radius.circular(innerRect.height / 2)),
  );
  final count = divisions ?? 1;
  // Figma spaces divider centers across the outer capsule's usable width;
  // the painted inner track keeps its 3px inset on every side.
  final dividerLeft = trackRect.left + _kCapsuleTrackInset / 2;
  final dividerStep = (trackRect.width - _kCapsuleTrackInset) / count;
  final gapHalf = dividerStep > _kCapsuleGapWidth ? _kCapsuleGapWidth / 2 : 0.0;
  for (var index = 0; index < count; index++) {
    // Leave a 2px unpainted gap when the division is wide enough.
    final left = math.max(
      innerRect.left,
      index == 0 ? innerRect.left : dividerLeft + index * dividerStep + gapHalf,
    );
    final right = math.min(
      innerRect.right,
      index == count - 1
          ? innerRect.right
          : dividerLeft + (index + 1) * dividerStep - gapHalf,
    );
    if (right <= left) {
      continue;
    }
    final segment = Rect.fromLTRB(left, innerRect.top, right, innerRect.bottom);
    canvas.drawRect(segment, Paint()..color = inactiveColor);
    final selected = segment.intersect(
      Rect.fromLTRB(activeLeft, innerRect.top, activeRight, innerRect.bottom),
    );
    if (!selected.isEmpty) {
      canvas.drawRect(selected, Paint()..color = activeColor);
    }
  }
  canvas.restore();
}

class _TDesignSliderTrackShape extends RoundedRectSliderTrackShape {
  const _TDesignSliderTrackShape({required this.horizontalInset});

  final double horizontalInset;

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) => _preferredTrackRect(
    parentBox: parentBox,
    offset: offset,
    sliderTheme: sliderTheme,
    horizontalInset: horizontalInset,
  );

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
    super.paint(
      context,
      offset,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      enableAnimation: enableAnimation,
      textDirection: textDirection,
      thumbCenter: thumbCenter,
      secondaryOffset: secondaryOffset,
      isDiscrete: isDiscrete,
      isEnabled: isEnabled,
      additionalActiveTrackHeight: 0,
    );
  }
}

class _TDesignRangeSliderTrackShape extends RoundedRectRangeSliderTrackShape {
  const _TDesignRangeSliderTrackShape({required this.horizontalInset});

  final double horizontalInset;

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) => _preferredTrackRect(
    parentBox: parentBox,
    offset: offset,
    sliderTheme: sliderTheme,
    horizontalInset: horizontalInset,
  );

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
    super.paint(
      context,
      offset,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      enableAnimation: enableAnimation,
      startThumbCenter: startThumbCenter,
      endThumbCenter: endThumbCenter,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
      textDirection: textDirection,
      additionalActiveTrackHeight: 0,
    );
  }
}

class _CapsuleSliderTrackShape extends RoundedRectSliderTrackShape {
  const _CapsuleSliderTrackShape({
    required this.horizontalInset,
    required this.outerColor,
    required this.divisions,
  });

  final double horizontalInset;
  final Color outerColor;
  final int? divisions;

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) => _capsuleMaterialTrackRect(
    parentBox: parentBox,
    offset: offset,
    sliderTheme: sliderTheme,
    horizontalInset: horizontalInset,
  );

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
    final trackRect = _capsuleVisualTrackRect(
      getPreferredRect(
        parentBox: parentBox,
        offset: offset,
        sliderTheme: sliderTheme,
        isEnabled: isEnabled,
        isDiscrete: isDiscrete,
      ),
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
    final innerRect = trackRect.deflate(_kCapsuleTrackInset);
    _paintCapsuleSegments(
      context.canvas,
      trackRect: trackRect,
      outerColor: outerColor,
      inactiveColor: inactiveColor,
      activeColor: activeColor,
      activeLeft: textDirection == TextDirection.ltr
          ? innerRect.left
          : thumbCenter.dx,
      activeRight: textDirection == TextDirection.ltr
          ? thumbCenter.dx
          : innerRect.right,
      divisions: divisions,
    );
  }
}

class _CapsuleRangeSliderTrackShape extends RoundedRectRangeSliderTrackShape {
  const _CapsuleRangeSliderTrackShape({
    required this.horizontalInset,
    required this.outerColor,
    required this.divisions,
  });

  final double horizontalInset;
  final Color outerColor;
  final int? divisions;

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) => _capsuleMaterialTrackRect(
    parentBox: parentBox,
    offset: offset,
    sliderTheme: sliderTheme,
    horizontalInset: horizontalInset,
  );

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
    final trackRect = _capsuleVisualTrackRect(
      getPreferredRect(
        parentBox: parentBox,
        offset: offset,
        sliderTheme: sliderTheme,
        isEnabled: isEnabled,
        isDiscrete: isDiscrete,
      ),
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
    final left = math.min(startThumbCenter.dx, endThumbCenter.dx);
    final right = math.max(startThumbCenter.dx, endThumbCenter.dx);
    _paintCapsuleSegments(
      context.canvas,
      trackRect: trackRect,
      outerColor: outerColor,
      inactiveColor: inactiveColor,
      activeColor: activeColor,
      activeLeft: left,
      activeRight: right,
      divisions: divisions,
    );
  }
}

class _CapsuleRangeSliderTickMarkShape extends RangeSliderTickMarkShape {
  const _CapsuleRangeSliderTickMarkShape();

  @override
  Size getPreferredSize({
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
  }) => Size.zero;

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
  }) {}
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
      final isFirst = index == 0;
      final isLast = index == divisions;
      return Expanded(
        flex: isFirst || isLast ? 1 : 2,
        child: Align(
          alignment: isFirst
              ? AlignmentDirectional.centerStart
              : isLast
              ? AlignmentDirectional.centerEnd
              : Alignment.center,
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      );
    });
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.tTheme.spacer16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: labels,
          ),
        ),
        slider,
      ],
    );
  }
}

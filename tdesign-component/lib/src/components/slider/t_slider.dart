import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_internal_material.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../text/t_text_resolve.dart';
import '../text/t_text_styled.dart';
import 't_slider_geometry.dart';
import 't_slider_theme.dart';

/// 格式化滑块提示文案。
/// [value] 当前滑块数值。
///
/// ## 返回值
/// 显示在滑块提示中的格式化文案。
typedef TSliderThumbFormatter = String Function(double value);

/// 滑块视觉结构。
enum TSliderVariant {
  /// 标准细轨道。
  normal,

  /// 胶囊轨道，默认激活区四周内缩 3px，20px thumb 沿轨道方向两端各留 3px，默认横截面两侧各留 2px。
  /// 空间充足时轨道高度至少为 24px；厚度受横轴约束，行程不足时按比例缩小。
  capsule,
}

const double _kThumbRadius = SliderGeometry.thumbDiameter / 2;

// Each component owns this size cache. Native track layout supplies the actual
// RenderBox before painting the range thumb, whose API has no parentBox.
class _SliderGeometryLayout {
  _SliderGeometryLayout(this.geometry) : _size = geometry.preferredSize;
  final SliderGeometry geometry;
  Size _size;
  _SliderPointerState pointer = _SliderPointerState();
  RenderBox? viewport;
  ValueChanged<Offset>? pointerMove;
  void suppressUnavailableInteraction() {
    pointer.suppressed = true;
    final id = pointer.id;
    if (id != null) {
      GestureBinding.instance.cancelPointer(id);
    }
  }

  SliderMetrics get metrics => geometry.forSize(_size);
  SliderMetrics forConstraints(BoxConstraints constraints) {
    _size = geometry.sizeForConstraints(constraints);
    return metrics;
  }

  SliderMetrics forBox(RenderBox box) {
    _size = box.size;
    return metrics;
  }
}

class _SliderPointerState {
  int? id;
  Offset? position;
  bool singleActive = false;
  bool nativeAction = false;
  bool rangeActive = false;
  bool suppressed = false;
  double? singleValue;
}

// A disappearing viewport ends its pointer interaction. Positive resizes keep
// the same native gesture; no zero-length coordinate division is dispatched.
class _SliderGeometryViewport extends SingleChildRenderObjectWidget {
  const _SliderGeometryViewport({required this.layout, required super.child});
  final _SliderGeometryLayout layout;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderSliderGeometryViewport(layout);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderSliderGeometryViewport renderObject,
  ) {
    renderObject.updateLayoutMetrics(layout);
  }
}

class _RenderSliderGeometryViewport extends RenderProxyBox {
  _RenderSliderGeometryViewport(this._layout);
  _SliderGeometryLayout _layout;
  final _pointers = <int>{};

  void updateLayoutMetrics(_SliderGeometryLayout value) {
    value.pointer = _layout.pointer;
    value.viewport = this;
    _layout = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) =>
      _layout.geometry.preferredSize.width;
  @override
  double computeMaxIntrinsicWidth(double height) =>
      _layout.geometry.preferredSize.width;
  @override
  double computeMinIntrinsicHeight(double width) =>
      _layout.geometry.preferredSize.height;
  @override
  double computeMaxIntrinsicHeight(double width) =>
      _layout.geometry.preferredSize.height;
  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      _layout.geometry.sizeForConstraints(constraints);

  // Like the native slider, this control has no text baseline. Do not ask
  // the constraint builder to run a speculative layout for baseline queries.
  @override
  double? computeDryBaseline(
    BoxConstraints constraints,
    TextBaseline baseline,
  ) => null;

  @override
  void performLayout() {
    super.performLayout();
    _layout.viewport = this;
    if (!_layout.forBox(this).hasTravel &&
        (_layout.pointer.singleActive || _layout.pointer.rangeActive)) {
      for (final pointer in _pointers) {
        GestureBinding.instance.cancelPointer(pointer);
      }
      _pointers.clear();
    }
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is PointerDownEvent) {
      _pointers.add(event.pointer);
      _layout.pointer.id ??= event.pointer;
    }
    final pointer = _layout.pointer;
    if (pointer.id == event.pointer && event is! PointerCancelEvent) {
      pointer.position = event.position;
      if (event is PointerMoveEvent && pointer.singleActive) {
        _layout.pointerMove?.call(event.position);
      }
    }
    if (event is PointerUpEvent || event is PointerCancelEvent) {
      _pointers.remove(event.pointer);
      scheduleMicrotask(() {
        if (pointer.id == event.pointer) {
          pointer.id = null;
        }
      });
    }
    super.handleEvent(event, entry);
  }
}

SliderThemeData _sliderThemeFromTDesign(
  BuildContext context,
  SliderGeometry geometry,
  _SliderGeometryLayout layout,
) {
  final token = context.tTheme;
  final theme = Theme.of(context).extension<TSliderThemeData>();
  final brand = token.brandColor;
  final activeTrack = theme?.activeTrackColor ?? brand;
  final inactiveTrack = theme?.inactiveTrackColor ?? token.componentBorder;
  final disabledComponent = token.bgColorComponentDisabled;
  final disabledBrand = token.brandColorDisabled;
  final thumbBorder = theme?.thumbBorderColor ?? token.grayColor1;
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final disabledThumbBorder =
      theme?.disabledThumbBorderColor ??
      (isDark ? token.bgColorComponentDisabled : token.componentBorder);

  return SliderThemeData(
    // Preserve current TD layout; zero padding would shrink the native render box.
    // ignore: deprecated_member_use
    year2023: true,
    overlayShape: const RoundSliderOverlayShape(
      overlayRadius: SliderGeometry.hitRadius,
    ),
    minThumbSeparation: SliderGeometry.minimumRangeSeparation,
    allowedInteraction: SliderInteraction.tapAndSlide,
    activeTrackColor: activeTrack,
    inactiveTrackColor: inactiveTrack,
    secondaryActiveTrackColor: activeTrack.withAlpha(0x8a),
    disabledActiveTrackColor: disabledBrand,
    disabledInactiveTrackColor: disabledComponent,
    disabledSecondaryActiveTrackColor: disabledBrand,
    activeTickMarkColor: activeTrack,
    inactiveTickMarkColor: inactiveTrack,
    disabledActiveTickMarkColor: disabledBrand,
    disabledInactiveTickMarkColor: disabledComponent,
    tickMarkShape: _TDesignSliderTickMarkShape(layout),
    rangeTickMarkShape: _TDesignRangeSliderTickMarkShape(layout),
    thumbColor: theme?.thumbColor ?? token.textColorAnti,
    disabledThumbColor: theme?.disabledThumbColor ?? token.textColorAnti,
    thumbShape: _TDesignSliderThumbShape(
      layout: layout,
      borderColor: thumbBorder,
      disabledBorderColor: disabledThumbBorder,
    ),
    rangeThumbShape: _TDesignRangeSliderThumbShape(
      layout: layout,
      borderColor: thumbBorder,
      disabledBorderColor: disabledThumbBorder,
    ),
    overlayColor: theme?.overlayColor ?? brand.withAlpha(0x1f),
    valueIndicatorColor: theme?.valueIndicatorColor ?? brand,
    valueIndicatorStrokeColor: theme?.valueIndicatorColor ?? brand,
    valueIndicatorTextStyle: TTextResolve.resolve(
      context: context,
      singleLine: true,
      style: TextStyle(
        color: theme?.valueIndicatorTextColor ?? token.textColorPrimary,
        fontSize: token.fontBodyMedium?.size,
        height: token.fontBodyMedium?.height,
        fontWeight: token.fontBodyMedium?.fontWeight,
      ),
    ),
  );
}

SliderThemeData _resolveSliderTheme(
  BuildContext context,
  TSliderVariant variant,
  int? divisions,
  SliderGeometry geometry,
  _SliderGeometryLayout layout,
) {
  final base = _sliderThemeFromTDesign(context, geometry, layout);
  if (variant == TSliderVariant.normal) {
    return base.copyWith(
      trackHeight: geometry.trackHeight,
      trackShape: _TDesignSliderTrackShape(geometry: geometry, layout: layout),
      rangeTrackShape: _TDesignRangeSliderTrackShape(
        geometry: geometry,
        layout: layout,
      ),
    );
  }
  return base.copyWith(
    trackHeight: geometry.trackHeight,
    trackShape: _CapsuleSliderTrackShape(
      layout: layout,
      outerColor: base.inactiveTrackColor ?? context.tTheme.componentBorder,
      disabledOuterColor: context.tTheme.bgColorComponent,
      divisions: divisions,
    ),
    rangeTrackShape: _CapsuleRangeSliderTrackShape(
      layout: layout,
      outerColor: base.inactiveTrackColor ?? context.tTheme.componentBorder,
      disabledOuterColor: context.tTheme.bgColorComponent,
      divisions: divisions,
    ),
    tickMarkShape: SliderTickMarkShape.noTickMark,
    rangeTickMarkShape: const _CapsuleRangeSliderTickMarkShape(),
  );
}

Color _disabledThumbLabelColor(BuildContext context) {
  final theme = Theme.of(context).extension<TSliderThemeData>();
  return theme?.valueIndicatorTextColor?.withValues(alpha: 0.38) ??
      context.tTheme.textColorDisabled;
}

class TSlider extends StatelessWidget {
  const TSlider({
    super.key,
    required this.value,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.showThumbValue = false,
    this.thumbFormatter,
    this.showScaleValue = false,
    this.scaleFormatter,
    this.variant = TSliderVariant.normal,
  }) : assert(max > min),
       assert(value >= min && value <= max),
       assert(divisions == null || divisions > 0),
       assert(!showScaleValue || divisions != null);

  /// 受控滑块值；应处于 min 与 max 指定的范围内，父组件需回传新值。
  final double value;

  /// 值变更回调；为 null 时禁用。
  final ValueChanged<double>? onChanged;

  /// 开始拖动时触发。
  final ValueChanged<double>? onChangeStart;

  /// 结束拖动时触发。
  final ValueChanged<double>? onChangeEnd;

  /// 最小值。
  /// max 必须大于 min。
  final double min;

  /// 最大值。
  /// 必须大于 min。
  final double max;

  /// 离散刻度数；null 表示连续。
  /// 非 null 时必须大于 0；输入值吸附到最近刻度，显示数值使用吸附后的值。
  final int? divisions;

  /// 是否持续显示拇指上方数值。
  final bool showThumbValue;

  /// 拇指上方数值格式化回调。
  final TSliderThumbFormatter? thumbFormatter;

  /// 是否显示刻度值；开启时必须提供 [divisions]。
  final bool showScaleValue;

  /// 刻度值格式化回调。
  final TSliderThumbFormatter? scaleFormatter;

  /// 滑块视觉结构，默认使用标准细轨道。
  final TSliderVariant variant;

  @override
  Widget build(BuildContext context) {
    final effectiveValue = SliderGeometry.effectiveValue(
      value,
      min,
      max,
      divisions,
    );
    final geometry = SliderGeometry.resolve(
      context,
      capsule: variant == TSliderVariant.capsule,
    );
    final label = showThumbValue
        ? (thumbFormatter?.call(effectiveValue) ??
              effectiveValue.toStringAsFixed(2))
        : null;
    final layout = _SliderGeometryLayout(geometry);
    void pointerChanged(Offset position) {
      final pointer = layout.pointer;
      if (!pointer.singleActive || !layout.metrics.hasTravel) {
        return;
      }
      final value = layout.metrics.valueAt(
        layout.viewport!.globalToLocal(position).dx,
        min: min,
        max: max,
        divisions: divisions,
        direction: Directionality.of(context),
      );
      if (pointer.singleValue != value) {
        pointer.singleValue = value;
        onChanged?.call(value);
      }
    }

    layout.pointerMove = pointerChanged;
    final slider = Slider(
      value: effectiveValue,
      onChanged: onChanged == null
          ? null
          : (value) {
              // Pointer values come from the current geometry. Native values remain
              // authoritative for keyboard and accessibility actions.
              if (!layout.pointer.suppressed &&
                  (!layout.pointer.singleActive ||
                      layout.pointer.nativeAction)) {
                if (layout.pointer.nativeAction) {
                  layout.pointer.singleValue = value;
                }
                onChanged!(value);
              }
            },
      onChangeStart: (value) {
        final pointer = layout.pointer;
        if (!layout.metrics.hasTravel) {
          layout.suppressUnavailableInteraction();
          return;
        }
        if (pointer.singleActive) {
          pointer.nativeAction = true;
          onChangeStart?.call(value);
          return;
        }
        if (pointer.id != null) {
          pointer.singleActive = true;
          pointer.singleValue = effectiveValue;
          onChangeStart?.call(effectiveValue);
          pointerChanged(pointer.position!);
        } else {
          onChangeStart?.call(value);
        }
      },
      onChangeEnd: (value) {
        final pointer = layout.pointer;
        if (pointer.suppressed) {
          pointer.suppressed = false;
          pointer.singleActive = false;
          pointer.nativeAction = false;
          return;
        }
        if (pointer.nativeAction) {
          pointer.nativeAction = false;
          onChangeEnd?.call(value);
        } else if (pointer.singleActive) {
          final last = pointer.singleValue!;
          pointer.singleActive = false;
          onChangeEnd?.call(last);
        } else {
          onChangeEnd?.call(value);
        }
      },
      min: min,
      max: max,
      divisions: divisions,
      label: label,
    );
    final baseTheme = _resolveSliderTheme(
      context,
      variant,
      divisions,
      geometry,
      layout,
    );
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
    final themedSlider = Theme(
      data: TInternalMaterialTheme.resolve(context),
      child: _SliderGeometryViewport(
        layout: layout,
        child: SliderTheme(data: sliderTheme, child: slider),
      ),
    );
    final sliderContent = showThumbValue
        ? Padding(
            padding: EdgeInsets.only(top: context.tTheme.spacer2),
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
            geometry: geometry,
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
    required this.value,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.showThumbValue = false,
    this.thumbFormatter,
    this.showScaleValue = false,
    this.scaleFormatter,
    this.variant = TSliderVariant.normal,
  }) : assert(max > min),
       assert(divisions == null || divisions > 0),
       assert(!showScaleValue || divisions != null);

  /// 受控范围值；两端值应处于 min 与 max 指定的范围内，父组件需回传新值。
  /// 连续拖动在正常尺寸下保留 8 逻辑像素最小中心间距；空间不足时随几何缩小，且不超过当前区间行程。
  /// 离散同刻度、直接传入的相等端点仍受支持。
  final RangeValues value;

  /// 范围变更回调；为 null 时禁用。
  final ValueChanged<RangeValues>? onChanged;

  /// 开始拖动时触发。
  final ValueChanged<RangeValues>? onChangeStart;

  /// 结束拖动时触发。
  final ValueChanged<RangeValues>? onChangeEnd;

  /// 最小值。
  /// max 必须大于 min。
  final double min;

  /// 最大值。
  /// 必须大于 min。
  final double max;

  /// 离散刻度数；null 表示连续。
  /// 非 null 时必须大于 0；输入值吸附到最近刻度，显示数值使用吸附后的值。
  final int? divisions;

  /// 是否持续显示拇指上方数值。
  final bool showThumbValue;

  /// 拇指上方数值格式化回调。
  final TSliderThumbFormatter? thumbFormatter;

  /// 是否显示刻度值；开启时必须提供 [divisions]。
  final bool showScaleValue;

  /// 刻度值格式化回调。
  final TSliderThumbFormatter? scaleFormatter;

  /// 滑块视觉结构，默认使用标准细轨道。
  final TSliderVariant variant;

  @override
  Widget build(BuildContext context) {
    assert(value.start >= min && value.end <= max);
    final effectiveStart = SliderGeometry.effectiveValue(
      value.start,
      min,
      max,
      divisions,
    );
    final effectiveEnd = SliderGeometry.effectiveValue(
      value.end,
      min,
      max,
      divisions,
    );
    final geometry = SliderGeometry.resolve(
      context,
      capsule: variant == TSliderVariant.capsule,
    );
    final labels = showThumbValue
        ? RangeLabels(
            thumbFormatter?.call(effectiveStart) ??
                effectiveStart.toStringAsFixed(2),
            thumbFormatter?.call(effectiveEnd) ??
                effectiveEnd.toStringAsFixed(2),
          )
        : null;
    final layout = _SliderGeometryLayout(geometry);
    final slider = RangeSlider(
      values: RangeValues(effectiveStart, effectiveEnd),
      onChanged: onChanged == null
          ? null
          : (values) {
              if (!layout.pointer.suppressed) {
                onChanged!(values);
              }
            },
      onChangeStart: (values) {
        if (!layout.metrics.hasTravel) {
          layout.suppressUnavailableInteraction();
          return;
        }
        layout.pointer.rangeActive = true;
        onChangeStart?.call(values);
      },
      onChangeEnd: (values) {
        layout.pointer.rangeActive = false;
        if (layout.pointer.suppressed) {
          layout.pointer.suppressed = false;
          return;
        }
        onChangeEnd?.call(values);
      },
      min: min,
      max: max,
      divisions: divisions,
      labels: labels,
    );
    final baseTheme = _resolveSliderTheme(
      context,
      variant,
      divisions,
      geometry,
      layout,
    );
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
    final themedSlider = Theme(
      data: TInternalMaterialTheme.resolve(context),
      child: _SliderGeometryViewport(
        layout: layout,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final metrics = layout.forConstraints(constraints);
            return SliderTheme(
              data: sliderTheme.copyWith(
                minThumbSeparation: metrics.rangeSeparation(
                  (effectiveEnd - effectiveStart) / (max - min),
                ),
              ),
              child: slider,
            );
          },
        ),
      ),
    );
    final sliderContent = showThumbValue
        ? Padding(
            padding: EdgeInsets.only(top: context.tTheme.spacer2),
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
            geometry: geometry,
            slider: sliderContent,
          )
        : sliderContent;
    return decoration == null
        ? content
        : DecoratedBox(decoration: decoration, child: content);
  }
}

void _paintCapsuleSegments(
  Canvas canvas, {
  required Rect trackRect,
  required Rect thumbTrack,
  required double innerInset,
  required double gapWidth,
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
  final innerRect = trackRect.deflate(innerInset);
  if (innerRect.isEmpty) {
    return;
  }

  canvas.save();
  canvas.clipRRect(
    RRect.fromRectAndRadius(innerRect, Radius.circular(innerRect.height / 2)),
  );
  final count = divisions ?? 1;
  // 分段边界对齐 thumb 落点：分段在 thumb 行程上等分。
  final dividerLeft = thumbTrack.left;
  final dividerStep = thumbTrack.width / count;
  final gapHalf = dividerStep > gapWidth ? gapWidth / 2 : 0.0;
  for (var index = 0; index < count; index++) {
    // Leave a 2px unpainted gap when the division is wide enough.
    final left = index == 0
        ? innerRect.left
        : math.max(innerRect.left, dividerLeft + index * dividerStep + gapHalf);
    final right = index == count - 1
        ? innerRect.right
        : math.min(
            innerRect.right,
            dividerLeft + (index + 1) * dividerStep - gapHalf,
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

void _paintNormalTrack(
  Canvas canvas,
  Rect rect,
  SliderThemeData theme,
  Animation<double> animation, {
  required double activeLeft,
  required double activeRight,
}) {
  if (rect.isEmpty) {
    return;
  }
  final border = RRect.fromRectAndRadius(
    rect,
    Radius.circular(math.min(rect.width, rect.height) / 2),
  );
  final inactive = Color.lerp(
    theme.disabledInactiveTrackColor,
    theme.inactiveTrackColor,
    animation.value,
  )!;
  final active = Color.lerp(
    theme.disabledActiveTrackColor,
    theme.activeTrackColor,
    animation.value,
  )!;
  final left = activeLeft.clamp(rect.left, rect.right).toDouble();
  final right = activeRight.clamp(left, rect.right).toDouble();
  void segment(double start, double end, Color color) {
    if (end <= start) {
      return;
    }
    canvas.save();
    canvas.clipRect(
      Rect.fromLTRB(start, rect.top - 1, end, rect.bottom + 1),
      doAntiAlias: false,
    );
    canvas.drawRRect(border, Paint()..color = color);
    canvas.restore();
  }

  segment(rect.left, left, inactive);
  segment(left, right, active);
  segment(right, rect.right, inactive);
}

class _TDesignSliderTickMarkShape extends RoundSliderTickMarkShape {
  const _TDesignSliderTickMarkShape(this.layout);
  final _SliderGeometryLayout layout;
  @override
  double get tickMarkRadius => layout.metrics.tickRadius;
}

class _TDesignRangeSliderTickMarkShape extends RoundRangeSliderTickMarkShape {
  const _TDesignRangeSliderTickMarkShape(this.layout);
  final _SliderGeometryLayout layout;
  @override
  double get tickMarkRadius => layout.metrics.tickRadius;
}

class _TDesignSliderTrackShape extends SliderTrackShape {
  const _TDesignSliderTrackShape({
    required this.geometry,
    required this.layout,
  });

  final _SliderGeometryLayout layout;

  final SliderGeometry geometry;

  @override
  bool get isRounded => false;

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) => layout.forBox(parentBox).coordinateRect(parentBox.size, offset);

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
    final rect = layout.forBox(parentBox).visualRect(parentBox.size, offset);
    _paintNormalTrack(
      context.canvas,
      rect,
      sliderTheme,
      enableAnimation,
      activeLeft: textDirection == TextDirection.ltr
          ? rect.left
          : thumbCenter.dx,
      activeRight: textDirection == TextDirection.ltr
          ? thumbCenter.dx
          : rect.right,
    );
  }
}

class _TDesignRangeSliderTrackShape extends RangeSliderTrackShape {
  const _TDesignRangeSliderTrackShape({
    required this.geometry,
    required this.layout,
  });

  final SliderGeometry geometry;
  final _SliderGeometryLayout layout;

  @override
  bool get isRounded => false;

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) => layout.forBox(parentBox).coordinateRect(parentBox.size, offset);

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
    final rect = layout.forBox(parentBox).visualRect(parentBox.size, offset);
    _paintNormalTrack(
      context.canvas,
      rect,
      sliderTheme,
      enableAnimation,
      activeLeft: math.min(startThumbCenter.dx, endThumbCenter.dx),
      activeRight: math.max(startThumbCenter.dx, endThumbCenter.dx),
    );
  }
}

class _CapsuleSliderTrackShape extends RoundedRectSliderTrackShape {
  const _CapsuleSliderTrackShape({
    required this.layout,
    required this.outerColor,
    required this.disabledOuterColor,
    required this.divisions,
  });

  final _SliderGeometryLayout layout;
  final Color outerColor;
  final Color disabledOuterColor;
  final int? divisions;

  // Geometry owns the complete travel in continuous and discrete modes.
  @override
  bool get isRounded => false;

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) => layout.forBox(parentBox).coordinateRect(parentBox.size, offset);

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
    final metrics = layout.forBox(parentBox);
    final trackRect = metrics.visualRect(parentBox.size, offset);
    final innerInset = metrics.capsuleInset;
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
    final innerRect = trackRect.deflate(innerInset);
    _paintCapsuleSegments(
      context.canvas,
      trackRect: trackRect,
      thumbTrack: metrics.coordinateRect(parentBox.size, offset),
      innerInset: innerInset,
      gapWidth: metrics.capsuleGapWidth,
      outerColor: Color.lerp(
        disabledOuterColor,
        outerColor,
        enableAnimation.value,
      )!,
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
    required this.layout,
    required this.outerColor,
    required this.disabledOuterColor,
    required this.divisions,
  });

  final _SliderGeometryLayout layout;
  final Color outerColor;
  final Color disabledOuterColor;
  final int? divisions;

  /// 同 [_CapsuleSliderTrackShape]。
  @override
  bool get isRounded => false;

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) => layout.forBox(parentBox).coordinateRect(parentBox.size, offset);

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
    final metrics = layout.forBox(parentBox);
    final trackRect = metrics.visualRect(parentBox.size, offset);
    final innerInset = metrics.capsuleInset;
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
      thumbTrack: metrics.coordinateRect(parentBox.size, offset),
      innerInset: innerInset,
      gapWidth: metrics.capsuleGapWidth,
      outerColor: Color.lerp(
        disabledOuterColor,
        outerColor,
        enableAnimation.value,
      )!,
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
    required this.layout,
    required this.borderColor,
    required this.disabledBorderColor,
  });

  final _SliderGeometryLayout layout;
  final Color borderColor;
  final Color disabledBorderColor;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      layout.metrics.thumbSize;

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
      radius: layout.forBox(parentBox).thumbRadius,
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
    required this.layout,
    required this.borderColor,
    required this.disabledBorderColor,
  });

  final _SliderGeometryLayout layout;
  final Color borderColor;
  final Color disabledBorderColor;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      layout.metrics.thumbSize;

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
      radius: layout.metrics.thumbRadius,
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
  required double radius,
}) {
  if (radius <= 0) {
    return;
  }
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
  final strokeWidth = SliderGeometry.thumbBorderWidth * radius / _kThumbRadius;
  canvas.drawCircle(
    center,
    math.max(0, radius - strokeWidth / 2),
    Paint()
      ..color = border
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth,
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
    required this.geometry,
    required this.slider,
  });

  final double min;
  final double max;
  final int divisions;
  final TSliderThumbFormatter? formatter;
  final SliderGeometry geometry;
  final Widget slider;

  @override
  Widget build(BuildContext context) {
    final direction = Directionality.of(context) == TextDirection.ltr
        ? 1.0
        : -1.0;
    final labels = List<Widget>.generate(divisions + 1, (index) {
      final value = min + (max - min) * index / divisions;
      final text = formatter?.call(value) ?? value.toString();
      final isFirst = index == 0;
      final isLast = index == divisions;
      final alignment = isFirst
          ? AlignmentDirectional.centerStart
          : isLast
          ? AlignmentDirectional.centerEnd
          : Alignment.center;
      return Expanded(
        flex: isFirst || isLast ? 1 : 2,
        child: Align(
          alignment: alignment,
          child: OverflowBox(
            fit: OverflowBoxFit.deferToChild,
            minWidth: 0,
            maxWidth: double.infinity,
            alignment: alignment,
            child: FractionalTranslation(
              translation: Offset(
                (isFirst
                        ? -0.5
                        : isLast
                        ? 0.5
                        : 0.0) *
                    direction,
                0,
              ),
              child: TTextStyled(
                text,
                style: null,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    });
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SliderLabelPadding(
          geometry: geometry,
          child: Row(children: labels),
        ),
        slider,
      ],
    );
  }
}

// Width-aware padding with intrinsic sizing, shared by single and range labels.
class _SliderLabelPadding extends SingleChildRenderObjectWidget {
  const _SliderLabelPadding({required this.geometry, required super.child});
  final SliderGeometry geometry;
  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderSliderLabelPadding(geometry);
  @override
  void updateRenderObject(
    BuildContext context,
    _RenderSliderLabelPadding renderObject,
  ) {
    renderObject.geometry = geometry;
  }
}

class _RenderSliderLabelPadding extends RenderShiftedBox {
  _RenderSliderLabelPadding(this._geometry) : super(null);
  SliderGeometry _geometry;
  SliderGeometry get geometry => _geometry;
  set geometry(SliderGeometry value) {
    if (identical(value, _geometry)) {
      return;
    }
    _geometry = value;
    markNeedsLayout();
  }

  double get _intrinsicInset =>
      _geometry.forWidth(_geometry.preferredSize.width).thumbInset;
  @override
  double computeMinIntrinsicWidth(double height) =>
      child!.getMinIntrinsicWidth(height) + 2 * _intrinsicInset;
  @override
  double computeMaxIntrinsicWidth(double height) =>
      child!.getMaxIntrinsicWidth(height) + 2 * _intrinsicInset;
  @override
  double computeMinIntrinsicHeight(double width) =>
      child!.getMinIntrinsicHeight(
        math.max(0.0, width - _geometry.forWidth(width).thumbInset * 2),
      );
  @override
  double computeMaxIntrinsicHeight(double width) =>
      child!.getMaxIntrinsicHeight(
        math.max(0.0, width - _geometry.forWidth(width).thumbInset * 2),
      );
  double _inset(BoxConstraints constraints) => _geometry
      .forWidth(
        constraints.hasBoundedWidth
            ? constraints.maxWidth
            : computeMaxIntrinsicWidth(double.infinity),
      )
      .thumbInset;
  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final inset = _inset(constraints);
    final size = child!.getDryLayout(
      constraints.deflate(EdgeInsets.symmetric(horizontal: inset)),
    );
    return constraints.constrain(Size(size.width + 2 * inset, size.height));
  }

  @override
  void performLayout() {
    final inset = _inset(constraints);
    child!.layout(
      constraints.deflate(EdgeInsets.symmetric(horizontal: inset)),
      parentUsesSize: true,
    );
    size = constraints.constrain(
      Size(child!.size.width + 2 * inset, child!.size.height),
    );
    (child!.parentData! as BoxParentData).offset = Offset(
      (size.width - child!.size.width) / 2,
      0,
    );
  }
}

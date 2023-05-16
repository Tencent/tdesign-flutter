///
///  Created by arvinwli@tencent.com on 4/24/23.
///
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'td_slider.dart';

///刻度显示格式化
typedef ScaleFormatter = String Function(double value);

///
///slider显示样式配置
///
class TDSliderThemeData extends SliderThemeData {
  ///是否显示游标值
  final bool showThumbValue;

  ///游标上文本样式
  final TextStyle? thumbTextStyle;

  ///disable时游标的样式
  final TextStyle disabledThumbTextStyle;

  ///是否显示刻度值
  final bool showScaleValue;

  ///刻度值的格式化
  final ScaleFormatter? scaleFormatter;

  ///刻度值的样式
  final TextStyle? scaleTextStyle;

  ///disabled状态时刻度的样式
  final TextStyle disabledScaleTextStyle;

  ///分割几块
  final int? divisions;

  ///最小值
  final double min;

  ///最大值
  final double max;

  /// 运行时测量的数据，这里用于组件内部使用
  final SliderMeasureData sliderMeasureData = SliderMeasureData();

  TDSliderThemeData(
      {double? trackHeight = 4,
      Color? activeTrackColor = const Color(0xFF0052D9),
      Color? inactiveTrackColor = const Color(0xFFDCDCDC),
      Color? secondaryActiveTrackColor,
      Color? disabledActiveTrackColor = const Color(0xFFB5C7FF),
      Color? disabledInactiveTrackColor = const Color(0xFFEEEEEE),
      Color? disabledSecondaryActiveTrackColor,
      Color? activeTickMarkColor = const Color(0xFF0052D9),
      Color? inactiveTickMarkColor = const Color(0xFFDCDCDC),
      Color? disabledActiveTickMarkColor = const Color(0xFFB5C7FF),
      Color? disabledInactiveTickMarkColor = const Color(0xFFEEEEEE),
      Color? thumbColor = Colors.white,
      Color? overlappingShapeStrokeColor,
      Color? disabledThumbColor = Colors.white,
      Color? overlayColor,
      Color? valueIndicatorColor,
      SliderComponentShape? overlayShape = const TDNoOverlayShape(),
      SliderTickMarkShape? tickMarkShape = const TDRoundSliderTickMarkShape(),
      SliderComponentShape? thumbShape = const TDRoundSliderThumbShape(),
      SliderTrackShape? trackShape = const TDRoundedRectSliderTrackShape(),
      SliderComponentShape? valueIndicatorShape,
      RangeSliderTickMarkShape? rangeTickMarkShape = const TDRoundRangeSliderTickMarkShape(),
      RangeSliderThumbShape? rangeThumbShape = const TDRoundRangeSliderThumbShape(),
      RangeSliderTrackShape? rangeTrackShape = const TDRoundedRectRangeSliderTrackShape(),
      RangeSliderValueIndicatorShape? rangeValueIndicatorShape,
      ShowValueIndicator? showValueIndicator = ShowValueIndicator.never,
      TextStyle? valueIndicatorTextStyle,
      double? minThumbSeparation,
      RangeThumbSelector? thumbSelector,
      MaterialStateProperty<MouseCursor?>? mouseCursor,
      this.showScaleValue = false,
      this.showThumbValue = false,
      this.divisions,
      this.scaleTextStyle = const TextStyle(fontSize: 14, color: Color(0xE6000000)),
      this.disabledScaleTextStyle = const TextStyle(fontSize: 14, color: Color(0x42000000)),
      this.thumbTextStyle = const TextStyle(fontSize: 14, color: Color(0xE6000000)),
      this.disabledThumbTextStyle = const TextStyle(fontSize: 14, color: Color(0x42000000)),
      this.min = 0.0,
      this.max = 1.0,
      this.scaleFormatter})
      : super(
          trackHeight: trackHeight,
          activeTrackColor: activeTrackColor,
          inactiveTrackColor: inactiveTrackColor,
          disabledActiveTrackColor: disabledActiveTrackColor,
          disabledInactiveTrackColor: disabledInactiveTrackColor,
          activeTickMarkColor: activeTickMarkColor,
          inactiveTickMarkColor: inactiveTickMarkColor,
          disabledActiveTickMarkColor: disabledActiveTickMarkColor,
          disabledInactiveTickMarkColor: disabledInactiveTickMarkColor,
          thumbColor: thumbColor,
          overlappingShapeStrokeColor: overlappingShapeStrokeColor,
          disabledThumbColor: disabledThumbColor,
          overlayColor: overlayColor,
          valueIndicatorColor: valueIndicatorColor,
          overlayShape: overlayShape,
          tickMarkShape: tickMarkShape,
          thumbShape: thumbShape,
          trackShape: trackShape,
          valueIndicatorShape: valueIndicatorShape,
          rangeTickMarkShape: rangeTickMarkShape,
          rangeThumbShape: rangeThumbShape,
          rangeTrackShape: rangeTrackShape,
          rangeValueIndicatorShape: rangeValueIndicatorShape,
          showValueIndicator: showValueIndicator,
          valueIndicatorTextStyle: valueIndicatorTextStyle,
          minThumbSeparation: minThumbSeparation,
          thumbSelector: thumbSelector,
          mouseCursor: mouseCursor,
        );

  @override
  TDSliderThemeData copyWith({
    double? trackHeight,
    Color? activeTrackColor,
    Color? inactiveTrackColor,
    Color? secondaryActiveTrackColor,
    Color? disabledActiveTrackColor,
    Color? disabledInactiveTrackColor,
    Color? disabledSecondaryActiveTrackColor,
    Color? activeTickMarkColor,
    Color? inactiveTickMarkColor,
    Color? disabledActiveTickMarkColor,
    Color? disabledInactiveTickMarkColor,
    Color? thumbColor,
    Color? overlappingShapeStrokeColor,
    Color? disabledThumbColor,
    Color? overlayColor,
    Color? valueIndicatorColor,
    SliderComponentShape? overlayShape,
    SliderTickMarkShape? tickMarkShape,
    SliderComponentShape? thumbShape,
    SliderTrackShape? trackShape,
    SliderComponentShape? valueIndicatorShape,
    RangeSliderTickMarkShape? rangeTickMarkShape,
    RangeSliderThumbShape? rangeThumbShape,
    RangeSliderTrackShape? rangeTrackShape,
    RangeSliderValueIndicatorShape? rangeValueIndicatorShape,
    ShowValueIndicator? showValueIndicator,
    TextStyle? valueIndicatorTextStyle,
    double? minThumbSeparation,
    RangeThumbSelector? thumbSelector,
    MaterialStateProperty<MouseCursor?>? mouseCursor,
    bool? showScaleValue,
    bool? showThumbValue,
    TextStyle? disabledScaleTextStyle,
    TextStyle? disabledThumbTextStyle,
    TextStyle? scaleTextStyle,
    TextStyle? thumbTextStyle,
    int? divisions,
    double? min,
    double? max,
    ScaleFormatter? scaleFormatter,
  }) {
    return TDSliderThemeData(
        trackHeight: trackHeight ?? this.trackHeight,
        activeTrackColor: activeTrackColor ?? this.activeTrackColor,
        inactiveTrackColor: inactiveTrackColor ?? this.inactiveTrackColor,
        disabledActiveTrackColor: disabledActiveTrackColor ?? this.disabledActiveTrackColor,
        disabledInactiveTrackColor: disabledInactiveTrackColor ?? this.disabledInactiveTrackColor,
        activeTickMarkColor: activeTickMarkColor ?? this.activeTickMarkColor,
        inactiveTickMarkColor: inactiveTickMarkColor ?? this.inactiveTickMarkColor,
        disabledActiveTickMarkColor: disabledActiveTickMarkColor ?? this.disabledActiveTickMarkColor,
        disabledInactiveTickMarkColor: disabledInactiveTickMarkColor ?? this.disabledInactiveTickMarkColor,
        thumbColor: thumbColor ?? this.thumbColor,
        overlappingShapeStrokeColor: overlappingShapeStrokeColor ?? this.overlappingShapeStrokeColor,
        disabledThumbColor: disabledThumbColor ?? this.disabledThumbColor,
        overlayColor: overlayColor ?? this.overlayColor,
        valueIndicatorColor: valueIndicatorColor ?? this.valueIndicatorColor,
        overlayShape: overlayShape ?? this.overlayShape,
        tickMarkShape: tickMarkShape ?? this.tickMarkShape,
        thumbShape: thumbShape ?? this.thumbShape,
        trackShape: trackShape ?? this.trackShape,
        valueIndicatorShape: valueIndicatorShape ?? this.valueIndicatorShape,
        rangeTickMarkShape: rangeTickMarkShape ?? this.rangeTickMarkShape,
        rangeThumbShape: rangeThumbShape ?? this.rangeThumbShape,
        rangeTrackShape: rangeTrackShape ?? this.rangeTrackShape,
        rangeValueIndicatorShape: rangeValueIndicatorShape ?? this.rangeValueIndicatorShape,
        showValueIndicator: showValueIndicator ?? this.showValueIndicator,
        valueIndicatorTextStyle: valueIndicatorTextStyle ?? this.valueIndicatorTextStyle,
        minThumbSeparation: minThumbSeparation ?? this.minThumbSeparation,
        thumbSelector: thumbSelector ?? this.thumbSelector,
        mouseCursor: mouseCursor ?? this.mouseCursor,
        showScaleValue: showScaleValue ?? this.showScaleValue,
        showThumbValue: showThumbValue ?? this.showThumbValue,
        disabledScaleTextStyle: disabledScaleTextStyle ?? this.disabledScaleTextStyle,
        disabledThumbTextStyle: disabledThumbTextStyle ?? this.disabledThumbTextStyle,
        scaleTextStyle: scaleTextStyle ?? this.scaleTextStyle,
        thumbTextStyle: thumbTextStyle ?? this.thumbTextStyle,
        divisions: divisions ?? this.divisions,
        min: min ?? this.min,
        max: max ?? this.max,
        scaleFormatter: scaleFormatter ?? this.scaleFormatter);
  }
}

class TDSliderThemeFactory {
  static final TDSliderThemeData capsuleThemeData = TDSliderThemeData(
    trackShape: const TDCapsuleRectSliderTrackShape(),
    tickMarkShape: const TDCapsuleSliderTickMarkShape(),
    thumbShape: const TDCapsuleSliderThumbShape(),
    rangeTrackShape: const TDCapsuleRectRangeSliderTrackShape(),
    rangeTickMarkShape: const TDCapsuleRangeSliderTickMarkShape(),
    rangeThumbShape: const TDCapsuleRangeSliderThumbShape(),
    activeTickMarkColor: const Color(0xFFE7E7E7),
    inactiveTickMarkColor: const Color(0xFFE7E7E7),
    disabledActiveTickMarkColor: const Color(0xFFE7E7E7),
    disabledInactiveTickMarkColor: const Color(0xFFE7E7E7),
    trackHeight: 24,
  );
}

class SliderMeasureData {
  Rect? trackerRect;
  Offset? thumbCenter;
}

///
///Slider轨道绘制
///
class TDRoundedRectSliderTrackShape extends SliderTrackShape with BaseSliderTrackShape {
  /// Create a slider track that draws two rectangles with rounded outer edges.
  const TDRoundedRectSliderTrackShape();

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
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    // If the slider [SliderThemeData.trackHeight] is less than or equal to 0,
    // then it makes no difference whether the track is painted or not,
    // therefore the painting can be a no-op.
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }
    assert(sliderTheme is TDSliderThemeData);

    sliderTheme as TDSliderThemeData;
    // Assign the track segment paints, which are leading: active and
    // trailing: inactive.
    final activeTrackColorTween =
        ColorTween(begin: sliderTheme.disabledActiveTrackColor, end: sliderTheme.activeTrackColor);
    final inactiveTrackColorTween =
        ColorTween(begin: sliderTheme.disabledInactiveTrackColor, end: sliderTheme.inactiveTrackColor);
    final activePaint = Paint()..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final inactivePaint = Paint()..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    final Paint leftTrackPaint;
    final Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final trackRadius = Radius.circular(trackRect.height / 2);
    final activeTrackRadius = Radius.circular((trackRect.height + additionalActiveTrackHeight) / 2);

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left,
        (textDirection == TextDirection.rtl) ? trackRect.top - (additionalActiveTrackHeight / 2) : trackRect.top,
        thumbCenter.dx,
        (textDirection == TextDirection.rtl) ? trackRect.bottom + (additionalActiveTrackHeight / 2) : trackRect.bottom,
        topLeft: (textDirection == TextDirection.ltr) ? activeTrackRadius : trackRadius,
        bottomLeft: (textDirection == TextDirection.ltr) ? activeTrackRadius : trackRadius,
      ),
      leftTrackPaint,
    );
    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        thumbCenter.dx,
        (textDirection == TextDirection.rtl) ? trackRect.top - (additionalActiveTrackHeight / 2) : trackRect.top,
        trackRect.right,
        (textDirection == TextDirection.rtl) ? trackRect.bottom + (additionalActiveTrackHeight / 2) : trackRect.bottom,
        topRight: (textDirection == TextDirection.rtl) ? activeTrackRadius : trackRadius,
        bottomRight: (textDirection == TextDirection.rtl) ? activeTrackRadius : trackRadius,
      ),
      rightTrackPaint,
    );
  }
}

///
///游标的绘制
///
class TDRoundSliderThumbShape extends SliderComponentShape {
  /// Create a slider thumb that draws a circle.
  const TDRoundSliderThumbShape({
    this.enabledThumbRadius = 10.0,
    this.disabledThumbRadius,
    this.elevation = 4.0,
    this.pressedElevation = 4.0,
  });

  /// The preferred radius of the round thumb shape when the slider is enabled.
  ///
  /// If it is not provided, then the Material Design default of 10 is used.
  final double enabledThumbRadius;

  /// The preferred radius of the round thumb shape when the slider is disabled.
  ///
  /// If no disabledRadius is provided, then it is equal to the
  /// [enabledThumbRadius]
  final double? disabledThumbRadius;

  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

  /// The resting elevation adds shadow to the unpressed thumb.
  ///
  /// The default is 1.
  ///
  /// Use 0 for no shadow. The higher the value, the larger the shadow. For
  /// example, a value of 12 will create a very large shadow.
  ///
  final double elevation;

  /// The pressed elevation adds shadow to the pressed thumb.
  ///
  /// The default is 6.
  ///
  /// Use 0 for no shadow. The higher the value, the larger the shadow. For
  /// example, a value of 12 will create a very large shadow.
  final double pressedElevation;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(isEnabled == true ? enabledThumbRadius : _disabledThumbRadius);
  }

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
    assert(sliderTheme.disabledThumbColor != null);
    assert(sliderTheme.thumbColor != null);

    final canvas = context.canvas;
    final radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );
    final colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );

    final color = colorTween.evaluate(enableAnimation)!;
    final radius = radiusTween.evaluate(enableAnimation);

    final elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );

    final evaluatedElevation = elevationTween.evaluate(activationAnimation);
    final path = Path()..addArc(Rect.fromCenter(center: center, width: 2 * radius, height: 2 * radius), 0, math.pi * 2);

    var paintShadows = true;

    if (paintShadows) {
      canvas.drawShadow(path, const Color.fromRGBO(0, 0, 0, 0.5), evaluatedElevation, true);
    }
    var paint = Paint();
    paint.color = color;
    canvas.drawCircle(
      center,
      radius,
      paint,
    );
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        0,
        2 * math.pi,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = const Color(0xFFF3F3F3));
  }
}

///系统用于绘制Overlay，这里不做绘制，只做slider的宽高计算
class TDNoOverlayShape extends SliderComponentShape {
  const TDNoOverlayShape();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.zero;
  }

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
  }) {}
}

///
/// 刻度绘制
///
class TDRoundSliderTickMarkShape extends SliderTickMarkShape {
  /// Create a slider tick mark that draws a circle.
  const TDRoundSliderTickMarkShape({
    this.tickMarkRadius,
  });

  /// The preferred radius of the round tick mark.
  ///
  /// If it is not provided, then 1/4 of the [SliderThemeData.trackHeight] is used.
  final double? tickMarkRadius;

  @override
  Size getPreferredSize({
    required SliderThemeData sliderTheme,
    required bool isEnabled,
  }) {
    assert(sliderTheme.trackHeight != null);
    // The tick marks are tiny circles. If no radius is provided, then the
    // radius is defaulted to be a fraction of the
    // [SliderThemeData.trackHeight]. The fraction is 1/4.
    return Size.fromRadius(tickMarkRadius ?? 4);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    required bool isEnabled,
  }) {
    assert(sliderTheme.disabledActiveTickMarkColor != null);
    assert(sliderTheme.disabledInactiveTickMarkColor != null);
    assert(sliderTheme.activeTickMarkColor != null);
    assert(sliderTheme.inactiveTickMarkColor != null);
    // The paint color of the tick mark depends on its position relative
    // to the thumb and the text direction.
    Color? begin;
    Color? end;
    switch (textDirection) {
      case TextDirection.ltr:
        final isTickMarkRightOfThumb = center.dx > thumbCenter.dx;
        begin = isTickMarkRightOfThumb
            ? sliderTheme.disabledInactiveTickMarkColor
            : sliderTheme.disabledActiveTickMarkColor;
        end = isTickMarkRightOfThumb ? sliderTheme.inactiveTickMarkColor : sliderTheme.activeTickMarkColor;
        break;
      case TextDirection.rtl:
        final isTickMarkLeftOfThumb = center.dx < thumbCenter.dx;
        begin =
            isTickMarkLeftOfThumb ? sliderTheme.disabledInactiveTickMarkColor : sliderTheme.disabledActiveTickMarkColor;
        end = isTickMarkLeftOfThumb ? sliderTheme.inactiveTickMarkColor : sliderTheme.activeTickMarkColor;
        break;
    }
    final paint = Paint()..color = ColorTween(begin: begin, end: end).evaluate(enableAnimation)!;

    // The tick marks are tiny circles that are the same height as the track.
    final tickMarkRadius = getPreferredSize(
          isEnabled: isEnabled,
          sliderTheme: sliderTheme,
        ).width /
        2;
    if (tickMarkRadius > 0 && (sliderTheme as TDSliderThemeData).showScaleValue) {
      assert(sliderTheme.divisions != null);
      var rect = sliderTheme.trackShape?.getPreferredRect(parentBox: parentBox, sliderTheme: sliderTheme);
      if (rect != null && sliderTheme.divisions! > 0) {
        //轨道的高度
        var trackHeight = rect.bottom - rect.top;
        //最左边的刻度中心到最右边刻度中心的长度
        var markWidth = (rect.right - rect.left) - trackHeight;
        //最左边刻度的起点
        var markStart = rect.left + trackHeight / 2;
        //每个刻度的宽度
        var perWidth = markWidth / sliderTheme.divisions!;
        assert(perWidth > 0);
        //计算当前是第几个刻度
        var index = ((center.dx - markStart) / perWidth).round();
        //获取当前刻度的值
        var value = sliderTheme.min + index * ((sliderTheme.max - sliderTheme.min) / sliderTheme.divisions!);
        //格式化数值
        var valueFormatter = sliderTheme.scaleFormatter != null ? sliderTheme.scaleFormatter!(value) : value.toString();
        //绘制刻度的值
        var painter = TextPainter(
            text: TextSpan(
                text: valueFormatter,
                style: enableAnimation.value > 0 ? sliderTheme.scaleTextStyle : sliderTheme.disabledScaleTextStyle),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center)
          ..layout(maxWidth: 100);
        //绘制的x
        var x = center.dx - painter.size.width / 2;
        if (index == 0) {
          x = center.dx - trackHeight;
        } else if (index == sliderTheme.divisions) {
          x = center.dx - painter.size.width + trackHeight;
        }
        painter.paint(context.canvas, Offset(x, center.dy - painter.height - 14));
      }
      //绘制刻度
      context.canvas.drawCircle(center, tickMarkRadius, paint);
    }
  }
}

/// Base track shape that provides an implementation of [getPreferredRect] for
/// default sizing.
///
/// The height is set from [SliderThemeData.trackHeight] and the width of the
/// parent box less the larger of the widths of [SliderThemeData.rangeThumbShape] and
/// [SliderThemeData.overlayShape].
///
/// See also:
///
///  * [RectangularRangeSliderTrackShape], which is a track shape with sharp
///    rectangular edges
mixin TDBaseRangeSliderTrackShape {
  /// Returns a rect that represents the track bounds that fits within the
  /// [Slider].
  ///
  /// The width is the width of the [Slider] or [RangeSlider], but padded by
  /// the max of the overlay and thumb radius. The height is defined by the
  /// [SliderThemeData.trackHeight].
  ///
  /// The [Rect] is centered both horizontally and vertically within the slider
  /// bounds.
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    assert(sliderTheme.rangeThumbShape != null);
    assert(sliderTheme.overlayShape != null);
    final thumbWidth = sliderTheme.rangeThumbShape!.getPreferredSize(isEnabled, isDiscrete).width;
    final overlayWidth = sliderTheme.overlayShape!.getPreferredSize(isEnabled, isDiscrete).width;
    final trackHeight = sliderTheme.trackHeight!;
    assert(overlayWidth >= 0);
    assert(trackHeight >= 0);

    final trackLeft = offset.dx + math.max(overlayWidth / 2, thumbWidth / 2);
    final trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final trackRight = trackLeft + parentBox.size.width - math.max(thumbWidth, overlayWidth);
    final trackBottom = trackTop + trackHeight;
    final rect = Rect.fromLTRB(math.min(trackLeft, trackRight), trackTop, math.max(trackLeft, trackRight), trackBottom);
    // If the parentBox'size less than slider's size the trackRight will be less than trackLeft, so switch them.
    (sliderTheme as TDSliderThemeData).sliderMeasureData.trackerRect = rect;
    return rect;
  }
}

/// The default shape of a [TDRangeSlider]'s track.
///
/// It paints a solid colored rectangle with rounded edges, vertically centered
/// in the `parentBox`. The track rectangle extends to the bounds of the
/// `parentBox`, but is padded by the larger of [RoundSliderOverlayShape]'s
/// radius and [RoundRangeSliderThumbShape]'s radius. The height is defined by
/// the [SliderThemeData.trackHeight]. The color is determined by the
/// [RangeSlider]'s enabled state and the track segment's active state which are
/// defined by:
///   [SliderThemeData.activeTrackColor],
///   [SliderThemeData.inactiveTrackColor],
///   [SliderThemeData.disabledActiveTrackColor],
///   [SliderThemeData.disabledInactiveTrackColor].
///
/// {@macro flutter.material.RangeSliderTickMarkShape.paint.trackSegment}
///
/// ![A range slider widget, consisting of 5 divisions and showing the rounded rect range slider track shape.]
/// (https://flutter.github.io/assets-for-api-docs/assets/material/rounded_rect_range_slider_track_shape.png)
///
/// See also:
///
///  * [RangeSlider], for the component that is meant to display this shape.
///  * [SliderThemeData], where an instance of this class is set to inform the
///    slider of the visual details of the its track.
///  * [RangeSliderTrackShape], which can be used to create custom shapes for
///    the [RangeSlider]'s track.
///  * [RectangularRangeSliderTrackShape], for a similar track with sharp edges.
class TDRoundedRectRangeSliderTrackShape extends RangeSliderTrackShape with TDBaseRangeSliderTrackShape {
  /// Create a slider track with rounded outer edges.
  ///
  /// The middle track segment is the selected range and is active, and the two
  /// outer track segments are inactive.
  const TDRoundedRectRangeSliderTrackShape();

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
    double additionalActiveTrackHeight = 0,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.rangeThumbShape != null);

    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    // Assign the track segment paints, which are left: active, right: inactive,
    // but reversed for right to left text.
    final activeTrackColorTween = ColorTween(
      begin: sliderTheme.disabledActiveTrackColor,
      end: sliderTheme.activeTrackColor,
    );
    final inactiveTrackColorTween = ColorTween(
      begin: sliderTheme.disabledInactiveTrackColor,
      end: sliderTheme.inactiveTrackColor,
    );
    final activePaint = Paint()..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final inactivePaint = Paint()..color = inactiveTrackColorTween.evaluate(enableAnimation)!;

    final Offset leftThumbOffset;
    final Offset rightThumbOffset;
    switch (textDirection) {
      case TextDirection.ltr:
        leftThumbOffset = startThumbCenter;
        rightThumbOffset = endThumbCenter;
        break;
      case TextDirection.rtl:
        leftThumbOffset = endThumbCenter;
        rightThumbOffset = startThumbCenter;
        break;
    }
    final thumbSize = sliderTheme.rangeThumbShape!.getPreferredSize(isEnabled, isDiscrete);
    final thumbRadius = thumbSize.width / 2;
    assert(thumbRadius > 0);

    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final trackRadius = Radius.circular(trackRect.height / 2);

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left,
        trackRect.top,
        leftThumbOffset.dx,
        trackRect.bottom,
        topLeft: trackRadius,
        bottomLeft: trackRadius,
      ),
      inactivePaint,
    );
    context.canvas.drawRect(
      Rect.fromLTRB(
        leftThumbOffset.dx,
        trackRect.top - (additionalActiveTrackHeight / 2),
        rightThumbOffset.dx,
        trackRect.bottom + (additionalActiveTrackHeight / 2),
      ),
      activePaint,
    );
    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        rightThumbOffset.dx,
        trackRect.top,
        trackRect.right,
        trackRect.bottom,
        topRight: trackRadius,
        bottomRight: trackRadius,
      ),
      inactivePaint,
    );
  }
}

/// The default shape of a [RangeSlider]'s thumbs.
///
/// There is a shadow for the resting and pressed state.
///
/// ![A slider widget, consisting of 5 divisions and showing the round range slider thumb shape.]
/// (https://flutter.github.io/assets-for-api-docs/assets/material/round_range_slider_thumb_shape.png)
///
/// See also:
///
///  * [RangeSlider], which includes thumbs defined by this shape.
///  * [SliderTheme], which can be used to configure the thumb shapes of all
///    range sliders in a widget subtree.
class TDRoundRangeSliderThumbShape extends RangeSliderThumbShape {
  /// Create a slider thumb that draws a circle.
  const TDRoundRangeSliderThumbShape({
    this.enabledThumbRadius = 10.0,
    this.disabledThumbRadius,
    this.elevation = 3.0,
    this.pressedElevation = 3.0,
  });

  /// The preferred radius of the round thumb shape when the slider is enabled.
  ///
  /// If it is not provided, then the Material Design default of 10 is used.
  final double enabledThumbRadius;

  /// The preferred radius of the round thumb shape when the slider is disabled.
  ///
  /// If no disabledRadius is provided, then it is equal to the
  /// [enabledThumbRadius].
  final double? disabledThumbRadius;

  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

  /// The resting elevation adds shadow to the unpressed thumb.
  ///
  /// The default is 1.
  final double elevation;

  /// The pressed elevation adds shadow to the pressed thumb.
  ///
  /// The default is 6.
  final double pressedElevation;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(isEnabled == true ? enabledThumbRadius : _disabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    assert(sliderTheme.showValueIndicator != null);
    assert(sliderTheme.overlappingShapeStrokeColor != null);
    final canvas = context.canvas;
    final radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );
    final colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );
    final radius = radiusTween.evaluate(enableAnimation);
    final elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );

    // Add a stroke of 1dp around the circle if this thumb would overlap
    // the other thumb.
    if (isOnTop ?? false) {
      final strokePaint = Paint()
        ..color = sliderTheme.overlappingShapeStrokeColor!
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(center, radius, strokePaint);
    }

    final color = colorTween.evaluate(enableAnimation)!;

    final evaluatedElevation = isPressed! ? elevationTween.evaluate(activationAnimation) : elevation;
    final shadowPath = Path()
      ..addArc(Rect.fromCenter(center: center, width: 2 * radius, height: 2 * radius), 0, math.pi * 2);

    var paintShadows = true;
    if (paintShadows) {
      canvas.drawShadow(shadowPath, const Color.fromRGBO(0, 0, 0, 0.5), evaluatedElevation, true);
    }
    if ((sliderTheme as TDSliderThemeData).showThumbValue && sliderTheme.sliderMeasureData.trackerRect != null) {
      var trackerRect = sliderTheme.sliderMeasureData.trackerRect!;
      var ratio = (center.dx - trackerRect.left) / (trackerRect.right - trackerRect.left);
      //计算滑块的值
      var value = (sliderTheme.max - sliderTheme.min) * ratio + sliderTheme.min;
      //格式化显示
      var formatterValue =
          sliderTheme.scaleFormatter == null ? value.toStringAsFixed(2) : sliderTheme.scaleFormatter!(value);
      //绘制数值
      var painter = TextPainter(
          text: TextSpan(
              text: '$formatterValue',
              style: enableAnimation.value > 0 ? sliderTheme.thumbTextStyle : sliderTheme.disabledThumbTextStyle),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center)
        ..layout(maxWidth: 100);
      painter.paint(context.canvas, Offset(center.dx - painter.size.width / 2, center.dy - painter.height - 14));
    }
    //绘制游标
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = color,
    );
  }
}

/// The default shape of each [RangeSlider] tick mark.
///
/// Tick marks are only displayed if the slider is discrete, which can be done
/// by setting the [RangeSlider.divisions] to an integer value.
///
/// It paints a solid circle, centered on the track.
/// The color is determined by the [Slider]'s enabled state and track's active
/// states. These colors are defined in:
///   [SliderThemeData.activeTrackColor],
///   [SliderThemeData.inactiveTrackColor],
///   [SliderThemeData.disabledActiveTrackColor],
///   [SliderThemeData.disabledInactiveTrackColor].
///
/// ![A slider widget, consisting of 5 divisions and showing the round range slider tick mark shape.]
/// (https://flutter.github.io/assets-for-api-docs/assets/material/round_range_slider_tick_mark_shape.png )
///
/// See also:
///
///  * [RangeSlider], which includes tick marks defined by this shape.
///  * [SliderTheme], which can be used to configure the tick mark shape of all
///    sliders in a widget subtree.
class TDRoundRangeSliderTickMarkShape extends RangeSliderTickMarkShape {
  /// Create a range slider tick mark that draws a circle.
  const TDRoundRangeSliderTickMarkShape({
    this.tickMarkRadius,
  });

  /// The preferred radius of the round tick mark.
  ///
  /// If it is not provided, then 1/4 of the [SliderThemeData.trackHeight] is used.
  final double? tickMarkRadius;

  @override
  Size getPreferredSize({
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
  }) {
    return Size.fromRadius(tickMarkRadius ?? 4);
  }

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
    assert(sliderTheme.disabledActiveTickMarkColor != null);
    assert(sliderTheme.disabledInactiveTickMarkColor != null);
    assert(sliderTheme.activeTickMarkColor != null);
    assert(sliderTheme.inactiveTickMarkColor != null);

    final bool isBetweenThumbs;
    switch (textDirection) {
      case TextDirection.ltr:
        isBetweenThumbs = startThumbCenter.dx < center.dx && center.dx < endThumbCenter.dx;
        break;
      case TextDirection.rtl:
        isBetweenThumbs = endThumbCenter.dx < center.dx && center.dx < startThumbCenter.dx;
        break;
    }
    final begin = isBetweenThumbs ? sliderTheme.disabledActiveTickMarkColor : sliderTheme.disabledInactiveTickMarkColor;
    final end = isBetweenThumbs ? sliderTheme.activeTickMarkColor : sliderTheme.inactiveTickMarkColor;
    final paint = Paint()..color = ColorTween(begin: begin, end: end).evaluate(enableAnimation)!;

    // The tick marks are tiny circles that are the same height as the track.
    final tickMarkRadius = getPreferredSize(
          isEnabled: isEnabled,
          sliderTheme: sliderTheme,
        ).width /
        2;
    if (tickMarkRadius > 0 && (sliderTheme as TDSliderThemeData).showScaleValue) {
      assert(sliderTheme.divisions != null);
      var rect = sliderTheme.rangeTrackShape?.getPreferredRect(parentBox: parentBox, sliderTheme: sliderTheme);
      if (rect != null && sliderTheme.divisions! > 0) {
        //轨道的高度
        var trackHeight = rect.bottom - rect.top;
        //最左边的刻度中心到最右边刻度中心的长度
        var markWidth = (rect.right - rect.left) - trackHeight;
        //最左边刻度的起点
        var markStart = rect.left + trackHeight / 2;
        //每个刻度的宽度
        var perWidth = markWidth / sliderTheme.divisions!;
        assert(perWidth > 0);
        //计算当前是第几个刻度
        var index = ((center.dx - markStart) / perWidth).round();
        //获取当前刻度的值
        var value = sliderTheme.min + index * ((sliderTheme.max - sliderTheme.min) / sliderTheme.divisions!);
        //格式化数值
        var valueFormatter = sliderTheme.scaleFormatter != null ? sliderTheme.scaleFormatter!(value) : value.toString();
        //绘制刻度的值
        var painter = TextPainter(
            text: TextSpan(
                text: valueFormatter,
                style: enableAnimation.value > 0 ? sliderTheme.scaleTextStyle : sliderTheme.disabledScaleTextStyle),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center)
          ..layout(maxWidth: 100);
        //绘制的x
        var x = center.dx - painter.size.width / 2;
        if (index == 0) {
          x = center.dx - trackHeight;
        } else if (index == sliderTheme.divisions) {
          x = center.dx - painter.size.width + trackHeight;
        }
        painter.paint(context.canvas, Offset(x, center.dy - painter.height - 14));
      }
      context.canvas.drawCircle(center, tickMarkRadius, paint);
    }
  }
}

mixin TDCapsuleTrackShape {
  Offset adjustThumbCenter(Offset thumbCenter, Rect trackRect) {
    final value = (thumbCenter.dx - trackRect.left) / trackRect.width;
    final x = value * (trackRect.width - 24) + trackRect.left + 12;
    return Offset(x, thumbCenter.dy);
  }
}

///
///Slider轨道绘制
///
class TDCapsuleRectSliderTrackShape extends SliderTrackShape with BaseSliderTrackShape, TDCapsuleTrackShape {
  final Color trackColorWhenShowScale;

  /// Create a slider track that draws two rectangles with rounded outer edges.
  const TDCapsuleRectSliderTrackShape({this.trackColorWhenShowScale = const Color(0xFFE7E7E7)});

  @override
  Rect getPreferredRect(
      {required RenderBox parentBox,
      Offset offset = Offset.zero,
      required SliderThemeData sliderTheme,
      bool isEnabled = false,
      bool isDiscrete = false}) {
    var rect = super.getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    var realRect = Rect.fromLTRB(rect.left + 12, rect.top, rect.right - 12, rect.bottom);
    (sliderTheme as TDSliderThemeData).sliderMeasureData.trackerRect = realRect;
    return realRect;
  }

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
    double additionalActiveTrackHeight = 3,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    // If the slider [SliderThemeData.trackHeight] is less than or equal to 0,
    // then it makes no difference whether the track is painted or not,
    // therefore the painting can be a no-op.
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }
    assert(sliderTheme is TDSliderThemeData);

    sliderTheme as TDSliderThemeData;
    // Assign the track segment paints, which are leading: active and
    // trailing: inactive.
    var showScale = (sliderTheme).showScaleValue;
    final activeTrackColorTween =
        ColorTween(begin: sliderTheme.disabledActiveTrackColor, end: sliderTheme.activeTrackColor);
    final inactiveTrackColorTween = ColorTween(
        begin: sliderTheme.disabledInactiveTrackColor,
        end: showScale ? trackColorWhenShowScale : sliderTheme.inactiveTrackColor);
    final activePaint = Paint()..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final inactivePaint = Paint()..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    final Paint activeTrackPaint;
    final Paint inactiveTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        activeTrackPaint = activePaint;
        inactiveTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        activeTrackPaint = inactivePaint;
        inactiveTrackPaint = activePaint;
        break;
    }

    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final trackRadius = Radius.circular(trackRect.height / 2);
    final activeTrackRadius = Radius.circular((trackRect.height - additionalActiveTrackHeight) / 2);

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(trackRect.left - 12, trackRect.top, trackRect.right + 12, trackRect.bottom,
          topLeft: trackRadius, bottomLeft: trackRadius, topRight: trackRadius, bottomRight: trackRadius),
      inactiveTrackPaint,
    );
    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left - 12 + additionalActiveTrackHeight,
        trackRect.top + additionalActiveTrackHeight,
        thumbCenter.dx,
        trackRect.bottom - additionalActiveTrackHeight,
        topLeft: activeTrackRadius,
        bottomLeft: activeTrackRadius,
      ),
      activeTrackPaint,
    );
    if ((sliderTheme).showScaleValue) {
      final inactiveSecondPaint = Paint()..color = sliderTheme.inactiveTrackColor!;
      context.canvas.drawRRect(
        RRect.fromLTRBAndCorners(
          thumbCenter.dx,
          trackRect.top + additionalActiveTrackHeight,
          trackRect.right + 12 - additionalActiveTrackHeight,
          trackRect.bottom - additionalActiveTrackHeight,
          topRight: activeTrackRadius,
          bottomRight: activeTrackRadius,
        ),
        inactiveSecondPaint,
      );
    }
  }
}

///
///游标的绘制
///
class TDCapsuleSliderThumbShape extends SliderComponentShape {
  /// Create a slider thumb that draws a circle.
  const TDCapsuleSliderThumbShape({
    this.enabledThumbRadius = 10.0,
    this.disabledThumbRadius,
    this.elevation = 4.0,
    this.pressedElevation = 4.0,
  });

  /// The preferred radius of the round thumb shape when the slider is enabled.
  ///
  /// If it is not provided, then the Material Design default of 10 is used.
  final double enabledThumbRadius;

  /// The preferred radius of the round thumb shape when the slider is disabled.
  ///
  /// If no disabledRadius is provided, then it is equal to the
  /// [enabledThumbRadius]
  final double? disabledThumbRadius;

  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

  /// The resting elevation adds shadow to the unpressed thumb.
  ///
  /// The default is 1.
  ///
  /// Use 0 for no shadow. The higher the value, the larger the shadow. For
  /// example, a value of 12 will create a very large shadow.
  ///
  final double elevation;

  /// The pressed elevation adds shadow to the pressed thumb.
  ///
  /// The default is 6.
  ///
  /// Use 0 for no shadow. The higher the value, the larger the shadow. For
  /// example, a value of 12 will create a very large shadow.
  final double pressedElevation;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(isEnabled == true ? enabledThumbRadius : _disabledThumbRadius);
  }

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
    assert(sliderTheme.disabledThumbColor != null);
    assert(sliderTheme.thumbColor != null);

    final canvas = context.canvas;
    final radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );
    final colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );

    final color = colorTween.evaluate(enableAnimation)!;
    final radius = radiusTween.evaluate(enableAnimation);

    final elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );
    assert(sliderTheme is TDSliderThemeData);
    final evaluatedElevation = elevationTween.evaluate(activationAnimation);
    final path = Path()..addArc(Rect.fromCenter(center: center, width: 2 * radius, height: 2 * radius), 0, math.pi * 2);

    var paintShadows = true;

    if (paintShadows) {
      canvas.drawShadow(path, const Color.fromRGBO(0, 0, 0, 0.5), evaluatedElevation, true);
    }
    var paint = Paint();
    paint.color = color;
    canvas.drawCircle(
      center,
      radius,
      paint,
    );
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        0,
        2 * math.pi,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = const Color(0xFFF3F3F3));
  }
}

///
/// 刻度绘制
///
class TDCapsuleSliderTickMarkShape extends SliderTickMarkShape {
  /// Create a slider tick mark that draws a circle.
  const TDCapsuleSliderTickMarkShape({
    this.tickMarkRadius,
  });

  /// The preferred radius of the round tick mark.
  ///
  /// If it is not provided, then 1/4 of the [SliderThemeData.trackHeight] is used.
  final double? tickMarkRadius;

  @override
  Size getPreferredSize({
    required SliderThemeData sliderTheme,
    required bool isEnabled,
  }) {
    assert(sliderTheme.trackHeight != null);
    // The tick marks are tiny circles. If no radius is provided, then the
    // radius is defaulted to be a fraction of the
    // [SliderThemeData.trackHeight]. The fraction is 1/4.
    return Size.fromRadius(tickMarkRadius ?? 4);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    required bool isEnabled,
  }) {
    assert(sliderTheme.disabledActiveTickMarkColor != null);
    assert(sliderTheme.disabledInactiveTickMarkColor != null);
    assert(sliderTheme.activeTickMarkColor != null);
    assert(sliderTheme.inactiveTickMarkColor != null);
    // The paint color of the tick mark depends on its position relative
    // to the thumb and the text direction.
    // Color? begin;
    // Color? end;
    // // final paint = Paint()..color = ColorTween(begin: begin, end: end).evaluate(enableAnimation)!;
    // final paint = Paint()
    //   ..strokeWidth = 2
    //   ..color = ColorTween(begin: begin, end: end).evaluate(enableAnimation)!;
    // The tick marks are tiny circles that are the same height as the track.
    final tickMarkRadius = getPreferredSize(
          isEnabled: isEnabled,
          sliderTheme: sliderTheme,
        ).width /
        2;
    var dx = center.dx;
    if (tickMarkRadius > 0 && (sliderTheme as TDSliderThemeData).showScaleValue) {
      assert(sliderTheme.divisions != null);
      var rect = sliderTheme.trackShape?.getPreferredRect(parentBox: parentBox, sliderTheme: sliderTheme);
      if (rect != null && sliderTheme.divisions! > 0) {
        //轨道的高度
        var trackHeight = rect.bottom - rect.top;
        //最左边的刻度中心到最右边刻度中心的长度
        var markWidth = (rect.right - rect.left) - trackHeight;
        //最左边刻度的起点
        var markStart = rect.left + trackHeight / 2;
        //每个刻度的宽度
        var perWidth = markWidth / sliderTheme.divisions!;
        assert(perWidth > 0);
        //计算当前是第几个刻度
        var index = ((center.dx - markStart) / perWidth).round();
        //获取当前刻度的值
        var value = sliderTheme.min + index * ((sliderTheme.max - sliderTheme.min) / sliderTheme.divisions!);
        //修正x坐标
        dx = rect.left + index * (((rect.right - rect.left) / sliderTheme.divisions!));
        //格式化数值
        var valueFormatter = sliderTheme.scaleFormatter != null ? sliderTheme.scaleFormatter!(value) : value.toString();
        //绘制刻度的值
        var painter = TextPainter(
            text: TextSpan(
                text: valueFormatter,
                style: enableAnimation.value > 0 ? sliderTheme.scaleTextStyle : sliderTheme.disabledScaleTextStyle),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center)
          ..layout(maxWidth: 100);
        var x = dx - painter.size.width / 2;
        if (index == 0) {
          x = rect.left - trackHeight / 2;
        } else if (index == sliderTheme.divisions) {
          x = rect.right - painter.size.width + trackHeight / 2;
        }
        painter.paint(context.canvas, Offset(x, center.dy - painter.height - 16));
      }
      if (dx > rect!.left + 1 && dx < rect.right - 1) {
        final isBetweenThumbs = thumbCenter.dx > center.dx;
        final begin =
            isBetweenThumbs ? sliderTheme.disabledActiveTickMarkColor : sliderTheme.disabledInactiveTickMarkColor;
        final end = isBetweenThumbs ? sliderTheme.activeTickMarkColor : sliderTheme.inactiveTickMarkColor;
        final paint = Paint()
          ..strokeWidth = 2
          ..color = ColorTween(begin: begin, end: end).evaluate(enableAnimation)!;
        context.canvas.drawLine(Offset(dx, sliderTheme.sliderMeasureData.trackerRect!.top + 3),
            Offset(dx, sliderTheme.sliderMeasureData.trackerRect!.bottom - 3), paint);
      }
    }
  }
}

/// The default shape of a [TDRangeSlider]'s track.
///
/// It paints a solid colored rectangle with rounded edges, vertically centered
/// in the `parentBox`. The track rectangle extends to the bounds of the
/// `parentBox`, but is padded by the larger of [RoundSliderOverlayShape]'s
/// radius and [RoundRangeSliderThumbShape]'s radius. The height is defined by
/// the [SliderThemeData.trackHeight]. The color is determined by the
/// [RangeSlider]'s enabled state and the track segment's active state which are
/// defined by:
///   [SliderThemeData.activeTrackColor],
///   [SliderThemeData.inactiveTrackColor],
///   [SliderThemeData.disabledActiveTrackColor],
///   [SliderThemeData.disabledInactiveTrackColor].
///
/// {@macro flutter.material.RangeSliderTickMarkShape.paint.trackSegment}
///
/// ![A range slider widget, consisting of 5 divisions and showing the rounded rect range slider track shape.]
/// (https://flutter.github.io/assets-for-api-docs/assets/material/rounded_rect_range_slider_track_shape.png)
///
/// See also:
///
///  * [RangeSlider], for the component that is meant to display this shape.
///  * [SliderThemeData], where an instance of this class is set to inform the
///    slider of the visual details of the its track.
///  * [RangeSliderTrackShape], which can be used to create custom shapes for
///    the [RangeSlider]'s track.
///  * [RectangularRangeSliderTrackShape], for a similar track with sharp edges.
class TDCapsuleRectRangeSliderTrackShape extends RangeSliderTrackShape with TDBaseRangeSliderTrackShape {
  final Color trackColorWhenShowScale;

  /// Create a slider track with rounded outer edges.
  ///
  /// The middle track segment is the selected range and is active, and the two
  /// outer track segments are inactive.
  const TDCapsuleRectRangeSliderTrackShape({this.trackColorWhenShowScale = const Color(0xFFE7E7E7)});

  @override
  Rect getPreferredRect(
      {required RenderBox parentBox,
      Offset offset = Offset.zero,
      required SliderThemeData sliderTheme,
      bool isEnabled = false,
      bool isDiscrete = false}) {
    var rect = super.getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    return Rect.fromLTRB(rect.left + 12, rect.top, rect.right - 12, rect.bottom);
  }

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
    double additionalActiveTrackHeight = 3,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.rangeThumbShape != null);

    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }
    var showScale = (sliderTheme as TDSliderThemeData).showScaleValue;
    // Assign the track segment paints, which are left: active, right: inactive,
    // but reversed for right to left text.
    final activeTrackColorTween = ColorTween(
      begin: sliderTheme.disabledActiveTrackColor,
      end: sliderTheme.activeTrackColor,
    );
    final inactiveTrackColorTween = ColorTween(
      begin: sliderTheme.disabledInactiveTrackColor,
      end: showScale ? trackColorWhenShowScale : sliderTheme.inactiveTrackColor,
    );
    final activePaint = Paint()..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final inactivePaint = Paint()..color = inactiveTrackColorTween.evaluate(enableAnimation)!;

    final Offset leftThumbOffset;
    final Offset rightThumbOffset;
    switch (textDirection) {
      case TextDirection.ltr:
        leftThumbOffset = startThumbCenter;
        rightThumbOffset = endThumbCenter;
        break;
      case TextDirection.rtl:
        leftThumbOffset = endThumbCenter;
        rightThumbOffset = startThumbCenter;
        break;
    }
    final thumbSize = sliderTheme.rangeThumbShape!.getPreferredSize(isEnabled, isDiscrete);
    final thumbRadius = thumbSize.width / 2;
    assert(thumbRadius > 0);

    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final trackRadius = Radius.circular(trackRect.height / 2);

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left - 12,
        trackRect.top,
        trackRect.right + 12,
        trackRect.bottom,
        topLeft: trackRadius,
        bottomLeft: trackRadius,
        topRight: trackRadius,
        bottomRight: trackRadius,
      ),
      inactivePaint,
    );
    var activeTrackRadius = Radius.circular(trackRect.height / 2 - additionalActiveTrackHeight);
    final inactiveSecondPaint = Paint()..color = sliderTheme.inactiveTrackColor!;
    if (showScale) {
      context.canvas.drawRRect(
        RRect.fromLTRBAndCorners(
          trackRect.left - 9,
          trackRect.top + additionalActiveTrackHeight,
          rightThumbOffset.dx,
          trackRect.bottom - additionalActiveTrackHeight,
          topLeft: activeTrackRadius,
          bottomLeft: activeTrackRadius,
        ),
        inactiveSecondPaint,
      );
    }
    context.canvas.drawRect(
      Rect.fromLTRB(
        leftThumbOffset.dx,
        trackRect.top + additionalActiveTrackHeight,
        rightThumbOffset.dx,
        trackRect.bottom - additionalActiveTrackHeight,
      ),
      activePaint,
    );
    if ((sliderTheme).showScaleValue) {
      context.canvas.drawRRect(
        RRect.fromLTRBAndCorners(
          rightThumbOffset.dx,
          trackRect.top + additionalActiveTrackHeight,
          trackRect.right + 9,
          trackRect.bottom - additionalActiveTrackHeight,
          topRight: activeTrackRadius,
          bottomRight: activeTrackRadius,
        ),
        inactiveSecondPaint,
      );
    }
  }
}

/// The default shape of a [RangeSlider]'s thumbs.
///
/// There is a shadow for the resting and pressed state.
///
/// ![A slider widget, consisting of 5 divisions and showing the round range slider thumb shape.]
/// (https://flutter.github.io/assets-for-api-docs/assets/material/round_range_slider_thumb_shape.png)
///
/// See also:
///
///  * [RangeSlider], which includes thumbs defined by this shape.
///  * [SliderTheme], which can be used to configure the thumb shapes of all
///    range sliders in a widget subtree.
class TDCapsuleRangeSliderThumbShape extends RangeSliderThumbShape {
  /// Create a slider thumb that draws a circle.
  const TDCapsuleRangeSliderThumbShape({
    this.enabledThumbRadius = 10.0,
    this.disabledThumbRadius,
    this.elevation = 3.0,
    this.pressedElevation = 3.0,
  });

  /// The preferred radius of the round thumb shape when the slider is enabled.
  ///
  /// If it is not provided, then the Material Design default of 10 is used.
  final double enabledThumbRadius;

  /// The preferred radius of the round thumb shape when the slider is disabled.
  ///
  /// If no disabledRadius is provided, then it is equal to the
  /// [enabledThumbRadius].
  final double? disabledThumbRadius;

  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

  /// The resting elevation adds shadow to the unpressed thumb.
  ///
  /// The default is 1.
  final double elevation;

  /// The pressed elevation adds shadow to the pressed thumb.
  ///
  /// The default is 6.
  final double pressedElevation;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(isEnabled == true ? enabledThumbRadius : _disabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    assert(sliderTheme.showValueIndicator != null);
    assert(sliderTheme.overlappingShapeStrokeColor != null);
    final canvas = context.canvas;
    final radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );
    final colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    );
    final radius = radiusTween.evaluate(enableAnimation);
    final elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );

    // Add a stroke of 1dp around the circle if this thumb would overlap
    // the other thumb.
    if (isOnTop ?? false) {
      final strokePaint = Paint()
        ..color = sliderTheme.overlappingShapeStrokeColor!
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(center, radius, strokePaint);
    }

    final color = colorTween.evaluate(enableAnimation)!;

    final evaluatedElevation = isPressed! ? elevationTween.evaluate(activationAnimation) : elevation;
    final shadowPath = Path()
      ..addArc(Rect.fromCenter(center: center, width: 2 * radius, height: 2 * radius), 0, math.pi * 2);

    var paintShadows = true;
    if (paintShadows) {
      canvas.drawShadow(shadowPath, const Color.fromRGBO(0, 0, 0, 0.5), evaluatedElevation, true);
    }
    if ((sliderTheme as TDSliderThemeData).showThumbValue && sliderTheme.sliderMeasureData.trackerRect != null) {
      var trackerRect = sliderTheme.sliderMeasureData.trackerRect!;
      var ratio = (center.dx - trackerRect.left) / (trackerRect.right - trackerRect.left);
      //计算滑块的值
      var value = (sliderTheme.max - sliderTheme.min) * ratio + sliderTheme.min;
      //格式化显示
      var formatterValue =
          sliderTheme.scaleFormatter == null ? value.toStringAsFixed(2) : sliderTheme.scaleFormatter!(value);
      //绘制数值
      var painter = TextPainter(
          text: TextSpan(text: '$formatterValue', style: sliderTheme.thumbTextStyle),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center)
        ..layout(maxWidth: 100);
      painter.paint(context.canvas, Offset(center.dx - painter.size.width / 2, center.dy - painter.height - 16));
    }

    //绘制游标
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = color,
    );
  }
}

/// The default shape of each [RangeSlider] tick mark.
///
/// Tick marks are only displayed if the slider is discrete, which can be done
/// by setting the [RangeSlider.divisions] to an integer value.
///
/// It paints a solid circle, centered on the track.
/// The color is determined by the [Slider]'s enabled state and track's active
/// states. These colors are defined in:
///   [SliderThemeData.activeTrackColor],
///   [SliderThemeData.inactiveTrackColor],
///   [SliderThemeData.disabledActiveTrackColor],
///   [SliderThemeData.disabledInactiveTrackColor].
///
/// ![A slider widget, consisting of 5 divisions and showing the round range slider tick mark shape.]
/// (https://flutter.github.io/assets-for-api-docs/assets/material/round_range_slider_tick_mark_shape.png )
///
/// See also:
///
///  * [RangeSlider], which includes tick marks defined by this shape.
///  * [SliderTheme], which can be used to configure the tick mark shape of all
///    sliders in a widget subtree.
class TDCapsuleRangeSliderTickMarkShape extends RangeSliderTickMarkShape {
  /// Create a range slider tick mark that draws a circle.
  const TDCapsuleRangeSliderTickMarkShape({
    this.tickMarkRadius,
  });

  /// The preferred radius of the round tick mark.
  ///
  /// If it is not provided, then 1/4 of the [SliderThemeData.trackHeight] is used.
  final double? tickMarkRadius;

  @override
  Size getPreferredSize({
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
  }) {
    return Size.fromRadius(tickMarkRadius ?? 4);
  }

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
    assert(sliderTheme.disabledActiveTickMarkColor != null);
    assert(sliderTheme.disabledInactiveTickMarkColor != null);
    assert(sliderTheme.activeTickMarkColor != null);
    assert(sliderTheme.inactiveTickMarkColor != null);

    // The tick marks are tiny circles that are the same height as the track.
    final tickMarkRadius = getPreferredSize(
          isEnabled: isEnabled,
          sliderTheme: sliderTheme,
        ).width /
        2;
    var dx = center.dx;
    if (tickMarkRadius > 0 && (sliderTheme as TDSliderThemeData).showScaleValue) {
      assert(sliderTheme.divisions != null);
      var rect = sliderTheme.rangeTrackShape?.getPreferredRect(parentBox: parentBox, sliderTheme: sliderTheme);
      if (rect != null && sliderTheme.divisions! > 0) {
        //轨道的高度
        var trackHeight = rect.bottom - rect.top;
        //最左边的刻度中心到最右边刻度中心的长度
        var markWidth = (rect.right - rect.left) - trackHeight;
        //最左边刻度的起点
        var markStart = rect.left + trackHeight / 2;
        //每个刻度的宽度
        var perWidth = markWidth / sliderTheme.divisions!;
        assert(perWidth > 0);
        //计算当前是第几个刻度
        var index = ((center.dx - markStart) / perWidth).round();
        //获取当前刻度的值
        var value = sliderTheme.min + index * ((sliderTheme.max - sliderTheme.min) / sliderTheme.divisions!);
        //格式化数值
        var valueFormatter = sliderTheme.scaleFormatter != null ? sliderTheme.scaleFormatter!(value) : value.toString();
        //修正x坐标
        dx = rect.left + index * (((rect.right - rect.left) / sliderTheme.divisions!));
        //绘制刻度的值
        var painter = TextPainter(
            text: TextSpan(
                text: valueFormatter,
                style: enableAnimation.value > 0 ? sliderTheme.scaleTextStyle : sliderTheme.disabledScaleTextStyle),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center)
          ..layout(maxWidth: 100);
        var x = dx - painter.size.width / 2;
        if (index == 0) {
          x = rect.left - trackHeight / 2;
        } else if (index == sliderTheme.divisions) {
          x = rect.right - painter.size.width + trackHeight / 2;
        }
        painter.paint(context.canvas, Offset(x, center.dy - painter.height - 16));
      }
      if (dx > rect!.left + 1 && dx < rect.right - 1) {
        final bool isBetweenThumbs;
        switch (textDirection) {
          case TextDirection.ltr:
            isBetweenThumbs = startThumbCenter.dx < center.dx && center.dx < endThumbCenter.dx;
            break;
          case TextDirection.rtl:
            isBetweenThumbs = endThumbCenter.dx < center.dx && center.dx < startThumbCenter.dx;
            break;
        }
        final begin =
            isBetweenThumbs ? sliderTheme.disabledActiveTickMarkColor : sliderTheme.disabledInactiveTickMarkColor;
        final end = isBetweenThumbs ? sliderTheme.activeTickMarkColor : sliderTheme.inactiveTickMarkColor;
        final paint = Paint()
          ..strokeWidth = 2
          ..color = ColorTween(begin: begin, end: end).evaluate(enableAnimation)!;
        context.canvas.drawLine(Offset(dx, sliderTheme.sliderMeasureData.trackerRect!.top + 3),
            Offset(dx, sliderTheme.sliderMeasureData.trackerRect!.bottom - 3), paint);
      }
    }
  }
}

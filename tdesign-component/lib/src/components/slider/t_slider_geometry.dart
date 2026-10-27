import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import 't_slider_theme.dart';

// Axis is a layout input of the internal vertical composition, not a theme
// override or a public component option.
class SliderGeometryScope extends InheritedWidget {
  const SliderGeometryScope({
    required this.axis,
    required super.child,
    super.key,
  });

  final Axis axis;

  static Axis axisOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SliderGeometryScope>()?.axis ??
      Axis.horizontal;

  @override
  bool updateShouldNotify(SliderGeometryScope oldWidget) =>
      axis != oldWidget.axis;
}

// Internal implementation shared with the repository's vertical composition.
// This library is deliberately not exported by tdesign_flutter.dart.
class SliderGeometry {
  const SliderGeometry({
    required this.capsule,
    required this.trackHeight,
    required this.horizontalInset,
  });

  factory SliderGeometry.resolve(
    BuildContext context, {
    required bool capsule,
  }) {
    final token = context.tTheme;
    final theme = Theme.of(context).extension<TSliderThemeData>();
    final axis = SliderGeometryScope.axisOf(context);
    final requestedHeight = capsule ? token.spacer3 : theme?.trackHeight ?? 4;
    return SliderGeometry(
      capsule: capsule,
      trackHeight: capsule
          ? math.max(thumbDiameter + 4, _nonNegative(requestedHeight))
          : _nonNegative(requestedHeight),
      horizontalInset: axis == Axis.horizontal
          ? _nonNegative(token.spacer2)
          : thumbDiameter / 2 + thumbBorderWidth / 2,
    );
  }

  static const double thumbDiameter = 20;
  static const double thumbBorderWidth = 1;
  static const double capsuleBorderWidth = 3;
  // Preserve the existing continuous-range interaction at normal sizes.
  static const double minimumRangeSeparation = 8;
  static const double hitRadius = 24;
  static const double tickRadius = 3;
  static const double capsuleGapWidth = 2;

  final bool capsule;
  final double trackHeight;
  final double horizontalInset;

  // Native slider sizing: a 144px track plus the 48px overlay, with a
  // cross axis large enough for that overlay or the requested track.
  Size get preferredSize =>
      Size(144 + hitRadius * 2, math.max(hitRadius * 2, trackHeight));

  Size sizeForConstraints(BoxConstraints constraints) => constraints.constrain(
    Size(
      constraints.hasBoundedWidth ? constraints.maxWidth : preferredSize.width,
      constraints.hasBoundedHeight
          ? constraints.maxHeight
          : preferredSize.height,
    ),
  );

  // A declared vertical track length excludes the thumb hit area. Both layout
  // and labels use these metrics, so reserving hit space never shortens it.
  SliderMetrics forTrackLength(
    double length, {
    double crossExtent = double.infinity,
  }) {
    final visible = _nonNegative(length);
    final crossScale = _crossScale(crossExtent);
    final minimumLength = capsule ? _minimumControlExtent : thumbDiameter;
    final scale = math.min(crossScale, visible / minimumLength);
    // Below the minimum unscaled track length, forWidth has consumed optional
    // spacing. Use the same limiting spacing when converting back to a box.
    final compact = visible < minimumLength * crossScale;
    final minimumInset = capsule ? 0.0 : _thumbHitInset;
    final inset =
        (compact
            ? minimumInset
            : math.max(_nonNegative(horizontalInset), minimumInset)) *
        scale;
    return forWidth(visible + inset * 2, crossExtent: crossExtent);
  }

  static const double _thumbHitInset = thumbDiameter / 2 + thumbBorderWidth / 2;
  double get _minimumControlExtent => capsule
      ? thumbDiameter * 2 + capsuleBorderWidth * 2
      : thumbDiameter + _thumbHitInset * 2;

  double _crossScale(double extent) => extent == double.infinity
      ? 1
      : math.min(
          1,
          _nonNegative(extent) / (capsule ? thumbDiameter + 4 : thumbDiameter),
        );

  SliderMetrics forSize(Size size) =>
      forWidth(size.width, crossExtent: size.height);

  SliderMetrics forWidth(double width, {double crossExtent = double.infinity}) {
    final available = _nonNegative(width);
    final scale = math.min(
      _crossScale(crossExtent),
      available / _minimumControlExtent,
    );
    final height = math.min(
      _nonNegative(trackHeight) * scale,
      crossExtent == double.infinity
          ? double.infinity
          : _nonNegative(crossExtent),
    );
    final radius = thumbDiameter / 2 * scale;
    final minimumInset = capsule ? 0.0 : _thumbHitInset * scale;
    final maximumInset = math.max(
      minimumInset,
      (available - (capsule ? _minimumControlExtent : thumbDiameter) * scale) /
          2,
    );
    final visualInset = (_nonNegative(horizontalInset) * scale)
        .clamp(minimumInset, maximumInset)
        .toDouble();
    // The capsule border is 3px on the travel axis; track thickness controls
    // the cross axis only. Marks never change the thumb's endpoints.
    final endInset = capsule ? radius + capsuleBorderWidth * scale : 0.0;
    final thumbInset = visualInset + endInset;
    return SliderMetrics(
      width: available,
      trackHeight: height,
      thumbRadius: radius,
      visualInset: visualInset,
      thumbInset: thumbInset,
    );
  }

  static double effectiveValue(
    double value,
    double min,
    double max,
    int? divisions,
  ) {
    final normalized = ((value - min) / (max - min)).clamp(0.0, 1.0);
    if (divisions == null || divisions <= 0) {
      return value;
    }
    final step = (normalized * divisions).round();
    return min + (max - min) * step / divisions;
  }

  static double _nonNegative(double value) =>
      value.isFinite ? math.max(0.0, value) : 0.0;
}

class SliderMetrics {
  const SliderMetrics({
    required this.width,
    required this.trackHeight,
    required this.thumbRadius,
    required this.visualInset,
    required this.thumbInset,
  });

  final double width;
  final double trackHeight;
  final double thumbRadius;
  final double visualInset;
  final double thumbInset;

  // A minimum gap cannot exceed an already valid controlled interval. This
  // keeps narrow/overlapping input values valid without forcing them apart.
  double rangeSeparation(double normalizedSpan) => math.min(
    SliderGeometry.minimumRangeSeparation * scale,
    math.max(0.0, width - thumbInset * 2) * normalizedSpan.clamp(0.0, 1.0),
  );

  Size get thumbSize => Size.fromRadius(thumbRadius);
  bool get hasTravel => thumbRadius > 0 && width > thumbInset * 2;
  double get scale => thumbRadius / (SliderGeometry.thumbDiameter / 2);
  double get tickRadius => SliderGeometry.tickRadius * scale;
  double get capsuleGapWidth => SliderGeometry.capsuleGapWidth * scale;

  double get capsuleInset => SliderGeometry.capsuleBorderWidth * scale;

  double thumbOffset(double ratio) =>
      thumbInset + ratio * (width - thumbInset * 2);

  double valueAt(
    double position, {
    required double min,
    required double max,
    required int? divisions,
    required TextDirection direction,
  }) {
    assert(hasTravel);
    final visual = ((position - thumbInset) / (width - thumbInset * 2)).clamp(
      0.0,
      1.0,
    );
    final ratio = direction == TextDirection.rtl ? 1 - visual : visual;
    return SliderGeometry.effectiveValue(
      min + ratio * (max - min),
      min,
      max,
      divisions,
    );
  }

  Rect visualRect(Size size, Offset offset) => Rect.fromLTWH(
    offset.dx + visualInset,
    offset.dy + (size.height - trackHeight) / 2,
    math.max(0.0, width - visualInset * 2),
    trackHeight,
  );

  // A zero-height coordinate rect prevents native SDK padding from becoming a
  // second source of thumb geometry in either supported Flutter version.
  Rect coordinateRect(Size size, Offset offset) => Rect.fromLTRB(
    offset.dx + thumbInset,
    offset.dy + size.height / 2,
    offset.dx + width - thumbInset,
    offset.dy + size.height / 2,
  );
}

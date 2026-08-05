import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// The constraints used by [StickyHeaderValueLayoutBuilder].
class StickyHeaderBoxValueConstraints<T> extends BoxConstraints {
  StickyHeaderBoxValueConstraints({
    required this.value,
    required BoxConstraints constraints,
  }) : super(
         minWidth: constraints.minWidth,
         maxWidth: constraints.maxWidth,
         minHeight: constraints.minHeight,
         maxHeight: constraints.maxHeight,
       );

  final T value;

  @override
  bool operator ==(Object other) {
    assert(debugAssertIsValid());
    if (identical(this, other)) {
      return true;
    }
    if (other is! StickyHeaderBoxValueConstraints<T>) {
      return false;
    }
    assert(other.debugAssertIsValid());
    return value == other.value &&
        minWidth == other.minWidth &&
        maxWidth == other.maxWidth &&
        minHeight == other.minHeight &&
        maxHeight == other.maxHeight;
  }

  @override
  int get hashCode {
    assert(debugAssertIsValid());
    return Object.hash(minWidth, maxWidth, minHeight, maxHeight, value);
  }
}

/// Builds a sticky header from layout constraints and its current state.
class StickyHeaderValueLayoutBuilder<T>
    extends ConstrainedLayoutBuilder<StickyHeaderBoxValueConstraints<T>> {
  const StickyHeaderValueLayoutBuilder({
    super.key,
    required Widget Function(
      BuildContext context,
      StickyHeaderBoxValueConstraints<T> constraints,
    )
    builder,
  }) : super(builder: builder);

  @override
  // ignore: library_private_types_in_public_api
  _RenderStickyHeaderValueLayoutBuilder<T> createRenderObject(
    BuildContext context,
  ) => _RenderStickyHeaderValueLayoutBuilder<T>();
}

class _RenderStickyHeaderValueLayoutBuilder<T> extends RenderBox
    with
        RenderObjectWithChildMixin<RenderBox>,
        RenderObjectWithLayoutCallbackMixin,
        RenderAbstractLayoutBuilderMixin<
          StickyHeaderBoxValueConstraints<T>,
          RenderBox
        > {
  @override
  double computeMinIntrinsicWidth(double height) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    assert(_debugThrowIfNotCheckingIntrinsics());
    return 0.0;
  }

  @override
  void performLayout() {
    final constraints = this.constraints;
    runLayoutCallback();
    if (child != null) {
      child!.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(child!.size);
    } else {
      size = constraints.biggest;
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return child?.hitTest(result, position: position) ?? false;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      context.paintChild(child!, offset);
    }
  }

  bool _debugThrowIfNotCheckingIntrinsics() {
    assert(() {
      if (!RenderObject.debugCheckingIntrinsics) {
        throw FlutterError(
          'StickyHeaderValueLayoutBuilder does not support returning intrinsic dimensions.\n'
          'Calculating the intrinsic dimensions would require running the layout '
          'callback speculatively, which might mutate the live render object tree.',
        );
      }
      return true;
    }());
    return true;
  }
}

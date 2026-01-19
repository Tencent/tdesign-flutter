import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// The signature of the [ValueLayoutBuilder] builder function.
typedef ValueLayoutWidgetBuilder<T> = Widget Function(
    BuildContext context,
    BoxValueConstraints<T> constraints,
    );

class BoxValueConstraints<T> extends BoxConstraints {
  BoxValueConstraints({
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
  bool operator ==(dynamic other) {
    assert(debugAssertIsValid());
    if (identical(this, other)) {
      return true;
    }
    if (other is! BoxValueConstraints<T>) {
      return false;
    }
    final typedOther = other;
    assert(typedOther.debugAssertIsValid());
    return value == typedOther.value &&
        minWidth == typedOther.minWidth &&
        maxWidth == typedOther.maxWidth &&
        minHeight == typedOther.minHeight &&
        maxHeight == typedOther.maxHeight;
  }

  @override
  int get hashCode {
    assert(debugAssertIsValid());
    return Object.hash(minWidth, maxWidth, minHeight, maxHeight, value);
  }
}

/// Builds a widget tree that can depend on the parent widget's size and a extra
/// value.
///
/// Similar to the [LayoutBuilder] widget except that the constraints contains
/// an extra value.
///
class ValueLayoutBuilder<T> extends ConstrainedLayoutBuilder<BoxValueConstraints<T>> {
  /// Creates a widget that defers its building until layout.
  const ValueLayoutBuilder({
    Key? key,
    required ValueLayoutWidgetBuilder<T> builder,
  }) : super(key: key, builder: builder);

  @override
  ValueLayoutWidgetBuilder<T> get builder => super.builder;

  @override
  _RenderValueLayoutBuilder<T> createRenderObject(BuildContext context) => _RenderValueLayoutBuilder<T>();
}

class _RenderValueLayoutBuilder<T> extends RenderBox
    with RenderObjectWithChildMixin<RenderBox>, RenderObjectWithLayoutCallbackMixin, RenderAbstractLayoutBuilderMixin<BoxValueConstraints<T>, RenderBox> {
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
        throw FlutterError('ValueLayoutBuilder does not support returning intrinsic dimensions.\n'
            'Calculating the intrinsic dimensions would require running the layout '
            'callback speculatively, which might mutate the live render object tree.');
      }
      return true;
    }());

    return true;
  }
}

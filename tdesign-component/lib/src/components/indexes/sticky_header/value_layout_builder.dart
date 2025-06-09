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
/// https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/widgets/layout_builder.dart
///
/// 兼容新版的 ValueLayoutBuilder
class ValueLayoutBuilder<T> extends StatelessWidget {
  const ValueLayoutBuilder({Key? key, required this.value, required this.builder}) : super(key: key);

  final T value;
  final ValueLayoutWidgetBuilder<T> builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return builder(ctx, BoxValueConstraints<T>(value: value, constraints: constraints));
      },
    );
  }
}
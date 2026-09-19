import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// 组合组件提供给徽标的最低优先级定位默认值。
///
/// 仅供 TDesign 内部组合组件使用；实例参数与主题配置始终优先。
@internal
class TBadgeFallback extends InheritedWidget {
  const TBadgeFallback({
    super.key,
    required super.child,
    this.alignment,
    this.offset,
  });

  final AlignmentGeometry? alignment;
  final Offset? offset;

  @override
  bool updateShouldNotify(TBadgeFallback oldWidget) =>
      alignment != oldWidget.alignment || offset != oldWidget.offset;
}

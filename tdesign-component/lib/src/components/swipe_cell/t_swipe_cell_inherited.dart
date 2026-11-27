import 'package:flutter/widgets.dart';

/// 向操作项传递当前滑动单元格关闭能力。
class TSwipeCellInherited extends InheritedWidget {
  const TSwipeCellInherited({
    super.key,
    required super.child,
    required this.close,
  });

  /// 关闭当前滑动单元格。
  final Future<void> Function() close;

  @override
  bool updateShouldNotify(covariant TSwipeCellInherited oldWidget) {
    return close != oldWidget.close;
  }

  /// 获取最近的 [TSwipeCellInherited]。
  static TSwipeCellInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TSwipeCellInherited>();
  }
}

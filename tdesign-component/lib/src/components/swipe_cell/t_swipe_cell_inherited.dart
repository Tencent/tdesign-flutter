import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 't_swipe_cell_action.dart';

/// 滑动单元格的 InheritedWidget，用于向子树传递滑动状态
class TSwipeCellInherited extends InheritedWidget {
  const TSwipeCellInherited({
    Key? key,
    required Widget child,
    required this.cellClick,
    required this.actionClick,
    required this.duration,
    required this.controller,
  }) : super(child: child, key: key);

  /// 滑动动画时长
  final Duration duration;

  /// 单元格点击回调
  final void Function() cellClick;

  /// 操作按钮点击回调，返回 true 表示触发二次确认
  final bool Function(TSwipeCellAction action) actionClick;

  /// 滑动控制器
  final SlidableController controller;

  @override
  bool updateShouldNotify(covariant TSwipeCellInherited oldWidget) {
    return true;
  }

  /// 获取最近的 [TSwipeCellInherited] 实例
  static TSwipeCellInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TSwipeCellInherited>();
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import './td_swipe_panel.dart';
import '../cell/td_cell.dart';

enum TDSwipeDirection { right, left }

/// 滑动单元格组件
class TDSwipeCell extends StatefulWidget {
  const TDSwipeCell({
    Key? key,
    this.slidableKey,
    required this.cell,
    this.disabled = false,
    this.opened = const [false, false],
    this.right,
    this.left,
    this.onChange,
    this.controller,
    this.groupTag,
    this.closeOnScroll = true,
    this.dragStartBehavior = DragStartBehavior.start,
    this.direction = Axis.horizontal,
  }) : super(key: key);

  /// 滑动组件的 Key
  final Key? slidableKey;

  /// 单元格 [TDCell]
  final Widget cell;

  /// 是否禁用滑动
  final bool? disabled;

  /// 默认打开，[left, rigth]
  final List<bool>? opened;

  /// 右侧滑动操作项面板
  final TDSwipePanel? right;

  /// 左侧滑动操作项面板
  final TDSwipePanel? left;

  /// 滑动展开事件
  final Function(TDSwipeDirection direction, bool open)? onChange;

  /// 自定义控制滑动窗口
  final SlidableController? controller;

  /// 同一组中只有一个被打开
  final Object? groupTag;

  /// 滚动时，是否关闭滑动操作项面板
  final bool? closeOnScroll;

  /// 处理拖动开始行为的方式[GestureDetector.dragStartBehavior]
  final DragStartBehavior? dragStartBehavior;

  /// 可拖动的方向
  final Axis? direction;

  @override
  _TDSwipeCellState createState() => _TDSwipeCellState();
}

class _TDSwipeCellState extends State<TDSwipeCell> with TickerProviderStateMixin {
  late final SlidableController controller;
  TDSwipeDirection? openDirection;

  @override
  void initState() {
    super.initState();
    controller = (widget.controller ?? SlidableController(this))
      ..actionPaneType.addListener(_handleActionPanelTypeChanged);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if ((widget.opened?.length ?? 0) > 0 && widget.opened![0] == true) {
        controller.openStartActionPane();
      }
      if ((widget.opened?.length ?? 0) > 1 && widget.opened![1] == true) {
        controller.openEndActionPane();
      }
    });
  }

  @override
  void didUpdateWidget(covariant TDSwipeCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      controller.actionPaneType.removeListener(_handleActionPanelTypeChanged);

      controller = (widget.controller ?? SlidableController(this))
        ..actionPaneType.addListener(_handleActionPanelTypeChanged);
    }
  }

  @override
  void dispose() {
    controller.actionPaneType.removeListener(_handleActionPanelTypeChanged);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: widget.slidableKey ?? UniqueKey(),
      closeOnScroll: widget.closeOnScroll ?? true,
      child: widget.cell,
      controller: controller,
      enabled: !(widget.disabled ?? false),
      groupTag: widget.groupTag,
      startActionPane: widget.left?.build(context),
      endActionPane: widget.right?.build(context),
      dragStartBehavior: widget.dragStartBehavior ?? DragStartBehavior.start,
      direction: widget.direction ?? Axis.horizontal,
    );
  }

  void _handleActionPanelTypeChanged() {
    if (widget.onChange == null) {
      return;
    }
    switch (controller.actionPaneType.value) {
      case ActionPaneType.none:
        widget.onChange!(openDirection!, false);
        openDirection = null;
        break;
      case ActionPaneType.start:
        openDirection = TDSwipeDirection.left;
        widget.onChange!(openDirection!, true);
        break;
      case ActionPaneType.end:
        openDirection = TDSwipeDirection.right;
        widget.onChange!(openDirection!, true);
        break;
    }
  }
}

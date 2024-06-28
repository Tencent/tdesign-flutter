import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import './td_swipe_auto_close.dart';
import './td_swipe_panel.dart';
import '../cell/td_cell.dart';
import 'td_swipe_action.dart';

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

  /// 同一组中只有一个被打开，[TDSwipeCell]必须为[TDSwipeAutoClose]的后代组件才有效
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
    final rightConfirmLength = widget.right?.confirms?.length ?? 0;
    final leftConfirmLength = widget.left?.confirms?.length ?? 0;
    final isHorizontal = widget.direction == Axis.horizontal;
    final slidable = Slidable(
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
    return rightConfirmLength > 0 || leftConfirmLength > 0
        ? Stack(
            children: [
              slidable,
              ...List.generate(
                rightConfirmLength,
                (index) => Positioned.fill(
                  child: FractionallySizedBox(
                    alignment: isHorizontal ? Alignment.centerRight : Alignment.bottomCenter,
                    widthFactor: isHorizontal ? widget.right?.extentRatio ?? 0.3 : null,
                    heightFactor: isHorizontal ? null : widget.right?.extentRatio ?? 0.3,
                    child: ClipRect(
                      // clipper: ,
                      child: widget.right!.confirms![index],
                    ),
                  ),
                ),
              ),
              ...List.generate(
                leftConfirmLength,
                (index) => Positioned.fill(
                  child: FractionallySizedBox(
                    alignment: isHorizontal ? Alignment.centerLeft : Alignment.topCenter,
                    widthFactor: isHorizontal ? widget.left?.extentRatio ?? 0.3 : null,
                    heightFactor: isHorizontal ? null : widget.left?.extentRatio ?? 0.3,
                    child: ClipRect(
                      // clipper: ,
                      child: widget.right!.confirms![index],
                    ),
                  ),
                ),
              ),
            ],
          )
        : slidable;
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

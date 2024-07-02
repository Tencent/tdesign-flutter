import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../util/list_ext.dart';
import '../cell/td_cell.dart';
import 'td_swipe_cell_action.dart';
import 'td_swipe_cell_close.dart';
import 'td_swipe_cell_inherited.dart';
import 'td_swipe_cell_panel.dart';

export 'package:flutter_slidable/flutter_slidable.dart';

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
    this.duration = const Duration(milliseconds: 200),
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
  final TDSwipeCellPanel? right;

  /// 左侧滑动操作项面板
  final TDSwipeCellPanel? left;

  /// 滑动展开事件
  final Function(TDSwipeDirection direction, bool open)? onChange;

  /// 自定义控制滑动窗口
  final SlidableController? controller;

  /// 同一组中只有一个被打开，[TDSwipeCell]必须为[TDSwipeCellClose]的后代组件才有效
  final Object? groupTag;

  /// 滚动时，是否关闭滑动操作项面板
  final bool? closeOnScroll;

  /// 处理拖动开始行为的方式[GestureDetector.dragStartBehavior]
  final DragStartBehavior? dragStartBehavior;

  /// 可拖动的方向
  final Axis? direction;

  /// 打开关闭动画时长
  final Duration? duration;

  Duration get getDuration => duration ?? const Duration(milliseconds: 200);

  @override
  _TDSwipeCellState createState() => _TDSwipeCellState();

  static SlidableController? of(BuildContext context) {
    return Slidable.of(context);
  }
}

class _TDSwipeCellState extends State<TDSwipeCell> with TickerProviderStateMixin {
  late final SlidableController controller;
  final confirmListenable = ValueNotifier<TDSwipeCellAction?>(null);
  TDSwipeDirection? openDirection;

  @override
  void initState() {
    super.initState();
    controller = (widget.controller ?? SlidableController(this))
      ..actionPaneType.addListener(_handleActionPanelTypeChanged)
      ..animation.addStatusListener((status) {
        confirmListenable.value = null;
      });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if ((widget.opened?.length ?? 0) > 0 && widget.opened![0] == true) {
        controller.openStartActionPane(duration: widget.getDuration);
      }
      if ((widget.opened?.length ?? 0) > 1 && widget.opened![1] == true) {
        controller.openEndActionPane(duration: widget.getDuration);
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
    return TDSwipeCellInherited(
      duration: widget.getDuration,
      controller: controller,
      actionClick: (action) {
        final isLeft = openDirection == TDSwipeDirection.left;
        final panel = isLeft ? widget.left! : widget.right!;
        final index = panel.children.indexOf(action);
        final confirm = panel.confirms?.find((element) => element.confirmIndex?.contains(index) == true);
        confirmListenable.value = confirm;
        return confirm != null;
      },
      child: rightConfirmLength > 0 || leftConfirmLength > 0
          ? ValueListenableBuilder(
              valueListenable: confirmListenable,
              builder: (BuildContext context, value, Widget? child) {
                return Stack(
                  children: [
                    slidable,
                    _confirmWidget(),
                  ],
                );
              },
            )
          : slidable,
    );
  }

  Widget _confirmWidget() {
    final isHorizontal = widget.direction == Axis.horizontal;
    final isLeft = openDirection == TDSwipeDirection.left;
    final pane = isLeft ? widget.left : widget.right;
    final extentRatio = pane?.extentRatio ?? 0.3;
    return Positioned.fill(
      child: FractionallySizedBox(
        alignment: isHorizontal
            ? (isLeft ? Alignment.centerLeft : Alignment.centerRight)
            : (isLeft ? Alignment.topCenter : Alignment.bottomCenter),
        widthFactor: isHorizontal ? extentRatio : null,
        heightFactor: isHorizontal ? null : extentRatio,
        child: AnimatedSwitcher(
          duration: widget.getDuration,
          transitionBuilder: (child, animation) {
            return SlideTransition(
              child: child,
              position: Tween<Offset>(
                begin: isLeft ? const Offset(-1, 0) : const Offset(1, 0),
                end: isLeft ? const Offset(0, 0) : const Offset(0, 0),
              ).animate(animation),
            );
          },
          child: confirmListenable.value ?? const SizedBox.shrink(),
        ),
      ),
    );
  }

  void _handleActionPanelTypeChanged() {
    switch (controller.actionPaneType.value) {
      case ActionPaneType.none:
        widget.onChange?.call(openDirection!, false);
        openDirection = null;
        break;
      case ActionPaneType.start:
        openDirection = TDSwipeDirection.left;
        widget.onChange?.call(openDirection!, true);
        break;
      case ActionPaneType.end:
        openDirection = TDSwipeDirection.right;
        widget.onChange?.call(openDirection!, true);
        break;
    }
  }
}

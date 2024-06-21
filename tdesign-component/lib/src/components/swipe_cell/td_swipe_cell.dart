import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../tdesign_flutter.dart';
import '../cell/td_cell.dart';
import 'td_swipe_option.dart';

typedef CellBuilder = Widget Function(BuildContext context, TDCell cell);

enum SwipeDirection { right, left }

/// 滑动单元格组件
class TDSwipeCell extends StatefulWidget {
  const TDSwipeCell({
    Key? key,
    this.cell,
    this.cells,
    this.builder,
    this.disabled = false,
    this.openedRight = false,
    this.openedLeft = false,
    this.right,
    this.rightWidget,
    this.rightConfirm,
    this.rightConfirmWidget,
    this.left,
    this.leftWidget,
    this.leftConfirm,
    this.leftConfirmWidget,
    this.onChange,
    this.controller,
    this.groupTag,
  }) : super(key: key);

  /// 单元格
  final TDCell? cell;

  /// 单元格列表，优先级高于cell
  final List<TDCell>? cells;

  /// cell构建器，可自定义cell父组件，如Dismissible
  final CellBuilder? builder;

  /// 是否禁用滑动
  final bool? disabled;

  /// 默认打开右侧
  final bool? openedRight;

  /// 默认打开左侧
  final bool? openedLeft;

  /// 右侧滑动操作项
  final List<TDSwipeOption>? right;

  /// 右侧滑动操作项组件，优先级高于right
  final Widget? rightWidget;

  /// 右侧滑动操作项二次确认
  final List<TDSwipeOption>? rightConfirm;

  /// 右侧滑动操作项二次确认组件，优先级高于rightConfirm
  final Widget? rightConfirmWidget;

  /// 左侧滑动操作项
  final List<TDSwipeOption>? left;

  /// 左侧滑动操作项组件，优先级高于left
  final Widget? leftWidget;

  /// 左侧滑动操作项二次确认
  final List<TDSwipeOption>? leftConfirm;

  /// 左侧滑动操作项二次确认组件，优先级高于leftConfirm
  final Widget? leftConfirmWidget;

  /// 滑动展开事件
  final Function(SwipeDirection direction, bool open)? onChange;

  /// [SlidableController] 自定义控制滑动窗口
  final SlidableController? controller;

  /// 同一组中只有一个[Slidable]打开
  final Object? groupTag;

  @override
  _TDSwipeCellState createState() => _TDSwipeCellState();
}

class _TDSwipeCellState extends State<TDSwipeCell> {
  @override
  Widget build(BuildContext context) {
    // final cells = widget.cells ?? (widget.cell == null ? [] : [widget.cell!]);
    return Container();
  }
}

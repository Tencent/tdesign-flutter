import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import './td_swipe_cell.dart';

/// 滑动单元格自动关闭组件，需要[TDSwipeCell]组件配置相同的[TDSwipeCell.groupTag]
class TDSwipeAutoClose extends StatelessWidget {
  const TDSwipeAutoClose({
    Key? key,
    this.closeWhenOpened = true,
    this.closeWhenTapped = true,
    required this.child,
  }) : super(key: key);

  /// 打开[TDSwipeCell]前是否自动关闭其它
  final bool? closeWhenOpened;

  /// 点击[TDSwipeAutoClose]组件时，关闭全部[TDSwipeCell]
  final bool? closeWhenTapped;

  /// 其后代必须有[TDSwipeCell]
  final Widget child;

  @override
  Widget build(context) {
    return SlidableAutoCloseBehavior(
      closeWhenOpened: closeWhenOpened ?? true,
      closeWhenTapped: closeWhenTapped ?? true,
      child: child,
    );
  }
}

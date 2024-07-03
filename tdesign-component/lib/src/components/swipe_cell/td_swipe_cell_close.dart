import 'package:flutter/material.dart';
import './td_swipe_cell.dart';

/// 滑动单元格自动关闭组件，需要[TDSwipeCell]组件配置相同的[TDSwipeCell.groupTag]
class TDSwipeCellClose extends StatelessWidget {
  const TDSwipeCellClose({
    Key? key,
    this.closeWhenOpened = true,
    this.closeWhenTapped = true,
    required this.child,
  }) : super(key: key);

  /// 当同一组（[TDSwipeCell.groupTag]）中的一个[TDSwipeCell]打开时，是否应该关闭组中的所有其他[TDSwipeCell]
  final bool? closeWhenOpened;

  /// 当同一组（[TDSwipeCell.groupTag]）中的一个[TDSwipeCell]被点击时，是否应该关闭组中的所有[TDSwipeCell]
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

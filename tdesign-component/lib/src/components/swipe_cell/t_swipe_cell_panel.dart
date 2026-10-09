import 'package:flutter/material.dart';

import 't_swipe_cell_action.dart';

/// 滑动单元格操作面板。
class TSwipeCellPanel {
  TSwipeCellPanel({required this.children})
    : assert(children.isNotEmpty, 'children must not be empty.');

  /// 操作项列表。面板宽度由所有操作项的实际布局宽度自动确定。
  /// 列表必须非空。
  final List<TSwipeCellAction> children;

  /// 构建操作项的横向布局，宽度由 [children] 的实际布局宽度决定。
  ///
  /// 操作项沿交叉轴拉伸；返回的布局由调用方放入滑动单元格。
  /// [context] 调用方的构建上下文；当前布局不读取其中的主题或尺寸。
  ///
  /// ## 返回值
  /// 由 children 横向排列、沿交叉轴拉伸的操作面板布局。
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

import 'package:flutter/material.dart';

import 't_swipe_cell_action.dart';

/// 滑动单元格操作面板。
class TSwipeCellPanel {
  TSwipeCellPanel({required this.children})
    : assert(children.isNotEmpty, 'children must not be empty.');

  /// 操作项列表。面板宽度由所有操作项的实际布局宽度自动确定。
  final List<TSwipeCellAction> children;

  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

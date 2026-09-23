import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'SwipeCell')
class SwipeCellSwiperRightLeftCellExample extends StatelessWidget {
  const SwipeCellSwiperRightLeftCellExample({super.key});

  Widget _buildSwiperRightLeftCell(BuildContext context) {
    return TSwipeCell(
      start: TSwipeCellPanel(
        children: [_action(context, '选择', context.tTheme.brandNormalColor)],
      ),
      end: TSwipeCellPanel(
        children: [_action(context, '删除', context.tTheme.errorNormalColor)],
      ),
      child: const TCell(title: Text('左右滑操作'), note: Text('辅助信息')),
    );
  }

  TSwipeCellAction _action(
    BuildContext context,
    String label,
    Color? color, {
    IconData? icon,
  }) {
    return TSwipeCellAction(backgroundColor: color, icon: icon, label: label);
  }

  @override
  Widget build(BuildContext context) {
    return _buildSwiperRightLeftCell(context);
  }
}

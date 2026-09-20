import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'SwipeCell')
class SwipeCellSwiperRightCellExample extends StatelessWidget {
  const SwipeCellSwiperRightCellExample({super.key});

  Widget _buildSwiperRightCell(BuildContext context) {
    return TSwipeCell(
      start: TSwipeCellPanel(
        children: [_action(context, '选择', context.tTheme.brandNormalColor)],
      ),
      child: const TCell(title: Text('右滑单操作'), note: Text('辅助信息')),
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
    return _buildSwiperRightCell(context);
  }
}

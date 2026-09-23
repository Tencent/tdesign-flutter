import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

@ExampleCode(group: 'SwipeCell')
class SwipeCellSwiperIconCellExample extends StatelessWidget {
  const SwipeCellSwiperIconCellExample({super.key});

  Widget _buildSwiperIconCell(BuildContext context) {
    return Column(
      children: [
        TSwipeCell(
          end: TSwipeCellPanel(
            children: [
              _action(
                context,
                '编辑',
                context.tTheme.warningNormalColor,
                icon: TIcons.edit,
              ),
              _action(
                context,
                '删除',
                context.tTheme.errorNormalColor,
                icon: TIcons.delete,
              ),
            ],
          ),
          child: const TCell(title: Text('左滑-带图标文本双操作'), note: Text('辅助信息')),
        ),
        const SizedBox(height: 16),
        TSwipeCell(
          end: TSwipeCellPanel(
            children: [
              TSwipeCellAction(
                backgroundColor: context.tTheme.warningNormalColor,
                icon: TIcons.edit,
              ),
              TSwipeCellAction(
                backgroundColor: context.tTheme.errorNormalColor,
                icon: TIcons.delete,
              ),
            ],
          ),
          child: const TCell(title: Text('左滑-仅带图标双操作'), note: Text('辅助信息')),
        ),
      ],
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
    return _buildSwiperIconCell(context);
  }
}

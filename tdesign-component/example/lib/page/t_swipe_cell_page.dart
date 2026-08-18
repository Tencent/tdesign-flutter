import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TSwipeCellPage extends StatelessWidget {
  const TSwipeCellPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(context),
      exampleCodeGroup: 'SwipeCell',
      desc: '用于承载列表中的更多操作，通过左右滑动来展示，按钮宽度根据内容自适应、高度根据列表高度而变化。',
      backgroundColor: context.tTheme.bgColorPage,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '左滑操作', builder: _buildSwiperCell),
            ExampleItem(desc: '右滑操作', builder: _buildSwiperRightCell),
            ExampleItem(desc: '左右滑操作', builder: _buildSwiperRightLeftCell),
            ExampleItem(desc: '带图标的滑动操作', builder: _buildSwiperIconCell),
          ],
        ),
      ],
      test: const [],
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

  @ExampleCode(group: 'SwipeCell')
  Widget _buildSwiperCell(BuildContext context) {
    return Column(
      children: [
        TSwipeCell(
          end: TSwipeCellPanel(
            children: [_action(context, '删除', context.tTheme.errorNormalColor)],
          ),
          child: const TCell(title: Text('左滑单操作'), note: Text('辅助信息')),
        ),
        const SizedBox(height: 16),
        TSwipeCell(
          end: TSwipeCellPanel(
            children: [_action(context, '删除', context.tTheme.errorNormalColor)],
          ),
          child: const TCell(
            title: Text('左滑大列表'),
            note: Text('辅助信息'),
            subtitle: Text('一段很长很长的内容文字'),
            image: CircleAvatar(
              backgroundImage: AssetImage('assets/img/t_avatar_1.png'),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TSwipeCell(
          end: TSwipeCellPanel(
            children: [
              _action(context, '编辑', context.tTheme.warningNormalColor),
              _action(context, '删除', context.tTheme.errorNormalColor),
            ],
          ),
          child: const TCell(title: Text('左滑双操作'), note: Text('辅助信息')),
        ),
        const SizedBox(height: 16),
        TSwipeCell(
          end: TSwipeCellPanel(
            children: [
              _action(context, '收藏', context.tTheme.brandNormalColor),
              _action(context, '编辑', context.tTheme.warningNormalColor),
              _action(context, '删除', context.tTheme.errorNormalColor),
            ],
          ),
          child: const TCell(title: Text('左滑多操作'), note: Text('辅助信息')),
        ),
      ],
    );
  }

  @ExampleCode(group: 'SwipeCell')
  Widget _buildSwiperRightCell(BuildContext context) {
    return TSwipeCell(
      start: TSwipeCellPanel(
        children: [_action(context, '选择', context.tTheme.brandNormalColor)],
      ),
      child: const TCell(title: Text('右滑单操作'), note: Text('辅助信息')),
    );
  }

  @ExampleCode(group: 'SwipeCell')
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

  @ExampleCode(group: 'SwipeCell')
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
}

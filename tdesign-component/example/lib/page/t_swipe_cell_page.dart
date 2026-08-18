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
      desc: '用于承载列表中的更多操作，通过左右滑动来展示，按钮的宽度固定、高度根据列表高度而变化。',
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '左滑单操作', builder: _buildSwiperCell),
            ExampleItem(desc: '右滑单操作', builder: _buildSwiperRightCell),
            ExampleItem(desc: '左右滑操作', builder: _buildSwiperRightLeftCell),
            ExampleItem(desc: '带图标的滑动操作', builder: _buildSwiperIconCell),
          ],
        ),
      ],
      test: const [],
    );
  }

  @ExampleCode(group: 'SwipeCell')
  Widget _buildSwiperCell(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        // 左滑单操作：删除
        Theme(
          data: Theme.of(context).mergeExtension(
            const TSwipeCellThemeData(),
          ),
          child: TSwipeCell(
            end: TSwipeCellPanel(
              extentRatio: 70 / screenWidth,
              children: [
                TSwipeCellAction(
                  backgroundColor: context.tTheme.errorNormalColor,
                  label: '删除',
                ),
              ],
            ),
            child: const TCell(title: Text('左滑单操作'), note: Text('辅助信息')),
          ),
        ),
        const SizedBox(height: 16),
        // 左滑大列表：删除（带头像与长描述）
        Theme(
          data: Theme.of(context).mergeExtension(
            const TSwipeCellThemeData(),
          ),
          child: TSwipeCell(
            end: TSwipeCellPanel(
              extentRatio: 70 / screenWidth,
              children: [
                TSwipeCellAction(
                  backgroundColor: context.tTheme.errorNormalColor,
                  label: '删除',
                ),
              ],
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
        ),
        const SizedBox(height: 16),
        // 左滑双操作：编辑 + 删除
        Theme(
          data: Theme.of(context).mergeExtension(
            const TSwipeCellThemeData(),
          ),
          child: TSwipeCell(
            end: TSwipeCellPanel(
              extentRatio: 120 / screenWidth,
              children: [
                TSwipeCellAction(
                  backgroundColor: context.tTheme.warningNormalColor,
                  label: '编辑',
                ),
                TSwipeCellAction(
                  backgroundColor: context.tTheme.errorNormalColor,
                  label: '删除',
                ),
              ],
            ),
            child: const TCell(title: Text('左滑双操作'), note: Text('辅助信息')),
          ),
        ),
        const SizedBox(height: 16),
        // 左滑多操作：收藏 + 编辑 + 删除
        Theme(
          data: Theme.of(context).mergeExtension(
            const TSwipeCellThemeData(),
          ),
          child: TSwipeCell(
            end: TSwipeCellPanel(
              extentRatio: 180 / screenWidth,
              children: [
                TSwipeCellAction(
                  backgroundColor: context.tTheme.brandNormalColor,
                  label: '收藏',
                ),
                TSwipeCellAction(
                  backgroundColor: context.tTheme.warningNormalColor,
                  label: '编辑',
                ),
                TSwipeCellAction(
                  backgroundColor: context.tTheme.errorNormalColor,
                  label: '删除',
                ),
              ],
            ),
            child: const TCell(title: Text('左滑多操作'), note: Text('辅助信息')),
          ),
        ),
      ],
    );
  }

  @ExampleCode(group: 'SwipeCell')
  Widget _buildSwiperRightCell(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Theme(
      data: Theme.of(context).mergeExtension(
        const TSwipeCellThemeData(),
      ),
      child: TSwipeCell(
        start: TSwipeCellPanel(
          extentRatio: 70 / screenWidth,
          children: [
            TSwipeCellAction(
              backgroundColor: context.tTheme.brandNormalColor,
              label: '选择',
            ),
          ],
        ),
        child: const TCell(title: Text('右滑单操作'), note: Text('辅助信息')),
      ),
    );
  }

  @ExampleCode(group: 'SwipeCell')
  Widget _buildSwiperRightLeftCell(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Theme(
      data: Theme.of(context).mergeExtension(
        const TSwipeCellThemeData(),
      ),
      child: TSwipeCell(
        start: TSwipeCellPanel(
          extentRatio: 70 / screenWidth,
          children: [
            TSwipeCellAction(
              backgroundColor: context.tTheme.brandNormalColor,
              label: '选择',
            ),
          ],
        ),
        end: TSwipeCellPanel(
          extentRatio: 70 / screenWidth,
          children: [
            TSwipeCellAction(
              backgroundColor: context.tTheme.errorNormalColor,
              label: '删除',
            ),
          ],
        ),
        child: const TCell(title: Text('左右滑操作'), note: Text('辅助信息')),
      ),
    );
  }

  @ExampleCode(group: 'SwipeCell')
  Widget _buildSwiperIconCell(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        // 带图标文本双操作
        Theme(
          data: Theme.of(context).mergeExtension(
            const TSwipeCellThemeData(),
          ),
          child: TSwipeCell(
            end: TSwipeCellPanel(
              extentRatio: 160 / screenWidth,
              children: [
                TSwipeCellAction(
                  backgroundColor: context.tTheme.warningNormalColor,
                  icon: TIcons.edit,
                  label: '编辑',
                ),
                TSwipeCellAction(
                  backgroundColor: context.tTheme.errorNormalColor,
                  icon: TIcons.delete,
                  label: '删除',
                ),
              ],
            ),
            child: const TCell(
              title: Text('左滑-带图标文本双操作'),
              note: Text('辅助信息'),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // 仅带图标双操作
        Theme(
          data: Theme.of(context).mergeExtension(
            const TSwipeCellThemeData(),
          ),
          child: TSwipeCell(
            end: TSwipeCellPanel(
              extentRatio: 120 / screenWidth,
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
            child: const TCell(
              title: Text('左滑-仅带图标双操作'),
              note: Text('辅助信息'),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // 大列表-仅带图标双操作（竖排图标，带头像与长描述）
        Theme(
          data: Theme.of(context).mergeExtension(
            const TSwipeCellThemeData(),
          ),
          child: TSwipeCell(
            end: TSwipeCellPanel(
              extentRatio: 120 / screenWidth,
              children: [
                TSwipeCellAction(
                  flex: 60,
                  backgroundColor: context.tTheme.warningNormalColor,
                  direction: Axis.vertical,
                  icon: TIcons.edit,
                  label: '编辑',
                ),
                TSwipeCellAction(
                  flex: 60,
                  backgroundColor: context.tTheme.errorNormalColor,
                  direction: Axis.vertical,
                  icon: TIcons.delete,
                  label: '删除',
                ),
              ],
            ),
            child: const TCell(
              title: Text('左滑大列表-仅带图标双操作'),
              note: Text('辅助信息'),
              subtitle: Text('一段很长很长的内容文字'),
              image: CircleAvatar(
                backgroundImage: AssetImage('assets/img/t_avatar_1.png'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

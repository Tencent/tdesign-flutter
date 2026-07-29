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
          title: 'TCell 单元格操作',
          children: [
            ExampleItem(desc: '列表滑动操作', builder: _buildSwiperCell),
            ExampleItem(desc: '左滑双操作', builder: _buildSwiperMuliCell),
            ExampleItem(desc: '左滑三操作', builder: _buildSwiper3Cell),
            ExampleItem(desc: '右滑单操作', builder: _buildSwiperRightCell),
            ExampleItem(desc: '左右滑操作', builder: _buildSwiperRightLeftCell),
            ExampleItem(desc: '带图标的滑动操作', builder: _buildSwiperIconCell),
            ExampleItem(desc: '带二次确认的操作', builder: _buildSwiperConfirmCell),
          ],
        ),
        ExampleModule(
          title: '自定义内容',
          children: [
            ExampleItem(desc: '自定义卡片操作', builder: _buildCustomContentCell),
          ],
        ),
      ],
      test: const [],
    );
  }

  @ExampleCode(group: 'SwipeCell')
  Widget _buildSwiperCell(BuildContext context) {
    // 屏幕宽度
    var screenWidth = MediaQuery.of(context).size.width;
    final list = [
      {'id': '1', 'title': '项目进度', 'note': '待处理', 'description': '今天完成设计评审'},
      {
        'id': '2',
        'title': '迭代任务',
        'note': '进行中',
        'description': '实现 SwipeCell 的组件重构'
      },
      {'id': '3', 'title': '周报草稿', 'note': '未提交', 'description': '整理本周工作内容'},
    ];
    final cellLength = ValueNotifier<int>(list.length);
    return ValueListenableBuilder(
      valueListenable: cellLength,
      builder: (BuildContext context, value, Widget? child) {
        return TCellGroup(
          cells: list
              .map((e) => TCell(
                  title: Text(e['title'] ?? ''),
                  note: Text(e['note'] ?? ''),
                  subtitle: Text(e['description'] ?? '')))
              .toList(),
          builder: (context, cell, index) {
            return Theme(
              data: Theme.of(context).mergeExtension(
                const TSwipeCellThemeData(),
              ),
              child: TSwipeCell(
                groupTag: 'cell-list',
                closeWhenOpened: true,
                onOpenChanged: (side, open) {
                  print('打开方向：$side');
                  print('打开转态$open');
                },
                end: TSwipeCellPanel(
                  extentRatio: 140 / screenWidth,
                  onDismissed: (context) {
                    list.removeAt(index);
                    cellLength.value = list.length;
                  },
                  children: [
                    TSwipeCellAction(
                      backgroundColor: context.tTheme.warningNormalColor,
                      label: '编辑',
                      onPressed: (_) {},
                    ),
                    TSwipeCellAction(
                      backgroundColor: context.tTheme.errorNormalColor,
                      label: '删除',
                      onPressed: (context) {
                        print('点击action');
                        print(TSwipeCell.of(context));
                        list.removeAt(index);
                        cellLength.value = list.length;
                      },
                    ),
                  ],
                ),
                child: cell,
              ),
            );
          },
        );
      },
    );
  }

  @ExampleCode(group: 'SwipeCell')
  Widget _buildSwiperMuliCell(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Theme(
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
    );
  }

  @ExampleCode(group: 'SwipeCell')
  Widget _buildSwiper3Cell(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Theme(
      data: Theme.of(context).mergeExtension(
        const TSwipeCellThemeData(),
      ),
      child: TSwipeCell(
        end: TSwipeCellPanel(
          extentRatio: 180 / screenWidth,
          children: [
            TSwipeCellAction(
              backgroundColor: context.tTheme.brandNormalColor,
              label: '保存',
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
        child: const TCell(title: Text('左滑三操作'), note: Text('辅助信息')),
      ),
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
          extentRatio: 60 / screenWidth,
          children: [
            TSwipeCellAction(
              backgroundColor: context.tTheme.brandNormalColor,
              label: '选择',
            ),
          ],
        ),
        child: const TCell(title: Text('右滑操作'), note: Text('辅助信息')),
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
          extentRatio: 60 / screenWidth,
          children: [
            TSwipeCellAction(
              backgroundColor: context.tTheme.brandNormalColor,
              label: '选择',
            ),
          ],
        ),
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
        child: const TCell(title: Text('左右滑操作'), note: Text('辅助信息')),
      ),
    );
  }

  @ExampleCode(group: 'SwipeCell')
  Widget _buildSwiperIconCell(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
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
            child: const TCell(title: Text('左滑操作'), note: Text('图标+文字（横向）')),
          ),
        ),
        const SizedBox(height: 16),
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
            child: const TCell(title: Text('左滑操作'), note: Text('仅图标')),
          ),
        ),
        const SizedBox(height: 16),
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
              title: Text('左滑操作'),
              note: Text('图标+文字（纵向）'),
              subtitle: Text('一段很长很长的内容文字'),
            ),
          ),
        )
      ],
    );
  }

  @ExampleCode(group: 'SwipeCell')
  Widget _buildSwiperConfirmCell(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Theme(
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
          confirms: [
            TSwipeCellAction(
              backgroundColor: context.tTheme.errorNormalColor,
              label: '确认删除',
              confirmIndex: const [1],
            ),
          ],
        ),
        child: const TCell(title: Text('左滑操作'), note: Text('二次确认')),
      ),
    );
  }

  @ExampleCode(group: 'SwipeCell')
  Widget _buildCustomContentCell(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return TSwipeCell(
      groupTag: 'custom-content',
      closeWhenOpened: true,
      start: TSwipeCellPanel(
        extentRatio: 76 / screenWidth,
        children: [
          TSwipeCellAction(
            backgroundColor: context.tTheme.brandNormalColor,
            icon: TIcons.check,
            label: '完成',
            onPressed: (_) {},
          ),
        ],
      ),
      end: TSwipeCellPanel(
        extentRatio: 152 / screenWidth,
        children: [
          TSwipeCellAction(
            backgroundColor: context.tTheme.warningNormalColor,
            label: '编辑',
            onPressed: (_) {},
          ),
          TSwipeCellAction(
            backgroundColor: context.tTheme.errorNormalColor,
            label: '删除',
            onPressed: (_) {},
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            CircleAvatar(child: Icon(Icons.description_outlined)),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('自定义任务卡片'),
                  SizedBox(height: 4),
                  Text('这是任意 Widget 内容，不依赖 TCell。'),
                ],
              ),
            ),
            Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

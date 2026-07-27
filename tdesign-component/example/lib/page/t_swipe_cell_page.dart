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
            ExampleItem(desc: '左滑双操作', builder: _buildSwiperMuliCell),
            ExampleItem(desc: '左滑三操作', builder: _buildSwiper3Cell),
            ExampleItem(desc: '右滑单操作', builder: _buildSwiperRightCell),
            ExampleItem(desc: '左右滑操作', builder: _buildSwiperRightLeftCell),
            ExampleItem(desc: '带图标的滑动操作', builder: _buildSwiperIconCell),
            ExampleItem(desc: '带二次确认的操作', builder: _buildSwiperConfirmCell),
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
    var list = [
      {'id': '1', 'title': '左滑单操作', 'note': '辅助信息', 'description': ''},
      {
        'id': '2',
        'title': '左滑单操作',
        'note': '辅助信息',
        'description': '一段很长很长的内容文字'
      },
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
                onChanged: (direction, open) {
                  print('打开方向：$direction');
                  print('打开转态$open');
                },
                right: TSwipeCellPanel(
                  extentRatio: 60 / screenWidth,
                  onDismissed: (context) {
                    list.removeAt(index);
                    cellLength.value = list.length;
                  },
                  children: [
                    TSwipeCellAction(
                      backgroundColor: context.tTheme.errorNormalColor,
                      label: '删除',
                      onPressed: (context) {
                        print('点击action');
                        print(TSwipeCell.of(context));
                        print(TSwipeCellInherited.of(context)?.controller);
                        list.removeAt(index);
                        cellLength.value = list.length;
                      },
                    ),
                  ],
                ),
                cell: cell,
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
        right: TSwipeCellPanel(
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
        cell: const TCell(title: Text('左滑双操作'), note: Text('辅助信息')),
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
        right: TSwipeCellPanel(
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
        cell: const TCell(title: Text('左滑三操作'), note: Text('辅助信息')),
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
        left: TSwipeCellPanel(
          extentRatio: 60 / screenWidth,
          children: [
            TSwipeCellAction(
              backgroundColor: context.tTheme.brandNormalColor,
              label: '选择',
            ),
          ],
        ),
        cell: const TCell(title: Text('右滑操作'), note: Text('辅助信息')),
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
        left: TSwipeCellPanel(
          extentRatio: 60 / screenWidth,
          children: [
            TSwipeCellAction(
              backgroundColor: context.tTheme.brandNormalColor,
              label: '选择',
            ),
          ],
        ),
        right: TSwipeCellPanel(
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
        cell: const TCell(title: Text('左右滑操作'), note: Text('辅助信息')),
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
            right: TSwipeCellPanel(
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
            cell: const TCell(title: Text('左滑操作'), note: Text('图标+文字（横向）')),
          ),
        ),
        const SizedBox(height: 16),
        Theme(
          data: Theme.of(context).mergeExtension(
            const TSwipeCellThemeData(),
          ),
          child: TSwipeCell(
            right: TSwipeCellPanel(
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
            cell: const TCell(title: Text('左滑操作'), note: Text('仅图标')),
          ),
        ),
        const SizedBox(height: 16),
        Theme(
          data: Theme.of(context).mergeExtension(
            const TSwipeCellThemeData(),
          ),
          child: TSwipeCell(
            right: TSwipeCellPanel(
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
            cell: const TCell(
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
        right: TSwipeCellPanel(
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
        cell: const TCell(title: Text('左滑操作'), note: Text('二次确认')),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/demo.dart';
import '../base/example_widget.dart';

class TSwipeCellPage extends StatelessWidget {
  const TSwipeCellPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(context),
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

  @Demo(group: 'SwipeCell')
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
                  title: e['title'],
                  note: e['note'],
                  description: e['description']))
              .toList(),
          builder: (context, cell, index) {
            return TSwipeCell(
              slidableKey: ValueKey(list[index]['id']),
              groupTag: 'test',
              onChange: (direction, open) {
                print('打开方向：$direction');
                print('打开转态$open');
              },
              right: TSwipeCellPanel(
                extentRatio: 60 / screenWidth,
                // dragDismissible: true,
                onDismissed: (context) {
                  list.removeAt(index);
                  cellLength.value = list.length;
                },
                children: [
                  TSwipeCellAction(
                    backgroundColor: TTheme.of(context).errorNormalColor,
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
            );
          },
        );
      },
    );
  }

  @Demo(group: 'SwipeCell')
  Widget _buildSwiperMuliCell(BuildContext context) {
    // 屏幕宽度
    var screenWidth = MediaQuery.of(context).size.width;
    return TSwipeCell(
      groupTag: 'test',
      right: TSwipeCellPanel(
        extentRatio: 120 / screenWidth,
        children: [
          TSwipeCellAction(
            backgroundColor: TTheme.of(context).warningNormalColor,
            label: '编辑',
          ),
          TSwipeCellAction(
            backgroundColor: TTheme.of(context).errorNormalColor,
            label: '删除',
          ),
        ],
      ),
      cell: const TCell(title: '左滑双操作', note: '辅助信息'),
    );
  }

  @Demo(group: 'SwipeCell')
  Widget _buildSwiper3Cell(BuildContext context) {
    // 屏幕宽度
    var screenWidth = MediaQuery.of(context).size.width;
    return TSwipeCell(
      groupTag: 'test',
      right: TSwipeCellPanel(
        extentRatio: 180 / screenWidth,
        children: [
          TSwipeCellAction(
            backgroundColor: TTheme.of(context).brandNormalColor,
            label: '保存',
          ),
          TSwipeCellAction(
            backgroundColor: TTheme.of(context).warningNormalColor,
            label: '编辑',
          ),
          TSwipeCellAction(
            backgroundColor: TTheme.of(context).errorNormalColor,
            label: '删除',
          ),
        ],
      ),
      cell: const TCell(title: '左滑三操作', note: '辅助信息'),
    );
  }

  @Demo(group: 'SwipeCell')
  Widget _buildSwiperRightCell(BuildContext context) {
    // 屏幕宽度
    var screenWidth = MediaQuery.of(context).size.width;
    return TSwipeCell(
      groupTag: 'test',
      left: TSwipeCellPanel(
        extentRatio: 60 / screenWidth,
        children: [
          TSwipeCellAction(
            backgroundColor: TTheme.of(context).brandNormalColor,
            label: '选择',
          ),
        ],
      ),
      cell: const TCell(title: '右滑操作', note: '辅助信息'),
    );
  }

  @Demo(group: 'SwipeCell')
  Widget _buildSwiperRightLeftCell(BuildContext context) {
    // 屏幕宽度
    var screenWidth = MediaQuery.of(context).size.width;
    return TSwipeCell(
      groupTag: 'test',
      left: TSwipeCellPanel(
        extentRatio: 60 / screenWidth,
        children: [
          TSwipeCellAction(
            backgroundColor: TTheme.of(context).brandNormalColor,
            label: '选择',
          ),
        ],
      ),
      right: TSwipeCellPanel(
        extentRatio: 120 / screenWidth,
        children: [
          TSwipeCellAction(
            backgroundColor: TTheme.of(context).warningNormalColor,
            label: '编辑',
          ),
          TSwipeCellAction(
            backgroundColor: TTheme.of(context).errorNormalColor,
            label: '删除',
          ),
        ],
      ),
      cell: const TCell(title: '左右滑操作', note: '辅助信息'),
    );
  }

  @Demo(group: 'SwipeCell')
  Widget _buildSwiperIconCell(BuildContext context) {
    // 屏幕宽度
    var screenWidth = MediaQuery.of(context).size.width;

    return Column(
      // spacing: 16,
      children: [
        TSwipeCell(
          groupTag: 'test',
          right: TSwipeCellPanel(
            extentRatio: 160 / screenWidth,
            children: [
              TSwipeCellAction(
                backgroundColor: TTheme.of(context).warningNormalColor,
                icon: TIcons.edit,
                label: '编辑',
              ),
              TSwipeCellAction(
                backgroundColor: TTheme.of(context).errorNormalColor,
                icon: TIcons.delete,
                label: '删除',
              ),
            ],
          ),
          cell: const TCell(title: '左滑操作', note: '图标+文字（横向）'),
        ),
        const SizedBox(height: 16),
        TSwipeCell(
          groupTag: 'test',
          right: TSwipeCellPanel(
            extentRatio: 120 / screenWidth,
            children: [
              TSwipeCellAction(
                backgroundColor: TTheme.of(context).warningNormalColor,
                icon: TIcons.edit,
              ),
              TSwipeCellAction(
                backgroundColor: TTheme.of(context).errorNormalColor,
                icon: TIcons.delete,
              ),
            ],
          ),
          cell: const TCell(title: '左滑操作', note: '仅图标'),
        ),
        const SizedBox(height: 16),
        TSwipeCell(
          groupTag: 'test',
          right: TSwipeCellPanel(
            extentRatio: 120 / screenWidth,
            children: [
              TSwipeCellAction(
                flex: 60,
                backgroundColor: TTheme.of(context).warningNormalColor,
                direction: Axis.vertical,
                icon: TIcons.edit,
                label: '编辑',
              ),
              TSwipeCellAction(
                flex: 60,
                backgroundColor: TTheme.of(context).errorNormalColor,
                direction: Axis.vertical,
                icon: TIcons.delete,
                label: '删除',
              ),
            ],
          ),
          cell: const TCell(
              title: '左滑操作', note: '图标+文字（纵向）', description: '一段很长很长的内容文字'),
        )
      ],
    );
  }

  @Demo(group: 'SwipeCell')
  Widget _buildSwiperConfirmCell(BuildContext context) {
    // 屏幕宽度
    var screenWidth = MediaQuery.of(context).size.width;
    return TSwipeCell(
      groupTag: 'test',
      right: TSwipeCellPanel(
        extentRatio: 120 / screenWidth,
        children: [
          TSwipeCellAction(
            backgroundColor: TTheme.of(context).warningNormalColor,
            label: '编辑',
          ),
          TSwipeCellAction(
            backgroundColor: TTheme.of(context).errorNormalColor,
            label: '删除',
          ),
        ],
        confirms: [
          TSwipeCellAction(
            backgroundColor: TTheme.of(context).errorNormalColor,
            label: '确认删除',
            confirmIndex: const [1],
          ),
        ],
      ),
      cell: const TCell(title: '左滑操作', note: '二次确认'),
    );
  }
}

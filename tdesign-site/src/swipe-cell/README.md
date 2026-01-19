---
title: Swipecell 滑动操作
description: 用于承载列表中的更多操作，通过左右滑动来展示，按钮的宽度固定、高度根据列表高度而变化。
spline: base
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

在tdesign_flutter/tdesign_flutter.dart中有所有组件的路径。

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

[td_swipe_cell_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_swipe_cell_page.dart)

### 1 组件类型

左滑单操作
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
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
        return TDCellGroup(
          cells: list
              .map((e) => TDCell(
                  title: e['title'],
                  note: e['note'],
                  description: e['description']))
              .toList(),
          builder: (context, cell, index) {
            return TDSwipeCell(
              slidableKey: ValueKey(list[index]['id']),
              groupTag: 'test',
              onChange: (direction, open) {
                print('打开方向：$direction');
                print('打开转态$open');
              },
              right: TDSwipeCellPanel(
                extentRatio: 60 / screenWidth,
                // dragDismissible: true,
                onDismissed: (context) {
                  list.removeAt(index);
                  cellLength.value = list.length;
                },
                children: [
                  TDSwipeCellAction(
                    backgroundColor: TDTheme.of(context).errorNormalColor,
                    label: '删除',
                    onPressed: (context) {
                      print('点击action');
                      print(TDSwipeCell.of(context));
                      print(TDSwipeCellInherited.of(context)?.controller);
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
  }</pre>

</td-code-block>
                                  

左滑双操作
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwiperMuliCell(BuildContext context) {
    // 屏幕宽度
    var screenWidth = MediaQuery.of(context).size.width;
    return TDSwipeCell(
      groupTag: 'test',
      right: TDSwipeCellPanel(
        extentRatio: 120 / screenWidth,
        children: [
          TDSwipeCellAction(
            backgroundColor: TDTheme.of(context).warningNormalColor,
            label: '编辑',
          ),
          TDSwipeCellAction(
            backgroundColor: TDTheme.of(context).errorNormalColor,
            label: '删除',
          ),
        ],
      ),
      cell: const TDCell(title: '左滑双操作', note: '辅助信息'),
    );
  }</pre>

</td-code-block>
                                  

左滑三操作
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwiper3Cell(BuildContext context) {
    // 屏幕宽度
    var screenWidth = MediaQuery.of(context).size.width;
    return TDSwipeCell(
      groupTag: 'test',
      right: TDSwipeCellPanel(
        extentRatio: 180 / screenWidth,
        children: [
          TDSwipeCellAction(
            backgroundColor: TDTheme.of(context).brandNormalColor,
            label: '保存',
          ),
          TDSwipeCellAction(
            backgroundColor: TDTheme.of(context).warningNormalColor,
            label: '编辑',
          ),
          TDSwipeCellAction(
            backgroundColor: TDTheme.of(context).errorNormalColor,
            label: '删除',
          ),
        ],
      ),
      cell: const TDCell(title: '左滑三操作', note: '辅助信息'),
    );
  }</pre>

</td-code-block>
                                  

右滑单操作
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwiperRightCell(BuildContext context) {
    // 屏幕宽度
    var screenWidth = MediaQuery.of(context).size.width;
    return TDSwipeCell(
      groupTag: 'test',
      left: TDSwipeCellPanel(
        extentRatio: 60 / screenWidth,
        children: [
          TDSwipeCellAction(
            backgroundColor: TDTheme.of(context).brandNormalColor,
            label: '选择',
          ),
        ],
      ),
      cell: const TDCell(title: '右滑操作', note: '辅助信息'),
    );
  }</pre>

</td-code-block>
                                  

左右滑操作
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwiperRightLeftCell(BuildContext context) {
    // 屏幕宽度
    var screenWidth = MediaQuery.of(context).size.width;
    return TDSwipeCell(
      groupTag: 'test',
      left: TDSwipeCellPanel(
        extentRatio: 60 / screenWidth,
        children: [
          TDSwipeCellAction(
            backgroundColor: TDTheme.of(context).brandNormalColor,
            label: '选择',
          ),
        ],
      ),
      right: TDSwipeCellPanel(
        extentRatio: 120 / screenWidth,
        children: [
          TDSwipeCellAction(
            backgroundColor: TDTheme.of(context).warningNormalColor,
            label: '编辑',
          ),
          TDSwipeCellAction(
            backgroundColor: TDTheme.of(context).errorNormalColor,
            label: '删除',
          ),
        ],
      ),
      cell: const TDCell(title: '左右滑操作', note: '辅助信息'),
    );
  }</pre>

</td-code-block>
                                  

带图标的滑动操作
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwiperIconCell(BuildContext context) {
    // 屏幕宽度
    var screenWidth = MediaQuery.of(context).size.width;

    return Column(
      // spacing: 16,
      children: [
        TDSwipeCell(
          groupTag: 'test',
          right: TDSwipeCellPanel(
            extentRatio: 160 / screenWidth,
            children: [
              TDSwipeCellAction(
                backgroundColor: TDTheme.of(context).warningNormalColor,
                icon: TDIcons.edit,
                label: '编辑',
              ),
              TDSwipeCellAction(
                backgroundColor: TDTheme.of(context).errorNormalColor,
                icon: TDIcons.delete,
                label: '删除',
              ),
            ],
          ),
          cell: const TDCell(title: '左滑操作', note: '图标+文字（横向）'),
        ),
        const SizedBox(height: 16),
        TDSwipeCell(
          groupTag: 'test',
          right: TDSwipeCellPanel(
            extentRatio: 120 / screenWidth,
            children: [
              TDSwipeCellAction(
                backgroundColor: TDTheme.of(context).warningNormalColor,
                icon: TDIcons.edit,
              ),
              TDSwipeCellAction(
                backgroundColor: TDTheme.of(context).errorNormalColor,
                icon: TDIcons.delete,
              ),
            ],
          ),
          cell: const TDCell(title: '左滑操作', note: '仅图标'),
        ),
        const SizedBox(height: 16),
        TDSwipeCell(
          groupTag: 'test',
          right: TDSwipeCellPanel(
            extentRatio: 120 / screenWidth,
            children: [
              TDSwipeCellAction(
                flex: 60,
                backgroundColor: TDTheme.of(context).warningNormalColor,
                direction: Axis.vertical,
                icon: TDIcons.edit,
                label: '编辑',
              ),
              TDSwipeCellAction(
                flex: 60,
                backgroundColor: TDTheme.of(context).errorNormalColor,
                direction: Axis.vertical,
                icon: TDIcons.delete,
                label: '删除',
              ),
            ],
          ),
          cell: const TDCell(
              title: '左滑操作', note: '图标+文字（纵向）', description: '一段很长很长的内容文字'),
        )
      ],
    );
  }</pre>

</td-code-block>
                                  

带二次确认的操作
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSwiperConfirmCell(BuildContext context) {
    // 屏幕宽度
    var screenWidth = MediaQuery.of(context).size.width;
    return TDSwipeCell(
      groupTag: 'test',
      right: TDSwipeCellPanel(
        extentRatio: 120 / screenWidth,
        children: [
          TDSwipeCellAction(
            backgroundColor: TDTheme.of(context).warningNormalColor,
            label: '编辑',
          ),
          TDSwipeCellAction(
            backgroundColor: TDTheme.of(context).errorNormalColor,
            label: '删除',
          ),
        ],
        confirms: [
          TDSwipeCellAction(
            backgroundColor: TDTheme.of(context).errorNormalColor,
            label: '确认删除',
            confirmIndex: const [1],
          ),
        ],
      ),
      cell: const TDCell(title: '左滑操作', note: '二次确认'),
    );
  }</pre>

</td-code-block>
                                  


## API
### TDSwipeCell
#### 简介
滑动单元格组件
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| cell | Widget | - | 单元格 [TDCell] |
| closeWhenOpened | bool? | true | 当同一组（[groupTag]）中的一个[TDSwipeCell]打开时，是否关闭组中的所有其他[TDSwipeCell] |
| closeWhenTapped | bool? | true | 当同一组（[groupTag]）中的一个[TDSwipeCell]被点击时，是否应该关闭组中的所有[TDSwipeCell] |
| controller | SlidableController? | - | 自定义控制滑动窗口 |
| direction | Axis? | Axis.horizontal | 可拖动的方向 |
| disabled | bool? | false | 是否禁用滑动 |
| dragStartBehavior | DragStartBehavior? | DragStartBehavior.start | 处理拖动开始行为的方式[GestureDetector.dragStartBehavior] |
| duration | Duration? | const Duration(milliseconds: 200) | 打开关闭动画时长 |
| groupTag | Object? | - | 组，配置后，[closeWhenOpened]、[closeWhenTapped]才起作用 |
| key |  | - |  |
| left | TDSwipeCellPanel? | - | 左侧滑动操作项面板 |
| onChange |  Function(TDSwipeDirection direction, bool open)? | - | 滑动展开事件 |
| opened | List<bool>? | const [false, false] | 默认打开，[left, right] |
| right | TDSwipeCellPanel? | - | 右侧滑动操作项面板 |
| slidableKey | Key? | - | 滑动组件的 Key |


#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| close |  |   required Object? tag,  SlidableController? current, | 根据[groupTag]关闭[TDSwipeCell]     current：保留当前不关闭 |
| of |  |   required BuildContext context, | 获取上下文最近的[controller] |


  
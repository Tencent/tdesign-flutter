---
title: Indexes 索引
description: 用于页面中信息快速检索，可以根据目录中的页码快速找到所需的内容。
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

[td_indexes_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_indexes_page.dart)

### 1 组件类型

基础索引类型

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildSimple(BuildContext context) {
  final renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  final indexList = _list.map((item) => item['index'] as String).toList();
  return TDButton(
    text: '基础用法',
    isBlock: true,
    size: TDButtonSize.large,
    theme: TDButtonTheme.primary,
    type: TDButtonType.outline,
    onTap: () {
      Navigator.of(context).push(
        TDSlidePopupRoute(
          slideTransitionFrom: SlideTransitionFrom.right,
          modalTop: renderBox?.size.height,
          builder: (context) {
            return Container(
              color: Colors.white,
              child: TDIndexes(
                indexList: indexList,
                builderContent: (context, index) {
                  final list = _list.firstWhere((element) => element['index'] == index)['children'] as List<String>;
                  return TDCellGroup(
                    cells: list
                        .map((e) => TDCell(
                              title: e,
                            ))
                        .toList(),
                  );
                },
              ),
            );
          },
        ),
      );
    },
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildSimple(BuildContext context) {
  final renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  final indexList = _list.map((item) => item['index'] as String).toList();
  return TDButton(
    text: '基础用法',
    isBlock: true,
    size: TDButtonSize.large,
    theme: TDButtonTheme.primary,
    type: TDButtonType.outline,
    onTap: () {
      Navigator.of(context).push(
        TDSlidePopupRoute(
          slideTransitionFrom: SlideTransitionFrom.right,
          modalTop: renderBox?.size.height,
          builder: (context) {
            return Container(
              color: Colors.white,
              child: TDIndexes(
                indexList: indexList,
                builderContent: (context, index) {
                  final list = _list.firstWhere((element) => element['index'] == index)['children'] as List<String>;
                  return TDCellGroup(
                    cells: list
                        .map((e) => TDCell(
                              title: e,
                            ))
                        .toList(),
                  );
                },
              ),
            );
          },
        ),
      );
    },
  );
}</pre>

</td-code-block>
                
### 1 组件样式

其他索引类型

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildOther(BuildContext context) {
  final renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  final indexList = _list.map((item) => item['index'] as String).toList();
  return TDButton(
    text: '胶囊索引',
    isBlock: true,
    size: TDButtonSize.large,
    theme: TDButtonTheme.primary,
    type: TDButtonType.outline,
    onTap: () {
      Navigator.of(context).push(
        TDSlidePopupRoute(
          slideTransitionFrom: SlideTransitionFrom.right,
          modalTop: renderBox?.size.height,
          builder: (context) {
            return Container(
              color: Colors.white,
              child: TDIndexes(
                indexList: indexList,
                capsuleTheme: true,
                builderContent: (context, index) {
                  final list = _list.firstWhere((element) => element['index'] == index)['children'] as List<String>;
                  return TDCellGroup(
                    cells: list
                        .map((e) => TDCell(
                              title: e,
                            ))
                        .toList(),
                  );
                },
              ),
            );
          },
        ),
      );
    },
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildOther(BuildContext context) {
  final renderBox = navBarkey.currentContext?.findRenderObject() as RenderBox?;
  final indexList = _list.map((item) => item['index'] as String).toList();
  return TDButton(
    text: '胶囊索引',
    isBlock: true,
    size: TDButtonSize.large,
    theme: TDButtonTheme.primary,
    type: TDButtonType.outline,
    onTap: () {
      Navigator.of(context).push(
        TDSlidePopupRoute(
          slideTransitionFrom: SlideTransitionFrom.right,
          modalTop: renderBox?.size.height,
          builder: (context) {
            return Container(
              color: Colors.white,
              child: TDIndexes(
                indexList: indexList,
                capsuleTheme: true,
                builderContent: (context, index) {
                  final list = _list.firstWhere((element) => element['index'] == index)['children'] as List<String>;
                  return TDCellGroup(
                    cells: list
                        .map((e) => TDCell(
                              title: e,
                            ))
                        .toList(),
                  );
                },
              ),
            );
          },
        ),
      );
    },
  );
}</pre>

</td-code-block>
                


## API
### TDIndexesList
#### 简介
索引
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| indexList | List<String> | - | 索引字符列表。不传默认 A-Z |
| indexListMaxHeight | double | 0.8 | 索引列表最大高度（父容器高度的百分比，默认0.8） |
| activeIndex | ValueNotifier<String> | - | 选中索引 |
| onSelect | void Function(String newIndex, String oldIndex) | - | 点击侧边栏时触发事件 |
| builderIndex | Widget Function(BuildContext context, String index, bool isActive)? | - | 索引文本自定义构建，包括索引激活左侧提示 |

```
```
 ### TDIndexesAnchor
#### 简介
索引锚点
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| sticky | bool | - | 索引是否吸顶 |
| text | String | - | 锚点文本 |
| capsuleTheme | bool | - | 是否为胶囊式样式 |
| builderAnchor | Widget? Function(BuildContext context, String index, bool isPinnedToTop)? | - | 索引锚点构建 |
| activeIndex | ValueNotifier<String> | - | 选中索引 |

```
```
 ### TDIndexes
#### 简介
索引
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| indexList | List<String>? | - | 索引字符列表。不传默认 A-Z |
| indexListMaxHeight | double? | 0.8 | 索引列表最大高度（父容器高度的百分比，默认0.8） |
| sticky | bool? | true | 锚点是否吸顶 |
| stickyOffset | double? | 0 | 锚点吸顶时与顶部的距离 |
| capsuleTheme | bool? | false | 锚点是否为胶囊式样式 |
| reverse | bool? | false | 反方向滚动置顶 |
| scrollController | ScrollController? | - | 滚动控制器 |
| onChange | void Function(String index)? | - | 索引发生变更时触发事件 |
| onSelect | void Function(String index)? | - | 点击侧边栏时触发事件 |
| builderContent | Widget? Function(BuildContext context, String index) | - | 内容自定义构建 |
| builderAnchor | Widget? Function(BuildContext context, String index, bool isPinnedToTop)? | - | 锚点自定义构建 |
| builderIndex | Widget Function(BuildContext context, String index, bool isActive)? | - | 索引文本自定义构建，包括索引激活左侧提示 |


  
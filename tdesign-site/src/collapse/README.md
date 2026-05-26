---
title: Collapse 折叠面板
description: 可以折叠/展开的内容区域。
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

[td_collapse_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_collapse_page.dart)

### 1 Type 组件类型

Basic 基础折叠面板
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildBasicCollapse(BuildContext context) {
    return TCollapse(
      style: TCollapseStyle.block,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _basicData[index].isExpanded = !isExpanded;
        });
      },
      children: _basicData.map((CollapseDataItem item) {
        return TCollapsePanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Text(item.headerValue);
          },
          isExpanded: item.isExpanded,
          body: const Text(randomString),
        );
      }).toList(),
    );
  }</pre>

</td-code-block>
                                  

with Operation Instructions 带操作说明
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCollapseWithOperationText(BuildContext context) {
    return TCollapse(
      style: TCollapseStyle.block,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _blockStyleWithOpText[index].isExpanded = !isExpanded;
        });
      },
      children: _blockStyleWithOpText.map((CollapseDataItem item) {
        return TCollapsePanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Text(item.headerValue);
          },
          expandIconTextBuilder: (BuildContext context, bool isExpanded) {
            return isExpanded ? '收起' : '展开';
          },
          isExpanded: item.isExpanded,
          body: const Text(randomString),
        );
      }).toList(),
    );
  }</pre>

</td-code-block>
                                  

Accordion 手风琴式
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildAccordionCollapse(BuildContext context) {
    return TCollapse.accordion(
      style: TCollapseStyle.block,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _accordionData[index].isExpanded = !isExpanded;
        });
      },
      children: _accordionData.map((CollapseDataItem item) {
        return TCollapsePanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Text(item.headerValue);
          },
          isExpanded: item.isExpanded,
          body: const Text(randomString),
          value: item.expandedValue,
        );
      }).toList(),
    );
  }</pre>

</td-code-block>
                                  
### 1 Style 组件样式

Block Style 通栏样式
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildBlockStyleCollapse(BuildContext context) {
    return TCollapse(
      style: TCollapseStyle.block,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _blockStyleData[index].isExpanded = !isExpanded;
        });
      },
      children: _blockStyleData.map((CollapseDataItem item) {
        return TCollapsePanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Text(item.headerValue);
          },
          isExpanded: item.isExpanded,
          body: const Text(randomString),
        );
      }).toList(),
    );
  }</pre>

</td-code-block>
                                  

Card Style 卡片样式
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCardCollapse(BuildContext context) {
    return TCollapse(
      style: TCollapseStyle.card,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _cardStyleData[index].isExpanded = !isExpanded;
        });
      },
      children: _cardStyleData.map((CollapseDataItem item) {
        return TCollapsePanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Text(item.headerValue);
          },
          isExpanded: item.isExpanded,
          body: const Text(randomString),
        );
      }).toList(),
    );
  }</pre>

</td-code-block>
                                  


## API
### TCollapse
#### 简介
折叠面板列表组件，需配合 [TCollapsePanel] 使用
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| animationDuration | Duration | kThemeAnimationDuration | 折叠面板列表的动画时长 |
| children | List<TCollapsePanel> | - | 折叠面板列表的子组件 |
| elevation | double | 0 | 折叠面板列表的阴影 |
| expansionCallback | ExpansionPanelCallback? | - | 折叠面板列表的回调函数； 回调时，入参为当前点击的折叠面板的索引 index 和是否展开的状态 isExpanded |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| style | TCollapseStyle | TCollapseStyle.block | 折叠面板列表的样式 - [TCollapseStyle.block] 通栏风格 - [TCollapseStyle.card] 卡片风格 |

#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| initialOpenPanelValue | Object? | - | 折叠面板列表的默认展开面板的值； 当使用 [TCollapse.accordion] 时，此值生效 |


#### 工厂构造方法

##### TCollapse.accordion

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | List<TCollapsePanel> | - | 折叠面板列表的子组件 |
| style | TCollapseStyle | TCollapseStyle.block | 折叠面板列表的样式 - [TCollapseStyle.block] 通栏风格 - [TCollapseStyle.card] 卡片风格 |
| expansionCallback | ExpansionPanelCallback? | - | 折叠面板列表的回调函数； 回调时，入参为当前点击的折叠面板的索引 index 和是否展开的状态 isExpanded |
| animationDuration | Duration | kThemeAnimationDuration | 折叠面板列表的动画时长 |
| elevation | double | 0 | 折叠面板列表的阴影 |
| initialOpenPanelValue | Object? | - | 折叠面板列表的默认展开面板的值； 当使用 [TCollapse.accordion] 时，此值生效 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |


### TCollapseStyle
#### 简介
折叠面板的组件样式
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| block | Block 通栏风格 |
| card | Card 卡片风格 |


  
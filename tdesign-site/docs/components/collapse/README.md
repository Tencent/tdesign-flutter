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
      onExpansionChanged: (int index, bool isExpanded) {
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
      onExpansionChanged: (int index, bool isExpanded) {
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
    return TCollapse&lt;String&gt;(
      mode: TCollapseMode.accordion,
      value: _accordionValue,
      onChanged: (value) =&gt; setState(() =&gt; _accordionValue = value),
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
      onExpansionChanged: (int index, bool isExpanded) {
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
      variant: TCollapseVariant.card,
      onExpansionChanged: (int index, bool isExpanded) {
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
折叠面板列表组件，需配合 `TCollapsePanel` 使用

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | List&lt;TCollapsePanel&lt;T&gt;&gt; | - | 折叠面板列表 |
| mode | TCollapseMode | TCollapseMode.multiple | 多面板或手风琴模式 |
| variant | TCollapseVariant? | - | 通栏或卡片样式；未设置时读取组件 Theme |
| onExpansionChanged | ExpansionPanelCallback? | - | 点击面板时回调当前索引和点击前的展开状态 |
| animationDuration | Duration? | - | 动画时长；未设置时读取组件 Theme |
| elevation | double? | - | 阴影；未设置时读取组件 Theme |
| value | T? | - | 手风琴模式下当前展开面板的值 |
| onChanged | ValueChanged&lt;T?&gt;? | - | 手风琴模式下目标值变更回调 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |

### TCollapsePanel

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| headerBuilder | ExpansionPanelHeaderBuilder | - | 标题构建器 |
| body | Widget | - | 面板内容 |
| key | Key? | - | 面板稳定标识 |
| isExpanded | bool | false | multiple 模式下是否展开 |
| disabled | bool | false | 是否禁用交互 |
| placement | TCollapsePlacement | TCollapsePlacement.bottom | 内容向上或向下展开 |
| semanticsLabel | String? | - | 复杂自定义标题的无障碍标签 |
| expandIconTextBuilder | TCollapseIconTextBuilder? | - | 展开图标旁说明文案 |
| value | T? | - | 手风琴模式下的唯一标识 |
| backgroundColor | Color? | - | 面板背景色 |

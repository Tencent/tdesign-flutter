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

[t_collapse_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/t_collapse_page.dart)

### 1 Type 组件类型

Basic 基础折叠面板
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildBasicCollapse(BuildContext context) {
    return TCollapse&lt;String&gt;(
      value: _basicValue,
      onChanged: (value) =&gt; setState(() =&gt; _basicValue = value),
      children: [
        TCollapsePanel&lt;String&gt;(
          value: 'basic',
          headerBuilder: (context, isExpanded) =&gt;
              const Text('折叠面板标题'),
          body: const Text(randomString),
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  

with Operation Instructions 带操作说明
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCollapseWithOperationText(BuildContext context) {
    return TCollapse&lt;String&gt;(
      value: _operationValue,
      onChanged: (value) =&gt; setState(() =&gt; _operationValue = value),
      children: [
        TCollapsePanel&lt;String&gt;(
          value: 'operation',
          headerBuilder: (context, isExpanded) =&gt;
              const Text('折叠面板标题'),
          trailingBuilder: (context, isExpanded) =&gt;
              Text(isExpanded ? '收起' : '展开'),
          body: const Text(randomString),
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  

Accordion 手风琴式
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildAccordionCollapse(BuildContext context) {
    final values = List.generate(3, (index) =&gt; '$index');
    return TCollapse&lt;String&gt;(
      mode: TCollapseMode.accordion,
      value: _accordionValue,
      onChanged: (value) =&gt; setState(() =&gt; _accordionValue = value),
      children: values.map((panelValue) {
        return TCollapsePanel&lt;String&gt;(
          value: panelValue,
          headerBuilder: (context, isExpanded) =&gt;
              const Text('折叠面板标题'),
          body: const Text(randomString),
        );
      }).toList(),
    );
  }</pre>

</td-code-block>
                                  
### 2 Style 组件样式

Card Style 卡片样式
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCardCollapse(BuildContext context) {
    return TCollapse&lt;String&gt;(
      variant: TCollapseVariant.card,
      value: _cardValue,
      onChanged: (value) =&gt; setState(() =&gt; _cardValue = value),
      children: List.generate(3, (index) {
        return TCollapsePanel&lt;String&gt;(
          value: 'card-$index',
          headerBuilder: (context, isExpanded) =&gt;
              const Text('折叠面板标题'),
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
| animationDuration | Duration? | - | 动画时长；未设置时读取组件 Theme |
| elevation | double? | - | 阴影；未设置时读取组件 Theme |
| value | List&lt;T&gt; | - | 所有模式的唯一展开状态源；accordion 模式最多一项 |
| onChanged | ValueChanged&lt;List&lt;T&gt;&gt;? | - | 返回变更后的完整值列表；为 null 时整组禁用 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |

### TCollapsePanel

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| headerBuilder | ExpansionPanelHeaderBuilder | - | 标题构建器 |
| body | Widget | - | 面板内容 |
| value | T | - | 面板唯一标识，用于匹配 `TCollapse.value` |
| bodyHeight | double? | - | 展开内容区域的固定高度 |
| key | Key? | - | 面板稳定标识 |
| disabled | bool | false | 是否禁用交互 |
| placement | TCollapsePlacement | TCollapsePlacement.bottom | 内容向上或向下展开 |
| semanticsLabel | String? | - | 复杂自定义标题的无障碍标签 |
| leadingBuilder | TCollapsePanelBuilder? | - | 标题左侧内容构建器 |
| trailingBuilder | TCollapsePanelBuilder? | - | 标题右侧、展开图标前的内容构建器 |
| expandIconBuilder | TCollapsePanelBuilder? | 默认箭头 | 省略时使用默认箭头；显式 null 隐藏；builder 自定义 |
| backgroundColor | Color? | - | 面板背景色 |

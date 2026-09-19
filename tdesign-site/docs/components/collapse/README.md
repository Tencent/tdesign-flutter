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

以下示例代码直接来自 Example App 的 `@ExampleCode(group: "collapse")` 生成资产，Web 文档不维护代码副本。

{{ flutter-example-group collapse }}

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

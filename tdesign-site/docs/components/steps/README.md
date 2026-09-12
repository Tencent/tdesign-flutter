---
title: Steps 步骤条
description: 用于任务步骤展示或任务进度展示。
spline: navigation
isComponent: true
---

## 引入

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

完整示例见 [t_steps_page.dart](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/example/lib/page/t_steps_page.dart)。

### 基础步骤条

`direction` 控制水平或垂直布局，默认使用水平布局。

<td-code-block panel="Dart">

  <pre slot="Dart" lang="dart">
const TSteps.progress(
  value: 1,
  steps: [
    TStepsItemData(title: '已完成', content: '辅助信息'),
    TStepsItemData(title: '进行中', content: '辅助信息'),
    TStepsItemData(title: '未完成', content: '辅助信息'),
  ],
)</pre>

</td-code-block>

<td-code-block panel="Dart">

  <pre slot="Dart" lang="dart">
const TSteps.progress(
  value: 1,
  direction: TStepsDirection.vertical,
  steps: [
    TStepsItemData(title: '已完成', content: '辅助信息'),
    TStepsItemData(title: '进行中', content: '辅助信息'),
    TStepsItemData(title: '未完成', content: '辅助信息'),
  ],
)</pre>

</td-code-block>

### 图标与点状步骤条

通过 `icon` 自定义步骤图标；`indicator: TStepsIndicator.dot` 显示点状步骤条。

<td-code-block panel="Dart">

  <pre slot="Dart" lang="dart">
const TSteps.progress(
  value: 1,
  steps: [
    TStepsItemData(title: '已完成', icon: TIcons.cart),
    TStepsItemData(title: '进行中', icon: TIcons.cart),
    TStepsItemData(title: '未完成', icon: TIcons.cart),
  ],
)</pre>

</td-code-block>

<td-code-block panel="Dart">

  <pre slot="Dart" lang="dart">
const TSteps.progress(
  value: 1,
  indicator: TStepsIndicator.dot,
  steps: [
    TStepsItemData(title: '已完成'),
    TStepsItemData(title: '进行中'),
    TStepsItemData(title: '未完成'),
  ],
)</pre>

</td-code-block>

### 错误状态

`status` 描述当前 `value` 对应步骤的状态。

<td-code-block panel="Dart">

  <pre slot="Dart" lang="dart">
const TSteps.progress(
  value: 1,
  status: TStepsStatus.error,
  steps: [
    TStepsItemData(title: '已完成'),
    TStepsItemData(title: '错误', errorIcon: TIcons.close_circle),
    TStepsItemData(title: '未完成'),
  ],
)</pre>

</td-code-block>

### 受控选择

`TSteps.selectable` 是垂直受控选择组件。调用方持有 `value`，并在
`onChange` 中更新它。它固定使用点状指示器和右侧箭头，已完成节点实心，
当前节点空心。

<td-code-block panel="Dart">

  <pre slot="Dart" lang="dart">
int _selectedStep = 2;

Widget build(BuildContext context) {
  return TSteps.selectable(
    value: _selectedStep,
    steps: const [
      TStepsItemData(title: '已完成步骤'),
      TStepsItemData(title: '已完成步骤'),
      TStepsItemData(title: '当前步骤'),
    ],
    onChange: (index) {
      setState(() => _selectedStep = index);
    },
  );
}</pre>

</td-code-block>

### 自定义标题与内容

`customTitle` 和 `customContent` 分别优先于 `title` 和 `content`。

<td-code-block panel="Dart">

  <pre slot="Dart" lang="dart">
const TSteps.progress(
  value: 1,
  direction: TStepsDirection.vertical,
  steps: [
    TStepsItemData(title: '已完成', content: '辅助信息'),
    TStepsItemData(
      customTitle: Text('自定义标题'),
      customContent: Padding(
        padding: EdgeInsets.only(top: 4),
        child: Text('自定义内容'),
      ),
    ),
  ],
)</pre>

</td-code-block>

### 纯展示步骤条

`TSteps.display` 的节点和连线始终使用完成态品牌色，不接收 `value`、
`status` 或 `onChange`。

<td-code-block panel="Dart">

  <pre slot="Dart" lang="dart">
const TSteps.display(
  direction: TStepsDirection.vertical,
  steps: [
    TStepsItemData(title: '步骤展示', content: '可自定义此处内容'),
    TStepsItemData(title: '步骤展示', content: '可自定义此处内容'),
    TStepsItemData(title: '步骤展示', content: '可自定义此处内容'),
  ],
)</pre>

</td-code-block>

## API

### TSteps.progress

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| steps | `List<TStepsItemData>` | - | 步骤数据，必填 |
| value | `int` | `0` | 当前激活索引；越界值仅在渲染时收敛到有效范围 |
| direction | `TStepsDirection` | `horizontal` | 水平或垂直方向 |
| status | `TStepsStatus` | `process` | 当前步骤的进行中或错误状态 |
| indicator | `TStepsIndicator` | `standard` | 标准或点状指示器 |
| onChange | `ValueChanged&lt;int&gt;?` | - | 选择步骤时触发；为空时只读，非空时不改变指示器视觉 |

### TSteps.selectable

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| steps | `List<TStepsItemData>` | - | 步骤数据，必填 |
| value | `int` | - | 当前选中索引，必填 |
| onChange | `ValueChanged&lt;int&gt;` | - | 选择步骤时触发，必填 |

### TSteps.display

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| steps | `List<TStepsItemData>` | - | 步骤数据，必填 |
| direction | `TStepsDirection` | `vertical` | 水平或垂直方向 |

### TStepsItemData

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| title | `String?` | - | 标题 |
| content | `String?` | - | 辅助内容 |
| icon | `IconData?` | - | 自定义步骤图标 |
| errorIcon | `IconData?` | - | 当前步骤处于错误状态时使用的图标 |
| customTitle | `Widget?` | - | 自定义标题，优先于 `title` |
| customContent | `Widget?` | - | 自定义内容，优先于 `content` |

`title`、`customTitle`、`content`、`customContent` 至少提供一个。

### 枚举

| 枚举 | 可选值 |
| --- | --- |
| `TStepsDirection` | `horizontal`、`vertical` |
| `TStepsStatus` | `process`、`error` |
| `TStepsIndicator` | `standard`、`dot` |

## Breaking Change 迁移

| 旧 API | 新 API |
| --- | --- |
| `activeIndex` | `value` |
| `TStepsStatus.success` | `TStepsStatus.process` |
| `successIcon` | `icon` |
| `TSteps(...)` | 进度用 `TSteps.progress(...)`，垂直选择用 `TSteps.selectable(...)`，纯展示用 `TSteps.display(...)` |
| `simple: true` | `TSteps.progress(indicator: TStepsIndicator.dot)` |
| `readOnly` | 使用 `TSteps.progress` 并省略 `onChange` |
| `verticalSelect: true` | `TSteps.selectable(...)` |
| `TStepsVariant.defaultTheme` / `TStepsVariant.dot` | `TStepsIndicator.standard` / `TStepsIndicator.dot` |
| `TStepsVariant.display` | `TSteps.display(...)` |
| `TStepsThemeData` 中的业务开关 | 改用对应的命名构造 |

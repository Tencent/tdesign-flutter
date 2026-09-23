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

{{ flutter-example-group steps }}

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

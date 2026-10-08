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

## 主题配置

步骤状态与内容通过构造参数和 `TStepsItemData` 配置；颜色、字号与连线默认读取 [TThemeData](/flutter/components/theme?tab=api#tthemedata) 的全局 Token，没有独立的 Steps Theme 类。

{{ flutter-api steps }}

## Breaking Change 迁移

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| `activeIndex` | - | - | 迁移为 `value` | - |
| `TStepsStatus.success` | - | - | 迁移为 `TStepsStatus.process` | - |
| `successIcon` | - | - | 迁移为 `icon` | - |
| `TSteps(...)` | - | - | 迁移为 进度用 `TSteps.progress(...)`，垂直选择用 `TSteps.selectable(...)`，纯展示用 `TSteps.display(...)` | - |
| `simple: true` | - | - | 迁移为 `TSteps.progress(indicator: TStepsIndicator.dot)` | - |
| `readOnly` | - | - | 迁移为 使用 `TSteps.progress` 并省略 `onChange` | - |
| `verticalSelect: true` | - | - | 迁移为 `TSteps.selectable(...)` | - |
| `TStepsVariant.defaultTheme` / `TStepsVariant.dot` | - | - | 迁移为 `TStepsIndicator.standard` / `TStepsIndicator.dot` | - |
| `TStepsVariant.display` | - | - | 迁移为 `TSteps.display(...)` | - |
| `TStepsThemeData` 中的业务开关 | - | - | 迁移为 改用对应的命名构造 | - |

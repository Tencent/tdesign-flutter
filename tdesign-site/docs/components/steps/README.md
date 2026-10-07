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

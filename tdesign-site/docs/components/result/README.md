---
title: Result 结果
description: 反馈结果状态。
spline: base
isComponent: true
---

## 引入

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

以下示例代码直接来自 Example App 的 `@ExampleCode(group: "result")` 生成资产，Web 文档不维护代码副本。

{{ flutter-example-group result }}

## API

### TResult

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| description | String? | - | 描述文本；为空时不占布局空间 |
| icon | Widget? | - | 自定义图标；传入后替换默认状态图标 |
| key | Key? | - | 组件标识 |
| status | TResultStatus | TResultStatus.info | 当前结果状态，决定默认图标、颜色和无障碍语义 |
| title | String | '' | 标题文本；为空时不占布局空间 |

### TResultStatus

| 名称 | 说明 |
| --- | --- |
| info | 默认信息状态 |
| success | 成功结果状态 |
| warning | 警告结果状态 |
| error | 错误结果状态 |

---
title: Empty 空状态
description: 用于空状态时的占位提示。
spline: base
isComponent: true
---

## 引入

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

以下示例代码直接来自 Example App 的 `@ExampleCode(group: "empty")` 生成资产，Web 文档不维护代码副本。

{{ flutter-example-group empty }}

## API

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| icon | IconData? | `TIcons.info_circle_filled` | 默认图标；`image` 非空时不显示 |
| image | Widget? | - | 自定义图片或插画；优先于 `icon` |
| emptyText | String? | - | 描述文字 |
| operation | Widget? | - | 描述下方的操作内容 |
| key | Key? | - | 组件标识 |

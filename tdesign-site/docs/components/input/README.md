---
title: Input 输入框
description: 用于单行文本信息输入。
spline: base
isComponent: true
---

## 引入

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

以下示例代码直接来自 Example App 的 `@ExampleCode(group: "input")` 生成资产，Web 文档不维护代码副本。

{{ flutter-example-group input }}

## 迁移说明

- 原 `label` 迁移到 `TFormItem.label`。
- 原 `showClearButton` 迁移到 `clearButtonMode`。
- 不再透传 Material `InputDecoration`；提示词、前后置内容、状态和外层视觉分别使用 `hintText`、`prefix`、`suffix`、`status` 与 `TInputThemeData`。

完整 API 以 `TInput` dartdoc 和 Example API 面板为准。

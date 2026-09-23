---
title: Textarea 多行文本框
description: 用于多行文本信息输入。
spline: base
isComponent: true
---

## 引入

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

{{ flutter-example-group textarea }}

## 迁移说明

Textarea 不再透传 Material `InputDecoration`。外置表单标签迁移到 `TFormItem`；独立输入框内部标题继续使用 `TTextarea.label`。

完整 API 以 `TTextarea` dartdoc 和 Example API 面板为准。

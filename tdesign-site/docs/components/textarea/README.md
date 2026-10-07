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

## 主题配置

Textarea 复用 [TInputThemeData](/flutter/components/input?tab=api#tinputthemedata)：容器读取 `contentPadding` 和 `borderColor`；内部编辑器的内边距固定为零、背景透明，其余输入主题配置继续传给 `TInput`。标题和默认状态颜色使用 [TThemeData](/flutter/components/theme?tab=api#tthemedata) 的全局 Token。

{{ flutter-api textarea }}

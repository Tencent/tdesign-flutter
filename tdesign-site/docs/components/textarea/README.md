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

完整场景见 [t_textarea_page.dart](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/example/lib/page/t_textarea_page.dart)。

### 基础与内部标题

```dart
const SizedBox(
  height: 128,
  child: TTextarea(
    label: '标签文字',
    hintText: '请输入文字',
    minLines: 2,
  ),
)
```

`label` 是独立 Textarea 的内部标题。作为表单字段使用时，应改用 `TFormItem.label`，避免重复标签和校验语义。

### 自动增高与字符计数

```dart
const TTextarea(
  label: '标签文字',
  hintText: '设置最大字符个数',
  minLines: 1,
  maxLines: 6,
  maxLength: 200,
  indicator: true,
)
```

- `minLines` 与 `maxLines` 组合表达自动增高范围。
- `indicator` 仅在配置 `maxLength` 或 `maxCharacter` 时显示。
- `maxLength` 使用 Flutter grapheme 语义；`maxCharacter` 使用 ASCII 1、非 ASCII 2 的计数规则。

### 状态与外框

```dart
const TTextarea(
  hintText: '请输入文字',
  bordered: true,
  status: TInputStatus.error,
  maxLength: 100,
  indicator: true,
)
```

`bordered` 控制外边框；背景、圆角、内边距和文字视觉通过 `TInputThemeData` 定制。禁用使用 `enabled: false`，只读使用 `readOnly: true`。

## 迁移说明

Textarea 不再透传 Material `InputDecoration`。外置表单标签迁移到 `TFormItem`；独立输入框内部标题继续使用 `TTextarea.label`。

完整 API 以 `TTextarea` dartdoc 和 Example API 面板为准。

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

完整场景见 [t_input_page.dart](https://github.com/Tencent/tdesign-flutter/blob/develop/tdesign-component/example/lib/page/t_input_page.dart)。

### 基础输入框

表单标签、必填标记和帮助信息由 `TFormItem` 负责，`TInput` 只负责编辑行为和输入框视觉。

```dart
const TFormItem(
  label: '标签文字',
  required: true,
  help: '最大输入10个字符',
  child: TInput(
    borderless: true,
    hintText: '请输入文字',
    maxLength: 10,
  ),
)
```

### 前后置内容与密码

```dart
const TInput(
  hintText: '请输入密码',
  obscureText: true,
  showPasswordToggle: true,
  inputType: TextInputType.visiblePassword,
)

const TInput(
  hintText: '请输入文字',
  prefix: Icon(TIcons.app),
  suffix: Icon(TIcons.info_circle_filled),
)
```

`showPasswordToggle` 仅支持单行输入；初始显隐由 `obscureText` 决定，后续状态由组件内部维护。传入 `suffix` 时不显示内置清除按钮。

### 清除、状态与字符限制

```dart
const TInput(
  initialValue: '已输入内容',
  status: TInputStatus.error,
  clearButtonMode: TInputClearButtonMode.always,
)
```

- `clearButtonMode`：`never`、`always`、`focused`。
- `maxLength`：按 Flutter grapheme cluster 统计用户可见字符。
- `maxCharacter`：ASCII 计 1，非 ASCII 计 2，与 `maxLength` 二选一。
- `enabled: false` 表示禁用；`readOnly: true` 保留选择与复制能力。
- `status` 影响边框、计数器和状态按钮，不改变已输入文字的正文颜色。

### 受控与非受控

```dart
final controller = TextEditingController();

TInput(
  controller: controller,
  onChanged: (value) {},
)
```

`controller` 与 `initialValue` 不能同时传入。未传 controller 时，`initialValue` 只在内部 controller 创建时初始化一次。

## 迁移说明

- 原 `label` 迁移到 `TFormItem.label`。
- 原 `showClearButton` 迁移到 `clearButtonMode`。
- 不再透传 Material `InputDecoration`；提示词、前后置内容、状态和外层视觉分别使用 `hintText`、`prefix`、`suffix`、`status` 与 `TInputThemeData`。

完整 API 以 `TInput` dartdoc 和 Example API 面板为准。

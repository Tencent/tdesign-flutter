---
title: Form 表单
description: 用以收集、校验和提交数据，一般由输入框、选择器等控件组成。
spline: base
isComponent: true
---

## 引入

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

以下示例代码直接来自 Example App 的 `@ExampleCode(group: "form")` 生成资产，Web 文档不维护代码副本。

{{ flutter-example-group form }}

## 组件关系

```text
TForm                 表单生命周期、字段注册和统一操作
  └─ TFormField<T>    受控字段值、必填与 validator
       └─ TFormItem   label、必填标记、help/error 和布局
            └─ 输入或选择组件
```

`TFormField` 和 `TFormItem` 均可独立使用。Flutter 业务状态仍由调用方持有，组件不会复制一份表单 data。

## 校验与提交

```dart
formController.validate();
formController.validate(fields: ['name']);
formController.submit();
formController.clearValidate();
formController.clearValidate(fields: ['name']);
formController.setValidateMessage({'name': '用户名已存在'});
formController.reset();
```

- 默认首次提交前不自动展示校验错误；首次提交失败后按用户交互更新。
- `clearValidate` 只清除校验展示，不表示字段值变化，也不会触发 `TForm.onChanged`。
- `reset` 重置 Flutter 字段交互与校验状态；受控业务值仍由调用方恢复。
- `setValidateMessage` 用于服务端错误，外部错误优先于本地 validator。

## 横向与纵向布局

```dart
Theme(
  data: Theme.of(context).mergeExtension(
    const TFormThemeData(layout: TFormLayout.vertical),
  ),
  child: form,
)
```

`TFormItem` 的布局与视觉默认值由 `TFormThemeData` 控制。`leading` 属于标签区域前置结构，`extra` 是无定位样式的尾部 Widget 插槽；需要垂直居中时使用 `verticalAlignment: TFormItemVerticalAlignment.center`。

## 迁移说明

- 删除旧的模板式 `data`、`items`、`TFormItemType` 和 `TFormValidation` API，字段改由 `TFormField<T>` 组合。
- 删除 `TFormRule` / `TFormField.rules`，必填使用 `required`，其他约束统一写入 Flutter 原生 `validator`。
- 表单项视觉继续由 `TFormItem` 负责，不把 label、help、error 等参数复制到输入组件。

完整示例以以上 Example App 生成代码为准，完整 API 以组件 dartdoc 和 Example API 面板为准。

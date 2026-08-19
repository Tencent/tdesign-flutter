# 实施方案

## 技术方案

- 在 `TFormState` 中维护字段注册、字段校验回调和外部错误映射。
- 使用隐藏的字段 scope 传递 required/error 状态，`TFormItem` 读取状态；`TInput` 不再读取 Form scope。
- 为 `TFormController` 增加按字段操作和外部错误注入 API。
- 将输入清除按钮从 `showClearButton` 布尔配置改为 `TInputClearButtonMode`。
- 删除 `TInput` / `TTextarea` 的 `label`，同步迁移 Example 和测试到 `TFormItem`。
- 用无边框 `TextField` 承载编辑内核，外层由 TDesign `DecoratedBox`、布局和计数/提示区域负责视觉。
- 用组件状态解析统一边框、焦点、禁用、错误、警告和成功色，避免继承 Material `InputDecorationTheme` 的外壳样式。
- 用可组合的输入格式器实现 `maxCharacter`，Textarea 额外负责 indicator 和 min/max 行数。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `tdesign-component/lib/src/components/form` | Form 生命周期、字段状态、表单项边界 |
| 组件 | `tdesign-component/lib/src/components/input`、`textarea` | label 和 clear button API |
| 测试 | `tdesign-component/test/components/form`、`input`、`textarea` | API、校验、回归覆盖 |
| 示例 | `tdesign-component/example/lib/page/t_form_page.dart`、`t_input_page.dart` | 对齐推荐组合方式 |
| 文档 | 公开 API dartdoc、Spec | 记录 breaking change 和用法 |

## API 变化

- Breaking：删除 `TInput.label` 和 `TTextarea.label`。
- Breaking：删除 `TInputThemeData.showClearButton`，使用 `clearButtonMode`。
- 新增：`TInput.clearButtonMode`、`TTextarea.clearButtonMode`。
- 新增：`TFormController.validate({Iterable<String>? fields})`。
- 新增：`TFormController.clearValidate({Iterable<String>? fields})`。
- 新增：`TFormController.setValidateMessage(Map<String, String?> messages)`。
- 新增：`TInput.status`、`TInput.borderless`、`TInput.maxCharacter`。
- 新增：`TTextarea.status`、`TTextarea.bordered`、`TTextarea.maxCharacter`、`TTextarea.indicator`。

## 风险与取舍

- 删除输入 label 会影响直接使用 `TInput(label: ...)` 的调用方，迁移方式为外包 `TFormItem`。
- 受控字段的 reset 仍不能替业务状态自动赋值；reset 只重置 Flutter 校验状态并清除 Form 错误。
- 自绘外层增加了边框、状态、计数和布局维护面，但编辑内核仍是 Flutter 原生控件，焦点、IME、selection、语义树和 formatter 不需要重复实现。
- `maxCharacter` 是小程序兼容语义，不与 Flutter 的 `maxLength` 混用；两个限制同时传入时断言，避免用户无法判断计数口径。

## 验证策略

- 单元测试：Form controller 的字段校验、清除校验和外部错误。
- Widget 测试：独立 TFormItem、TInput clearButtonMode、输入 label 迁移。
- 静态检查：`flutter analyze`。
- 人工验收：Example Form 与 Input 页面检查无重复 label、错误和清除按钮行为。
- 视觉验收：Example 页面逐项对照 MiniProgram API/Demo 矩阵，至少检查边框、焦点、禁用、状态、计数和自适应高度。

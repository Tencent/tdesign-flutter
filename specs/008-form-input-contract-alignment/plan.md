# 实施方案

## 技术方案

- 在 `TFormState` 中维护字段注册、字段校验回调和外部错误映射。
- 使用中立的字段视觉 scope 传递 required/error 状态；`TInput` 只消费字段展示状态与 `TFormItem` 视觉作用域，不依赖 `TForm` 生命周期。
- 为 `TFormController` 增加按字段操作和外部错误注入 API。
- 将输入清除按钮从 `showClearButton` 布尔配置改为 `TInputClearButtonMode`。
- 删除 `TInput` 的 `label`；`TTextarea.label` 收敛为独立多行输入框内部标题，表单标签仍迁移到 `TFormItem`。
- 用无边框 `TextField` 承载编辑内核，外层由 TDesign `DecoratedBox`、布局和计数/提示区域负责视觉。
- 用组件状态解析统一边框、焦点、禁用、错误、警告和成功色，避免继承 Material `InputDecorationTheme` 的外壳样式。
- FormItem 与 Input 的局部 TextStyle 使用字段级 merge，保留未显式覆盖的 token 字号、行高和语义色；横向 FormItem 通过 `start/center` 语义配置对齐，不根据内容结构隐式切换。
- 用可组合的输入格式器实现 `maxCharacter`，Textarea 额外负责内部标题、独立容器、indicator 和 min/max 行数。

## 影响范围

| 范围 | 文件或模块 | 影响 |
| --- | --- | --- |
| 组件 | `tdesign-component/lib/src/components/form` | Form 生命周期、字段状态、表单项边界 |
| 组件 | `tdesign-component/lib/src/components/input`、`textarea` | 标题、clear button 和多行视觉 API |
| 测试 | `tdesign-component/test/components/form`、`input`、`textarea` | API、校验、回归覆盖 |
| 示例 | `tdesign-component/example/lib/page/t_form_page.dart`、`t_input_page.dart` | 对齐推荐组合方式 |
| 文档 | 公开 API dartdoc、Spec | 记录 breaking change 和用法 |

## API 变化

- Breaking：删除 `TInput.label`，表单中的输入标题统一迁移到 `TFormItem.label`。
- Breaking：删除与 `TTextarea` 重复的 `TInput.multiline` 命名构造器；多行场景迁移到 `TTextarea`，底层仍由单一 `TInput` 实现复用 Flutter 编辑能力。
- Breaking：删除 `TFormRule` 与 `TFormField.rules`，字段约束统一迁移到 Flutter 原生 `validator`；必填场景继续使用 `required` / `requiredMessage`。
- 新增：`TTextarea.label`，仅用于独立多行输入框内部标题。
- Breaking：删除 `TInputThemeData.showClearButton`，使用 `clearButtonMode`。
- Breaking：删除 `TInput.decoration`、`TTextarea.decoration` 和 `TInputThemeData.decorationTheme`；提示词样式迁移到 `TInputThemeData.hintStyle`，其他视觉使用对应的 TDesign 专属 API。
- 新增：`TInput.clearButtonMode`、`TTextarea.clearButtonMode`。
- 新增：`TFormController.validate({Iterable<String>? fields})`。
- 新增：`TFormController.clearValidate({Iterable<String>? fields})`。
- 新增：`TFormController.setValidateMessage(Map<String, String?> messages)`。
- 新增：`TFormItem.leading`、`TFormThemeData.leadingGap`、`TFormItem.verticalAlignment` 和 `TFormThemeData.verticalAlignment`；纵向对齐只使用 `start/center` 语义枚举，不暴露 Row 实现类型。
- 新增：`TInput.status`、`TInput.borderless`、`TInput.maxCharacter`。
- 新增：`TTextarea.status`、`TTextarea.bordered`、`TTextarea.maxCharacter`、`TTextarea.indicator`。

## 风险与取舍

- 删除 `TInput.label` 会影响直接使用该参数的调用方，迁移方式为外包 `TFormItem`；Textarea 的内部标题不得替代表单字段标签。
- 删除 Material decoration 入口会影响直接透传 `InputDecoration` 的调用方；hint、前后置内容、背景、边框和内边距分别迁移到 TInput、TFormItem 和 TInputThemeData 的专属属性。
- 受控字段的 reset 仍不能替业务状态自动赋值；reset 只重置 Flutter 校验状态并清除 Form 错误。
- 自绘外层增加了边框、状态、计数和布局维护面，但编辑内核仍是 Flutter 原生控件，焦点、IME、selection、语义树和 formatter 不需要重复实现。
- `maxCharacter` 是小程序兼容语义，不与 Flutter 的 `maxLength` 混用；两个限制同时传入时断言，避免用户无法判断计数口径。

## 验证策略

- 单元测试：Form controller 的字段校验、清除校验和外部错误。
- Widget 测试：覆盖独立 TFormItem、前置内容布局、语义化纵向对齐、clearButtonMode、输入 label 迁移、局部颜色样式保留 token 字体、help/error 语义色以及超长标签与消息行对齐。
- 静态检查：`flutter analyze`。
- 人工验收：Example Form、Input 与 Textarea 页面检查无重复 label、错误和清除按钮行为。
- 视觉验收：Example 页面逐项对照 MiniProgram API/Demo 矩阵，至少检查边框、焦点、禁用、状态、计数和自适应高度。

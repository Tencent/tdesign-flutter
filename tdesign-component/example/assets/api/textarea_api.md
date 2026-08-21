## API
### TTextarea
#### 简介
TDesign 多行文本输入框。
编辑能力复用 `TInput.multiline`；容器、内部标题、提示词和计数器遵循
Textarea 的视觉契约。表单字段标签仍应由 `TFormItem` 提供，`label` 仅用于
独立 Textarea 自身的内部标题。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| autofocus | bool | false | 是否自动聚焦。 |
| bordered | bool | false | 是否显示外边框。 |
| clearButtonMode | TInputClearButtonMode? | - | 清除按钮显示模式；未传时读取 `TInputThemeData.clearButtonMode`。 |
| controller | TextEditingController? | - | 文本控制器。 |
| enabled | bool | true | 是否可交互。 |
| focusNode | FocusNode? | - | 焦点节点。 |
| hintText | String? | - | 占位提示文案。 |
| indicator | bool | false | 是否显示当前字符计数。 |
| initialValue | String? | - | 内部控制器的初始文本，仅初始化一次。 |
| inputAction | TextInputAction? | - | 键盘动作。 |
| inputFormatters | List<TextInputFormatter>? | - | 输入格式化器。 |
| inputType | TextInputType | TextInputType.multiline | 键盘类型。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| label | String? | - | 输入框内部标题。 表单中的字段标签请使用 `TFormItem.label`，避免与表单必填、校验语义重复。 |
| maxCharacter | int? | - | 最大字符数，按 ASCII 字符 1、非 ASCII 字符 2 计数。 |
| maxLength | int? | - | 最大字符数。 |
| maxLines | int? | - | 最大行数；null 表示不限制。 |
| minLines | int? | - | 最小行数；未传时读取 Theme 默认值。 |
| onChanged | ValueChanged<String>? | - | 文本变化通知。 |
| onEditingComplete | VoidCallback? | - | 编辑完成回调。 |
| onSubmitted | ValueChanged<String>? | - | 提交回调。 |
| prefix | Widget? | - | 前缀组件。 |
| readOnly | bool | false | 是否只读。 |
| status | TInputStatus | TInputStatus.normal | 输入框语义状态。 |
| suffix | Widget? | - | 后缀组件。 |
| textAlign | TextAlign | TextAlign.start | 文本对齐方式。 |

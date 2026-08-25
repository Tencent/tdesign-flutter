## API
### TInput
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| autofocus | bool | false | 是否自动聚焦。 |
| borderless | bool | false | 是否隐藏输入框边框。 |
| clearButtonMode | TInputClearButtonMode? | - | 清除按钮显示模式。 |
| controller | TextEditingController? | - | 文本控制器。 |
| cursorColor | Color? | - | 光标颜色。 |
| enabled | bool | true | 是否可交互。 设为 `false` 时表示禁用输入框，禁止编辑、聚焦和选择，并使用禁用态文字颜色。 |
| focusNode | FocusNode? | - | 焦点节点。 |
| hintText | String? | - | 占位提示文案。 |
| indicator | bool | false | 是否显示当前字符计数。 多行场景优先使用 `TTextarea`；未配置长度限制时不会显示。 |
| initialValue | String? | - | 内部控制器的初始文本，仅初始化一次。 |
| inputAction | TextInputAction? | - | 键盘动作。 |
| inputFormatters | List<TextInputFormatter>? | - | 输入格式化器。 |
| inputType | TextInputType | TextInputType.text | 键盘类型。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| maxCharacter | int? | - | 最大字符权重，按 Unicode code point 计算：ASCII code point 计 1， 非 ASCII code point 计 2。 与 `maxLength` 二选一；用于对齐小程序 `maxcharacter`。 |
| maxLength | int? | - | 最大字符数，使用 Flutter grapheme 计数语义。 |
| maxLines | int? | 1 | 最大行数。 |
| minLines | int? | - | 最小行数。 |
| obscureText | bool | false | 是否隐藏输入文本。 |
| onChanged | ValueChanged<String>? | - | 文本变化通知。 |
| onEditingComplete | VoidCallback? | - | 编辑完成回调。 |
| onSubmitted | ValueChanged<String>? | - | 提交回调。 |
| prefix | Widget? | - | 前缀组件。 |
| readOnly | bool | false | 是否只读。 设为 `true` 时禁止修改内容，但保留只读文本的选择和复制能力；文字仍使用正常态颜色。 |
| showPasswordToggle | bool | false | 是否在后置插槽显示内置密码显隐按钮。 初始显隐状态由 `obscureText` 决定，按钮点击后的显隐状态由输入框 自身维护。启用后会使用 TDesign 的浏览图标和 24dp 图标槽，且不会 额外撑高输入框；仅支持单行输入。如果同时传入 `suffix`，自定义后置内容 会紧跟在该按钮之后。 |
| status | TInputStatus | TInputStatus.normal | 输入框语义状态。 状态色用于输入壳层、计数器和错误提示； 已输入文字仍使用正常正文色，除非通过 `style` 或 `TInputThemeData.textStyle` 显式覆盖。 当输入框位于 `TFormField` 中且表单错误需要在输入框内展示时， 表单错误状态优先于这里显式设置的状态。 |
| style | TextStyle? | - | 输入文本样式。 未指定的字段继承 TDesign `fontBodyLarge`；显式颜色可覆盖默认正文色。 |
| suffix | Widget? | - | 后缀组件；传入后不显示内置清除按钮。 |
| textAlign | TextAlign | TextAlign.start | 文本对齐方式。 |

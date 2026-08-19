## API
### TTextarea

#### 简介

`TInput.multiline` 的语义别名，保留 Flutter 文本编辑、焦点和 IME 能力。

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识。 |
| controller | TextEditingController? | - | 文本控制器。 |
| initialValue | String? | - | 内部控制器的初始文本，仅初始化一次。 |
| onChanged | ValueChanged<String>? | - | 文本变化通知。 |
| onSubmitted | ValueChanged<String>? | - | 提交回调。 |
| onEditingComplete | VoidCallback? | - | 编辑完成回调。 |
| enabled | bool | true | 是否可交互。 |
| readOnly | bool | false | 是否只读。 |
| hintText | String? | - | 占位提示文案。 |
| prefix | Widget? | - | 前缀组件。 |
| suffix | Widget? | - | 后缀组件。 |
| clearButtonMode | TInputClearButtonMode? | Theme/never | 清除按钮显示模式：never、always、focused。 |
| status | TInputStatus | normal | 输入状态：normal、success、warning、error。 |
| bordered | bool | false | 是否显示 TDesign 外边框。 |
| maxLines | int? | - | 最大行数；null 表示不限制。 |
| minLines | int? | - | 最小行数；未传时读取 Theme 默认值。 |
| maxLength | int? | - | Flutter grapheme 计数的最大字符数。与 maxCharacter 二选一。 |
| maxCharacter | int? | - | 小程序语义的最大字符数：ASCII 计 1，非 ASCII 计 2。与 maxLength 二选一。 |
| indicator | bool | false | 是否显示当前计数；未配置长度限制时无效。 |
| autofocus | bool | false | 是否自动聚焦。 |
| focusNode | FocusNode? | - | 焦点节点。 |
| inputType | TextInputType | TextInputType.multiline | 键盘类型。 |
| inputAction | TextInputAction? | - | 键盘动作。 |
| textAlign | TextAlign | TextAlign.start | 文本对齐方式。 |
| inputFormatters | List<TextInputFormatter>? | - | 输入格式化器。 |
| decoration | InputDecoration? | - | Material 迁移逃逸口；不覆盖默认 TDesign 外层边框和内边距。 |

`TTextarea` 不提供 `label`；标签、help 和 error 应使用 `TFormItem` 或页面外层结构承载。

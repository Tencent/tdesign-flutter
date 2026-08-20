## API
### TInput

#### 工厂构造方法

##### TInput.multiline

创建多行输入框。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| controller | TextEditingController? | - | 文本控制器。 |
| initialValue | String? | - | 内部控制器的初始文本，仅初始化一次。 |
| onChanged | ValueChanged<String>? | - | 文本变化通知。 |
| onSubmitted | ValueChanged<String>? | - | 提交回调。 |
| onEditingComplete | VoidCallback? | - | 编辑完成回调。 |
| enabled | bool | true | 是否可交互。 设为 `false` 时表示禁用输入框，禁止编辑、聚焦和选择，并使用禁用态文字颜色。 |
| readOnly | bool | false | 是否只读。 设为 `true` 时禁止修改内容，但保留只读文本的选择和复制能力；文字仍使用正常态颜色。 |
| hintText | String? | - | 占位提示文案。 |
| prefix | Widget? | - | 前缀组件。 |
| suffix | Widget? | - | 后缀组件；传入后不显示内置清除按钮。 |
| clearButtonMode | TInputClearButtonMode? | - | 清除按钮显示模式。 |
| status | TInputStatus | TInputStatus.normal | 输入框语义状态。 |
| borderless | bool | false | 是否隐藏输入框边框。 |
| maxLines | int? | - | 最大行数。 |
| minLines | int? | - | 最小行数。 |
| maxLength | int? | - | 最大字符数，使用 Flutter grapheme 计数语义。 |
| maxCharacter | int? | - | 最大字符数，按 ASCII 字符 1、非 ASCII 字符 2 计数。 与 `maxLength` 二选一；用于对齐小程序 `maxcharacter`。 |
| indicator | bool | false | 是否显示当前字符计数。 主要用于 `TInput.multiline` 对齐小程序 Textarea 的 `indicator`。未配置长度限制时不会显示。 |
| autofocus | bool | false | 是否自动聚焦。 |
| focusNode | FocusNode? | - | 焦点节点。 |
| inputType | TextInputType | TextInputType.multiline | 键盘类型。 |
| inputAction | TextInputAction? | - | 键盘动作。 |
| textAlign | TextAlign | TextAlign.start | 文本对齐方式。 |
| inputFormatters | List<TextInputFormatter>? | - | 输入格式化器。 |
| decoration | InputDecoration? | - | Material 输入装饰迁移逃逸口。 该属性可以补充 Flutter 输入内核支持的 hint、label、语义和文本 配置；默认 TDesign 外层边框、内边距和清除按钮仍由本组件负责。 |
| style | TextStyle? | - | 输入文本样式。 未指定的字段继承 TDesign `fontBodyLarge`；显式颜色可覆盖状态默认色。 |
| cursorColor | Color? | - | 光标颜色。 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| autofocus | bool | false | 是否自动聚焦。 |
| borderless | bool | false | 是否隐藏输入框边框。 |
| clearButtonMode | TInputClearButtonMode? | - | 清除按钮显示模式。 |
| controller | TextEditingController? | - | 文本控制器。 |
| cursorColor | Color? | - | 光标颜色。 |
| decoration | InputDecoration? | - | Material 输入装饰迁移逃逸口。 该属性可以补充 Flutter 输入内核支持的 hint、label、语义和文本 配置；默认 TDesign 外层边框、内边距和清除按钮仍由本组件负责。 |
| enabled | bool | true | 是否可交互。 设为 `false` 时表示禁用输入框，禁止编辑、聚焦和选择，并使用禁用态文字颜色。 |
| focusNode | FocusNode? | - | 焦点节点。 |
| hintText | String? | - | 占位提示文案。 |
| indicator | bool | false | 是否显示当前字符计数。 主要用于 `TInput.multiline` 对齐小程序 Textarea 的 `indicator`。未配置长度限制时不会显示。 |
| initialValue | String? | - | 内部控制器的初始文本，仅初始化一次。 |
| inputAction | TextInputAction? | - | 键盘动作。 |
| inputFormatters | List<TextInputFormatter>? | - | 输入格式化器。 |
| inputType | TextInputType | TextInputType.text | 键盘类型。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| maxCharacter | int? | - | 最大字符数，按 ASCII 字符 1、非 ASCII 字符 2 计数。 与 `maxLength` 二选一；用于对齐小程序 `maxcharacter`。 |
| maxLength | int? | - | 最大字符数，使用 Flutter grapheme 计数语义。 |
| maxLines | int? | 1 | 最大行数。 |
| minLines | int? | - | 最小行数。 |
| obscureText | bool | false | 是否隐藏输入文本。 |
| onChanged | ValueChanged<String>? | - | 文本变化通知。 |
| onEditingComplete | VoidCallback? | - | 编辑完成回调。 |
| onSubmitted | ValueChanged<String>? | - | 提交回调。 |
| prefix | Widget? | - | 前缀组件。 |
| readOnly | bool | false | 是否只读。 设为 `true` 时禁止修改内容，但保留只读文本的选择和复制能力；文字仍使用正常态颜色。 |
| showPasswordToggle | bool | false | 是否在后置插槽显示内置密码显隐按钮。 初始显隐状态由 `obscureText` 决定，按钮点击后的显隐状态由输入框 自身维护。启用后会使用 TDesign 的浏览图标和 40dp 触控区域；如果 同时传入 `suffix`，自定义后置内容会紧跟在该按钮之后。 |
| status | TInputStatus | TInputStatus.normal | 输入框语义状态。 |
| style | TextStyle? | - | 输入文本样式。 未指定的字段继承 TDesign `fontBodyLarge`；显式颜色可覆盖状态默认色。 |
| suffix | Widget? | - | 后缀组件；传入后不显示内置清除按钮。 |
| textAlign | TextAlign | TextAlign.start | 文本对齐方式。 |

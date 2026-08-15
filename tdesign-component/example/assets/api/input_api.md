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
| enabled | bool | true | 是否可交互。 |
| readOnly | bool | false | 是否只读。 |
| label | String? | - | 标签文案（输入框左侧的固定标签）。 |
| required | bool | false | 是否必填；为 true 且存在 label 时在标签后展示红色 `*`。 |
| layout | TInputLayout | horizontal | 标签与输入区的排布方式（horizontal/vertical）。 |
| status | TInputStatus | normal | 输入框状态（normal/success/warning/error），影响边框与提示文本颜色。 |
| tips | String? | - | 输入区下方提示文本，颜色随 status。 |
| align | TInputAlign? | - | 输入内容位置（left/center/right）；未传时回退到 textAlign。 |
| clearable | bool? | - | 是否可清空；为 false 时不显示内置清除按钮。 |
| clearTrigger | TInputClearTrigger | always | 内置清除按钮的触发方式（always/focus）。 |
| maxcharacter | int? | - | 最大字符数，一个汉字计 2 个字符；与 maxLength 二选一使用。 |
| borderless | bool | false | 是否开启无边框模式。 |
| allowInputOverMax | bool | false | 超出 maxLength / maxcharacter 后是否允许继续输入。 |
| hintText | String? | - | 占位提示文案。 |
| prefix | Widget? | - | 前缀组件。 |
| suffix | Widget? | - | 后缀组件；传入后不显示内置清除按钮。 |
| maxLines | int? | - | 最大行数；null 表示不限制。 |
| minLines | int? | - | 最小行数；未传时读取 Theme 默认值。 |
| maxLength | int? | - | 最大字符数。 |
| autofocus | bool | false | 是否自动聚焦。 |
| focusNode | FocusNode? | - | 焦点节点。 |
| inputType | TextInputType | TextInputType.multiline | 键盘类型。 |
| inputAction | TextInputAction? | - | 键盘动作。 |
| textAlign | TextAlign | TextAlign.start | 文本对齐方式。 |
| inputFormatters | List<TextInputFormatter>? | - | 输入格式化器。 |
| decoration | InputDecoration? | - | Material 输入装饰逃逸口。 |
| style | TextStyle? | - | 输入文本样式。 |
| cursorColor | Color? | - | 光标颜色。 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| autofocus | bool | false | 是否自动聚焦。 |
| controller | TextEditingController? | - | 文本控制器。 |
| cursorColor | Color? | - | 光标颜色。 |
| decoration | InputDecoration? | - | Material 输入装饰逃逸口。 |
| enabled | bool | true | 是否可交互。 |
| focusNode | FocusNode? | - | 焦点节点。 |
| hintText | String? | - | 占位提示文案。 |
| initialValue | String? | - | 内部控制器的初始文本，仅初始化一次。 |
| inputAction | TextInputAction? | - | 键盘动作。 |
| inputFormatters | List<TextInputFormatter>? | - | 输入格式化器。 |
| inputType | TextInputType | TextInputType.text | 键盘类型。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| label | String? | - | 标签文案（输入框左侧的固定标签）。 |
| required | bool | false | 是否必填；为 true 且存在 label 时在标签后展示红色 `*`。 |
| layout | TInputLayout | horizontal | 标签与输入区的排布方式（horizontal/vertical）。 |
| status | TInputStatus | normal | 输入框状态（normal/success/warning/error），影响边框与提示文本颜色。 |
| tips | String? | - | 输入区下方提示文本，颜色随 status。 |
| align | TInputAlign? | - | 输入内容位置（left/center/right）；未传时回退到 textAlign。 |
| clearable | bool? | - | 是否可清空；为 false 时不显示内置清除按钮。 |
| clearTrigger | TInputClearTrigger | always | 内置清除按钮的触发方式（always/focus）。 |
| maxcharacter | int? | - | 最大字符数，一个汉字计 2 个字符；与 maxLength 二选一使用。 |
| borderless | bool | false | 是否开启无边框模式。 |
| allowInputOverMax | bool | false | 超出 maxLength / maxcharacter 后是否允许继续输入。 |
| maxLength | int? | - | 最大字符数。 |
| maxLines | int? | 1 | 最大行数。 |
| minLines | int? | - | 最小行数。 |
| obscureText | bool | false | 是否隐藏输入文本。 |
| onChanged | ValueChanged<String>? | - | 文本变化通知。 |
| onEditingComplete | VoidCallback? | - | 编辑完成回调。 |
| onSubmitted | ValueChanged<String>? | - | 提交回调。 |
| prefix | Widget? | - | 前缀组件。 |
| readOnly | bool | false | 是否只读。 |
| style | TextStyle? | - | 输入文本样式。 |
| suffix | Widget? | - | 后缀组件；传入后不显示内置清除按钮。 |
| textAlign | TextAlign | TextAlign.start | 文本对齐方式。 |

#### 枚举

##### TInputLayout

标签与输入区的排布方式。

| 取值 | 说明 |
| --- | --- |
| horizontal | 横向：label 在输入框左侧，同一行排列。 |
| vertical | 纵向：label 在输入框上方，换行排列。 |

##### TInputStatus

输入框状态，影响边框与提示文本颜色。

| 取值 | 说明 |
| --- | --- |
| normal | 默认状态。 |
| success | 成功状态。 |
| warning | 警告状态。 |
| error | 错误状态。 |

##### TInputAlign

输入内容的位置。

| 取值 | 说明 |
| --- | --- |
| left | 居左。 |
| center | 居中。 |
| right | 居右。 |

##### TInputClearTrigger

内置清除按钮的触发方式。

| 取值 | 说明 |
| --- | --- |
| always | 输入框有值时始终显示。 |
| focus | 输入框聚焦且有值时显示。 |


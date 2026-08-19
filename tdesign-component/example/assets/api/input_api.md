## API
### TInput

#### 工厂构造方法

##### TInput.multiline

创建多行输入框，编辑内核仍使用 Flutter `TextField`。

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
| suffix | Widget? | - | 后缀组件；传入后不显示内置清除按钮。 |
| clearButtonMode | TInputClearButtonMode? | Theme/never | 清除按钮显示模式：never、always、focused。 |
| status | TInputStatus | normal | 输入状态：normal、success、warning、error。 |
| borderless | bool | false | 是否隐藏 TDesign 输入边框。 |
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
| style | TextStyle? | - | 输入文本样式。 |
| cursorColor | Color? | - | 光标颜色。 |

#### 默认构造方法

默认构造方法参数与 `TInput.multiline` 相同，另有以下差异：

| 参数 | 默认值 | 说明 |
| --- | --- | --- |
| maxLines | 1 | 单行输入。 |
| inputType | TextInputType.text | 键盘类型。 |
| obscureText | false | 是否隐藏输入文本。 |

`TInput` 不提供 `label`；标签、help 和 error 应使用 `TFormItem` 或页面外层结构承载。

## API
### TTextarea
#### 简介
`TInput.multiline` 的语义别名。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| autofocus | bool | false | 是否自动聚焦。 |
| controller | TextEditingController? | - | 文本控制器。 |
| decoration | InputDecoration? | - | Material 输入装饰逃逸口。 |
| enabled | bool | true | 是否可交互。 |
| focusNode | FocusNode? | - | 焦点节点。 |
| hintText | String? | - | 占位提示文案。 |
| initialValue | String? | - | 内部控制器的初始文本，仅初始化一次。 |
| inputAction | TextInputAction? | - | 键盘动作。 |
| inputFormatters | List<TextInputFormatter>? | - | 输入格式化器。 |
| inputType | TextInputType | TextInputType.multiline | 键盘类型。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| label | String? | - | 标签文案（输入框左侧的固定标签）。 |
| maxLength | int? | - | 最大字符数。 |
| maxLines | int? | - | 最大行数；null 表示不限制。 |
| minLines | int? | - | 最小行数；未传时读取 Theme 默认值。 |
| onChanged | ValueChanged<String>? | - | 文本变化通知。 |
| onEditingComplete | VoidCallback? | - | 编辑完成回调。 |
| onSubmitted | ValueChanged<String>? | - | 提交回调。 |
| prefix | Widget? | - | 前缀组件。 |
| readOnly | bool | false | 是否只读。 |
| suffix | Widget? | - | 后缀组件。 |
| textAlign | TextAlign | TextAlign.start | 文本对齐方式。 |

## API
### TSearchBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| autoFocus | bool | false | 是否自动聚焦。 |
| cancelText | String | '取消' | 取消按钮文案。 |
| controller | TextEditingController? | - | 文本控制器。 |
| decoration | InputDecoration? | - | 输入框装饰逃逸口。 |
| enabled | bool | true | 是否可交互。 |
| focusNode | FocusNode? | - | 自定义焦点。 |
| hintText | String? | - | 占位提示。 |
| initialValue | String? | - | 初始文本；仅在未传 `controller` 时初始化一次。 |
| inputAction | TextInputAction | TextInputAction.search | 键盘动作。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| needCancel | bool | false | 是否显示取消按钮。 |
| onCancelPressed | VoidCallback? | - | 取消按钮点击回调。 |
| onChanged | ValueChanged<String>? | - | 文本变化通知。 |
| onClearPressed | VoidCallback? | - | 清除按钮点击回调。 |
| onSubmitted | ValueChanged<String>? | - | 提交回调。 |
| readOnly | bool | false | 是否只读。 |

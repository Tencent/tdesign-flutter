## API
### TSearchBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| controller | TextEditingController? | - | 文本控制器。 |
| initialValue | String? | - | 初始文本；仅在未传 controller 时初始化一次。 |
| onChanged | ValueChanged<String>? | - | 文本变化通知。 |
| onSubmitted | ValueChanged<String>? | - | 提交回调。 |
| enabled | bool | true | 是否可交互。 |
| readOnly | bool | false | 是否只读。 |
| hintText | String? | - | 占位提示。 |
| needCancel | bool | false | 是否显示取消按钮。 |
| cancelText | String | '取消' | 取消按钮文案。 |
| onCancelPressed | VoidCallback? | - | 取消按钮点击回调。 |
| onClearPressed | VoidCallback? | - | 清除按钮点击回调。 |
| autoFocus | bool | false | 是否自动聚焦。 |
| inputAction | TextInputAction | TextInputAction.search | 键盘动作。 |
| decoration | InputDecoration? | - | 输入框装饰逃逸口。 |
| focusNode | FocusNode? | - | 自定义焦点。 |


### TSearchBarThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| variant | TSearchBarVariant? | - | 搜索框形态。 |
| textAlignment | TSearchBarAlignment? | - | 文本对齐方式。 |
| backgroundColor | Color? | - | 背景颜色。 |
| padding | EdgeInsetsGeometry? | - | 外层内边距。 |
| cursorHeight | double? | - | 光标高度。 |
| autoHeight | bool? | - | 是否自动高度。 |


### TSearchBarVariant
#### 枚举值

| 名称 | 说明 |
| --- | --- |
| square | 方形搜索框。 |
| round | 圆角搜索框。 |


### TSearchBarAlignment
#### 枚举值

| 名称 | 说明 |
| --- | --- |
| left | 左对齐。 |
| center | 居中对齐。 |

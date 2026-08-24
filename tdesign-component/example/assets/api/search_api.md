## API
### TSearchBar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| actionText | String? | - | 右侧操作文案；为空时不占据布局空间。 |
| autofocus | bool | false | 是否自动聚焦。 |
| clearable | bool | true | 是否在聚焦且存在文本时显示清除按钮。 |
| controller | TextEditingController? | - | 文本控制器。 |
| enabled | bool | true | 是否可交互。 |
| focusNode | FocusNode? | - | 自定义焦点节点。 |
| hintText | String? | - | 占位提示。 |
| initialValue | String? | - | 内部控制器的初始文本，仅初始化一次。 |
| inputAction | TextInputAction | TextInputAction.search | 键盘动作。 |
| inputFormatters | List<TextInputFormatter>? | - | 输入格式化器。 |
| inputType | TextInputType | TextInputType.text | 键盘类型。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| maxCharacter | int? | - | 最大加权字符数，ASCII 字符计 1，非 ASCII 字符计 2。 |
| maxLength | int? | - | 最大字符数；不显示 Material 计数器。 |
| onActionPressed | VoidCallback? | - | 右侧操作点击回调。组件不会隐式清空输入或释放焦点。 |
| onChanged | ValueChanged<String>? | - | 文本变化通知。 |
| onClearPressed | VoidCallback? | - | 清除按钮点击回调。 |
| onFocusChanged | ValueChanged<bool>? | - | 焦点变化通知。 |
| onSubmitted | ValueChanged<String>? | - | 提交回调。 |
| readOnly | bool | false | 是否只读。只读时仍可获得焦点和选择文字，但不显示清除按钮。 |
| textAlignment | TSearchBarAlignment? | - | 文本对齐方式，默认左对齐。 |
| variant | TSearchBarVariant? | - | 搜索框形态；优先于 `TSearchBarThemeData.variant`。 |


### TSearchBarThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| actionGap | double? | - | 搜索框与右侧操作文字的间距，默认 15dp。 |
| actionTextStyle | TextStyle? | - | 右侧操作文字样式。 |
| clearIconTheme | IconThemeData? | - | 清除图标主题。 |
| contentPadding | EdgeInsetsGeometry? | - | 输入区域内部留白，默认水平方向 12dp。 |
| cursorHeight | double? | - | 光标高度。 |
| height | double? | - | 搜索框高度，默认 40dp。 |
| hintStyle | TextStyle? | - | 占位文字样式，未设置字段继承 `fontBodyLarge` 和占位色 Token。 |
| inputBackgroundColor | Color? | - | 输入区域背景色，默认 `bgColorSecondaryContainer` Token。 |
| searchIconTheme | IconThemeData? | - | 搜索图标主题。 |
| textStyle | TextStyle? | - | 输入文字样式，未设置字段继承 `fontBodyLarge` Token。 |
| variant | TSearchBarVariant? | - | 搜索框形态。 |


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

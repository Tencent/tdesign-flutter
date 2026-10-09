## API

### TSearchBar

基于 Material `TextField` 的搜索输入框。

`controller` 是主控制路径；未传时组件创建内部 controller，并使用
`initialValue` 初始化一次。搜索结果由调用方在组件外组合。

#### 构造方法

##### TSearchBar

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| actionText | String? | - | 右侧操作文案；为空时不占据布局空间。 | 否 |
| autofocus | bool | false | 是否自动聚焦。 | 否 |
| clearable | bool | true | 是否在存在文本、enabled 为 true 且非只读时显示清除按钮；无需聚焦。 | 否 |
| controller | TextEditingController? | - | 文本控制器；与 initialValue 互斥。外部控制器由调用方释放， 未提供时由组件创建并释放内部控制器。 | 否 |
| enabled | bool | true | 是否可交互。 | 否 |
| focusNode | FocusNode? | - | 焦点节点；外部节点由调用方释放，未提供时由组件管理内部节点。 | 否 |
| hintText | String? | - | 占位提示。 | 否 |
| initialValue | String? | - | 内部控制器的初始文本，仅初始化一次。 | 否 |
| inputAction | TextInputAction | TextInputAction.search | 键盘动作。 | 否 |
| inputFormatters | List&lt;TextInputFormatter&gt;? | - | 输入格式化器。 | 否 |
| inputType | TextInputType | TextInputType.text | 键盘类型。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| maxCharacter | int? | - | 最大加权字符数，ASCII 字符计 1，非 ASCII 字符计 2。 | 否 |
| maxLength | int? | - | 最大字符数；不显示 Material 计数器，与 maxCharacter 互斥。 | 否 |
| onActionPressed | VoidCallback? | - | 右侧操作点击回调。组件不会隐式清空输入或释放焦点。 | 否 |
| onChanged | ValueChanged&lt;String&gt;? | - | 文本变化通知。 | 否 |
| onClearPressed | VoidCallback? | - | 清除按钮点击回调；先清空 controller，再调用本回调，最后触发 onChanged('')。 | 否 |
| onFocusChanged | ValueChanged&lt;bool&gt;? | - | 焦点变化通知。 | 否 |
| onSubmitted | ValueChanged&lt;String&gt;? | - | 提交回调。 | 否 |
| readOnly | bool | false | 是否只读。只读时仍可获得焦点和选择文字，但不显示清除按钮。 | 否 |
| textAlignment | TSearchBarAlignment? | - | 文本对齐方式，默认左对齐。 | 否 |
| variant | TSearchBarVariant? | - | 搜索框形态；未设置时为 `TSearchBarVariant.square`。 | 否 |


### TSearchBarVariant

搜索框形态。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| square | TSearchBarVariant | - | 方形搜索框。 | - |
| round | TSearchBarVariant | - | 圆角搜索框。 | - |


### TSearchBarAlignment

搜索框文本对齐方式。
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| left | TSearchBarAlignment | - | 左对齐。 | - |
| center | TSearchBarAlignment | - | 居中对齐。 | - |


### TSearchBarThemeData

`TSearchBar` 的默认视觉配置。

<!-- api-theme: fields -->

#### 配置项


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| actionGap | double? | - | 搜索框与右侧操作文字的间距，默认 15dp。 | 否 |
| actionTextStyle | TextStyle? | - | 右侧操作文字样式。 | 否 |
| clearIconTheme | IconThemeData? | - | 清除图标主题。 | 否 |
| contentPadding | EdgeInsetsGeometry? | - | 输入区域内部留白，默认水平方向 12dp。 | 否 |
| cursorHeight | double? | - | 光标高度。 | 否 |
| height | double? | - | 搜索框高度，默认 40dp。 | 否 |
| hintStyle | TextStyle? | - | 占位文字样式，未设置字段继承 `fontBodyLarge` 和占位色 Token。 | 否 |
| inputBackgroundColor | Color? | - | 输入区域背景色，默认 `bgColorSecondaryContainer` Token。 | 否 |
| searchIconTheme | IconThemeData? | - | 搜索图标主题。 | 否 |
| textStyle | TextStyle? | - | 输入文字样式，未设置字段继承 `fontBodyLarge` Token。 | 否 |

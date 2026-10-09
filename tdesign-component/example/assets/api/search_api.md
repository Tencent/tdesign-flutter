## API

### TSearchBar

#### 构造方法

##### TSearchBar

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| actionText | String? | - | 右侧操作文案；为空时不占据布局空间。 | 否 |
| autofocus | bool | false | 是否自动聚焦。 | 否 |
| clearable | bool | true | 是否在聚焦且存在文本时显示清除按钮。 | 否 |
| controller | TextEditingController? | - | 文本控制器。 | 否 |
| enabled | bool | true | 是否可交互。 | 否 |
| focusNode | FocusNode? | - | 自定义焦点节点。 | 否 |
| hintText | String? | - | 占位提示。 | 否 |
| initialValue | String? | - | 内部控制器的初始文本，仅初始化一次。 | 否 |
| inputAction | TextInputAction | TextInputAction.search | 键盘动作。 | 否 |
| inputFormatters | List&lt;TextInputFormatter&gt;? | - | 输入格式化器。 | 否 |
| inputType | TextInputType | TextInputType.text | 键盘类型。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| maxCharacter | int? | - | 最大加权字符数，ASCII 字符计 1，非 ASCII 字符计 2。 | 否 |
| maxLength | int? | - | 最大字符数；不显示 Material 计数器。 | 否 |
| onActionPressed | VoidCallback? | - | 右侧操作点击回调。组件不会隐式清空输入或释放焦点。 | 否 |
| onChanged | ValueChanged&lt;String&gt;? | - | 文本变化通知。 | 否 |
| onClearPressed | VoidCallback? | - | 清除按钮点击回调。 | 否 |
| onFocusChanged | ValueChanged&lt;bool&gt;? | - | 焦点变化通知。 | 否 |
| onSubmitted | ValueChanged&lt;String&gt;? | - | 提交回调。 | 否 |
| readOnly | bool | false | 是否只读。只读时仍可获得焦点和选择文字，但不显示清除按钮。 | 否 |
| textAlignment | TSearchBarAlignment? | - | 文本对齐方式，默认左对齐。 | 否 |
| variant | TSearchBarVariant? | - | 搜索框形态；未设置时为 `TSearchBarVariant.square`。 | 否 |


### TSearchBarThemeData

#### 构造方法

##### TSearchBarThemeData

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


#### 实例方法

##### TSearchBarThemeData.copyWith

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| height | double? | - | 字段含义：搜索框高度，默认 40dp。 调用时的空值行为见方法说明。 | 否 |
| inputBackgroundColor | Color? | - | 字段含义：输入区域背景色，默认 `bgColorSecondaryContainer` Token。 调用时的空值行为见方法说明。 | 否 |
| contentPadding | EdgeInsetsGeometry? | - | 字段含义：输入区域内部留白，默认水平方向 12dp。 调用时的空值行为见方法说明。 | 否 |
| textStyle | TextStyle? | - | 字段含义：输入文字样式，未设置字段继承 `fontBodyLarge` Token。 调用时的空值行为见方法说明。 | 否 |
| hintStyle | TextStyle? | - | 字段含义：占位文字样式，未设置字段继承 `fontBodyLarge` 和占位色 Token。 调用时的空值行为见方法说明。 | 否 |
| searchIconTheme | IconThemeData? | - | 字段含义：搜索图标主题。 调用时的空值行为见方法说明。 | 否 |
| clearIconTheme | IconThemeData? | - | 字段含义：清除图标主题。 调用时的空值行为见方法说明。 | 否 |
| actionTextStyle | TextStyle? | - | 字段含义：右侧操作文字样式。 调用时的空值行为见方法说明。 | 否 |
| actionGap | double? | - | 字段含义：搜索框与右侧操作文字的间距，默认 15dp。 调用时的空值行为见方法说明。 | 否 |
| cursorHeight | double? | - | 字段含义：光标高度。 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TSearchBarThemeData | - | - | - |


##### TSearchBarThemeData.lerp

位置参数：`other, t`


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TSearchBarThemeData&gt;? | - | - | 是 |
| t | double | - | - | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TSearchBarThemeData | - | - | - |


### TSearchBarVariant
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| square | TSearchBarVariant | - | 方形搜索框。 | - |
| round | TSearchBarVariant | - | 圆角搜索框。 | - |


### TSearchBarAlignment
#### 枚举值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| left | TSearchBarAlignment | - | 左对齐。 | - |
| center | TSearchBarAlignment | - | 居中对齐。 | - |

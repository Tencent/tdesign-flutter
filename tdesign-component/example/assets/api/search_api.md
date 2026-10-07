## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TSearchBar
#### 简介
基于 Material `TextField` 的搜索输入框。
`controller` 是主控制路径；未传时组件创建内部 controller，并使用
`initialValue` 初始化一次。搜索结果由调用方在组件外组合。

#### 声明

```dart
class TSearchBar extends StatefulWidget
```

#### 默认构造方法


```dart
const TSearchBar({
  super.key,
  this.controller,
  this.initialValue,
  this.onChanged,
  this.onSubmitted,
  this.onFocusChanged,
  this.enabled = true,
  this.readOnly = false,
  this.hintText,
  this.actionText,
  this.onActionPressed,
  this.onClearPressed,
  this.clearable = true,
  this.autofocus = false,
  this.inputType = TextInputType.text,
  this.inputAction = TextInputAction.search,
  this.maxLength,
  this.maxCharacter,
  this.inputFormatters,
  this.variant,
  this.textAlignment,
  this.focusNode,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
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
#### 简介
`TSearchBar` 的默认视觉配置。

#### 声明

```dart
class TSearchBarThemeData extends ThemeExtension<TSearchBarThemeData>
```

#### 默认构造方法


```dart
const TSearchBarThemeData({
  this.height,
  this.inputBackgroundColor,
  this.contentPadding,
  this.textStyle,
  this.hintStyle,
  this.searchIconTheme,
  this.clearIconTheme,
  this.actionTextStyle,
  this.actionGap,
  this.cursorHeight,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
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

```dart
TSearchBarThemeData copyWith({
  double? height,
  Color? inputBackgroundColor,
  EdgeInsetsGeometry? contentPadding,
  TextStyle? textStyle,
  TextStyle? hintStyle,
  IconThemeData? searchIconTheme,
  IconThemeData? clearIconTheme,
  TextStyle? actionTextStyle,
  double? actionGap,
  double? cursorHeight,
})
```


返回主题副本；非空参数替换对应配置，null 参数保留当前配置。

返回类型：`TSearchBarThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| height | double? | - | 搜索框高度，默认 40dp。 | 否 |
| inputBackgroundColor | Color? | - | 输入区域背景色，默认 `bgColorSecondaryContainer` Token。 | 否 |
| contentPadding | EdgeInsetsGeometry? | - | 输入区域内部留白，默认水平方向 12dp。 | 否 |
| textStyle | TextStyle? | - | 输入文字样式，未设置字段继承 `fontBodyLarge` Token。 | 否 |
| hintStyle | TextStyle? | - | 占位文字样式，未设置字段继承 `fontBodyLarge` 和占位色 Token。 | 否 |
| searchIconTheme | IconThemeData? | - | 搜索图标主题。 | 否 |
| clearIconTheme | IconThemeData? | - | 清除图标主题。 | 否 |
| actionTextStyle | TextStyle? | - | 右侧操作文字样式。 | 否 |
| actionGap | double? | - | 搜索框与右侧操作文字的间距，默认 15dp。 | 否 |
| cursorHeight | double? | - | 光标高度。 | 否 |


##### TSearchBarThemeData.lerp

```dart
TSearchBarThemeData lerp(
  ThemeExtension<TSearchBarThemeData>? other,
  double t,
)
```


按 t 在当前主题和目标主题之间生成过渡主题。
other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。

返回类型：`TSearchBarThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TSearchBarThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


### TSearchBarVariant
#### 简介
搜索框形态。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| square | 方形搜索框。 |
| round | 圆角搜索框。 |


### TSearchBarAlignment
#### 简介
搜索框文本对齐方式。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| left | 左对齐。 |
| center | 居中对齐。 |

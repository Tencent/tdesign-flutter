## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TInput

#### 声明

```dart
class TInput extends StatefulWidget
```

#### 默认构造方法


```dart
const TInput({
  super.key,
  this.controller,
  this.initialValue,
  this.onChanged,
  this.onSubmitted,
  this.onEditingComplete,
  this.enabled = true,
  this.readOnly = false,
  this.hintText,
  this.prefix,
  this.suffix,
  this.clearButtonMode,
  this.status = TInputStatus.normal,
  this.borderless = false,
  this.maxLines = 1,
  this.minLines,
  this.maxLength,
  this.maxCharacter,
  this.indicator = false,
  this.autofocus = false,
  this.focusNode,
  this.inputType = TextInputType.text,
  this.inputAction,
  this.textAlign = TextAlign.start,
  this.obscureText = false,
  this.showPasswordToggle = false,
  this.inputFormatters,
  this.style,
  this.cursorColor,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| autofocus | bool | false | 是否自动聚焦。 | 否 |
| borderless | bool | false | 是否隐藏输入框边框。 | 否 |
| clearButtonMode | TInputClearButtonMode? | - | 清除按钮显示模式；为空时为 TInputClearButtonMode.never。 点击清除会清空 controller 并触发 onChanged；suffix 非空或 showPasswordToggle 为 true 时隐藏清除按钮。 | 否 |
| controller | TextEditingController? | - | 文本控制器；与 initialValue 互斥。外部控制器由调用方释放， 未提供时由组件创建并释放内部控制器。 | 否 |
| cursorColor | Color? | - | 光标颜色。 | 否 |
| enabled | bool | true | 是否可交互。 设为 `false` 时表示禁用输入框，禁止编辑、聚焦和选择，并使用禁用态文字颜色。 | 否 |
| focusNode | FocusNode? | - | 焦点节点；外部节点由调用方释放，未提供时由组件管理内部节点。 | 否 |
| hintText | String? | - | 占位提示文案。 | 否 |
| indicator | bool | false | 是否显示当前字符计数。 多行场景优先使用 `TTextarea`；未配置长度限制时不会显示。 | 否 |
| initialValue | String? | - | 内部控制器的初始文本，仅初始化一次。 | 否 |
| inputAction | TextInputAction? | - | 键盘动作。 | 否 |
| inputFormatters | List&lt;TextInputFormatter&gt;? | - | 输入格式化器。 | 否 |
| inputType | TextInputType | TextInputType.text | 键盘类型。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| maxCharacter | int? | - | 最大字符权重，按 Unicode code point 计算：ASCII code point 计 1， 非 ASCII code point 计 2。 非空时必须大于或等于 0，与 maxLength 二选一。提交中的文本超过限制时，保留不超过限制的 最长前缀；输入法正在 composing 时暂不截断，在 composing 结束后执行。 | 否 |
| maxLength | int? | - | 最大字符数，使用 Flutter grapheme 计数语义；非空时必须大于或等于 0， 与 maxCharacter 互斥。 | 否 |
| maxLines | int? | 1 | 最大行数。 | 否 |
| minLines | int? | - | 最小行数；为空时单行为 null，多行默认为 4，并限制到非空 maxLines。 | 否 |
| obscureText | bool | false | 是否隐藏输入文本；为 true 时仅支持 maxLines 为 1、minLines 为 null。 | 否 |
| onChanged | ValueChanged&lt;String&gt;? | - | 文本变化通知。 | 否 |
| onEditingComplete | VoidCallback? | - | 编辑完成回调。 | 否 |
| onSubmitted | ValueChanged&lt;String&gt;? | - | 提交回调。 | 否 |
| prefix | Widget? | - | 前缀组件。 | 否 |
| readOnly | bool | false | 是否只读。 设为 `true` 时禁止修改内容，但保留只读文本的选择和复制能力；文字仍使用正常态颜色。 | 否 |
| showPasswordToggle | bool | false | 是否在后置插槽显示内置密码显隐按钮。 初始显隐状态由 `obscureText` 决定，按钮点击后的显隐状态由输入框 自身维护。启用后会使用 TDesign 的浏览图标和 24dp 图标槽，且不会 额外撑高输入框；仅支持单行输入。如果同时传入 `suffix`，自定义后置内容 会紧跟在该按钮之后。启用密码显隐按钮时，不同时显示内置清除按钮。 | 否 |
| status | TInputStatus | TInputStatus.normal | 输入框语义状态。 状态色用于输入壳层、计数器和错误提示； 已输入文字仍使用正常正文色，除非通过 `style` 显式覆盖。 当输入框位于 `TFormField` 中且表单错误需要在输入框内展示时， 表单错误状态优先于这里显式设置的状态。 | 否 |
| style | TextStyle? | - | 输入文本样式。 输入文字样式的唯一组件公开配置入口。未指定的字段继承显式 Material 文字主题或 TDesign `fontBodyLarge`；提示文字由组件 Theme 的 `hintStyle` 单独控制。 | 否 |
| suffix | Widget? | - | 后缀组件；传入后不显示内置清除按钮。 | 否 |
| textAlign | TextAlign | TextAlign.start | 文本对齐方式。 | 否 |


### TInputThemeData
#### 简介
TInput 与 TTextarea 共用的组件级 ThemeExtension。
{@category ComponentTheme}
输入组件的外层边框、颜色、内边距和提示文字样式在这里提供组件级默认值；
默认状态不继承全局填充色，避免输入区被 `ThemeData.inputDecorationTheme`
污染。

#### 声明

```dart
class TInputThemeData extends ThemeExtension<TInputThemeData>
```

#### 默认构造方法


```dart
const TInputThemeData({
  this.clearIconSize,
  this.hintStyle,
  this.clearIconColor,
  this.contentPadding,
  this.borderRadius,
  this.backgroundColor,
  this.borderColor,
  this.borderWidth,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| backgroundColor | Color? | - | 输入区域背景色。 null 时在 TFormItem 作用域内透明，独立输入框使用 bgColorContainer Token。 | 否 |
| borderColor | Color? | - | 输入区域边框颜色。 null 时按启用、焦点与语义状态解析边框颜色；禁用态使用 componentStroke Token。 | 否 |
| borderRadius | double? | - | 输入区域圆角。 对非多行、非无边框输入框设置为大于 0 的值时，输入框使用完整边框； 未设置时保留单行输入框的底部分隔线。 | 否 |
| borderWidth | double? | - | 输入区域边框宽度。 null 时为 1 逻辑像素。 | 否 |
| clearIconColor | Color? | - | 清除图标颜色。 null 时错误态使用 errorColor，其他状态使用 textColorPlaceholder Token。 | 否 |
| clearIconSize | double? | - | 清除图标尺寸。 null 时为 20 逻辑像素。 | 否 |
| contentPadding | EdgeInsetsGeometry? | - | 输入区域内边距。 null 时在 TFormItem 作用域内为零，独立输入框为四周 16 逻辑像素；Textarea 组合有独立的容器分工。 | 否 |
| hintStyle | TextStyle? | - | 占位提示文本样式。 未指定的字段继承 TDesign 输入框提示词 token。 | 否 |


#### 实例方法

##### TInputThemeData.copyWith

```dart
TInputThemeData copyWith({
  double? clearIconSize,
  TextStyle? hintStyle,
  Color? clearIconColor,
  EdgeInsetsGeometry? contentPadding,
  double? borderRadius,
  Color? backgroundColor,
  Color? borderColor,
  double? borderWidth,
})
```


复制主题配置。
## 返回值
返回主题副本；非空参数替换对应配置，null 参数保留当前配置。

返回类型：`TInputThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| clearIconSize | double? | - | 清除图标尺寸。 null 时为 20 逻辑像素。 | 否 |
| hintStyle | TextStyle? | - | 占位提示文本样式。 未指定的字段继承 TDesign 输入框提示词 token。 | 否 |
| clearIconColor | Color? | - | 清除图标颜色。 null 时错误态使用 errorColor，其他状态使用 textColorPlaceholder Token。 | 否 |
| contentPadding | EdgeInsetsGeometry? | - | 输入区域内边距。 null 时在 TFormItem 作用域内为零，独立输入框为四周 16 逻辑像素；Textarea 组合有独立的容器分工。 | 否 |
| borderRadius | double? | - | 输入区域圆角。 对非多行、非无边框输入框设置为大于 0 的值时，输入框使用完整边框； 未设置时保留单行输入框的底部分隔线。 | 否 |
| backgroundColor | Color? | - | 输入区域背景色。 null 时在 TFormItem 作用域内透明，独立输入框使用 bgColorContainer Token。 | 否 |
| borderColor | Color? | - | 输入区域边框颜色。 null 时按启用、焦点与语义状态解析边框颜色；禁用态使用 componentStroke Token。 | 否 |
| borderWidth | double? | - | 输入区域边框宽度。 null 时为 1 逻辑像素。 | 否 |


##### TInputThemeData.lerp

```dart
TInputThemeData lerp(ThemeExtension<TInputThemeData>? other, double t)
```


生成主题过渡配置。
## 返回值
按 t 在当前主题和目标主题之间生成过渡主题。
other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。

返回类型：`TInputThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TInputThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


### TInputClearButtonMode
#### 简介
输入框清除按钮的显示模式。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| never | 从不显示清除按钮。 |
| always | 有文本时显示清除按钮。 |
| focused | 输入框获得焦点且有文本时显示清除按钮。 |


### TInputStatus
#### 简介
输入框的语义状态。
状态不改变已输入文字的正文色。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| normal | 默认状态。 |
| success | 成功状态。 |
| warning | 警告状态。 |
| error | 错误状态。 |

## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TTextarea
#### 简介
TDesign 多行文本输入框。
编辑能力复用 `TInput`；容器、内部标题、提示词和计数器遵循
Textarea 的视觉契约。表单字段标签仍应由 `TFormItem` 提供，`label` 仅用于
独立 Textarea 自身的内部标题。
### 主题配置
主题复用 `TInputThemeData`，容器读取其中的 `contentPadding` 和 `borderColor`。
内部编辑器的内边距固定为零、背景透明，其余输入主题配置继续传给 `TInput`；
标题、状态颜色等默认外观读取 `TThemeData` 的全局 Token。

#### 声明

```dart
class TTextarea extends StatefulWidget
```

#### 默认构造方法


```dart
const TTextarea({
  super.key,
  this.controller,
  this.initialValue,
  this.onChanged,
  this.onSubmitted,
  this.onEditingComplete,
  this.enabled = true,
  this.readOnly = false,
  this.hintText,
  this.label,
  this.layout = TTextareaLayout.horizontal,
  this.prefix,
  this.suffix,
  this.clearButtonMode,
  this.status = TInputStatus.normal,
  this.bordered = false,
  this.maxLines,
  this.minLines,
  this.maxLength,
  this.maxCharacter,
  this.indicator = false,
  this.autofocus = false,
  this.focusNode,
  this.inputType = TextInputType.multiline,
  this.inputAction,
  this.textAlign = TextAlign.start,
  this.inputFormatters,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| autofocus | bool | false | 是否自动聚焦。 | 否 |
| bordered | bool | false | 是否显示外边框。 | 否 |
| clearButtonMode | TInputClearButtonMode? | - | 清除按钮显示模式；未传时不显示清除按钮。 | 否 |
| controller | TextEditingController? | - | 文本控制器；与 initialValue 互斥。外部控制器由调用方释放， 未提供时由组件创建并释放内部控制器。 | 否 |
| enabled | bool | true | 是否可交互。 | 否 |
| focusNode | FocusNode? | - | 焦点节点；外部节点由调用方释放，未提供时由组件管理内部节点。 | 否 |
| hintText | String? | - | 占位提示文案。 | 否 |
| indicator | bool | false | 是否显示当前字符计数。 | 否 |
| initialValue | String? | - | 内部控制器的初始文本，仅初始化一次。 | 否 |
| inputAction | TextInputAction? | - | 键盘动作。 | 否 |
| inputFormatters | List&lt;TextInputFormatter&gt;? | - | 输入格式化器。 | 否 |
| inputType | TextInputType | TextInputType.multiline | 键盘类型。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| label | String? | - | 输入框内部标题。 表单中的字段标签请使用 `TFormItem.label`，避免与表单必填、校验语义重复。 | 否 |
| layout | TTextareaLayout | TTextareaLayout.horizontal | 内部标题与编辑区的排列方式。 | 否 |
| maxCharacter | int? | - | 最大字符权重，按 Unicode code point 计算：ASCII code point 计 1， 非 ASCII code point 计 2；非空时必须大于或等于 0，与 maxLength 互斥。 | 否 |
| maxLength | int? | - | 最大字符数；非空时必须大于或等于 0，与 maxCharacter 互斥。 | 否 |
| maxLines | int? | - | 最大行数；null 表示不限制。 | 否 |
| minLines | int? | - | 最小行数；未传时使用 4 行，并限制到非空 maxLines。 | 否 |
| onChanged | ValueChanged&lt;String&gt;? | - | 文本变化通知。 | 否 |
| onEditingComplete | VoidCallback? | - | 编辑完成回调。 | 否 |
| onSubmitted | ValueChanged&lt;String&gt;? | - | 提交回调。 | 否 |
| prefix | Widget? | - | 前缀组件。 | 否 |
| readOnly | bool | false | 是否只读。 | 否 |
| status | TInputStatus | TInputStatus.normal | 输入框语义状态。 | 否 |
| suffix | Widget? | - | 后缀组件。 | 否 |
| textAlign | TextAlign | TextAlign.start | 文本对齐方式。 | 否 |


### TTextareaLayout
#### 简介
多行文本框内部标题与编辑区的排列方式。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| horizontal | 标题与编辑区横向排列。 |
| vertical | 标题与编辑区竖向排列。 |

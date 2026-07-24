## API
### TForm
#### 简介
TDesign 表单容器。
校验和字段生命周期委托给 Flutter `Form` 与 `FormState`。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| autovalidateMode | AutovalidateMode | AutovalidateMode.disabled | 自动校验时机。 |
| child | Widget | - | 表单内容。 |
| controller | TFormController? | - | 表单控制器。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChanged | VoidCallback? | - | 任意字段变化时触发。 |
| onSubmit | ValueChanged<Map<String, Object?>>? | - | 校验通过后触发。 |
| showErrorMessage | bool | true | 是否向字段 builder 暴露错误文案。 |


### TFormState
#### 简介
`TForm` 的公开状态。

### TFormController
#### 简介
命令式触发表单提交、校验和重置。

### TFormField
#### 简介
将严格受控组件接入 Flutter `FormField` 的字段桥接组件。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| autovalidateMode | AutovalidateMode? | - | 自动校验时机。 |
| builder | TFormFieldBuilder<T> | - | 字段内容 builder。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| name | String | - | 字段名。 |
| onChanged | ValueChanged<T>? | - | 字段值变化回调；为 null 时禁用字段。 |
| onSaved | FormFieldSetter<T>? | - | 保存字段时触发。 |
| validator | FormFieldValidator<T>? | - | 字段校验器。 |
| value | T | - | 受控字段值。 |


### TFormItem
#### 简介
表单项的标签和字段布局容器。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget | - | 字段内容。 |
| errorText | String? | - | 错误文案。 |
| extra | Widget? | - | 标签末尾的额外内容。 |
| help | String? | - | 辅助说明文案。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| label | String? | - | 标签文案。 |
| labelWidth | double? | - | 标签区域宽度。 |
| required | bool | false | 是否显示必填标记。 |


### TFormThemeData
#### 简介
TForm 组件级 ThemeExtension。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 表单项背景色。 |
| errorStyle | TextStyle? | - | 错误文案样式。 |
| helpStyle | TextStyle? | - | 辅助说明样式。 |
| itemPadding | EdgeInsetsGeometry? | - | 表单项内边距。 |
| itemSpacing | double? | - | 表单项间距。 |
| labelAlign | TextAlign? | - | 标签对齐方式。 |
| labelGap | double? | - | 标签与字段的垂直间距。 |
| labelStyle | TextStyle? | - | 标签样式。 |
| labelWidth | double? | - | 默认标签宽度。 |
| layout | TFormLayout? | - | 表单项布局方向。 |
| messageGap | double? | - | 字段与辅助或错误文案的间距。 |
| requiredMarkStyle | TextStyle? | - | 必填标记样式。 |
| showColon | bool? | - | 是否在标签末尾显示冒号。 |


### TFormLayout
#### 简介
表单项布局方向。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| horizontal | 标签与字段水平排列。 |
| vertical | 标签与字段垂直排列。 |


### TFormFieldBuilder
#### 简介
TDesign 字段 builder。
#### 类型定义

```dart
typedef TFormFieldBuilder = Widget Function(BuildContext context, T value, ValueChanged<T>? onChanged, String? errorText);
```

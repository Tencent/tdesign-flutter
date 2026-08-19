## API
### TForm
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| autovalidateMode | AutovalidateMode? | - | 自动校验时机。 |
| child | Widget | - | 表单内容。 |
| controller | TFormController? | - | 表单控制器。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChanged | VoidCallback? | - | 任意字段变化时触发。 |
| onSubmit | ValueChanged<Map<String, Object?>>? | - | 校验通过后触发，参数为各 `TFormField` 注册的字段值。 |
| showErrorMessage | bool | true | 是否向字段 builder 暴露错误文案。 |

`TFormController` 提供 `validate({Iterable<String>? fields})`、
`clearValidate({Iterable<String>? fields})`、
`setValidateMessage(Map<String, String?> messages)`、`submit()` 和 `reset()`。
字段值仍由 Flutter 受控字段管理，不复制小程序 `data` / `rules` 对象 API。
`TFormThemeData.requiredMarkPosition` 可设置必填标记显示在标签左侧或右侧。

### TFormItem
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget | - | 字段内容。 |
| errorText | String? | - | 错误文案。 未传时自动使用最近 `TFormField` 的校验错误。 |
| extra | Widget? | - | 标签末尾的额外内容。 |
| help | String? | - | 辅助说明文案。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| label | String? | - | 标签文案。 |
| labelWidth | double? | - | 标签区域宽度；为空时读取 `TFormThemeData.labelWidth`。 |
| required | bool? | - | 是否显示必填标记。 未传时继承最近 `TFormField` 的 required 状态。 |
| showErrorMessage | bool | true | 是否展示继承自 `TFormField` 的错误文案。 |
| labelAlign | TextAlign? | Theme/end | 标签文本对齐方式；未传时继承 `TFormThemeData`。 |


### TFormRule
#### 类型定义

```dart
typedef TFormRule = FormFieldValidator<T>;
```


### TFormFieldBuilder
#### 类型定义

```dart
typedef TFormFieldBuilder = Widget Function(BuildContext context, T value, ValueChanged<T>? onChanged, String? errorText);
```

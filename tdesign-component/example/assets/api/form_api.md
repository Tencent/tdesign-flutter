## API
### TForm
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| autovalidateMode | AutovalidateMode | AutovalidateMode.disabled | 自动校验时机。 |
| child | Widget | - | 表单内容。 |
| controller | TFormController? | - | 表单控制器。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onChanged | VoidCallback? | - | 任意字段变化时触发。 |
| onSubmit | ValueChanged<Map<String, Object?>>? | - | 校验通过后触发，参数为各 `TFormField` 注册的字段值。 |
| showErrorMessage | bool | true | 是否向字段 builder 暴露错误文案。 |


### TFormItem
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget | - | 字段内容。 |
| errorText | String? | - | 错误文案。 |
| extra | Widget? | - | 标签末尾的额外内容。 |
| help | String? | - | 辅助说明文案。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| label | String? | - | 标签文案。 |
| labelWidth | double? | - | 标签区域宽度；为空时读取 `TFormThemeData.labelWidth`。 |
| required | bool | false | 是否显示必填标记。 |


### TFormFieldBuilder
#### 类型定义

```dart
typedef TFormFieldBuilder = Widget Function(BuildContext context, T value, ValueChanged<T>? onChanged, String? errorText);
```

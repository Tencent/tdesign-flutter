# TForm / TFormItem / TFormField

> 状态：已完成 | Sprint：S3

表单能力建立在 Flutter `Form`、`FormState` 与 `FormField` 之上。TDesign 只补充字段收集、受控组件桥接和统一表单项布局，不维护独立校验引擎。

## 架构

| 层 | 实现 |
|---|---|
| 校验与生命周期 | Flutter `Form` / `FormState` / `FormField` |
| 容器 | `TForm`、`TFormState`、`TFormController` |
| 字段桥接 | `TFormField<T>` |
| 标签与消息布局 | `TFormItem` |
| 视觉配置 | `TFormThemeData` |

`TFormItem` 不识别任何具体输入组件。新增组件时，只需通过 `TFormField<T>` 的 builder 连接受控值，不修改 Form 源码。

## TForm

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `child` | `Widget` | 必填 | 表单内容 |
| `controller` | `TFormController?` | `null` | 命令式校验、提交和重置 |
| `autovalidateMode` | `AutovalidateMode` | `disabled` | Material 自动校验时机 |
| `onChanged` | `VoidCallback?` | `null` | 任意字段变化时触发 |
| `onSubmit` | `ValueChanged<Map<String, Object?>>?` | `null` | 校验成功后的字段快照 |
| `showErrorMessage` | `bool` | `true` | 是否向字段 builder 暴露错误文案 |

也可以通过 `GlobalKey<TFormState>` 调用 `validate()`、`submit()`、`reset()` 和读取 `values`。

## TFormField

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `name` | `String` | 必填 | 提交 Map 中的字段名 |
| `value` | `T` | 必填 | 受控值 |
| `builder` | `TFormFieldBuilder<T>` | 必填 | 构建字段内容 |
| `onChanged` | `ValueChanged<T>?` | `null` | 值变化回调；为 `null` 时禁用 |
| `validator` | `FormFieldValidator<T>?` | `null` | Material 字段校验器 |
| `onSaved` | `FormFieldSetter<T>?` | `null` | 表单保存时触发 |
| `autovalidateMode` | `AutovalidateMode?` | `null` | 字段级自动校验时机 |

Builder 签名：

```dart
Widget Function(
  BuildContext context,
  T value,
  ValueChanged<T>? onChanged,
  String? errorText,
)
```

## TFormItem

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `child` | `Widget` | 必填 | 字段内容 |
| `label` | `String?` | `null` | 标签文案 |
| `required` | `bool` | `false` | 是否显示必填标记 |
| `help` | `String?` | `null` | 辅助说明 |
| `errorText` | `String?` | `null` | 错误文案，存在时优先于 help |
| `labelWidth` | `double?` | Theme | 当前项标签宽度 |
| `extra` | `Widget?` | `null` | 标签末尾额外内容 |

## Theme

`TFormThemeData` 提供 `showColon`、`labelWidth`、`layout`、`labelAlign`、`labelStyle`、`requiredMarkStyle`、`helpStyle`、`errorStyle`、`backgroundColor`、`itemPadding`、`itemSpacing`、`labelGap` 和 `messageGap`。

`TFormLayout` 包含 `horizontal` 与 `vertical`。

## 示例

```dart
TForm(
  controller: controller,
  onSubmit: (values) {},
  child: TFormField<bool>(
    name: 'notifications',
    value: notifications,
    onChanged: (next) => setState(() => notifications = next),
    validator: (value) => value == true ? null : '请开启通知',
    builder: (context, value, onChanged, errorText) => TFormItem(
      label: '消息通知',
      required: true,
      errorText: errorText,
      child: TSwitch(value: value, onChanged: onChanged),
    ),
  ),
)
```

## 验收

- 字段注册、改名、移除和外部受控更新均有测试。
- validator、save、submit、reset 和 controller 生命周期均有测试。
- 横向、纵向、帮助与错误布局均有测试。
- Form 源码每文件覆盖率均高于 95%，定向 analyze 为 0 issue。

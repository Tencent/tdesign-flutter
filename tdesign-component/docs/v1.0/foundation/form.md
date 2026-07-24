# Form 基础方案

v1 表单以 Flutter `Form`、`FormState` 和 `FormField` 为唯一校验与生命周期基础。

## 分层

| 层 | 职责 |
|---|---|
| Flutter Form | 字段注册、校验、保存和重置生命周期 |
| TForm | 字段值快照、提交入口和错误显示策略 |
| TFormField<T> | 将严格受控组件接入 FormField |
| TFormItem | 标签、必填标记、帮助和错误文案布局 |
| TFormThemeData | 表单项视觉与布局默认值 |

## 约束

- 表单容器不持有字段业务状态。
- 字段的 `value` 始终由业务侧持有。
- `TFormField.onChanged == null` 表示字段禁用，并向 builder 传入 null 回调。
- 校验只使用 `FormFieldValidator<T>`。
- `TFormItem` 不根据字段类型创建或分发组件。
- `TFormController` 只代理当前 `TFormState`，不复制字段状态。

## 提交

`TFormState.submit()` 或 `TFormController.submit()` 先调用 Material `validate()`。校验成功后调用 `save()`，并把当前注册字段的只读快照传给 `TForm.onSubmit`。

## 重置

`reset()` 重置 Material 字段的校验状态。严格受控值仍由业务侧负责恢复，然后通过 rebuild 同步到 `TFormField.value`。

## 主题

表单项布局通过 `TFormThemeData` 配置。各输入组件的视觉仍由对应的 Material Theme 或 `T{Component}ThemeData` 管理，Form 不覆盖子组件主题。

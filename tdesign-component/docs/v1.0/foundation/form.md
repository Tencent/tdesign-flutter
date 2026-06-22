# Form 方案（v1.0）

> **已定稿（2025-06）** · 组件 → [form.md](../components/03-input/form.md) · [form-item.md](../components/03-input/form-item.md)

**Material 对照**：校验与生命周期跟 `Form` / `FormState` / `FormField`；`TFormField<T>` 对标 `TextFormField` 桥接模式；**废弃**自研 `TFormValidation` / `TFormItemType`。

---

## 1. 三层

| 层 | v1.0 |
|---|---|
| A 校验 | Material `Form` + `FormState` + `FormField` |
| B UI | `TForm` + `TFormItem`（label / help / error 布局） |
| C 桥接 | **`TFormField<T>`** 挂接各字段 Widget |

**废弃**：`TFormValidation.check()`、`TFormItemType`、`FormItemNotifier`、`data`/`items` 集中式 API。

---

## 2. 字段桥接（控制类 → Form 写法）

| 类 | 字段 | Form 内 |
|---|---|---|
| D | Input、Textarea、SearchBar | `TFormField` + `controller` + `enabled` |
| B/C | Switch、Checkbox、Slider、Rate | `value` + `onChanged` → `field.didChange` |
| F | Picker、Calendar、Cascader | 同 B/C |
| B 组 | CheckboxGroup | `TFormField<List<T>>`；`maxChecked` 留组件实例 |

禁用：`TFormField.enabled == false` → B/C/F 传 `onChanged: null`；D 传 `enabled: false`。

---

## 3. 0.2.x → v1.0

| 0.2.x | v1.0 |
|---|---|
| `data: Map` / `items` | `child` + `TFormField(name:)` |
| `TFormItem(type: stepper, …)` | `TFormItem(child: TFormField<int>(…))` |
| `formController` | `controller: TFormController` |
| `TForm(disabled: true)` | 各 `TFormField(enabled: false)` |
| `submitWithWarningMessage` | 废弃；用 `validator` |

```dart
// 0.2.x
TForm(disabled: true, items: [...])

// v1.0：逐字段
TFormField<bool>(
  builder: (field) => TSwitch(
    value: field.value ?? false,
    onChanged: field.enabled ? field.didChange : null,
  ),
)
// 或 TFormField(enabled: false, ...)
```

更多禁用对照 → [disabled-evolution.md §6](./disabled-evolution.md#6-代码示例0.2x--v10)

---

## 4. Theme

`TFormThemeData`：label 宽、对齐、help/error 样式、项间距。字段 L4 仍用各自 `T{Xxx}ThemeData`。

---

## 5. 测试

Form 容器：`submit` / `reset` / `validate` · 字段 + Form：至少一条 `rules` 失败态 → [testing.md](../guide/testing.md)

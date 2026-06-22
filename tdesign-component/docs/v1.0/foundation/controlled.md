# 受控与控制类（A–F）

> **已定稿（2025-06）** · 关联：[§1 控制类](#控制类) · [api.md §5](./api.md#5-禁用0.2x--v10) · [form.md §2](./form.md#2-字段桥接控制类--form-写法)

外部持有状态；组件只渲染传入值。`value` / `onChanged` **不走** Theme P0–P4。

**Material 对照**：`Switch`/`Checkbox`/`Slider`/`Radio` 均为 `value` + `onChanged`、无 `defaultValue`；`TextField` 主路径 `TextEditingController`，辅路径 `initialValue`（同 `TextFormField`，init 一次）。

---

## 1. 控制类 A–F {#控制类}

| 类 | 代表 | 核心 API | 初值 | 禁用 |
|---|---|---|---|---|
| **A** | Button、Link、Cell | `onPressed` | — | `onPressed: null` / ListTile 系 `onTap: null` |
| **B/C** | Switch、Slider、Rate、Steps | `value` + `onChanged` | 父 State 或 `Controller(initialValue:)` | `onChanged: null` |
| **D** | Input、Textarea | `controller`（主）/ `initialValue`（辅，init 一次） | `TInputController(initialValue:)` | `enabled: false` / `readOnly: true` |
| **E** | Popup、Dialog、Toast | `show()`（主推）/ `visible` + `onVisibleChange` | 父 State；无 `defaultVisible` | 不 show / `visible: false`；**无** Widget 级 `disabled` |
| **F** | Picker、Calendar、Cascader… | `value` + `onChanged` | 父 State 或 Controller | `onChanged: null`；项级 `*.disabled` **KEEP** |

---

## 2. 初值 {#初值}

| 参数 | B/C/F/E | D（Input） |
|---|---|---|
| ~~`defaultValue`~~ | ❌ 删除 | ❌ |
| Widget `initialValue` | ❌ | ✅ 与 `controller` 互斥，仅 init 一次 |
| 初值落点 | 父字段或 `XxxController(initialValue:)` | 同上 |

**互斥**（assert）：`controller` ↔ `value`；Input 的 `controller` ↔ `initialValue`。

---

## 3. value 与 Controller {#controller}

| | `value` + `onChanged` | `controller` |
|---|---|---|
| 用途 | 默认 | 命令式改值、多 Widget 共享 |
| 改值 | 父 `setState` | `_c.value = x` |

Form：D → `controller`；B/C/F → `value` + `onChanged`；由 `TFormField` 桥接。

---

## 4. E 类浮层 {#e-类}

| 层级 | v1.0 |
|---|---|
| 显隐 | 不调 `showXxx()`；或 `visible: false` |
| 容器 | `TPopupOptions` / 各 Options + `T{Xxx}ThemeData` |
| 内部 | 子控件按 A/B 类禁用 |

**禁止**浮层容器 `disabled: true`。

| 组件 | 主推 API |
|---|---|
| TPopup / TPopover | `show()` |
| TDialog | `showAlert` / `showConfirm` / `showInput` |
| TDrawer | `show()` + `visible` |
| TActionSheet | `showList` / `showGrid` / `showGroupActionSheet` |
| TToast / TMessage | static `show*` |

**进 Theme**：蒙层、圆角、动画。 **留实例**：`title`/`content`/回调/`child`/`visible`。

---

## 5. F 类选择器 {#f-类}

| 组件 | `value` 类型 |
|---|---|
| TPicker | 列组合 |
| TDateTimePicker | `DateTime` |
| TCalendar | `List<DateTime>`；`minDate`/`maxDate` 留实例 |
| TCascader | 级联路径 |
| TTreeSelect | id / id 列表 |
| TDropdownMenu | 菜单选中值 |

**禁用**：Widget `onChanged: null`；`TPickerOption.disabled` 等数据项 **KEEP**。

**进 Theme**：滚轮高、指示器、列样式。 **留实例**：`value`、`onChanged`、选项数据。

---

## 6. 代码示例（0.2.x → v1.0）{#6-代码示例0.2x--v10}

### Switch（B 类）

```dart
// 0.2.x
TSwitch(isOn: _on, enable: true, onChanged: (v) => _on = v)

// v1.0
TSwitch(
  value: _on,
  onChanged: (v) => setState(() => _on = v),
)
TSwitch(value: _on, onChanged: null) // 禁用
```

### Input（D 类）

```dart
final _c = TInputController(initialValue: 'hello');
TInput(
  controller: _c,
  onChanged: (v) => debugPrint(v), // 通知，不用于禁用
  enabled: true,
)

// 非受控一次性初值（与 controller 互斥）
TInput(initialValue: 'hello', onChanged: ...)
```

### Picker / 浮层（E/F）

```dart
DateTime _selected = DateTime.now(); // 初值在父 State
TPopup.show(context, ...);          // 命令式
TPopup(visible: _open, onVisibleChange: (v) => setState(() => _open = v), ...) // 声明式
```

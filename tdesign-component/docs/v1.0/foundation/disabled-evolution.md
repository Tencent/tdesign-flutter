# 禁用演变（0.2.x → v1.0）

> **已定稿（2025-06）** · 规则 → [api.md §5](./api.md#5-禁用0.2x--v10) · [controlled.md §1](./controlled.md#控制类)

v1.0 **不暴露** Widget 级统一 `disabled` / `enable`；按控制类映射。

---

## 1. 控制类 → v1.0 写法

| 类 | v1.0 |
|---|---|
| A | `onPressed: null` / `onTap: null` |
| B/C/F | `onChanged: null` |
| D | `enabled: false` / `readOnly: true` |
| E | 不调 `show` |
| Tab 等 | `enabled: false` |

---

## 2. 一句话对照

| 0.2.x | v1.0 |
|---|---|
| `TButton(disabled: true)` | `onPressed: null` |
| `TSwitch(enable: false)` | `onChanged: null` |
| `TCheckbox` / `TRadio(enable: false)` | `onChanged: null` |
| `TInput` 不可编辑 | `enabled: false` |
| `TInput` 只读 | `readOnly: true` |
| `TStepper(disabled: true)` | `onChanged: null` |
| `TRate(disabled: true)` | `onChanged: null` |
| `TPicker(disabled: true)` | `onChanged: null` |
| `TCell(disabled: true)` | `onTap: null` |
| `TUpload(disabled: true)` | 上传区 `onPressed: null` |
| `TLink(state: disabled)` | `onPressed: null` |
| `TTab(enable: false)` | `enabled: false` |
| `TForm(disabled: true)` | 各 `TFormField(enabled: false)` |
| `TSwipeCell(disabled: true)` | `enabled: false` |
| `TTag(disable: true)` | Theme 灰态 |

---

## 3. 数据项 `disabled`（KEEP）

| 字段 | 组件 |
|---|---|
| `TPickerOption.disabled` | Picker / DateTimePicker |
| `TActionSheetItem.disabled` | ActionSheet |
| `TDropdownItem.disabled` | DropdownMenu |
| `TSidebarItem.disabled` | SideBar |
| `TTab.enabled` | Tab（由 `enable` 改名） |

Widget 级：`onChanged: null` · 数据项级：`*.disabled` **KEEP**。

---

## 4. 非禁用字段（勿误迁）

| 字段 | 含义 |
|---|---|
| `enableHapticFeedback` / `enableInfiniteRefresh` | RefreshHeader 能力开关 |
| `enableInteractiveSelection` | Input 文本可选 |
| `enableFeedback` | TabBar 触觉 |
| `enabledReplaceType` | Upload 替换类型 |
| `disableSelect` | SelectTag 样式模式 |
| `disableTextStyle` | Button 禁用态样式 |
| `readOnly`（Steps） | 步骤不可点击 |

---

## 5. 逐组件字段（有变更项）

| 组件 | 0.2.x | v1.0 |
|---|---|---|
| TButton | `disabled` | `onPressed: null` |
| TSwitch / TCheckbox / TRadio | `enable` | `onChanged: null` |
| TInput / TTextarea | — | **新增** `enabled` |
| TStepper | `disabled` | `onChanged: null` |
| TCell | `disabled` | `onTap: null` |
| TRate | `disabled` | `onChanged: null` |
| TTag | `disable` | Theme 灰态 |
| TSwipeCell | `disabled` | `enabled: false` |
| TLink | `TLinkState.disabled` | `onPressed: null` |
| TForm | `disabled` | `TFormField(enabled: false)` |
| TUpload | `disabled` | 上传 `onPressed: null` |
| TPicker | `disabled` | `onChanged: null` |
| TTab | `enable` | `enabled` |

无 Widget 级禁用的展示/浮层组件 → 见各 md §1 禁用一行。

---

## 6. 代码示例（0.2.x → v1.0）{#6-代码示例0.2x--v10}

### ❌ 用 `onChanged: null` 禁用 Input（D 类）

```dart
// 0.2.x 误导性写法（v1.0 禁止用于表达禁用）
TInput(onChanged: null) // onChanged 是文本通知，不是开关
```

```dart
// v1.0
TInput(controller: c, enabled: false)
TInput(controller: c, readOnly: true) // 只读，可复制
```

### ❌ 保留 `disabled: true` 在 Button（A 类）

```dart
// 0.2.x
TButton(text: '提交', disabled: true, onTap: () {})
```

```dart
// v1.0
TButton(child: Text('提交'), onPressed: null)
// 或条件禁用
TButton(child: Text('提交'), onPressed: isLoading ? null : _submit)
```

### ❌ `TForm(disabled: true)` 锁整张表单

```dart
// 0.2.x
TForm(disabled: true, items: [...])
```

```dart
// v1.0：逐字段
TFormField<bool>(
  builder: (field) => TSwitch(
    value: field.value ?? false,
    onChanged: field.enabled ? field.didChange : null,
  ),
)
// 或 field.enabled: false
```

通栏 `isBlock` 属布局迁移（非禁用）→ [button.md §2.1](../components/01-base/button.md#21-isblock-迁移通栏布局)

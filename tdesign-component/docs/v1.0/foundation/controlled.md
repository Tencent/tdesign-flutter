# 受控与控制类（A–F）

> **已定稿（2025-06）** · 关联：[§1 控制类](#控制类) · [api.md §5](./api.md#5-禁用0.2x--v10) · [form.md §2](./form.md#2-字段桥接控制类--form-写法)

外部持有状态；组件只渲染传入值。`value` / `onChanged` **不走** Theme P0–P4。

**Material 对照**：`Switch`/`Checkbox`/`Slider`/`Radio` 均为 `value` + `onChanged`、无 `defaultValue`；`TextField` 主路径 `TextEditingController`，辅路径 `initialValue`（同 `TextFormField`，init 一次）。导航选中（B 类）→ [§1.1](#11-导航选中b-类)。

---

## 1. 控制类 A–F {#控制类}

| 类 | 代表 | 核心 API | 初值 | 禁用 |
|---|---|---|---|---|
| **A** | Button、Link、Cell | `onPressed` | — | `onPressed: null` / ListTile 系 `onTap: null` |
| **B/C** | Switch、Slider、Rate、TStepper、**TSideBar**、**TTabBar**、**TSwiper** | `value` + `onChanged` | 父 State | `onChanged: null` |
| **D** | Input、Textarea | `controller`（主）/ `initialValue`（辅，init 一次） | `TInputController(initialValue:)` | `enabled: false` / `readOnly: true` |
| **E** | Popup、Dialog、Toast | `show()` → `Handle` / `Future` | — | 不调 `show`；**无** Widget 级 `visible` / `disabled` |
| **F** | Picker、Calendar、Cascader… | `value` + `onChanged` | 父 State | `onChanged: null`；项级 `*.disabled` **KEEP** |

### 1.1 导航选中（B 类）{#11-导航选中b-类}

Material **无**标准 SideBar Widget；**受控选中**语义对齐 M3：

| Material | 选中 API | 变更回调 |
|---|---|---|
| `NavigationBar` | `selectedIndex` | `onDestinationSelected` |
| `NavigationRail` | `selectedIndex` | `onDestinationSelected` |
| `BottomNavigationBar` | `currentIndex` | `onTap` |

TDesign 导航选中统一为 **`value` + `onChanged`**（与 Switch 等同一条全局命名线）；初值由**父 State** 持有，禁用 **`onChanged: null`**。代表：[TSideBar](../components/02-navigation/sidebar.md) · [TTabBar](../components/02-navigation/tab-bar.md)。**非** [TIndexes](../components/02-navigation/indexes.md)（`—` 通知型，内部持激活索引）。

---

## 2. 初值 {#初值}

| 参数 | B/C/F/E | D（Input） |
|---|---|---|
| ~~`defaultValue`~~ | ❌ 删除 | ❌ |
| Widget `initialValue` | ❌ | ✅ 与 `controller` 互斥，仅 init 一次 |
| 初值落点 | 父 State | `TInputController(initialValue:)` 或一次性 `initialValue` |

**互斥**（assert）：Input 的 `controller` ↔ `initialValue`。**B/C/F 不提供**与 `value` 并行的业务 `XxxController`（命令式改值 → 父 `setState` 改 `value`）。

---

## 3. 单轨原则与 Controller {#controller}

**每个组件一种主控制方案**；禁止 `value` + `onChanged` 与业务 `XxxController` 双轨并行（对齐 Material `Switch` / `RadioGroup` / `DropdownButton`）。

| 控制类 | 主方案 | 禁止 |
|---|---|---|
| **B/C/F** | `value` + `onChanged`；初值父 State | `TSwitchController`、`TRadioGroupController`、`TPickerController` 等与 `value` 并行的业务 Controller |
| **D** | `TInputController`（或互斥 `initialValue`） | 与 `controller` 同时传 `initialValue` |
| **`—` Controller 持态** | `TabController` 等 **即**主方案 | 再叠 Widget `value` + `onChanged` |
| **E** | `show()` → `Handle` / `Future` | 浮层容器 `disabled: true`；Widget `visible` |

**Flutter 基建 Controller**（`ScrollController`、`PageController`、`TextEditingController` 用于 filter 等）**不算**业务双轨；B/C/F 命令式改选中/开关/选项值 → **父 `setState` 改 `value`**。

### 3.1 value 与 D 类 Controller

| | `value` + `onChanged`（B/C/F） | `controller`（D / `TabController`） |
|---|---|---|
| 用途 | B/C/F **唯一**主路径 | D / Tabs **唯一**主路径 |
| 改值 | 父 `setState` | `_c.text = x` / `tabController.index = i` |

Form：D → `controller`；B/C/F → `value` + `onChanged`；由 `TFormField` 桥接。

---

## 4. E 类浮层 {#e-类}

| 层级 | v1.0 |
|---|---|
| 显隐 | **仅**命令式 `showXxx()` / `show()`；关闭 → `Handle.close()` / `Navigator.pop` / `Future` 结束 |
| 容器 | `TPopupOptions` / 各 Options + `T{Xxx}ThemeData` |
| 内部 | 子控件按 A/B 类禁用 |

**禁止**浮层容器 `disabled: true`。**禁止** Widget 级 `visible` + `onVisibleChange` 声明式显隐（对齐 Material `showDialog` / `showModalBottomSheet`；不 show 即关闭）。

| 组件 | 唯一主路径 |
|---|---|
| TPopup | `TPopup.show` → `TPopupHandle` |
| TDrawer | `TDrawer(...).show()` → `TDrawerHandle` |
| TActionSheet | `showList/Grid/GroupActionSheet` → `TActionSheetHandle` |
| TDialog | `showAlert` / `showConfirm` / `showInput` → `Future<T?>` |
| TPopover | `showPopover` → `Future` |
| TToast | static `show*` → `toastId` |
| TMessage | `showMessage` → `TMessageHandle` |

**TPopup 业务壳**（Drawer / ActionSheet）：`show` 返回 `T{Xxx}Handle`；Theme 字段归类 → [theme.md §2.1](./theme.md#21-themedata-字段归类v10-裁决)。

**进 Theme**：色 · 边距 · 宽高 · 圆角 · 阴影 · 按压样式 · 过渡 `duration`/`curve`/`delay`。**不进 Theme**：`showOverlay` / `closeOnOverlayClick` / `useSafeArea` / 能力开关 / 回调。

**留实例**：`title` / `content` / 回调 / `child`（**单次 show** 参数）。`onClose` / `onVisibleChange` 仅作 **show 生命周期通知**，**非**声明式持态 API。

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

## 6. 控制类 — {#控制类-}

**非** A–F 严格受控；组件 md 用 `## 控制方案`，勿统称「受控」。

| 子类 | 代表 | 核心 API | 初值 | 说明 |
|---|---|---|---|---|
| **纯展示** | Text、Divider、Loading、Progress | — | — | 无 `value` / `onChanged` |
| **展示型 value** | TSteps、TProgress | `value`（渲染） | 父 State | **无** `onChanged`；**非** B 类 |
| **通知型** | TIndexes | `onChanged` / `onSelect`（L3） | 组件内部 | 激活索引内部 `ValueNotifier`；**非** `value` 闭环 → [indexes.md](../components/02-navigation/indexes.md) |
| **Controller 持态** | TTabs | `TabController` | 父创建 Controller | **非** Widget `value` + `onChanged` |
| **容器** | Form、Collapse | 子组件各自 A–F | — | 编排层，不替代子项控制类 |

**与 B/C 易混**：`TSteps.value` 仅展示当前步；`TIndexes.onChanged` 仅通知、不可受控激活索引。导航 **TSteps**（`—`）≠ 输入 **TStepper**（B/C，`value` + `onChanged`）。

---

## 7. 代码示例（0.2.x → v1.0）{#7-代码示例0.2x--v10}

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
DateTime _selected = DateTime.now(); // F 类：父 State 持 value
TPopup.show(context, ...);           // E 类：命令式打开
handle.close();                      // E 类：关闭
```

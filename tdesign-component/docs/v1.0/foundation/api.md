# API 方案（v1.0）

> **已定稿（2025-06）** · 开发环境 → [developer-guide.md](../guide/developer-guide.md) · 逐组件 → [components/](../components/) §1 + §2

---

## 1. 构造器四层（L1–L4）

| 层级 | 内容 | 构造器 |
|---|---|---|
| L1 语义 | `variant`、`size`、`value`、`enabled` | ✅ |
| L2 内容 | `child`、`label`、`hintText`、`icon` | ✅ |
| L3 行为 | `onPressed`、`onChanged`、`onVisibleChange` | ✅ |
| L4 样式 | 色、边距、宽高、圆角、阴影、状态按压样式、动效参数（`duration`/`curve`/`delay`） | ❌ → `T{Xxx}ThemeData`（归类 → [theme.md §2.1](./theme.md#21-themedata-字段归类v10-裁决)） |

逃逸舱：`style: ButtonStyle?`、`decoration`（Material 同名）；**是否提供** → [theme.md §2.2](./theme.md#22-p0-逃逸舱判定) 四问判定（**默认无**）。
子树覆盖：`Theme.of(context).mergeExtension(T{Xxx}ThemeData(...))`。**禁止**构造器 `themeData`（→ [theme.md §2.1](./theme.md#禁止构造器-themedatav10-裁决)）。

**Material 依据**：L4 不进构造器，与 `ButtonStyle` / `InputDecorationTheme` / `WidgetStateProperty` 同层；实例级仍可用 Material 逃逸舱。

### 1.1 Flutter `Key`（Widget 基建）

| 项 | 约定 |
|---|---|
| **是否公开 API** | 是 — 所有 `StatelessWidget` / `StatefulWidget` 构造器均接受可选 `Key`（Dart 3：`super.key`） |
| **是否 L1–L4** | **否** — Flutter Element 身份，非 TDesign 业务语义 |
| **组件 md §1.1** | **不逐行列出** `key`；全库一次约定见本节（→ [component-doc.md §5.2](../guide/component-doc.md#52-构造器与工厂一张表)） |
| **实现** | 新代码统一 `super.key`；0.2.x 遗留 `Key? key` + `super(key: key)` 迁移时收口 |
| **典型用途** | 列表项身份、父 `setState` 后保持子树状态、**受控初值重置**（改 `key` 强制 remount；B/C/D 类优先改 `value` / `controller`，`key` 为破例手段） |

与受控 `value` / `onChanged` **无关**；勿将 `key` 当作选中态或表单值的替代 API。

---

## 2. 全局命名（0.2.x → v1.0）

| 0.2.x | v1.0 |
|---|---|
| `onTap` / `onClick` | `onPressed`（ListTile 系仍 `onTap`） |
| `onChange` | `onChanged` |
| `isOn` / `checked` | `value` |
| `type` | `variant` |
| `theme`（Button） | `colorScheme: TButtonColorScheme` |
| `disabled` / `enable` | 按控制类 → [disabled-evolution.md](./disabled-evolution.md) |
| 构造器 L4 | `T{Xxx}ThemeData` 或 `style`/`decoration` |
| `TTheme.of` | `Theme.of(context)` + `mergeExtension` |
| `*Style` | 不 export |

### 2.1 L2 内容槽：Widget 实例 vs Builder 回调

两类 L2 槽位，命名方式**不同**，靠**类型 + 后缀**区分，不靠 `Widget` / `builder` 混用前缀。

| 种类 | 参数形态 | 命名 | 类型示例 | 说明 |
|---|---|---|---|---|
| **Widget 实例** | 直接传入已构建的子树 | **语义名**（不加 `Widget` 后缀） | `Widget?` | `title` · `footer` · `child` · `icon` |
| **Builder 回调** | 按上下文懒构建子树 | **`{语义}Builder` 后缀**（对齐 Flutter） | `Widget? Function(...)` | `contentBuilder` · `anchorBuilder` · `itemBuilder` |

**Widget 实例（v1.0 裁决）**

- 每个语义槽**只有一个** `Widget?` 参数；**禁止** `String?` + `titleWidget` 双通道。
- 纯文案：`title: Text('标题')`（同 [button.md](../components/01-base/button.md) `child`、[drawer.md](../components/02-navigation/drawer.md) `title`/`footer`）。
- 整块自定义主体：优先 `child`（对齐 Material `child`）。
- **禁止** v1.0 新 API 使用 `titleWidget` · `contentWidget` 等 `*Widget` 后缀。
- **唯一例外**：同构造器另有非 Widget 同名语义（如 `loading: bool?` 与 `loadingWidget: Widget?`）时，后者可保留 `*Widget` 以消歧。

**Builder 回调（v1.0 裁决）**

- 后缀 **`Builder`**，前缀为语义：`contentBuilder`（✅），**非** `builderContent`（❌）。
- 依据：Flutter / Material 惯例 — `itemBuilder` · `separatorBuilder` · `transitionBuilder` · `ListView.builder`。
- **为何 Builder 带后缀、Widget 不带**：`Builder` 表示**函数**（懒构建）；`Widget?` 类型已说明是实例，槽位名只保留语义（`title` 即「标题区」）。

**Material 特例（保持原名，不强行合并）**

- `Tab`：`text` / `child` / `icon` 跟 Material [Tab](https://api.flutter.dev/flutter/material/Tab-class.html)。
- `AppBar`：`flexibleSpace` 等 Material 字段名 KEEP。

0.2.x 对照：`title`+`titleWidget` → `title: Widget?` · `contentWidget` → `child` · `builderContent` → `contentBuilder`（见各组件 §2）。

代码对照 → [disabled-evolution.md §6](./disabled-evolution.md#6-代码示例0.2x--v10) · [controlled.md §6](./controlled.md#6-代码示例0.2x--v10) · 逐组件 [components/](../components/) §2

---

## 3. 动作回调

| 场景 | v1.0 | Material 对照 |
|---|---|---|
| A 类（Button、Fab、Link） | `onPressed` | `ElevatedButton.onPressed` |
| ListTile 系（Cell） | `onTap` / `onLongPress` | `ListTile.onTap`（保留 `onTap` 名） |
| TabBar | `onTap` | `TabBar.onTap` |
| B/C/F | `onChanged` | `Switch` / `Slider` / `Radio.onChanged` |
| E 类 | `show()` → `Handle` / `Future` | `showModalBottomSheet` / `showDialog` |
| D 类 Input | `onChanged` 仅通知；禁用用 `enabled` | `TextField.onChanged` + `enabled` / `readOnly` |

E 类细则 → [controlled.md §4](./controlled.md#e-类)

---

## 4. 回调签名（v1.0 定稿）

| 类型 | 签名 |
|---|---|
| A | `VoidCallback? onPressed` |
| B Switch | `void Function(bool)? onChanged` |
| B Checkbox | `void Function(bool?)? onChanged` |
| B/C/F | `ValueChanged<T>? onChanged` |
| C Slider | `ValueChanged<double>?` + `onChangeStart`/`onChangeEnd` |
| E | `show()` → `Handle` / `Future`；show 上 `onClose` / `onVisibleChange` 仅生命周期通知 |

---

## 5. 禁用（0.2.x → v1.0）

| 控制类 | v1.0 | 0.2.x 废弃 | Material 原生 |
|---|---|---|---|
| A | `onPressed: null` / `onTap: null` | ~~`disabled`~~ | `ElevatedButton.onPressed == null` |
| B/C/F | `onChanged: null` | ~~`enable`~~ / ~~`disabled`~~ | `Switch` / `Slider` / `Checkbox.onChanged == null` |
| D | `enabled: false` / `readOnly: true` | 不用 `onChanged: null` | `TextField.enabled` / `readOnly` |
| E | 不调 `show` | ~~浮层 `disabled`~~ / ~~`visible`~~ | 无 Widget 级 disabled；不调 `show` |
| Tab 等 | `enabled: false` | ~~`enable`~~ | `Tab.enabled` |

**原则**：有 Material 等价写法时跟 Material；**不**再暴露统一 `disabled` / `enable` 构造器。

逐组件字段 → [disabled-evolution.md](./disabled-evolution.md) · 代码示例 → [disabled-evolution.md §6](./disabled-evolution.md#6-代码示例0.2x--v10)

---

## 6. 参数精简（五问 → 落点）

| 落点 | 条件 |
|---|---|
| KEEP | L1–L3 高频 |
| → THEME | L4 样式默认（§2.1 归类）；不含浮层策略 / 能力开关 |
| MERGE | 同义多参数 |
| RENAME | 语义对、命名不对齐 Material |
| REMOVE | 重复 / 可组合 |
| 新增 | Material 缺且设计必需 → `T{Xxx}ThemeData` 扩展字段 |

目标线：动作类 6–10 · 选择类 3–5 · 输入类 12–18 · 浮层 5–8。

---

## 7. Material 对齐（精简）

**总原则**：Material 有且语义一致 → 对齐命名与禁用；TDesign 跨端 / 设计稿必需 → 保留能力，必要时改名或进 ThemeExtension。

| 冲突点 | v1.0 裁决 |
|---|---|
| 禁用 | 跟 Material 原生（§5）；不暴露统一 `disabled` |
| Button 色彩 vs 形态 | `colorScheme`（跨端色彩）+ `variant`（形态）；不用 Flutter 易混的 `theme` |
| 受控初值 | B/C/F **无** `defaultValue`；对齐 `Switch.value` / `Slider.value` |
| Input 初值 | `controller` 主路径；`initialValue` 辅（init 一次），对齐 `TextFormField` |
| Form | 校验跟 `Form`/`FormState`/`FormField`；UI 仍用 `TForm`/`TFormItem` |
| 主题 | `MaterialApp.theme` + `ThemeExtension`；删 `TTheme` 单例 |
| ListTile / TabBar | 保留 `onTap`（Material 同名），不用 `onPressed` |
| 设计独有样式 | Material 无字段 → `T{Xxx}ThemeData` 扩展（见 [theme.md §4](./theme.md#4-material-vs-themeextension)） |

底层实现尽量包装 **Material 3** 控件；自绘仅设计稿无法由 M3 + Theme 表达时采用。逐组件 **Material 对齐** 见各 md §2 末行。

---

## 8. export（v1.0 公开面）

| export | 不 export |
|---|---|
| Widget、`show`、`ThemeExtension`、`Controller`、enum | `*Style`、内部 Widget、旧普通类 Theme |

逐组件 §1「export 收敛」· 全量 → [总规范附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) · 升级 checklist → [§8.1](#81-升级检查清单)

### 8.1 升级检查清单 {#升级检查清单}

公开面只保留 Widget、`ThemeExtension`、Controller、必要 enum；`*Style` 与内部类型 **不 export**。

- [ ] 全局搜索 `TTheme.of` → `Theme.of`
- [ ] 全局搜索 `.enable:` / `disabled:` 构造器 → 按 [§5](#5-禁用0.2x--v10) + [disabled-evolution.md §6](./disabled-evolution.md#6-代码示例0.2x--v10) 改写
- [ ] 删除对 `*_style.dart` 深路径 import
- [ ] 构造器 L4 → 子树 `mergeExtension(T{Xxx}ThemeData(...))`（见 [theme.md §3](./theme.md#3-子树覆盖)）
- [ ] 公开 API 注释与 [components/*.md §1](../components/) 一致；废弃参数不写「仍可使用」

# API 方案（v1.0）

> **已定稿（2025-06）** · 开发环境 → [developer-guide.md](../guide/developer-guide.md) · 逐组件 → [components/](../components/) §1 + §2

---

## 1. 构造器四层（L1–L4）

| 层级 | 内容 | 构造器 |
|---|---|---|
| L1 语义 | `variant`、`size`、`value`、`enabled` | ✅ |
| L2 内容 | `child`、`label`、`hintText`、`icon` | ✅ |
| L3 行为 | `onPressed`、`onChanged`、`onVisibleChange` | ✅ |
| L4 样式 | 色、字号、padding、圆角 | ❌ → `T{Xxx}ThemeData` |

逃逸舱：`style: ButtonStyle?`、`decoration`（Material 同名）。  
子树覆盖：`Theme.of(context).mergeExtension(T{Xxx}ThemeData(...))`。

**Material 依据**：L4 不进构造器，与 `ButtonStyle` / `InputDecorationTheme` / `WidgetStateProperty` 同层；实例级仍可用 Material 逃逸舱。

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

代码对照 → [disabled-evolution.md §6](./disabled-evolution.md#6-代码示例0.2x--v10) · [controlled.md §6](./controlled.md#6-代码示例0.2x--v10) · 逐组件 [components/](../components/) §2

---

## 3. 动作回调

| 场景 | v1.0 | Material 对照 |
|---|---|---|
| A 类（Button、Fab、Link） | `onPressed` | `ElevatedButton.onPressed` |
| ListTile 系（Cell） | `onTap` / `onLongPress` | `ListTile.onTap`（保留 `onTap` 名） |
| TabBar | `onTap` | `TabBar.onTap` |
| B/C/F | `onChanged` | `Switch` / `Slider` / `Radio.onChanged` |
| E 类 | `show()` / `visible` + `onVisibleChange` | `showModalBottomSheet` / Route 显隐 |
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
| E | `show()` / `ValueChanged<bool>? onVisibleChange` |

---

## 5. 禁用（0.2.x → v1.0）

| 控制类 | v1.0 | 0.2.x 废弃 | Material 原生 |
|---|---|---|---|
| A | `onPressed: null` / `onTap: null` | ~~`disabled`~~ | `ElevatedButton.onPressed == null` |
| B/C/F | `onChanged: null` | ~~`enable`~~ / ~~`disabled`~~ | `Switch` / `Slider` / `Checkbox.onChanged == null` |
| D | `enabled: false` / `readOnly: true` | 不用 `onChanged: null` | `TextField.enabled` / `readOnly` |
| E | 不 show / `visible: false` | ~~浮层 `disabled`~~ | 无 Widget 级 disabled；不调 `show` |
| Tab 等 | `enabled: false` | ~~`enable`~~ | `Tab.enabled` |

**原则**：有 Material 等价写法时跟 Material；**不**再暴露统一 `disabled` / `enable` 构造器。

逐组件字段 → [disabled-evolution.md](./disabled-evolution.md) · 代码示例 → [disabled-evolution.md §6](./disabled-evolution.md#6-代码示例0.2x--v10)

---

## 6. 参数精简（五问 → 落点）

| 落点 | 条件 |
|---|---|
| KEEP | L1–L3 高频 |
| → THEME | L4 或低频默认 |
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

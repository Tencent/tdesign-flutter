# TButton — v1.0 定稿

> Sprint **S1** | 控制类 **A** · 源码：`lib/src/components/button` · [guide](../guide/developer-guide.md)

**读法**：新写 v1.0 → **§1**（配样式 + **§3**）；0.2.x 升级 → **§2**（含 **§2.1** `isBlock`；Theme 见 **§3**，`shape` 见 **§3.5**）；落地与验收 → **§4**

**图例** → [component-doc.md §4](../../guide/component-doc.md#4-决策图例固定-6-个不新增)（§1–§3「决策」列）

---

## 架构

Material 薄包装 · `onPressed: null` = 禁用 · `TButtonThemeData` 全量 resolve（不以 Material `defaultStyleOf` 为起点）

**L1 三维**（正交）：`variant` / `colorScheme` 在构造器；`shape` 在 Theme。易混：`variant: fill` ≠ `shape: filled`（直角外形）。

| 维度 | 配置 | 默认 |
| --- | --- | --- |
| `variant` | 构造器 | `fill` |
| `colorScheme` | 构造器 | Theme |
| `shape` | `TButtonThemeData.shape`（内部枚举） | `rectangle` |

**style**：`*Style` 色板（P2，无 `shape`）→ resolve `ButtonStyle` → P0 `style` 覆盖。`shape` 配 Theme，展开进 resolved `ButtonStyle`，不写入 `*Style`。

---

## 1. v1.0 定稿 API（当前规范）

> 以下为 v1.0 **当前制定**的公开 API；相对 0.2.x 的变更见 §2。无图例项 = 与 0.2.x 同名同义保留。

层级 → [api.md §1](../../foundation/api.md#1-构造器四层l1l4)

### 构造器

| 决策 | 参数 / 方法 | 层级 | 类型 | 默认 | 说明 |
| --- | --- | --- | --- | --- | --- |
| | `child` | L2 | `Widget?` | — | 内容；纯文案用 `Text('…')` |
| | `size` | L1 | `TButtonSize` | `medium` | 未传用 `defaultSize` |
| ✏️ | `variant` | L1 | `TButtonVariant?` | `defaultVariant` | fill · outline · text · ghost |
| ✏️ | `colorScheme` | L1 | `TButtonColorScheme?` | Theme | defaultTheme · primary · danger · light |
| 🔀 | `icon` | L2 | `Widget?` | — | 见 **§1.1 icon 行为** |
| | `iconPosition` | L1 | `TButtonIconPosition` | `left` | |
| ✏️ | `onPressed` | L3 | `VoidCallback?` | — | `null` 禁用 |
| ✨ | `style` | P0 | `ButtonStyle?` | — | 覆盖 resolve；非日常配 `shape`（§3.5） |

#### §1.1 icon 行为

| `icon` 传入 | 尺寸 / 颜色 |
| --- | --- |
| `Icon` 未设 `size` / `color` | 组件按 `size` + 前景色补齐 |
| `Icon` 已设 `size` / `color` | 以传入为准 |
| 自定义 `Widget` | 调用方自管 |
| 升级 `IconData` | 改为 `Icon(Icons.xxx)` |

### 类型

| 决策 | 类型 | 成员 | 用于 |
| --- | --- | --- | --- |
| | `TButtonSize` | large · medium · small · extraSmall | `size` |
| | `TButtonIconPosition` | left · right | `iconPosition` |
| ✏️ | `TButtonVariant` | fill · outline · text · ghost | `variant` |
| ✏️ | `TButtonColorScheme` | defaultTheme · primary · danger · light | `colorScheme` |
| ✨ | `TButtonThemeData` | ThemeExtension | §3 |

### export

| 决策 | 符号 | 说明 |
| --- | --- | --- |
| 🚫 | `TButtonStyle` | 📦 迁入 `TButtonThemeData` |
| 🚫 | `TButtonType` | ✏️ → `TButtonVariant` |
| 🚫 | `TButtonTheme`（enum） | ✏️ → `TButtonColorScheme` |
| 🚫 | `TButtonEvent` | ✏️ → `VoidCallback?` |
| 🚫 | `TButtonStatus` | 🗑️ 内部类型 |
| 🚫 | `TButtonShape` | 📦 → `TButtonThemeData.shape`（内部，不 export） |
| 🚫 | `t_button_style.dart` | 整文件移出 |

[附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) · 替换细节 §2

---

## 2. 0.2.x → v1.0

**未改**（§1 无图例项）：`child`、`size`、`iconPosition`、`TButtonSize`、`TButtonIconPosition`

### ✏️ 改名

| 0.2.x | v1.0 | 怎么改 |
| --- | --- | --- |
| `type` / `TButtonType` | `variant` / `TButtonVariant` | 换名，成员对应 |
| `theme` / `TButtonTheme` | `colorScheme` / `TButtonColorScheme` | 换名，成员对应 |
| `onTap` / `TButtonEvent` | `onPressed` / `VoidCallback?` | 换名 |

### 🔀 合并

| 0.2.x | v1.0 | 怎么改 |
| --- | --- | --- |
| `icon` + `iconWidget` | `icon`（`Widget?`） | `IconData` → `Icon(...)`；§1.1 |
| `text` | `child: Text(…)` | 删 `text` 参数；**非**改名为 `child` |

### 🗑️ 移除

| 0.2.x | v1.0 | 怎么改 |
| --- | --- | --- |
| `disabled` | `onPressed: null` | **非**改名为 `onPressed` |
| `onLongPress` | — | 外包手势 |
| `TButtonStatus` | 不 export | 内部类型 |
| `isBlock` | — | **布局外包**；见下表 **§2.1** |

#### §2.1 `isBlock` 迁移（通栏布局）

v1.0 **不**在 `TButton` 上提供通栏参数；宽度与外边距由 **父级布局** 承担（对齐 Material：`FilledButton` + 父级 `maxWidth` 约束）。

| 0.2.x 行为 | v1.0 替代 |
| --- | --- |
| `isBlock: true`（横向撑满父级） | 外包 `SizedBox(width: double.infinity, child: TButton(...))` |
| 默认 `margin: horizontal 16` | 外包 `Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: …)`；或页面级 `Theme` `margin` |
| `isBlock` + `shape: filled` 底栏直角通栏 | `Padding` + `SizedBox` + `TButton`；直角用 Theme `shape: filled` |
| `isBlock: true` + `shape: circle` / `square` | **勿**通栏 + 图标定宽并存；通栏用 `rectangle` / `round`；图标钮去掉 `SizedBox` 全宽 |
| Dialog 等组件内底栏按钮 | 组件内部自行 `SizedBox` 全宽；**非** `TButton` 构造器参数 |

**示例对照**（语义示意，非强制 API 名）：

| 0.2.x | v1.0 |
| --- | --- |
| `TButton(isBlock: true, text: '提交', …)` | `SizedBox(width: double.infinity, child: TButton(child: Text('提交'), …))` |
| 同上且需左右 16 | `Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: SizedBox(width: double.infinity, child: TButton(...)))` |

```dart
// 0.2.x
TButton(text: '提交', isBlock: true, onTap: _submit)

// v1.0：宽度由父级约束，不在 TButton 上设通栏
SizedBox(
  width: double.infinity,
  child: TButton(child: Text('提交'), onPressed: _submit),
)
// 需复刻 0.2 默认左右 16 外边距时
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: SizedBox(
    width: double.infinity,
    child: TButton(child: Text('提交'), onPressed: _submit),
  ),
)
```

> 其它组件（Popup / Toast 等）demo 里的 `isBlock: true` 触发钮，按上表改为外层 `SizedBox`（± `Padding`）。

### 📦 迁入 Theme · ✨ 新增

- **📦** `shape`、`style` 三态、`padding`、`margin`、`gradient` 等 → `TButtonThemeData`（字段见 **§3**，`shape` 见 **§3.5**）；`TButtonShape` 🚫、`TButtonStyle` 🚫
- **✨** P0 `ButtonStyle? style`、`TButtonThemeData` — 见 §1（`style` 与 0.2 `TButtonStyle` **同名不同型**）

---

## 3. Theme

✨ `TButtonThemeData` = 子树默认；未传构造器项由此补全 · [theme.md](../../foundation/theme.md)

| 场景 | 配置位置 | 范围 |
| --- | --- | --- |
| 单颗 | §1 构造器（含 P0 `style`） | 该实例 |
| 一区 | `mergeExtension(TButtonThemeData(...))` | 子树 |
| 全局 | `MaterialApp.theme` + Token | 全 App |

**覆盖顺序**：P0 `style` **>** resolve（§3.5）**>** Token

单颗破例：§1 ✨ `style`，不必改 Theme。

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
| --- | --- | --- | --- |
| ✨ | `defaultVariant`、`defaultSize` | 未传 `variant` / `size` | — |
| 📦 | `filledStyle` · `outlinedStyle` · `textButtonStyle` · `ghostStyle` | **P2** 色板；默认 Token + `colorScheme`；**无** `shape` | `style` / `activeStyle` / `disableStyle` |
| 📦 | `shape` | 五档外形 → §3.5 展开进 resolved `ButtonStyle` | `shape` |
| 📦 | `padding` | 显式值覆盖 §3.5 推导 padding | `padding` |
| 📦 | `margin` | 外边距 | `margin` |
| 📦 | `iconSpacing` | 图标文案间距 | `iconTextSpacing` |
| 📦 | `gradient` | 装饰层（非 `ButtonStyle` 字段） | `gradient` |
| 📦 | `textStyle` | 默认文案 | `textStyle` / `disableTextStyle` |

### 3.5 `shape` 解析

保留 0.2 五档：轮廓 · square/circle 等宽高 · padding 模式 · `filled` 居中 · outline/ghost 减 `side.width`。展开进 resolved `ButtonStyle`，覆盖 M3 默认。

| 内部 `shape` | `ButtonStyle.shape` |
| --- | --- |
| `rectangle` · `square` | `RoundedRectangleBorder(radius: radiusDefault)` |
| `round` | `StadiumBorder()` 或 `radiusRound` |
| `circle` | `CircleBorder()` 或 `radiusRound` 裁圆 |
| `filled` | `BorderRadius.zero`（≠ `variant: fill`） |

**square / circle**（推荐纯 `icon`；通栏宽按钮请用 §2.1 布局，**勿**与定宽图标钮混用）：

| `size` | 边长 | 等边 padding |
| --- | --- | --- |
| large | 48 | 12 |
| medium | 40 | 10 |
| small | 32 | 7 |
| extraSmall | 28 | 5 |

**resolve**：`variant` → 控件 + 色板 → `colorScheme` → `shape`+`size` → 扩展层 → P0 `style`

**冲突优先级**（后者赢）：`shape` §3.5 → `*Style` → P0 · `minimumSize` `size`/§3.5 → `*Style` → P0 · `padding` §3.5 → Theme `padding` → P0 · 颜色 `colorScheme` → `*Style` → P0

---

## 4. 实现约定

> 全局测试门槛 → [testing.md](../../guide/testing.md)（Tier1 Widget、Golden、覆盖率）。本节为 **TButton 专项**验收表。

### 4.1 单路径 resolve

| 文件（规划） | 职责 |
| --- | --- |
| `t_button.dart` | Widget；委托 resolve |
| `t_button_resolve.dart` | **唯一** `ButtonStyle` merge 入口（§3.5 优先级） |
| `t_button_theme_data.dart` | ThemeExtension |

**约束**：`build` 内禁止内联 variant/colorScheme/shape merge；§3.5 冲突优先级须在 `resolve` 单测覆盖。

### 4.2 测试与 Example 契约

| 必测 | 断言 |
| --- | --- |
| A 类禁用 | `onPressed: null` → 不可点；**无** `disabled` 构造器 |
| `variant` × `colorScheme` | fill / outline / text / ghost × 至少 primary、defaultTheme 各一态 |
| §1.1 `icon` | 未设 `size`/`color` 时按 `size` 补齐；已设则尊重传入 |
| `iconPosition` | left / right 布局 |
| §3.5 `shape` | rectangle · round · square · circle · filled 展开进 `ButtonStyle.shape` |
| `size` | large / medium / small / extraSmall → §3.5 等边 padding / `minimumSize` |
| P0 `style` | 实例 `style` 覆盖 Theme resolve |
| Theme 子树 | `mergeExtension(TButtonThemeData)` 覆盖构造器未传项 |
| `variant: fill` ≠ `shape: filled` | 二者正交，勿混测为同一维度 |

**Golden**（[testing.md §4](../../guide/testing.md#4-golden) 优先组件）：默认 · primary · danger · disabled · 纯 `icon` + `shape: circle` 至少 5 张。

**Example**：

- 覆盖 §1 全 `variant` / `colorScheme` / `size` 矩阵（现有 demo 分组对齐）
- **§2.1**：通栏用外层 `SizedBox`/`Padding` 示例，**勿**在 `TButton` 上暴露 `isBlock`
- `onLongPress` 以外包 `GestureDetector` 示例（0.2 已移除构造器参数）

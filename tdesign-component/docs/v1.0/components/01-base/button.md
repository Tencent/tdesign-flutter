# TButton — v1.0 定稿

> Sprint **S1** | 控制类 **A** · 源码：`lib/src/components/button` · [guide](../guide/developer-guide.md)

**读法**：API → **§1**；Theme → **§2**；落地与验收 → **§3**

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

**style**：`*Style` 色板（P2，无 `shape`）→ resolve `ButtonStyle`（含 §1.2 内部 `textStyle`）→ P0 `style` 覆盖。`shape` 配 Theme，展开进 resolved `ButtonStyle`，不写入 `*Style`。

---

## 1. v1.0 定稿 API（当前规范）

层级 → [api.md §1](../../foundation/api.md#1-构造器四层l1l4)

### 构造器

| 决策 | 参数 / 方法 | 层级 | 类型 | 默认 | 说明 |
| --- | --- | --- | --- | --- | --- |
| | `child` | L2 | `Widget?` | — | 内容；推荐 `TText('…')`；见 **§1.2 文案 / TextStyle** |
| | `size` | L1 | `TButtonSize` | `medium` | 未传用 `defaultSize` |
| ✏️ | `variant` | L1 | `TButtonVariant?` | `defaultVariant` | fill · outline · text · ghost |
| ✏️ | `colorScheme` | L1 | `TButtonColorScheme?` | Theme | defaultTheme · primary · danger · light |
| 🔀 | `icon` | L2 | `Widget?` | — | 见 **§1.1 icon 行为** |
| | `iconPosition` | L1 | `TButtonIconPosition` | `left` | |
| ✏️ | `onPressed` | L3 | `VoidCallback?` | — | `null` 禁用 |
| ✨ | `style` | P0 | `ButtonStyle?` | — | 覆盖 resolve；非日常配 `shape`（§2.5） |

#### §1.1 icon 行为

| `icon` 传入 | 尺寸 / 颜色 |
| --- | --- |
| `Icon` 未设 `size` / `color` | 组件按 `size` + 前景色补齐 |
| `Icon` 已设 `size` / `color` | 以传入为准 |
| 自定义 `Widget` | 调用方自管 |

#### §1.2 文案 / TextStyle

**分工**：`TButton` 管按钮皮（variant / colorScheme / size / shape / 禁用）；**字形**默认由 resolve **内部**按 `size` 写入 `ButtonStyle.textStyle`（**不对外暴露** `textStyle` / `disableTextStyle` API）。推荐 `child: TText('…')`；富文本、远程字体等走 [TText](./text.md)。

与 §1.1 `icon` 对称：

| `child` 传入 | 字形 / 颜色 |
| --- | --- |
| `TText` / `Text` 未设 `font` / `style` / `textColor` | 组件按 `size` 补默认 **TextStyle**（Token 字体）；颜色由 `foregroundColor` 下发（含禁用） |
| `TText` 已设 `font` / `style` / `textColor`，或 `Text` 已设 `style` | 以传入为准 |
| 自定义 `Widget` | 调用方自管 |

**`size` → 默认字体 Token**（resolve 内部，实现于 `t_button_resolve.dart`）：

| `TButtonSize` | 默认 `Font` Token |
| --- | --- |
| `large` | `fontBodyLarge` |
| `medium` | `fontBodyMedium` |
| `small` | `fontBodySmall` |
| `extraSmall` | `fontBodyExtraSmall` |

**正常 / 禁用**：不设两套公开 `TextStyle` API。

| 态 | 字形 | 颜色 |
| --- | --- | --- |
| 正常（`onPressed` 非 null） | 上表按 `size` | `foregroundColor` ← `variant` × `colorScheme` × Token |
| 禁用（`onPressed: null`） | 与正常态相同（字号/字重不变） | `foregroundColor` ← `WidgetState.disabled`（如 `textDisabledColor`；ghost 等 variant 走 resolve 特例） |

`ElevatedButton` 将 `foregroundColor` 合并进子树 `DefaultTextStyle`，故 **禁用变灰不靠 `disableTextStyle` 构造器**，而靠 A 类 `onPressed: null`。若设计稿要求禁用态额外改字重/透明度，仅在 resolve 的 `textStyle` **`WidgetState.disabled` 分支**内处理（不新增 Theme 字段）。

**覆盖优先级**（后者赢）：

```
TText.style / TText.font / Text.style  >  resolve 内部 textStyle（按 size）  >  Material labelLarge
Text.style.color / TText.textColor     >  foregroundColor（含 disabled）
P0 style: ButtonStyle?                 >  上述 resolve 结果
```

**示例**：

```dart
// 推荐：默认字形 + 颜色均由 Button 内补
TButton(
  size: TButtonSize.large,
  colorScheme: TButtonColorScheme.primary,
  onPressed: _submit,
  child: TText('提交'),
)

// 裸 Text 可用，同样继承 Button 默认 TextStyle
TButton(child: Text('确定'), onPressed: _submit)

// 特例：单颗按钮改字形
TButton(
  onPressed: _submit,
  child: TText('删除', font: context.tTheme.fontTitleSmall),
)

// 禁用：仅 onPressed: null，文案自动走 disabled 前景色
TButton(child: TText('提交'), onPressed: null)
```

### 类型

| 决策 | 类型 | 成员 | 用于 |
| --- | --- | --- | --- |
| | `TButtonSize` | large · medium · small · extraSmall | `size` |
| | `TButtonIconPosition` | left · right | `iconPosition` |
| ✏️ | `TButtonVariant` | fill · outline · text · ghost | `variant` |
| ✏️ | `TButtonColorScheme` | defaultTheme · primary · danger · light | `colorScheme` |
| ✨ | `TButtonThemeData` | ThemeExtension | §2 |

### export

| 符号 | 说明 |
| --- | --- |
| `TButton` | 按钮 Widget |
| `TButtonProps` | 供组合组件透传的按钮配置 |
| `TButtonSize` | 尺寸枚举 |
| `TButtonVariant` | 形态枚举 |
| `TButtonColorScheme` | 语义色枚举 |
| `TButtonIconPosition` | 图标位置枚举 |
| `TButtonThemeData` | ThemeExtension |

---

## 2. Theme

✨ `TButtonThemeData` = 子树默认；未传构造器项由此补全 · [theme.md](../../foundation/theme.md)

| 场景 | 配置位置 | 范围 |
| --- | --- | --- |
| 单颗 | §1 构造器（含 P0 `style`） | 该实例 |
| 一区 | `mergeExtension(TButtonThemeData(...))` | 子树 |
| 全局 | `MaterialApp.theme` + Token | 全 App |

**覆盖顺序**：P0 `style` **>** resolve（§2.5）**>** Token

单颗破例：§1 ✨ `style`，不必改 Theme。

| 决策 | 字段 | 管什么 |
| --- | --- | --- |
| ✨ | `defaultVariant`、`defaultSize` | 未传 `variant` / `size` 时的默认值 |
| 📦 | `filledStyle` · `outlinedStyle` · `textButtonStyle` · `ghostStyle` | **P2** 色板；默认 Token + `colorScheme`；**无** `shape` |
| 📦 | `shape` | 五档外形 → §2.5 展开进 resolved `ButtonStyle` |
| 📦 | `padding` | 显式值覆盖 §2.5 推导 padding |
| 📦 | `margin` | 外边距 |
| 📦 | `iconSpacing` | 图标文案间距 |
| 📦 | `gradient` | 装饰层（非 `ButtonStyle` 字段） |

> **文案 / TextStyle 不进 Theme 公开字段**：默认字形与禁用色由 resolve 内 `ButtonStyle.textStyle` + `foregroundColor`（`WidgetStateProperty`）承担，规则见 **§1.2**。

### 2.5 `shape` 解析

内置五档外形：轮廓 · square/circle 等宽高 · padding 模式 · `filled` 居中 · outline/ghost 减 `side.width`。展开进 resolved `ButtonStyle`，覆盖 M3 默认。

| 内部 `shape` | `ButtonStyle.shape` |
| --- | --- |
| `rectangle` · `square` | `RoundedRectangleBorder(radius: radiusDefault)` |
| `round` | `StadiumBorder()` 或 `radiusRound` |
| `circle` | `CircleBorder()` 或 `radiusRound` 裁圆 |
| `filled` | `BorderRadius.zero`（≠ `variant: fill`） |

**square / circle**（推荐纯 `icon`；不与全宽父约束混用）：

| `size` | 边长 | 等边 padding |
| --- | --- | --- |
| large | 48 | 12 |
| medium | 40 | 10 |
| small | 32 | 7 |
| extraSmall | 28 | 5 |

**resolve**：`variant` → 控件 + 色板 → `colorScheme` → `shape`+`size`（含 §1.2 内部 `textStyle`）→ 扩展层 → P0 `style`

**冲突优先级**（后者赢）：`shape` §2.5 → `*Style` → P0 · `minimumSize` / `textStyle` `size`/§1.2/§2.5 → `*Style` → P0 · `padding` §2.5 → Theme `padding` → P0 · 颜色 `colorScheme` → `*Style` → P0 · 文案显式 `TText`/`Text.style` → resolve 内 `textStyle`（§1.2）

---

## 3. 实现约定

> 全局测试门槛 → [testing.md](../../guide/testing.md)（Tier1 Widget、Golden、覆盖率）。本节为 **TButton 专项**验收表。

### 4.1 单路径 resolve

| 文件（规划） | 职责 |
| --- | --- |
| `t_button.dart` | Widget；委托 resolve |
| `t_button_resolve.dart` | **唯一** `ButtonStyle` merge 入口（§2.5 优先级） |
| `t_button_theme_data.dart` | ThemeExtension |

**约束**：`build` 内禁止内联 variant/colorScheme/shape merge；§2.5 冲突优先级须在 `resolve` 单测覆盖。

### 4.2 测试与 Example 契约

| 必测 | 断言 |
| --- | --- |
| A 类禁用 | `onPressed: null` → 不可点；**无** `disabled` 构造器 |
| `variant` × `colorScheme` | fill / outline / text / ghost × 至少 primary、defaultTheme 各一态 |
| §1.1 `icon` | 未设 `size`/`color` 时按 `size` 补齐；已设则尊重传入 |
| §1.2 文案 | 未设 `font`/`style`/`textColor` 时按 `size` 补 Token 字体；`onPressed: null` 时前景色走 disabled |
| `iconPosition` | left / right 布局 |
| §2.5 `shape` | rectangle · round · square · circle · filled 展开进 `ButtonStyle.shape` |
| `size` | large / medium / small / extraSmall → §2.5 等边 padding / `minimumSize` |
| P0 `style` | 实例 `style` 覆盖 Theme resolve |
| Theme 子树 | `mergeExtension(TButtonThemeData)` 覆盖构造器未传项 |
| `variant: fill` ≠ `shape: filled` | 二者正交，勿混测为同一维度 |

**Golden**（[testing.md §4](../../guide/testing.md#4-golden) 优先组件）：默认 · primary · danger · disabled · 纯 `icon` + `shape: circle` 至少 5 张。

**Example**：

- 覆盖 §1 全 `variant` / `colorScheme` / `size` 矩阵（现有 demo 分组对齐）
- 全宽按钮用外层 `SizedBox`/`Padding` 示例，`TButton` 不提供通栏参数
- 长按等扩展交互以外包 `GestureDetector` 示例

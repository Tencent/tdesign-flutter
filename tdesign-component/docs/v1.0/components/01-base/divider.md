# TDivider — v1.0 定稿

> Sprint **S2** | 控制类 **—**（纯展示）· **Tier T3** 自绘 · 源码：`lib/src/components/divider` · [guide](../guide/developer-guide.md)

**读法**：新写 v1.0 → **§1**（语义 + **§3**）；0.2.x 升级 → **§2**（跨端对齐见 §1；L4 见 §3 末列）；落地与验收 → **§4**

**图例** → [component-doc.md §4](../../guide/component-doc.md#4-决策图例固定-6-个不新增)（§1–§3「决策」列）

**跨端对照**：`layout` · `align` · `dashed` · `child`（≈ React `content` / `children`）

---

## 架构

**T3 自绘**（**不**包装 Material `Divider` Widget）· 实线 `Container`、虚线 `CustomPaint`、水平带文案 `Row` + 自绘线段 · 纯展示无受控/禁用

**公开面收敛**：构造器仅 **4 项**（`layout` / `align` / `dashed` / `child`），对齐 React/Vue Divider；色、线粗、间距等 L4 → `TDividerThemeData`（§3）。

**与 Material 的关系**：resolve 默认值 **对齐** `DividerTheme` / Token（P2 回退），非 Widget 委托。0.2 `height` = 线粗 → v1.0 Theme **`thickness`**（≠ Material `Divider.height` 占位高度）。

---

## 1. v1.0 定稿 API（当前规范）

> 以下为 v1.0 **当前制定**的公开 API；相对 0.2.x 的变更见 §2。无图例项 = 与 0.2.x 同名同义保留（本组件 §1 项均有图例或为 ✨ 新增）。

层级 → [api.md §1](../../foundation/api.md#1-构造器四层l1l4)

### 构造器

| 决策 | 参数 / 方法 | 层级 | 类型 | 默认 | 说明 |
| --- | --- | --- | --- | --- | --- |
| ✨ | `layout` | L1 | `TDividerLayout` | `horizontal` | 横/竖分割线；见 **§3.5** 约束 |
| ✏️ | `align` | L1 | `TDividerAlign` | `center` | 中间内容在线条中的位置；**仅** `layout: horizontal` |
| ✏️ | `dashed` | L1 | `bool` | `false` | 虚线；**仅** `layout: horizontal` |
| 🔀 | `child` | L2 | `Widget?` | — | 中间子元素（≈ 跨端 `content`）；纯文案用 `Text('…')`；见 **§1.1** |

#### §1.1 `child` 与 `layout`

| `layout` | `child` | `align` / `dashed` | 行为 |
| --- | --- | --- | --- |
| `horizontal` | `null` | 任意 | 纯横线（§3.5 模式 A） |
| `horizontal` | 有 | `align` 生效；可 `dashed` | 横线 + 中间区（模式 B） |
| `vertical` | 任意 | **忽略** | 纯竖线；**不渲染** `child`（对齐跨端） |

### 类型

| 决策 | 类型 | 成员 | 用于 |
| --- | --- | --- | --- |
| ✨ | `TDividerLayout` | horizontal · vertical | `layout` |
| ✏️ | `TDividerAlign` | left · center · right | `align` |
| ✨ | `TDividerThemeData` | ThemeExtension | §3 |

### export

| 决策 | 符号 | 说明 |
| --- | --- | --- |
| 🚫 | `TextAlignment` | ✏️ → `TDividerAlign` |

[附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) · 替换细节 §2

---

## 2. 0.2.x → v1.0

**未改**：无（公开 API 按跨端重定）

### ✏️ 改名

| 0.2.x | v1.0 | 怎么改 |
| --- | --- | --- |
| `alignment` / `TextAlignment` | `align` / `TDividerAlign` | 换名，成员对应 |
| `isDashed` | `dashed` | 换名 |
| 构造器 `height` | `TDividerThemeData.thickness` | 线粗迁入 Theme |

### 🔀 合并

| 0.2.x | v1.0 | 怎么改 |
| --- | --- | --- |
| `text` + `widget` | `child` | 删双通道；`text: '…'` → `child: Text('…')` |

### 🗑️ 移除

| 0.2.x | v1.0 | 怎么改 |
| --- | --- | --- |
| `direction` | `layout` | 0.2 仅虚线绘制轴；v1.0 **`layout` 表横/竖形态**（✨ 新语义，非一对一改名） |
| `width` | — | 竖线线宽由 Theme `thickness` + `layout: vertical` 决定 |
| `hideLine` | — | 无等价；仅中间区请自定义 `child` 或外层布局 |

### 📦 迁入 Theme · ✨ 新增

- **📦** `color`、`textStyle`、`margin`、`gapPadding`、`height`（→ **`thickness`**）→ `TDividerThemeData`（见 **§3** 末列）
- **✨** `layout`、`TDividerLayout`、`TDividerAlign`、`TDividerThemeData` — 见 §1 / §3
- **实现**：T3 自绘单路径；竖线 `layout: vertical` 为 v1.0 一等能力（0.2 无等价构造参数）

---

## 3. Theme

✨ `TDividerThemeData` = 子树默认；构造器未传的 L4 由此补全 · [theme.md](../../foundation/theme.md)

| 场景 | 配置位置 | 范围 |
| --- | --- | --- |
| 单颗 | §1 构造器 L1/L2 | 形态与中间内容 |
| 一区 | `mergeExtension(TDividerThemeData(...))` | 子树 |
| 全局 | `MaterialApp.theme` + Token | 全 App |

**覆盖顺序**：§1 L1/L2 **>** `TDividerThemeData`（P1）**>** `DividerTheme`（P2，仅默认回退）**>** Token（P4）

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
| --- | --- | --- | --- |
| 📦 | `color` | 线条色；透明 + 较大 `thickness` 可作间距块 | `color` |
| 📦 | `thickness` | 线粗/线宽：横线=高度，竖线=宽度（默认 `0.5`） | `height` / `width` |
| 📦 | `margin` | 外边距 | `margin` |
| 📦 | `gapPadding` | 线与中间内容间距（默认 `horizontal: 8`） | `gapPadding` |
| 📦 | `textStyle` | `child` 为默认文案时的样式 | `textStyle` |
| | `indent` / `endIndent` | 对齐 Material `DividerTheme` 语义；按需扩展 | — |

### 3.5 绘制契约（T3 单路径）

**跨端约束**（与 React Divider 一致）：`dashed`、`align`、`child` 仅在 `layout == horizontal` 生效；`vertical` 时强制实线、不绘中间区。

| 模式 | 条件 | 绘制 |
| --- | --- | --- |
| **A** 纯线 | `child == null` | 单段线：横线 `dashed` ? `CustomPaint` : `Container`；竖线 `Container` 填色 |
| **B** 线 + 中间 | `layout: horizontal` 且 `child != null` | `Row`：`align` 决定左右线长；线段同模式 A |

**虚线**：仅模式 A/B 横线；`DashedPainter` 轴向由 `layout` 推导（竖线不支持虚线）。

**间距块**（0.2 Dialog 等）：Theme `color: transparent` + 较大 `thickness` — 模式 A，不另开 API。

**resolve**：`layout` 选形态 → L1/L2 选模式 → `TDividerThemeData` 补 L4 → 回退 `DividerTheme` / Token

---

## 4. 实现约定

> 全局测试门槛 → [testing.md](../../guide/testing.md)。本节为 **TDivider 专项**验收表。

### 4.1 单路径绘制

| 文件（规划） | 职责 |
| --- | --- |
| `t_divider.dart` | Widget；选模式 A/B（§3.5） |
| `t_divider_painter.dart` | 虚线 `CustomPaint`（仅横线） |
| `t_divider_theme_data.dart` | ThemeExtension |

**约束**：**不**包装 Material `Divider` Widget；横/竖/虚线/带 `child` 仅 §3.5 两模式，禁止第二套绘制分支。

### 4.2 测试与 Example 契约

| 必测 | 断言 |
| --- | --- |
| §1.1 `layout` × `child` | 水平纯线 · 水平+中间区 · 竖线；竖线 **不渲染** `child` |
| `align` | left / center / right 仅 `layout: horizontal` + `child != null` |
| `dashed` | 仅横线；竖线强制实线 |
| `vertical` 忽略 | `align` / `dashed` / `child` 在 `layout: vertical` 时无效 |
| Theme `thickness` | 横线=高度、竖线=宽度 |
| Theme `color` | 线条色；透明 + 大 `thickness` 间距块（§3.5） |
| Theme `gapPadding` | 模式 B 线与 `child` 间距 |
| resolve 优先级 | §1 L1/L2 **>** `TDividerThemeData` **>** `DividerTheme` **>** Token |
| 0.2 迁移 | `height`→`thickness`；`text`/`widget`→`child` |

**Golden**（可选，优先级低于 Button）：水平实线 · 水平虚线 · 水平带文案三 `align` · 竖线。

**Example**：

- 覆盖 §1.1 表格四种语义（含 `vertical` + 误传 `child` 不展示）
- 横线 `dashed: true` 与 `align` 三档分开展示
- 竖线在 `Row` 内定高场景（非横排假布局）

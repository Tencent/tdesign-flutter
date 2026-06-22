# TBackTop — v1.0 定稿

> Sprint **S3** | 控制类 **A** · **Tier T2** · 源码：`lib/src/components/backtop` · [guide](../../guide/developer-guide.md)

**读法**：新写 v1.0 → **§1**（配样式 + **§3**）；0.2.x 升级 → **§2**（L4 见 §3 末列）；落地与验收 → **§4**

**图例** → [component-doc.md §4](../../guide/component-doc.md#4-决策图例固定-6-个不新增)（§1–§3「决策」列）

**跨端对照**：绑定滚动回顶 · `shape`（圆形 / 半圆）· `theme` 明暗 · `showText`；与 [TFab](../01-base/fab.md) 区分（Fab 通用悬浮操作，BackTop 专用于回顶）

---

## 架构

**T2 自绘**：`GestureDetector` + `Container` 双形态（`circle` / `halfCircle`）· 监听 `controller` 偏移控制显隐 · 点击默认 `controller.animateTo(0)` 后触发 `onPressed` · A 类 `onPressed: null` = 禁用 · L4（`shape` / `colorScheme` / 默认阈值等）→ `TBackTopThemeData`（§3）

0.2.x 显隐由页面外层 `ScrollController.addListener` 承担；v1.0 内置 `visibilityOffset`（仍可外包 `Visibility` 做动画，非必须）。

---

## 1. v1.0 定稿 API（当前规范）

> 以下为 v1.0 **当前制定**的公开 API；相对 0.2.x 的变更见 §2。无图例项 = 与 0.2.x 同名同义保留。

层级 → [api.md §1](../../foundation/api.md#1-构造器四层l1l4)

### 构造器

| 决策 | 参数 / 方法 | 层级 | 类型 | 默认 | 说明 |
| --- | --- | --- | --- | --- | --- |
| | `controller` | L1 | `ScrollController?` | — | 页面滚动控制器；有 clients 时点击先回顶 |
| | `showText` | L2 | `bool` | `false` | 是否展示文案（i18n 走 `context.resource`） |
| ✏️ | `onPressed` | L3 | `VoidCallback?` | — | `null` 禁用；未传时回顶后无额外回调 |
| ✨ | `visibilityOffset` | L1 | `double?` | Theme `defaultVisibilityOffset` | 绑定 `controller` 时，偏移 ≥ 阈值才显示 |
| ✨ | `tooltip` | L2 | `String?` | — | 读屏 / `Tooltip` 提示；未传时可回退资源文案 |

#### §1.1 点击与回顶

| 条件 | 行为 |
| --- | --- |
| `onPressed == null` | 不可点（A 类禁用） |
| `controller` 有效 | 防抖后 `animateTo(0)`，再调 `onPressed` |
| `controller` 为 `null` 或无 clients | 仅调 `onPressed`（若有） |
| 自定义回顶逻辑 | 构造器传 `onPressed`，内部仍先执行默认滚动（与 0.2 `onClick` 并存语义一致） |

### 类型

| 决策 | 类型 | 成员 | 用于 |
| --- | --- | --- | --- |
| ✏️ | `TBackTopShape` | circle · halfCircle | Theme `shape` |
| ✏️ | `TBackTopColorScheme` | light · dark | Theme `colorScheme` |
| ✨ | `TBackTopThemeData` | ThemeExtension | §3 |

### export

| 决策 | 符号 | 说明 |
| --- | --- | --- |
| 🚫 | `TBackTopStyle` | ✏️ → `TBackTopShape` |
| 🚫 | `TBackTopTheme`（enum） | ✏️ → `TBackTopColorScheme`（Theme `colorScheme`） |

[附录 C](../../v1.0-redesign-spec.md#附录-cexport-审计表) · 替换细节 §2

---

## 2. 0.2.x → v1.0

**未改**（§1 无图例项）：`controller`、`showText`

### ✏️ 改名

| 0.2.x | v1.0 | 怎么改 |
| --- | --- | --- |
| `onClick` | `onPressed` | 换名；`null` 表禁用（0.2 无禁用语义） |
| `style` / `TBackTopStyle` | `shape` / `TBackTopShape` | 枚举换名；**构造器删除**，改 Theme `shape` |
| `theme` / `TBackTopTheme` | `colorScheme` / `TBackTopColorScheme` | 枚举换名；**构造器删除**，改 Theme `colorScheme` |

### 📦 迁入 Theme · ✨ 新增

- **📦** `style`、`theme` → `TBackTopThemeData`（字段见 **§3** 末列）
- **✨** `visibilityOffset`、`tooltip`、`TBackTopThemeData` — 见 §1 / §3；显隐阈值吸收 example 中硬编码 `offset >= 100`

### 布局迁移（0.2 demo 外包）

| 0.2.x | v1.0 |
| --- | --- |
| 页面 `ScrollController.addListener` + `setState` 控制显隐 | 优先用构造器 `visibilityOffset` + 内置监听；复杂动画可继续外包 |
| `halfCircle` 用 `Positioned(right: -16, …)` 贴边 | 半圆形态仍可能需外层 `Positioned` 贴右；偏移默认值见 **§3** `halfCircleRightInset` |
| `floatingActionButton` 槽位放 `TBackTop` | 仍可用；或 `Stack` + 内置显隐 |

---

## 3. Theme

✨ `TBackTopThemeData` = 子树默认；未传构造器项由此补全 · [theme.md](../../foundation/theme.md)

| 场景 | 配置位置 | 范围 |
| --- | --- | --- |
| 单颗 | §1 构造器（`visibilityOffset` / `tooltip` / `showText`） | 该实例 |
| 一区 | `mergeExtension(TBackTopThemeData(...))` | 子树 |
| 全局 | `MaterialApp.theme` + Token | 全 App |

**覆盖顺序**：构造器 `visibilityOffset` **>** Theme `defaultVisibilityOffset` · Token 配色

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
| --- | --- | --- | --- |
| 📦 | `shape` | `circle` / `halfCircle` 外形 | `style` |
| 📦 | `colorScheme` | `light` / `dark` 背景与描边 Token | `theme` |
| ✨ | `defaultVisibilityOffset` | 未传 `visibilityOffset` 时的显示阈值 | —（demo 硬编码 100） |
| ✨ | `defaultRight` · `defaultBottom` | 右下角默认偏移（对齐 [Fab §4.2](../01-base/fab.md#42-与-backtop-共用定位后续) 规划） | — |
| ✨ | `halfCircleRightInset` | 半圆贴右负 inset（吸收 0.2 `right: -16`） | — |

`showText` 留在 **实例**（§1）；文案内容走 i18n 资源，不进 Theme。

---

## 4. 实现约定

> 全局测试门槛 → [testing.md](../../guide/testing.md)。本节为 **TBackTop 专项**验收表。

### 4.1 模块职责

| 文件（规划） | 职责 |
| --- | --- |
| `t_backtop.dart` | Widget；形态分支 + 显隐 + 点击防抖 |
| `t_backtop_theme_data.dart` | ThemeExtension |
| `t_backtop_visibility.dart`（可选） | `controller` 偏移监听；与 Widget 解耦便于单测 |

**约束**：配色从 `TBackTopThemeData.colorScheme` + Token resolve；**禁止**在 `build` 内硬编码 0.2 `TTheme.of` 分支。右下角偏移可与 Fab 共用内部 `floating_anchor`（不 export，见 [fab.md §4.2](../01-base/fab.md#42-与-backtop-共用定位后续)）。

### 4.2 测试与 Example 契约

| 必测 | 断言 |
| --- | --- |
| A 类禁用 | `onPressed: null` → 不可点 |
| `shape` | `circle` / `halfCircle` 布局与 0.2 视觉等价 |
| `showText` | `true` / `false` 文案显隐 |
| `visibilityOffset` | 绑定 `controller` 时阈值内外显隐 |
| 回顶 | `controller` 有效 → `animateTo(0)`；防抖不重复触发 |
| `onPressed` | 自定义回调在默认滚动后触发 |
| Theme 子树 | `mergeExtension(TBackTopThemeData)` 覆盖 `shape` / `colorScheme` / 默认阈值 |
| `colorScheme` | `light` / `dark` Token 与 0.2 明暗主题对齐 |

**Golden**：`circle` · `halfCircle` × `showText` on/off × `light`/`dark` 至少 4 张。

**Example**：

- 覆盖 §1 `visibilityOffset` 内置显隐（**勿**再手写 listener 为主路径）
- `halfCircle` 贴边示例保留 `Positioned` 或 Theme `halfCircleRightInset`
- 与 [TFab](../01-base/fab.md) 同页并存时区分回顶 vs 通用操作

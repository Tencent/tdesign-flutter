# TNavBar — v1.0 定稿

> **状态**：已定稿 | **控制类**：A | **Sprint**：S3
> **源码**：`lib/src/components/navbar/` · **类名**：`TNavBar`
> **官网**：[Navbar 导航栏](https://tdesign.tencent.com/flutter/components/navbar) · [guide](../../guide/developer-guide.md)

**读法**：按 **§1** 查看当前 v1 API，按 **§2** 配置主题，按 **§3** 落地测试与 Example。

**图例** → [component-doc.md §4](../../guide/component-doc.md#4-决策图例固定-6-个不新增)（§1–§3「决策」列）

- [§1 v1.0 定稿 API](#1-v10-定稿-api)
- [§2 Theme 主题配置](#2-theme-主题配置)
- [§3 实现约定 · 测试与 Example 契约](#3-实现约定--测试与-example-契约)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | `NavigationToolbar` 薄包装 |
| 布局 | **左 · 中 · 右**；默认布局见 **§1.1.0**；左右 Items + 插槽 |
| 命名 | `leadingItems` / `leading` · `actionsItems` / `actions`（对称）；**Items** = `List<TNavBarItem>`，**插槽** = `Widget?` |
| Theme | `TNavBarThemeData`（§2）；标题样式 **仅 Theme** |
| 禁用 | 默认返回：`onBack: null`；隐藏返回：`leadingItems: []`；Items：`TNavBarItem.action: null` |
| L4 | → `TNavBarThemeData`；构造器不留 L4 |

## 控制方案

控制类 **A**：`onBack` / `TNavBarItem.action` 对齐 `onPressed` — `null` 禁用（不可点）；非 `null` 为点击回调。默认返回钮**显隐**由左区配置（`leadingItems` / `leading`），与 `onBack` 分离。**不提供** `value` / `onChanged`。

→ [controlled.md](../../foundation/controlled.md)

---

## §1 v1.0 定稿 API

> 以下为 v1.0 **当前制定**的公开 API。左右 **Items（结构化列表）** 与 **插槽（自由 Widget）** 分层；见 §1.1.1。

层级 → [api.md §1](../../foundation/api.md#1-构造器四层l1l4)

> **P0 逃逸舱**：无。本组件不提供 `style` / `decoration` 逃逸舱（四问判定见 [theme.md §2.2](../../foundation/theme.md#22-p0-逃逸舱判定)）；单颗差异用子树 `mergeExtension`（`TNavBarThemeData`）。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 说明 |
|------|------|------|------|------|
| | `leadingItems` | `List<TNavBarItem>?` | L2 | 左侧标准动作项列表 |
| ✨ | `leading` | `Widget?` | L2 | **左插槽**（自由 Widget；**非** Items 列表） |
| 🔀 | `title` | `Widget?` | L2 | 中部标题插槽 |
| ✏️ | `belowTitle` | `Widget?` | L2 | 标题下方扩展插槽 |
| ✏️ | `actionsItems` | `List<TNavBarItem>?` | L2 | 右侧标准动作项列表 |
| ✨ | `actions` | `Widget?` | L2 | **右插槽**（自由 Widget；**非** Items 列表） |
| | `onBack` | `VoidCallback?` | L3 | 默认返回钮点击；`null` 禁用（A 类）；非 `null` 执行业务回调（需 pop 时在回调内处理） |

> **不提供** `flexibleSpace`（§1.1.4）。样式 → `TNavBarThemeData` + `mergeExtension`（禁止构造器 `themeData`）。

#### §1.1.0 默认布局

##### v1.0 默认布局契约

**Widget 树**（无 `belowTitle` 时）：

```text
Container（高 48 + padding · 背景 · 阴影）
└─ NavigationToolbar
   ├─ leading:  Row [ 默认返回? | leadingItems? | leading? ]
   ├─ middle:   title
   └─ trailing: Row [ actionsItems | actions ]
```

有 `belowTitle` 时：`Column` → `Expanded(NavigationToolbar)` + `belowTitle`（`crossAxisAlignment: start`）。

**默认值**（未传即生效）：

| 参数 | 默认值 |
|------|--------|
| `leadingItems` / `leading` | `null` |
| `actionsItems` / `actions` | `null` |
| `title` | `null` → 渲染空标题 |
| `belowTitle` | `null` |
| L4 样式 | 不走构造器，走 `TNavBarThemeData` resolve 链 |

**零配置示例**：`TNavBar(title: Text('页面标题'))`

```text
┌──────────────────────────────────────────────────────────┐
│  ←   │        页面标题（居中）        │      （空）      │
└──────────────────────────────────────────────────────────┘
```

| 维度 | v1.0 默认布局 | resolve 链 |
|------|---------------|------------|
| **左区** | 默认显示返回钮；`leadingItems` 有内容且未传 `leading` 时接在返回钮后面；`leading` 插槽传入后左区由插槽自管 | 返回：`TIcons.chevron_left` · `iconSize: 28` · `backIconColor` → `textColorPrimary` |
| **中区** | `title` 默认居中；文本标题单行省略 | 文案路径：`fontBodyLarge` · `FontWeight.w500` · `titleColor` → `textColorPrimary` |
| **右区** | `actionsItems == null` 且 `actions == null` → 空 | — |
| **标题间距** | `middleSpacing` | `titleMargin` → **16** |
| **栏高** | `preferredSize` | `height` → **48** |
| **栏 padding** | 容器内边距 | `spacer16` 水平 · `spacer4` 垂直 |
| **背景** | `Container` 底色 | `backgroundColor` → `bgColorContainer`；`opacity` → **1** |
| **边框模式** | 关 | `useBorderStyle` → **false**；为 true 时 Items 外包圆角描边 + 项间竖线 |
| **安全区** | 组件内**不**处理 | 页面外层 `SafeArea` / 容器处理 |
| **返回点击** | `onBack` 非 `null` 时执行回调；`onBack: null` 时钮不可点 | 隐藏返回用 `leadingItems: []`；禁用返回用 `onBack: null` |

**`TNavBarItem` 默认**：`iconSize: 24`；左 Items `padding.right = spacer8`，右 Items `padding.left = spacer8`；`icon: Widget?` 为空时不渲染图标。

**关闭默认返回**：

| 场景 | 写法 | 左区渲染 |
|------|------|----------|
| 默认 | `leadingItems == null` 且 `leading == null` | 默认返回 |
| 默认返回 + 左 Items | `leadingItems: […]` | 默认返回 + Items |
| 不要返回 | `leadingItems: []` 且无 `leading` | 空 |
| 完全自定义左区 | `leading: Widget` | 插槽自管 |

**`leadingItems: null` vs `[]`**（`leading: null` 时）— 非 Theme 差异，是**左区有无占位**：

| | `leadingItems` 未传（`null`） | `leadingItems: []` |
|---|---|---|
| 左区 | 默认 `←`（28px + 间距） | **空**，宽 0 |
| 标题 | 居中，为返回钮让出左宽 | 居中，左无占位 |
| 典型 | 内页、零配置 | Tab 根页、搜索型 |

```text
null：  │ ← │    页面标题（居中）    │ （空） │
[]：    │        页面标题（居中）        │ （空） │
```

##### 与现网过渡实现的对应

现网 `t_nav_bar.dart` 已采用同一套默认布局骨架，但 API 名称与 v1.0 不同：

| 现网 | v1.0 |
|------|------|
| `useDefaultBack: true`（默认） | 默认显示返回 |
| `useDefaultBack: false` | `leadingItems: []` |
| `leading: List<TNavBarItem>` | `leadingItems` |
| `actions: List<TNavBarItem>` | `actionsItems` |
| `titleWidget ?? Text(title ?? '')` | `title: Widget?`（文本标题由组件示例/封装给出） |
| `centerTitle: true` | 默认居中；非居中由 `title` 自管 |
| L4 构造器字段 | `TNavBarThemeData` |

**宽度要求**（§4）：左右取固有宽；中间 `title` 区等价 **`Expanded`**，搜索框等宽内容必须吃满剩余宽。

**偏离默认**（v1.0）：

| 意图 | 做法 |
|------|------|
| 不要返回 | `leadingItems: []` |
| 右操作图标 | `actionsItems: […]` |
| 宽搜索 / 非居中 | `title: Widget?` 自管 |
| 左/右整块自定义 | `leading` / `actions` 插槽 |
| 栏样式 | `mergeExtension(TNavBarThemeData(...))` |

#### §1.1.1 Items 与插槽

| 槽位 | Items（`List<TNavBarItem>?`） | 插槽（`Widget?`） | 单项定制 |
|------|------------------------------|-------------------|----------|
| **左** | `leadingItems` | `leading` | Items 内 `TNavBarItem.icon: Widget?` |
| **中** | — | `title` · `belowTitle` | 整区 Widget（搜索框等） |
| **右** | `actionsItems` | `actions` | Items 内 `icon: Widget?` |

> v1.0 **拆分**过渡实现里同名的列表型 `leading` / `actions`：列表 → `*Items`；名称 `leading` / `actions` **专指插槽**（对齐 Material 区名，类型为 `Widget?`）。

**默认返回**：默认左区显示返回；未传 `leading` 且 `leadingItems` 有内容时接在返回钮后；`leadingItems: []` 表示显式关闭默认返回。

**`onBack` 与显隐分工**（A 类，对齐 `onPressed`）：

| 意图 | API | 效果 |
|------|-----|------|
| 不显示默认返回 | `leadingItems: []` 且无 `leading` | 左区无返回钮 |
| 显示但禁用 | `onBack: null` | 返回钮可见、不可点 |
| 自定义返回 | `onBack: () { … }` | 可点；pop 等业务在回调内处理 |
| 标准 pop | `onBack: () => Navigator.maybePop(context)` | 可点并执行 pop |

> 零配置 `TNavBar(title: …)` 展示默认可点返回时，等价于组件内建 `maybePop`；与**显式** `onBack: null`（禁用）区分由实现层保证（见 §4）。

| `leadingItems` | `leading` | 左区渲染（自左向右） |
|----------------|-----------|----------------------|
| `null` | `null` | 默认返回 |
| `[]` | `null` | 空 |
| 有 | `null` | 默认返回 + Items |
| `null` / `[]` | 有 | 插槽 `leading` 自管 |
| 有 | 有 | Items + 插槽 `leading`（左区自管） |

**右区组合**（自左向右）：

| `actionsItems` | `actions` | 右区渲染 |
|----------------|-----------|----------|
| `null` | `null` | 空 |
| 有 | `null` | 仅 Items |
| `null` | 有 | 仅插槽 |
| 有 | 有 | Items + 插槽（同一 `Row`） |

**移除** `useDefaultBack`：默认显示返回；`leadingItems: []` 且无 `leading` ↔ 不要返回。

**移除** `centerTitle`：中间默认居中；非居中 → `title` 自管布局。

**三槽宽度**（§4）：左右 Items + 插槽取**固有宽**；`title` **Expanded** 占剩余。

#### §1.1.2 典型场景

| 场景 | 左（Items / 插槽） | 中 | 右（Items / 插槽） | 要点 |
|------|-------------------|-----|-------------------|------|
| **零配置内页** | `null` / `null` → 默认返回 | `title` | `null` / `null` → 空 | `TNavBar(title: Text('页面标题'))` |
| **无返回左区** | `[]` / `null` → 空 | `title` 或宽 Widget | 按需 `actionsItems` | Tab 根页、占位给中区 |
| **标准右操作** | `null` / `null` → 默认返回 | `title` | `[icon…]` / `null` | 内页 + 右图标 |
| **搜索型** | `[]` / `null` | `title: TSearchBar(…)` | `[home, …]` / `null` | 见下节 |

```text
零配置内页：
│ ← │      页面标题      │          │

无返回左区（leadingItems: []）：
│        页面标题        │          │

标准右操作：
│ ← │      页面标题      │  🏠  ⋯  │

搜索型：
│    [ 搜索预设文案          ]    │  🏠  ⋯  │
```

**右区说明**（与左对称命名，**无**默认图标）：

| `actionsItems` | `actions` | 右区 |
|----------------|-----------|------|
| `null` | `null` | 空（零配置默认） |
| `[]` | `null` | 空（显式不要右 Items，与 `null` 视觉同） |
| 有 | `null` | 图标列表（`iconSize: 24`，项间 `spacer8`） |
| `null` / `[]` | 有 | 插槽自管 |
| 有 | 有 | Items + 插槽同一 `Row` |

#### §1.1.3 场景示例：搜索型 NavBar

| 区域 | Items | 插槽 |
|------|-------|------|
| 左 | — | —（v1.0：`leadingItems: []`；现网：`useDefaultBack: false`） |
| 中 | — | `title: TSearchBar(placeholder: '搜索预设文案', …)` |
| 右 | `[home, ellipsis]` | — |

`TNavBar(leadingItems: [], title: TSearchBar(…), actionsItems: […])`

#### §1.1.4 关于 `flexibleSpace`（v1.0 不提供）

栏背全宽层，**非**左/中/右槽；v1.0 不提供。

#### §1.1.5 过渡实现映射

| 过渡代码（列表误用同名） | v1.0 |
|--------------------------|------|
| `leading: List<TNavBarItem>` | `leadingItems` |
| `actions: List<TNavBarItem>` | `actionsItems` |
| — | `leading` / `actions` 释放为 **Widget 插槽** |

---

### 1.2 类型定义

#### TNavBarItem

| 决策 | 参数 | 类型 | 默认 | 说明 |
|------|------|------|------|------|
| 🔀 | `icon` | `Widget?` | — | 项级图标组件 |
| | `iconColor` | `Color?` | — | 项级图标色 |
| | `action` | `TBarItemAction?` | — | `null` 禁用 |
| | `iconSize` | `double?` | `24` | |
| | `padding` | `EdgeInsetsGeometry?` | — | |

#### 其他类型

| 类型 | 说明 |
|------|------|
| `TBarItemAction` | `void Function()` |
| `TNavBarThemeData` | ThemeExtension（§2） |

### 1.3 export

**公开 export**：`TNavBar` · `TNavBarItem` · `TBarItemAction` · `TNavBarThemeData`。

---


## §2 Theme 主题配置

`TNavBarThemeData` · [theme.md](../../foundation/theme.md)

| 范围 | 配置方法 |
|------|---------|
| 单颗 / 子树 / 全局 | `mergeExtension(TNavBarThemeData(...))` |

覆盖顺序：`P0`(无) **>** `P1` 组件 Theme（`TNavBarThemeData`）**>** `P2` Material `ToolbarTheme` / `AppBarTheme` **>** `P3` `ThemeData` **>** `P4` Token。

### 标题区（默认居中 `title` 路径）

自定义 `title` / `belowTitle` **不**走下列 resolve。

| 决策 | 字段 | 默认 |
|------|------|------|
| 📦 | `titleColor` | Token | 构造器 |
| 📦 | `titleFont` | Token | 构造器 |
| 📦 | `titleFontFamily` | Token | 构造器 |
| 📦 | `titleFontWeight` | `w500` | 构造器 |
| 📦 | `titleMargin` | `16` | 构造器 |

### 栏身与边框

| 决策 | 字段 |
|------|------|
| 📦 | `backgroundColor` / `height` / `padding` / `backIconColor` / `opacity` | 构造器 |
| 📦 | `useBorderStyle` / `border` / `boxShadow` | 构造器 / `TNavBarItemBorder` |

#### 字段归类：进 Theme 与不进 Theme

本组件为 Material `NavigationToolbar` 薄包装；已按 [theme.md §4](../../foundation/theme.md#4-material-vs-themeextension) 确认：布局骨架走 Material 子主题（P2），外观样式为 TDesign 扩展（P1）。

**进 Theme**
- P2（Material `ToolbarTheme` / `AppBarTheme`）：`NavigationToolbar` 布局（leading / middle / trailing 对齐展开）
- P1（`TNavBarThemeData`，TDesign 扩展）：`titleColor` · `titleFont` / `titleFontFamily` / `titleFontWeight` · `titleMargin` · `backgroundColor` · `height` · `padding` · `backIconColor` · `opacity` · `useBorderStyle` / `border` / `boxShadow`

**不进 Theme（构造器 L2/L3）**
- `onBack`（L3）· `leadingItems` / `leading` · `title` / `belowTitle` · `actionsItems` / `actions`（L2）

---

## §3 实现约定 · 测试与 Example 契约

### 三槽位宽度契约

| 槽位 | 规则 |
|------|------|
| **左** | 默认返回 + `leadingItems`，或 `leading` 插槽自管 → 固有宽；`leadingItems: []` 且无插槽 → 宽 0 |
| **中** | `title` **`Expanded`** |
| **右** | `actionsItems` + `actions` → 固有宽 |

### 默认返回与 `onBack`

| 场景 | 行为 |
|------|------|
| 展示默认返回 + 零配置 | 内建 `Navigator.maybePop`（可点） |
| `onBack: () { … }` | 仅执行回调，**不**自动 `maybePop` |
| `onBack: null` | 返回钮禁用（`GestureDetector.onTap: null` / 等价置灰） |
| `leadingItems: []` | 不渲染默认返回 |

**必测**：§1.1.0 默认布局 · `leadingItems: null` vs `[]` · §1.1.2 典型场景 · `onBack: null` 禁用 · 中间 `Expanded` · Theme。

**Example**：`leftBarItems`→`leadingItems` · `rightBarItems`→`actionsItems` · 过渡 `leading`/`actions` List→`*Items` · `titleWidget`→`title`。

> [api.md](../../foundation/api.md) · [controlled.md](../../foundation/controlled.md) · [testing.md](../../guide/testing.md)（类名以 **§1** 为准）

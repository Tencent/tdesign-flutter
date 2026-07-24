# TSideBar — v1.0 定稿

> **状态**：已定稿 | **控制类**：B | **Sprint**：S3
> **源码**：`lib/src/components/sidebar/` · **类名**：`TSideBar`
> **官网**：[SideBar 侧边栏](https://tdesign.tencent.com/flutter/components/side-bar) · [guide](../../guide/developer-guide.md)

**读法**：按 **§1** 查看当前 v1 API，按 **§2** 配置主题，按 **§3** 落地测试与 Example。

**图例** → [component-doc.md §4](../../guide/component-doc.md#4-决策图例固定-6-个不新增)（§1–§3「决策」列）

- [§1 v1.0 定稿 API](#1-v10-定稿-api)
- [§2 Theme 主题配置](#2-theme-主题配置)
- [§3 实现约定 · 测试与 Example 契约](#3-实现约定--测试与-example-契约)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 自绘侧边导航（纵向 `ListView`） |
| Material | 无等价薄包装 |
| Theme | `TSideBarThemeData`（§2） |
| 禁用 | 整栏：`onChanged: null`；单项：`TSideBarItem.disabled` |
| L4 | → `TSideBarThemeData`（§2） |

## 控制方案

控制类 **B**：**仅** `value` + `onChanged`；**`value` 必填**且由**父 State** 持有。用户点击 → `onChanged`；父组件 `setState` 回写 `value`。命令式切项由父 `setState` 改 `value`，**无** `Controller` 辅助 API。禁用：`onChanged: null`。

**Material 对照**：无同名 SideBar Widget；受控选中对齐 M3 `NavigationBar.selectedIndex` + `onDestinationSelected` / `NavigationRail`；API 统一为 `value` + `onChanged`（→ [controlled.md §1.1](../../foundation/controlled.md#11-导航选中b-类)）。**非** [TIndexes](./indexes.md) 式内部持态。

→ [controlled.md](../../foundation/controlled.md) · [form.md §2](../../foundation/form.md#2-字段桥接控制类--form-写法)

---

## §1 v1.0 定稿 API

> 以下为 v1.0 当前公开 API。L4 默认走 §2 Theme（`mergeExtension`）。

层级 → [api.md §1](../../foundation/api.md#1-构造器四层l1l4)

> **P0 样式覆盖**：`style`、颜色、`contentPadding`、`height` 可直接覆盖 Theme，适用于单颗 SideBar 的局部差异；可复用默认值仍应放入 `TSideBarThemeData`。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认 | 说明 |
|------|------|------|------|------|------|
| ✏️ | `value` | `int` | L1 | — | 当前选中项；**必填**；须匹配 `children` 中某项 |
| | `onChanged` | `ValueChanged<int>?` | L3 | — | 选中变化；与 `value` 成对；`null` 禁用整栏 |
| | `children` | `List<TSideBarItem>` | L2 | `[]` | 侧栏项 |
| | `style` | `TSideBarVariant?` | P0 | Theme / `normal` | `normal` 或 `outline` 形态 |
| | `selectedColor` / `unSelectedColor` | `Color?` | P0 | Theme / Token | 选中、未选中文字色 |
| | `selectedTextStyle` | `TextStyle?` | P0 | Theme | 选中文字样式 |
| | `selectedBgColor` / `unSelectedBgColor` | `Color?` | P0 | Theme / Token | 选中、未选中背景色 |
| | `contentPadding` | `EdgeInsetsGeometry?` | P0 | Theme / `EdgeInsets.all(16)` | 项内边距 |
| | `height` | `double?` | P0 | Theme / 视口高度 | 侧栏高度 |
| | `loading` | `bool` | L1 | `false` | **业务态**：是否展示加载 UI（→ §1.1.1） |
| | `loadingWidget` | `Widget?` | L2 | — | 加载占位；与 `loading` 配对；保留 `*Widget` 消歧 → [api.md §2.1](../../foundation/api.md#21-l2-内容槽widget-实例-vs-builder-回调) |

> 样式默认经 `Theme.of(context).extension<TSideBarThemeData>()`；局部参数优先级高于 Theme；**禁止**构造器 `themeData`（→ [theme.md §2.1](../../foundation/theme.md#禁止构造器-themedatav10-裁决)）。
> 构造器可选 `Key`（`super.key`）见 [api.md §1.1](../../foundation/api.md#11-flutter-keywidget-基建)；**不进上表**。

#### §1.1.1 加载态

`loading` 是 **bool 业务态**，不进 Theme（对齐 [theme.md §2.1「不进 Theme」](../../foundation/theme.md#21-themedata-字段归类v10-裁决)）。

| `loading` | `loadingWidget` | 渲染 |
|-----------|-----------------|------|
| `false` | — | 正常侧栏列表 |
| `true` | `null` | 内置 `TLoading`（circle · large） |
| `true` | 有 | 仅 `loadingWidget` |

```dart
TSideBar(
  value: 0,
  onChanged: (v) => setState(() => _value = v),
  loading: _loading,
  children: [...],
)
```

#### §1.1.2 受控与回调（B 类）

凡选中项变化，**仅**触发 **`onChanged`**（用户点击；父 `setState` 改 `value` 不触发）。

| 触发源 | `onChanged` |
|--------|-------------|
| 用户点击新项 | ✅ |
| 父 `setState` 改 `value` | — |
| 重复点击当前项 | — |
| 点击 `disabled` 项 | — |

```dart
int _value = 0;

TSideBar(
  value: _value,
  onChanged: (v) => setState(() => _value = v),
  children: [
    TSideBarItem(value: 0, label: '选项一'),
    TSideBarItem(value: 1, label: '选项二'),
  ],
)

// 命令式切项：父 State 改 value（不经过 onChanged）
setState(() => _value = 2);
```

**`value` 规则**：

- **必填**；父 State 持初值；**不**自动选中 `children` 首项。
- 须与某项 `TSideBarItem.value` 一致；无匹配项时实现可 assert / 无选中高亮。
- **严格 B 类**：高亮由构造器 **`value`** 驱动；父 `setState` 改 `value` 后须同步高亮（`didUpdateWidget` 跟 `widget.value`），**不**仅靠组件内部 index / 局部 State 持选中态。

### 1.2 类型定义

#### TSideBarItem

| 决策 | 参数 | 类型 | 默认 | 说明 |
|------|------|------|------|------|
| | `label` | `String` | `''` | 标签 |
| | `value` | `int` | `-1` | 项值（与 `TSideBar.value` 对应）；业务传 **唯一非负** `int`，**勿**用默认 `-1` 作真实项 |
| | `icon` | `IconData?` | — | 图标 |
| | `badge` | `TBadge?` | — | 徽标 |
| | `disabled` | `bool` | `false` | 单项禁用 |
| | `textStyle` | `TextStyle?` | — | 项级文字样式（不进 Theme） |

**图标与徽标**：`badge` 显示在项目右上角，不占用图标与标签的主行宽度；带 `icon` 的项目仍保留图标和单行省略标签。标签过长时以 `ellipsis` 截断。

#### 其他类型

| 决策 | 类型 | 说明 |
|------|------|------|
| | `TSideBarVariant` | `normal` · `outline`；形态默认在 Theme |
| | `TSideBarThemeData` | ThemeExtension（§2） |

### 1.3 export

**公开 export**：`TSideBar` · `TSideBarItem` · `TSideBarThemeData` · `TSideBarVariant`。

---


## §2 Theme 主题配置

`TSideBarThemeData` · [theme.md](../../foundation/theme.md)

| 范围 | 配置方法 |
|------|---------|
| 单颗 / 子树 / 全局 | `mergeExtension(TSideBarThemeData(...))` |

覆盖顺序：构造器局部覆盖 **P0** **>** `P1` 组件 Theme（`TSideBarThemeData`）**>** `P3` `ThemeData` / `P4` Token（自绘无 P2 Material 子主题）。

| 决策 | 字段 | 管什么 |
|------|------|--------|
| 📦 | `style` | `normal` / `outline` 形态 |
| 📦 | `selectedColor` / `unSelectedColor` | 文字色 |
| 📦 | `selectedBgColor` / `unSelectedBgColor` | 背景色 |
| 📦 | `selectedTextStyle` | 选中字形 |
| 📦 | `contentPadding` / `height` | 布局 |

#### 字段归类：进 Theme 与不进 Theme

本组件为自绘侧边导航（无 Material 等价薄包装）；已确认 Material 无对应字段 → 进 Theme 者全为 TDesign 扩展（P1）。

**进 `TSideBarThemeData`（P1，可主题化）**
- `style`（`normal` / `outline`）· `selectedColor` / `unSelectedColor` / `selectedBgColor` / `unSelectedBgColor` · `selectedTextStyle` · `contentPadding` · `height`

**不进 Theme（构造器 P0/L1/L2/L3）**
- P0：`style` · `selectedColor` / `unSelectedColor` · `selectedBgColor` / `unSelectedBgColor` · `selectedTextStyle` · `contentPadding` · `height`
- L1/L2/L3：`loading` · `loadingWidget` · `value` · `onChanged` · `children` · 项级 `textStyle`

---

## §3 实现约定 · 测试与 Example 契约

**文件**：`t_sidebar.dart` · `t_sidebar_item.dart` · `t_sidebar_theme_data.dart`。

### 布局默认（现网参考）

| 项 | 默认 |
|----|------|
| 最小宽度 | `106` |
| 单项高度 | `56` |
| 列表 | `ListView` · `ClampingScrollPhysics` |

**必测**：受控 `value`+`onChanged`（点击触发）· 父改 `value` 同步高亮 · `onChanged: null` · `disabled` 单项 · `value` 必填不自动首项 · `loading` / `loadingWidget` · `TSideBarVariant` Theme · 图标与徽标共存时主行内容可见。

**Example**：
- 切页：`PageController` 由父 State 驱动，每个 `children` 项对应不同的页面标题、说明和内容。
- 锚点：以每段**标题**的 `GlobalKey` 相对右侧滚动视口顶边确定选中项；点击项使用 `Scrollable.ensureVisible(..., alignment: 0)`。不得使用固定区块高度、固定 offset 或视口中心阈值。
- 锚点末段：尾部空间仅补足“最后标题到末段内容底部”不足一屏的高度；最后标题置顶后不得继续将内容向上推。
- `outline` 与带图标锚点示例复用上述锚点语义；自定义样式使用 Theme Token 的浅色背景和次级文字色，避免硬编码主题色。
- 延迟加载：初始 `loading: true`，异步数据就绪后切换为正常列表；不得在 `build` 中重复创建延迟任务或永久保持 loading。
- 未选中颜色：仅展示 `unSelectedColor` 的低干扰前景色覆盖，并保留实际 `children`、选中态和内容切换，不与锚点或 children 更新示例混用。

> [api.md](../../foundation/api.md) · [controlled.md](../../foundation/controlled.md) · [testing.md](../../guide/testing.md)（类名与 **§1** 冲突时以 **§1** 为准）

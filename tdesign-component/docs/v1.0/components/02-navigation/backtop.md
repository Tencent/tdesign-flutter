# TBackTop — v1.0 定稿

> **状态**：已定稿 | **控制类**：A | **Sprint**：S3 · **Tier T2**
> **源码**：`lib/src/components/backtop/` · **类名**：`TBackTop`
> **官网**：[BackTop 返回顶部](https://tdesign.tencent.com/flutter/components/back-top) · [guide](../../guide/developer-guide.md)

**读法**：按 **§1** 查看当前 v1 API，按 **§2** 配置主题，按 **§3** 落地测试与 Example。

**图例** → [component-doc.md §4](../../guide/component-doc.md#4-决策图例固定-6-个不新增)（§1–§3「决策」列）

- [§1 v1.0 定稿 API](#1-v10-定稿-api)
- [§2 Theme 主题配置](#2-theme-主题配置)
- [§3 实现约定 · 测试与 Example 契约](#3-实现约定--测试与-example-契约)

与 [TFab](../01-base/fab.md) 区分：BackTop 专用于滚动回顶。

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | T2 自绘（`GestureDetector` + `Container`） |
| Material | 无等价薄包装 |
| Theme | `TBackTopThemeData`（§2） |
| 禁用 | `onPressed: null` |
| L4 | → `TBackTopThemeData`（§2） |

## 控制方案

控制类 **A**：`onPressed` 动作回调；`null` 禁用。**不提供** `value` / `onChanged`。

→ [controlled.md](../../foundation/controlled.md)

---

## §1 v1.0 定稿 API

> 以下为 v1.0 当前公开 API。`shape` 等 L4 默认走 §2 Theme，可实例覆盖。

层级 → [api.md §1](../../foundation/api.md#1-构造器四层l1l4)

> **P0 逃逸舱**：无。本组件不提供 `style` / `decoration` 逃逸舱（四问判定见 [theme.md §2.2](../../foundation/theme.md#22-p0-逃逸舱判定)）；单颗差异用子树 `mergeExtension` 或 L1 单项（`shape` / `visibilityOffset`）。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认 | 说明 |
|------|------|------|------|------|------|
| | `controller` | `ScrollController?` | L1 | — | 绑定滚动；有效时点击先回顶 |
| | `showText` | `bool` | L2 | `false` | 是否展示文案（i18n） |
| ✏️ | `onPressed` | `VoidCallback?` | L3 | — | `null` 禁用；未传时回顶后无额外回调 |
| ✨ | `visibilityOffset` | `double?` | L1 | Theme | 偏移 ≥ 阈值才显示 |
| ✨ | `tooltip` | `String?` | L2 | resource 默认 | 无障碍提示；外包 `Tooltip`；见 **tooltip 与无障碍** |
| | `shape` | `TBackTopShape?` | L1 | Theme | 可覆盖 Theme |

**点击行为**：`onPressed == null` 不可点；`controller` 有效则先 `animateTo(0)` 再调 `onPressed`；无 `controller` 仅调 `onPressed`。

#### tooltip 与无障碍

BackTop 默认仅图标（`showText: false`），读屏（VoiceOver / TalkBack）无法从视觉推断用途。v1.0 **始终**外包 Flutter `Tooltip`，`tooltip` 提供控件语义名称。

| 场景 | 行为 |
|------|------|
| 传入 `tooltip` | 作为 `Tooltip.message`；桌面/Web 悬停、移动端长按显示提示；读屏聚焦时朗读 |
| 未传 | 回退 `context.resource` 组合文案（中文：「返回顶部」） |
| `onPressed: null`（禁用） | 仍保留 `Tooltip`；读屏可获知按钮用途，点击区 `onTap` 为 `null` |

与 `showText` 区别：`showText` 控制按钮上**可见**文案；`tooltip` 为**不可见**语义提示，二者独立——`showText: false` 时界面仍简洁，读屏用户仍可通过 `tooltip` 理解按钮。

与 [TFab](../01-base/fab.md) 差异：Fab 拆分 `tooltip`（悬停提示）与 `semanticLabel`（读屏标签）；BackTop 以 `tooltip` 统一承担（纯图标回顶场景足够）。

### 1.2 类型定义

| 决策 | 类型 | 说明 |
|------|------|------|
| ✏️ | `TBackTopShape` | `circle` · `halfCircle` |
| ✨ | `TBackTopThemeData` | ThemeExtension（§2） |

### 1.3 export

**公开 export**：`TBackTop` · `TBackTopShape` · `TBackTopThemeData`。
**不 export**：内部定位辅助（可与 Fab 共用，不公开）。

---


## §2 Theme 主题配置

`TBackTopThemeData` · [theme.md](../../foundation/theme.md)

| 范围 | 配置方法 |
|------|---------|
| 单颗 | 构造器 `shape` / `visibilityOffset` |
| 子树 | `Theme.of(context).mergeExtension(TBackTopThemeData(...))` |
| 全局 | `TDesignTheme` 注册 `TBackTopThemeData` |

覆盖顺序：`P0`(无) **>** `P1` 组件 Theme（`TBackTopThemeData`）**>** `P3` `ThemeData` / `P4` Token（自绘无 P2 Material 子主题）。

**配色**：不提供构造器颜色字段。默认背景、边框和内容色分别读取 `Theme.of(context).colorScheme.primaryContainer`、`primary`、`onPrimaryContainer`，因此应用品牌主题会自动生效；需要局部覆盖时使用 `TBackTopThemeData`。

| 决策 | 字段 | 管什么 |
|------|------|--------|
| 📦 | `shape` | 外形 |
| 📦 | `backgroundColor` / `borderColor` / `contentColor` | 背景、边框、图标与文字色 |
| ✨ | `defaultVisibilityOffset` | 显隐阈值 |
| ✨ | `defaultRight` / `defaultBottom` | 定位 |
| ✨ | `halfCircleRightInset` | 半圆贴边 |

#### 字段归类：进 Theme 与不进 Theme

本组件为 T2 自绘（无 Material 等价薄包装）；已确认 Material 无对应字段 → 进 Theme 者全为 TDesign 扩展（P1）。

**进 `TBackTopThemeData`（P1，可主题化）**
- `shape` · `backgroundColor` / `borderColor` / `contentColor` · `defaultVisibilityOffset` · `defaultRight` / `defaultBottom` · `halfCircleRightInset`

**不进 Theme（构造器 L1/L2/L3）**
- `controller`（L1）· `showText`（L2）· `onPressed`（L3）· `tooltip`（L2）

---

## §3 实现约定 · 测试与 Example 契约

**文件**：`t_backtop.dart` · `t_backtop_theme_data.dart` · `t_backtop_visibility.dart`（可选）。

**必测**：`onPressed: null` · `shape` 两态 · `showText` · `brightness` 配色 · `visibilityOffset` · `tooltip`（自定义 / resource 默认 / 禁用时仍可用）· 回顶防抖 · Theme 子树。

**Example**：内置显隐为主路径；`halfCircle` 贴边示例；与 Fab 同页区分用途。

> [api.md](../../foundation/api.md) · [controlled.md](../../foundation/controlled.md) · [testing.md](../../guide/testing.md) · [fab.md](../01-base/fab.md)

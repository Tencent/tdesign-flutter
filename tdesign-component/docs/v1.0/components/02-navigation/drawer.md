# TDrawer — v1.0 定稿

> **状态**：已定稿 | **控制类**：E | **Sprint**：S4
> **源码**：`lib/src/components/drawer/` · **类名**：`TDrawer`
> **官网**：[Drawer 抽屉](https://tdesign.tencent.com/flutter/components/drawer) · [guide](../../guide/developer-guide.md)

**读法**：按 **§1** 查看当前 v1 API，按 **§2** 配置主题，按 **§3** 落地测试与 Example。

**图例** → [component-doc.md §4](../../guide/component-doc.md#4-决策图例固定-6-个不新增)（§1–§3「决策」列）

- [§1 v1.0 定稿 API](#1-v10-定稿-api)
- [§2 Theme 主题配置](#2-theme-主题配置)
- [§3 实现约定 · 测试与 Example 契约](#3-实现约定--测试与-example-契约)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | E 类命令式侧滑抽屉；内部 [`TPopup.show`](../05-feedback/popup.md) |
| Material | 无 `Scaffold.drawer` / `Drawer` 薄包装（视觉对齐 TDesign，实现为浮层） |
| Theme | `TDrawerThemeData`（内容）+ `TPopupThemeData`（蒙层/动效） |
| 禁用 | 不 `show()`；**无** Widget 级 `disabled` |
| L4 | 内容样式 → `TDrawerThemeData`；**禁止**构造器 `themeData` / `popupOptions` |

## 控制方案

控制类 **E**：命令式 **`show()` → `TDrawerHandle`** → `handle.close()`；**不提供** `visible` / `onVisibleChange`（→ [controlled.md §4](../../foundation/controlled.md#e-类) · [popup.md §2](../05-feedback/popup.md#2-tpopup-业务壳约定)）。`showOverlay` / `closeOnOverlayClick` 为 L3，**不进 Theme**。

→ [controlled.md](../../foundation/controlled.md)

---

## §1 v1.0 定稿 API

> 以下为 v1.0 当前公开 API。L4 样式统一迁入 §2 Theme。

层级 → [api.md §1](../../foundation/api.md#1-构造器四层l1l4)

> **P0 逃逸舱**：无。本组件不提供 `style` / `decoration` 逃逸舱（四问判定见 [theme.md §2.2](../../foundation/theme.md#22-p0-逃逸舱判定)）；单颗差异用子树 `mergeExtension`（`TDrawerThemeData` / `TPopupThemeData`）或构造器 L1（`width` / `drawerTop`）。

### 1.1 构造器参数

E 类入口：`TDrawer(context, ...)` → `show()` 返回 **`TDrawerHandle`** → `handle.close()` 关闭。命令式为**唯一**主路径；**不提供** `visible` / `onVisibleChange`（对齐 [Popup §2 业务壳](../05-feedback/popup.md#2-tpopup-业务壳约定)）。

| 决策 | 参数 | 类型 | 层级 | 默认 | 说明 |
|------|------|------|------|------|------|
| | `context` | `BuildContext` | E | — | 打开方上下文（首参）；`show()` 时用于 `Theme.of(context)` |
| ✏️ | `child` | `Widget?` | L2 | — | 自定义主体；传入后覆盖列表模式 |
| | `items` | `List<TDrawerItem>?` | L2 | — | 菜单项列表 |
| ✏️ | `title` | `Widget?` | L2 | — | 列表模式标题插槽 |
| | `footer` | `Widget?` | L2 | — | 列表模式底部区 |
| | `placement` | `TDrawerPlacement?` | L1 | `right` | `left` / `right` → 内部 `TPopupPlacement` |
| | `width` | `double?` | L1 | Theme | 抽屉宽度；构造器可覆盖 Theme |
| ✨ | `drawerTop` | `double?` | L1 | Theme | 顶部位移；写入 `TPopup` inset（避开 NavBar 等） |
| | `onClose` | `VoidCallback?` | L3 | — | 关闭后回调（含蒙层关闭；无单独 `onOverlayClick`） |
| | `onItemClick` | `TDrawerItemClickCallback?` | L3 | — | 点击 `items` 某项；**不**自动关闭抽屉（见 **§1.1.1**） |
| | `closeOnOverlayClick` | `bool?` | L3 | `true` | 点击蒙层是否关闭 |
| | `showOverlay` | `bool?` | L3 | `true` | 是否显示蒙层 |

> 传 `child` 时忽略 `items` / `title` / `footer` 的列表拼装。纯文案：`title: Text('标题')`。

#### 与 TPopup 的关系

| 层 | 职责 | 业务是否感知 |
|----|------|-------------|
| `TDrawer` | 侧滑语义、`items` 拼装、`drawerTop` / `width` 映射 | ✅ 公开 API |
| `TPopup` | Route、蒙层、动画、inset | ❌ 内部实现；**不透传** `TPopupOptions` / `TPopupHandle` |
| `TDrawerThemeData` | 内容区样式默认 | ✅ `Theme.of(context)` / `mergeExtension` |
| `TPopupThemeData` | 蒙层色、过渡动效 | ✅ `Theme.of(context)` / `mergeExtension` |

#### 命令式用法

`show()` 返回 **`TDrawerHandle`**（包装内部 `TPopupHandle`，不对外暴露）。关闭统一 **`handle.close()`**；**不提供** `TDrawer.close()`。

```dart
final handle = TDrawer(
  context,
  drawerTop: navBarHeight,
  items: [...],
  onItemClick: (index, item) {
    Navigator.of(context).pushNamed('/settings');
    handle.close(); // 业务决定何时关
  },
  onClose: () => debugPrint('已关闭'),
).show();

// 跨 widget 持有
TDrawerHandle? _drawerHandle;
_drawerHandle = TDrawer(context, items: [...]).show();
_drawerHandle?.close();
```

> 与 `showDialog` 的 `Future` 模型分工不同：Drawer 走 **Handle + 回调**；需 `await` 结果请用 [TDialog](../05-feedback/dialog.md)。

L4 内容样式（背景、边框、`hover` 等）不进构造器，统一 §3 `TDrawerThemeData` + `Theme.of(context)`。

#### §1.1.1 点击菜单项（不默认关闭）

点击 `items` 某项**不**自动 `close()`；**不提供** `closeOnItemClick`。

| 场景 | 行为 |
|------|------|
| 点击菜单项 | 仅触发 `onItemClick(index, item)`；抽屉保持打开 |
| 选完需关抽屉 | 在 `onItemClick` 内显式 `handle.close()` |
| 点击蒙层 | `closeOnOverlayClick` 控制；关闭后走 `onClose` |

> 不采用「默认关」：多步操作 / 跳转前确认等场景由业务决定何时关。

### 1.2 类型定义

#### TDrawerItem

| 参数 | 类型 | 说明 |
|------|------|------|
| `title` | `String?` | 项标题文案 |
| `icon` | `Widget?` | 项图标 |
| `content` | `Widget?` | 项完全自定义；传入后覆盖 `title`/`icon` |

#### 其他类型

| 决策 | 类型 | 说明 |
|------|------|------|
| ✨ | `TDrawerHandle` | `show()` 返回值；`close()` · `isShowing`；内部包装 `TPopupHandle` |
| | `TDrawerPlacement` | `left` · `right` |
| | `TDrawerItemClickCallback` | `void Function(int index, TDrawerItem item)` |
| | `TDrawerThemeData` | 内容区 ThemeExtension（§2） |

#### `TDrawerHandle`

| 成员 | 说明 |
|------|------|
| `close()` | 关闭本次抽屉；已关时无副作用 |
| `isShowing` | 本次抽屉是否仍在展示 |

### 1.3 export

**公开 export**：`TDrawer` · `TDrawerHandle` · `TDrawerItem` · `TDrawerPlacement` · `TDrawerItemClickCallback` · `TDrawerThemeData`。
**不 export**：`TDrawerWidget`（内部列表拼装；侧滑菜单统一 `TDrawer(...).show()`，不公开嵌入路径）。

---


## §2 Theme 主题配置 {#3-theme-主题配置}

`TDrawerThemeData` + `TPopupThemeData` · [theme.md](../../foundation/theme.md)

| 范围 | 配置方法 |
|------|---------|
| 单次打开 | 构造器 `width` / `drawerTop` / `child` / `items` / L3 蒙层策略 |
| 子树 | `mergeExtension(TDrawerThemeData)` · `mergeExtension(TPopupThemeData)` |
| 全局 | `TDesignTheme` 注册上述 Extension |

**收拢原则**：样式默认走 `ThemeExtension`（字段归类 → [theme.md §2.1](../../foundation/theme.md#21-themedata-字段归类v10-裁决)）；**禁止**构造器 `themeData` / `popupOptions`（→ [theme.md §2.1](../../foundation/theme.md#禁止构造器-themedatav10-裁决)）。`show()` 时用打开方 `context` 解析 Theme。

覆盖顺序：`P0`(无) **>** `P1` 内容 `TDrawerThemeData` + 浮层 `TPopupThemeData` **>** `P3` `ThemeData` / `P4` Token。构造器 L1（`width` / `drawerTop`）可单次覆盖内容 `TDrawerThemeData`；蒙层动效/色由 `TPopupThemeData` 表达（无 P2 Material 浮层子主题）。

### 构造器 L3（不进 Theme）

| 参数 | 说明 |
|------|------|
| `showOverlay` | 本次是否显示蒙层 |
| `closeOnOverlayClick` | 本次点蒙层是否关闭 |
| `onClose` / `onItemClick` | 关闭与项点击回调 |

### `TDrawerThemeData` 字段（样式）

| 决策 | 字段 | 类别 | 说明 |
|------|------|------|------|
| 📦 | `width` | 宽高 | 默认宽；构造器 `width` 可覆盖 |
| 📦 | `drawerTop` | 宽高 | 默认顶部位移；映射 `TPopup` inset；构造器可覆盖 |
| 📦 | `backgroundColor` | 色 | 内容区背景 |
| 📦 | `bordered` | 边框 | 列表边框 |
| 📦 | `isShowLastBordered` | 边框 | 末行分割线 |
| 📦 | `hover` | 按压样式 | 列表项点击反馈样式默认 |
| 📦 | `style` | 按压 / Cell | `TCellThemeData`（项标题、图标、间距等） |

### `TPopupThemeData` 字段（Drawer 浮层壳 · 样式）

| 决策 | 字段 | 类别 | 说明 |
|------|------|------|------|
| 📦 | `overlayColor` | 色 | 蒙层色（及透明度） |
| 📦 | `animationDuration` | 动效 | 侧滑入/出时长 |
| 📦 | `animationCurve` | 动效 | 侧滑曲线 |

#### 字段归类：进 Theme 与不进 Theme

本组件为 E 类浮层，内部基于 `TPopup` 自绘（**非** Material `Drawer` 薄包装），无 Material 浮层子主题；已确认 Material 无对应字段 → 进 Theme 者全为 TDesign 扩展（P1）。

**进 Theme**
- `TDrawerThemeData`（内容区，P1）：`width` · `drawerTop` · `backgroundColor` · `bordered` · `hover` · `style`
- `TPopupThemeData`（浮层壳，P1）：`overlayColor` · `animationDuration` · `animationCurve`

**不进 Theme（构造器 L2/L3）**
- `showOverlay` · `closeOnOverlayClick` · `onClose` · `onItemClick`（L3）
- `child` · `items` · `title` · `footer`（L2，单次 `show`）

> 单次打开内容（`child` / `items` / `title` / `footer`）与 L3 蒙层策略不进 Theme。显隐：`show()` → `TDrawerHandle` · `handle.close()`。

---

## §3 实现约定 · 测试与 Example 契约

**文件**：`t_drawer.dart` · `t_drawer_handle.dart` · `t_drawer_theme_data.dart` · `t_drawer_resolve.dart`（规划）；`t_drawer_widget.dart` 内部专用。

**必测**：`child` / `items` 两种模式 · `title` / `footer` · `placement` · `drawerTop` inset · 蒙层 · `onClose` · **点击 item 不自动关** · `onItemClick` 内 `handle.close()` · `show()` 返回 `TDrawerHandle` · `isShowing` · 重复 `show()` 防重入 · `Theme.of(context)` 子树 · 构造器 `width` / `drawerTop` 覆盖 Theme · **不 export** `TPopupHandle`。

**Example**：`visible: true` → `.show()` 接 `TDrawerHandle` · `title`+`titleWidget` → `title: Widget?` · `contentWidget` → `child` · NavBar 高度 → `drawerTop` · **列表项点击后 `handle.close()` 示范**。

> [api.md](../../foundation/api.md) · [controlled.md](../../foundation/controlled.md) · [testing.md](../../guide/testing.md) · [popup.md](../05-feedback/popup.md)

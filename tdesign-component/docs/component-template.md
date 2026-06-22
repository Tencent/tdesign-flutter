# {组件名} — v1.0 定稿

> **状态**：规划中 | **控制类**：[A/B/C/D/E/F] | **Sprint**：[S1/S2/...]

- [§1 v1.0 定稿 API](#1-v10-定稿-api)（新组件从零开始看这里）
- [§2 0.2.x → v1.0](#2-02x--v10)（从旧版升级看这里）
- [§3 Theme 主题配置](#3-theme-主题配置)
- [§4 实现约定 · 测试与 Example 契约](#4-实现约定--测试与-example-契约)

**源码路径**：`lib/src/components/{组件名}/`

**文首模板（必填）**：
- 控制类：[A/B/C/D/E/F]
- Sprint 编号：[S1/S2/...]
- 源码路径：`lib/src/components/{组件名}/`

---

**架构**：（用一段话说明实现方式、受控/禁用、Theme 指向）

{组件名} 底层基于 Material [{原生控件}](https://api.flutter.dev/flutter/material/{...}.html) 薄包装。[A 类：通过 `onPressed: null` 表达禁用]。所有样式按优先级 `实例 P0 style > resolve 全量 > Token` 覆盖。主题扩展为 `T{组件名}ThemeData`，通过 `Theme.of(context).extension<T{组件名}ThemeData>()` 读取。

---

## §1 v1.0 定稿 API

> 与 0.2.x API 对照参见 §2。§1 中无特殊图例标记的参数 = 与 0.2.x 同名同义保留。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认值 | 说明 |
|------|------|------|------|--------|------|
| | `child` | `Widget?` | L2 | — | 内容组件 |
| ✨ | `variant` | `T{组件名}Variant?` | L1 | Theme | 变体样式 |
| | `size` | `T{组件名}Size` | L1 | `medium` | 尺寸规格 |
| ✨ | `colorScheme` | `T{组件名}ColorScheme?` | L1 | Theme | 颜色方案 |
| 🗑️ → | `onPressed` | `VoidCallback?` | L3 | — | 点击回调；`null` 即禁用 |
| | `style` | `{组件名}Style?` | P0 | — | 实例级最终覆盖（逃逸舱） |

> **L1** = 语义级、**L2** = 内容级、**L3** = 行为级、**P0** = 逃逸舱样式覆盖

### 1.2 类型定义

| 决策 | 类型 | 成员 | 用于 |
|------|------|------|------|
| ✨ | `T{组件名}Size` | `large` · `medium` · `small` | `size` 参数 |
| ✨ | `T{组件名}Variant` | `...` | `variant` 参数 |
| ✨ | `T{组件名}ColorScheme` | `defaultTheme` · `primary` · `danger` · `...` | `colorScheme` 参数 |
| ✨ | `T{组件名}ThemeData` | ThemeExtension | §3 主题配置 |

### 1.3 移除的导出符号

| 决策 | 移除符号 | 替代 |
|------|---------|------|
| 🚫 | `T{组件名}Style` | 迁入 `T{组件名}ThemeData`（不公开导出） |
| 🗑️ | `disabled` 参数 | 按控制类对应方式处理 |
| ✏️ | `...` | 参见 §2 升级对照 |

---

## §2 0.2.x → v1.0

### ✏️ 改名

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `type` / `T{组件名}Type` | `variant` / `T{组件名}Variant` | 全局替换枚举名和参数名 |
| `theme`（颜色方案） | `colorScheme` | 全局替换参数名 |
| `onTap` / `onClick` | `onPressed` | 回调函数名替换 |

### 🔀 合并

| 从（0.2.x） | 到（v1.0） | 怎么改 |
|------------|-----------|--------|
| `icon` + `iconWidget` | `icon`（统一为 `Widget?`） | 旧 `icon: IconData` 改为 `icon: Icon(Icons.xxx)` |

### 🗑️ 移除

| 从（0.2.x） | 替代方案 | 怎么改 |
|------------|---------|--------|
| `disabled` 参数 | `onPressed: null` / `onChanged: null` | 按控制类对应方式 |
| `isBlock` 参数 | 父级 `SizedBox(width: double.infinity)` | 外包通栏布局 |

### 📦 迁入 Theme

| 从（0.2.x 构造器） | 到（T{组件名}ThemeData 字段） | 怎么改 |
|------------------|---------------------------|--------|
| 颜色相关参数 | `{xxx}Color` 字段 | 见 §3 末列 |
| 间距/圆角参数 | `padding` / `borderRadius` 等字段 | 见 §3 末列 |

> 子组件内部使用的 {组件名} 也需同步升级，**不借用 T{组件名} 参数**。

---

## §3 Theme 主题配置

### 3.1 配置方式

| 范围 | 配置方法 |
|------|---------|
| 单组件 | 构造器 `variant` / `colorScheme` + P0 `style` |
| 子树 | `Theme.of(context).mergeExtension(T{组件名}ThemeData(...))` |
| 全应用 | `MaterialApp.theme` 扩展 `T{组件名}ThemeData` |

### 3.2 覆盖顺序

`实例 P0 style` **>** resolve（全量合并） **>** Token

### 3.3 T{组件名}ThemeData 字段

| 决策 | 字段 | 管什么 | 0.2.x 构造参数 |
|------|------|--------|---------------|
| ✨ | `defaultVariant` | 变体默认值 | — |
| ✨ | `defaultSize` | 尺寸默认值 | — |
| 📦 | `{variant}Style` | 按 variant 的色板 | `style` / `activeStyle` / `disableStyle` |
| 📦 | `color` | 主色 | 旧构造器 `color` |
| 📦 | `textStyle` | 默认文案样式 | `textStyle` |
| 📦 | `padding` | 内边距 | `padding` |
| 📦 | `borderRadius` | 圆角 | — |
| ✨ | `shape` | 外形枚举 | — |

---

## §4 实现约定 · 测试与 Example 契约

### 4.1 实现约束

- **文件划分**：单一 resolve 入口
  - `t_{组件名}.dart` — Widget 本体
  - `t_{组件名}_resolve.dart` — **唯一**样式合并入口
  - `t_{组件名}_theme_data.dart` — ThemeExtension

- **底层实现**：基于 Material {原生控件} 薄包装

### 4.2 必测场景

> 控制类通用必测见 [testing.md](v1.0/guide/testing.md) §3，此处仅列组件专项。

| 测试项 | Golden | 说明 |
|--------|--------|------|
| 基础渲染 | ✅ | 默认参数正常渲染 |
| 禁用状态 | ✅ | `onPressed: null` / `onChanged: null` 不可交互 |
| `variant` × `colorScheme` 矩阵 | ✅ | 至少 primary / defaultTheme 各一态 |
| 尺寸验证 | | `large` / `medium` / `small` 各尺寸渲染正确 |
| P0 style 覆盖 | | 实例 style 优先于 Theme resolve |
| Theme 子树 | | `mergeExtension` 覆盖构造器未传项 |

### 4.3 Example 契约

- 覆盖所有 `variant` / `colorScheme` / `size` 组合矩阵
- 提供 `isBlock` 迁移示例（父级布局通栏）
- 提供 `onLongPress` 外包手势示例（如适用）

---

> **文档参考**：[api.md](v1.0/foundation/api.md) · [controlled.md](v1.0/foundation/controlled.md) · [theme.md](v1.0/foundation/theme.md) · [disabled-evolution.md](v1.0/foundation/disabled-evolution.md)

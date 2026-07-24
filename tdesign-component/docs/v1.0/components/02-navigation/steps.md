# TSteps — v1.0 定稿

> **状态**：已定稿 | **控制类**：— | **Sprint**：S3
> **源码**：`lib/src/components/steps/` · **类名**：`TSteps`
> **官网**：[Steps 步骤条](https://tdesign.tencent.com/flutter/components/steps) · [guide](../../guide/developer-guide.md)

**读法**：按 **§1** 查看当前 v1 API，按 **§2** 配置主题，按 **§3** 落地测试与 Example。

**图例** → [component-doc.md §4](../../guide/component-doc.md#4-决策图例固定-6-个不新增)（§1–§3「决策」列）

- [§1 v1.0 定稿 API](#1-v10-定稿-api)
- [§2 Theme 主题配置](#2-theme-主题配置)
- [§3 实现约定 · 测试与 Example 契约](#3-实现约定--测试与-example-契约)

---

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | 自绘步骤条（横向/纵向） |
| Material | 无等价薄包装；**非** `Stepper`（分步表单控件） |
| Theme | `TStepsThemeData`（§2） |
| 交互 | **纯展示**；无步骤点击 / `onChanged` |
| L4 | → `TStepsThemeData`（§2） |

## 控制方案

控制类 **`—`**（展示型 value）：`value` 表示**当前步索引**，父 State 传入渲染；**无** `onChanged` 闭环，**非** B 类受控。

**Material 对照**：对齐「流程进度展示」语义；**非** Material `Stepper`（`onStepContinue` / `onStepCancel` 等分步表单交互）。导航 **TSteps**（`—`）≠ 输入 **[TStepper](../03-input/stepper.md)**（B/C，`value` + `onChanged`）。

**与 B 类区别**：展示型允许 `value` 构造器默认 `0`；父亦可显式传 `value`。切步由业务改父 State（按钮、接口回调等），**不由**步骤条自身点击驱动。

→ [controlled.md §6](../../foundation/controlled.md#控制类-)

---

## §1 v1.0 定稿 API

> 以下为 v1.0 当前公开 API。L4 默认走 §2 Theme（`mergeExtension`）。

层级 → [api.md §1](../../foundation/api.md#1-构造器四层l1l4)

> **P0 逃逸舱**：无。本组件不提供 `style` / `decoration` 逃逸舱（四问判定见 [theme.md §2.2](../../foundation/theme.md#22-p0-逃逸舱判定)）；单颗差异用子树 `mergeExtension` 或 L1 单项（`status` / `simple` / `verticalSelect` / `readOnly`）。

### 1.1 构造器参数

| 决策 | 参数 | 类型 | 层级 | 默认 | 说明 |
|------|------|------|------|------|------|
| | `steps` | `List<TStepsItemData>` | L2 | — | 步骤数据 |
| ✏️ | `value` | `int` | L1 | `0` | 当前步索引；展示型，见 **§1.1.1** |
| | `direction` | `TStepsDirection` | L1 | `horizontal` | 横向/纵向 |
| | `readOnly` | `bool?` | L1 | Theme | 流程展示视觉态，见 **§1.1.2** |
| | `status` | `TStepsStatus?` | L1 | Theme | `success` / `error`；可覆盖 Theme |
| | `simple` | `bool?` | L1 | Theme | 简洁模式 |
| | `verticalSelect` | `bool?` | L1 | Theme | 纵向选中样式（右箭头） |

> 样式默认经 `Theme.of(context).extension<TStepsThemeData>()`；**禁止**构造器 `themeData`（→ [theme.md §2.1](../../foundation/theme.md#禁止构造器-themedatav10-裁决)）。
> 构造器可选 `Key`（`super.key`）见 [api.md §1.1](../../foundation/api.md#11-flutter-keywidget-基建)；**不进上表**。
> **`value`**：当前步索引参数。

#### §1.1.1 当前步索引（展示型 value）

有效索引：`effectiveIndex = value`。

| 参数 | 默认 | 说明 |
|------|------|------|
| `value` | `0` | 父 State 传入当前步 |

**规则**（展示型 `—`，**非** B 类）：

- 父 State 持业务进度；`setState` 改 `value` 后组件须同步激活态（`didUpdateWidget` 跟 `widget.value`）。
- 越界索引实现 **clamp** 至 `[0, steps.length - 1]`（`steps` 为空时为 `0`）。
- **无**步骤点击回调；切步由页面其它控件驱动父 State。

```dart
int _step = 0;

TSteps(
  value: _step,
  steps: [
    TStepsItemData(title: '步骤一', content: '说明'),
    TStepsItemData(title: '步骤二', content: '说明'),
    TStepsItemData(title: '步骤三', content: '说明'),
  ],
)

// 业务驱动切步（非步骤条点击）
ElevatedButton(
  onPressed: _step < 2 ? () => setState(() => _step++) : null,
  child: const Text('下一步'),
)
```

```dart
TSteps(steps: [...], value: 1);

// 业务驱动更新当前步
setState(() => _step = 2);
```

#### §1.1.2 交互与 `readOnly`（纯展示）

v1.0 **不提供** `onTap` / `onChanged` / 步骤级点击 API。步骤条仅渲染进度，**不可**通过点击步骤切换当前步。

| `readOnly` | 视觉语义 |
|------------|----------|
| `false`（默认） | **进行中**：区分已完成 / 当前 / 未完成；当前步标题可加粗 |
| `true` | **流程展示态**：连线与节点按「流程已走完」样式渲染（非「禁用点击」——本身即无点击） |

> **不进 Theme**：`steps` · `value` · `direction`。

### 1.2 类型定义

#### TStepsItemData

| 决策 | 参数 | 类型 | 说明 |
|------|------|------|------|
| | `title` | `String?` | 标题 |
| | `content` | `String?` | 内容 |
| | `successIcon` | `IconData?` | 成功图标 |
| | `errorIcon` | `IconData?` | 失败图标 |
| | `customTitle` | `Widget?` | 自定义标题 |
| | `customContent` | `Widget?` | 自定义内容 |

#### 其他类型

| 决策 | 类型 | 说明 |
|------|------|------|
| | `TStepsDirection` | `horizontal` · `vertical` |
| | `TStepsStatus` | `success` · `error`；当前步错误态等 |
| | `TStepsThemeData` | ThemeExtension（§2） |

### 1.3 export

**公开 export**：`TSteps` · `TStepsItemData` · `TStepsDirection` · `TStepsStatus` · `TStepsThemeData`。

---


## §2 Theme 主题配置

`TStepsThemeData` · [theme.md](../../foundation/theme.md)

| 范围 | 配置方法 |
|------|---------|
| 单颗 | 构造器 `status` / `simple` / `verticalSelect` / `readOnly` |
| 子树 | `Theme.of(context).mergeExtension(TStepsThemeData(...))` |
| 全局 | `TDesignTheme` 注册 `TStepsThemeData` |

覆盖顺序：`P0`(无) **>** `P1` 组件 Theme（`TStepsThemeData`）**>** `P3` `ThemeData` / `P4` Token（自绘非 Material `Stepper`，无 P2）。

| 决策 | 字段 | 管什么 |
|------|------|--------|
| 📦 | `status` | 步骤状态（`success` / `error`） |
| 📦 | `simple` | 简洁模式 |
| 📦 | `verticalSelect` | 纵向选中样式 |
| 📦 | `readOnly` | 流程展示视觉态默认 |

#### 字段归类：进 Theme 与不进 Theme

本组件为自绘步骤条（**非** Material `Stepper` 分步表单控件），无 Material 等价；已确认 Material 无对应字段 → 进 Theme 者全为 TDesign 扩展（P1）。

**进 `TStepsThemeData`（P1，可主题化）**
- `status`（`success` / `error`）· `simple` · `verticalSelect` · `readOnly`

**不进 Theme（构造器 L1/L2）**
- `steps`（L2）· `value`（L1）· `direction`（L1）

---

## §3 实现约定 · 测试与 Example 契约

**文件**：`t_steps.dart` · `t_steps_horizontal.dart` / `t_steps_vertical.dart` · `t_steps_theme_data.dart`。

**Theme 合并**：`status` / `simple` / `verticalSelect` / `readOnly` 须按 §2 优先级解析（构造器 L1 **>** `Theme.extension<TStepsThemeData>()` **>** 内置默认）；**禁止**构造器 `themeData` 参数。

**必测**：横/纵布局 · `value` 驱动激活态 · 父 `setState` 改 `value` 同步 · 默认 `value: 0` · 越界 clamp · `readOnly` 两档视觉 · `status: error` 当前步样式 · `simple` · `verticalSelect` · Theme 子树覆盖 · **无**步骤点击 / `onChanged` · **无**构造器 `themeData`。

**Example**：父 State + 外部按钮切步 · `readOnly` 流程展示态 · `status: error` · 横纵示例 · Theme `simple` 覆盖。

> [api.md](../../foundation/api.md) · [controlled.md](../../foundation/controlled.md) · [testing.md](../../guide/testing.md)（类名与 **§1** 冲突时以 **§1** 为准）

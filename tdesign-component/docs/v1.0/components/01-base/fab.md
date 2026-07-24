# TFab — v1.0 定稿

> Sprint **S2** | 控制类 **A** · **Tier T2** · 源码：`lib/src/components/fab` · [guide](../guide/developer-guide.md)

**读法**：API → **§1**；Theme → **§2**；实现与验收 → **§3**

**图例** → [component-doc.md §4](../../guide/component-doc.md#4-决策图例固定-6-个不新增)（§1–§3「决策」列）

**跨端对照**：[mobile-vue Fab](https://tdesign.tencent.com/mobile-vue/components/fab?tab=api) · 默认 `TButton` 内核（非 Material `FloatingActionButton`）

---

## 架构

**T2 组合**：`TFab` = **定位层**（默认右下角悬浮 + 可选拖拽/吸附/边界）+ **动作层**（默认内嵌 [`TButton`](./button.md)；`child` 可完全自定义）

对齐跨端：**Fab 负责「浮」与交互区域**；按钮外观/主题/尺寸经 **`buttonProps` 透传内嵌 [`TButton`](./button.md)**（与 mobile-vue `buttonProps → Button` 一致）。纯图标时内嵌按钮 `shape: circle`；有 `text` 时 `shape: round`。

`onPressed: null` = 禁用（写入内嵌 `TButton.onPressed`，或 `child` 模式见 **§1.2.1**）· `TFabThemeData` **仅**管 Fab 定位层默认（偏移、边界、吸附动画）

**无 `TFabButton` 组件**：动作层默认 **内嵌 [`TButton`](./button.md)**；`buttonProps: TButtonProps?` 为内嵌按钮的可选配置，字段见 **§1.2**。

| 层 | 职责 | 跨端 |
| --- | --- | --- |
| 定位层 | `right`/`bottom` 默认偏移、`draggable`、`magnet`、`xBounds`/`yBounds` | `style` + 拖拽 API |
| 动作层 | `icon` + `text` 或 `child` | `icon` 插槽 + `text` / `default` 插槽 |
| 透传 | `buttonProps` | `TButtonProps?` → 内嵌 [`TButton`](./button.md) |

**实现模块**（单路径 resolve，见 **§3.1**）：

| 文件 | 职责 |
| --- | --- |
| `t_fab.dart` | Widget；收集扁平构造参数 → 调 resolve |
| `t_fab_resolve.dart` | `resolveLayout` / `resolveButton` **唯一** merge 入口 |
| `t_fab_defaults.dart` | Fab 内嵌 `TButton` 默认（large · primary · shape 推导） |
| `t_fab_drag.dart` | 拖拽、吸附、点击/拖动阈值 |
| `t_fab_theme_data.dart` | 定位层 ThemeExtension |
| `t_fab_layout.dart` | `TFabLayout` 模型（由扁平 L1 字段组装，见 **§1.4**） |

---

## 1. v1.0 定稿 API（当前规范）

层级 → [api.md §1](../../foundation/api.md#1-构造器四层l1l4)

### 构造器

| 决策 | 参数 / 方法 | 层级 | 类型 | 默认 | 说明 |
| --- | --- | --- | --- | --- | --- |
| | `text` | L2 | `String` | `''` | 图标+文字形态；非空时内嵌 `TButton` 为 `round` |
| 🔀 | `icon` | L2 | `Widget?` | — | 见 **§1.1**；未传默认 `Icon(TIcons.add)` |
| ✨ | `child` | L2 | `Widget?` | — | 自定义内容；**有则替代**默认内嵌 `TButton`；见 **§1.2.1** |
| ✨ | `buttonProps` | L2 | `TButtonProps?` | — | 内嵌 `TButton` 的部分配置；见 **§1.2** |
| ✏️ | `onPressed` | L3 | `VoidCallback?` | — | `null` 禁用；对齐跨端 `onClick` |
| ✨ | `tooltip` | L2 | `String?` | — | 纯图标 Fab 提示（对齐 Material `tooltip`） |
| ✨ | `semanticLabel` | L2 | `String?` | — | 读屏标签；未传且纯图标时可回退 `tooltip` |
| ✨ | `right` | L1 | `double?` | Theme `defaultRight`（16） | 距屏幕右侧；与 `bottom` 共同定位 |
| ✨ | `bottom` | L1 | `double?` | Theme `defaultBottom`（32） | 距屏幕底部 |
| ✨ | `draggable` | L1 | `TFabDragAxis?` | `null` | `all` · `vertical` · `horizontal`；见 **§2.5** |
| ✨ | `magnet` | L1 | `TFabMagnet?` | `null` | 拖拽结束左右吸附：`left` · `right` |
| ✨ | `xBounds` | L1 | `TFabBounds?` | Theme | 水平边界；见 **§1.4** |
| ✨ | `yBounds` | L1 | `TFabBounds?` | Theme | 垂直边界 |
| ✨ | `onDragStart` | L3 | `TFabDragCallback?` | — | 开始拖拽；见 **§1.3** |
| ✨ | `onDragEnd` | L3 | `TFabDragCallback?` | — | 结束拖拽 |

#### §1.1 icon 行为

`icon` 由 **`TFab` 构造器**传入内嵌 `TButton`；尺寸/颜色补齐规则与 [button.md §1.1](./button.md#11-icon-行为) 一致（**不**从 `buttonProps` 读取 `icon`）。

#### §1.2 `buttonProps` 与内嵌 `TButton`

未传 `child` 时，Fab 经 **`resolveButton`（§3.1）** resolve 一颗 [`TButton`](./button.md)。

**`TButtonProps`**（Fab 侧类型）：可选 `size` · `variant` · `colorScheme` · `shape` · `style`（与 [`TButton` §1](./button.md#1-v10-定稿-api当前规范) 同名字段对齐）；**不含** `onPressed`、`child`、`icon`。

**维护约束**：Fab **不得**复制 `TButton` 完整 resolve；仅 merge `TFabDefaults` + `buttonProps` + `TFab.text`/`icon`/`onPressed`，再构造 `TButton`  delegate 其 Theme 链。

| 传入 | 行为 |
| --- | --- |
| `buttonProps` 未传 | `TFabDefaults` + `text`/`icon` |
| `buttonProps` 部分字段 | merge 进默认；未传字段保持 Fab 默认 |
| `child` 有值 | 不内嵌 `TButton`；忽略 `buttonProps`；见 **§1.2.1** |
| `text` + `icon` | 内容糖；不由 `buttonProps` 承载 |

**样式入口**：`variant` / `colorScheme` / `size` / `shape` / `style` → **`buttonProps` 或 [`TButtonThemeData`](./button.md#2-theme)**；阴影/elevation **仅**跟 `TButton`，`TFabThemeData` 不设 `elevation`。

#### §1.2.1 `child` 模式（点击与禁用）

| 项 | 行为 |
| --- | --- |
| 点击 | Fab 外层 `Listener`/`GestureDetector` 统一触发 **`TFab.onPressed`**；**不**在 `child` 外再包 `TButton`/`InkWell`（避免双重点击区） |
| 禁用 | `onPressed == null` → 外层 `IgnorePointer`（或等价）；`child` 内部手势不响应 |
| `buttonProps` | **忽略** |
| `tooltip` / `semanticLabel` | 包在可点击区域外层 `Tooltip` / `Semantics` |

#### §1.3 拖拽回调与 `TFabDragDetails`

对齐 Flutter 手势语义；回调签名：

```dart
typedef TFabDragCallback = void Function(TFabDragDetails details);

class TFabDragDetails {
  /// 当前偏移（相对父 Stack 内容区，已含安全区）
  final Offset position;
  /// 对应 onDragStart / onDragEnd 的原始手势（高级用法，可选）
  final DragStartDetails? start;
  final DragEndDetails? end;
}
```

#### §1.4 `TFabLayout` · `TFabBounds`（分组模型）

**公开构造器保持扁平 API**（对齐 mobile-vue）。实现侧将 L1 定位字段收拢为 **`TFabLayout`**（`resolveLayout` 入参），避免 `build` 内散落。

| 类型 | 字段 | 说明 |
| --- | --- | --- |
| `TFabLayout` | `right` · `bottom` · `draggable` · `magnet` · `xBounds` · `yBounds` | 内部模型；由构造器扁平字段组装 |
| `TFabBounds` | `start` · `end` | 水平：`left`/`right` 留白；垂直：`top`/`bottom` 留白（px） |

跨端对照：`xBounds: [16, 16]` → `TFabBounds(start: 16, end: 16)`。

#### §1.5 挂载与定位（单一路径）

`TFab` **自带定位**（`right` / `bottom` + 可选拖拽/吸附/边界），与 `Scaffold.floatingActionButton` **两套平行机制，只选一套**。

| 场景 | v1.0 写法 |
| --- | --- |
| 标准页内悬浮（推荐） | `Stack(fit: StackFit.expand)` 顶层放 `TFab(...)`；`Positioned` + `MediaQuery.padding` 安全区 |
| 页面含 `Scaffold` | `TFab` 在 **`body` 内 `Stack` 顶层**；**不要**用 `Scaffold.floatingActionButton` |
| 固定悬浮、不需拖拽 | `不传 draggable`（默认）；仍用 `Stack` + `right`/`bottom` |
| Demo 横排 | `Row`/`Wrap` + `不传 draggable`；仅文档示例 |

与 [TBackTop](../02-navigation/backtop.md) 区分：BackTop 绑定滚动回顶；Fab 为通用操作 + 可拖拽。

### 类型

| 决策 | 类型 | 成员 | 用于 |
| --- | --- | --- | --- |
| ✨ | `TFabDragAxis` | all · vertical · horizontal | `draggable` |
| ✨ | `TFabMagnet` | left · right | `magnet` |
| ✨ | `TFabBounds` | `start` · `end` | `xBounds` / `yBounds` |
| ✨ | `TFabLayout` | 见 §1.4 | 实现侧；**不** export |
| ✨ | `TFabThemeData` | ThemeExtension | §2 |
| ✨ | `TButtonProps` | 见 §1.2 | `buttonProps` |
| ✨ | `TFabDragDetails` | `position` · `start` · `end` | 拖拽回调 |
| | `TFabDragCallback` | `void Function(TFabDragDetails)` | `onDragStart` / `onDragEnd` |

### export

| 符号 | 说明 |
| --- | --- |
| `TFab` | 悬浮动作按钮 Widget |
| `TButtonProps` | 内嵌 `TButton` 透传配置 |
| `TFabDragAxis` | 拖拽轴枚举 |
| `TFabMagnet` | 吸附方向枚举 |
| `TFabBounds` | 拖拽边界模型 |
| `TFabDragDetails` | 拖拽回调信息 |
| `TFabDragCallback` | 拖拽回调类型 |
| `TFabThemeData` | ThemeExtension |

---

## 2. Theme

`TFabThemeData` = **定位层**默认；按钮样式 **仅** [`TButtonThemeData`](./button.md#2-theme) · [theme.md](../../foundation/theme.md)

| 场景 | 配置位置 |
| --- | --- |
| 定位/拖拽默认 | `TFabThemeData` |
| 按钮外观 | `buttonProps` / `TButtonThemeData` |

**不**映射 `floatingActionButtonTheme`（内嵌 `TButton`，非 `FloatingActionButton`）。

| 决策 | 字段 | 管什么 |
| --- | --- | --- |
| ✨ | `defaultRight` / `defaultBottom` | 默认偏移（16 / 32） |
| ✨ | `defaultXBounds` / `defaultYBounds` | 默认 `TFabBounds` |
| ✨ | `magnetAnimationDuration` | 吸附动画 |
| ✨ | `dragTapSlop` | 点击 vs 拖拽阈值（逻辑像素） |

### 2.5 拖拽与吸附

1. `不传 draggable`：固定 `right`/`bottom`。
2. `draggable: TFabDragAxis.all` / `all`：全向；`vertical` / `horizontal` 单轴。
3. `xBounds` / `yBounds`：`TFabBounds` 限制范围。
4. `magnet`：拖拽结束吸附；仅支持 `TFabMagnet.left/right`，不传则不吸附。
5. 位移 ≤ `dragTapSlop` → `onPressed`；否则 `onDragStart` → `onDragEnd`。

**resolve**：`resolveLayout`（安全区 + 偏移 + 拖拽）→ `resolveButton`（`buttonProps` > `TButtonThemeData` > Token）

---

## 3. 实现约定

### 3.1 单路径 resolve

```dart
// t_fab_resolve.dart — 唯一 merge 入口；禁止在 build 内联 merge
TFabLayout resolveLayout(TFab widget, TFabThemeData theme, EdgeInsets safePadding);
Widget resolveButton(BuildContext context, TFab widget, TFabThemeData fabTheme);
```

`resolveButton` 输出 **一颗** `TButton` 或 `child` 包裹层（§1.2.1）；**不**复制 `TButton` 的 variant/shape Theme 展开逻辑。

### 3.2 与 BackTop 共用定位（后续）

Fab 与 [TBackTop](../02-navigation/backtop.md) 均涉及右下角偏移 + 安全区。后续可抽到 **内部 util**（不 export）：

| 路径（规划） | 职责 |
| --- | --- |
| `lib/src/util/floating_anchor.dart` | 安全区、`Positioned` 偏移计算；Fab / BackTop 共用 |

v1.0 Fab 可先本地实现；抽 util 时 **不改变** §1 公开 API。

### 3.3 测试与 Example 契约

| 必测 | 断言 |
| --- | --- |
| `resolveButton` 默认 / `buttonProps` merge | `size`/`colorScheme`/shape 推导 |
| `text` 空与非空 | `circle` vs `round` |
| `onPressed: null` | 内嵌 `TButton` 与 `child` 模式均不可点 |
| `child` 模式 | 仅外层一次 `onPressed`；无嵌套 `InkWell` |
| 拖拽阈值 | 小位移触发 `onPressed`；大位移走 drag 回调 |
| `resolveLayout` + 安全区 | 刘海/Home 条不遮挡 |

**Example**：除横排 demo 外，须有 **`Stack(fit: StackFit.expand)` 真实页**（与 §1.5 一致），覆盖纯图标 / 文字 / 拖拽。

# Theme 方案（v1.0）

> **已定稿（2025-06）** · 开发环境 → [developer-guide.md](../guide/developer-guide.md)

---

## 0. Token / 组件 / Theme.of 三者关系

> 本节回答「CSS Token、项目组件、`Theme.of` 三者如何衔接」；四层架构细节见 [§1](#1-四层架构)。

TDesign 的设计令牌（web 端以 **CSS 变量**承载：色板 / 间距 / 圆角 / 字阶）是**设计值的唯一源头**，但 Flutter 没有 CSS——它在 Flutter 端**物化为 `TThemeData`**（L1），组件读的是经 Token 解析后的样式，而非 CSS 本身。

### 流转链路

```
CSS Token（设计源）
   │  搬到 Dart → TThemeData
   ▼
L1  TThemeData（JSON Token）                     ← P4 最底层、唯一真源
   │  TMaterialThemeBuilder
   ▼
L2  ThemeData + ColorScheme（Material 主题）      ← P3
   │  Theme.of(context) 读取
   ▼
L3  T{Xxx}ThemeData（组件 ThemeExtension）        ← P1 组件默认样式
   │  Theme.of(context).extension<T{Xxx}ThemeData>()
   ▼
L4  Widget 实例 style / decoration               ← P0 逃逸舱（最高优先级）
```

优先级（覆盖方向，强 → 弱）：**P0 实例 > P1 组件 Theme > P2 Material > P3 ColorScheme > P4 Token**。

### 与 `Theme.of` 的关系

| 想要 | 怎么取 | 层级 |
| --- | --- | --- |
| 全局设计 Token（色板 / 间距原始值） | `Theme.of(context).extension<TThemeData>()` | P4 |
| Material 子主题 / `ColorScheme` / `TextTheme` | `Theme.of(context)`（返回 `ThemeData`） | P2 / P3 |
| 某组件的样式默认 | `Theme.of(context).extension<T{Xxx}ThemeData>()` | P1 |
| 单颗强覆盖 | 构造器 `style` / `decoration`，或子树 `mergeExtension` | P0 |

> 要点：v1.0 **不用**旧 `TTheme.of`，统一走 Material 的 `Theme.of(context)`；子树覆盖用 `mergeExtension(...)`，**禁用** `copyWith(extensions:)`（见 [§3](#3-子树覆盖)）。Token → ColorScheme 映射见 [总规范 §1.3](../../v1.0-redesign-spec.md#13-token--colorscheme-映射表)。

---

## 1. 四层架构

```
L1  TThemeData           — JSON Token
L2  TMaterialThemeBuilder — Token → ThemeData（M3 子主题）
L3  T{Xxx}ThemeData      — 组件 ThemeExtension
L4  Widget 实例           — style / decoration 逃逸舱
```

**v1.0 定稿**：移除 `TTheme` 单例；`TThemeBuilder.light/dark(token)` 为入口。对齐 `MaterialApp.theme` / `darkTheme` / `themeMode`。

---

## 2. 样式优先级 P0–P4

| 级 | 来源 |
|---|---|
| P0 | 实例 `style` / `decoration` / `variant` |
| P1 | `T{Xxx}ThemeData` |
| P2 | Material 子主题（`filledButtonTheme` 等） |
| P3 | `ThemeData.colorScheme` / `textTheme` |
| P4 | `TThemeData` Token |

口诀：**实例 > 组件 Theme > Material > Token**。

### 2.1 ThemeData 字段归类（v1.0 裁决）

> 全库 `T{Xxx}ThemeData` / 浮层 `TPopupThemeData` 均按本节归类；细则 → 各组件 §Theme。

#### 进 Theme（P1 · 样式默认）

| 类别 | 示例 |
|------|------|
| **色** | `backgroundColor` · `overlayColor` · 文案色 |
| **边距** | `padding` · `margin` · `gap` · 列表分割线间距 |
| **宽高** | `width` · `height` · `drawerTop` · `itemHeight` · `itemMinWidth` |
| **边框 / 圆角 / 阴影** | `bordered` · `radius` · `elevation` · `boxShadow` |
| **状态样式** | `hover` 按压高亮 · `pressed` / `disabled` 色（`WidgetStateProperty` / `TCellThemeData`） |
| **动效参数** | `duration` · `curve` · `delay`（画面过渡节奏；**非** Toast 停留时长） |

#### 不进 Theme（构造器 / show · L1–L3）

| 类别 | 示例 |
|------|------|
| **浮层策略** | `showOverlay` · `closeOnOverlayClick` · `useSafeArea` |
| **能力开关** | `showCancel` · `scrollable` · `showPagination` |
| **交互语义** | `onClose` · `onItemClick` · `onChanged`；点项后是否 `handle.close()` |
| **停留 / 业务时序** | Toast `duration`（显示多久） |

#### 动画与 Material

| 项 | v1.0 |
|----|------|
| 默认过渡 | `TPopupThemeData`：`animationDuration` · `animationCurve`（及组件自有 Theme） |
| 单次覆盖 | `show` / Route 可选参数（对齐 M3 `AnimationStyle` 思路） |
| 不进 Theme | 浮层「要不要蒙层」「点蒙层关不关」 |

#### TPopup 系分工（范例）

| 对象 | 归类内容 |
|------|----------|
| **`TDrawerThemeData`** | 色 · 边距 · `width` / `drawerTop` · 边框 · `TCellThemeData` · `hover` 按压样式 |
| **`TActionSheetThemeData`** | 色 · 圆角 · `itemHeight` / `itemMinWidth` · `cancelText` · `defaultAlign` · 宫格 `count` / `rows` 等**布局默认** |
| **`TPopupThemeData`** | 蒙层色 · 过渡 `duration` / `curve` |
| **构造器 / `show*` L3** | `showOverlay` · `closeOnOverlayClick` · `showCancel` · `scrollable` · `useSafeArea` · 回调 |

→ [drawer.md §3](../components/02-navigation/drawer.md#3-theme-主题配置) · [popup.md §3](../components/05-feedback/popup.md#3-theme) · [action-sheet.md §2](../components/05-feedback/action-sheet.md#2-theme)

#### 禁止构造器 `themeData`（v1.0 裁决）

对齐 M3：**样式默认只从 `Theme.of(context)` 读取**（全局 / 子树 `mergeExtension`）。**全库不提供** `T{Xxx}(..., themeData: …)` 构造器参数。

| 场景 | v1.0 做法 |
|------|-----------|
| 全 App / 一片区域默认 | `MaterialApp.theme` · `Theme(data: …mergeExtension(T{Xxx}ThemeData(...)), child: …)` |
| 单颗组件与周围不同 | **`Theme` 子树包裹**（上表），或 P0 逃逸舱 `style` / `decoration` |
| E 类浮层 `show()` | 打开方 `context` 上的 Theme；**无** `themeData` |

```dart
// ✅ 单颗 Indexes 定制样式
Theme(
  data: Theme.of(context).mergeExtension(
    const TIndexesThemeData(capsuleTheme: true),
  ),
  child: TIndexes(contentBuilder: ...),
)

// ❌ 不提供
TIndexes(themeData: TIndexesThemeData(...));
```

### 2.2 P0 逃逸舱判定（写 / 评审组件）{#22-p0-逃逸舱判定}

> **默认**：全库**多数组件无** P0 `style` / `decoration`；L4 进 `T{Xxx}ThemeData`，单颗差异用 **子树 `mergeExtension`** 或 **L1 构造器单项**（`variant` · `status` 等）。
> **例外**：Material 有同名逃逸舱，或极少数需「一颗整包覆写」resolve 时，才在 §1 增加 P0 行。

#### 四问判定（按序）

| # | 问题 | 是 → | 否 → |
|---|------|------|------|
| 1 | Material Widget 有 **`style` / `decoration`** 吗？ | 考虑 P0；类型**跟 Material 同名**（`ButtonStyle?` · `InputDecoration?` · `TextStyle?`） | 继续 ↓ |
| 2 | 单颗差异能用 **子树 `mergeExtension`** 吗？ | **不要 P0** | 继续 ↓ |
| 3 | 能用 **L1 构造器单项**覆盖吗？（`variant` · `colorScheme` · `status` · 项级 `textStyle` 等） | **不要 P0** | 继续 ↓ |
| 4 | resolve 字段很多，且业务**常要一颗整包覆写**吗？ | 可选自研 `T{Xxx}Style?`（**少见**；须在 §1 标明 P0 与 resolve 顺序） | **不要 P0** |

**默认结论**：四问走完仍为「否」→ **不提供** P0；组件 md §1 **不写** `style: T{Xxx}Style?` 规划行。

#### 全库现况（v1.0 定稿）

| 有 P0 | 参数 | 说明 |
|-------|------|------|
| [TButton](../components/01-base/button.md) | `ButtonStyle? style` | Material 同名；✅ |
| [TText](../components/01-base/text.md) | `TextStyle? style` | Material 同名；✅ |
| [TInput](../components/03-input/input.md) · [TTextarea](../components/03-input/textarea.md) | `InputDecoration? decoration` | Material 同名；✅ |
| [TFab](../components/01-base/fab.md) | 经 `buttonProps.style` | 委托 Button P0 |
| **其余组件** | — | **无 P0**（含 SideBar · Steps · Tabs · Navbar · Switch · Cell …） |

自研 `T{Xxx}Style` **非默认模板**；新增前须在四问表记录裁决理由。

#### 组件 md 写法

- **有 P0**：§1.1 表单独一行，层级列 **`P0`**，说明写「覆盖 resolve / 非日常入口」；§3 覆盖顺序写明 **P0 > P1 Theme > …**
- **无 P0**：§3「单颗」行只写 **子树 `mergeExtension`** 或 **构造器 L1 覆盖**；**禁止**写「规划逃逸舱」占位
- §2 **禁止**新增构造器 `themeData`（→ 上节）

→ 构造器四层 [api.md §1](./api.md#1-构造器四层l1l4) · 撰写清单 [component-doc.md §8](../guide/component-doc.md#8-去重检查清单发布前)

---

## 3. 子树覆盖

```dart
// ❌ 会覆盖其它 Extension（如 TThemeData）
Theme.of(context).copyWith(extensions: [TButtonThemeData(...)])

// ✅ merge，勿 copyWith(extensions: [...]) 覆盖
Theme.of(context).mergeExtension(
  TButtonThemeData(
    defaultVariant: TButtonVariant.outlined,
    filledStyle: ButtonStyle(
      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 16)),
    ),
  ),
)
```

### 3.1 TButton 速查（S1）

字段分工 → [button.md §3](../components/01-base/button.md#3-theme)

**全局**（全 App 默认）：`TThemeBuilder` 写入 `TButtonThemeData`（P1）+ Material 子主题（P2）+ Token（P4）。

```dart
MaterialApp(
  theme: TThemeBuilder.light(token),
  darkTheme: TThemeBuilder.dark(token),
  // 改全局 Button 默认（仍走 merge，勿覆盖其它 Extension）
  // theme: TThemeBuilder.light(token).mergeExtension(
  //   TButtonThemeData(defaultVariant: TButtonVariant.outline, shape: ...),
  // ),
)
```

**多颗各不同**：三层正交，按粒度选最浅一层即可。

| 粒度 | 做法 | 管什么 |
| --- | --- | --- |
| 单颗 | 构造器 `variant` / `colorScheme` / `size`；破例用 P0 `style` | 该实例（优先于 Theme） |
| 一区 | `Theme(data: …mergeExtension(TButtonThemeData(...)), child: …)` | 子树未传构造器项 |
| 全局 | 上表 `MaterialApp.theme` | 全 App 默认 |

```dart
// 同页多配色：构造器 colorScheme（L1），互不干扰
Row(children: [
  TButton(colorScheme: TButtonColorScheme.primary, onPressed: () {}, child: Text('主')),
  TButton(colorScheme: TButtonColorScheme.danger, onPressed: () {}, child: Text('危')),
])

// 同页两区不同默认外形/形态：子树 mergeExtension
Column(children: [
  Theme(
    data: Theme.of(context).mergeExtension(
      TButtonThemeData(defaultVariant: TButtonVariant.fill, shape: ...),
    ),
    child: TButton(onPressed: () {}, child: Text('填充区')),
  ),
  Theme(
    data: Theme.of(context).mergeExtension(
      TButtonThemeData(defaultVariant: TButtonVariant.outline),
    ),
    child: TButton(onPressed: () {}, child: Text('描边区')),
  ),
])
```

口诀：**改全站 → Builder/Token；改一片 → mergeExtension；改一颗 → 构造器 / `style`**。

---

## 4. Material vs ThemeExtension

| Material 有 | TDesign 独有（设计稿必需） |
|---|---|
| 用 `ButtonStyle`、`inputDecorationTheme`、`WidgetStateProperty` 等 | 进 `T{Xxx}ThemeData` 扩展字段（如 `gradient`、强制字重） |
| 禁用走 `onPressed: null` / `onChanged: null` / `enabled` | 不进构造器 L4 |
| `ThemeData.colorScheme` / `textTheme`（P3） | Token 经 `TMaterialThemeBuilder` 写入，P4 回读仅 TD 专有项 |

**裁决**：先查 Material 子主题能否表达 → 能则 P2；不能且跨组件复用 → P1 Extension；仅单实例 → 子树 Theme 或 L1 单项；**极少数** → P0 逃逸舱（→ [§2.2](#22-p0-逃逸舱判定) 四问，**默认无**）。

组件 md §2.1 必填「Material 字段 vs TDesign 扩展」对照表。

---

## 5. 0.2.x → v1.0 主题 API

| 0.2.x | v1.0 |
|---|---|
| `TTheme.of(context)` | `Theme.of(context).extension<TThemeData>()` |
| `systemThemeDataLight` 薄映射 | `TThemeBuilder.light(token)` |
| `enum TButtonTheme` | `TButtonColorScheme` + 参数 `colorScheme:` |
| `TButtonStyle` / `*_style.dart` | `TButtonThemeData`；**不 export** Style |
| 构造器 L4（色/间距/圆角） | `T{Xxx}ThemeData` 或 `style` 逃逸舱 |
| `TTheme._singleData` | 删除 |

---

## 6. v1.0 新增

| API | 职责 |
|---|---|
| `TMaterialThemeBuilder` | Token → 完整 `ThemeData` |
| `TThemeBuilder.light/dark()` | 应用入口 |
| `T{Xxx}ThemeData` | 组件 ThemeExtension（S1：Button/Input/Switch/Checkbox/Radio/Slider/Text/Divider） |
| `TStyleResolver` | P0–P4 统一解析 |
| `ThemeData.mergeExtension<T>()` | 子树 merge Extension |

Token → ColorScheme 映射 → [总规范 §1.3](../../v1.0-redesign-spec.md#13-token--colorscheme-映射表)

---

## 7. 组件 ThemeExtension 速查（S2 · TText）

> 覆盖顺序 · 核心扩展 · 模块划分 → [text.md](../components/01-base/text.md)

### 7.1 注册与读取

| 项 | v1.0 |
| --- | --- |
| 类型 | `TTextThemeData extends ThemeExtension<TTextThemeData>` |
| 注册 | `TMaterialThemeBuilder` 写入 `ThemeData.extensions`（与 `TButtonThemeData` 同模式） |
| 读取 | `Theme.of(context).extension<TTextThemeData>()` |
| 子树 | `Theme.of(context).mergeExtension(TTextThemeData(...))` |

### 7.2 Material vs TDesign

| 能力 | P2 `TextTheme` / `DefaultTextStyle` | P1 `TTextThemeData` | 子树 `TTextConfiguration` |
| --- | --- | --- | --- |
| 字号/字重/行高 | `bodyLarge` 等 | `defaultFont`（`Font` Token） | — |
| 前景色 | `TextTheme.*.color` | `defaultTextColor` | — |
| 删除线默认 | — | `isTextThrough` · `lineThroughColor` | — |
| 强制居中默认 | — | `forceVerticalCenter` | `paddingConfig`（算法） |
| 全局字体族 | `fontFamily`（经 Builder） | — | `globalFontFamily` |
| 布局/缩放 | — | `strutStyle` · `textWidthBasis` · `textHeightBehavior` · `textScaleFactor` | — |

**裁决**：Material `TextTheme` 仍作 P2；TDesign 专有项（`forceVerticalCenter`、删除线默认、`Font` Token 默认）进 P1；子树字体与居中算法 **不**并入 ThemeExtension，保留 `TTextConfiguration`（对齐 [redesign-spec §3.3](../../v1.0-redesign-spec.md#33-inheritedwidget-迁移策略)）。

### 7.3 `TTextThemeData` 字段

| 字段 | 类型 | 默认来源 | 0.2.x 构造器 |
| --- | --- | --- | --- |
| `defaultFont` | `Font?` | Token `fontBodyLarge` | `font` |
| `defaultTextColor` | `Color?` | Token `textColorPrimary` | `textColor` |
| `defaultBackgroundColor` | `Color?` | — | `backgroundColor` |
| `forceVerticalCenter` | `bool` | `false` | `forceVerticalCenter` |
| `isTextThrough` | `bool` | `false` | `isTextThrough` |
| `lineThroughColor` | `Color?` | 同前景色 | `lineThroughColor` |
| `isInFontLoader` | `bool` | `false` | `isInFontLoader` |
| `strutStyle` | `StrutStyle?` | — | `strutStyle` |
| `textWidthBasis` | `TextWidthBasis?` | Material 默认 | `textWidthBasis` |
| `textHeightBehavior` | `TextHeightBehavior?` | — | `textHeightBehavior` |
| `textScaleFactor` | `double?` | `1.0` | `textScaleFactor` |

`copyWith` · `lerp` 与其它 `ThemeExtension` 一致；`TThemeBuilder.light/dark` 须提供合理默认值。

# Theme 方案（v1.0）

> **已定稿（2025-06）** · 开发环境 → [developer-guide.md](../guide/developer-guide.md)

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

**裁决**：先查 Material 子主题能否表达 → 能则 P2；不能且跨组件复用 → P1 Extension；仅单实例 → P0 逃逸舱。

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

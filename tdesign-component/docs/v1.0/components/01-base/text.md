# TText — 架构设计（v1.0）

> Sprint **S2** | 控制类 **—**（纯展示）· **Tier T2** · 源码：`lib/src/components/text`
> Theme 字段 → [theme.md §7](../../foundation/theme.md#7-组件-themeextension-速查s2--ttext) · 全局规范 → [developer-guide](../guide/developer-guide.md)

---

## 1. 定位

| 项 | 裁决 |
| --- | --- |
| 是什么 | TDesign 对 Material **`Text` / `Text.rich`** 的 **T2 薄包装** |
| 不是什么 | 非动作控件（无 `onPressed` / 禁用态）· 非自绘字形 |
| 为何存在 | ① 用 **`Font` Token** 降低 `TextStyle` 配置成本；② **`forceVerticalCenter`** 解决中文与图标/按钮混排的视觉居中；③ **`getRawText`** 与只认系统 `Text` 的 API 互操作 |
| 与系统 `Text` | **超集**：保留 `Text` 全能力，底层仍委托 `Text` 渲染 |

---

## 2. 分层架构

```
┌─────────────────────────────────────────────────────────┐
│  TText / TText.rich（Widget）                              │
├─────────────────────────────────────────────────────────┤
│  布局层   textAlign · maxLines · overflow · …（同 Text）   │
│  扩展层   forceVerticalCenter → Container + padding       │
│  样式层   resolve → TextStyle → Text / Text.rich         │
│  互操作   getRawText() → 裸 Text（丢扩展层包装）            │
└─────────────────────────────────────────────────────────┘
         ▲                    ▲                    ▲
         │                    │                    │
   TTextThemeData    TTextConfiguration      P0 style
   （视觉默认 P1）    （子树行为）            （逃逸舱）
```

| 层 | 职责 | 主要类型 |
| --- | --- | --- |
| **内容** | 纯文案或富文本 | `data` · `TText.rich` + `TTextSpan` |
| **布局 / 语义** | 与 `Text` 对齐 | `textAlign` · `maxLines` · `overflow` · `semanticsLabel` 等 |
| **样式** | Token 糖 → `TextStyle` | `font` · `textColor` · `isTextThrough` 等；默认由 Theme 提供 |
| **扩展** | TDesign 专有行为 | `forceVerticalCenter` · 外层 `backgroundColor` · `fontFamilyUrl` |
| **子树** | 非 Theme 的 Inherited 上下文 | `TTextConfiguration` |

---

## 3. 与 Material `Text` 的分工

| 能力 | Material `Text` | `TText` |
| --- | --- | --- |
| 渲染 | 原生 | 内部 `_getRawText` → `Text` / `Text.rich` |
| 默认样式 | `TextTheme` / `DefaultTextStyle` | `TTextThemeData` → `TextTheme` → Token（P1→P2→P4） |
| 配样式 | 主要 `TextStyle` | 扁平糖 + P0 `style` 覆盖 |
| 中文混排居中 | ❌ | ✅ `forceVerticalCenter` |
| 背景色 | `TextStyle.background` | 外层 **`Container.color`**（避免中英文混排阶梯色） |
| 删除线 | `TextStyle.decoration` | 糖参数 `isTextThrough` |
| 远程字体 | 自行 `FontLoader` | `fontFamilyUrl` → `TFontLoaderWidget` |
| 转系统组件 | — | `getRawText(context)` |

---

## 4. 配置双轨

视觉默认与子树行为 **刻意拆分**，不合并进同一个 ThemeExtension。

| 机制 | 类型 | 管什么 | 典型场景 |
| --- | --- | --- | --- |
| **`TTextThemeData`** | `ThemeExtension` | 默认字体/颜色/删除线/是否默认居中等 | App / 页面级 `mergeExtension` |
| **`TTextConfiguration`** | `InheritedWidget` | `globalFontFamily` · `paddingConfig`（居中算法） | App 根或局部子树包一层 |

**覆盖顺序**（样式 resolve）：

```
P0 style  >  构造器糖  >  TTextConfiguration  >  TTextThemeData  >  TextTheme  >  Token
```

字段明细 → [theme.md §7](../../foundation/theme.md#7-组件-themeextension-速查s2--ttext)。

---

## 5. 核心扩展

### 5.1 `forceVerticalCenter`

TDesign **相对系统 `Text` 的最大差异**。

| 项 | 说明 |
| --- | --- |
| 问题 | TDesign `Font` 行高与系统 `Text` 不一致，与图标/按钮横排时视觉不居中 |
| 做法 | `forceVerticalCenter: true` → 定高 `Container` + `TTextPaddingConfig` 算 `padding` |
| 分端 | Android / iOS / Web / OHOS 各自校准（`TTextPaddingConfig`） |
| 限制 | 英文混排 · 多行 · `maxLines > 1` 可能偏移 |
| `getRawText` | 转出系统 `Text` 后 **丢失** padding 居中 |
| 约束 | 内部居中只处理 `TText` 自身；Row 混排仍由父布局负责 |

### 5.2 样式糖（扁平化 `TextStyle`）

将常用 `TextStyle` 字段提到构造器外层，映射 `Font` Token，例如 `font` · `textColor` · `isTextThrough`（删除线开关）· `lineThroughColor`。

- **实例覆盖**：构造器糖参数优先于 `TTextThemeData`，用于单个 `TText` / `TTextSpan` 的局部样式
- **破例**：P0 `style` 覆盖 resolve 任意字段

### 5.3 `getRawText`

供 `Image`、部分 Material API 等 **只接受系统 `Text`** 的场景。转出后仅保留 `TextStyle` 与布局参数，**不含**扩展层包装。

### 5.4 `fontFamilyUrl`

非空时 Widget 树外包 `TFontLoaderWidget`，加载完成后再走正常 build；业务侧只配 `fontFamilyUrl`，不直接使用 `TFontLoaderWidget`。

---

## 6. 配套类型

| 类型 | 角色 |
| --- | --- |
| **`TTextSpan`** | `TextSpan` 扩展；样式糖与 `TText` 对齐；**共用** `t_text_resolve.dart` |
| **`TTextPaddingConfig`** | 居中 padding 算法；可经 `TTextConfiguration.paddingConfig` 自定义 |
| **`TFontLoader`** | 远程字体加载工具 |

**`TText` vs `TTextSpan` 语义差**（架构须区分）：

| 项 | `TText` | `TTextSpan` |
| --- | --- | --- |
| `forceVerticalCenter` | 外层生效 | 随父级 `TText`，Span 自身不居中 |
| `backgroundColor` | 外层 `Container` | `TextStyle.backgroundColor` |
| `context` | Widget `build` 自带 | 纯 Span 树无父 context 时构造器须传 |

---

## 7. 样式 resolve（单路径）

架构要求：`TText.getTextStyle` 与 `TTextSpan` 内部样式逻辑必须共用同一 resolve 入口，避免富文本与纯文本样式不一致。

**v1.0 架构约束**：`t_text_resolve.dart` 为 **唯一** `getTextStyle` 入口；平台规则只写一处：

| 规则 | 处理 |
| --- | --- |
| iOS `FontWeight ≤ w500` 且无 `fontFamily` | 回退 `PingFang SC` |
| 子树全局字体 | `TTextConfiguration.globalFontFamily` |
| 前景背景 | `TText` 用 `Container`，**不用** `TextStyle.backgroundColor` 做块背景 |
| Web 居中 | 行高微调 + `TTextPaddingConfig` 独立分支 |

**build 管线**：

```
fontFamilyUrl? → TFontLoaderWidget
forceVerticalCenter? → Container(height + padding) → Text
backgroundColor?     → Container(color) → Text
否则                 → Text / Text.rich
```

---

## 8. 模块划分（规划）

| 文件 | 职责 |
| --- | --- |
| `t_text.dart` | `TText` · `TTextSpan` · `TTextConfiguration` · `TTextPaddingConfig` |
| `t_text_resolve.dart` | 样式 merge + 平台补丁 |
| `t_text_theme_data.dart` | `ThemeExtension` |
| `t_font_loader.dart` | 远程字体 |
| `t_text_vertical_align.dart` | 可选的 metrics 居中扩展实现 |

---

## 9. 实现约定

| 文件 | 约束 |
| --- | --- |
| `t_text_resolve.dart` | `TText` 与 `TTextSpan` 共用单一路径，避免纯文本与富文本样式不一致 |
| `t_text_theme_data.dart` | 只承载视觉默认值，不放运行时全局开关 |
| `TTextConfiguration` | 只承载子树上下文配置，如字体族和居中 padding 策略 |

**验收重点**：`TText` / `TText.rich` / `TTextSpan` 样式一致；`globalFontFamily` 变更能触发子树重建；`getRawText(context)` 只输出系统 `Text` 能表达的字段。

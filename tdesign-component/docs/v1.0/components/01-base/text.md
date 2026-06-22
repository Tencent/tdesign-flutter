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
| 演进 | 精度提升分两阶段 → [§10 垂直居中演进方案](#10-垂直居中演进方案) |

### 5.2 样式糖（扁平化 `TextStyle`）

将常用 `TextStyle` 字段提到构造器外层，映射 `Font` Token，例如 `font` · `textColor` · `isTextThrough`（删除线开关）· `lineThroughColor`。

- **v1.0 策略**：默认迁入 `TTextThemeData`；构造器 **暂保留** 糖参数作实例覆盖（软收敛）
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

0.2 问题：`TText.getTextStyle` 与 `TTextSpan._getTextStyle` **两套逻辑**，富文本与纯文本可能不一致。

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
| `t_text_vertical_align.dart` | **S2+** · 方案二 metrics 居中（`TextVerticalAlignResolver` · 可选） |

---

## 9. v1.0 相对 0.2 的架构演进

| 0.2 | v1.0 | 动机 |
| --- | --- | --- |
| 样式默认散落 + `TTheme.of` 直读 | `TTextThemeData` | 对齐全库 ThemeExtension 体系 |
| `kTextForceVerticalCenterEnable` · `kTextNeedGlobalFontFamily` | **删除** | 去掉模块全局 var，行为可预测、可测 |
| 双份 `getTextStyle` | `t_text_resolve.dart` 单路径 | Text / Span 样式一致 |
| `updateShouldNotify` 仅监听 padding | 同时监听 `globalFontFamily` | 换字体子树正确重建 |

**S2 不变**：双构造 · `getRawText` · `forceVerticalCenter` **legacy 算法**（`TTextPaddingConfig`）· 构造器糖（软收敛，不删公开参数）· `TTextConfiguration` 保留。

**S2+ 演进**：垂直居中精度 → [§10](#10-垂直居中演进方案)（方案一 S2 实施 · 方案二单独立项）。

---

## 10. 垂直居中演进方案

> **背景**：0.2 采用「定高 `Container` + 分端 padding 常数」（`TTextPaddingConfig`），在基准机型（Android Pixel 4 · iOS iPhone 8 Plus）上可用，但 **无法覆盖所有系统字体 / 缩放 / Flutter 引擎版本**。根因分两档：**实现不一致**（可修）与 **架构输入维度不足**（需演进）。  
> **裁决**：组件库 **不** fork Flutter 引擎、**不**自绘 `RenderParagraph`；精度路线仅 **方案一 + 方案二**。

### 10.1 总览

| 方案 | 阶段 | S2 | 架构 | 核心手段 |
| --- | --- | --- | --- | --- |
| **方案一** | 短期 · 实现层 | ✅ 实施 | 不改（仍 `TTextPaddingConfig`） | 修 bug + 混排层对齐 |
| **方案二** | 中期 · metrics 驱动 | ❌ 单独立项（S2+） | 演进（双轨策略） | `TextPainter` 动态算 offset + 缓存 |

```
方案一（S2）          方案二（S2+）
  修 height 语义  ──►  TextPainter 测 glyph 盒
  扩容缓存 key    ──►  结果缓存 + legacy fallback
  版本/feature    ──►  逐步废弃分端 magic number
  混排层试点      ──►  仍须 Button/Tag 等同高或 baseline
```

### 10.2 方案一 — 实现层（S2）

**目标**：在 **不改变 padding 查表架构** 的前提下，收窄「某些机型不准」的问题面；与 §9 Theme / resolve 改造 **可并行**。

#### 范围（TText）

| # | 项 | 说明 |
| --- | --- | --- |
| 1 | 统一 `height` 语义 | `Container.height`、`TTextPaddingConfig.getPadding`、`TextStyle.height` 使用 **同一套** `height`；消除 `showHeight = min(heightRate, height)` 与外层盒不一致 |
| 2 | 扩容 padding 缓存 key | 除 `(fontSize, height)` 外，至少包含 `fontFamily`、`fontWeight`、`textScale`（`MediaQuery.textScaler`）、`paddingConfig` 实例 |
| 3 | 版本分支 | 以 **Flutter 引擎版本** 或 **feature flag** 切换系数；**不再**用 Dart SDK 版本（`VersionUtil.isAfterThen`）代代理 |
| 4 | 字体加载失效 | `fontFamilyUrl` / 远程字体 loaded 后 invalidate 缓存 |
| 5 | Web TODO | 清理 `kIsFlutterWebAfter320` 硬编码，并入统一版本/feature 机制 |

#### 范围（混排层 · 与 TText 配合）

| # | 项 | 说明 |
| --- | --- | --- |
| 6 | 审计 `forceVerticalCenter: true` 的 Row 父级 | Button · Tag · Badge · TabBar · Link · NoticeBar · Avatar 等 |
| 7 | 混排对齐试点 | `CrossAxisAlignment.baseline` **或** Icon / Text **共用定高**（`SizedBox(height: fontSize × lineHeight)`）；以 Button Reference 先验证 |
| 8 | 文档 | 明确「`TText` 内部居中 ≠ Row 混排居中」 |

#### 优势

- 投入小（约 2～5 人日）、API 无 breaking、风险低
- 直接修复已知实现 bug（height 割裂、缓存过粗、textScale 未参与、版本探测错误）
- 与 v1.0 S2 交付（`TTextThemeData`、去全局 var、`t_text_resolve.dart`）不冲突

#### 劣势

- **治不好结构性不准**：固定系数无法覆盖全部厂商系统字体
- 分端 magic number 仍需保留与回归
- 混排层 baseline 对系统 `Icon` 常不理想，需定高策略补充

#### 验收

- [ ] 固定 embedded font 单测 / 黄金测试不回归
- [ ] 大字体模式（`textScale > 1`）padding 与 Text 同步缩放
- [ ] Button 单行中文 + Icon 视觉回归通过（Reference 机型矩阵）

### 10.3 方案二 — metrics 驱动（S2+）

**目标**：在 **不 fork 引擎** 前提下，用运行时字体 metrics 替代分端常数，解决「非基准机型永远不准」。

#### 做法

```
resolve TextStyle（与正式渲染一致，走 t_text_resolve.dart）
    ↓
TextPainter(text, textScaler, maxLines: 1).layout()
    ↓
读 preferredLineHeight / computeDistanceToActualBaseline / size
    ↓
topOffset = (targetHeight − visualTextHeight) / 2
    ↓
Container(height: targetHeight, padding: EdgeInsets.only(top: topOffset)) → Text
```

#### 双轨策略（与方案一共存）

| 策略 | 适用 | 说明 |
| --- | --- | --- |
| `legacy` | 默认 S2 行为 | 现有 `TTextPaddingConfig`；方案一修 bug 后的版本 |
| `metrics` | S2+ 默认（待 RFC） | `TextPainter` 动态算 offset；**单行纯文本**优先 |

**回退 `legacy` 条件**：`TText.rich` · `maxLines > 1` · 性能敏感且文案高度离散 · 业务显式 `paddingConfig` override。

#### 缓存

- key 建议：`styleHash · text · textScaler · maxLines · locale · platform`
- 远程字体 loaded / Theme 变更 / `globalFontFamily` 变更 → invalidate
- 需 benchmark（如 1000 个 `TText`）证明缓存后 build 开销可接受

#### API 演进（规划）

| 0.2 / S2 | S2+ |
| --- | --- |
| `TTextPaddingConfig` 仅常数 | 可扩展为 `VerticalAlignStrategy { legacy, metrics }` |
| `TTextConfiguration.paddingConfig` | 保留；`metrics` 时委托 `TextVerticalAlignResolver` |
| — | 新文件 `t_text_vertical_align.dart`（可选，见 §8） |

#### 优势

- 按 **当前设备 · 字体 · 文案 · 缩放** 计算，不绑基准模拟器
- Flutter 引擎升级后测量自适应，可 **逐步废弃** `paddingRate` / `paddingExtraRate`
- `data` 参数终于参与计算；与 `getTextStyle`（iOS PingFang 注入等）一致

#### 劣势

- 复杂度上升：测量 + 缓存 + 失效管线
- **非数学完美**：CJK 视觉中心 ≠ bounding box 中心；英文 / emoji 混排仍可能偏
- 富文本（多 `TTextSpan`）成本高，MVP **排除**
- 远程字体可能导致 1 帧跳变；`getRawText()` **仍丢失** padding 包装
- **不自动解决** Icon + Text 混排（仍须 §10.2 混排层策略）

#### MVP 范围（S2+ RFC）

- ✅ 单行 `data` · `maxLines == 1` · 非 `TText.rich`
- ✅ 缓存 + legacy fallback
- ❌ 富文本 metrics 居中（后续迭代）
- ❌ 删除 `TTextPaddingConfig`（先 deprecated，再观察）

### 10.4 方案对比

| 维度 | 方案一 | 方案二 |
| --- | --- | --- |
| 工作量 | 低（2～5 人日） | 中～高（5～15 人日） |
| 机型覆盖率 | 小幅～中幅提升 | 大幅提升 |
| API 破坏性 | 无 | 低（双轨 + Theme 默认策略） |
| 性能 | 几乎无影响 | 低～中（依赖缓存） |
| 混排 Icon+Text | 混排层单独处理 | Text 准了仍可能要混排策略 |
| 与 §9 S2 关系 | ✅ 并进 | ❌ 单独立项 |

### 10.5 排期裁决

| 阶段 | 内容 |
| --- | --- |
| **S2** | 方案一全部 P0/P1 + §9 架构交付；`TTextPaddingConfig` 标注为 **legacy** |
| **S2+** | 方案二 RFC → MVP（单行 metrics）→ 灰度默认 `metrics` |
| **不做** | fork 引擎 · 自绘 `RenderParagraph`（组件库形态不适用） |

> **说明**：§9「删除全局 var、迁入 `TTextThemeData`」减的是 **配置副作用**，**不解决** metrics 精度问题；精度依赖 §10 方案一（止血）+ 方案二（根治主流机型）。

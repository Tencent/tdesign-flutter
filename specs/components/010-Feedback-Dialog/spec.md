# Dialog 设计说明

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

Dialog 默认几何、按钮组合与跨端设计不一致，复用 Button 时容易扩散修改。

Dialog 的核心弹层能力已存在，但默认顶边距和关闭按钮位置与 Figma 移动端设计各差 8px，居中 Popup 的 240×240 默认尺寸还会把 311dp Dialog 压窄并裁切输入框。Example 仅展示 7 个业务化场景，且 Dialog ThemeData 生产源码覆盖基线仅 78.16%。

## 范围与非目标

### 目标

- 对齐 Figma Dialog 移动端展示稿的默认顶边距和关闭按钮位置。
- 公开展示官方 base、confirm、status、with-image、with-input、command 和自定义按钮全部 22 个场景。
- 对齐 Figma Demo 的页面文案、状态分组说明和各类 Dialog 打开态。
- Dialog 生产源码 LCOV 达到 95% 以上。

### 涉及

- `TDialog` 默认可见样式。
- Dialog ThemeData 与样式 Widget 测试。
- Dialog Example 页、Example 测试和自动生成代码片段。

- Dialog 使用 Flutter 标准模态路由承载居中自适应面板；不新增 Popup 公开 API，普通 Popup 的 240×240 默认契约保持不变。
- Dialog 保留现有构造与 `Future<T?>` 展示 API；仅增加可选的蒙层与关闭按钮返回值。

### 不涉及

- 不机械新增 Web/小程序的 `top`/`middle`、`cancelBtn`/`confirmBtn`、`buttonLayout` 或 plugin 形态 API。
- 不改变 Dialog 的 240ms 缩放动画、结果返回和遮罩默认语义。

## 最终方案与行为契约

- `TDialog.show<T>` 增加可选 `T? barrierResult`，仅在 `barrierDismissible: true` 的蒙层关闭成功时返回；`TDialog` 与 `TConfirmDialog` 增加可选 `Object? closeButtonResult`，仅用于内置关闭图标。两者默认 `null`，按钮继续使用 `TDialogAction.result`；不新增关闭回调、Controller 或组件级业务结果枚举。
- 显示仍由 Flutter 模态路由承载，蒙层使用标准 ModalBarrier/AnimatedModalBarrier；蒙层与内置关闭图标走所属 Navigator 的 `maybePop`，遵守 PopScope 拦截。操作按钮保留原有 Navigator.pop 行为；系统返回与业务 Navigator.pop 使用其原有结果，不误报为蒙层关闭。
- 命令调用 Demo 用私有结果枚举展示确认、取消、蒙层与关闭按钮的区分，并显示实际关闭来源。测试必须从公开入口打开后点击面板四周的真实蒙层，验证默认 false、显式 true、面板内点击、Future 仅完成一次与阻止返回的路径；覆盖率不能替代这些交互证据。
- Dialog Demo 全部 22 个入口均显式设置 `barrierDismissible: true`，包括反馈、确认、输入、图片及各种操作区，统一允许点击蒙层关闭；仅调整示例组合，组件全局默认 false 保持不变。
- 默认 content padding 为 `EdgeInsets.fromLTRB(24, 24, 24, 0)`。
- 默认圆角、内容留白、标题正文间距、关闭按钮偏移和操作区间距从对应 TDesign radius/spacer token 解析；实例参数与组件 Theme 仍保持更高优先级。
- Dialog 路由面板按内容自适应，默认宽度为 311dp，不再继承 Popup 的 240×240 固定尺寸。
- 关闭图标的可见边界距面板 top/end 均为 8px，点击热区独立覆盖在标题之上，不用缩小点击区域换取视觉对齐。
- 内容超过面板最大高度时，内容区显示 4dp 宽、2dp 圆角的滚动条；滚动条距面板 end 16dp，颜色使用 `grayColor4` 的 50% 透明度。标题、内容和操作区仍共用原有结构，不新增公开控制参数。
- 默认标题和正文的主字体与 fallback 从 Dialog Theme 和全局 TDesign Token 解析，不隐式继承外部 Material `TextTheme`。
- 带图片场景在 Example 层通过任意 `content` Widget 组合；垂直两按钮通过 `actionsWidget` 组合；不扩大基础 API。
- 带图片场景的图片保持 16:9 并横向铺满 311dp 面板；文案或图片与操作按钮之间均为 24dp，图片居中场景的标题区与图片之间为 24dp。输入场景复用 `TInput`，保留灰色输入壳、16dp 顶间距和清除能力，不使用原生透明 `TextField` 近似。
- “文字按钮”使用 32dp 顶间距、56dp 高的贴边文字操作区和 0.5dp 分隔线；基础按钮继续使用 24dp 操作区内边距。
- 三个及以上操作按 `TDialogAction.role` 将主要与危险操作优先从上到下展示，同类操作保持声明顺序；未声明强调角色时不改变调用方顺序。确认类无标题和纯标题场景的右侧确认操作均使用品牌填充按钮。
- 贴边文字 Footer 仅用于 1～2 个文字操作；三个及以上文字操作使用带默认操作区内边距的纵向布局。
- 普通基础操作由 Dialog 默认解析为 `fill + light`，主要与危险操作继续分别使用 `fill + primary`、`fill + danger`；显式 `text`、`outline`、`ghost` 的普通操作保留 `defaultTheme` 配色。实例 `colorPreset` 和 `style` 仍优先，不联动覆盖其他操作，不新增 API 或 Theme 选择器。颜色由 TButton 的现有 token/主题解析链提供。
- Demo 标准操作不重复声明角色已经决定的配色；输入类与“组件用法”的两组示例显式使用贴边文字操作区。垂直两按钮的完全自定义操作区继续由调用方组合 TButton，并使用相同的浅色次要操作样式。
- `actionsPadding` 和 `actionSpacing` 的显式实例值始终高于 token 默认值，即使数值与默认字面量相同也不得被覆盖。
- “组件状态”内逐项展示文字按钮、水平基础按钮、垂直基础按钮、多按钮和关闭按钮说明，不以一个笼统说明替代。
- 22 个官方场景均有独立可见触发入口；小程序 `openType` 通过 Flutter 既有 `TDialogAction` 自定义子项表达，不新增跨端专用 API。
- 公开页在“组件用法”后结束，不展示仅供内部验证的“单元测试”模块。

<a id="source-083"></a>
<a id="record-083-text-slot-restoration"></a>

### 083 · 标题与正文文字槽恢复

- 标题/正文在双槽、单槽和滚动分支均通过既有 `TTextStyleScope` 提供组件默认，同时保留原生 `Text` 居中与段落配置。全局 `TText` 不隐式继承外部 `DefaultTextStyle` 的规则保持不变。
- `TText` 实例显式样式对应字段仍优先；内容内部更近的 `TTextThemeData` 可以覆盖文字槽默认。自定义内容需要独立主题时，在内容内部显式配置；不改变全局隔离，也不增加配置或 API。
- 共享 Theme 自定义内容的功能与 Golden 测试复用同一场景，并显式设置内容自身的局部 TD 文字主题，覆盖 M2/M3。
- 本事项仅修复 Dialog 标题/正文及对应测试，不含 Button/NavBar、ActionSheet 居中问题、其他组件遗漏、CI 优化或工具链升级。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | 通过明确的内容与动作组合表达确认/取消，不把业务回调编进通用布局。 |
| 保留的边界与代价 | 只修改必要的组合消费者；基础 Button 契约及主题所有权由对应 Spec 维护。 |

### 设计演变中的关键理由

- 默认可见间距发生 8px 变化，需在 PR 更新日志中向用户明确说明。
- Example 图片复用仓库已打包资源，Golden 显式等待图片解码，避免把空白槽位误收为基线。
- 文字操作区只在全部操作都显式使用 `TButtonVariant.text` 时启用，混合或基础按钮不改变既有布局。
- 输入场景复用已经发布的 `TInput` 和局部 `TInputThemeData`，不把 Dialog 专属颜色、间距扩散为新的公开参数。
- 仅将语义匹配的 radius/spacer/font 值 token 化；面板宽度、Footer 高度和细分隔线不借用无关 token。

- Figma 当前页面采用“02 组件状态”，因此 Flutter Demo 保留该分组名称；组件内容顺序与官方小程序公开 Demo 对齐。
- 修复居中 Popup 240×240 固定尺寸压窄 311dp Dialog、裁切 `TInput` 的根因；带 Popup `centerSize` 主题时仍保持 Dialog 自适应。
- 三项及以上操作按 `TDialogAction.role` 稳定提升强调操作，全为普通操作时保持调用方声明顺序。
- 极小视口与放大的 `spacer32` token 组合不会产生负宽高约束。
- 文字按钮对齐 32dp Footer 顶间距、56dp 操作高度和 0.5dp 分隔线；三个及以上按钮按主要操作优先排列。
- 图片 Golden 显式等待仓库资产解码，防止把空白图片槽位误收为基线。

- 根因位于 Dialog 的 normal role 默认解析，并非标准 Demo 缺少颜色参数。普通基础操作改为 `fill + light`；主要/危险操作、普通文字/描边/幽灵操作，以及显式配色与 ButtonStyle 覆盖保持原有语义，不修改共享 TButton，也不新增 API。
- 标准 Demo 去除与 role 重复的主操作默认配色；完全自定义的垂直操作区仍由调用方组合 TButton，其次要按钮同步为浅色填充。纯标题确认的浅色主操作继续保留显式场景选择。
实际 Material 背景与文字色验证覆盖明暗主题、自定义品牌 token、实例与 Dialog Theme 样式覆盖。
- Flutter 3.32.0 组件测试与回归调度器自测合计 37/37；Dialog 生产源码覆盖率 `227/231 = 98.27%`，超过 95% 门禁；既有组件、Demo 与 Golden 调度清单仍覆盖本次修改的文件。示例生成器及 check 通过。
- Flutter 3.32.0 与 3.47.0 全量 `flutter analyze --fatal-infos --no-pub` 均为 0 issues。
- Flutter 3.32.0 Linux 首次精确比较：8 张既有打开态出现预期按钮差异（单个取消按钮 5016～5017px，约 1.65%；多按钮 21000px，约 6.90%），页面和文字按钮共 4 张不变；另外新增三个确认场景及垂直操作的明暗 8 张 Golden。检查旧图、实际图及差异图后更新，在同一容器不带 `--update-goldens` 复跑 20/20，最终精确比较无差异，未放宽容差。
- 已在 Android 16 真机安装并打开“确认类-带标题”，确认取消为浅色填充蓝字、确定为品牌色填充白字；此处仅为该场景真机验收，不代表完整跨端像素一致。
- 默认视觉属于 breaking change；保留旧外观的迁移方式见 spec.md。尚未提交、推送或更新远端 PR。

## 兼容性与迁移

- 普通操作未指定变体时，从描边默认配色调整为填充浅色配色；显式 `fill` 且未指定配色的普通操作同样采用浅色配色，属于默认视觉 breaking change。需要旧外观时显式设置 `variant: TButtonVariant.outline, colorScheme: TButtonColorPreset.defaultTheme`；文字、描边、幽灵变体与显式样式不变。
- 关闭返回值为可选新增能力，默认值及既有 `Future<T?>` 不变，本项不引入 breaking change；不新增为 Dialog 特制的 Popup 开关；`actionsPadding` / `actionSpacing` 构造入口与公开字段允许 `null` 表示未设置，渲染时解析当前主题 token。
- 相对 develop 基线 `ed6ac81d`，三项及以上操作由声明顺序调整为主要/危险角色优先、普通角色随后，两组内部各自保持声明顺序。混合角色的默认显示顺序可能变化，属于 breaking change；全为普通角色时顺序不变，不应描述为“原先无条件倒序”。需要完全自定义展示顺序时使用既有 `actionsWidget`；不要仅为排序修改角色而同时改变配色语义。提交与 PR 标题应使用 `breaking(dialog)`。

- 083 恢复既有文字槽样式契约，无 API 或配置新增。依赖此前错误正文默认的无样式或部分样式 TText 仍可能有可见变化；需要固定外观时显式指定字体与颜色。既有 PNG 不变不代表所有调用零兼容风险。

## 验收标准

- 顶边距和关闭按钮偏移有 Widget 测试保护。
- Example 测试证明 22 个入口公开可见，并覆盖图片、垂直按钮和自定义操作项交互。
- Example 测试逐项打开并关闭 22 个入口，覆盖输入、文字按钮、图片、主操作顺序和返回结果。
- Dialog 生产源码 LCOV `LH/LF >= 95%`。
- Flutter 3.32.0 与 latest 的组件测试、Example 测试和严格 analyze 全部通过。
- Flutter 3.32 Linux 亮暗主题 38 个 Golden 在本轮像素修复后无 `--update-goldens` 精确复跑 38/38 通过，未放宽容差。

083 还需验证标题/正文各布局分支、显式样式与更近局部主题优先级，以及共享 Theme 自定义内容；双版本功能和严格分析、逐组件95%覆盖率、Demo及生成产物检查后，在 Linux Flutter3.32.0 精确比较原基线，不以更新图片消除失败。历史执行结果和边界见 [083验收记录](./acceptance.md#source-083)。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。

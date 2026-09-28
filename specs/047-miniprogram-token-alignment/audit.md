# Token 差异审计（阶段性）

基准：`tdesign-miniprogram/develop@1a1c5ca135b0e9bf19abc43a59870c4908a28ad5`。完整机器清单见 [`token-audit.json`](./token-audit.json)，可用 `node tool/audit_miniprogram_tokens.mjs <小程序仓库目录>` 重算。该文件取当前 Flutter 工作区的主题配置，改动后须重新生成。

| 对照表 | 行数 | 主要列 | 可判断范围 |
| --- | ---: | --- | --- |
| [待审查项（精简）](./review-needed-table.md) | 15 类 | 已知值差、命名歧义、平台表达风险、判断人 | 先看此表，决定哪些需要设计判断 |
| [全局 Token 逐项对照](./global-token-table.md) | 216 | 名称、组、来源、明暗原式及最终值、Flutter 值、引用链、getter、结论 | 全局名称、值、引用链与读取入口；复杂平台表达仍待视觉核对 |
| [组件变量逐项映射](./component-token-table.md) | 804 | 变量、所属组件、源码位置、明暗默认表达、冲突值、Flutter 目录与 Theme 字段候选 | 小程序默认表达已逐项提取；Flutter 消费值尚未逐项证明 |
| [Flutter Theme 字段清单](./flutter-theme-field-table.md) | 437 | 组件、字段、源码、同名小程序变量候选 | Flutter 侧数量盘点；非同名不自动判为多余 |

前三张逐项表由同一审计脚本生成：`--markdown=global`、`--markdown=component`、`--markdown=flutter-theme`。表内“值一致”只表示当前脚本的结构化值一致；“平台表达待视觉核对”不应当作像素一致。

## 全局 Token

小程序 216 个全局 CSS 变量（不含 `_components.less` 的 9 个组件级例外）；当前 Flutter 默认主题配置 216 个键。同名项 **216 个**，小程序独有 **0 个**，Flutter 独有 **0 个**。已补小程序 `primaryColor1`～`primaryColor10`、边框色、`spacer`～`spacer6`、独立字号/行高/字体族与 `shadow1`～`shadow4`；原有 Flutter 独有全局键已退出默认配置。CSS `inset` 阴影在 Flutter 中需使用不同类型表达，详见下文。

逐项比较了浅色、暗色全部 216 个同名键：两种模式各有**1 个已批准的原始值差（仅 `radiusCircle`）**，未批准值差、未比较键、引用链差异和缺失同名 getter 均为 **0 个**。其中 185 个为标量值一致，30 个复合字体、字体族或阴影为结构字段一致但平台渲染待验，`radiusCircle` 是 Flutter 固定半径与 CSS 百分比的明确例外。此前仅比较最终默认值时遗漏 4 个颜色 Token 的引用链和 3 个 getter，现已修正并纳入脚本审计：浅色 `bgColorContainer → fontWhite1`，明暗 `textColorAnti → fontWhite1`，浅色 `textColorBrand/textColorLink → brandColor`，暗色后两者 `→ primaryColor8`。这些修改不改变出厂色值，但会使自定义上游 Token 时的联动与小程序一致；直接覆盖下游仍优先。

| 名称 | 模式 | 小程序最终值 | Flutter 最终值 | 分类 |
| --- | --- | --- | --- | --- |
| `radiusCircle` | 浅色、暗色 | `50%` | `9999dp`（固定半径） | 唯一批准的跨平台值差；不得称同值 |
| `bgColorSpecialComponent` | 暗色 | `transparent` | `transparent` | 已补齐并通过暗色 Theme 解析测试 |

颜色表达采用 8 位通道比较；CSS 的 `rgba(..., 90%)` 与最接近的 Flutter 8 位 alpha 视为量化等价，不列为实际色值差异。该比较尚不证明组件最终颜色一致，组件可能由 Material 或组件 Theme 覆盖。

Flutter 独有配置键现为 **0 项**。迁移前独有而现已从全局配置移除的键分为：

- 悬停/选择：`bgColorComponentHover`、`bgColorContainerHover`、`bgColorContainerSelect`、`bgColorSecondaryComponentHover`、`bgColorSecondaryContainerHover`、`brandHoverColor`、`errorHoverColor`、`successHoverColor`、`warningHoverColor`。
- 字体：`fontBodyExtraLarge`、`numberFontFamily`。
- 阴影：`shadowsBase`、`shadowsMiddle`、`shadowsTop`。

`shadowInsetTop`、`shadowInsetRight`、`shadowInsetBottom`、`shadowInsetLeft` 已保留同名全局入口，但小程序当前的值均为**零模糊、零扩散的 0.5px 内侧线**，Flutter 用 `BorderSide` 而非 `BoxShadow` 表达。亮色 `#dcdcdc`、暗色 `#5e5e5e`；实际应用时分别放到 `Border` 的 top/right/bottom/left。Flutter 边线与 CSS 内投影仍可能存在亚像素渲染差异；若小程序未来加入模糊或扩散，此转换不再等价，需重审。

`spacer4` 曾是最明显的**同名异义**：Flutter 旧值 4dp，小程序 `--td-spacer-4` 是 `64rpx`（375 宽约 32dp）。旧消费端已按其数值语义迁移，现 `spacer4` 表示 32dp；旧 4dp 使用点暂以组件局部常量保留，需继续按组件变量核对。Flutter 独有的 hover、数字字体、旧阴影键已退出全局配置；仍需要的视觉值由组件或 Flutter 资产局部持有。

字号、行高使用 `fontMetricMap` 独立配置，`fontSizeXs` 等别名保持小程序的引用链；复合 `Font` 未被显式定制时随对应字号/行高变化。小程序字体族的逗号后备列表转为 Flutter `fontFamily` + `fontFamilyFallback`；后备字体是否安装及字形差异仍是平台风险。`shadow1`～`shadow4` 已按 CSS 参数转为 `BoxShadow` 列表，但 CSS 与 Flutter 模糊半径渲染不保证逐像素一致，需要 Golden/设计图验证。当前自动审计已比较复合阴影的层数、偏移、模糊、扩散和颜色，内侧边线的方向、宽度和颜色，以及字体族的主字体与后备列表；这仍不等于平台像素等价。

## 组件应用 Token

扫描小程序组件样式中的 `var(--td-...)` 使用，排除全局变量后得到 804 个组件专属变量名，分布在 70 个组件目录。逐项表记录所有使用位置、回退表达式、浅色/暗色默认表达、冲突候选值和 Flutter 静态映射。784 项的默认表达已展开可确定的引用；14 项仍含 CSS `calc()`，尚未数值化；2 项有多套回退、3 项无回退、1 项仍含未解析引用。559 项直接回退全局 Token；其中 333 项的候选 Flutter 组件目录中出现相应全局 getter，但这只是**目录级线索**，不能证明该值驱动相同 UI 属性。597 项有同名组件目录，28 项与同目录 Flutter Theme 字段同名；放宽到跨目录寻找则为 35 项，因为两端组件目录并非一一对应。Flutter 组件 Theme 共盘点 437 个字段。这些数量均不能直接用作“已对齐”或“多余”的计数：Flutter Theme 字段不要求逐个对应 CSS 自定义变量。Tag 有 31 个组件变量，其中部分亦被 CheckTag 复用。

小程序源码本身还有 2 个同名变量的回退冲突：`sliderDefaultColor` 浅色可能为 `#e7e7e7` 或 `#eeeeee`，暗色可能为 `#383838` 或 `#2c2c2c`；`tabBarBorderColor` 暗色在两个消费者处分别回退 `#383838`、`#e8e8e8`。另有 3 个变量没有 `var()` 回退、1 个变量的暗色覆盖值仍包含未定义的 `var(--bg-color-page)`。这些都保留原样列入待审查，不擅自替小程序选择一个默认值。`calc()` 的 14 项也保留原表达，不能当成固定 dp。组件变量与 Flutter **最终生效值**仍需逐项沿 `全局 Token → 组件 Theme → API 状态 → Widget` 追踪；当前报告不能声称 804 项值都已与 Flutter 对齐。

## 待设计稿或组件运行裁定

| 待裁定项 | 当前处理 | 需要的证据 |
| --- | --- | --- |
| `spacer4` 旧 4dp 消费点 | 暂由组件局部值承担 | 逐组件检查小程序组件变量及实际尺寸，不能把数值未变当成语义已对齐 |
| `radiusCircle` | 小程序 `50%`，Flutter 保留固定 `9999dp` 语义；BackTop 半圆形、TabBar 胶囊等使用各自正确的圆角来源 | Linux Golden 与设计稿的最终形状、尺寸比对 |
| `rpx` 响应方式 | 用户已接受 375 宽下 2rpx = 1dp，52 个含 `rpx` 的全局数值 Token 按此口径判定通过 | 其他屏宽仍不宣称严格响应式等价，不再作为本轮数值阻塞项 |
| 字体与阴影 | Flutter 保留同名入口，使用平台类型表达 | 字体安装/字形、CSS 阴影与内阴影的渲染比对 |
| 组件覆盖链 | 仅建静态映射，必要字段才开放 Theme | 逐组件核对默认值、Material `ColorScheme`、组件 Theme 与全局 Token 的实际优先级 |

本轮已按小程序修正的无歧义全局值包括浅色页面底色/链接色、`fontTitleSmall` 字重、暗色灰阶/激活背景/反色文字及警告、错误、成功的激活色，并新增遮罩、滚动条和表格阴影颜色。公开语义色 getter/键已改为小程序式名称；这是 breaking change。Demo 的绿/红自定义主题 JSON 也已改用当前全局键，并支持 CSS 百分比透明度。设计稿比对、全部组件消费验证和 Linux Golden 门禁仍待完成。

## 验证记录

- 当前批次在 Flutter 3.32.0 与 3.47.0 下，`flutter analyze --fatal-infos` 均零告警；四组聚焦测试各 148 项通过，两个版本的 57 个完整组件回归套件及覆盖率门禁均通过。BackTop、Indexes、TabBar Demo 的 15 项非视觉测试也在 3.32.0 Linux 和 3.47.0 macOS 下通过。
- 视觉调度器自检曾因源码注释含共享字体未收录的 3 个汉字失败；已将对应注释改为不依赖新增字形的等价表述，Flutter 3.32.0 下自检通过。未修改字体或字形清单。
- Flutter 3.32.0 Linux 隔离容器的无更新 Golden：BackTop/导航矩阵/TabBar 组件文件共 1 项通过、15 项差异；BackTop/Indexes/TabBar Demo 文件共 11 项通过、20 项差异。已保存 master、test、isolatedDiff 并检查代表图。差异混有全局颜色/字体变更及图标轮廓等未完全归因的变化；未运行 `--update-goldens`，视觉门禁仍未通过。
- Figma View seat 的 MCP 调用配额已耗尽，无法重新获取高清 BackTop 节点；旧 Spec 的半圆宽度、图标、深色边框与小程序默认值冲突，保留为设计裁定项。
- 非文字复核发现 TabBar 胶囊误用 `shadow1`；小程序 `tab-bar.less` 的默认值是 `@shadow-3`，Flutter 已改用 `shadow3` 并补自定义 Token 的聚焦断言。Flutter 3.32.0、3.47.0 的 TabBar 组件测试各 35 项及改动文件定向分析均通过；3.32.0 Linux 胶囊浅色无更新 Golden 仍有 7475/48000 像素差异（比较器 15.57%），主要来自较大的阴影，尚不能证明与设计图逐像素一致。全包 `flutter analyze --fatal-infos` 本次被 41 条范围外 `RegExp` 弃用提示挡住，不把定向分析冒称全包通过。
- 2026-09-27 恢复 Flutter `radiusCircle = 9999dp` 的固定半径语义后重新审计：216 个全局键两模式各只有这 1 个已批准原始值差；未批准值差、缺失 Token/getter、未比较键和引用链差异均为 0。`TText` 的非 Apple 默认字体适配消除了 Linux Golden 的数字方块。两个 Flutter 版本的聚焦测试各 82 项通过、改动文件定向 analyze 均零诊断。
- Linux 3.32.0 隔离环境已无更新复跑受影响的 47 张组件与 Demo Golden：12 通过、35 差异；相较修复前 10 通过、37 差异，全部旧基线差异像素由 354655 降至 333868。仍有正确 Token 色值、TabBar 设计对齐布局与 `shadow3` 阴影引起的旧基线差异；它们不等于设计稿差异。未更新 Golden，不能声称像素门禁通过。`dart run tool/generate_example_code.dart --check`、`git diff --check` 在前批次通过。

## 保留的小程序命名歧义

Tag 的组件变量 `--td-tag-danger-color` 在 `packages/components/tag/tag.less:12` 以 Less `@error-color` 为回退；后者在 `packages/components/common/style/_variables.less:197` 读取全局 `--td-error-color`，再回退到第 6 级错误色。亮色默认 `#d54941`，暗色默认 `#c64751`。因此 Tag 的 `danger` 是组件配色名，全局的 `error` 是默认色来源，**不存在**全局 `--td-danger-color` 或 Less `@danger-color`。按用户决定，Flutter 保留 `TTagColorScheme.danger → errorColor` 的默认映射，不新增全局 `dangerColor` 别名。

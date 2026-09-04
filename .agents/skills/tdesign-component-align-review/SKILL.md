---
name: tdesign-component-align-review
description: Review TDesign Flutter 组件的公开 Demo、API 收敛、Flutter 设计模式、主题、测试和 Golden 证据。以小程序公开 Demo 作为可见效果参考，但不机械映射其 props/events；适用于组件对齐和 PR Review。
---

# TDesign Flutter 组件 Review

依据当前 PR 的实际源码、运行结果和测试进行 Review。仅请求 Review 时只审查；已获授权的修复或 PR 更新按约定范围继续执行，不重复索取许可，也不从 Review 请求推导修改权限。

本 skill 只补充组件对齐专项规则。分支、Spec、更新日志、双版本兼容、lint 和 PR 模板仍以仓库 `CONTRIBUTING.md`、`specs/README.md` 与 `tdesign-flutter-general` 为准。仓库 `.agents/skills/tdesign-component-align-review/SKILL.md` 是唯一维护源，外部安装副本只做镜像，不得独立演化。

使用外部镜像时，文中的仓库文件和相邻 skill 引用均从目标仓库对应路径解析，不从本机安装目录寻找仓库规范。

## 1. 冻结证据

记录实际 checkout、Flutter PR 的 base、head、commit 和改动文件。涉及跨端 Demo 时，同时记录小程序版本或 commit、公开 Demo 入口及直接使用的模板、样式和脚本；不要把本地过期分支或单个截图当成当前基准。

区分实现事实与对齐目标：当前 Flutter 源码、运行和测试用于判断实际行为；目标以用户指定的设计稿、版本或契约为准，未指定时参考小程序公开 Demo。两者不一致时记录偏差，不以现状替代目标。跨端参考的取证顺序：

1. 已确定目标的完整 Demo、设计节点及其版本；
2. Demo 直接依赖的上游源码；
3. API 文档仅用于解释语义，不能单独证明 Flutter 需要新增 API。

单张截图、首屏、测试覆盖率或 API 列表不能证明 Demo 完整性。无法运行或测量的内容标为未验证，不得写“完全一致”。

## 2. 公开 Demo 契约

按第 1 节确定的目标逐实例核对；默认采用小程序公开页面顺序：

- 页面分组、标题、说明、元素数量和顺序；
- 初始值、禁用/加载/错误状态和操作结果；
- 页面背景、间距、尺寸、对齐、颜色及深浅色表现；
- 滚动、溢出、SafeArea、键盘和手势等实际适用边界。

以官方公开页面中的 Demo 块为契约边界：`ExampleModule` / `ExampleItem` 表达公开分组、标题、描述和示例顺序，不按每个内部 Widget 机械拆分。Flutter 多余示例应删除；仍有测试价值的场景移入聚焦 Widget 测试。同步 Demo 源码、生成示例、页面测试和必要 Golden。

### 组件选择与布局职责

Demo 展示组件能力，不替组件补实现或修复默认样式：

- 有对应 TD 组件时优先使用，如 `TButton`、`TText`、`TPopupHeader`、`TPopup`；不以 Material 控件的默认视觉替代。Demo 自行编写的布局使用 `Row`、`Column`、`Padding`、`SizedBox`、`Expanded` 等基础原语，只负责外部排列和合理约束。
- 组件内部背景、字体、颜色、选中态、圆角、间距和对齐由组件与主题负责；不得在 Demo 中添加 `Material` 包装、装饰、位移或样式覆盖来掩盖缺陷。明确展示自定义样式的示例可用已有 API 或 Theme，但不能替代默认样式验收。
- Demo 管理示例状态和外部组合，例如 `TPopup + TPicker` 的草稿、确认、取消和可用高度；状态/API 的归属遵循第 3 节。此规则不禁止导入 `material.dart` 或使用 Flutter 基础机制；显式主题覆盖遵循第 4 节。

页面壳及可复制示例按以下规则处理：

- 页面采用“页面底色 + 组件容器背景”的紧凑布局时，先检查并复用 `ExamplePage.compactDemo`；不要在每个 builder 中重复绘制背景，也不要仅为单个组件扩展 `ExampleItem`。
- 连续 Cell 使用 `TCellGroup` 管理背景、分隔线和末项边界，不在 Demo 中重复编写 `Column + Divider`。状态子标题仍按官方页面层级放置，不能为了代码短而改变背景层级。
- Demo builder 只展示用户可复制的组件组合，Example 页面基础设施不得进入生成代码片段；生成片段的校验见第 5 节。
- 只有现有 Example 页面模式无法表达，并且职责归属与复用证据表明能力应由公共页面基础设施承担时，才考虑扩展通用 Example API；不得仅按受影响组件数量作判断，也不得用一次 Demo 修复制造新的公共抽象。

先判断缺口层级，再决定修改方式：

| 层级 | 判断 | 优先处理 |
|---|---|---|
| Demo 缺口 | 组件已有能力，但父布局约束或组合错误 | 修正 Example；如弹层未给标题预留高度 |
| 内部缺口 | 公开契约足够，但组件在合理约束下仍异常 | 修复组件并补组件测试；如 TD 标题继承错误装饰，不在 Demo 包装补救 |
| API 缺口 | 公开 Demo 或已验证的 Flutter 真实用例无法由组合、Theme 或现有 API 合理表达 | 提出最小公开 API；仅在超出既有授权或需要用户决策时确认 |
| 无缺口 | Flutter 已有等价表达 | 不修改 API |
| 候选能力 | 仅见于上游 API 表，公开 Demo 未使用且没有已验证的 Flutter 真实用例 | 只记录，不实现 |

禁止为了 API 一一对应、缩短 Demo 代码或补齐上游 props/events 而扩大 Flutter 公共面。

## 3. API 收敛与 Flutter 模式

不能只检查本次新增字段。结合组件当前全部公开构造参数、字段、回调、枚举、Controller 和 ThemeData，回答“API 是否已收敛”，并列出证据：

| API/组合 | 状态源和实际语义 | 重叠或冲突 | Flutter 惯用表达 | 结论 |
|---|---|---|---|---|
| 示例 | 默认值、空值和生效条件 | 独立/重复/别名/冲突 | 参数、nullable callback、Widget、builder、Theme 或 Controller | 保留/合并/改名/删除/待确认 |

必须检查：

- 同一状态、启停条件、完成事件或错误结果只有一个权威入口；
- 名称、dartdoc、默认值、空值语义、Theme 默认值和运行逻辑一致；
- 不存在不同名称表达同一能力，或参数可由另一个参数直接推导；
- callback、统一状态回调和 Controller 不重复通知或形成双完成源；
- 业务编排、Demo 状态、子组件 ThemeData、第三方类型和内部适配对象不泄漏到公共 API；
- 声明式状态优先使用不可变参数和 nullable callback；内容扩展使用 Widget/builder；可复用的样式默认值优先来自语义 token 或组件 Theme，实例 API 保留有真实逐实例配置需求的参数、必要语义选择器或完整样式逃逸入口；Controller 只处理无法由声明式重建表达的跨树命令或生命周期协调；
- 名称优先采用 Flutter、Material/Cupertino 和仓库同类组件的惯用语义，不机械沿用小程序名称。

### 状态所有权优先于 token 化

先确定公开 API 的单一状态源，再决定内置默认样式从哪里取得；不得反过来为了 token 化扩大公共面：

- 样式 token 化不得制造第二公开状态源；组件已有必要实例参数时，默认值可以在内部引用语义 token，但 ThemeExtension 不再暴露同义字段。
- 连续尺寸、进度等确有逐实例配置需求的值可以保留为实例参数；“属于可见样式”本身不是迁入 Theme 或删除实例参数的充分理由。
- 只有存在已验证的子树批量默认需求时，才评估由 Theme 提供默认值。实例参数必须允许未指定，不得同时保留非空实例默认值和同义 Theme 默认值形成两个默认源；视觉字段完整解析链见第 4 节，语义选择器见下节。

### `variant`、`colorScheme`、`status` 与 Theme 的判定模型

`TButton` 只提供职责拆分参考，不是所有组件枚举取值的命名模板。Web / 小程序的 `theme`、`type` 等名称不能机械映射；必须根据调用者意图和运行效果判断维度，再记录枚举全部取值、默认值、空值语义、有效组合和公开字段类型。

| 维度 | 判定标准 | 示例 | 所有权 |
|---|---|---|---|
| `variant` | 改变结构、布局、边框或填充/描边等绘制处理；不是任意色相切换 | fill / outline / text / ghost、solid / tinted、linear / circular | 实例 API；满足严格条件时 Theme 可提供 `defaultVariant` |
| `colorScheme` | 业务含义和绘制处理不变，只选择一组协调的预设颜色 | defaultTheme / primary / danger，以及组件确有需要的其他调色预设 | 仅实例 API；Theme 不保存该选择器 |
| `status` / `state` | 表达组件、内容或数据当前所处的业务或生命周期状态 | normal / info / success / warning / error、ready / uploading | 实例、数据模型或 Controller 中唯一合适的一处；Theme 不拥有状态 |
| `style` / 具体样式字段 | 完整或局部覆盖最终呈现 | `ButtonStyle`、颜色、文字样式、间距 | 实例完整 style 或组件 Theme；不得再造同义选择器 |

按以下顺序判定，不能只看枚举成员名称：

1. 值是否描述“当前发生了什么”，或会决定默认图标、提示语、无障碍语义、交互和生命周期？是则属于 `status` / `state`，即使当前实现暂时只改变颜色。
2. 值是否改变填充、描边、文本、层级、布局或绘制处理？是则属于 `variant`。例如同一组件的实色、浅色填充和描边可以是不同 variant。
3. 前两项都不成立，只在相同状态和相同绘制处理中替换协调调色板，才属于 `colorScheme`。

因此 `info / success / warning / error` 既不能一律判为状态，也不能一律判为配色：输入框校验、上传进度或公告状态属于 `status`；Tag 或 Popover 若只是由调用者选择视觉调色板、没有状态行为和默认内容语义，可以属于 `colorScheme`。`light` 也不是固定维度：表示浅色填充处理时属于 `variant`，表示一套独立调色板时才属于 `colorScheme`。dartdoc 必须写清实际语义，不能让调用者依赖猜测。

Theme 与默认值遵循以下所有权规则：

- 组件不得公开 `colorTheme`，也不得在组件 ThemeExtension 中保存组件枚举型 `colorScheme`、`defaultColorScheme`、`status` 或 `defaultStatus`。Flutter 官方 `ThemeData.colorScheme` 与类型 `ColorScheme` 是 Material 实际调色板，不受此限制；内部私有/常量形式的内置默认配色也不是 Theme 选择器。
- ThemeExtension 可以保存具体 `Color`、`TextStyle`、`ButtonStyle`、布局值和按状态派生的样式。`resolve(context, status: instanceStatus)` 接收实例状态计算样式不表示 Theme 拥有状态；Theme 不得自行选择或覆盖当前状态。
- Theme 仅在 variant 是稳定的呈现偏好、存在真实的子树批量默认需求、且实例 `variant` 为 nullable 时，才可提供 `defaultVariant`。解析顺序必须是 `instance.variant ?? theme.defaultVariant ?? builtInDefault`。实例已经使用非空内置默认值时，不再增加 Theme `defaultVariant` 形成第二默认源。
- `colorScheme` 与 `status` 不提供 Theme 回退，使用实例值或组件内置默认值。枚举成员词汇按组件语义决定；Button 的取值不是强制全集。已发布的 `defaultTheme` 等名称保持兼容，重命名必须按 breaking change 处理。
- 只有 `variant`、`colorScheme`、`status` 彼此独立且至少存在两组有意义的交叉组合时，才同时公开。若组合被禁止、没有真实用例或一个维度可由另一个推导，则合并或只保留权威入口。
- 新增或正在修改的契约必须遵守本模型。未触及的已发布历史 API 若不符合规则，记录为技术债，不自动阻塞无关 PR，也不能作为复制先例；当同一组件契约进入修改范围时，必须评估迁移。若迁移会造成未授权的范围扩大，则明确记录独立 breaking 方案并停止扩散，而不是悄悄删除或继续新增重复入口。

以下情况默认视为冗余：

- `enableX` 与 `onX != null` 同时控制能力；
- `disabled` 与 nullable callback 重复表达禁用；
- 单项事件回调与统一状态回调重复报告同一事件；
- 实例参数与 ThemeExtension 在没有真实子树默认需求时重复保存同一个状态、选择器或样式标量；完整的 Flutter 样式对象逃逸入口不在此列，但必须有明确覆盖优先级；
- Controller 同时与 Future/callback 决定完成状态；
- 高层组件已表达能力，同时又公开第三方底层配置。

未发布的冗余 API 直接收敛；已发布 API 必须说明 breaking 风险和迁移方式。没有逐项证据时，不得断言“API 已完全收敛”或“符合 Flutter 设计模式”。

## 4. Theme 与视觉

具体视觉字段的解析优先级为：实例显式参数或完整 style > 当前子树的组件 ThemeExtension 显式字段 > 调用者显式提供且语义适用的 Flutter 标准主题字段（如 `TextTheme`、`IconTheme`、Material 组件 Theme 或 `ColorScheme`）> TDesign 语义 token / 已文档化的内置默认值。Flutter 自动生成的 Material 默认视觉不应覆盖 TD 默认样式；第 3 节的语义选择器不套用此视觉字段解析链。

- token 是最终兜底，不应预填到高优先级 ThemeExtension 并遮蔽 Flutter 主题继承；
- ThemeData 只承载视觉、布局和稳定的呈现默认值，不承载内容、业务状态、回调、Controller 或业务流程开关；动画时长等运动视觉参数可以进入 Theme，但是否启用业务能力仍由组件状态或回调表达；
- 组合组件应让 `TText`、`TLoading` 等子组件继承当前 Theme 子树，不接收子组件 ThemeData；
- 比较视觉时固定视口、DPR、字体缩放、主题、语言和状态；页面壳的合理平台差异不机械对齐。

### 默认样式值与 token

默认值优先复用 TDesign 语义 token；无匹配 token、无子树默认需求且共享 token 缺少复用证据时，可保留单一、已文档化且有契约证据的内置默认值。不得借用无关 token 或只为消除字面量新增 Theme 字段。公开字段归属仍按第 3 节判断。

- Review 新增或修改的颜色、字体、行高、字重、圆角、阴影、间距、内边距、宽高、指示器尺寸、边框和描边；默认实现不得散落多个直接决定同一可见样式的常量。单一、已文档化且有契约证据的内置默认值不等于散落硬编码。
- 尺寸能由同一语义下的字体、行高和间距自然计算时可以组合；数值相等不代表语义相同。
- `0`、数量、最大行数、枚举值和无量纲绘制比例不属于样式 token。固定路径坐标或数值一旦决定可见尺寸、间距、圆角或描边，仍按样式值审查；几何比例应从画布、控件尺寸或 token 派生。
- 修改共享视觉原语时，列出全部消费组件并验证默认视觉和自定义主题路径，不能只证明当前 Demo 正确。
- token 化修复至少补两类证据：自定义相关 token 后实际布局或绘制值随之变化；默认 token 下 Flutter 3.32.0 Linux Golden 无意外差异。仅把数字改写为 token 名称不算完成。

## 5. 测试、覆盖率与 Golden 门禁

### Widget 与交互测试

- Demo Widget 测试逐项断言公开分组、文案、实例数量、顺序、关键参数、初始状态和操作结果；不能只断言某种组件类型曾出现。
- 可滚动页面必须遍历完整 scroll extent，覆盖首屏外实例；动态、受控、禁用、加载、错误和主题切换场景按真实调用流验证。
- 聚焦组件测试覆盖根因、普通路径、边界、回调次数、Controller 所有权和生命周期。Demo 测试验证公开组装，不能替代组件测试。
- 修改 `@ExampleCode` 方法后运行仓库生成器的 check 模式；生成片段变化必须来自 Demo 源码，不手工维护两份逻辑。

### CI 回归登记

新增或修改组件测试、Demo 功能测试与 Golden 后，按 [`tdesign-flutter-general` 第八节](../tdesign-flutter-general/SKILL.md) 核对登记、自测与真实 CI 入口。区分已登记、本地已通过和远端 CI 已通过，不以 job 名称代替执行证据。

当前 PR 新增或修改的组件测试、覆盖率目标或 Demo Golden 未登记到仓库已有 CI 调度入口时，属于测试门禁缺失，Review 判定为阻塞问题；不得降级为仓库既有基础设施建议。

### 覆盖率

- 覆盖率按改动所有权过滤并分别报告：组件生产源码、Demo 页面源码和其他依赖不能混为一个总数。
- 修改生产组件源码时，执行通用 skill 第八节登记的覆盖率门禁，以当前脚本阈值为准。报告过滤后的 LCOV 分子、分母和比例，Demo 页面覆盖率不能替代组件生产源码达标。
- 覆盖率只证明代码行执行，不能替代交互、视觉、真机或跨版本证据。测试失败时不得仅凭已生成的 LCOV 宣称门禁通过。

### Golden

- 功能断言与像素比较必须解耦；混合文件应拆分或用标签分流。执行平台见下方“执行环境”，不能因 Golden 的平台限制缩减功能测试矩阵。
- Golden 固定 viewport、device pixel ratio、字体缩放、语言和主题，同时覆盖 light / dark；加载确定性的中文字体和实际使用的图标字体，基线中不得保留缺字方框。
- Golden 边界包含真实 Demo 页面背景、标题、描述、组间距和组件容器。长页面按稳定 `ExampleItem` / 分组边界分别截图，或生成完整滚动页面证据；仅覆盖首屏不能宣称整页齐备。
- 对弹窗、操作面板、下拉层、消息等“操作后才可见”的状态，必须先通过真实点击、选择、翻页或关闭操作触发目标状态，再断言目标内容可见并保存 Golden；初始隐藏状态或仅渲染触发按钮不能替代操作后快照。
- 首次生成或有意更新前，先与当前官方 Demo 和真机渲染核对。检查实际图、基线图和差异图，确认变化来自预期源码；不得直接运行更新命令消除失败。
- 更新基线后，立即在不带更新参数的情况下重跑同一测试，证明基线可复现。报告比较器容差、实际 diff 比例及仍未覆盖的平台风险。
- 以仓库实际 Golden comparator 和 CI 配置为准；未配置容差时默认要求精确一致。配置了容差也必须报告来源和实际差异比例；结构、数量、顺序、关键尺寸、缺字、裁切和未覆盖区域不得通过面积容差豁免。

### 执行环境

- Flutter 3.32.0 与 latest 均运行严格 analyze 和非视觉功能/交互测试；自动 Golden 与其他像素比较测试仅在 Flutter 3.32.0 Linux 执行和更新基线。其他平台允许真机运行、截图与人工核对，但不能写回 Golden 基线。区分本地与 CI 证据，清理本次无关产物，不处理用户已有文件。

## 6. Review 结论与交付

Review 输出按严重程度列出问题，每项包含文件行号、可复现行为、根因、影响、最小修复和应补测试。明确区分：

- **阻塞问题**：行为、API、兼容性、视觉契约或测试证据不满足；Review 不通过；
- **非阻塞问题**：不影响当前契约的风险或后续建议；单独列出，不伪装成缺陷；
- **未验证项**：缺少运行、截图、版本或环境证据。

先判断缺失证据是否属于本次验收范围：完成当前行为、API、视觉或兼容性契约所必需的证据缺失时，必须列为阻塞问题；只有明确超出本次范围，或不影响当前契约且因环境限制无法补充的证据，才列为非阻塞的未验证项。不得用“未验证”绕过本 skill 的完成条件。

当 Review **没有阻塞问题**时，结论为通过；除非用户明确要求，不修改 PR。用户明确要求创建或更新 PR 时，PR 模板、更新日志和 breaking 格式遵循仓库 `CONTRIBUTING.md`、PR 模板及 `tdesign-flutter-general`，本 skill 只补充以下对齐 Review 专项要求：

1. 标题遵循 Conventional Commits，概括当前源码实际产生的用户可见或工程变更；
2. 描述根据当前 diff、最终行为、API 影响和测试证据填写；
3. 标题和描述不得把“对齐小程序”“参考小程序”或跨端比较过程当作变更内容；小程序只属于 Review 证据，不属于 PR 实现说明；
4. 不写源码未实现的能力，不沿用过时标题或计划；平台专属的 Issue 关联规则按仓库规范执行；
5. 更新后同时检查正文原始 Markdown 和渲染结果，再核对 title、body、base/head、commit 和文件范围。

当 Review 有阻塞问题时，不得用改标题、正文、Golden 容差或更新基线规避问题；仅审查任务报告问题，已授权修复的任务继续修复。修复后基于最新代码及验证证据重新判断，不能沿用旧结论。

按本次任务范围判断完成：公开 Demo 契约有证据；缺口分层正确；API 无重复状态源且符合 Flutter 模式；Theme 继承合理；相关测试、Golden、双版本 analyze 和必要覆盖率通过。涉及 PR 时还需核对标题与描述是否准确；存在未获授权的修改需求应报告，不能据此自行修改远端。

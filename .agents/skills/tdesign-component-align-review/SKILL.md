---
name: tdesign-component-align-review
description: Review TDesign Flutter 组件的公开 Demo、API 收敛、Flutter 设计模式、主题、测试和 Golden 证据。以小程序公开 Demo 作为可见效果参考，但不机械映射其 props/events；适用于组件对齐和 PR Review。
---

# TDesign Flutter 组件对齐 Review

依据当前 PR 的实际源码、运行结果和测试进行 Review。默认只审查；用户明确要求修复后才修改代码，明确要求更新 PR 后才修改远端标题、正文或状态。

本 skill 补充组件对齐专项规则。分支、Spec、更新日志、双版本兼容、lint 和 PR 模板仍以仓库 `CONTRIBUTING.md`、`specs/README.md` 与 `tdesign-flutter-general` 为准。

## 1. 冻结证据与公开 Demo 契约

记录实际 checkout、PR base/head/commit 和改动文件。跨端对齐时同时记录小程序版本或 commit、公开 Demo 入口，以及直接使用的模板、样式和脚本。

证据优先级：

1. 当前 Flutter 源码、真实运行和测试；
2. 小程序完整公开 Demo 的结构、视觉和交互；
3. Demo 直接依赖的上游源码；
4. API 文档只解释语义，不能单独证明 Flutter 需要新增 API。

按小程序公开页面顺序逐实例核对分组、标题、说明、元素数量和顺序、初始状态、操作结果、页面背景、间距、尺寸、深浅色，以及滚动、溢出、SafeArea、键盘和手势等适用边界。单张截图、首屏或 API 列表不能证明 Demo 完整性；无法运行的内容必须标为未验证，不得写“完全一致”。

以官方公开页面中的 Demo 块作为契约边界，不按每个内部 Widget 机械拆分。Flutter 多余示例应删除；仍有测试价值的场景移入聚焦组件测试。同步 Demo 源码、生成示例、页面测试和必要 Golden。

先比较页面壳和已有组合能力，再新增公共 API：

- 紧凑页面优先复用 `ExamplePage.compactDemo`；
- 连续 Cell 优先使用 `TCellGroup` 管理背景、分隔线和末项边界；
- Demo builder 只展示用户可复制的组件组合，页面基础设施不得进入生成代码片段；
- 只有现有页面模式无法表达，且职责和复用证据充分时，才扩展通用 Example API。

| 缺口 | 判断 | 处理 |
|---|---|---|
| Demo 缺口 | 组件已有能力 | 调整 Example 组合 |
| 内部缺口 | 公开契约足够、实现无法表达 | 修改内部实现 |
| API 缺口 | 公开 Demo 或已验证的 Flutter 用例无法由组合、Theme 或现有 API 合理表达 | 提出最小 API，并在扩大公共面前确认 |
| 无缺口 | Flutter 已有等价表达 | 不修改 API |
| 候选能力 | 仅见于上游 API 表且无真实用例 | 记录，不实现 |

禁止为了 API 一一对应、缩短 Demo 代码或补齐上游 props/events 而扩大 Flutter 公共面。

## 2. API 收敛与 Flutter 模式

Review 必须覆盖组件现有的全部公开构造参数、字段、回调、枚举、Controller 和 ThemeData，不能只检查本次新增字段。逐项记录状态源、默认值、空值语义、生效条件、重叠关系、Flutter 惯用表达，以及保留/合并/改名/删除结论。

必须确认：

- 同一状态、启停条件、完成事件或错误结果只有一个权威入口；
- 名称、dartdoc、默认值、Theme 默认值与运行逻辑一致；
- callback、统一状态回调和 Controller 不重复通知或形成双完成源；
- 业务编排、Demo 状态、第三方类型和内部适配对象不泄漏到公共 API；
- 声明式状态优先使用不可变参数和 nullable callback，内容扩展使用 Widget/builder；
- 原始颜色、字号、圆角、间距进入 token/Theme，实例 API 只保留必要的语义选择器或完整样式逃逸入口；
- 名称优先采用 Flutter、Material/Cupertino 与仓库同类组件的惯用语义，不机械沿用小程序名称。

### `variant`、`colorScheme`、`status` 与 Theme 的边界

以 `TButton` 的职责拆分为基准：

| 维度 | 含义 | 典型值 | 所有权 |
|---|---|---|---|
| `variant` | 结构或绘制形态变化，不只是换颜色 | fill / outline / text / ghost | 实例 API；确有子树默认需求时 Theme 可提供 `defaultVariant` |
| `colorScheme` | 状态和结构不变时选择协调的预设配色 | default / primary / danger / light | 仅实例 API；Theme 不保存选择器 |
| `status` | 业务或生命周期状态 | info / success / warning / error、ready / uploading | 实例、数据模型或 Controller 中唯一合适的一处；Theme 不拥有状态 |
| style / 具体样式字段 | 覆盖最终呈现 | `ButtonStyle`、颜色、文字样式、间距 | 实例完整 style 或组件 Theme |

强制规则：

- 仅切换颜色或业务状态的枚举不得命名为 `variant`；
- 组件实例的 `colorScheme` 是预设选择器；Flutter `ThemeData.colorScheme` / `ColorScheme` 是实际 Material 调色板，二者不是同一层级；
- 组件不得公开或在 ThemeExtension 中声明 `colorTheme`；
- 组件 ThemeExtension 不得保存枚举型 `colorScheme` 或 `defaultColorScheme`，只能提供实际 `Color`、`TextStyle`、`ButtonStyle`、状态样式及其他呈现配置；
- `TTagThemeData.colorScheme` 与 `TPopoverThemeData.colorScheme` 应迁移到 `TTag`、`TSelectTag`、`TPopover` 等实例 API，ThemeData 删除重复选择器；
- NoticeBar 的 info / success / warning / error 表示公告状态时，由实例 `status` 唯一持有，Theme 不再重复 `variant`、`status` 或 `defaultStatus`；
- `colorScheme` 与 `status` 不提供 Theme 回退，使用实例值或组件内置默认值；
- 只有 `variant`、`colorScheme`、`status` 彼此独立且至少存在两组有意义的交叉组合时，才同时公开；
- 已发布 API 的删除或改名必须记录 breaking 风险与迁移方案，不能在普通修复中无说明地处理。

默认视为冗余的组合包括：`enableX` 与 `onX != null`；`disabled` 与 nullable callback；单项事件与统一状态回调重复报告；实例参数与 ThemeExtension 重复保存状态或选择器；Controller 与 Future/callback 同时决定完成状态；高层组件已表达能力又公开第三方底层配置。

## 3. Theme 与视觉

解析优先级为：实例显式参数或完整 style > 当前子树组件 ThemeExtension 显式字段 > Material 组件 Theme、`ColorScheme`、`TextTheme`、`IconTheme` > TDesign 语义 token 兜底。

- token 不应预填到高优先级 ThemeExtension 并遮蔽 Flutter 主题继承；
- ThemeData 只承载视觉、布局和稳定呈现默认值，不承载内容、业务状态、回调、Controller 或业务流程开关；
- 默认实现不得散落直接决定可见样式的常量；优先复用语义匹配的 token，不因数值相同挪用无关 token；
- 修改共享视觉原语时列出全部消费组件，并验证默认视觉与自定义主题路径；
- 比较视觉时固定视口、DPR、字体缩放、语言、主题和状态，页面壳的合理平台差异不机械对齐。

## 4. 测试、覆盖率与 Golden

- Demo Widget 测试逐项断言公开分组、文案、实例数量、顺序、关键参数、初始状态和操作结果；滚动页面必须覆盖首屏外实例；
- 聚焦组件测试覆盖根因、普通路径、边界、回调次数、Controller 所有权和生命周期；
- 修改 `@ExampleCode` 后运行生成器 check；生成片段只从 Demo 源码生成；
- 新增或修改的组件测试、覆盖率目标、Demo 功能测试和 Golden 必须登记到仓库当前 CI 调度器；文件存在或本地单独通过不能证明 CI 已覆盖；
- 生产组件源码覆盖率按仓库当前门禁过滤报告；当前要求手写生产 Dart 行覆盖率 `LH/LF >= 95%`，Demo 覆盖率不能替代组件覆盖率；
- Flutter 3.32.0 与 latest 都运行严格 analyze 和非视觉测试；Golden 仅在 Flutter 3.32.0 Linux 生成与执行；
- Golden 固定 viewport、DPR、字体、字体缩放、语言和主题，覆盖 light/dark；更新前检查实际图、基线图、差异图，更新后立即无更新参数重跑；
- macOS 或其他渲染环境的结果只能作为人工证据，不得写回 Linux 基线；不得通过提高容差或盲目更新基线掩盖结构变化。

## 5. Review 结论与交付

按严重程度输出：

- **阻塞问题**：行为、API、兼容性、视觉契约或验收所需证据不满足；
- **非阻塞问题**：不影响当前契约的风险或后续建议；
- **未验证项**：明确超出范围或受环境限制且不影响当前契约的证据。

每项问题给出文件行号、可复现行为、根因、影响、最小修复与应补测试。验收必需证据缺失必须算阻塞，不能用“未验证”绕过。

没有阻塞问题时才判定通过。用户明确要求创建或更新 PR 时：

1. 标题遵循 Conventional Commits，并反映当前源码实际变化；
2. 正文根据最终 diff、行为、API 影响和测试证据填写完整模板；
3. 不把“对齐小程序”或跨端比较过程写成实现内容；
4. 不写源码未实现的能力，不沿用过时标题或计划；
5. 更新后核对 title、body、base/head、commit、文件范围和 checks。

有阻塞问题时不得用改标题、正文、Golden 容差或更新基线规避。修复后基于最新 head 重新完整 Review。

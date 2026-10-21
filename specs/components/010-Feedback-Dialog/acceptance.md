# Dialog 验证范围与结论

## 本次范围

2026-10-20：整理设计背景、决策和验收记录，重点冲突对照公开源码检查；本次未重新执行组件、Golden、设备或远端 CI。以下是原有范围内的证据摘要，不构成当前候选通过声明。

## 已有验证结论

| 原记录范围 | 原文可追溯标识与环境 | 有界结论 |
| --- | --- | --- |
| 既有记录 | `c345e5fbb915f2147c788ebdd5db437841f06ae4`、`ed6ac81deea5d831dabf21c2c5345c72d7dd7522`、`3583cba34fbb6d148a80b811542f30224ccb40e7`；Flutter 3.32.0 / 3.47.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围）；设备：仅按下文的实际操作与未覆盖范围解释 |

同一原记录可能包含多个复验阶段；上表保留原文可识别的提交、源码/参考源标识与 SDK；这些标识不保证是同一个验证候选，不把它们合成为一次完整矩阵。未提供唯一候选或原始日志绑定的结果，须在实际交付时复核。

## 验证范围与未覆盖项

- Android 16 真机已局部验收“确认类-带标题”的取消/确认配色。最终全部 22 个 Demo 的蒙层交互与关闭来源尚未完成完整真机复验；Widget 测试和覆盖率不能替代真机证据。
- 2026-09-03 读取当前 head 的远端结果：CNB 8/8 通过；GitHub analyze、test、Golden 与各平台构建通过，但拼写检查失败、CLA 待处理，不能将整体 CI 标记为全绿。拼写失败唯一命中下方验收记录中的设备型号，已在本次文档修订中移除该非必要标识，远端结果需推送后重验。
- 最新 [CodeBuddy Review](https://cnb.cool/tencent/tdesign/tdesign-flutter/-/pulls/125#comment-2095402176306794496) 未提出新的组件实现缺陷；CodeBuddy 已按当前源码同步 CNB PR 元数据，GitHub PR #1036 也已同步标题、正文与更新日志。

以下保留各阶段实际执行结果与当时的限制。“本轮”“当前”“未提交/推送”等均指所属阶段，不代表顶部所列最新 head；阶段计数也不代表最新测试总数。

- 直接读取用户指定 Figma 分支中 Dialog 的 `descriptions` 图层（节点 `28600:41090`）：原文为“告知当前状态、信息和解决方法，等内容。描述尽可能控制在三行内。”；Demo 保留设计稿标点，移除多出的“文案”并补齐句号，不修改组件 API 或限制正文行数。
- 新增反馈、确认、输入、图片和文字按钮场景的原文断言；Flutter 3.32.0 与 3.47.0 的 Demo 测试均为 10/10，定向严格 analyze 均为 0 issues，示例代码生成与 check 通过。
- Flutter 3.32.0 Linux 初次比较只有 10 张打开态正文发生预期变化（每张 2871px，约 0.94%），2 张页面基线不变；检查实际图、旧基线与差异图后更新，并在不带 `--update-goldens` 的精确比较下复跑 12/12 通过。此处验证文案与对应回归，不代表新增了真机或全页跨端像素一致性证据。

- 根因位于 Dialog 的 normal role 默认解析，并非标准 Demo 缺少颜色参数。普通基础操作改为 `fill + light`；主要/危险操作、普通文字/描边/幽灵操作，以及显式配色与 ButtonStyle 覆盖保持原有语义，不修改共享 TButton，也不新增 API。
- 标准 Demo 去除与 role 重复的主操作默认配色；完全自定义的垂直操作区仍由调用方组合 TButton，其次要按钮同步为浅色填充。纯标题确认的浅色主操作继续保留显式场景选择。
- 新增回归首先在旧实现复现 `expected fill / actual outline`；修复后 Flutter 3.32.0 与 3.47.0 组件测试各 26/26，Demo 功能测试各 11/11，定向严格 analyze 均为 0 issues。实际 Material 背景与文字色验证覆盖明暗主题、自定义品牌 token、实例与 Dialog Theme 样式覆盖。
- Flutter 3.32.0 组件测试与回归调度器自测合计 37/37；Dialog 生产源码覆盖率 `227/231 = 98.27%`，超过 95% 门禁；既有组件、Demo 与 Golden 调度清单仍覆盖本次修改的文件。示例生成器及 check 通过。
- Flutter 3.32.0 与 3.47.0 全量 `flutter analyze --fatal-infos --no-pub` 均为 0 issues。
- Flutter 3.32.0 Linux 首次精确比较：8 张既有打开态出现预期按钮差异（单个取消按钮 5016～5017px，约 1.65%；多按钮 21000px，约 6.90%），页面和文字按钮共 4 张不变；另外新增三个确认场景及垂直操作的明暗 8 张 Golden。检查旧图、实际图及差异图后更新，在同一容器不带 `--update-goldens` 复跑 20/20，最终精确比较无差异，未放宽容差。
- 已在 Android 16 真机安装并打开“确认类-带标题”，确认取消为浅色填充蓝字、确定为品牌色填充白字；此处仅为该场景真机验收，不代表完整跨端像素一致。
- 默认视觉属于 breaking change；保留旧外观的迁移方式见 spec.md。尚未提交、推送或更新远端 PR。

- 根据用户补充要求，将显式开启范围从确认类扩展到全部 22 个公开入口（17 处展示调用，其中图片 helper 被 6 个入口复用）；反馈、输入、图片、自定义操作等统一允许点击蒙层关闭，组件全局默认 false 保持不变。
- 回归先复现“反馈类-带标题 left 蒙层应关闭”失败；补齐显式参数后，375×812 视口逐入口验证四方向蒙层关闭，共 88 次，并验证每次面板内点击不关闭。补充滚动后等待布局稳定，避免在首屏外输入类入口布局未完成时查找失败；原有按钮关闭、输入及关闭来源测试继续保留。
- Flutter 3.32.0 与 3.47.0 Demo 测试各 14/14 通过；Linux 3.32.0 Golden 不更新基线精确复验 22/22，差异 0%。示例片段生成与 check、diff check 通过；本次不修改生产组件源码或 Golden 基线。
- 本轮未更新手机安装包、未提交或推送。此节覆盖此前仅确认类显式开启的 Demo 契约，不代表新增真机或跨端完整视觉验收。

## 原记录提到的验证入口

- `flutter test --no-pub test/components/dialog/t_dialog_test.dart --coverage`
- `flutter test --no-pub test/dialog_page_test.dart`
- `flutter analyze --fatal-infos --no-pub`
- `dart run tool/generate_example_code.dart --check`

入口仅用于追溯原记录；是否执行、对应环境和结果以原范围为准，不表示本轮重跑。

## 必要证据与追溯

原记录未给出可独立访问且绑定唯一候选的原始日志入口；保留的基线标识不能代替缺失证据。后续验证在此追加与最终方案相关的结论及必要链接，不重复保存每次运行流水。

明确待办统一见 [tasks.md](./tasks.md)。没有新证据时不变更完成状态；已有日期与 SHA 只描述原记录覆盖范围。

<a id="source-083"></a>

## 083 · 文字槽恢复与共享 Theme 验收

来源：#1181；原独立分支 `rss1102/fix/dialog-text-slots`，原基线 `d0de29e8`，已随 develop 的 `a30f5770` 合入。以下保留原日期、SDK、执行范围和限制；归并不增加运行证据，也不把原本地结果改写成当前 PR 验收。

2026-10-21。分支 rss1102/fix/dialog-text-slots，基线d0de29e8；不含另一分支、Button/NavBar、ActionSheet、CI优化或工具链升级。以下为提交前独立副本的本地验证记录；后续按用户授权独立发布，远端状态以PR页面为准。

### 双版本非视觉检查

Flutter3.32.0/3.47.7各通过 42 项登记组件/工具归属测试、16 项Demo非视觉、18 项调度、34 项既有文字契约；严格analyze --fatal-infos零诊断，57份API与6份文档一致。

| 组件覆盖率 | 3.32.0 | 3.47.7 |
| --- | --- | --- |
| dialog | 98.68% | 98.68% |

### 视觉与边界

纯分支Linux Flutter3.32.0所属视觉入口 48 项通过（含结构/交互，不等于相同数量PNG）；共享PopupProgress入口去重。未使用更新参数，1052张既有PNG未变。
Dialog旧Popup图差4.00%/9996px，修复后恢复原基线；Demo前后均通过，详见[原基线矩阵](#record-083-baseline-matrix)。

全局TText/Resolve/Scope、原生工具链和工作流未改。源代码与测试由纯分支重新执行，没有移用另一分支通过结论。未验证远端CI、全57组件、设备前台或APK/Web/iOS。

### 执行入口

本地 artifacts/text-slot-split-matrix-20261021/validate-split.py 调用严格分析、登记组件flutter test --coverage、check_component_coverage、Demo --exclude-tags golden、调度/文字契约及正式API --check；run-split-goldens.py执行纯分支原视觉入口。具体命令/退出码/耗时在该目录按版本的results.json和split-linux-results.json，矩阵见本地原记录split-matrix.md。

### 共享 Theme 场景补充验收（2026-10-21，提交前本地验证）

PR #1181 的 28b0cf01 在远端共享 Theme 场景 `custom content retains its theme beside TD visuals` 中出现 6253px / 1.96% 差异：自定义内容里未配置样式的 TText 接收了 Dialog 正文默认，字号/行高由 14/22 变为 16/24，颜色由主文字色变为次文字色。此前仅执行 Dialog 所属视觉入口，未覆盖这一共享消费者；前文结论仅限原记录范围。

本轮仅修复测试场景。进入 Dialog 前捕获调用方 TD 文字默认，在内容内部通过显式局部 TTextThemeData 恢复；保留 Material 与图标主题。功能与 Golden 共用 `test/helpers/custom_content_theme_scene.dart`，避免两份场景漂移。原登记的 `t_strict_material_boundary_test.dart` 新增功能断言，同时验证 M2/M3 下 TD 字体、行高、颜色与自定义 Material 文字/图标主题，不需新增调度入口。不修改 Dialog 或全局 TText 生产代码。

| 本地检查 | Flutter 3.32.0 | Flutter 3.47.7 |
| --- | --- | --- |
| 聚焦新增回归 | 1项通过 | 1项通过 |
| 严格 analyze --fatal-infos | 零诊断 | 零诊断 |
| 完整登记 Theme 功能回归 | 184项通过 | 184项通过 |
| Theme 生产行覆盖率 | 841/868，96.89% | 838/868，96.54% |
| Dialog + TText契约 + 调度 | 94项通过 | 94项通过 |
| Theme Demo非视觉 | 14项通过 | 14项通过 |

功能稳定后，在既有 Linux Flutter 3.32.0 镜像、相同字体与依赖下执行完整 Theme Component 27项、Theme Demo 22项测试（含功能/结构与像素检查，非PNG数量），全部通过，`m3_custom_content.png`精确匹配原基线。未使用更新参数。

反向验证：在临时3.32.0副本移除局部主题，新功能断言按预期失败（期望14，实际16），随后已恢复副本。既有PNG哈希核对无变更；以上为提交前本地验证证据；后续按用户授权推送至 #1181，不能推定新提交的远端CI已经通过。完整命令、退出码、耗时和源码指纹在本地 `artifacts/pr1181-local-theme-fix-20261021/`。

<a id="record-083-baseline-matrix"></a>

### 083 · 原基线矩阵与截图

同一Linux Flutter3.32.0、原基线、依赖和字体。通过仅限列出的既有场景，非全部TText用法像素覆盖。

| 组件 | 修复前 | 修复后 | PNG更新 |
| --- | --- | --- | --- |
| dialog | Popup差4.00%/9996px，Demo通过 | 既有入口通过 | 不需要 |

#### 审阅截图

以下是既有同环境诊断的实际渲染截图，非新增或更新Golden基线。修复后截图SHA与原基线一致；纯分支另经Linux精确比较通过。

| 修复前实际图 | 修复后实际图 |
| --- | --- |
| ![修复前](evidence/text-slot-restoration/dialog-before.png) | ![修复后](evidence/text-slot-restoration/dialog-after.png) |

#### 共享Theme消费者补充

| 场景 | PR原提交 | 显式局部主题补齐后 | PNG更新 |
| --- | --- | --- | --- |
| m3_custom_content（M2/M3） | CI差1.96%/6253px | Linux原基线精确通过 | 无 |
| 完整Theme Component / Theme Demo | 此前未纳入Dialog局部验收 | 27/22项测试通过 | 无 |

仅补齐自定义内容自身主题意图，Dialog直接TText槽仍使用Dialog默认。详见上方共享 Theme 场景补充记录。

## 从原 Spec 归档的历史执行记录

文档来源：`987e639087a7146d87d957a2a068765c5394d121` 的同组件 spec.md；该 SHA 仅标识文档来源，不是下列各次测试的统一候选。保留原文 SDK、平台、计数和未覆盖范围；原文未绑定唯一候选的部分仍无法据此确认。下列“本轮”“当前”“未提交”等仅指原阶段，本次未重新执行或外推其结论。

- Flutter 3.32 Linux 亮暗主题 38 个 Golden 在本轮像素修复后无 `--update-goldens` 精确复跑 38/38 通过，未放宽容差。

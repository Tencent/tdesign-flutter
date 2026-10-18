# 验收

原完整 head：af58482ed807dae1f3c052ec269dfd296831eb85。基础 PR #1172 稳定检查点：590df49a6209d31978e70e2eb4ea26101c605a6f。

## 拆分边界

3801 个原受版本管理文件均按 Git blob 逐字节核对一致，运行源码、测试、API、资源和 98 张 Golden 未重新改写。额外内容只有 078/079 拆分文档；详见 equivalence.json。077 内历史记录按各自指纹解释，不改写成当前新 head 的结果。

## 初次拆分本地验证（历史检查点）

Flutter 3.32.0 / 3.47.7 分别通过 565 项组件/主题/调度器测试、115 项 Example 测试（57 页明暗双模式消费矩阵及清单），严格分析与 API 审计通过。theme、Badge、Button、Tag 的生产行覆盖率均超过 95%，分项见 results.json。

执行组件清单中的 theme 组、Badge/Button/Tag 非 Golden 测试及三个回归调度/覆盖率工具测试，使用 `flutter test --no-pub --exclude-tags golden --coverage --reporter expanded`。矩阵使用 Example 的 `test/theme/all_component_web_theme_test.dart`，带 `--dart-define=TDESIGN_DEMO_TEST_MODULES=false`。分析使用 `flutter analyze --fatal-infos`，API 使用 `dart run tool/audit_api_docs.dart`，覆盖率用 `tool/check_component_coverage.dart`。

## 初次拆分视觉与远端边界（历史检查点）

98 张基线及全部原实现与 af58482e 一致；其历史全量 CI https://github.com/Tencent/tdesign-flutter/actions/runs/39055021982 已通过，属于相同源码的历史证据。本次没有重新更新基线，不能将历史结果声称为本 PR 新 head 的远端 CI。

仓库 CI 只对目标 develop 的 PR 运行。此 PR 先以 #1172 分支为 base；必须先合入 #1172、切换本 PR 目标为 develop，再完成新 head 的完整远端 CI 后单独审阅。这是初次拆分时的状态，已由下方合入后整理与新head验收覆盖。

## 后续 Review 检查点

初次恢复与树一致性记录只适用于 b374adc2。当前修正见 review.md / review-results.json：修复14项新增全局默认的几何插值与BackTop实际布局取值，不改变默认值或新增映射。双SDK各512组件测试和157页面测试通过，八组覆盖率均>95%，严格分析、API审计通过；17项新增回归已登记。Linux Flutter3.32原比较器无更新视觉比较25组全部通过，包含原16组已审阅基线归属场景及本轮受影响场景；98张PNG均保持批准记录的哈希，没有更新基线。这是该Review检查点的状态，不作为最新远端CI结论。

## #1172 合入后的冲突整理

#1172 实际以 squash 提交 `f5d8df2f2bc43224406319b4944930454458930c` 合入 develop，与原 head `590df49a6209d31978e70e2eb4ea26101c605a6f` 的 Git tree 完全一致。将 #1174 独有5个提交移植到新的 develop 后，检查点 `332b8d6eb35cff92de6b561d224c9d66e1855424` 与原 #1174 head `56c460a8524b39e5625af6032d8b9fde0c3c71ff` 的全部受版本管理文件逐字节一致；breaking 增量的二进制 diff 亦完全一致。详见 rebase-results.json。

本次没有通过手选 ours/theirs 改写组件或删除测试；运行源码、显式覆盖/中断插值修复、已确认的依据和98张基线均保留。重放不重复原 #1172 历史。后续新增仅为本节验收证据。按相同源码指纹复用既有双SDK512组件/157页面/25组Linux视觉结果，不重复跑相同本地门禁。该整理检查点的远端CI随后已完成，见下方 ca5c7c61 记录；不冒充本轮补充后的新head检查。

## CI 独立分组登记补正

移植后的真实CI分组核对发现：历史512项合并测试集得出的Drawer覆盖率不等于Drawer独立门禁，原独立组为273/288（94.79%）。将原全局过渡测试文件中的Drawer三项用例原样移入Drawer组件目录，登记到其componentTests；用例内容、总数及运行源码未改。此次仅调整测试所有权，不改变默认值、映射或Golden。按真实入口对Drawer及theme两组分别重新验证。

登记补正后，Flutter3.32 Drawer独立组276/288（95.83%），Flutter3.47.7为275/288（95.49%）；八个受影响分组均按真实CI命令分别通过门禁，严格分析零诊断，调度器22项自测通过。全部原17项过渡用例保留，Drawer三项断言主体忽略格式空白与旧文件一致。详细独立结果见ci-registration-results.json，不能再用历史合并统计替代独立门禁。

## 当前基础和上一已完成CI

当前目标为develop；登记补正head ca5c7c61379e9ef850b7cc6866089d4d90468f6b的完整test-build（run 39141947514）已通过，双SDK分析/功能/覆盖率与六项构建、Linux视觉均成功。下一个Golden补充提交必须等待自己的完整CI；旧记录不能代替新head结果。

## 2026-10-19 当前Golden验收

本批只有测试、视觉清单、PNG及Spec文档，生产组件、示例与API资源相对ca5c7c61逐字节未变。明暗模式8张目标图先无更新运行：2张稳定复现BackTop字体差异，6张提示新增基线不存在；无布局/交互异常。再于独立develop源码f5d8df2f中用相同新测试场景生成6张旧默认参考，不复制回仓库。以参考图比较新实现后，逐项查看8张实际/前图/差异图，确认Cell仅四角、Tabs仅padding布局变化、BackTop缺字修正。

在Flutter3.32.0 Linux amd64（framework be698c48a6、engine1881800949、Dart3.8.0）、DPR1、text scale1、固定测试字体环境中执行一次8项更新，随后立即用同一文件清单去除更新参数复跑，8项全部通过，精确像素差异0；比较器和容差未改。未使用macOS结果写回基线。旧默认参考只用于差异证据，不用作当前期望。

| 场景 | 状态与实际触发 | 基线 | 功能证据 |
| --- | --- | --- | --- |
| BackTop组件矩阵 | 圆/半圆×明/暗配色×有/无文字，静态8态 | dark/light各1张替换 | backtop三个组件测试入口；现有默认/覆盖断言 |
| Cell卡片默认圆角 | 默认卡片与组件内置边框卡片，圆角/padding均未指定 | dark/light各1张新增 | t_cell_test及component_token_ownership_test双模式默认9、token/显式覆盖断言 |
| Tabs可滚动tag | 初始选中Short、真实点击Long label后；保留Disabled标签 | dark/light×initial/selected，共4张新增 | tabs四个组件测试入口及component_token_ownership_test双模式padding16/外层覆盖断言 |

新Cell组件视觉套件及Tabs新增测试已登记component_test_manifest.dart；BackTop沿用已有入口。双SDK分别226项功能/主题/调度器自测通过，严格分析零诊断。原98张批准图片中96张哈希不变；两张BackTop有意替换。当前104张变更Golden完整清单、测试文件指纹、前后SHA和差异区域见golden-completion-results.json；前后对照图位于evidence/。不将本批聚焦组件截图声称为57页全部状态验收。最终提交的远端完整CI另以PR当前head的Checks和正文记录为准。

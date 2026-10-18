# 验收

原完整 head：af58482ed807dae1f3c052ec269dfd296831eb85。基础 PR #1172 稳定检查点：590df49a6209d31978e70e2eb4ea26101c605a6f。

## 拆分边界

3801 个原受版本管理文件均按 Git blob 逐字节核对一致，运行源码、测试、API、资源和 98 张 Golden 未重新改写。额外内容只有 078/079 拆分文档；详见 equivalence.json。077 内历史记录按各自指纹解释，不改写成当前新 head 的结果。

## 当前本地验证

Flutter 3.32.0 / 3.47.7 分别通过 565 项组件/主题/调度器测试、115 项 Example 测试（57 页明暗双模式消费矩阵及清单），严格分析与 API 审计通过。theme、Badge、Button、Tag 的生产行覆盖率均超过 95%，分项见 results.json。

执行组件清单中的 theme 组、Badge/Button/Tag 非 Golden 测试及三个回归调度/覆盖率工具测试，使用 `flutter test --no-pub --exclude-tags golden --coverage --reporter expanded`。矩阵使用 Example 的 `test/theme/all_component_web_theme_test.dart`，带 `--dart-define=TDESIGN_DEMO_TEST_MODULES=false`。分析使用 `flutter analyze --fatal-infos`，API 使用 `dart run tool/audit_api_docs.dart`，覆盖率用 `tool/check_component_coverage.dart`。

## 视觉与远端检查的边界

98 张基线及全部原实现与 af58482e 一致；其历史全量 CI https://github.com/Tencent/tdesign-flutter/actions/runs/39055021982 已通过，属于相同源码的历史证据。本次没有重新更新基线，不能将历史结果声称为本 PR 新 head 的远端 CI。

仓库 CI 只对目标 develop 的 PR 运行。此 PR 先以 #1172 分支为 base；必须先合入 #1172、切换本 PR 目标为 develop，再完成新 head 的完整远端 CI 后单独审阅。当前不声称已满足最终合入条件。

## 后续 Review 检查点

初次恢复与树一致性记录只适用于 b374adc2。当前修正见 review.md / review-results.json：修复14项新增全局默认的几何插值与BackTop实际布局取值，不改变默认值或新增映射。双SDK各512组件测试和157页面测试通过，八组覆盖率均>95%，严格分析、API审计通过；17项新增回归已登记。Linux Flutter3.32原比较器无更新视觉比较25组全部通过，包含原16组已审阅基线归属场景及本轮受影响场景；98张PNG均保持批准记录的哈希，没有更新基线。当前 #1174 仍不满足最终合入门禁。

## #1172 合入后的冲突整理

#1172 实际以 squash 提交 `f5d8df2f2bc43224406319b4944930454458930c` 合入 develop，与原 head `590df49a6209d31978e70e2eb4ea26101c605a6f` 的 Git tree 完全一致。将 #1174 独有5个提交移植到新的 develop 后，检查点 `332b8d6eb35cff92de6b561d224c9d66e1855424` 与原 #1174 head `56c460a8524b39e5625af6032d8b9fde0c3c71ff` 的全部受版本管理文件逐字节一致；breaking 增量的二进制 diff 亦完全一致。详见 rebase-results.json。

本次没有通过手选 ours/theirs 改写组件或删除测试；运行源码、显式覆盖/中断插值修复、已确认的依据和98张基线均保留。重放不重复原 #1172 历史。后续新增仅为本节验收证据。按相同源码指纹复用既有双SDK512组件/157页面/25组Linux视觉结果，不重复跑相同本地门禁。最终新 head 的远端完整CI待本次推送后执行，不冒充旧head检查。

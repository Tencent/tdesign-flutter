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

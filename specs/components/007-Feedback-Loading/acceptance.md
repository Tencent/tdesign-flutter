# Loading 验证范围与结论

## 本次范围

2026-10-20：整理设计背景、决策和验收记录，重点冲突对照公开源码检查；本次未重新执行组件、Golden、设备或远端 CI。以下是原有范围内的证据摘要，不构成当前候选通过声明。

## 已有验证结论

| 原记录范围 | 原文可追溯标识与环境 | 有界结论 |
| --- | --- | --- |
| 既有记录 | `ab04f68`、`8e8d68f6`、`33352953431`；Flutter 3.32.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围）；设备：仅按下文的实际操作与未覆盖范围解释 |

同一原记录可能包含多个复验阶段；上表保留原文可识别的提交、源码/参考源标识与 SDK；这些标识不保证是同一个验证候选，不把它们合成为一次完整矩阵。未提供唯一候选或原始日志绑定的结果，须在实际交付时复核。

## 验证范围与未覆盖项

- 原阶段记录：`t_loading.dart` line 92 的 `colorScheme?.primary` fallback 当时未覆盖，不影响该阶段 ≥95% 门槛。该 Material 回退在当前源码中已移除，旧行号和缺口不再作为当前测试要求。
- **真机像素表现仍未实测**：已有微信开发者工具 iOS 模拟器截图与 Linux Golden，但不将其外推为真机 DPR 结论。
- `reverse` / `pause` / `delay`（后续迭代，官方发布版未公开对应 Demo）。
- `attach`（仅 Vue 独有且发布版注释）。

## 原记录提到的验证入口

- `flutter analyze --fatal-infos --no-pub`
- `flutter test test/components/loading/t_loading_test.dart`
- `flutter test --coverage test/components/loading/t_loading_test.dart`
- `flutter test test/loading_demo_test.dart`
- `flutter test test/tool/check_component_coverage_test.dart test/tool/run_component_regression_test.dart test/tool/run_visual_regression_test.dart`
- `dart run tool/generate_example_code.dart --check`

入口仅用于追溯原记录；是否执行、对应环境和结果以原范围为准，不表示本轮重跑。

## 必要证据与追溯

原记录未给出可独立访问且绑定唯一候选的原始日志入口；保留的基线标识不能代替缺失证据。后续验证在此追加与最终方案相关的结论及必要链接，不重复保存每次运行流水。

明确待办统一见 [tasks.md](./tasks.md)。没有新证据时不变更完成状态；已有日期与 SHA 只描述原记录覆盖范围。

## 从原 Spec 归档的历史执行记录

文档来源：`987e639087a7146d87d957a2a068765c5394d121` 的同组件 spec.md；该 SHA 仅标识文档来源，不是下列各次测试的统一候选。保留原文 SDK、平台、计数和未覆盖范围；原文未绑定唯一候选的部分仍无法据此确认。下列“本轮”“当前”“未提交”等仅指原阶段，本次未重新执行或外推其结论。

- Flutter 3.32 Linux 首次精确比较：light 704px（0.17%）、dark 698px（0.16%）；差异只覆盖纯图标、横向图文、竖向图文共 3 个 activity 指示器。只更新 Loading light/dark 两张 Golden 后，无更新参数复跑 2/2。

- 完整修改前、修改后与独立像素差异图保存在 GitHub PR #1126 描述的附件中，不作为 Spec 二进制文件提交。

- Flutter 3.32：组件与工具回归 63/63（其中 Loading 组件 50/50），公开 Demo 2/2；生产源码 LCOV `265/266 = 99.62%`；组件与 Example 严格 analyze 均 0 issues。

- Flutter 3.47：Loading 组件 50/50、公开 Demo 2/2；组件与 Example 严格 analyze 均 0 issues。两个 SDK 间执行 clean 并分别恢复依赖，未混用编译缓存。

- 示例代码生成器 `--check` 通过，无生成片段变化。

原先混入验收标准的阶段性表述也仅作为历史原文保留，不由此补充通过证明；当前门槛仍为95%：

- 明暗主题整页 Golden 已在 Flutter 3.32.0 Linux CI 复现通过，且已与小程序实际页面截图完成人工比对。

- 站点 README 链接、API 表、示例代码已修正，`loading_api.md` 与 README 一致。

- Loading 全部手写生产源码行覆盖率 ≥95% 且不低于修改前基线（86.15%）。

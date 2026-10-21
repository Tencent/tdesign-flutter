# Cell / Table / Tabs 用户裁定验收（2026-10-16）

| 消费点 | 默认变化 | 实际全局来源 | 显式覆盖 |
| --- | --- | --- | --- |
| M037 Cell card圆角 | 8→9 | radiusLarge | cardBorderRadius优先 |
| M087 Table单元格水平padding | 16→12 | spacer1 | cellPadding优先 |
| M089 Tabs tag内框水平padding | 8→16 | spacer2 | 既有外层labelPadding独立生效 |

依据为用户确认值及冻结小程序a9f3ba680481d438b0be37e2e25cf4a62cf0acb3的实际引用链。Cell的cardPadding、Table纵向padding0、Tabs tag高度32和外层边距保持原行为。没有借用size同值刻度或使用比例。公开API签名不变；三项默认外观为有意的行为变更，应在后续发布中说明，显式值无需迁移。

## 本地验证

| 检查 | Flutter3.32.0 | Flutter3.47.7 |
| --- | --- | --- |
| Cell/Table/Tabs组件、主题隔离与3个调度器自测 | 193通过 | 193通过 |
| 3页明暗主题矩阵及对应页面功能 | 15通过 | 15通过 |
| analyze --fatal-infos | 无问题 | 无问题 |
| Cell生产行覆盖率 | 189/190，99.47% | 189/190，99.47% |
| Table生产行覆盖率 | 432/432，100% | 432/432，100% |
| Tabs生产行覆盖率 | 770/788，97.72% | 770/788，97.72% |

组件执行：枚举test/components/{cell,table,tabs}中的非golden测试，加test/theme/component_token_ownership_test.dart及test/tool/{run_component_regression,run_visual_regression,check_component_coverage}_test.dart；flutter test参数--exclude-tags golden --coverage --reporter expanded。tool/check_component_coverage.dart分别过滤cell/table/tabs的生产源码，均通过既有95%门槛。

页面执行：example目录设置TDESIGN_THEME_COMPONENT=cell,table,tabs，flutter test --dart-define=TDESIGN_DEMO_TEST_MODULES=false test/theme/all_component_web_theme_test.dart test/cell/cell_page_test.dart test/table/table_page_test.dart test/tabs/tabs_page_test.dart --exclude-tags golden --reporter expanded。每SDK含3页×2模式共6组主题记录，见three-results-<SDK>.json。覆盖率原始输出见three-coverage-<SDK>.txt。

聚焦断言在明暗模式分别检查9/12/16默认、相关Token实时变化、无关档位隔离及Element保持；Table同时检查表头与数据，Cell/Table检查组件显式覆盖；Tabs确认外层显式padding7和minHeight32不随内框Token改写。共享测试沿用已登记文件，3个调度器自测通过。3份API用生成器生成并再次输出到临时目录逐字节比对通过。

源码范围哈希核对确认：本批仅3个运行实现及3个对应主题API注释发生生产文件变化，其他生产文件保留本批开始状态。git diff --check通过。源码指纹见three-decision-source-fingerprint.json。本批没有重跑全部57页，其他组件复用其历史检查点，不能宣称当前57页全量重验。

## 仍待执行

Linux像素Golden未执行、基线未更新；当前macOS且无可用Docker daemon。[组件对齐技能第284行](../../../../../.agents/skills/tdesign-component-align-review/SKILL.md#L284)要求“自动 Golden 与其他像素比较测试仅在 Flutter 3.32.0 Linux 执行和更新基线”。需在该环境验收这三处有意视觉差异；本地功能通过不替代像素验收。本批未部署。

原小程序比较报告保留为裁定前证据，其中3项默认冲突现已解决；当前行为以本记录和mapping-review为准。剩余45项的原因与所需证据见[remaining-45-analysis.md](remaining-45-analysis.md)，这些点本批未改。

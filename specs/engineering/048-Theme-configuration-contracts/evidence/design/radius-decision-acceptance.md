# 用户圆角裁定增量验收（2026-10-16）

本批以用户指定 Figma 文件 `5iZtzla34Rz25j4cK7viAz` 的已保存变量及绑定快照为准，只修正下列两处默认值和主题消费。其他缺少依据的映射保留本批开始时的行为；历史全量验收仍见 [design-acceptance.md](design-acceptance.md)。

| 消费点 | 设计证据 | 本批结果 |
| --- | --- | --- |
| M019：Badge square | 节点27741:30861、25181:19264绑定radius-default=3 | 2→3px；直接消费Flutter radiusSmall |
| M069：SideBar tag选中内块 | 节点I27264:21535;27264:20989;27273:20750绑定radius-medium=6 | 9→6px；直接消费Flutter radiusDefault |

设计文件与仓库的圆角档位命名不同：设计default=3适配Flutter Small=3，设计medium=6适配Flutter Default=6。不修改全局圆角定义，不新增Medium档，不使用比例凑值。两处默认视觉变化均为用户明确裁定。

Badge气泡普通角10、尖角1、dot8、padding4/6不变；SideBar line相邻项反向角9、tag最小高56不变。此前已确认的padding映射不变。逐项依据、待确认项与当前行为已同步到 [mapping-review.md](mapping-review.md) 及机器清单JSON。

## 本批验证

| 检查 | Flutter 3.32.0 | Flutter 3.47.7 |
| --- | --- | --- |
| 4组组件、共享隔离断言及3个回归工具自测 | 251通过 | 251通过 |
| 4个受影响详情页主题及Badge/SideBar示例功能 | 29通过 | 29通过 |
| 严格分析（--fatal-infos） | 无问题 | 无问题 |
| Badge生产行覆盖率 | 279/280，99.64% | 277/280，98.93% |
| SideBar生产行覆盖率 | 239/240，99.58% | 239/240，99.58% |
| ActionSheet生产行覆盖率 | 541/559，96.78% | 540/559，96.60% |
| TabBar生产行覆盖率 | 547/555，98.56% | 546/555，98.38% |

每个SDK的组件命令：`flutter test test/components/{badge,sidebar,action_sheet,tabbar}/*test.dart`（实际枚举排除golden文件），另含`test/theme/component_token_ownership_test.dart`及`test/tool/{run_component_regression,run_visual_regression,check_component_coverage}_test.dart`，参数`--exclude-tags golden --coverage --reporter expanded`。覆盖率由`tool/check_component_coverage.dart`分别过滤并通过既有95%门槛，原始结果见本目录`radius-coverage-<SDK>.txt`。

页面命令：在example目录以`TDESIGN_THEME_COMPONENT=badge,side-bar,tab-bar,action-sheet`运行`flutter test --dart-define=TDESIGN_DEMO_TEST_MODULES=false test/theme/all_component_web_theme_test.dart test/badge/badge_page_test.dart test/sidebar/sidebar_anchor_test.dart test/sidebar/sidebar_demo_test.dart test/sidebar/sidebar_page_test.dart --exclude-tags golden --reporter expanded`。每SDK包含4页×light/dark，共8组结果，见`radius-results-<SDK>.json`。SideBar通过真实点击“自定义样式”进入tag示例，确保圆角测试实际检查目标内块。

聚焦断言验证默认3/6、相关圆角token原位实时更新、无关圆角档不影响目标属性、Element保留及无框架异常；同时验证气泡专有角与line反向角保持原值。共享Badge消费者ActionSheet及TabBar纳入回归。本批没有重新运行全部57页，其他页面沿用裁定前检查点，不能将本批结果称为57页新全量验收。

Badge与SideBar两份API文档由生成器同步，并再次生成到临时目录逐字节比对通过。生产文件与本批开始时的哈希比较确认：除两处运行时实现及对应两处API注释外，其他生产文件未变；新增测试沿用已登记文件，3个调度器自测通过。`git diff --check`通过。源码及设计快照指纹见 [radius-decision-source-fingerprint.json](radius-decision-source-fingerprint.json)，不覆盖历史检查点。

## 待验收

Linux像素Golden尚未执行，基线未更新。当前环境为macOS且无可用Docker daemon；[组件对齐技能第284行](../../../../../.agents/skills/tdesign-component-align-review/SKILL.md#L284)要求“自动 Golden 与其他像素比较测试仅在 Flutter 3.32.0 Linux 执行和更新基线”。因此两处有意视觉变化仍需该环境比对实际图、基线图和差异图。双SDK功能结果不替代像素验收；本批未部署站点。

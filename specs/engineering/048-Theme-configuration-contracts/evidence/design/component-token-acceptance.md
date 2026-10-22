# 三组件组件级 Token 验收（2026-10-17）

实现与优先级见[component-token-mapping.md](component-token-mapping.md)。本批只新增9个可选组件Theme字段，不扩展站点控制器及转换链路，不新增全局映射，不改变默认外观。基线b6f7f9d6包含PR原修复及自动生成的Drawer API补充；已审阅自动提交只改变该API文档。

## 本地稳定检查点

| 检查 | Flutter 3.32.0 | Flutter 3.47.7 |
| --- | --- | --- |
| 三组件/共享主题/调度器功能测试 | 454通过 | 454通过 |
| 三页功能及57页全局联动测试 | 127通过 | 127通过 |
| 严格分析--fatal-infos | 无问题 | 无问题 |
| API文档覆盖审计 | 57组件/370公开声明/0问题 | 57组件/370公开声明/0问题 |
| badge生产覆盖率 | 300/307，97.72% | 298/307，97.07% |
| button生产覆盖率 | 542/546，99.27% | 542/546，99.27% |
| tag生产覆盖率 | 343/350，98.00% | 343/350，98.00% |

报告见component-token-results-<SDK>.json（每份114个页面/模式键）及component-token-coverage-<SDK>.txt；指纹见component-token-source-fingerprint.json。矩阵覆盖57页明暗模式、适用类别与组合；不能把全局类别契约数当作每个组件新字段都已由控制器接入。本批新字段通过组件Widget/Theme测试验证，不经过CSS消息链路。

组件测试覆盖Badge默认/方向圆角/非bubble隔离/原位更新/默认与显式插值；Button四档、大中档全局默认与18独立默认、普通/渐变、纯图标居中、实例ButtonStyle优先、有限非负约束、copy及中断插值；Tag四档和custom、所有variant、明暗、统一padding优先、显式不重复扣边框、TSelectTag继承、默认与统一/分档交叉/中断插值。测试沿用既有集中登记文件；3个调度器自测通过。

API使用manifest驱动的同款生成命令，针对Badge/Button/Tag/theme生成，并输出到临时目录逐字节核对；保留顶层函数。补充TSizes的既有公开API登记，修复旧PR的scope审计失败。本地typos 1.51.1全库检查通过。拼写检查对Figma冻结快照中的原始截断节点名作精确正则排除，不改写证据。生成文档已核对9个字段的类型、默认和优先级。

## 复现命令与结果复用

组件：flutter test test/components/badge/t_badge_test.dart test/components/button/t_button_{test,theme_test,theme_priority_test,widget_test}.dart test/components/tag/t_{tag,select_tag}_test.dart test/theme/{component_token_ownership_test,t_theme_extensions_test}.dart test/tool/{run_component_regression_test,run_visual_regression_test,check_component_coverage_test}.dart --exclude-tags golden --coverage --reporter expanded。覆盖率用tool/check_component_coverage.dart分别检查badge/button/tag。

example：flutter test --dart-define=TDESIGN_DEMO_TEST_MODULES=false test/badge/badge_page_test.dart test/button/{button_demo_test,button_layout_test}.dart test/tag/tag_page_test.dart test/theme/all_component_web_theme_test.dart --exclude-tags golden --reporter expanded。静态检查flutter analyze --fatal-infos；API审计dart run tool/audit_api_docs.dart。

3.32组件最终重跑前仅移除测试中重复的material导入；127项页面结果复用同一组件源码、页面源码和环境的已通过结果。初次组件回归因新增注释字形触发既有字体清单检查，调整注释后最终调度器门禁通过；未改字体资源或像素基线。SDK验证完成后恢复仓库固定3.32.0依赖配置。本机macOS，不运行像素Golden。本轮新增自定义配置尚无单独的Linux像素Golden结果，Widget几何/样式断言不等同像素验收。

## 远端状态与视觉限制

旧head b6f7f9d6的双SDK功能/构建通过，API scope登记与快照拼写失败已在本批修复；旧Linux像素回归有Badge、BackTop、Dropdown、Refresh、SideBar、Table、Toast等差异，不能写作已通过。该失败包含此前默认外观调整及其他待审差异，未经逐图核对不更新基线。本批默认不变，保持PR草稿；新增提交的远端CI与Linux像素验收仍须单独读取，不用本地功能结果替代。

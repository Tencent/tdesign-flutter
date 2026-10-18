# PR A拆分验收（2026-10-18）

拆分前完整成果af58482ed807dae1f3c052ec269dfd296831eb85；develop为3bc89d28e96d580e0893526c627dc38f16b16d82。

## 当前稳定功能检查点

Flutter3.32.0和3.47.7各通过882项主题/Badge/Button/Tag/Dialog/Drawer/Popup/Message/Toast/调度器测试、45项消息/生命周期/主题演示/三组件页面测试，以及30项独立css2token测试。严格analyze零诊断；API审计57组件/370声明/0问题；九组生产覆盖率均超过95%，分子分母见results.json。3.32新增边界测试的const诊断修正后，单独复跑4项边界与严格分析通过，其余组件生产/测试代码不变，复用882项结果。

站点适配6项通过；Example代码片段--check通过。Badge/Button/Tag/Theme四份API由源码生成，并再次生成到临时目录逐字节一致。三个调度器自测包含在882项内；新增边界测试已登记到theme套件。

消息集成测试明确断言CSS size-10=48传到TThemeData，而小按钮minimumSize仍32；颜色/字体/圆角/阴影等原已存在的消费继续验证。新边界测试检查明暗模式、修改size/radius/spacer后Badge square2、SideBar tag9、Cell card8、Table左右16、Tabs tag左右8以及Button四档尺寸/图标保持原规格；已打开Toast实时响应原颜色Token且padding仍22/14。BackTop/Dropdown/Refresh及其主题、测试源码恢复为develop，原默认20/24/24保留。

## 视觉与独立breaking

A相对develop没有任何Golden文件变更；原98张变更仅在独立breaking PR恢复。隔离Linux/amd64 Flutter3.32正使用原基线执行完整visual runner，无--update-goldens参数，结果完成后同步。不得把旧af58482e的breaking像素结果当作A的验收。

B以A为base，保留077全部依据、114个映射记录、57页矩阵、98张基线和原测试。现有CI仅对目标develop的PR运行，因此B堆叠期间采用本地双版本与原始树一致性验证；A合入并将B目标切到develop后才会触发B自己的完整CI。此限制不通过扩大仓库CI触发范围规避。

当前文件为稳定功能检查点，最终远端CI状态以PR正文和实际head为准；不把未完成检查标成通过。工作区原有token_migration/pubspec.lock不属于拆分内容。

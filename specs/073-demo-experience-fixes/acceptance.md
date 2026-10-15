# 验证记录

基线已同步 develop 01ae7b7（仅站点导航文档更新）；运行时实现与验证的应用源码一致。本 PR 仅调整 Demo、构建元数据及测试，不改变组件公开 API，无 breaking change。

## 功能与分析
- Flutter 3.32.0 / 3.47.7 macOS：完整 Example 共享功能回归各 392 项通过，内部 debug 开关另 1 项通过。后续代码资源等待和删除确认保护分别补跑代码入口 18 项、图片 6 项，双版本通过。
- 两版本完整 `flutter analyze --no-pub --fatal-infos` 通过；集中回归清单自测各 22 项通过。
- 60 个入口 / 370 个 ExampleItem 的结构与生成片段检查通过；370 份片段独立分析通过；全部清单资源可从应用包读取且非空。
- 日期验证包版本、实际构建时间、下一次构建覆盖、UTC+8 跨日与无效输入；图片验证取消、首项、末项、删空、重新体验和单图继续滑动。
- 各 GitHub/CNB 构建及本地统一脚本共用 write_demo_build_info.dart。新测试已登记到共享功能清单和 Fab / ImageViewer 视觉清单。

## 图片回归
- 环境：GitHub Actions ubuntu-24.04 / Flutter 3.32.0，375×812、DPR 1、仓库固定字体、light/dark。使用 Flutter 默认精确比较器（零容差）。未在 macOS 生成或修改 Golden 基线。
- 代码清单 / 代码面板、删除一张 / 删除全部的 8 份新基线来自 Linux 实际渲染，已逐张人工检查。既有基线未改动。
- run 38730185293、head e6f24ec：原有图片及已建立的新基线 13 项通过，仅 3 份首次基线缺失；没有组件布局或代码面板交互错误。文件来自该 run 的 golden-failures-flutter-3.32.0 artifact。
- 代码查看测试用 waitForDemoWidget 等待稳定界面；不使用固定延时推定异步资源已加载。对原来直接 await 的测试资源读取使用 tester.runAsync，避免 fake async 挂起。
- 8 份基线齐备后将再次进行无更新参数的 Linux 比对；完整 CI 状态以最终 head 为准。

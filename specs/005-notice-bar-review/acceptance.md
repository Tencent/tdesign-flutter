# TNoticeBar Review 修复 - 验收记录

## 执行的命令与结果

| 命令 | 结果 |
| --- | --- |
| `flutter analyze lib/src/components/notice_bar/t_notice_bar.dart` | No issues found |
| `flutter analyze test/components/notice_bar/t_notice_bar_test.dart` | No issues found |
| Flutter 3.32.0 `flutter test --no-pub test/components/notice_bar --coverage` | PASS，42 tests；NoticeBar `LH=230` / `LF=239` = 96.23% |
| Flutter 3.32.0 `flutter test --no-pub test/notice_bar_page_test.dart` | PASS，2 tests |
| Flutter 3.32.0 `flutter analyze --fatal-infos --no-pub` | PASS，0 issues |
| Flutter 3.47.0 `flutter test --no-pub test/components/notice_bar` | PASS，42 tests |
| Flutter 3.47.0 `flutter test --no-pub test/notice_bar_page_test.dart` | PASS，2 tests |
| Flutter 3.47.0 `dart analyze --fatal-infos` | PASS，0 issues |
| `dart run tool/generate_example_code.dart` | PASS，卡片片段已删除，公开场景片段已同步 |
| Flutter 3.32.0 `flutter test --no-pub test/notice_bar_page_golden_test.dart test/notice_bar_page_test.dart` | PASS，4 tests；light/dark Golden 与功能测试分流 |
| CNB 同款 `docker/flutter-3.32.0` Linux 镜像更新并复跑 `notice_bar_page_golden_test.dart` | PASS，2 + 2 tests；light/dark 基线由 Linux 生成 |
| 回归调度器工具测试 | PASS，10 tests；NoticeBar 组件、覆盖率、Demo 功能和视觉回归登记同步 |
| Flutter 3.47.0 组件与 Demo 非视觉测试 | PASS，42 + 2 tests；Golden 未在 latest 执行 |

## 验收项核对

- [x] 水平滚动距离使用可视区宽度，不再依赖屏宽（代码 `_scroll()` 已确认）。
- [x] 冗余 getter 已移除。
- [x] `flutter analyze` 对改动文件无 error/warning。
- [x] 新增滚动距离回归测试与 variant 色值测试（静态校验通过）。
- [x] 双版本聚焦组件与 Example 测试通过。
- [x] 双版本严格 analyze 通过。
- [x] 生产源码覆盖率高于 95%。
- [x] 公开页面已按官方 3 个分组、8 个 Demo 块和 14 个实例重组，内部测试模块不再展示。
- [x] 入口、状态、滚动、自定义内容和自定义样式的文案、图标及组合均已逐项核对。
- [x] 375dp 小程序与 Flutter light/dark 页面截图已人工对照，证据见 [visual-comparison.md](visual-comparison.md)。

## 未覆盖项

- 水平滚动的真实帧级平滑度（依赖运行态视觉验证）。
- 真实设备上的垂直触摸、循环与 change 回调仍属于待确认/待实现契约。
- interval 默认值、operation 点击目标、默认前缀图标和 right padding 等公开行为仍需维护者决策。
- 静态截图已完成；逐帧叠图与真实设备触摸循环仍未验证。

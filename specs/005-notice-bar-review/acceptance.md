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

## 验收项核对

- [x] 水平滚动距离使用可视区宽度，不再依赖屏宽（代码 `_scroll()` 已确认）。
- [x] 冗余 getter 已移除。
- [x] `flutter analyze` 对改动文件无 error/warning。
- [x] 新增滚动距离回归测试与 variant 色值测试（静态校验通过）。
- [x] 双版本聚焦组件与 Example 测试通过。
- [x] 双版本严格 analyze 通过。
- [x] 生产源码覆盖率高于 95%。
- [x] 官方垂直滚动与自定义内容场景已公开，卡片 Demo 已删除。

## 未覆盖项

- 水平滚动的真实帧级平滑度（依赖运行态视觉验证）。
- 真实设备上的垂直触摸、循环与 change 回调仍属于待确认/待实现契约。
- interval 默认值、operation 点击目标、默认前缀图标和 right padding 等公开行为仍需维护者决策。
- MiniProgram 与 Flutter 的统一视口截图叠图尚未完成。

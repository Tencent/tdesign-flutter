# TNoticeBar Review 修复 - 验收记录

## 执行的命令与结果

| 命令 | 结果 |
| --- | --- |
| `flutter analyze lib/src/components/notice_bar/t_notice_bar.dart` | No issues found |
| `flutter analyze test/components/notice_bar/t_notice_bar_test.dart` | No issues found |
| Flutter 3.32.0 `flutter test --no-pub test/components/notice_bar/t_notice_bar_test.dart --coverage` | PASS，45 tests；NoticeBar `LH=253` / `LF=263` = 96.20% |
| Flutter 3.32.0 `flutter test --no-pub test/notice_bar_page_test.dart` | PASS，2 tests |
| Flutter 3.32.0 `flutter analyze --fatal-infos --no-pub` | PASS，0 issues |
| Flutter 3.47.0 `flutter test --no-pub test/components/notice_bar/t_notice_bar_test.dart` | PASS，45 tests |
| Flutter 3.47.0 `flutter test --no-pub test/notice_bar_page_test.dart` | PASS，2 tests |
| Flutter 3.47.0 `dart analyze --fatal-infos` | PASS，0 issues |
| `dart run tool/generate_example_code.dart` | PASS，卡片片段已删除，公开场景片段已同步 |
| Flutter 3.32.0 `flutter test --no-pub test/notice_bar_page_golden_test.dart` | macOS 仅用于辅助确认尺寸，未写回 Linux 基线 |
| CNB 同款 `docker/flutter-3.32.0` Linux 镜像更新并复跑 `notice_bar_page_golden_test.dart` | PASS；检查实际图后生成 375×1581 light/dark 基线，并在不带 `--update-goldens` 时复跑 2 tests 通过 |
| 首帧布局约束修复后以同款 Linux 镜像无更新参数复跑 Golden | PASS，2 tests；现有 light/dark 基线无需变化 |
| 回归调度器工具测试 | PASS，11 tests；NoticeBar 组件、覆盖率、Demo 功能和视觉回归登记同步，GitHub/CNB Example 清单一致 |
| Flutter 3.47.0 组件与 Demo 非视觉测试 | PASS，45 + 2 tests；Golden 未在 latest 执行 |
| GitHub / CNB 双版本 Example 功能回归入口核对 | PASS；均包含 `test/notice_bar_page_test.dart` |

## 验收项核对

- [x] 水平滚动距离使用可视区宽度，不再依赖屏宽（代码 `_scroll()` 已确认）。
- [x] 冗余 getter 已移除。
- [x] `flutter analyze` 对改动文件无 error/warning。
- [x] 新增滚动距离回归测试与 status 色值测试（静态校验通过）。
- [x] 双版本聚焦组件与 Example 测试通过。
- [x] 双版本严格 analyze 通过。
- [x] 生产源码覆盖率为 96.20%（`LH=253` / `LF=263`），高于 95%。
- [x] 公开页面已按官方 3 个分组、8 个 Demo 块和 14 个实例重组，内部测试模块不再展示。
- [x] 入口、状态、滚动、自定义内容和自定义样式的文案、图标及组合均已逐项核对。
- [x] 收敛后 375dp Flutter light/dark Linux Golden 已更新并复验；自定义 Icon 使用 22px 标准尺寸并继承状态色。
- [x] 首帧跑马灯空白段使用 `LayoutBuilder` 的真实内容区约束，不再回退屏幕宽度。
- [x] NoticeBar 自定义功能测试唯一持有分组、顺序、数量和参数断言，Golden Spec 不再保存未消费的重复结构配置。

## 未覆盖项

- 水平滚动的真实帧级平滑度（依赖运行态视觉验证）。
- 真实设备上的垂直触摸、循环与 change 回调仍属于待确认/待实现契约。
- operation 自定义子组件同时处理自身点击与 NoticeBar 统一点击目标时的手势竞争仍需真机验证。
- 逐帧叠图与真实设备触摸循环仍未验证。

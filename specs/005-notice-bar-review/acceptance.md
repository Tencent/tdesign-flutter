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

## 2026-09-15 Issue #1027 像素复核

- [x] Figma 页面 `24386:5282` 与反馈逐项核对，带图标和垂直滚动场景均要求图标与正文相隔 8px。
- [x] 判定为组件问题：内置前缀已有 8px，但自定义 `prefix` 未消费同一布局契约；现统一由 `TNoticeBar` 负责。
- [x] 自定义样式 Demo 删除手工 `Padding(right: 8)`，修复后没有双重间距。
- [x] `SizedBox.shrink()` 隐藏前缀时正文仍从 16px 内容边距起始，不残留空白。
- [x] 自定义 `spacer8` Token 会实际改变 prefix 与正文间距，默认 Token 下仍为 8px。
- [x] Theme 动态过渡在默认高度 22 与自定义高度间双向平滑插值，不产生 0 尺寸或透明中间态。
- [x] 明亮整页代表 Golden 变化 3,109px（0.52%）；差异只位于两个缺失间距的目标实例。
- [x] Flutter 3.32.0 Linux 明暗 Golden 更新后无参数复跑 2/2 通过。
- [x] Flutter 3.32.0：组件及回归工具 59/59、Demo 2/2，严格 analyze 0 问题；生产源码覆盖率 259/269 = 96.28%。
- [x] Flutter 3.47.0：组件 46/46、Demo 2/2，严格 analyze 0 问题。

## 2026-09-17 Token 与 Theme 插值补充验证

- [x] Flutter 3.32.0：NoticeBar 组件测试 50/50，Demo 功能测试 4/4。
- [x] Flutter 3.47.0：NoticeBar 组件测试 50/50，Demo 功能测试 4/4。
- [x] 改动源码与测试定向 analyze 为 0 issues。
- [x] NoticeBar 生产源码覆盖率 273/285 = 95.79%。
- [x] API 文档生成脚本通过，`prefix` 的 `spacer8` 契约与 `lerpDouble` 缺省语义已同步。
- [x] 自定义 `spacer8=13` 的组件几何断言通过，默认值仍为 8；本次不更新 Golden 基线。
- [x] 本机 macOS 对 Linux Golden 的无更新复跑保持平台字体差异（7.76%–8.13%），未把本机结果写回基线；Linux 结果继续由固定镜像和远端视觉回归门禁确认。

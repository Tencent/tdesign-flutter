# 验收记录

- 2026-09-02 禁用态辅助文字颜色回归：Flutter 3.32.0 与 3.47.0 的 `flutter test --no-pub --exclude-tags golden test/components/rate/t_rate_test.dart` 均为 36 项通过，分别直接断言默认 `textDisabledColor` Token 与显式 `ColorScheme.onSurface` 的 38% 透明度；3.32.0 覆盖率门禁为 361/367，98.37%；两个 SDK 的 `flutter analyze` 均零问题。
- 2026-09-01 垂直对齐修复前根因测试：默认 `fontBodyLarge` 目标行盒为 24px，Rate 辅助文字实际为 23px，且 `TextStyle.height == null`；同一测试在修复后测得 24px，并确认文字与首个 24px 星标中心差小于 0.01px。
- `flutter test test/components/rate/t_rate_test.dart test/components/text/t_text_test.dart test/components/text/t_text_resolve_test.dart`：56 项通过；Rate 辅助文字改用 `TText`，完整合并 `fontBodyLarge` 与 Theme 局部覆盖，并覆盖外层 `DefaultTextStyle`、窄容器位置和 1.0/1.5/2.0 文本缩放。
- `flutter test test/components/rate/t_rate_test.dart --coverage` 与 `dart run tool/check_component_coverage.dart rate`：34 项通过，生产源码 360/367，98.09%。
- `flutter test test/rate_demo_test.dart`（`tdesign-component/example`）：2 项公开 Demo 结构与实例契约通过。
- Flutter 3.32.0 `flutter analyze` 与 Flutter 3.47.0 `flutter analyze --no-pub`：组件包均零告警；两个 SDK 的 Rate 34 项测试均通过。Flutter 3.47.0 Chrome 的 1.0/1.5/2.0 文本缩放居中测试通过。回归矩阵三组工具测试 11 项通过；`dart run tool/generate_example_code.dart --check` 通过。
- 本地 macOS Flutter 3.32.0 对仓库 Flutter 3.32.0 Linux Rate Golden 的 light/dark 整页差异分别为 4.68% / 4.70%，差异覆盖整页平台字体与布局，不能归因于本次局部修复，未更新正式基线；仍需由 Linux 视觉回归生成并复跑预期 Golden。
- `flutter test test/components/rate/t_rate_test.dart`：31 项通过，包含默认评分提示及关闭路径、长按显示与移动/松手生命周期、提示固定锚定评分项、半星选择浮层、整星/半星拖动清零、慢速拖拽单生命周期、指针取消、半星文案语义值与有界/无界文案布局。
- `flutter test test/components/rate/t_rate_test.dart --coverage`：通过。
- `dart run tool/check_component_coverage.dart rate`：358/365，98.08%。
- 回归矩阵三组工具测试：10 项通过。
- `flutter analyze`（Flutter 3.32.0）：零告警。
- `flutter analyze`（Flutter 3.47.0）：零告警。
- `dart run tool/generate_example_code.dart --check`：通过。
- Flutter 3.32.0 Linux `rate_demo_golden_test.dart`：补齐第三方图标与三项独立栏的带描述评分后更新 375×1781 light/dark Golden，并无更新参数复跑通过；Golden 已加载 Cupertino 图标字体，无缺字方框。
- `rate_demo_test.dart`：完整公开文案、14 个实例顺序和关键参数、第三方心形图标、`3分 / 一般 / 未评分` 三项带描述状态以及拖动到未评分交互通过，并登记 CNB 与 GitHub 的 Flutter 3.32.0/latest 共享回归。
- `node scripts/check-flutter-component-contracts.mjs`：56 个官网组件路由与源码、Demo、API 文档契约通过；Rate 官网文档已移除旧版无效 API 并补充 breaking migration。
- 截图复核：Demo 行高 48px、水平内边距 16px、标题宽度 100px，对应小程序 96/32/200rpx；带描述评分的三个可交互实例保持在同一分组，辅助文案自适应宽度。

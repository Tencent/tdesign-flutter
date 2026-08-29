# 验收记录

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

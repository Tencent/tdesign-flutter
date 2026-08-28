# 验收记录

- `flutter test test/components/rate/t_rate_test.dart test/components/theme/t_resource_delegate_test.dart`：23 项通过。
- `flutter test test/components/rate/t_rate_test.dart --coverage`：通过。
- `dart run tool/check_component_coverage.dart rate`：267/269，99.26%。
- 回归矩阵三组工具测试：10 项通过。
- `flutter analyze`（Flutter 3.32.0）：零告警。
- `flutter analyze`（Flutter 3.47.0）：零告警。
- `dart run tool/generate_example_code.dart --check`：通过。
- Flutter 3.32.0 Linux `rate_demo_golden_test.dart`：light/dark Golden 无更新复跑通过。
- `rate_demo_test.dart`：完整公开文案、13 个实例顺序和关键参数、基础交互通过，并登记 Flutter 3.32.0/latest 共享回归。
- 截图复核：Demo 行高 48px、水平内边距 16px、标题宽度 100px，对应小程序 96/32/200rpx；辅助文案自适应宽度，“未评分”完整显示。

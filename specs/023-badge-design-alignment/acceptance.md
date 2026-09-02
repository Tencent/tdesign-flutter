# 验收记录

## 验证环境

- 分支：`rss1102/breaking/badge-design-alignment`
- 提交：见当前 PR 提交记录
- Flutter/Dart：Flutter 3.32.0；Flutter 3.47.0 / Dart 3.13.0
- 设计基准：Figma `TDesign for mobile` branch `4SdclZkcv5bPgX6pa8AsmI`，node `28591:41540`
- 真机：Android 16（API 36），Flutter Impeller/Vulkan

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter analyze --no-pub`（component，3.32.0） | 通过 | 0 issues |
| `flutter analyze --no-pub`（example，3.32.0） | 通过 | 0 issues |
| `flutter test --no-pub test/components/badge/t_badge_test.dart`（3.32.0） | 通过 | 33 tests |
| `flutter test --no-pub test/components/badge/t_badge_golden_test.dart`（3.32.0） | 通过 | light/dark 2 tests，未更新基准 |
| `flutter test --no-pub test/badge_page_test.dart`（example，3.32.0） | 通过 | 2 tests |
| `flutter test --coverage test/components/badge/t_badge_test.dart` + coverage gate | 通过 | production LH/LF 177/177 = 100% |
| `dart run tool/generate_example_code.dart --check` | 通过 | 示例代码无漂移 |
| Badge API 文档生成（3.32.0） | 通过 | TBadge、TBadgeThemeData、TBadgeVariant、TBadgeSize 均完整输出 |
| `flutter analyze --no-pub`（component + example，3.47.0） | 通过 | 0 issues |
| Badge component + Demo tests（3.47.0） | 通过 | 33 + 2 tests |

## 人工验收

- [x] Type、Style、Size 全部分组、文案和顺序与 Figma 一致
- [x] Dot/Number 中心锚点、Customize `Offset(-16, 0)` 与 Medium Button 一致
- [x] `normal` 单字符圆形、Square、Bubble、左右 Ribbon、左右 Triangle 在 Android 真机可辨识且无裁切
- [x] Large/Medium 使用 20/16px 行盒，真机文字垂直位置正常
- [x] debug 真机不展示内部 `test` 模块，公开页面仅保留三组设计示例

## 未覆盖项与后续工作

- Golden 固定在 Flutter 3.32.0；latest 只验证行为与 analyze，避免把 SDK 字体栅格差异误判为视觉变更。
- 未在 iOS 真机逐像素截图；跨平台风险由逻辑像素、Theme/Token、RTL、三档字体缩放与双 SDK 测试约束。

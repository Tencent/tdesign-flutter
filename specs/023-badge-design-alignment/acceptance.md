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
| `flutter test --no-pub test/components/badge/t_badge_test.dart`（3.32.0） | 通过 | 35 tests |
| `flutter test --no-pub test/components/badge/t_badge_golden_test.dart`（3.32.0） | 通过 | light/dark 2 tests，未更新基准 |
| `flutter test --no-pub test/badge_page_test.dart`（example，3.32.0） | 通过 | 2 tests |
| `flutter test --coverage test/components/badge/t_badge_test.dart` + coverage gate | 通过 | production LH/LF 177/177 = 100% |
| `dart run tool/generate_example_code.dart --check` | 通过 | 示例代码无漂移 |
| Badge API 文档生成（3.32.0） | 通过 | TBadge、TBadgeThemeData、TBadgeVariant、TBadgeSize 均完整输出 |
| `flutter analyze --no-pub`（component + example，3.47.0） | 通过 | 0 issues |
| Badge component + Demo tests（3.47.0） | 通过 | 35 + 2 tests |

## 人工验收

- [x] Type、Style、Size 全部分组、文案和顺序与 Figma 一致
- [x] Dot/Number 中心锚点、Customize `Offset(-16, 0)` 与 Medium Button 一致
- [x] `normal` 单字符圆形、Square、Bubble、左右 Ribbon、左右 Triangle 在 Android 真机可辨识且无裁切
- [x] Large/Medium 使用 20/16px 行盒，真机文字垂直位置正常
- [x] debug 真机不展示内部 `test` 模块，公开页面仅保留三组设计示例

## 未覆盖项与后续工作

- Golden 固定在 Flutter 3.32.0；latest 只验证行为与 analyze，避免把 SDK 字体栅格差异误判为视觉变更。
- 未在 iOS 真机逐像素截图；跨平台风险由逻辑像素、Theme/Token、RTL、三档字体缩放与双 SDK 测试约束。

## 2026-09-11 右上角位置复验

- Figma 与 Android 真机对比确认普通右上角文字徽标位置偏低；实现校正 Material 的方向性水平位置，并抵消框架额外追加的 8px 纵向兼容补偿，使最终中心点向上 4 逻辑像素并与内容右上角对齐。
- 显式实例 `offset`、局部及全局 `BadgeTheme.offset` 的覆盖优先级保持不变；Ribbon/Triangle 等角标形态仍使用零偏移贴合内容边角。
- Flutter 3.32.0 下 Badge 聚焦测试 40/40 通过，受影响源码及测试严格 analyze 为 0 issues。
- 修复版 debug APK 已重新构建并安装到 Android 16 真机，Dot、Number、Circle、Square 的右上角位置已向上移动 4 逻辑像素；自定义徽标改用设计稿的 48px 方形按钮，并校正为徽标中线与按钮顶边对齐。
- 自定义徽标几何回归按 Figma 节点 `27741:30841` 验证：公开 Demo 使用 `TBadgeVariant.custom` 且不传 `offset`；按钮为 48×48，徽标容器左边位于按钮右边 -16px，徽标中线与按钮顶边同 Y；520dpi 真机中分别对应 156×156、52px 与 0px 纵向差。
- `offset` API 保留，组件测试同时覆盖实例值覆盖自定义形态默认位置。

## 2026-09-03 Dot 默认尺寸复验

- 默认 Dot 直径由 6 调整为官方移动端规范的 8 逻辑像素；局部或显式全局
  `BadgeThemeData.smallSize` 的覆盖顺序不变。
- 独立 Dot、带 child Dot 和带描边 Dot 的 Widget 测试均锁定 8px。
- Flutter 3.32.0 与 3.47.0 的 Badge 聚焦测试及严格 analyze 通过；
  生产源码覆盖率 `171/172 = 99.42%`。
- `TBadge` 使用内部 8px Dot 默认值；`TThemeBuilder.badgeTheme.smallSize`
  保持为空，原生 Material Badge 自然回退 6px，主题基建测试锁定两者作用域隔离。
- CI 同款 Flutter 3.32.0 Linux 中已更新 light/dark 2 张 Badge Golden，
  并在同一容器无更新参数复跑 2/2 通过。
- Flutter 3.32.0 Linux 与 3.47.0 的 Badge 集中式回归测试均 36 项通过，
  生产源码覆盖率均为 `171/172 = 99.42%`，组件包严格 analyze 均为
  0 issues；Flutter 3.32.0 Linux Badge Golden 2/2 通过。
- `TThemeBuilder` 与原生 Material Badge 的作用域隔离断言已迁入集中式 CI
  登记的 `t_badge_test.dart`，避免只在未调度的聚合 Theme 测试中生效。

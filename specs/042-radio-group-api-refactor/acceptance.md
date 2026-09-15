# 验收记录

## 验证环境

- 分支：`rss1102/breaking/radio-api-refactor`
- 基线：`origin/develop@ec3ae579632874af767f81baade3844e457960bf`
- 提交：本 PR 当前 HEAD
- Flutter/Dart：Flutter 3.32.0（仓库基线）与 Flutter 3.47.0 / Dart 3.13.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test --no-pub test/components/radio/t_radio_test.dart test/components/radio/t_radio_theme_contract_test.dart` | 通过 | 40 项 Radio 行为与主题测试，含 #1109 四项视觉契约 |
| `flutter test --no-pub --coverage test/components/radio/t_radio_test.dart test/components/radio/t_radio_theme_contract_test.dart && dart run tool/check_component_coverage.dart radio` | 通过 | Radio 生产代码行覆盖率 289/297，97.31% |
| `flutter test --no-pub test/components/form/t_form_test.dart` | 通过 | 49 项，确认 Form 机械迁移未破坏既有行为 |
| `flutter test --no-pub test/radio_page_test.dart`（example） | 通过 | 6 项 Demo 行为与结构测试；横向容器通栏、四周 16dp、余量均分、状态文案及两类卡片四周 16dp 均有断言 |
| `flutter test --update-goldens test/radio_page_golden_test.dart && flutter test --no-pub test/radio_page_golden_test.dart`（Linux） | 通过 | Flutter 3.32.0 明暗 Golden 更新一次后立即无更新参数复跑 2/2；本次基准包含横向容器通栏、`space-between` 分布及可区分的禁用状态文案 |
| `dart run tool/generate_example_code.dart --check` | 通过 | 示例代码产物一致 |
| `node tool/generate_api.mjs --dry-run` | 通过 | Radio API 元数据可生成 |
| `flutter analyze --fatal-infos` | 通过 | Flutter 3.32.0，0 error / 0 warning |
| `/Users/rs/fvm/versions/3.47.0/bin/flutter test --no-pub test/components/radio/t_radio_test.dart test/components/radio/t_radio_theme_contract_test.dart` | 通过 | Flutter 3.47.0，40 项 |
| `/Users/rs/fvm/versions/3.47.0/bin/flutter test --no-pub test/radio_page_test.dart`（example） | 通过 | Flutter 3.47.0，6 项 |
| `/Users/rs/fvm/versions/3.47.0/bin/flutter analyze --fatal-infos` | 通过 | Flutter 3.47.0，0 error / 0 warning |
| `flutter test --no-pub test/tool/check_component_coverage_test.dart test/tool/run_component_regression_test.dart test/tool/run_visual_regression_test.dart` | 通过 | 13 项 CI 清单/脚本测试 |

## 人工验收

- [x] Radio Demo 的 inline/block/card 用法与交互符合 Spec；横向容器通栏并按 `space-between` 两端对齐，卡片文字四周保留 16dp 安全间距
- [x] Radio Demo Golden 检查无裁切、溢出、重复绘制或选中角标遮字
- [x] Android 实体机（1220×2656）从当前源码重新构建；横向首/末项 bounds 从 `x=85/1135` 修正为 `x=52/1168`（各 16dp），状态文案显示“单选-已选/单选-未选”且语义分别为 checked/unchecked + disabled
- [ ] 真机/模拟器触控体验留待 Form 接入 inline 时联合验收

## 未覆盖项与后续工作

- Form #1105 的布局与截图在本重构合并后单独处理。
- `t_m3_isolation_golden_test.dart` 只做 breaking API 编译迁移；该聚合 Golden 在
  develop 基线已包含 Checkbox、Progress 等无关陈旧差异，且不在 Radio 视觉回归
  清单中，因此本 PR 不更新其基准图。

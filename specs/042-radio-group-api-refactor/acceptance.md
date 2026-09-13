# 验收记录

## 验证环境

- 分支：`rss1102/breaking/radio-api-refactor`
- 基线：`origin/develop@ec3ae579632874af767f81baade3844e457960bf`
- 提交：待完成
- Flutter/Dart：Flutter 3.32.0（仓库基线）与 Flutter 3.47.0 / Dart 3.13.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test --no-pub test/components/radio/t_radio_test.dart test/components/radio/t_radio_theme_contract_test.dart` | 通过 | 37 项 Radio 行为与主题测试 |
| `flutter test --no-pub --coverage test/components/radio/t_radio_test.dart test/components/radio/t_radio_theme_contract_test.dart && dart run tool/check_component_coverage.dart radio` | 通过 | Radio 生产代码行覆盖率 275/282，97.52% |
| `flutter test --no-pub test/components/form/t_form_test.dart` | 通过 | 49 项，确认 Form 机械迁移未破坏既有行为 |
| `flutter test --no-pub test/radio_page_test.dart`（example） | 通过 | 4 项 Demo 行为与结构测试 |
| `flutter test --no-pub --update-goldens test/radio_page_golden_test.dart` 后无更新参数复跑 | 通过 | 明暗两张 Radio Demo Golden；横向示例切换 inline 后高度减少 32px，无裁切或溢出 |
| `dart run tool/generate_example_code.dart --check` | 通过 | 示例代码产物一致 |
| `node tool/generate_api.mjs --dry-run` | 通过 | Radio API 元数据可生成 |
| `flutter analyze --fatal-infos` | 通过 | Flutter 3.32.0，0 error / 0 warning |
| `/Users/rs/fvm/versions/3.47.0/bin/flutter test --no-pub test/components/radio/t_radio_test.dart test/components/radio/t_radio_theme_contract_test.dart` | 通过 | Flutter 3.47.0，37 项 |
| `/Users/rs/fvm/versions/3.47.0/bin/flutter analyze --fatal-infos` | 通过 | Flutter 3.47.0，0 error / 0 warning |
| `flutter test --no-pub test/tool/check_component_coverage_test.dart test/tool/run_component_regression_test.dart test/tool/run_visual_regression_test.dart` | 通过 | 13 项 CI 清单/脚本测试 |

## 人工验收

- [x] Radio Demo 的 inline/block/card 用法与交互符合 Spec
- [x] Radio Demo Golden 检查无裁切、溢出或重复绘制区域
- [ ] 真机/模拟器触控体验留待 Form 接入 inline 时联合验收

## 未覆盖项与后续工作

- Form #1105 的布局与截图在本重构合并后单独处理。
- `t_m3_isolation_golden_test.dart` 只做 breaking API 编译迁移；该聚合 Golden 在
  develop 基线已包含 Checkbox、Progress 等无关陈旧差异，且不在 Radio 视觉回归
  清单中，因此本 PR 不更新其基准图。

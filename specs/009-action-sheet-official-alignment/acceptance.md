# 验收记录

## 验证环境

- 分支：基于 `origin/develop` 的本地审查工作树
- 提交：待提交
- Flutter/Dart：Flutter 3.32.0 / Dart 3.8.0；Flutter 3.47.0 / Dart 3.13.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test test/components/action_sheet` | PASS，41 tests | Flutter 3.32.0，样式修正后 |
| `flutter analyze --fatal-infos --no-pub` | PASS | Flutter 3.32.0，新 Demo 矩阵后 |
| `dart run tool/generate_example_code.dart` | PASS | 生成 9 个 ActionSheet 片段并移除 3 个旧片段 |
| `flutter test test/components/action_sheet --coverage` | PASS，98.20% | ActionSheet 生产源码 `LH=437` / `LF=445` |
| `flutter test --no-pub test/action_sheet_page_test.dart` | PASS，2 tests | Flutter 3.32.0；9 场景入口与宫格交互 |
| `flutter test --no-pub ... --plain-name <matrix/interaction>` | PASS，2 tests | Flutter 3.47.0；golden 固定由最低支持版本 3.32.0 生成，latest 的图标抗锯齿存在 1.22% 差异 |
| `flutter test --no-pub test/components/action_sheet` | PASS，41 tests | Flutter 3.47.0 |
| `flutter analyze --fatal-infos --no-pub` | PASS | Flutter 3.47.0，0 issues |
| `flutter test --no-pub test/tool/check_component_coverage_test.dart test/tool/run_component_regression_test.dart test/tool/run_visual_regression_test.dart` | PASS，10 tests | 回归清单、覆盖率目标和视觉测试登记同步 |
| `flutter test --no-pub test/action_sheet_page_golden_test.dart test/action_sheet_page_test.dart` | PASS，4 tests | Flutter 3.32.0；功能测试与 light/dark Golden 分流后复验 |
| CNB 同款 `docker/flutter-3.32.0` Linux 镜像更新并复跑 `action_sheet_page_golden_test.dart` | PASS，2 + 2 tests | light/dark 基线由 Linux 生成；恢复共享字体后既有 `checkbox_page_test.dart` 3 tests 同时通过 |
| 集中式 CI 登记 | PASS | 组件测试、98.20% 覆盖率、双版本 Demo 功能测试与 3.32.0 Golden 均已登记 |

## 人工验收

- [ ] 9 个入口在 Example 应用中可打开、选择、取消和翻页。
- [x] 使用 375dp 视口完成小程序与 Flutter 页面、列表弹层截图对照，证据见 [visual-comparison.md](visual-comparison.md)。

## 未覆盖项与后续工作

- 翻页、禁用项和全部入口的真机连续交互仍需人工复核；静态截图不能替代交互验收。

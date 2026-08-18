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
| `flutter test --no-pub test/action_sheet_page_test.dart` | PASS，3 tests | Flutter 3.32.0；9 场景入口、宫格交互与 golden |
| `flutter test --no-pub ... --plain-name <matrix/interaction>` | PASS，2 tests | Flutter 3.47.0；golden 固定由最低支持版本 3.32.0 生成，latest 的图标抗锯齿存在 1.22% 差异 |
| `flutter test --no-pub test/components/action_sheet` | PASS，41 tests | Flutter 3.47.0 |
| `flutter analyze --fatal-infos --no-pub` | PASS | Flutter 3.47.0，0 issues |

## 人工验收

- [ ] 9 个入口在 Example 应用中可打开、选择、取消和翻页。
- [ ] 与官方小程序基线完成同尺寸截图叠加对照。

## 未覆盖项与后续工作

- 真实运行时像素证据待补充。

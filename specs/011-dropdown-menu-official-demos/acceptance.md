# 验收记录

## 验证环境

- 分支：基于 `origin/develop` 的本地审查工作树
- 提交：待提交
- Flutter/Dart：Flutter 3.32.0 / Dart 3.8.0；Flutter 3.47.0 / Dart latest

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test --no-pub test/components/dropdown_menu --coverage` | PASS，59 tests | `LH=910` / `LF=926` = 98.27% |
| `flutter test --no-pub test/dropdown_menu_page_test.dart` | PASS，4 tests | Flutter 3.32.0 |
| `flutter analyze --fatal-infos --no-pub` | PASS | Flutter 3.32.0，0 issues |
| `flutter test --no-pub test/dropdown_menu_page_test.dart` | PASS，4 tests | Flutter 3.47.0 |
| `dart analyze --fatal-infos` | PASS | Flutter 3.47.0 SDK，0 issues |
| `dart run tool/generate_example_code.dart` | PASS | 新增 direction/disabled 片段并同步更新现有片段 |

## 人工验收

- [ ] 官方 Demo 和 Flutter 额外能力分组在运行时清晰可用。
- [ ] 向上展开面板、图标切换和遮罩与官方完成截图对照。

## 未覆盖项与后续工作

- 勾选默认位置、空选按钮行为和全局 280px 上限等公开契约尚未获得维护者确认。
- Flutter 3.47.0 的既有组件用例 `auto placement can return during the same active drag` 稳定出现 0.93px 几何差异（原容差 0.5px）；本次未修改组件源码或该用例，Example 聚焦测试已通过。
- 真实运行时像素证据待补充。

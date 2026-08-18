# 验收记录

## 验证环境

- 分支：基于 `origin/develop` 的本地审查工作树
- 提交：待提交
- Flutter/Dart：Flutter 3.32.0 / Dart 3.8.0；Flutter 3.47.0 / Dart 3.13.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test --no-pub test/components/dialog/t_dialog_test.dart --coverage` | PASS，14 tests | Dialog 生产源码 `LH=172` / `LF=174` = 98.85% |
| `flutter test --no-pub test/dialog_page_test.dart` | PASS，3 tests | Flutter 3.32.0 Example 矩阵与交互 |
| `flutter analyze --fatal-infos --no-pub` | PASS | Flutter 3.32.0，0 issues |
| `dart run tool/generate_example_code.dart` | PASS | 生成 6 个新 Dialog 分组片段，移除 7 个旧片段 |
| `flutter test --no-pub test/components/dialog/t_dialog_test.dart` | PASS，14 tests | Flutter 3.47.0 |
| `flutter test --no-pub test/dialog_page_test.dart` | PASS，3 tests | Flutter 3.47.0；清理跨 SDK shader 缓存后 |
| `flutter analyze --fatal-infos --no-pub` | PASS | Flutter 3.47.0，0 issues |

## 人工验收

- [ ] 21 个入口在 Example 运行时可打开、关闭、输入和返回结果。
- [ ] 与官方小程序完成同尺寸像素对照。

## 未覆盖项与后续工作

- 真实运行时像素证据待补充。

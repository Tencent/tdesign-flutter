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
| Flutter 3.32.0 `flutter test --no-pub test/dialog_page_golden_test.dart test/dialog_page_test.dart` | PASS，5 tests | 功能测试与 light/dark Golden 分流 |
| 回归调度器工具测试 | PASS，10 tests | Dialog 组件、覆盖率、Demo 功能和视觉回归登记同步 |
| Flutter 3.47.0 组件与 Demo 非视觉测试 | PASS，14 + 3 tests | Golden 未在 latest 执行 |

## 人工验收

- [ ] 21 个入口在 Example 运行时可打开、关闭、输入和返回结果。
- [x] 使用 375dp 视口完成小程序与 Flutter 页面、关键打开态截图对照，证据见 [visual-comparison.md](visual-comparison.md)。

## 未覆盖项与后续工作

- 图片、输入等全部场景的连续交互仍需真机逐项复核；静态截图不证明输入与返回值行为。

# 验收记录

## 验证环境

- 分支：基于 `origin/develop` 的本地审查工作树
- 提交：待提交
- Flutter/Dart：Flutter 3.32.0 / Dart 3.8.0；Flutter 3.47.0 / Dart 3.13.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test --no-pub test/components/dialog/t_dialog_test.dart --coverage` | PASS，15 tests | 新增默认文本样式继承应用字体的回归保护 |
| `flutter test --no-pub test/dialog_page_test.dart` | PASS，4 tests | Flutter 3.32.0 Example 矩阵与交互 |
| `flutter analyze --fatal-infos --no-pub` | PASS | Flutter 3.32.0，0 issues |
| `dart run tool/generate_example_code.dart` | PASS | 生成 6 个新 Dialog 分组片段，移除 7 个旧片段 |
| `flutter test --no-pub test/components/dialog/t_dialog_test.dart` | PASS，15 tests | Flutter 3.47.0 |
| `flutter test --no-pub test/dialog_page_test.dart` | PASS，4 tests | Flutter 3.47.0；清理跨 SDK shader 缓存后 |
| `flutter analyze --fatal-infos --no-pub` | PASS | Flutter 3.47.0，0 issues |
| Flutter 3.32.0 `flutter test --no-pub test/dialog_page_golden_test.dart test/dialog_page_test.dart` | PASS，5 tests | 功能测试与 light/dark Golden 分流 |
| CNB 同款 `docker/flutter-3.32.0` Linux 镜像更新并复跑 `dialog_page_golden_test.dart` | PASS，2 + 2 tests | light/dark 基线由 Linux 生成 |
| 回归调度器工具测试 | PASS，10 tests | Dialog 组件、覆盖率、Demo 功能和视觉回归登记同步 |
| Flutter 3.47.0 组件与 Demo 非视觉测试 | PASS，15 + 4 tests | Golden 未在 latest 执行 |

## 人工验收

- [ ] 22 个入口在 Example 运行时可打开、关闭、输入和返回结果。
- [x] 使用 375dp 视口完成小程序与 Flutter 页面、关键打开态截图对照，证据见 [visual-comparison.md](visual-comparison.md)。

## 未覆盖项与后续工作

- 图片、输入等全部场景的连续交互仍需真机逐项复核；静态截图不证明输入与返回值行为。

## 2026-08-31 develop 同步复验

- 已合并 `origin/develop@ab04f68b8bcb572111216170d19045dd16d7895b`，冲突按 develop 共享测试基建与本 PR Dialog 默认值改动并集解决。
- CI 同款 Flutter 3.32.0 Linux：页面 light/dark 与点击“带关闭按钮的对话框”后的 Overlay light/dark Golden 共 4 项，更新后不带 `--update-goldens` 复跑通过。
- Flutter 3.32.0 与 3.47.0：15 个组件测试、4 个 Demo 功能测试和 `flutter analyze --fatal-infos --no-pub` 均通过。
- API 收敛复核：未新增公共 API；保留既有 `contentPadding` 定制入口，仅把默认上内边距 32 调为 24、关闭按钮默认偏移从 0 调为 8，属于 PR 标题已声明的 breaking 默认行为变更。

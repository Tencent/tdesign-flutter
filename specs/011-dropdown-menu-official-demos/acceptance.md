# 验收记录

## 验证环境

- 分支：基于 `origin/develop` 的本地审查工作树
- 提交：待提交
- Flutter/Dart：Flutter 3.32.0 / Dart 3.8.0；Flutter 3.47.0 / Dart latest

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test --no-pub test/components/dropdown_menu --coverage` | PASS，59 tests | `LH=911` / `LF=926` = 98.38% |
| `flutter test --no-pub test/dropdown_menu_page_test.dart` | PASS，4 tests | Flutter 3.32.0 |
| `flutter analyze --fatal-infos --no-pub` | PASS | Flutter 3.32.0，0 issues |
| `flutter test --no-pub test/dropdown_menu_page_test.dart` | PASS，4 tests | Flutter 3.47.0 |
| `dart analyze --fatal-infos` | PASS | Flutter 3.47.0 SDK，0 issues |
| `dart run tool/generate_example_code.dart` | PASS | 新增 direction/disabled 片段并同步更新现有片段 |
| Flutter 3.32.0 `flutter test --no-pub test/dropdown_menu_page_golden_test.dart test/dropdown_menu_page_test.dart` | PASS，6 tests | 功能测试与 light/dark Golden 分流 |
| CNB 同款 `docker/flutter-3.32.0` Linux 镜像更新并复跑 `dropdown_menu_page_golden_test.dart` | PASS，2 + 2 tests | light/dark 基线由 Linux 生成 |
| 回归调度器工具测试 | PASS，10 tests | DropdownMenu 组件、覆盖率、Demo 功能和视觉回归登记同步 |
| Flutter 3.47.0 组件与 Demo 非视觉测试 | PASS，59 + 4 tests | 主动拖动时的跨引擎坐标舍入以 1px 容差验证，展开关系仍严格检查 |

## 人工验收

- [x] 官方 Demo 和 Flutter 额外能力分组已在 375dp 运行截图中复核，证据见 [visual-comparison.md](visual-comparison.md)。
- [x] 单选菜单在点击后完成小程序与 Flutter light/dark 展开态截图对照。

## 未覆盖项与后续工作

- 勾选默认位置、空选按钮行为和全局 280px 上限等公开契约尚未获得维护者确认。
- Flutter 3.47.0 的既有组件用例 `auto placement can return during the same active drag` 存在 0.93px 几何舍入差异；本次仅将该断言容差收敛为 1 个逻辑像素，未修改组件源码，展开关系仍严格检查。
- 向上展开属于 Flutter 额外能力，不作为小程序公开矩阵的一对一视觉场景；其方向和图标切换由 Widget 测试锁定。

## 2026-08-31 develop 同步复验

- 已合并 `origin/develop@fb26b8d5`，并根据固定基线源码纠正原审查误判：官方状态组是两个禁用菜单，不是“一禁用一可用”。
- Demo 已用现有 API 收敛为“全部产品 + 默认排序”、同栏 1/2/3 列多选和两个禁用菜单；Flutter 扩展场景单独分组。
- CI 同款 Flutter 3.32.0 Linux：页面与单选点击展开态 light/dark Golden 共 4 项、4 个功能测试，更新后复跑共 8 tests 通过。
- Flutter 3.32.0 与 3.47.0：59 个组件测试、4 个 Demo 功能测试和 `flutter analyze --fatal-infos --no-pub` 均通过。
- API 收敛复核：生产组件源码相对 develop 无差异，没有新增或调整公共 API。

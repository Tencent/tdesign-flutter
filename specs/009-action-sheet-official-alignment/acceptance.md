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

## 2026-08-31 develop 同步复验

- 已合并 `origin/develop@fb26b8d5`，冲突按 develop 共享测试基建与本 PR ActionSheet 改动并集解决。
- CI 同款 Flutter 3.32.0 Linux：页面 light/dark 与点击“常规列表型”后的 Overlay light/dark Golden 共 4 项，更新后不带 `--update-goldens` 复跑通过。
- Flutter 3.32.0 与 3.47.0：组件聚焦测试、Demo 功能测试和 `flutter analyze --fatal-infos --no-pub` 均通过。
- API 收敛复核：未新增、删除或重命名公共 API；改动仅涉及描述色、高度和分页点颜色。
- 站点 README 已移除旧的文件/分享/图片处理业务示例，改为与当前公开 Demo 一致的描述列表、分页宫格和状态示例；`showGroup` 仍保留在 API 摘要中。
- 完整滚动 Web Demo 后发现并移除页尾内部“单元测试”模块；页面测试已增加公开页不出现该模块的断言。
- CI 同款 Flutter 3.32.0 Linux 已重建 375×1232 明暗整页 Golden，并在不带 `--update-goldens` 时复跑页面与点击后弹层 4/4 通过；截图证据已同步更新。

## 2026-09-01 宫格密度语义复验

- Flutter 3.32.0：ActionSheet 组件测试 47 项通过，生产代码覆盖率 `467/473 = 98.73%`，`flutter analyze --fatal-infos --no-pub` 零问题。
- Flutter 3.32.0：ActionSheet Demo 结构与交互测试 7 项通过，公开 Demo 仍保留 13 个入口；示例代码生成检查通过。
- Android 16 物理手机：多行滚动宫格首屏按 `count=8`、`rows=2` 完整展示前 8 项，排列为 4 列 2 行，并可横向查看剩余数据。
- Flutter 3.32.0 Linux：更新前多行滚动宫格 light/dark Golden 分别产生 7.58% / 7.57% 的预期布局差异；仅更新对应两张快照后，无 `--update-goldens` 复跑 2/2 通过。
- `count=10`、`rows=2` 的 5 列 2 行首屏及后续数据滚动由 Widget 测试覆盖；本轮未改动 Demo 数据以制造该场景。
- Flutter 3.47.0：ActionSheet 组件测试 47 项、Demo 测试 7 项与严格 analyze 均通过；首次 Demo 测试受跨 SDK `ink_sparkle.frag` 缓存污染影响，按约定 clean + pub get 后复跑通过。
- 全部 13 个入口的连续真机交互与最终 Review 仍待完成。

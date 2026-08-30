# 验收记录

## 验证环境

- 分支：`rss1102/breaking/component-color-scheme-ownership`
- 基线：`origin/develop@f4bcfddc`
- Flutter/Dart：Flutter 3.32.0 与本机 latest 3.47.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test test/components/tag/t_tag_test.dart test/components/tag/t_select_tag_test.dart test/components/popover/t_popover_test.dart` | 通过，111 tests | Flutter 3.32.0 |
| `flutter test test/components/theme/t_material_theme_priority_test.dart` | 通过，13 tests | Flutter 3.32.0 |
| `flutter test --exclude-tags golden test/popover_page_test.dart test/tag_page_test.dart` | 通过，6 tests | Flutter 3.32.0，Demo 结构与交互 |
| `flutter test test/tool/check_component_coverage_test.dart test/tool/run_component_regression_test.dart test/tool/run_visual_regression_test.dart` | 通过，10 tests | Flutter 3.32.0，回归矩阵自测 |
| `flutter test test/components/tag/t_tag_test.dart test/components/tag/t_select_tag_test.dart --coverage` + `check_component_coverage.dart tag` | 通过，`178/185 = 96.22%` | Flutter 3.32.0，生产代码行覆盖率 |
| `flutter test test/components/popover/t_popover_test.dart --coverage` + `check_component_coverage.dart popover` | 通过，`498/516 = 96.51%` | Flutter 3.32.0，生产代码行覆盖率 |
| Linux 容器 Tag Demo Golden 生成后复跑 | 通过，light/dark 2 tests | `ghcr.io/cirruslabs/flutter:3.32.0` |
| Linux 容器 Popover Golden 更新后复跑 | 通过，light/dark 2 tests | 既有基线仅统一文字抗锯齿渲染，无布局或配色变化 |
| `dart run tool/generate_example_code.dart --check` | 通过 | 生成片段与 Demo 源码一致 |
| `flutter analyze` | 通过，No issues found | Flutter 3.32.0 |
| `/Users/rs/fvm/versions/3.47.0/bin/flutter clean` | 通过 | 清理由跨 SDK 缓存引起的 `ink_sparkle.frag` 校验失败 |
| `/Users/rs/fvm/versions/3.47.0/bin/flutter test test/components/tag/t_tag_test.dart test/components/tag/t_select_tag_test.dart test/components/popover/t_popover_test.dart test/components/theme/t_material_theme_priority_test.dart` | 通过，124 tests | Flutter 3.47.0，清理缓存后重跑 |
| `/Users/rs/fvm/versions/3.47.0/bin/flutter analyze` | 通过，No issues found | Flutter 3.47.0 |
| `git diff --check` | 通过 | 无空白错误 |

## 人工验收

- [x] 确认实例 `colorScheme` 是唯一配色选择入口
- [x] 确认 Tag 的 `variant` 是实例绘制形态入口，ThemeData 不再保存选择器
- [x] 确认 ThemeData 仍可覆盖具体样式
- [x] 确认 Popover 类型从包入口导出不变
- [x] 确认 Tag Demo 覆盖 5 种配色和 4 种形态，Popover 六种配色均有组件测试

## 未覆盖项与后续工作

- 尚未执行远端 CI 与代码审查；需在提交、推送并创建 PR 后由平台完成。

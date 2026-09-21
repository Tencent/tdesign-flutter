# 验收记录

## 验证环境

- 分支：`rss1102/fix/checkbox-design-details`
- 基线：`origin/develop@bd3574220`
- Flutter/Dart：Flutter 3.32.0（Linux Golden）与 Flutter 3.47.0（latest）

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test --no-pub --exclude-tags demo test/components/checkbox/t_check_box_group_test.dart test/components/checkbox/t_checkbox_test.dart` | 通过 | 48 tests；含默认 Token、组件 Theme 与显式 Material Theme 的禁用未选路径 |
| `dart run tool/check_component_coverage.dart checkbox` | 通过 | 355/368，96.47% |
| `flutter test --no-pub --exclude-tags golden test/checkbox_page_test.dart` | 通过 | 1 test |
| `Flutter 3.32.0 Linux: flutter test --no-pub test/checkbox_page_test.dart` | 通过 | Light/Dark Golden；禁用未选描边为 `#DCDCDC` |
| `Flutter 3.32.0 Linux: dart run tool/run_visual_regression.dart` | 通过 | 风险修复后不更新基线全量复跑通过，未产生新增快照变更 |
| `Flutter 3.32.0 / 3.47.0: flutter analyze --no-pub --fatal-infos` | 通过 | 两版本均 0 issues |
| `flutter build apk --debug` | 通过 | Android Debug APK |
| `Flutter 3.47.0: flutter test --no-pub --exclude-tags demo test/components/checkbox/t_checkbox_test.dart test/components/checkbox/t_check_box_group_test.dart` | 通过 | 48 tests |

## 人工验收

- [x] Android 16 真机复验修复后的完整 Checkbox 页面

## 未覆盖项与后续工作

- Flutter 3.32.0 已完成 Linux Golden 与聚焦组件验证；Flutter 3.47.0 聚焦组件测试与严格 analyze 通过。

## 二次 Review 补充

- 单行标题与指示器按中心线对齐，多行标题继续按首行顶部对齐。
- 方形选中、未选、半选和禁用状态共用组件绘制的 1.5dp 圆角外框；该值不写入全局圆角 token。
- Gy3/Gy4/Gy5/Gy11 已按 Figma 与其他 TDesign 移动端灰阶统一，并由共享主题测试逐项锁定；
  各 Demo 不再使用局部颜色补丁追平设计稿。

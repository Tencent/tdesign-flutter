# 验收记录

## 验证环境

- 基线：`origin/develop` `682c563d`
- 分支：`rss1102/feat/popover-controller-theme-lerp`
- PR：[#1099](https://github.com/Tencent/tdesign-flutter/pull/1099)
- Flutter：3.32.0、3.47.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| Flutter 3.32.0 `flutter test --no-pub --coverage test/components/popover/t_popover_test.dart` | PASS，60 tests | 覆盖两层入口、所有关闭路径、Controller 替换、无 Overlay 防御与 Theme lerp |
| Flutter 3.32.0 `dart run tool/check_component_coverage.dart popover` | PASS | 生产源码 LH/LF = 614/627 = 97.93% |
| Flutter 3.32.0 `flutter analyze --fatal-infos` | PASS | 组件包完整分析，0 error / 0 warning |
| Flutter 3.32.0 Example 功能测试与定向 analyze | PASS，8 tests | 公开自定义内容使用 Controller，三个选项选择后均主动关闭并展示 Toast |
| Flutter 3.47.0 同组件测试与完整 analyze | PASS，60 tests | 清理并重新解析依赖后执行，0 error / 0 warning |
| Flutter 3.47.0 Example 功能测试与定向 analyze | PASS，8 tests | 0 error / 0 warning |
| Flutter 3.32.0 Linux `flutter test --no-pub test/popover_demo_golden_test.dart` | PASS，44 tests | 未使用 `--update-goldens`，既有 light/dark 基线精确比较无变化 |
| 回归清单自测 | PASS，13 tests | coverage/component/example/visual 登记一致 |
| 生成物检查 | PASS | Example 片段 `--check`、API manifest dry-run 通过 |

## 人工验收

- [x] Android 16 真机完成编译、安装与启动
- [x] 公开自定义内容的三个选项点击、Toast 与关闭由 Widget 测试验证
- [x] nullable Theme 插值保留 fallback，双显式值保持连续插值

## 未覆盖项

- 未新增或更新 Golden 基线；本 PR 不改变公开 Demo 的视觉目标。
- 未进行 iOS 真机及 Android 逐项人工交互验收；定位、交互与页面结构由
  Widget、Example、Android 启动和 Linux Golden 分层覆盖。

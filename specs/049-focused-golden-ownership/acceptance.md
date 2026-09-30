# 验收记录

## 验证环境

- 分支：`rss1102/refactor/miniprogram-tokens`
- 基准提交：`5f9dc1b45b05a28e70952798f3de22de3c22638d`
- Golden 环境：Linux amd64，Flutter 3.32.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test test/tool/run_visual_regression_test.dart --no-pub` | 通过，9/9 | Linux Flutter 3.32.0 与 3.47.2；组件 Demo 明暗覆盖与登记无缺口 |
| `dart run tool/run_visual_regression.dart` | 通过 | Linux Flutter 3.32.0，完整清单，无更新参数、精确像素比较 |
| `flutter analyze --fatal-infos` | 通过，0 issue | Linux Flutter 3.32.0 与 3.47.2 |
| `dart format --output=none --set-exit-if-changed tool/component_test_manifest.dart` | 通过 | 按 Dart 格式修正后复核 |
| `git diff --check` | 通过 | 无空白错误 |

## 人工验收

- [x] 用户确认 BackTop Demo 当前视觉差异合理。
- [x] 用户确认导航多组件拼盘不需要。

## 未覆盖项与后续工作

- 远端 CI 尚未运行；本轮未提交或推送。
- 保留 `m3_isolation_controls`（跨 Material 版本的主题隔离契约）与 `popup_progress_layout`（两个组件的真实约束交互），不把它们用于无关组件的验收。

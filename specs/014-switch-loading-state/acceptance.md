# 验收记录

## 验证环境

- 分支：rss1102/style/switch-miniprogram-alignment
- 提交：本 Spec 与 breaking API 实现一并提交
- Flutter/Dart：Flutter 3.32.0 / Dart 3.8.0；latest 待 CNB CI 验证

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `flutter test test/components/switch/t_switch_test.dart --coverage` | 通过 | 15 项；Switch 生产目录 341/358，95.25% |
| `flutter test test/switch_page_test.dart --coverage` | 通过 | 4 项；Demo 49/49，100%；light/dark Golden 非更新模式通过 |
| `flutter analyze`（tdesign-component） | 通过 | 0 issues |
| `flutter analyze`（example） | 通过 | 0 issues |
| `dart run tool/generate_example_code.dart --check --verbose` | 通过 | 所有片段已同步 |
| `node tool/generate_api.mjs` | 通过 | Switch API 文档已同步 |
| `git diff --check` | 通过 | 无空白错误 |

## 人工验收

- [ ] Android 实机确认 Switch 加载状态与分组展示

## 未覆盖项与后续工作

- Flutter latest 依赖 CNB CI 验证；本地未安装第二套 SDK。

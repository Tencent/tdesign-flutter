# 验收记录

## 验证环境

- 分支：`rss1102/refactor/demo-example-web-mapping`
- 基线：`origin/develop@66aa15d17`
- Flutter/Dart：Flutter 3.32.0 / Dart 3.8.0；Flutter 3.47.0 / Dart 3.13.0

## 自动化验证

| 命令 | 结果 | 备注 |
| --- | --- | --- |
| `dart run tool/generate_example_code.dart --check --verbose` | PASS | 413 份片段全部同步 |
| `flutter test test/tool/generate_example_code_test.dart` | PASS | Flutter 3.32，5/5 |
| `flutter analyze --fatal-infos` | PASS | Flutter 3.32，0 issues |
| `flutter test test/table_page_test.dart` | PASS | Flutter 3.32，4/4，覆盖 9 个真实代码面板 |
| `flutter analyze --fatal-infos` | PASS | Flutter 3.47，0 issues |
| `flutter test test/table_page_test.dart` | PASS | Flutter 3.47，清理跨 SDK shader 缓存后 4/4 |
| `pnpm test:example-code` | PASS | Node 映射测试 4/4；全量清单验证 57 份组件文档映射 404 份生成代码，仅排除非组件组 radius/shadows |
| `node scripts/check-flutter-component-contracts.mjs` | PASS | 56 条公开站点路由均具有组件源码、Example 注册和文档 |
| `pnpm site` | PASS | 全量映射测试随生产站点构建执行，108 modules transformed |
| Linux 3.32 `flutter test --no-pub test/table_demo_golden_test.dart` | PASS | `tdesign-flutter-golden-cache:3.32.0`，light/dark 2/2，未更新基线 |
| `git diff --check` | PASS | 无空白错误 |

## 人工验收

- [x] Table 页面公开顺序、坐标、尺寸、交互与 Linux light/dark Golden 未改变
- [x] 57 份组件 Web 文档均只有一个组映射，无手写 Dart `td-code-block`
- [x] Table、Stepper、Form 展开后的 Web 代码与生成资产逐字一致
- [x] 缺失或非法映射会阻止映射测试或站点构建

## 未覆盖项与后续工作

- 其他组件 Dart Demo 的目录拆分不属于本次 Web 单源迁移；页面运行行为未修改。
- macOS 本地 Golden 因平台文字栅格差异出现约 7.3% diff；未更新基线，最终结论采用 CI 同款 Linux 3.32 的 2/2 精确通过结果。

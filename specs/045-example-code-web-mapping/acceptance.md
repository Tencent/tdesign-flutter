# 验收记录

## 验证环境

- 分支：`rss1102/refactor/demo-example-web-mapping`
- 基线：`origin/develop@66aa15d17`
- Flutter/Dart：Flutter 3.32.0 / Dart 3.8.0；Flutter 3.47.0 / Dart 3.13.0

## 自动化验证

> 下表是旧结构阶段的历史记录。用户追加“每个公开 ExampleItem 独立文件且代码完整可复制”的验收条件后，以下结果不能作为最终验收；新结构完成后须在最新 head 重新执行并替换。

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
| `dart run tool/check_demo_structure.dart` | PASS | 60 个入口、141 个语义模块，Calendar 与 Sidebar 等辅助 example 已归位 |
| `dart run tool/generate_example_code.dart --check --verbose` | PASS | 413 份片段全部同步；目录迁移后 26 份格式化产物已重新生成 |
| `flutter analyze --fatal-infos` | PASS | Flutter 3.32，0 issues |
| Flutter 3.47 `flutter analyze --no-pub --fatal-infos` | PASS | 0 issues |
| 九类组件与辅助 example 抽查 | PASS | Table、Calendar、Sidebar、Input、Button、Form、TreeSelect、Stepper、LunarInfo，51/51 |
| `flutter test test/tool/generate_example_code_test.dart` | PASS | 5/5 |
| `pnpm test:example-code` | PASS | 57 份组件文档映射 404 份生成代码 |
| `pnpm site` | PASS | 108 modules transformed，生产构建完成 |

## 人工验收

- [x] Table 页面公开顺序、坐标、尺寸、交互与 Linux light/dark Golden 未改变
- [x] 57 份组件 Web 文档均只有一个组映射，无手写 Dart `td-code-block`
- [x] Table、Stepper、Form 展开后的 Web 代码与生成资产逐字一致
- [x] 缺失或非法映射会阻止映射测试或站点构建
- [x] 旧结构阶段的 60 个语义入口、141 个模块文件和辅助 example 归属均已通过脚本检查并抽查
- [ ] ExampleModule 分组已合并到 60 个页面入口，纯分组模块文件全部移除
- [ ] 全部公开 ExampleItem 均有独立语义文件，运行页面与代码面板引用同一 Widget
- [ ] 每份代码包含所需 imports、数据、状态、回调、helper、Controller 和生命周期，可在最小宿主中解析或编译
- [ ] Web 展示顺序与 ExampleModule / ExampleItem 顺序一致，且不混入测试专用或未注册片段

## 未覆盖项与后续工作

- macOS 本地完整测试中的 Golden 仍因平台文字栅格差异批量失败，未更新基线；非 Golden 明确抽查与双版本 analyze 已通过。
- ActionSheet 大小写敏感资源路径已在 `31111055` 修复，并由最新 Linux Golden 验证通过；旧记录不再作为已知问题。
- 当前 413 份生成片段中仍存在方法级片段引用页面字段、`setState`、helper 或 Controller 的情况；这是新验收条件下的阻塞项。
- macOS 本地 Golden 因平台文字栅格差异出现约 7.3% diff；未更新基线，最终结论采用 CI 同款 Linux 3.32 的 2/2 精确通过结果。

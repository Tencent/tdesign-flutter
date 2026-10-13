# 验收记录

## 验证环境

- 基线：e724cd0c474f14106ee0e5c14b496afabeddb86d
- 独立 worktree：material-export-quickstart；原工作区未修改。
- SDK：Flutter 3.32.0 / Dart 3.8.0；Flutter stable 3.44.9 / Dart 3.12.2。

## 自动化验证

| 验证 | 结果 | 备注 |
| --- | --- | --- |
| 两套 SDK `flutter analyze --no-pub --fatal-infos` | 通过，零诊断 | 包含 example、测试与临时示例 |
| 两套 SDK `flutter test --no-pub` Button 快速开始 smoke + horizontal Tab suite | 各 55 项通过 | README 提取代码，仅导入 TD，实际渲染并点击，确认回调输出 |
| 单导入与 Material + TD 双导入示例分析 | 通过 | 双导入仅忽略预期的 unnecessary_import 提示，无歧义 |
| `node scripts/sync-readme.mjs` | 通过 | 中英文组件 README 及站点已同步 |
| 中英文代码一致与 README 副本逐字节检查 | 通过 | 示例一致 |
| `git diff --check` | 通过 | 无空白错误 |

## 人工验收

- [x] 入口完整导出 Material，无现有 TD 导出删除。
- [x] 冗余导入清理仅涉及 import 及三处随 import 附带的旧注释；无组件逻辑修改。
- [x] Tab 测试在 TD import 上隐藏 TabPageSelector / TabPageSelectorIndicator，保持原先使用内部实现的契约。
- [x] 文档明确已发布 alpha.1 不包含此次重导出。

## 未覆盖项与后续工作

- 本次只完成本地修改，未提交、推送或发布。
- 未验证远端最新 stable；已验证本机 stable 3.44.9 和最低支持 3.32.0。
- SDK 切换初次测试命中旧 shader 格式缓存，clean 并重新解析依赖后通过。
- 临时验证 Dart 文件已删除；完整测试日志在 /private/tmp/material-export-test-3.32.log 和 material-export-test-3.44.log。
- 新增导出可能与消费者其他库的同名声明冲突，可用 hide/show 或前缀消歧。

## 三部分快速开始更新（2026-10-13）

- 中英文快速开始统一为「添加依赖 / 最小导入 / 最小使用」三部分，包含 pub get、单入口 import、完整 main.dart 和 flutter run。
- 使用内联 MaterialApp 的最小示例；中文按钮及输出文案已本地化，英文使用对应英文文案。
- README 副本逐字节一致；站点快速开始与中文源区段一致。
- 从文档提取新的中英文 Dart 示例，在 Flutter 3.32.0 下执行 flutter analyze --no-pub --fatal-infos：零诊断；临时文件已删除。
- git diff --check 通过。此前双 SDK Widget 验证记录对应上一版 MyApp 示例；本轮仅文档结构与示例简化，未重复 Widget 测试。
- 已通过 VS Code CLI 打开独立副本并定位 README_zh_CN.md:46。未提交或推送。

## 最小使用仅展示 TButton（2026-10-13）

- 按用户要求保留内置 Material 重导出；中英文最小使用只展示 const TButton(child: Text(...))，无布局、应用入口和事件。
- 删除完整 main.dart 的替换提示、flutter run 命令和可点击说明；改为放入已有页面，并说明未传 onPressed 时禁用。
- 中英文组件 README 副本逐字节同步；站点快速开始与中文源区段一致。
- 已核对两份最小表达式和入口导出；本轮仅文档调整，未新增或重复运行组件测试。
- 未提交或推送。

## PR 提交前验证（2026-10-13）

- 分支：rss1102/feat/material-export-quickstart；已 rebase 至 origin/develop faab46b2a447a336bdb9e5b42ff9d556f171bc0d。
- Toast 冲突仅涉及导入，保留 develop 新增逻辑和 gestures 导入，删除冗余 Material 导入。
- Flutter 3.32.0 / stable 3.44.9：组件包 flutter analyze --no-pub --fatal-infos 均零诊断。
- 两套 SDK 最小文档表达式 smoke + Button / horizontal Tab / Toast 测试各 228 项通过；最小表达式实际渲染且保持禁用语义。临时测试文件已删除。
- 对最新 develop 的完整 diff 检查确认机械清理未修改组件逻辑；中英文 README 副本一致；git diff --check 通过。
- 完整日志：/private/tmp/material-export-pr-analyze-3.32.log、material-export-pr-analyze-3.44.log、material-export-pr-test-3.32.log、material-export-pr-test-3.44.log。
- 本记录仅覆盖本地检查；远端 CI 以 PR 当前 head 的实际结果为准。

## CI / autofix 修复（2026-10-13）

- 检查 autofix head 8832978bbdfd56169e63f6ab37de89d1b6d30cad：363 个生成片段只删除 366 行导入，无 API、组件实现或片段正文变更。
- 两套 CI test job 的失败均来自 check_demo_snippets.dart：7 个 Cascader / SideBar 片段的 Material import 在合并 includes 后变为 unnecessary_import。此前测试阶段已通过，分析、Golden 与构建通过。
- 最小修复：4 个 Cascader 示例将 Material import 替换为 TD；SideBar icon helper 删除重复 Material import，重新生成 7 个片段。无门禁放宽，无组件行为修改。
- Flutter 3.32.0 / stable 3.44.9：全部 370 个生成片段分析通过，全包 analyze --fatal-infos 零诊断。
- generate_example_code.dart --check、check_demo_structure.dart（60 个入口 / 370 个 ExampleItem）与 git diff --check 通过。
- 日志：/private/tmp/pr1158-failed.log、pr1158-snippets-3.32.log、pr1158-snippets-3.44.log、pr1158-analyze-fix-3.32.log、pr1158-analyze-fix-3.44.log。
- 修复推送后，以 PR 最新 head 的 CI / autofix 结果为准；不执行合并。

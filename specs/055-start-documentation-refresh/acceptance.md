# 验收记录

## 验证环境

- 分支：`rss1102/docs/start-guides`
- 基点：远端 develop `faab46b2a447a336bdb9e5b42ff9d556f171bc0d`（新工作树创建前 fetch）
- 工作树：`/Users/rs/.codex/worktrees/start-docs-refresh/tdesign-flutter`
- Node：24.15.0；Vite：6.4.3。
- 示例验证：Flutter 3.32.0 / Dart 3.8.0；Flutter 3.44.9 stable / Dart 3.12.2。

## 自动化验证

| 命令或检查 | 结果 | 备注 |
| --- | --- | --- |
| `node --test scripts/sync-readme.test.mjs` | 8/8 通过 | 真实 CLI 夹具验证复制、提取、缩进、幂等、标记异常不部分写入、站内同源链接及实际生成副本 |
| `node scripts/sync-readme.mjs` | 通过 | 三份副本由源文档生成 |
| `node --test site/utils/flutterThemeBridge.test.mjs site/flutter-example-docs/*.test.mjs` | 21/21 通过 | 在 tdesign-site 执行 |
| `node site/flutter-example-docs/check-docs.mjs` | 通过 | 57 个组件页、360 个示例保持生成契约 |
| `node node_modules/vite/bin/vite.js build --config site/vite.config.ts` | 通过 | 与 `pnpm site` 使用相同检查和构建入口 |
| 抽取快速开始和全局配置教程的 Dart fenced 示例 | 通过 | 共 8 段；中英文最小应用一致；临时消费应用依赖本工作树组件源码，国际化使用仓库完整代理 |
| 临时应用 `flutter analyze --fatal-infos` | 双版本零诊断 | Flutter 3.32.0、3.44.9 stable |
| 临时应用 `flutter test` | 各 5/5 通过 | 最小应用、品牌色及全局/局部 Tag 样式、手动明暗切换、主题资源加载、国际化重建后切换文案 |
| 文档中的 develop 源码链接 | 通过 | 文件或目录在当前基点均存在 |
| `git diff --check` | 通过 | 无空白错误 |

## 人工验收

- [x] 从本工作树的 Vite 构建启动 19110 端口预览，在浏览器检查 `/flutter/getting-started` 、`/flutter/develop`、`/flutter/custom-theme`、`/flutter/dark-mode`、`/flutter/internationalization` 和 `/flutter/components/theme`。
- [x] 快速开始的标题与说明、依赖 YAML、完整 Dart 应用和需求导航实际显示；详细主题与国际化说明分别出现在独立教程，代码缩进与高亮正常。
- [x] 官网正文不再包含 README 徽章、贡献者列表和其他框架介绍；仓库与组件包 README 保留这些项目介绍。
- [x] 贡献指南的 clone 命令、当前生成器入口、集中式测试 manifest 和完整 PR 模板要求实际显示。
- [x] 修改范围限于 README、贡献指南、全局配置教程/菜单、Theme API 标题元数据、同步脚本/测试和本 Spec，未混入原工作区其他修改。

- [x] 需求表点击后进入当前预览站点的对应教程；全局配置四个菜单入口与页面标题一致。
- [x] 原 `自定义主题` 和 `🎨-自定义主题` 锚点仍可定位到需求导航，已有 FAQ 入口不落空。
- [x] Theme API 正文继续保持生成的 Example/API 契约，仅调整标题元数据。

## 未覆盖项与后续工作

- 未运行远端 CI、发布、推送或 PR 操作；本机 stable 3.44.9 验证不等于远端 `flutter@latest` 验证。
- 本机 3.47.0 为 user-branch，不用它作为 stable 证据；额外尝试时示例分析通过，但 Widget 测试出现 shader manifest/engine 不兼容错误。切换至 3.44.9 stable 并清理临时构建后测试通过。
- `pnpm site` 因本机 pnpm 10/项目声明 pnpm 11 的自动切换要求重装 modules 且非 TTY 而未运行；改用同一组 Node 检查及 Vite 构建入口完成站点验证。未修改 packageManager 或锁文件。
- 构建仍有旧二维码路径、第三方 PURE 注解、输出目录及 chunk 大小告警；相关文件未改动，不在本次文档收敛范围内。
- 本次为文档与生成规则改动，未运行组件全量回归或真机平台能力验收；临时示例验证文件不纳入仓库。
- FAQ、更新日志、组件概览保持不变，按用户要求留待后续处理。

## 阅读成本优化验收

- 贡献指南从 149 行缩为 118 行，移除生成器内部命令和 Issue 标签释义；按文档、组件、视觉和平台能力选择验证步骤。
- 国际化合并为三步，自定义主题明确快速开始中的替换位置，主题生成器标记为可选。中英文需求导航改为两列，主题需求链接到对应小节。
- 所有 Dart fenced 示例与上一提交逐段比较完全一致，继续沿用双版本示例验证结果。
- 同步测试 8/8、站点测试 21/21、57 个组件页/360 个示例契约检查及 Vite 生产构建通过；`git diff --check` 通过。
- 浏览器复现跨页链接首次加载未定位锚点，在内容加载后补充定位。品牌色和修改范围链接点击后目标标题距离视口顶部均为 80px；旧主题锚点定位到需求导航，表格与三步国际化正常显示。
- 上一提交 `770233af` 的远端 CI 已全部通过，autofix 未改变提交；本轮提交需要重新运行 CI。

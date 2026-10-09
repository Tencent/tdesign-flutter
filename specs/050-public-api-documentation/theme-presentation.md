# 组件 Theme 文档入口

2026-10-09 继续文档 PR #1149，工作分支 `rss1102/docs/component-api-completeness`，起点 `f203cedf`。

## 内容来源与归属

57 个页面的主入口 dartdoc 均增加「主题配置」小节，生成器只解析注释并调整标题层级。没有添加组件专属生成逻辑、手写 API 表或临时依赖覆盖。

- 51 个独立组件 Theme：主入口说明通过 `ThemeData.extensions` 配置，并指向同页已生成的 Theme 类型、字段及方法。字段的真实回退说明继续在 Theme dartdoc 维护，不把构造声明的 null 默认值替换成运行时默认值。
- 3 个复用组件：DateTimePicker 只复用 Picker 的高度、可见项数；Textarea 保留 Input 容器与编辑器的分工；PullDownRefresh 保留 Loading 的横向布局和文字颜色覆盖说明。没有复制其他页面的 Theme 字段表。
- Icon、Steps：明确没有独立 Theme，保留真实全局 Token 与实例配置来源。
- Theme 页：集中定义全局 Token，说明与组件 ThemeExtension 的关系。

组件现有实例覆盖、局部主题、弹层创建时快照以及 `copyWith` / `lerp` 差异仍由对应 API 的注释说明；本次不建立统一的运行时优先级规则。

## 验证与交付门禁

当前候选工具为 `TDesignOteam/tdesign-flutter-tools` PR #29 的 `3e2a617`。正式 `main` 仍为旧工具，不能把候选生成等同于正式依赖验收。

旧文档 PR head `f350da49` 的 autofix 重写全部 57 份 API，重新加入源码代码块，导致两版本展示测试失败（Expected: not 'pre' / Actual: 'pre'）。该失败来自旧生成器与新展示契约不匹配，不能通过放宽测试掩盖。站点工作流另因 Gradle/Kotlin 依赖下载失败，与 Theme 文案无直接关系。

工具 #29 合入正式 main 后，需要重新解析依赖、正式生成与 `--check`，并重新读取文档 PR 最新 head 的 autofix diff 和 CI。当前不声明可合并。

此前 `current-semantic-ledger.json` 与消费证据保留为原轮次的源码快照；本轮添加注释后文件哈希会变化，不把旧哈希当作最终源码证明。本轮以重新生成、AST/非注释 Token 核对和页面回归记录为准。

## 本轮最终候选验证

Flutter 3.32.0 与 stable 3.47.6 对相同最终源码执行：

| 检查 | 3.32.0 | 3.47.6 |
| --- | --- | --- |
| 57 份文档生成 | 完成 | 完成 |
| 生成产物逐字节比较 | 两 SDK 及工作区 57/57 一致 | 两 SDK 及工作区 57/57 一致 |
| 工具 validate | ERROR=0、WARN=0 | ERROR=0、WARN=0 |
| 文档专项测试 | 115 通过 | 115 通过 |
| 真实 API 页面测试 | 70 通过 | 70 通过 |
| flutter analyze --no-pub --fatal-infos | 零问题 | 零问题 |

独立 AST 审计 issues 为空；73 个生产 Dart 文件相对本轮起点的全部非注释 Token 一致（包括逗号）。57 页均有注释生成的主题配置小节，369 个公开声明保留，复用或无独立 Theme 的页面未重复声明 ThemeData。git diff --check 通过。

运行入口：现有 test/tool/audit_api_docs_test.dart、typedef_docs_test.dart、api_presentation_test.dart，以及 example/test/api_docs_test.dart；未添加仅镜像实现的测试。生成使用工具 PR #29 的实际解析器，不直接维护 Markdown。

最初最新 SDK 测试因 package_config 指向 3.32.0 而编译失败；分别用对应 SDK 的 flutter pub get --offline 刷新缓存后重跑通过，未修改源码、测试或锁文件绕过。

本轮未重跑组件全量、Golden、设备、Figma 或官网浏览器验收；实际 Flutter API 页面测试与生成契约通过不能代替这些证据。

# 046-Demo-experience 验证范围与结论

<a id="source-046"></a>
<a id="source-065"></a>
<a id="source-073"></a>

## 本次范围

2026-10-20 原记录整理；未重跑组件、Golden、设备或远端CI。以下结论仅限原候选与范围。

## 已有验证结论

| 原记录范围 | 原文可追溯标识与环境 | 有界结论 |
| --- | --- | --- |
| 既有记录 | 未绑定唯一完整候选 SHA；SDK 范围未完整标注 | 组件与布局：未提取到可独立确认的通过结论；Demo 与消费：未提取到可独立确认的通过结论；Golden：未提取到可独立确认的通过结论；设备：仅按下文的实际操作与未覆盖范围解释 |

各标识可能对应不同阶段，不能合成一次完整验证；候选或日志缺失时仍需复核。

## 验证范围与未覆盖项

实际实现变更时，应记录候选 SHA、环境、所执行命令、结果及未覆盖项；不再保留过期的 PR 拆分记录。

## 必要证据与追溯

未绑定唯一候选的结果不作为当前通过证明；旧命令与流水由Git历史追溯。

当前待办见 [tasks.md](./tasks.md)；实际执行入口见[贡献规范](../../../CONTRIBUTING.md#组件测试与-ci-回归门禁)。清理不关闭未完成项。

## 2026-10-23 站点历史转换清理

基线 `8bbbcd21b02dd3e2c83a21d373c8718f0ce0693a`；本分支 `tdesign-site` 源码补丁 SHA-256 `f236c9df201637b3cfb6df424c435b5167d612b4b20fe80a727a7524fa095439`（`git diff 8bbbcd21b02dd3e2c83a21d373c8718f0ce0693a -- tdesign-site` 的 UTF-8 字节）。此标识不包含验收记录本身。

- Node 24.15.0：`node --test site/utils/flutterThemeBridge.test.mjs site/flutter-example-docs/*.test.mjs`，33/33 通过。
- `node site/flutter-example-docs/check-docs.mjs`：57 个组件文档、360 个生成示例映射通过。
- 在 `tdesign-site/site` 执行 `../node_modules/.bin/vite build`：通过，4.06s；存在既有大 chunk 提示。
- 扫描站点 Markdown：无 Flutter 指令之外的旧占位符；无 `.wxml`/`.wxss` 资产。仓库文档适配、Flutter 示例/API 指令及 BASE_URL 图片改写保留。
- 未执行 Flutter 组件、Golden、设备或线上部署；最终远端 head CI 待核对。
## 全组件历史审查处置

[审查表及最新处置](./evidence/component-audit.md)保留原基线范围，并按 2026-10-23 的 develop 和合并状态修正 Upload/Toast 说明；不将历史检查点视为当前全量验收。

## 2026-10-23 文档纠错本地验证

基线 `8bbbcd21b02dd3e2c83a21d373c8718f0ce0693a`；文档/源码补丁 SHA-256 `90b44fbabba220d8f04a67a2e2e3d8193f2f498de41ce07a31b6154e4084a38a`（`git diff 8bbbcd21b02dd3e2c83a21d373c8718f0ce0693a -- CONTRIBUTING.md tdesign-component tdesign-site` 的 UTF-8 字节，不包含 specs 验收文本）。

- macOS，Flutter 3.32.0 / 3.47.7：`flutter analyze --fatal-infos` 两版无诊断。
- Example 工程执行 `flutter test --no-pub test/example_code_viewer_test.dart test/api_docs_test.dart`：两版各 74/74 通过。3.47.7 首轮因切换 SDK 后旧 `ink_sparkle.frag` 缓存格式不兼容失败；执行 flutter clean、重新离线解析依赖后完整复跑通过，不改源码规避。
- `node tool/generate_api.mjs` 从源码生成 57 页 API，仅 TimeCounter 的预期说明变化；`dart run tool/audit_api_docs.dart --json` 为 370 声明、0 issues。
- `dart run tool/generate_example_code.dart --check` 通过，未改生成片段。
- Node 24.15.0：站点测试 33/33；57 个组件文档/360 个生成示例映射和 Vite 构建通过。`node scripts/sync-readme.mjs --check` 为 6 份文档、0 stale；变更 Markdown 的相对文件链接检查无缺失。
- 只更新文档、注释和历史处置；未执行全组件功能、Golden、设备或全部代码面板人工验收。上述记录不替代最终 head 的远端 CI，CI 尚待核对。

## 2026-10-23 latest develop verification

Base: `182f8cd956edeee4dfd7ef977176309f051e3c3c`. Binary diff SHA-256 (`git diff --binary --no-ext-diff origin/develop -- tdesign-site`): `f236c9df201637b3cfb6df424c435b5167d612b4b20fe80a727a7524fa095439`.

- Node 24.15.0 / macOS: theme bridge and documentation tests 33/33 passed; 57 component pages / 360 generated example mappings passed; Vite production build passed in 3.32s (existing chunk size warning only).
- `git diff --check origin/develop` passed. Flutter directives, repository document adapters and BASE_URL image rewriting retained. No component source changes; Flutter/Golden/device tests are outside this cleanup scope.
- Current FAQ, audit dispositions and unused-version cleanup come from develop. No push, remote PR mutation, deployment or current remote CI verification.


## 可运行接入指南

来源 PR #1156 `a9a44f1985af4f7b4ca3b46b53f26d5c7d90085e`；独立基线 develop `673ddf8cc69d41632f68832a9079385623af7df1`。仅包含本章节职责；验证结果仅适用于以下本地候选，不继承原 PR CI 或其他拆分分支结果。

2026-10-26 本地验证：相对上述基线的源码二进制补丁 SHA-256（scripts / tdesign-component / tdesign-site，不含本记录）为 `bbd439ebc56f2b9be5c50892cb6f55dba3be1383270cc665a5ac77efbbbf5867`。

macOS Flutter 3.32.0 / 3.47.7：Example 严格分析均无诊断，文档示例与 Theme 非 Golden 功能测试各 20/20；3.32.0 回归清单、覆盖率 runner、视觉 runner 和示例生成器自测 41/41，生成片段 --check 通过。Node 24.22.1：站点测试 39/39，57 页/360 示例映射、8 份同步输出检查及生产构建通过。Linux amd64 / Flutter 3.32.0：主题与指南 Golden 14/14 精确比对通过，使用 TDESIGN_DEMO_TEST_MODULES=false；未运行更新基线命令，未修改容差。截图内容沿用来源候选中的预期视觉。

上述检查点尚未执行指南浏览器交互；后续验证及修复见下文。移动设备验收与本分支远端 CI 当时均未执行。


### 2026-10-26 浏览器交互与预览刷新复核

基线仍为 `673ddf8cc69d41632f68832a9079385623af7df1`；本轮最终源码补丁 SHA-256（scripts / tdesign-component / tdesign-site，不含 Spec）为 `faa8ca5a5c3be612c56fc20d5cde99d1a04ccf8d6fc8fb32c81da319a960e4e9`。本地发布构建使用 Flutter 3.47.7，禁用 Web 资源 CDN，挂载于 http://127.0.0.1:19117/flutter/；最终 main.dart.js SHA-256 为 `e2c55e167f28ceb16691d177658212816aaced22b4aa24949b05b96741bf2b90`。测试使用本机内置浏览器和当前分支生产站点，不连接已发布的 Flutter Demo。

- 发现并修复主题指南的实际刷新缺陷：内层带 home 的 MaterialApp 创建 Navigator，挂载时将 iframe 地址覆盖为首页，刷新后落到组件清单。局部应用改为 builder 渲染内容，保留主题、本地化和字体环境，路由由 Example 宿主唯一管理；完整可复制应用的 documentationThemeApp 用法不变。新增宿主导航所有权回归，覆盖完整指南及 JSON / local / mode 三个独立场景。
- 快速开始：实际点击计数增加；站点切换浅深色时计数保持。主题工具选择非默认腾讯云配色，浅色 `#006eff`、深色 `#2684ff`。在两种模式下只刷新 iframe，宿主 loader ID 均不变、iframe loader ID 变化，重新启动的计数为 0，当前外观及非默认配色恢复。刷新前后截图存于本地 artifacts/pr1156-split-local-20261026/guides-fixed-counter-*.png。
- 主题指南：默认/业务主题可切换；业务主题浅色为 green / `#16875D`、深色为 greenDark / `#56C08D`。输入“浏览器验证”及保存操作在站点明暗切换时保持。修复后的浅深色 iframe 刷新均保留 `#custom-theme` 路由，恢复对应主题，不再进入组件清单。临时输入、保存及选择跨刷新重新初始化，不承诺持久化。独立 JSON / local / mode 场景刷新后均保留原 hash；浅色、深色及跟随系统的实际文案与配色正确。
- 共享预览：从指南离开再进入可以挂载；Button 组件页沿用同一预览组件，非默认配色下刷新仍保留 `#button` 路由和当前外观。
- 国际化：仓库外临时入口直接调用本分支 runLocaleApp，浏览器实际完成“确认 → Confirm → 确认”。资源主题入口直接调用 runThemeApp，实际加载 assets/custom_theme.json 并渲染业务主题按钮；没有为截图手写平行实现。
- 390px 桌面浏览器视口仿真：正文右侧预留归零，document scrollWidth 374px，不超过 390px 视口。检查后清除视口仿真，并恢复本地站点默认配色；不将该结果记为移动设备验收。
- 修复后 Flutter 3.32.0 / 3.47.7 严格分析均无诊断；功能测试各 21/21；工具自测 41/41、示例片段 --check、站点测试 39/39、57 页/360 示例映射、8 份同步输出和生产构建通过。Linux Flutter 3.32.0 Golden 14/14 精确比对再次通过，未更新基线或容差。

结构化观察及必要截图保存于本地 artifacts/pr1156-split-local-20261026/。浏览器的外部页面装饰连接出现 Failed to fetch 日志；未验证其线上服务，不据此声称全站外部服务已通过。本轮只补充本机浏览器证据，未执行其他浏览器、真机、发布部署或远端 CI；这些范围见 tasks.md。


[主题指南深色预览刷新后的浏览器截图](./evidence/guide-preview-reload-dark.png)。截图为本地浏览器证据，不代表移动设备验收。


### 2026-10-26 PR #1204 在线预览及独立应用复验

运行源码 `e5bf6372351b15ce2e73e259bd05a42743fe3eaa`；[在线预览](https://preview-pr-1204-40282739968-1-tdesign-flutter.surge.sh/flutter/custom-theme) 的部署任务 40282739968 明确下载构建任务 40282176943 的产物，该构建 head 与上述提交一致。

- 在线快速开始按钮实测 0 → 2。主题指南在浅深色下分别只刷新 iframe；宿主 loader 不变、iframe loader 变化，实际地址均保留 `#custom-theme`，对应恢复 green / `#16875D` 与 greenDark / `#56C08D`。
- Flutter 3.32.0 从同一源码重新构建独立入口，直接调用 `runLocaleApp` 与 `runThemeApp`。国际化完成“确认 → Confirm → 确认”；资源主题成功加载项目 JSON 并渲染主题按钮，未手写平行应用。国际化指南本身没有内嵌预览，不将本地独立应用写成线上页面交互。
- [结构化运行记录](./evidence/pr1204-browser-observations.json)；[计数](./evidence/guides-counter.png)、[浅色刷新](./evidence/guides-theme-light-reloaded.png)、[深色刷新](./evidence/guides-theme-dark-reloaded.png)、[中文](./evidence/guides-locale-chinese.png)、[英文](./evidence/guides-locale-english.png)、[资源主题](./evidence/guides-resource-theme.png)均为未经编辑的实际浏览器截图。

该源码提交的远端构建及相关检查已通过。本次只新增截图和验收证据，未改变运行源码、生成片段或 Golden 基线；复用上文同一源码的双版本与 Golden 检查。本轮为桌面浏览器验证，未执行移动设备或其他浏览器验收；截图提交的新 head CI 需另行核对。

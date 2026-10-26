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


## 文档锚点与历史恢复

来源 PR #1156 `a9a44f1985af4f7b4ca3b46b53f26d5c7d90085e`；独立基线 develop `673ddf8cc69d41632f68832a9079385623af7df1`。仅包含本章节职责；验证结果仅适用于以下本地候选，不继承原 PR CI 或其他拆分分支结果。

2026-10-26 本地验证：相对上述基线的源码二进制补丁 SHA-256（scripts / tdesign-component / tdesign-site，不含本记录）为 `5a33996bd87ebd61b6ef8615f4bc499f08c48bd42e3e35e33ab17375b683dfb0`。

Node 24.22.1：导航、主题桥及站点文档测试 47/47；57 页/360 示例映射、6 份同步输出检查和 Vite 生产构建通过。仅改站点，未运行 Flutter 或 Golden。

本机内置浏览器访问当前分支生产预览 http://127.0.0.1:19116/flutter/：首次验证发现 Markdown 将分组锚点渲染为空段落中的 a，锚点不是 details 的祖先，原逻辑只定位不展开。修复识别相邻折叠章节的空锚点，并增加对应回归及非空段落不误展开测试。修复后 migration-group-basic 和 migration-component-button 均展开对应章节，目标距视口顶部 80px；跨页 FAQ 返回恢复滚动 2321px。相同无 hash URL 的独立历史条目 B / C 分别恢复 basic / display 折叠状态及 2051px / 2159px，前进至 C 仍恢复对应状态。必要截图见本地 artifacts/pr1156-split-local-20261026/navigation-browser-anchor.png。

这是本机浏览器聚焦检查，不代表全部浏览器、移动视口、发布站点或设备验收。未推送、未执行本分支远端 CI。


[迁移指南折叠锚点展开与定位的浏览器截图](./evidence/navigation-folded-anchor.png)。截图为本地浏览器证据，不代表移动设备验收。


### 2026-10-26 PR #1205 在线导航复验

运行源码 `2695c64d96cc5fb0dd65f03731c158ec87b48f75`；[在线预览](https://preview-pr-1205-40282829021-1-tdesign-flutter.surge.sh/flutter/migration-1-0) 的部署任务 40282829021 下载构建任务 40282224119 的产物，构建 head 与上述提交一致。

- 分组 `#migration-group-basic` 与折叠块内部 `#migration-component-icon` 深链接均自动展开基础组件章节；内部目标距视口顶部 80px。截图另向上滚动以完整展示章节上下文，不把截图后的滚动位置当成定位断言。
- 通过真实侧栏导航访问“迁移指南 → FAQ → 同一迁移指南”，两次 URL 均为 `/flutter/migration-1-0`。第一次仅展开基础组件，滚动位置 2051；第二次仅展开输入组件，滚动位置 2123。浏览器连续后退恢复第一次，连续前进恢复第二次，折叠数组与滚动值均与各自离开前完全一致。
- [结构化运行记录](./evidence/pr1205-browser-observations.json)；[分组深链接](./evidence/navigation-group-anchor.png)、[内部深链接](./evidence/navigation-inside-anchor.png)、[后退恢复](./evidence/navigation-history-back-A.png)、[前进恢复](./evidence/navigation-history-forward-B.png)均为未经编辑的在线站点运行截图。

该源码提交的远端构建及相关检查已通过。本次只新增截图与验收证据，站点实现不变，复用已有 47/47 测试及构建结果；无需重跑 Flutter 或 Golden。本轮为桌面浏览器验证，未执行移动设备或其他浏览器验收；截图提交的新 head CI 需另行核对。

### 2026-10-26 PR #1202 整合复验

包含 #1205 全部提交和 theme-generator 1.3.0。基线 673ddf8cc69d41632f68832a9079385623af7df1，站点二进制补丁 SHA-256 e7884d66243819bb703865b8dacd01b5769fe5bbb90988d098f7a94b26cbd710（计算入口同 Spec 044）。#1205 导航实现与测试未改动。

仅升级主题生成器的对照版本中，内部 #migration-component-icon 章节仍折叠，证明未覆盖 #1205。整合后的生产预览中，内部锚点及 #migration-group-basic 均自动展开，目标距视口顶部均为 80px。

真实侧栏导航创建同一无 hash URL 的历史条目：A 仅展开基础组件、滚动 2339px；B 仅展开输入组件、滚动 2483px。后退到 B、继续后退到 A、前进回 B，折叠数组和滚动值分别完全恢复。见[结构化观察](./evidence/pr1202-navigation-observations.json)、[后退 A](./evidence/pr1202-history-back-A.png)、[前进 B](./evidence/pr1202-history-forward-B.png)。

整合候选站点测试共 47/47、生产构建通过。本轮为本地桌面浏览器验收，未代表线上部署、移动设备或全部浏览器；旧 #1205 远端结果只适用于其原 head。



## 主题功能色板

来源 PR #1156 `a9a44f1985af4f7b4ca3b46b53f26d5c7d90085e`；独立基线 develop `673ddf8cc69d41632f68832a9079385623af7df1`。仅包含本章节职责；验证结果仅适用于以下本地候选，不继承原 PR CI 或其他拆分分支结果。

2026-10-26 本地验证：相对上述基线的源码二进制补丁 SHA-256（scripts / tdesign-component / tdesign-site，不含本记录）为 `0be40213b40d94ea65c94e4e304c9d5ae38e3a9576281c3b475ff006bf7d16f0`。

macOS Flutter 3.32.0 / 3.47.7：Example 严格分析均无诊断，Theme 非 Golden 功能测试各 17/17，包含新增的不等长、稀疏/别名、空色板 3 项；3.32.0 工具与调度器自测 41/41。示例片段从实际源码重新生成，--check 通过。Linux amd64 / Flutter 3.32.0：现有 Theme 测试文件 Golden 8/8 精确比对通过，使用 TDESIGN_DEMO_TEST_MODULES=false；未修改任何基线或容差。页面默认颜色与指南视觉均保持既有基线。

设备上的色板与代码面板仍未人工验证，见 tasks.md；未推送、未执行本分支远端 CI。

### 2026-10-26 在线站点运行检查

运行候选为 PR #1206 `b85ebcfab1b26b7913da4ad20b2d82a49978b140`，使用其 CI 在线预览的 Theme 页面。本轮为真实浏览器运行检查；用户澄清验收对象为站点展示，未连接手机，不记为手机实机验收。

通过站点既有同源主题消息通道加载[测试配置](./evidence/functional-palette-browser-theme.json)，未修改预览源码。浅色、深色均显示新增业务色、稀疏键 brandColor12 和别名 brandAlias；四类功能色实际数量为 20/16/16/16，没有旧的数量不等提示，别名与目标同色。站点代码面板正常展示真实生成片段，包含导入、实际键名与 entries.length。空配置沿用聚焦 Widget 测试结果，本轮没有声称完成其浏览器检查。检查后重新加载预览，撤销临时主题配置。

[浅色运行截图](./evidence/functional-palette-browser-light.png) · [深色运行截图](./evidence/functional-palette-browser-dark.png)。截图仅为验收证据，未更新任何 Golden 基线或修改运行源码；此前源码候选的 CI 已完成，新增证据提交的 CI 按最终 head 单独核对。


### 2026-10-26 条目收集精简复核

移除中间 colors Map，先按固定分类筛选候选键，再解析非空颜色并直接生成 MapEntry。保留当前/默认/引用键集合、分类及组内顺序和渲染方式，不新增辅助类。示例片段从源码重新生成。

相对 develop 673ddf8cc69d41632f68832a9079385623af7df1 的源码二进制补丁 SHA-256（scripts / tdesign-component / tdesign-site，不含本记录）为 `e7450afca3330fca46257521c16a139f47111d39bbffc162b9a757e47394a96a`。Flutter 3.32.0 / 3.47.7 严格分析无诊断，Theme 非 Golden 功能测试各 17/17；片段生成及 --check 通过，站点片段测试 7/7，57 页/360 示例映射通过。Linux Flutter 3.32.0 现有 Golden 8/8 精确比对通过，未更新基线或容差。此前浏览器截图继续绑定原运行候选；本轮通过功能及像素比对验证行为和默认视觉保持一致，未声称重新执行在线浏览器验收。远端 CI 按最终提交另行核对。


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

### PR #1202：site-components 回退至 main 版本

依据 Flutter main d0de29e8，依赖从 ^0.20.0 回退为 ^0.18.1，锁文件实际解析 0.18.1；hybrids 连带回退至 8.2.2。其他依赖版本及运行源码未变。

站点目录 Git tree f076189826367459837dccf8e68d423b64ac9d7f（git rev-parse HEAD:tdesign-site），Node 24.15.0 / pnpm 11.20.0：冻结安装成功，实际安装版本 0.18.1；站点测试 51/51、57 页 / 360 示例映射和生产构建通过。

本机浏览器：移动端默认圆角 6px，调节后 4px，重置恢复 6px；内部锚点自动展开并定位在顶部 80px，跳转 FAQ 后后退恢复章节展开及滚动 2640px。


### 2026-10-26 同步最新 develop 后复核

合并 develop 942152009bf2520b98681da0a63d130ef9883d46（#1204）；运行候选 22c2284d29102aa654bb8f0b6e6c58cb93d703cc。相对该基线的源码二进制补丁 SHA-256（git diff --binary --no-ext-diff origin/develop -- scripts tdesign-component tdesign-site，不含本记录）为 4c630c97c579d71e72c931e45500606804339e70fc61bf238efd3f15c793aa40。

冲突仅涉及 Spec 046 的 spec / plan / tasks / acceptance，保留接入指南及功能色板的独立契约和原验收边界。功能色板实现及生成片段与同步前 dbb311a01e77dfc438779c1d855582254c0530a2 完全一致；Theme 测试保留 develop 指南新增测试和本 PR 的色板回归。

macOS Flutter 3.32.0 / 3.47.7：Example 严格分析均无诊断，Theme 与 documentation_examples 非 Golden 测试各 24/24；3.32.0 工具及调度器自测 41/41。片段 --check 通过；Node 24.15.0 的站点文档测试 30/30，57 页 / 360 示例映射通过。Linux amd64 Flutter 3.32.0 对同步候选重跑 Theme 测试文件的 Golden 14/14 精确通过，TDESIGN_DEMO_TEST_MODULES=false，未修改任何基线或容差。

与 #1205 d5688e33afc299f52849778f06fa8478bf7a0d09 比较，两者仅重合四份共用 Spec 文件；#1206 无站点导航源码改动，#1205 无功能色板实现或测试。两项修复不重复。当前色板修复不依赖 #1205/#1202；导航仍由 #1202 承载。

本轮未重新执行浏览器或手机验收，原浏览器截图仍只绑定原候选；本地新检查不能外推为最终 head 的远端 CI。

### PR #1206：site-components 回退至 main 版本

依据 Flutter main d0de29e8，依赖从 ^0.20.0 回退为 ^0.18.1，锁文件实际解析 0.18.1；hybrids 连带回退至 8.2.2。其他依赖版本及运行源码未变。

站点目录 Git tree cb22fb30b5cffebb6b28e721a2323661f50c335e（git rev-parse HEAD:tdesign-site），Node 24.15.0 / pnpm 11.20.0：冻结安装成功，实际安装版本 0.18.1；站点测试 39/39、57 页 / 360 示例映射和生产构建通过。

本机浏览器：Theme 页面及功能色生成代码面板可展示。纯站点生产预览未包含 Flutter 构建资产，不作为 Flutter iframe 功能验收。

本轮未重跑完整 Flutter 演示、真机或两个官网全量回归；原截图和 Flutter 测试仍绑定原候选。最终远端 CI 单独核对。

### PR #1202：合并 develop 304bf7d6 后冲突复核

运行候选 170d95c6（合并 develop 304bf7d6）。冲突仅涉及 Spec 046 四份文档和 package.json 的 theme-generator 版本，分别保留导航与色板记录、选择 1.3.0。site-components 继续使用 0.18.1。站点目录与合并前 c6015bfc 完全一致，tdesign-component 目录与 develop 304bf7d6 完全一致，未覆盖两边实现。

Node 24.15.0 / pnpm 11.20.0 冻结安装、站点测试 51/51、57 页/360 示例映射和生产构建通过；macOS Flutter 3.32.0 Example 严格分析无诊断，Theme 与 documentation_examples 非 Golden 测试 24/24 通过。git diff --check 通过。未重跑浏览器、双版本完整矩阵或 Golden；本轮结果仅覆盖上述检查，最终远端 CI 另行核对。

## 2026-10-26 PR #1202：迁移指南精简与锚点修复

基线为 4b262697e557849676cc9698ee8b4c47b6044260。最终源码逐文件指纹见[候选摘要](./evidence/pr1202-migration-compact-summary.json)。本节为本次提交的本地验收；远端 CI 按推送后的最终 head 核对。

修复重复点击同一链接后章节不展开、附录表格未展开和标题直达被固定页头遮挡的问题。精简开头、组件摘要和附录重复规则，明确版本边界与 null 禁用语义；不提供专用搜索控件。站点只显示统一页头，保留原标题片段地址；包内 Markdown 保留独立标题并由脚本同步。

Markdown 源由 85,538 字符减少至 70,984 字符（17.0%）；388 项旧类型的名称/去向、12 段 Dart 示例与精简前逐项一致，原有显式锚点和全部不同链接目标均保留。补充的页签、底部导航、轮播示例来自独立消费项目的同一源码。原正文的 PR 分工、patch 发布策略及 Golden 授权流水已移出用户指南；清理不改变已有组件行为或基线，不推定当前 Golden 通过。

Node 24.15.0：站点测试 56/56、57 页/360 示例映射、8 份文档同步检查、diff 检查及生产构建通过。迁移消费者在 Flutter 3.32.0 / 3.47.7 下严格分析均无诊断，测试各 24/24；后续文案精简未改变消费者源码和示例代码。未修改库公开 API 或 Golden。

[逐项浏览器记录](./evidence/pr1202-migration-compact-browser.json)：生产预览中逐一激活 461 处正文/目录链接，检查 61 处页面/API 页签往返，以及 64 个当前或旧标题片段。移除零宽的重复 H1 permalink 前共 558 处链接均通过；最终 557 处链接是此前清单的子集，无新目标，复查分组展开与详细改法均定位在顶部 80px。搜索控件不存在；重复点击、附录展开与历史恢复已验证。[最终截图](./evidence/pr1202-migration-compact-local.png)。

正式官网 60 个不同目标的[HTTP 记录](./evidence/pr1202-migration-official-http.json)均为 200；对应浏览器检查 58/60，Skeleton / 自定义主题页面存在动态模块加载失败，已保留在浏览器记录的 earlierOfficialBrowserCheck 中。文案精简未改变正式 URL，未重复执行外部检查，不把 HTTP 200 当成渲染通过。

上述结果仅覆盖本地桌面浏览器与列明的测试，不代表正式部署、移动设备、其他浏览器或两个官网全量回归；剩余事项见 tasks.md。

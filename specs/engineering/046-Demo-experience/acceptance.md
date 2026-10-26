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


本节按文字记录折叠展开与定位结论，不归档页面截图。


### 2026-10-26 PR #1205 在线导航复验

运行源码 `2695c64d96cc5fb0dd65f03731c158ec87b48f75`；[在线预览](https://preview-pr-1205-40282829021-1-tdesign-flutter.surge.sh/flutter/migration-1-0) 的部署任务 40282829021 下载构建任务 40282224119 的产物，构建 head 与上述提交一致。

- 分组 `#migration-group-basic` 与折叠块内部 `#migration-component-icon` 深链接均自动展开基础组件章节；内部目标距视口顶部 80px。截图另向上滚动以完整展示章节上下文，不把截图后的滚动位置当成定位断言。
- 通过真实侧栏导航访问“迁移指南 → FAQ → 同一迁移指南”，两次 URL 均为 `/flutter/migration-1-0`。第一次仅展开基础组件，滚动位置 2051；第二次仅展开输入组件，滚动位置 2123。浏览器连续后退恢复第一次，连续前进恢复第二次，折叠数组与滚动值均与各自离开前完全一致。
- [结构化运行记录](./evidence/pr1205-browser-observations.json)保留各项实际观察与结果；不另存页面截图。

该源码提交的远端构建及相关检查已通过。站点实现不变，验收复用已有 47/47 测试及构建结果；无需重跑 Flutter 或 Golden。本轮为桌面浏览器验证，未执行移动设备或其他浏览器验收；证据提交的新 head CI 需另行核对。

### 2026-10-26 PR #1202 整合复验

包含 #1205 全部提交和 theme-generator 1.3.0。基线 673ddf8cc69d41632f68832a9079385623af7df1，站点二进制补丁 SHA-256 e7884d66243819bb703865b8dacd01b5769fe5bbb90988d098f7a94b26cbd710（计算入口同 Spec 044）。#1205 导航实现与测试未改动。

仅升级主题生成器的对照版本中，内部 #migration-component-icon 章节仍折叠，证明未覆盖 #1205。整合后的生产预览中，内部锚点及 #migration-group-basic 均自动展开，目标距视口顶部均为 80px。

真实侧栏导航创建同一无 hash URL 的历史条目：A 仅展开基础组件、滚动 2339px；B 仅展开输入组件、滚动 2483px。后退到 B、继续后退到 A、前进回 B，折叠数组和滚动值分别完全恢复。见[结构化观察](./evidence/pr1202-navigation-observations.json)。

整合候选站点测试共 47/47、生产构建通过。本轮为本地桌面浏览器验收，未代表线上部署、移动设备或全部浏览器；旧 #1205 远端结果只适用于其原 head。



## 主题功能色板

来源 PR #1156 `a9a44f1985af4f7b4ca3b46b53f26d5c7d90085e`；独立基线 develop `673ddf8cc69d41632f68832a9079385623af7df1`。仅包含本章节职责；验证结果仅适用于以下本地候选，不继承原 PR CI 或其他拆分分支结果。

2026-10-26 本地验证：相对上述基线的源码二进制补丁 SHA-256（scripts / tdesign-component / tdesign-site，不含本记录）为 `0be40213b40d94ea65c94e4e304c9d5ae38e3a9576281c3b475ff006bf7d16f0`。

macOS Flutter 3.32.0 / 3.47.7：Example 严格分析均无诊断，Theme 非 Golden 功能测试各 17/17，包含新增的不等长、稀疏/别名、空色板 3 项；3.32.0 工具与调度器自测 41/41。示例片段从实际源码重新生成，--check 通过。Linux amd64 / Flutter 3.32.0：现有 Theme 测试文件 Golden 8/8 精确比对通过，使用 TDESIGN_DEMO_TEST_MODULES=false；未修改任何基线或容差。页面默认颜色与指南视觉均保持既有基线。

设备上的色板与代码面板仍未人工验证，见 tasks.md；未推送、未执行本分支远端 CI。

### 2026-10-26 在线站点运行检查

运行候选为 PR #1206 `b85ebcfab1b26b7913da4ad20b2d82a49978b140`，使用其 CI 在线预览的 Theme 页面。本轮为真实浏览器运行检查；用户澄清验收对象为站点展示，未连接手机，不记为手机实机验收。

通过站点既有同源主题消息通道加载[测试配置](./evidence/functional-palette-browser-theme.json)，未修改预览源码。浅色、深色均显示新增业务色、稀疏键 brandColor12 和别名 brandAlias；四类功能色实际数量为 20/16/16/16，没有旧的数量不等提示，别名与目标同色。站点代码面板正常展示真实生成片段，包含导入、实际键名与 entries.length。空配置沿用聚焦 Widget 测试结果，本轮没有声称完成其浏览器检查。检查后重新加载预览，撤销临时主题配置。

运行观察以结构化记录为准，未更新任何 Golden 基线或修改运行源码；此前源码候选的 CI 已完成，新增证据提交的 CI 按最终 head 单独核对。


### 2026-10-26 条目收集精简复核

移除中间 colors Map，先按固定分类筛选候选键，再解析非空颜色并直接生成 MapEntry。保留当前/默认/引用键集合、分类及组内顺序和渲染方式，不新增辅助类。示例片段从源码重新生成。

相对 develop 673ddf8cc69d41632f68832a9079385623af7df1 的源码二进制补丁 SHA-256（scripts / tdesign-component / tdesign-site，不含本记录）为 `e7450afca3330fca46257521c16a139f47111d39bbffc162b9a757e47394a96a`。Flutter 3.32.0 / 3.47.7 严格分析无诊断，Theme 非 Golden 功能测试各 17/17；片段生成及 --check 通过，站点片段测试 7/7，57 页/360 示例映射通过。Linux Flutter 3.32.0 现有 Golden 8/8 精确比对通过，未更新基线或容差。此前浏览器截图继续绑定原运行候选；本轮通过功能及像素比对验证行为和默认视觉保持一致，未声称重新执行在线浏览器验收。远端 CI 按最终提交另行核对。


## 可运行接入指南

来源 PR #1156 `a9a44f1985af4f7b4ca3b46b53f26d5c7d90085e`；独立基线 develop `673ddf8cc69d41632f68832a9079385623af7df1`。仅包含本章节职责；验证结果仅适用于以下本地候选，不继承原 PR CI 或其他拆分分支结果。

2026-10-26 本地验证：相对上述基线的源码二进制补丁 SHA-256（scripts / tdesign-component / tdesign-site，不含本记录）为 `bbd439ebc56f2b9be5c50892cb6f55dba3be1383270cc665a5ac77efbbbf5867`。

macOS Flutter 3.32.0 / 3.47.7：Example 严格分析均无诊断，文档示例与 Theme 非 Golden 功能测试各 20/20；3.32.0 回归清单、覆盖率 runner、视觉 runner 和示例生成器自测 41/41，生成片段 --check 通过。Node 24.22.1：站点测试 39/39，57 页/360 示例映射、8 份同步输出检查及生产构建通过。Linux amd64 / Flutter 3.32.0：主题与指南 Golden 14/14 精确比对通过，使用 TDESIGN_DEMO_TEST_MODULES=false；未运行更新基线命令，未修改容差。视觉结论仅对应上述来源候选。

上述检查点尚未执行指南浏览器交互；后续验证及修复见下文。移动设备验收与本分支远端 CI 当时均未执行。


### 2026-10-26 浏览器交互与预览刷新复核

基线仍为 `673ddf8cc69d41632f68832a9079385623af7df1`；本轮最终源码补丁 SHA-256（scripts / tdesign-component / tdesign-site，不含 Spec）为 `faa8ca5a5c3be612c56fc20d5cde99d1a04ccf8d6fc8fb32c81da319a960e4e9`。本地发布构建使用 Flutter 3.47.7，禁用 Web 资源 CDN，挂载于 http://127.0.0.1:19117/flutter/；最终 main.dart.js SHA-256 为 `e2c55e167f28ceb16691d177658212816aaced22b4aa24949b05b96741bf2b90`。测试使用本机内置浏览器和当前分支生产站点，不连接已发布的 Flutter Demo。

- 发现并修复主题指南的实际刷新缺陷：内层带 home 的 MaterialApp 创建 Navigator，挂载时将 iframe 地址覆盖为首页，刷新后落到组件清单。局部应用改为 builder 渲染内容，保留主题、本地化和字体环境，路由由 Example 宿主唯一管理；完整可复制应用的 documentationThemeApp 用法不变。新增宿主导航所有权回归，覆盖完整指南及 JSON / local / mode 三个独立场景。
- 快速开始：实际点击计数增加；站点切换浅深色时计数保持。主题工具选择非默认腾讯云配色，浅色 `#006eff`、深色 `#2684ff`。在两种模式下只刷新 iframe，宿主 loader ID 均不变、iframe loader ID 变化，重新启动的计数为 0，当前外观及非默认配色恢复。
- 主题指南：默认/业务主题可切换；业务主题浅色为 green / `#16875D`、深色为 greenDark / `#56C08D`。输入“浏览器验证”及保存操作在站点明暗切换时保持。修复后的浅深色 iframe 刷新均保留 `#custom-theme` 路由，恢复对应主题，不再进入组件清单。临时输入、保存及选择跨刷新重新初始化，不承诺持久化。独立 JSON / local / mode 场景刷新后均保留原 hash；浅色、深色及跟随系统的实际文案与配色正确。
- 共享预览：从指南离开再进入可以挂载；Button 组件页沿用同一预览组件，非默认配色下刷新仍保留 `#button` 路由和当前外观。
- 国际化：仓库外临时入口直接调用本分支 runLocaleApp，浏览器实际完成“确认 → Confirm → 确认”。资源主题入口直接调用 runThemeApp，实际加载 assets/custom_theme.json 并渲染业务主题按钮；没有为截图手写平行实现。
- 390px 桌面浏览器视口仿真：正文右侧预留归零，document scrollWidth 374px，不超过 390px 视口。检查后清除视口仿真，并恢复本地站点默认配色；不将该结果记为移动设备验收。
- 修复后 Flutter 3.32.0 / 3.47.7 严格分析均无诊断；功能测试各 21/21；工具自测 41/41、示例片段 --check、站点测试 39/39、57 页/360 示例映射、8 份同步输出和生产构建通过。Linux Flutter 3.32.0 Golden 14/14 精确比对再次通过，未更新基线或容差。

结构化观察保留原候选与运行范围，页面截图不作为长期附件。浏览器的外部页面装饰连接出现 Failed to fetch 日志；未验证其线上服务，不据此声称全站外部服务已通过。本轮只补充本机浏览器证据，未执行其他浏览器、真机、发布部署或远端 CI；这些范围见 tasks.md。


主题指南刷新结论见本节文字及下节结构化记录，不归档页面截图。


### 2026-10-26 PR #1204 在线预览及独立应用复验

运行源码 `e5bf6372351b15ce2e73e259bd05a42743fe3eaa`；[在线预览](https://preview-pr-1204-40282739968-1-tdesign-flutter.surge.sh/flutter/custom-theme) 的部署任务 40282739968 明确下载构建任务 40282176943 的产物，该构建 head 与上述提交一致。

- 在线快速开始按钮实测 0 → 2。主题指南在浅深色下分别只刷新 iframe；宿主 loader 不变、iframe loader 变化，实际地址均保留 `#custom-theme`，对应恢复 green / `#16875D` 与 greenDark / `#56C08D`。
- Flutter 3.32.0 从同一源码重新构建独立入口，直接调用 `runLocaleApp` 与 `runThemeApp`。国际化完成“确认 → Confirm → 确认”；资源主题成功加载项目 JSON 并渲染主题按钮，未手写平行应用。国际化指南本身没有内嵌预览，不将本地独立应用写成线上页面交互。
- [结构化运行记录](./evidence/pr1204-browser-observations.json)保留计数、浅深色刷新、语言切换及资源主题的实际观察；不归档页面截图。

该源码提交的远端构建及相关检查已通过。原候选的证据补充未改变运行源码、生成片段或 Golden 基线；复用上文同一源码的双版本与 Golden 检查。本轮为桌面浏览器验证，未执行移动设备或其他浏览器验收；证据提交的新 head CI 需另行核对。

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

## 2026-10-26 PR #1202 拆分后的站点修复验证

基线 develop `920babc94ff62b822c4c093a35cba016bfc243d9`；站点源码补丁 SHA-256 `257a952a48f81113547eced6614cd8ae1ef4bcc8c9c6be49904450ab312fb42e`。本 PR 只保留主题初始化、默认 CSS 提取、锚点展开与路由历史恢复；迁移正文、消费示例和专属文档布局移至独立文档 PR，不在本分支重复维护。

现有本地 Node 工具直接执行正式测试文件与构建入口：54/54 测试、57 页/360 示例映射、8 份文档同步、生产构建及差异检查通过。包管理器自动安装因 registry 请求失败及无交互终端未启动，未将其记作项目测试失败。未重新执行 Flutter、Golden、设备或完整浏览器矩阵；本次范围仅为站点源码，远端 CI 按最终提交核对。


## 2026-10-26 独立迁移指南整理

本次文档基于 develop `920babc94ff62b822c4c093a35cba016bfc243d9`，不依赖 #1202，不修改站点依赖、主题初始化、Vue Router 或历史状态机。组件对照采用六组直接可见的三列表格，旧类型附录保留原生折叠；保留 57 个组件、388 项映射、12 段示例及原有显式锚点。

历史浏览器记录：[逐项链接清单](./evidence/pr1202-migration-compact-browser.json)、[原候选指纹](./evidence/pr1202-migration-compact-summary.json)、[正式官网 HTTP 记录](./evidence/pr1202-migration-official-http.json)。这些记录绑定拆分前候选及当时布局，不表示本次独立分支已通过，也不将 HTTP 200 作为浏览器渲染证明。当前分支验收单独记录。

本地独立验证：按 develop 原始锁文件冻结安装，实际使用 theme-generator 1.2.7 / site-components 0.18.1；站点测试 42/42、57 页/360 示例映射、8 份文档同步和生产构建通过。独立迁移消费者在 Flutter 3.32.0 / 3.47.7 严格分析均无诊断，测试各 24/24。

生产构建浏览器逐项检查 469 处页内链接，以及 60 个不同的跨页/API 目标；链接落点和对应正文均可用。六组表格行数为 1/6/8/16/15/11，附录为 388 行，目录为 14 项；附录手动展开后表内链接返回直接可见的组件行。刷新直接进入组件锚点时，通过文档空锚点布局留出与当前站点组件一致的 120px 空间，不修改 Vue Router；页面截图仅存本地临时目录，不加入 Spec。

这些结果只覆盖本地桌面生产预览及列明的测试，不承诺现有站点的折叠历史恢复、手机适配或正式部署。前进后退和通用异步导航问题仍由 #1202 单独跟进。本次未运行完整组件/Golden/设备矩阵，远端 CI 按最终提交核对。

与同一 develop 基线的独立 #1208 清理提交经 git merge-tree 检查可干净组合；组合树的站点、组件及文档源码与本候选相同。两个 PR 可分别合入，不需要先合并 #1202。

## 2026-10-26 迁移验证项目移至仓库级目录

将原 `tdesign-component/tool/fixtures/token_migration/` 与运行器移至 `scripts/fixtures/token_migration/`、`scripts/run_migration_consumer.dart`；同步临时消费者的组件依赖路径、文档生成器、测试夹具、工具共用入口和 CI 路径过滤。历史附件中的旧路径仍按其原候选解释，不改写历史指纹。

当前本地：站点与工具入口测试合计 46/46、生产构建和 8 份文档同步检查通过；迁移正文与包内副本逐字节不变。Flutter 3.32.0 经 GitHub/CNB 共用 shell 入口、3.47.7 经仓库根目录直接运行入口，严格分析均无诊断，测试各 24/24。消费示例和测试内容未因搬迁改变，组件公开入口及 Golden 未改动。远端检查按本次推送后的最终提交重新核对。

## 2026-10-27 目录命名与测试职责收敛

去除 fixtures 中间层，项目与包名统一为 scripts/migration_consumer / tdesign_migration_consumer。文档唯一示例源命名为 lib/guide_examples.dart，公开参数替代示例命名为 lib/public_api_examples.dart；测试按 guide_examples_test 与 public_api_usage_test 区分。根目录运行入口及 GitHub/CNB 的共用命令不变，更新引用、组件依赖相对路径与 CI 过滤。

运行时用例由 24 项收敛到 16 项：4 项以构造或属性读取为主的检查转为静态编译示例；Text/Avatar/Tag 的 3 项重复样式用例交由已有组件回归，Calendar/DatePicker 仅挂载无异常的用例由静态示例及既有组件/Demo 覆盖。保留 12 项直接调用指南函数的交互组合，以及 4 项 Theme 链、TabBar、Popover、Popup 的独立消费契约；SwipeCell 参数互斥仍由现有组件测试覆盖。

Flutter 3.32.0 / 3.47.7：严格分析均无诊断，运行时测试各 16/16；3.32.0 经 CI 共用入口、3.47.7 经根目录直接入口验证。本地站点及工具入口 46/46 测试、57 页/360 示例映射、8 份文档同步与生产构建通过，迁移正文和包内副本逐字节不变。临时负向对照为未被调用的公开参数示例加入不存在的参数，静态分析按 undefined_named_parameter 拒绝，说明删除构造数量测试后签名检查仍生效；负向样本不进入仓库。未改组件实现或 Golden。


### 迁移示例归属 Example（2026-10-27）

迁移示例唯一源移至 `tdesign-component/example/lib/migration_examples.dart`（SHA-256 `e91197549ff82570e5ffc7b0188d7617a89f8bdfeba089b42699aeab78eafc37`），内容与移动前一致。文档生成直接读取该文件；仓库级验证运行器复制同一文件到临时消费者，不保留第二份源码。同步测试名称、说明和文档 CI 路径过滤。

本地 Flutter 3.32.0 / 3.47.7 独立消费者严格分析及各 16 项测试通过；3.32.0 使用共用工具入口，并额外确认 Example 自身配置下该文件分析无诊断。Node 46 项测试、57 页/360 示例映射、8 份文档同步和站点生产构建通过，迁移正文及包内副本逐字节不变。此次为目录与引用整理，未重复执行浏览器链接或完整组件/Golden/设备矩阵。


### 仓库级测试目录归并（2026-10-27）

在 `2d5eca2f42f498a354a9da393cbe27687a07b1d2` 上将脚本测试移至 `test/scripts/`、独立消费者移至 `test/migration_consumer/`；测试输入、断言及 Example 源码不变，脚本仍在 `scripts/`。同步路径定位、CI 过滤和当前文档引用，脚本测试额外确认新测试目录与迁移运行入口确实被调度。

本地通过共用入口执行 7 项脚本测试及 Flutter 3.32.0 / 3.47.7 严格分析、各 16 项消费者测试；另通过 42 项站点测试、8 份文档同步、57 页/360 示例映射与文档相对链接检查。联网依赖解析等待未完成，双版本重跑使用临时适配仅为 pub get 添加 --offline，其余入口和测试不变。指南与包内副本逐字节不变；未重复浏览器、构建或完整组件/Golden/设备矩阵。

运行器聚合补充：在 `3abf5810e107e87ddb320ca26a492e1d765dd06e` 上将专用运行器移入 `test/migration_consumer/run.dart`，从自身目录定位仓库，仅复制 pubspec、分析配置、lib/test 与 Example 示例。运行器 SHA-256：`fb3739b8e43b534284de2ae5d9480a5a04edfd9dccda7c43fad51077cac81a76`。共用入口的 7 项脚本测试及 8 份文档同步通过；Flutter 3.32.0 经共用入口、3.47.7 从仓库外目录直接运行，使用缓存依赖的严格分析与各 16 项测试通过。指南源码及测试用例不变；本补充未重跑站点构建或浏览器。

### 2026-10-27：复用公共定位并精简导航

基线 develop 8bd4605c0760d968ac20f4eec9ff4fb6bb095fc5；相对该基线的站点二进制补丁 SHA-256（git diff --binary --no-ext-diff origin/develop -- tdesign-site）为 a18cca8c8a84774a25330d18e7e51c7f79d8eb8385853e10a1ca01bb316bf03a。合入最新迁移指南后，正文及组件源码与 develop 一致，不回退 #1210 或 #1203。

对照 Tencent/tdesign main 41ae3ff8c4f20a9863edfbac70d5b652c982f210 的 td-doc-content：首次加载和标题点击的定位由公共组件负责；本分支只补 Vue Router 正文就绪、实际折叠展开和独立历史条目恢复。移除旧分组的相邻空锚点猜测、额外 80px 滚动偏移和重复 CSS，精简等待回调。附录仍消费 data-expand-details，保留该最小关联。运行源码与相应测试净减少 39 行，移除的两项测试只验证已删除的旧分组兼容。

Node 24.15.0：主题/导航 22/22、站点文档 33/33，共 55/55；57 页/360 示例映射、8 份文档同步、生产构建与 diff 检查通过。

本地生产预览：普通 Icon 锚点不追加偏移，锚点盒顶部 0、可见内容顶部 123.5px；附录自动展开，标题顶部 184px。原生重复点击同一附录 hash，在手动收起后重新展开并定位；组件默认与既有文档间距仍生效。对同一无 hash URL 创建 A（附录展开、27966.5px）和 B（附录收起、0px）两次访问，后退 B、后退 A、前进 B 的折叠与滚动值分别完全恢复。

本轮未执行真机、完整浏览器矩阵或 Golden；原候选截图和旧 80px 观察不外推到本次精简版本。最终远端 CI 按新 head 独立核对。

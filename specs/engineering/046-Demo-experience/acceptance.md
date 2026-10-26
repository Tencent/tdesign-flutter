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

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

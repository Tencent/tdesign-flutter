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

## 2026-10-23 residual guide and navigation verification

Base: `182f8cd956edeee4dfd7ef977176309f051e3c3c`. Binary diff SHA-256 (`git diff --binary --no-ext-diff origin/develop -- scripts tdesign-component tdesign-site`): `46125980f83eff49c2a7bac8fd8b99faa58108d91b4b6236811054e2d1a18a87`.

- macOS Flutter 3.32.0 / 3.47.7: Example `flutter analyze --fatal-infos` passed with no diagnostics on both SDKs. `flutter test --no-pub test/documentation_examples_test.dart test/theme/theme_demo_test.dart --exclude-tags golden --reporter expanded`: 23/23 passed on each SDK. Covers counter, asset theme loading, locale switching, default/business themes, token object reuse and unequal/sparse/empty functional palettes.
- Flutter 3.32.0: `dart run tool/generate_example_code.dart --check` passed. Regression/visual runner and snippet generator tests: 36/36 passed. Documentation tests registered in sharedExampleTests; Theme tests retain existing functional/visual scheduling.
- Node 24.15.0: site utility/documentation tests 47/47 passed; npm test:theme and test:example-code passed. Mapping check: 57 pages / 360 examples. Sync check: 8 outputs, zero stale. Vite build passed in 3.64s (existing chunk warning only).
- Linux amd64 local image `tdesign-flutter-golden-cache:3.32.0`: `flutter test --no-pub --dart-define=TDESIGN_DEMO_TEST_MODULES=false test/theme/theme_demo_test.dart --tags golden --reporter expanded`: 14/14 passed with exact pixel comparison; no baseline updates or tolerance changes. First run omitted the debug-module define and two Theme page sizes differed; visual inspection confirmed the extra internal debug section, then the full official configuration passed. Twelve imported guide/counter PNGs were verified on this candidate; the two existing Theme page PNGs were unchanged.
- Canonical migration source, package MIGRATION, component lib and root READMEs match develop; current CSS theme conversion guidance retained. No old Spec directories or historical CI/screenshot evidence imported. Independent of the #1155 cleanup branch. Diff whitespace check passed.
- Browser end-to-end manual interaction, mobile devices, deployment and remote CI were not executed. Navigation is covered by focused unit tests; production site build is not a claim of complete browser acceptance. No push or remote PR mutation.

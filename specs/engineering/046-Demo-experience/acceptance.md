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

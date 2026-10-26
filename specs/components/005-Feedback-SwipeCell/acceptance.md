# SwipeCell 验证范围与结论

<a id="record-005-theme-review-fixes"></a>
<a id="record-007-official-alignment"></a>

## 本次范围

2026-10-20 原记录整理；未重跑组件、Golden、设备或远端CI。以下结论仅限原候选与范围。

## 已有验证结论

| 原记录范围 | 原文可追溯标识与环境 | 有界结论 |
| --- | --- | --- |
| TSwipeCell 组件 Review 修复 | 未绑定唯一完整候选 SHA；Flutter 3.32.0 / 3.47.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围） |
| TSwipeCell 官方对齐修复（跨端 Review 结论落地） | 未绑定唯一完整候选 SHA；Flutter 3.32.0 | 组件与布局：未提取到可独立确认的通过结论；Demo 与消费：未提取到可独立确认的通过结论；静态检查：有明确通过记录（限原范围） |

各标识可能对应不同阶段，不能合成一次完整验证；候选或日志缺失时仍需复核。

## 验证范围与未覆盖项

以下保留各事项原有的文字验收结论与未覆盖项。本次未重新执行组件验收；历史截图及独立对比附件已移除。

## 必要证据与追溯

未绑定唯一候选的结果不作为当前通过证明；旧命令与流水由Git历史追溯。

当前待办见 [tasks.md](./tasks.md)；实际执行入口见[贡献规范](../../../CONTRIBUTING.md#组件测试与-ci-回归门禁)。清理不关闭未完成项。

## 1.0.1 controller-binding 验收

- 重复绑定仍抛 FlutterError；替换失败后原 Controller 可继续控制，卸载按实际绑定对象清理。
- 本组公开 API 签名及默认值未变，不包含 API 别名或废弃迁移。
- 原独立候选 `58cb2736`：Flutter 3.32.0 / 3.47.7 的本组件生产覆盖率均为 304/315 = 96.51%；原始结果见[验证数据](../001-Feedback-DropdownMenu/evidence/1.0.1-independent.json)。
- 整组验证环境、命令、指纹及本次补充回归结果统一记录在 [DropdownMenu 验收记录](../001-Feedback-DropdownMenu/acceptance.md#controller-binding-validation)，不以原候选结果替代新候选验证。

中文 API 注释及生成文档已补充推荐用法与原有绑定规则；本轮文档、字体覆盖及静态分析结果见[整组验收](../001-Feedback-DropdownMenu/acceptance.md#controller-api-doc-validation)，不改变实现或既有绑定限制。

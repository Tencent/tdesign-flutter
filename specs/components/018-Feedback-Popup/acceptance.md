# Popup 验证范围与结论

<a id="record-018-overlay-config"></a>
<a id="record-019-radius-duration-alignment"></a>
<a id="record-020-demo-alignment"></a>
<a id="record-021-slot-convergence"></a>

## 本次范围

2026-10-20 原记录整理；未重跑组件、Golden、设备或远端CI。以下结论仅限原候选与范围。

## 已有验证结论

| 原记录范围 | 原文可追溯标识与环境 | 有界结论 |
| --- | --- | --- |
| Popup：收敛蒙层散参到 `TPopupOverlayConfig` | 未绑定唯一完整候选 SHA；Flutter 3.32.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：未提取到可独立确认的通过结论；静态检查：有明确通过记录（限原范围） |
| Popup left/right 圆角对齐与动画时长评估 | 未绑定唯一完整候选 SHA；Flutter 3.32.0 | 组件与布局：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：未提取到可独立确认的通过结论；设备：仅按下文的实际操作与未覆盖范围解释 |
| Popup 公开 Demo 对齐 | `b60cdc8a1dce1f06dd45cb4e41eefd31c674e514`、`b5415f7244f468d19a4bd29f04e5c4412f189486`、`1c5ac0cc33bba821f2d831afe417e44de69fe7e8`；Flutter 3.32.0 / 3.47.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围）；设备：仅按下文的实际操作与未覆盖范围解释 |
| Popup 内容插槽收敛 | 未绑定唯一完整候选 SHA；Flutter 3.32.0 | 组件与布局：有明确通过记录（限原范围）；Demo 与消费：有明确通过记录（限原范围）；静态检查：有明确通过记录（限原范围）；Golden：有明确通过记录（限原范围） |

各标识可能对应不同阶段，不能合成一次完整验证；候选或日志缺失时仍需复核。

## 验证范围与未覆盖项

以下保留各事项原有的文字验收结论与未覆盖项。本次未重新执行组件验收；历史截图及独立对比附件已移除。

## 必要证据与追溯

未绑定唯一候选的结果不作为当前通过证明；旧命令与流水由Git历史追溯。

当前待办见 [tasks.md](./tasks.md)；实际执行入口见[贡献规范](../../../CONTRIBUTING.md#组件测试与-ci-回归门禁)。清理不关闭未完成项。

## destroyOnClose 独立修复候选

基线 develop `3704434fd2adfb6988110bc760aaaa52a814581c`，分支 `rss1102/fix/popup-destroy-on-close`；本轮源码指纹 `2488ca62bad4cc0b2736dfdbb45d82e9dcbbc79f4477757790bcdce9f45ed7ad`。完成内部承载重构，并修复 LocalHistoryEntry 消费返回后移除及声明式页面替换导致 State 丢失；路由上下文、语义及正常 pop 动画边界均有正式回归。两版全部登记组件各 3969 项、示例/API/代码面板各 98 项、工具与字体覆盖各 171 项通过；严格分析、57 份 API 和片段校验通过，相关生产覆盖率均超过 95%。本次修复范围最终复审无阻塞项，零动画 onClosed 历史问题不纳入；详见[本轮验收](./evidence/destroy-on-close.md)。

公开签名、默认 false 和 Controller 规则保持；关闭后资源保留时机按需求修正，不能声明生命周期全兼容。丢弃句柄可能保留到 Navigator 卸载；根 Navigator 可长期存在，业务定时器/订阅不保证暂停。不新增公开宿主或 dispose。只完成本地验收，未推送、创建 PR、合并或验证真机/Web release；未修改 Golden 基线。

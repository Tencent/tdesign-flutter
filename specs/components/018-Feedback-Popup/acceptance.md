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

公开签名、默认 false 和 Controller 规则保持；关闭后资源保留时机按需求修正，不能声明生命周期全兼容。丢弃句柄可能保留到 Navigator 卸载；根 Navigator 可长期存在，业务定时器/订阅不保证暂停。不新增公开宿主或 dispose。本地验收不替代远端 CI；独立 PR 的交付及检查状态以最终 head 为准，暂不合并。未验证真机/Web release，未修改 Golden 基线。

## 1.0.1 蒙层配置源码 breaking 候选

初始基线 develop 3704434f，当前基线 develop 264fc582；独立候选结果、FAQ 修正及 onClick 废弃兼容的双版本复验见 [配置设计验收](./evidence/overlay-final.md)。此前 onTap 兼容别名或 destroyOnClose 分支结果不作为当前候选证据。


## 同步最新 develop 的阶段候选（历史）

已同步 develop fabe5f6b（含 #1199）。冲突解决后两 SDK 各 4026 项登记组件、98 项受影响示例、176 项工具检查通过，严格分析零诊断，57 份 API/示例片段检查与相关覆盖率门禁通过。当前输入指纹及执行范围见[同步后的验收](./evidence/destroy-on-close.md#同步-develop-fabe5f6b-后的当前验收)；上文原基线结果仅作历史追溯，不代替此次候选。

## 当前候选：Drawer 保持历史关闭与遮挡规则

Drawer 单独保持 1.0.0 的关闭释放/遮挡规则，默认 false，未新增公开 API；Popup/Picker 保持现有同句柄保留策略。新增 24 项 Widget 与 1 项包入口消费者回归，原有边界测试保留；相同 21 项 Drawer 用例在 v1.0.0 原始源码上通过双版本对照。两 SDK 当前完整组件各 4050、示例/API 各 98、工具字体各 177 项通过，严格分析、API/片段生成、相关覆盖率通过；输入指纹、范围与局限见[当前验收](./evidence/destroy-on-close.md#drawer-历史生命周期保持后的当前验收)。

本地复审无阻塞项：Drawer 不再保留不可重开的内容，API、默认值、回调和 Controller 规则保持；Popup/Picker 的生命周期 breaking 风险仍须保留。历史章节的 Drawer 保留成本不再描述当前实现。推送后 CI/Review 另按最终 head 核对，暂不合并。

## 当前补充：替换会话的资源复用边界

基于 474cc674 仅补齐 FAQ、Spec 和 12 项正式测试，生产源码与生成 API 均未改变。默认 false 关闭后 GlobalKey/Controller 仍可能被保留内容使用；同句柄 open、独立资源替换和 true 卸载后转交均有实际入口回归，非法复用边界在双 SDK 中精确验证。两版各 473 项受影响组件、98 项示例/API、177 项工具/字体通过，严格分析零诊断、API/片段同步及三组件覆盖率门禁通过。输入指纹、范围差异与资源风险见[当前验收](./evidence/destroy-on-close.md#替换会话资源复用边界的当前验收)。

本轮本地 Review 无阻塞项；不扩大实现，不把 Controller 所有权规则不变写成关闭后必定解绑，保持 Drawer 原规则。远端结果绑定推送后的 head，暂不合并。

## 当前文档补充：FAQ 精简与跨组件指引

基于 1c7a3d45，仅修改四组件 FAQ 与 Spec；生产实现、API、默认值、正式测试、字体、Drawer 规则及站点导航代码未变。Popup 保留批准的精简文本，Picker/DateTimePicker 采用简短提示和精准链接，ActionSheet 单独注明三个入口未暴露 destroyOnClose，详细边界与间接影响留在 Spec。

两 SDK 各 57 份 API 同步、70 项 API 文档渲染及 14 项字体/清单检查通过；站点 Node 35 项和映射检查通过。本地浏览器四页实看及三个跨页链接验证通过，目标标题未被固定栏遮挡。输入指纹、渲染范围和行为证据复用边界见[本轮文档验收](./evidence/destroy-on-close.md#faq-精简与跨组件指引的当前验收)。本地文档 Review 无阻塞，生命周期 breaking 与 ActionSheet 参数限制仍明确保留；远端 CI 按新 head 核对，不合并。


## 当前文档补充：Popup 前两问 FAQ

基于 7d12c630 仅精简 Popup 前两问及整理 Spec，保留版本、final 源码风险、onTap/onClick 优先级及 open/show 正确用法，第三问与跨组件链接不变。两 SDK 各 57 份 API、70 项 API 渲染、14 项字体/清单检查通过，站点 Node 35 项及映射检查通过，真实浏览器已核对本地显示。生产实现、API、默认值、回调、Controller 和 Drawer 规则均未变。

输入指纹及范围见[本轮验收](./evidence/destroy-on-close.md#popup-前两问-faq-精简的当前验收)。本轮文档 Review 无阻塞，不重复运行未变组件或 Golden，不把历史功能结果或旧 CI 当作新 head 验收；远端 CI/Review 单独核对，暂不合并。

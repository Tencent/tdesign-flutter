# Message 实施方案

## 实现组织

声明式条件组合决定是否挂载；action 使用 Widget，自行持有交互，不增设消息专属链接模型。

未传 offset 的连续命令展示替换已有消息；需要并存时显式表达位置，避免隐式重叠。

## 影响范围

| 范围 | 实际入口 | 维护要求 |
| --- | --- | --- |
| 生产实现 | [tdesign-component/lib/src/components/message](../../../tdesign-component/lib/src/components/message) | 按 spec.md 的最终方案维护配置、状态和布局 |
| 测试与消费者 | [tdesign-component/test/components/message](../../../tdesign-component/test/components/message) | 对默认、覆盖、重建和直接组合消费者补充真实断言 |

## 实施顺序与验证

1. 先明确最终方案、接口变化与调用方边界；新增设计决策回写 spec.md。
2. 同步实现、公开注释、消费示例和测试；生成物只从源码生成。
3. 围绕该职责的默认、显式配置、状态变化、异常与生命周期做真实验证；按适用范围执行双 SDK、Golden、设备或交付检查。
4. 结果绑定候选、环境和必要证据，更新 acceptance.md；真实剩余工作只在 tasks.md 维护。

本次文档整理不执行上述实现或候选验收，不据旧命令流水推定当前检查通过。


## 1.0.1 overlay-lifecycle

仅修改本分支所属组件生产实现及已登记回归文件，保留既有 API、默认行为及 Controller 绑定规则。直接基于最新 develop 独立验证，不依赖其他修复分支。按实际 CI manifest 执行相关组件、示例非视觉测试及调度器自测；双 SDK 分别解析依赖、严格 analyze、生产覆盖率检查和生成器一致性检查。API 别名、废弃声明等 PR 5 内容不纳入。

# ActionSheet 实施方案

## 实现组织

fixed/paged/scroll 互斥布局各自持有有效参数，选择回调返回稳定业务项而非易变全局索引。

徽标按真实槽位锚定；count/rows 决定网格，不增加没有设计场景的 group 或空项占位 API。

## 影响范围

| 范围 | 实际入口 | 维护要求 |
| --- | --- | --- |
| 生产实现 | [tdesign-component/lib/src/components/action_sheet](../../../tdesign-component/lib/src/components/action_sheet) | 按 spec.md 的最终方案维护配置、状态和布局 |
| 测试与消费者 | [tdesign-component/test/components/action_sheet](../../../tdesign-component/test/components/action_sheet) | 对默认、覆盖、重建和直接组合消费者补充真实断言 |

## 实施顺序与验证

1. 先明确最终方案、接口变化与调用方边界；新增设计决策回写 spec.md。
2. 同步实现、公开注释、消费示例和测试；生成物只从源码生成。
3. 围绕该职责的默认、显式配置、状态变化、异常与生命周期做真实验证；按适用范围执行双 SDK、Golden、设备或交付检查。
4. 结果绑定候选、环境和必要证据，更新 acceptance.md；真实剩余工作只在 tasks.md 维护。

本次文档整理不执行上述实现或候选验收，不据旧命令流水推定当前检查通过。

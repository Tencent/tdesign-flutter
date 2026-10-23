# Form 实施方案

<a id="record-008-input-contract-alignment"></a>
<a id="record-039-design-details"></a>

## 实现组织

TForm 管生命周期，TFormField 管受控字段和校验，TFormItem 管布局，Input/Textarea 管编辑。

父级拥有受控值；清除校验不改值，reset 不写回过期初值，避免表单操作破坏业务状态。

## 影响范围

| 范围 | 实际入口 | 维护要求 |
| --- | --- | --- |
| 生产实现 | [tdesign-component/lib/src/components/form](../../../tdesign-component/lib/src/components/form) | 按 spec.md 的最终方案维护配置、状态和布局 |
| 测试与消费者 | [tdesign-component/test/components/form](../../../tdesign-component/test/components/form) | 对默认、覆盖、重建和直接组合消费者补充真实断言 |

## 实施顺序与验证

1. 先明确最终方案、接口变化与调用方边界；新增设计决策回写 spec.md。
2. 同步实现、公开注释、消费示例和测试；生成物只从源码生成。
3. 围绕该职责的默认、显式配置、状态变化、异常与生命周期做真实验证；按适用范围执行双 SDK、Golden、设备或交付检查。
4. 结果绑定候选、环境和必要证据，更新 acceptance.md；真实剩余工作只在 tasks.md 维护。

本次文档整理不执行上述实现或候选验收，不据旧命令流水推定当前检查通过。

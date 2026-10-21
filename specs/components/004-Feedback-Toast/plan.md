# Toast 实施方案

<a id="record-004-contract-alignment"></a>
<a id="record-006-overlay-config-and-placement"></a>
<a id="record-054-overlay-pointer"></a>

## 实现组织

全部入口使用同一时长规则，零或负时长表示持续展示；取消特殊无限常量，减少两套生命周期语义。

遮罩可见性与背景交互独立；同 ID 替换避免叠加变暗，不同 ID 仍可并存。

## 影响范围

| 范围 | 实际入口 | 维护要求 |
| --- | --- | --- |
| 生产实现 | [tdesign-component/lib/src/components/toast](../../../tdesign-component/lib/src/components/toast) | 按 spec.md 的最终方案维护配置、状态和布局 |
| 测试与消费者 | [tdesign-component/test/components/toast](../../../tdesign-component/test/components/toast) | 对默认、覆盖、重建和直接组合消费者补充真实断言 |

## 实施顺序与验证

1. 先明确最终方案、接口变化与调用方边界；新增设计决策回写 spec.md。
2. 同步实现、公开注释、消费示例和测试；生成物只从源码生成。
3. 围绕该职责的默认、显式配置、状态变化、异常与生命周期做真实验证；按适用范围执行双 SDK、Golden、设备或交付检查。
4. 结果绑定候选、环境和必要证据，更新 acceptance.md；真实剩余工作只在 tasks.md 维护。

本次文档整理不执行上述实现或候选验收，不据旧命令流水推定当前检查通过。

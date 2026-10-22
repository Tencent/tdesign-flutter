# Popup 实施方案

<a id="record-018-overlay-config"></a>
<a id="record-019-radius-duration-alignment"></a>
<a id="record-020-demo-alignment"></a>
<a id="record-021-slot-convergence"></a>

## 实现组织

蒙层行为用配置对象收敛；透明度由最终 Color 表达，不再与第二个 opacity 相乘。

bottom 只提供 headerBuilder，center 只提供 closeBuilder；按钮业务回调由调用方持有。

## 影响范围

| 范围 | 实际入口 | 维护要求 |
| --- | --- | --- |
| 生产实现 | [tdesign-component/lib/src/components/popup](../../../tdesign-component/lib/src/components/popup) | 按 spec.md 的最终方案维护配置、状态和布局 |
| 测试与消费者 | [tdesign-component/test/components/popup](../../../tdesign-component/test/components/popup) | 对默认、覆盖、重建和直接组合消费者补充真实断言 |

## 实施顺序与验证

1. 先明确最终方案、接口变化与调用方边界；新增设计决策回写 spec.md。
2. 同步实现、公开注释、消费示例和测试；生成物只从源码生成。
3. 围绕该职责的默认、显式配置、状态变化、异常与生命周期做真实验证；按适用范围执行双 SDK、Golden、设备或交付检查。
4. 结果绑定候选、环境和必要证据，更新 acceptance.md；真实剩余工作只在 tasks.md 维护。

本次文档整理不执行上述实现或候选验收，不据旧命令流水推定当前检查通过。

## 文字槽布局回归修复

内部 TToolbarPressable 接入文字槽主题时，原生 Text 保留 DefaultTextStyle 的局部合并与段落参数；TText 继续隔离外层 Material 默认样式，并保留显式样式优先。

在 Flutter 3.32.0、3.47.7 验证回归与组件测试，并以独立渲染产物比较修复前后；不更新现有 Golden 基线。

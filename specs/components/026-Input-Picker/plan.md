# Picker 实施方案

<a id="record-026-demo-alignment"></a>
<a id="record-043-popup-layout"></a>

## 实现组织

Picker 是严格受控的平铺面板；Popup/Header 和业务草稿由调用方组合。

接受回传时保留未受影响列的控制器；拒绝候选后停止滚动再回滚，平衡受控一致性与惯性体验。

## 影响范围

| 范围 | 实际入口 | 维护要求 |
| --- | --- | --- |
| 生产实现 | [tdesign-component/lib/src/components/picker](../../../tdesign-component/lib/src/components/picker) | 按 spec.md 的最终方案维护配置、状态和布局 |
| 测试与消费者 | [tdesign-component/test/components/picker](../../../tdesign-component/test/components/picker) | 对默认、覆盖、重建和直接组合消费者补充真实断言 |

## 实施顺序与验证

1. 先明确最终方案、接口变化与调用方边界；新增设计决策回写 spec.md。
2. 同步实现、公开注释、消费示例和测试；生成物只从源码生成。
3. 围绕该职责的默认、显式配置、状态变化、异常与生命周期做真实验证；按适用范围执行双 SDK、Golden、设备或交付检查。
4. 结果绑定候选、环境和必要证据，更新 acceptance.md；真实剩余工作只在 tasks.md 维护。

此前文档整理不代表实现验收；本轮文字槽实现与本地验证见后文和 acceptance.md，不据旧命令流水推定当前检查通过。

## 文字槽一致性

复用同方向/状态内置文案的解析结果提供 TTextStyleScope；不更改全局 TText。回归覆盖原生/TText、布局包装、显式样式、内部局部主题、明暗、文字缩放及各自状态/布局边界。双版本功能检查通过后运行已有视觉入口，前后截图放本地 artifacts，不纳入 Spec 或更新既有基线。

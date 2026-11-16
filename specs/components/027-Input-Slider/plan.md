# Slider 实施方案

## 实现组织

normal/capsule 的轨道与刻度属于组件形态，由组件实现，不由 Demo 局部主题补画。

复用内部几何模型解析可见轨道、thumb 行程、交互尺寸及连续范围间距；保留原生手势识别和受控值。单值拖动按当前几何映射位置；区分可见长度与完整命中布局，不能靠缩短轨道容纳 thumb。

## 影响范围

| 范围 | 实际入口 | 维护要求 |
| --- | --- | --- |
| 生产实现 | [tdesign-component/lib/src/components/slider](../../../tdesign-component/lib/src/components/slider) | 按 spec.md 的最终方案维护配置、状态和布局 |
| 测试与消费者 | [tdesign-component/test/components/slider](../../../tdesign-component/test/components/slider) | 对默认、覆盖、重建和直接组合消费者补充真实断言 |

## 实施顺序与验证

1. 先明确最终方案、接口变化与调用方边界；新增设计决策回写 spec.md。
2. 同步实现、公开注释、消费示例和测试；生成物只从源码生成。
3. 围绕该职责的默认、显式配置、状态变化、异常与生命周期做真实验证；按适用范围执行双 SDK、Golden、设备或交付检查。
4. 结果绑定候选、环境和必要证据，更新 acceptance.md；真实剩余工作只在 tasks.md 维护。

具体执行范围与绑定指纹记录在 acceptance.md；推送后的远端检查独立验证，不从本地结果外推。

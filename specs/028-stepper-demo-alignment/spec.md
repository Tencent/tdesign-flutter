# Stepper 公开 Demo 对齐

## 目标

对齐小程序公开 Demo 的基础、边界、禁用、形态与尺寸矩阵，并建立独立行为与视觉回归。

## API Review

- `value + onChanged` 为严格受控模式；`onChanged == null` 表示整组禁用，不引入 `defaultValue` 或重复的 `disabled`。
- `min/max/step` 负责数值约束，`TStepperVariant` 与 `TStepperSize` 负责互斥视觉语义。
- `variant/size` 的实例值、组件 Theme 与默认值优先级已收敛，无需复制小程序字符串 API。
- 生产组件源码不变，公开 API 无 breaking change。

## 行为契约

- Demo 顺序与公开页面一致。
- 最小/最大状态分别由受控值等于边界表达，禁用由空 callback 表达。
- 所有可交互实例均由页面持有状态。

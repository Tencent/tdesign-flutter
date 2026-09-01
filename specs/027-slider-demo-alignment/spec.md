# Slider 公开 Demo 对齐

## 目标

按小程序公开 Demo 的可见矩阵，对齐单/双游标、数值、非零起点、刻度、禁用、胶囊与垂直示例，并建立独立行为与视觉回归。

## API Review

- `TSlider` / `TRangeSlider` 以值类型区分单值与区间，避免 `range` 布尔参数改变 value 类型。
- `value + onChanged` 遵循 Flutter 受控模式，`onChanged == null` 表示禁用，不引入 `defaultValue`。
- 数值和刻度由 `showThumbValue` / `showScaleValue` 与 formatter 负责；非零起点沿用 `min/max/divisions`。
- 垂直方向由 `RotatedBox` 组合，胶囊外观由 `SliderTheme` 组合；二者不新增与 Flutter 框架重复的 API。

## 行为契约

- Demo 顺序与小程序公开页面一致。
- 所有可交互实例均由页面持有状态；禁用实例 callback 为 null。
- 生产组件源码不变，公开 API 无 breaking change。

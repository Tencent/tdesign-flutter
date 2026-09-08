# Slider 公开 Demo 对齐

## 目标

按小程序公开 Demo 的可见矩阵，对齐单/双游标、数值、非零起点、刻度、禁用、胶囊与垂直示例，并建立独立行为与视觉回归。

## API Review

- `TSlider` / `TRangeSlider` 以值类型区分单值与区间，避免 `range` 布尔参数改变 value 类型。
- `value + onChanged` 遵循 Flutter 受控模式，`onChanged == null` 表示禁用，不引入 `defaultValue`。
- 数值和刻度由 `showThumbValue` / `showScaleValue` 与 formatter 负责；`showThumbValue` 持续显示拇指数值，非零起点沿用 `min/max/divisions`。
- 垂直方向由 `RotatedBox` 组合，胶囊外观由 `SliderTheme` 组合；二者不新增与 Flutter 框架重复的 API。
- 视觉字段按局部 `SliderTheme` > 显式 `ColorScheme` > TDesign token 解析；token 默认提供白色描边 thumb、品牌色轨道、区分前后轨道的禁用色，并以禁用文字 token 绘制禁用态常驻数值。

## 行为契约

- Demo 的 8 个公开区块与内部 19 个 Slider 实例在数量、顺序、类型和默认值上与固定小程序基线一致。
- 所有可交互实例均由页面持有状态；禁用实例 callback 为 null。
- 垂直组合仅旋转轨道和 thumb，数值与刻度文字保持正常阅读方向。
- `TRangeSlider` 在构建时拒绝落在 `min/max` 外的范围值。
- 不新增公开 API；修正既有 `showThumbValue` 语义和默认视觉属于缺陷修复。

# Slider 设计说明

## 背景与目标

以下保留设计形成时的问题与依据；已修复的问题不表示当前代码仍有同一缺陷。

公开示例与默认轨道、刻度和游标几何不一致。


## 范围与非目标

### 目标

按小程序公开 Demo 的可见矩阵，对齐单/双游标、数值、非零起点、刻度、禁用、胶囊与垂直示例，并建立独立行为与视觉回归。

## 最终方案与行为契约

### API Review

- `TSlider` / `TRangeSlider` 以值类型区分单值与区间，避免 `range` 布尔参数改变 value 类型。
- `value + onChanged` 遵循 Flutter 受控模式，`onChanged == null` 表示禁用，不引入 `defaultValue`。
- 数值和刻度由 `showThumbValue` / `showScaleValue` 与 formatter 负责；`showThumbValue` 持续显示拇指数值，非零起点沿用 `min/max/divisions`。
- 垂直方向由 `RotatedBox` 组合，胶囊外观由 `SliderTheme` 组合；二者不新增与 Flutter 框架重复的 API。
- 视觉字段由 TSliderThemeData 覆盖 TDesign Token；外部 SliderTheme 和 ColorScheme 不反向配置；token 默认提供 Gy1 描边 thumb、品牌色轨道、Gy4 未激活轨道、区分前后轨道的禁用色，并以禁用文字 token 绘制禁用态常驻数值。

- Demo 的 8 个公开区块与内部 19 个 Slider 实例在数量、顺序、类型和默认值上与固定小程序基线一致。
- 所有可交互实例均由页面持有状态；禁用实例 callback 为 null。
- 垂直组合仅旋转轨道和 thumb，数值与刻度文字保持正常阅读方向；最小值位于顶部，数值向下递增，与设计稿一致。
- `TRangeSlider` 在构建时拒绝落在 `min/max` 外的范围值。
- 不新增公开 API；修正既有 `showThumbValue` 语义和默认视觉属于缺陷修复。

## 关键决策与取舍

| 决策 | 理由与取舍 |
| --- | --- |
| 采用的方案 | normal/capsule 的轨道与刻度属于组件形态，由组件实现，不由 Demo 局部主题补画。 |
| 保留的边界与代价 | 保留 Flutter 原生手势和受控值，不因视觉对齐扩大组件点击或布局区域。 |

## 兼容性与迁移

本次只整理设计记录，不据此新增 API、改变默认值或判断全部兼容。后续接口删除、类型收紧或默认行为变化按最终源码和迁移指南核对。

## 验收标准

- 默认、显式配置、关键状态与边界行为符合最终方案；功能、视觉和人工路径按适用范围分别验收。

验收标准描述应满足的行为，不表示已执行或通过；执行范围与证据见 [acceptance.md](./acceptance.md)，剩余事项只在 [tasks.md](./tasks.md) 维护。

跨组件配置职责见 [Theme 契约](../../engineering/048-Theme-configuration-contracts/spec.md)，视觉方法见 [Golden 规范](../../engineering/044-Testing-golden-regression/spec.md)。

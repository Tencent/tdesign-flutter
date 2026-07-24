# TSlider - v1.0 定稿

> **状态**：已实现 | **控制类**：C | **Sprint**：S2

**源码路径**：`lib/src/components/slider`

## 架构

| 项 | v1.0 |
|---|---|
| 实现 | Material `Slider` / `RangeSlider` 薄包装 |
| 控制 | `value` + `onChanged`，严格受控 |
| 禁用 | `onChanged: null` |
| Material Theme | `SliderThemeData` 负责轨道、thumb、overlay、刻度与状态颜色 |
| TDesign Theme | `TSliderThemeData` 仅负责 Material 没有的外层 decoration |

## API

### TSlider

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `value` | `double` | - | 受控滑块值 |
| `onChanged` | `ValueChanged<double>?` | - | 值变更；为 null 时禁用 |
| `onChangeStart` | `ValueChanged<double>?` | - | 开始拖动回调 |
| `onChangeEnd` | `ValueChanged<double>?` | - | 结束拖动回调 |
| `min` | `double` | `0` | 最小值 |
| `max` | `double` | `1` | 最大值 |
| `divisions` | `int?` | - | 离散刻度数；null 表示连续 |

### TRangeSlider

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `value` | `RangeValues` | - | 受控范围值 |
| `onChanged` | `ValueChanged<RangeValues>?` | - | 范围变更；为 null 时禁用 |
| `onChangeStart` | `ValueChanged<RangeValues>?` | - | 开始拖动回调 |
| `onChangeEnd` | `ValueChanged<RangeValues>?` | - | 结束拖动回调 |
| `min` | `double` | `0` | 最小值 |
| `max` | `double` | `1` | 最大值 |
| `divisions` | `int?` | - | 离散刻度数；null 表示连续 |

## Theme

`TSliderThemeData.decoration` 用于滑块外层装饰。所有 Material 能表达的视觉均通过 `SliderTheme` 或 `ThemeData.sliderTheme` 配置，不在 TDesign Theme 重复定义。

## 实现约束

- Widget 不维护业务值，不 clamp 外部非法值；构造器以 assert 明确边界契约。
- 单值要求 `min < max` 且 `value` 位于范围内。
- 范围值的边界与 `start <= end` 约束由底层 Material `RangeSlider` 校验。
- 不公开 thumb 点击坐标、运行时测量对象、自定义 Shape 或 Theme 更新回调。
- 不从公共总出口导出内部实现类型。

## 验收

| 项 | 要求 |
|---|---|
| 测试 | 覆盖单值、范围、生命周期、刻度、禁用、边界断言与两层 Theme |
| Golden | 覆盖单值/范围的启用与禁用状态 |
| 文档 | tools 生成 API 说明列不得为 `-` |
| 覆盖率 | 组件源码及各文件不低于 95% |
| API 边界 | 不出现点击事件、位置枚举、胶囊 Shape 或实例 L4 参数 |

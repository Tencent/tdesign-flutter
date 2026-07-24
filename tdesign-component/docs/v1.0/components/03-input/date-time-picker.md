# TDateTimePicker

## 定位

`TDateTimePicker` 是严格受控的日期时间滚轮面板，不包含弹层、工具栏和确认按钮。

## API

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `value` | `TDateTimePickerValue` | 必填 | 受控日期时间值 |
| `mode` | `DateTimePickerMode` | 日期 | 滚轮列组合 |
| `renderLabel` | `DateTimePickerRenderLabel?` | `null` | 自定义列文案 |
| `start` | `TDateTimePickerValue?` | `null` | 可选范围下限 |
| `end` | `TDateTimePickerValue?` | `null` | 可选范围上限 |
| `steps` | `DateTimePickerSteps?` | `null` | 各列步进 |
| `showWeek` | `bool` | `false` | 日期列是否显示星期 |
| `onChanged` | `ValueChanged<TDateTimePickerValue>?` | `null` | 值变化回调；为 `null` 时禁用 |

`TDateTimePickerValue` 允许只设置当前 mode 使用的字段。组件会依据 mode、边界和步进生成合法滚轮快照。

## Theme

使用共享 `TPickerThemeData.height` 和 `TPickerThemeData.itemCount` 控制视窗。

## 约束

- 父组件必须在 `onChanged` 中回灌 `value`。
- mode、边界、步进或外部 value 改变时滚轮同步重建。
- 回调只包含当前 mode 对应字段。
- 不提供确认回调或内部弹层。

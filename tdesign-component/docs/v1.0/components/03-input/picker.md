# TPicker

## 定位

`TPicker` 是严格受控的滚轮选择面板，不包含弹层、工具栏和确认按钮。

## API

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `items` | `TPickerItems` | 必填 | `TPickerColumns` 独立多列或 `TPickerLinked` 层级联动数据 |
| `value` | `List<Object?>` | 必填 | 各列受控值 |
| `onChanged` | `ValueChanged<TPickerValue>?` | `null` | 完整选中快照；为 `null` 时禁用 |
| `onColumnScrollEnd` | `void Function(int, TPickerValue)?` | `null` | 某列滚动结束回调 |
| `itemBuilder` | `TPickerItemBuilder?` | `null` | 自定义选项内容 |

`TPickerOption` 使用 `label`、`value`、`disabled` 和 `children` 描述选项。`TPickerLinked` 直接使用 `children` 建模，不接受动态 Map 或字段映射。

`TPickerValue` 提供 `selectedOptions`、`indexes`、`values` 和 `labels`。

## Theme

`TPickerThemeData` 同时供 `TPicker` 和 `TDateTimePicker` 使用。

| 字段 | 说明 |
|---|---|
| `height` | 滚轮视窗高度 |
| `itemCount` | 视窗内可见项数量 |

## 约束

- 父组件必须在 `onChanged` 中回灌 `value`。
- 禁用项不会进入回调结果，滚轮停在禁用项时会纠正到最近可用项。
- 联动选择会一次返回新分支的完整路径。
- 数据源始终使用强类型不可变选项结构。

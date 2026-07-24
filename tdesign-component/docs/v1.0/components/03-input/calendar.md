# TCalendar

## 定位

`TCalendar` 是严格受控的月历选择面板，不包含弹层、工具栏和确认按钮。

## API

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `value` | `List<DateTime>` | 必填 | 受控选中日期 |
| `variant` | `TCalendarVariant` | `single` | 单选、多选或区间 |
| `firstDayOfWeek` | `int` | `0` | 每周起始日，0 为周日 |
| `minDate` | `DateTime?` | 1970-01-01 | 最小可选日期 |
| `maxDate` | `DateTime?` | 2100-12-31 | 最大可选日期 |
| `onChanged` | `ValueChanged<List<DateTime>>?` | `null` | 选中变化；为 `null` 时禁用 |
| `onMonthChanged` | `ValueChanged<DateTime>?` | `null` | 可见月份变化 |
| `anchorDate` | `DateTime?` | `null` | 滚动锚点，不改变选中值 |
| `animateTo` | `bool` | `false` | 锚点滚动是否使用动画 |
| `monthTitleBuilder` | `TCalendarMonthTitleBuilder?` | 内置 | 月标题构建器 |
| `cellBuilder` | `TCalendarCellBuilder?` | `null` | 完整日期格构建器 |
| `subtitleBuilder` | `TCalendarSubtitleBuilder?` | `null` | 日期副标题构建器 |

## Theme

`TCalendarThemeData` 控制面板高度、装饰、星期/月标题/日期样式、格高、间距、内边距和区间连接色。

## 约束

- 父组件必须在 `onChanged` 中回灌 `value`。
- `single` 使用一个日期，`multiple` 使用任意数量日期，`range` 使用起止日期。
- 所有日期在比较和回调前会规范为年月日。
- 选择模式和每周起始日属于实例语义，不存入 Theme。

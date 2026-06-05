# Picker / DateTimePicker / Calendar 组件边界

## 三个独立组件

| 组件 | 职责 | 代码依赖 |
|------|------|----------|
| [`TPicker`](../picker/t_picker.dart) | 通用多列滚轮（独立选项或联动树） | 无 |
| [`TDateTimePicker`](t_date_time_picker.dart) | 日期/时间滚轮（年月日、时分秒及组合） | **仅依赖** `TPicker` 滚轮能力（`DateTimePickerWheel` → `picker_column_wheel` 等） |
| [`TCalendar`](../calendar/t_calendar.dart) | 月历格点选（单选 / 多选 / 区间、锚点、副标题） | 无 |

`TCalendar` 与 `TDateTimePicker` **互不依赖**；业务侧可按场景分别或组合使用（弹层、表单等自行组装）。

## 业务选型

| 场景 | 组件 |
|------|------|
| 月历格点选日期 | `TCalendar` |
| 滚轮选年月日 / 时分秒 | `TDateTimePicker` |
| 非日期时间的通用滚轮 | `TPicker` |

三者均无内置确认或弹窗；与 `TPopup` / `showModalBottomSheet` 等由业务层组合。

## 已移除的日历内嵌滚轮（develop 遗留）

以下文件为旧「日历内嵌滚轮」路径，**勿再恢复**：

- `calendar/date_picker_model.dart`
- `calendar/t_date_picker.dart`

## TDateTimePicker 约定

- `initialValue` 非受控；重置用 `key` 或 remount。
- 列边界用 `start` / `end` / `steps` / `renderLabel`。
- Snapshot 经 `toPickerColumns` 转为 `TPickerColumns` 后交给内部滚轮渲染。

## 相关文件

- [`t_date_time_picker.dart`](t_date_time_picker.dart)
- [`t_date_time_picker_internal.dart`](t_date_time_picker_internal.dart)
- [`t_date_time_picker_wheel.dart`](t_date_time_picker_wheel.dart)
- [`../picker/t_picker.dart`](../picker/t_picker.dart)
- [`../calendar/t_calendar.dart`](../calendar/t_calendar.dart)

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

## TCalendar 约定

- **选中**：`initialValue` 仅首挂载生效；运行期同步靠 `onChange`；重置选中用 `Key` 或 remount（与 `TDateTimePicker` 不同，后者 `didUpdateWidget` 会响应 `initialValue` 变更）。
- **滚动**：`anchorDate` 运行期可更新，只滚月份、不改选中；首屏优先级 `anchorDate` > `initialValue` 最早日 > `minDate` 首月。
- **区间**（`CalendarType.range`）：两次点击定区间；终点须晚于起点，否则以新点击重开区间。
- **站点文档**：非受控说明、range 规则、与 Picker 族对比见 `tdesign-site/src/calendar/README.md` 中「使用约定」。

### 按日禁用（`disableDate`）评估结论

暂不新增 `disableDate(DateTime) => bool` 公开 API：

| 方案 | 说明 |
|------|------|
| 现状 | `minDate`/`maxDate` 控制可选区间；业务禁用用 `subtitleBuilder`/`cellBuilder` 自定义展示与点击 |
| 暂缓内置 | 需定义与 min/max 优先级、range 模式交互等，扩大 primitive 表面积；有明确需求再单独立项 |

## 相关文件

- [`t_date_time_picker.dart`](t_date_time_picker.dart)
- [`t_date_time_picker_internal.dart`](t_date_time_picker_internal.dart)
- [`t_date_time_picker_wheel.dart`](t_date_time_picker_wheel.dart)
- [`../picker/t_picker.dart`](../picker/t_picker.dart)
- [`../calendar/t_calendar.dart`](../calendar/t_calendar.dart)

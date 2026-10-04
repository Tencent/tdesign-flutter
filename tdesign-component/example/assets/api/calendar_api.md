## API
### TCalendar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| anchorDate | DateTime? | - | 滚动锚点日期。 |
| animateTo | bool | false | 锚点滚动是否使用动画。 |
| cellBuilder | TCalendarCellBuilder? | - | 日期格构建器。 |
| firstDayOfWeek | TCalendarFirstDayOfWeek | TCalendarFirstDayOfWeek.sunday | 每周从星期几开始，默认从星期日开始。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| maxDate | DateTime? | - | 最大可选日期。 |
| minDate | DateTime? | - | 最小可选日期。 |
| monthTitleBuilder | TCalendarMonthTitleBuilder? | - | 月标题构建器。 |
| onChanged | ValueChanged<List<DateTime>>? | - | 选中日期变化回调；为 null 时禁用。 |
| onMonthChanged | ValueChanged<DateTime>? | - | 可见月份变化回调。 |
| subtitleBuilder | TCalendarSubtitleBuilder? | - | 日期副标题构建器。 |
| value | List<DateTime> | - | 受控选中日期列表。 列表长度与 `variant` 对应： - `TCalendarVariant.single`：1 个元素（选中日期） - `TCalendarVariant.multiple`：N 个元素（所有选中日期） - `TCalendarVariant.range`：2 个元素（起始、结束日期） |
| variant | TCalendarVariant | TCalendarVariant.single | 选择模式。 |
| weekdayNames | List<String>? | - | 星期标题。未设置时使用当前资源代理中的文案。 |


### TCalendarCellModel
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| date | DateTime | - | 当前日期。 |
| isLastDayOfMonth | bool | - | 是否为当月最后一天。 |
| selectType | DateSelectType | - | 当前格的选中、区间或禁用展示状态。 |


### TCalendarSubtitleContext
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| date | DateTime | - | 当前格子的阳历日期（仅年月日，无时分秒）。 |
| selectType | DateSelectType | - | 当前格的选中/区间/禁用等展示状态，便于按态设置副标题样式。 |


### TCalendarSubtitleBuilder
#### 类型定义

```dart
typedef TCalendarSubtitleBuilder = Widget? Function(BuildContext context, TCalendarSubtitleContext subtitleContext);
```


### TCalendarCellBuilder
#### 类型定义

```dart
typedef TCalendarCellBuilder = Widget? Function(BuildContext context, TCalendarCellModel cell);
```


### TCalendarMonthTitleBuilder
#### 类型定义

```dart
typedef TCalendarMonthTitleBuilder = Widget Function(BuildContext context, DateTime monthDate);
```

## API
### TDCalendar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| firstDayOfWeek | int? | 0 | 第一天从星期几开始，默认 0 = 周日 |
| format | CalendarFormat? | - | 用于格式化日期的函数，可定义日期前后的显示内容和日期样式 |
| maxDate | int? | - | 最大可选的日期(fromMillisecondsSinceEpoch)，不传则默认半年后 |
| minDate | int? | - | 最小可选的日期(fromMillisecondsSinceEpoch)，不传则默认今天 |
| title | String? | - | 标题 |
| titleWidget | Widget? | - | 标题组件 |
| type | CalendarType? | CalendarType.single | 日历的选择类型，single = 单选；multiple = 多选; range = 区间选择 |
| value | List<int>? | - | 当前选择的日期(fromMillisecondsSinceEpoch)，不传则默认今天，当 type = single 时数组长度为1 |
| displayFormat | String? | 'year month' | 年月显示格式，`year`表示年，`month`表示月，如`year month`表示年在前、月在后、中间隔一个空格 |
| cellHeight | double? | 60 | 日期高度 |
| height | double? | - | 高度 |
| width | double? | - | 宽度 |
| style | TDCalendarStyle? | - | 自定义样式 |
| onChange | void Function(List<int> value)? | - | 选中值变化时触发 |
| onCellClick | void Function(int value, DateSelectType type, TDate tdate)? | - | 点击日期时触发 |
| onCellLongPress | void Function(int value, DateSelectType type, TDate tdate)? | - | 长安日期时触发 |
| onHeaderClick | void Function(int index, String week)? | - | 点击周时触发 |
| useTimePicker | bool? | false | 是否显示时间选择器 |
| timePickerModel | List<DatePickerModel>? | - | 自定义时间选择器 |
| monthTitleHeight | double? | 22 | 月标题高度 |
| monthTitleBuilder | Widget Function(BuildContext context, DateTime monthDate)? | - | 月标题构建器 |
| pickerHeight | double? | 178 | 时间选择器List的视窗高度 |
| pickerItemCount | int? | 3 | 选择器List视窗中item个数，pickerHeight / pickerItemCount即item高度 |
| isTimeUnit | bool? | true | 是否显示时间单位 |

```
```
 ### TDCalendarPopup
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | context | 上下文 |
| top | double? | - | 距离顶部的距离 |
| autoClose | bool? | true | 自动关闭；在点击关闭按钮、确认按钮、遮罩层时自动关闭 |
| confirmBtn | Widget? | - | 自定义确认按钮 |
| visible | bool? | - | 默认是否显示日历 |
| onClose | VoidCallback? | - | 关闭时触发 |
| onConfirm | void Function(List<int> value)? | - | 点击确认按钮时触发 |
| builder | CalendarBuilder? | - | 控件构建器，优先级高于[child] |
| child | TDCalendar? | - | 日历控件 |

```
```
 ### TDCalendarStyle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| decoration |  | - |  |
| titleStyle | TextStyle? | - | header区域 [TDCalendar.title]的样式 |
| titleMaxLine | int? | - | header区域 [TDCalendar.title]的行数 |
| titleCloseColor | Color? | - | header区域 关闭图标的颜色 |
| weekdayStyle | TextStyle? | - | header区域 周 文字样式 |
| monthTitleStyle | TextStyle? | - | body区域 年月文字样式 |
| cellStyle | TextStyle? | - | 日期样式 |
| centreColor | Color? | - | 日期范围内背景样式 |
| cellDecoration | BoxDecoration? | - | 日期decoration |
| cellPrefixStyle | TextStyle? | - | 日期前面的字符串的样式 |
| cellSuffixStyle | TextStyle? | - | 日期后面的字符串的样式 |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TDCalendarStyle.generateStyle  | 生成默认样式 |
| TDCalendarStyle.cellStyle  | 日期样式 |

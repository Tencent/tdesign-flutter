## API
### TCalendar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| anchorDate | DateTime? | - | 锚点日期 |
| animateTo | bool? | false | 动画滚动到指定位置 |
| cellHeight | double? | 60 | 日期高度 |
| cellWidget | Widget? Function(BuildContext context, TDate tdate, DateSelectType selectType)? | - | 自定义日期单元格组件 |
| dataSource | TCalendarDataSource? | - | 外部数据源，用于提供农历转换等功能 |
| dateType | TCalendarDateType | TCalendarDateType.solar | 日历类型：阳历或农历 |
| displayFormat | String? | 'year month' | 年月显示格式，`year`表示年，`month`表示月，如`year month`表示年在前、月在后、中间隔一个空格 |
| firstDayOfWeek | int? | 0 | 第一天从星期几开始，默认 0 = 周日 |
| format | CalendarFormat? | - | 用于格式化日期的函数，可定义日期前后的显示内容和日期样式 |
| height | double? | - | 高度 |
| isTimeUnit | bool? | true | 是否显示时间单位 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| maxDate | int? | - | 最大可选的日期（fromMillisecondsSinceEpoch），不传则默认半年后 |
| minDate | int? | - | 最小可选的日期（fromMillisecondsSinceEpoch），不传则默认今天 |
| monthTitleBuilder | Widget Function(BuildContext context, DateTime monthDate)? | - | 月标题构建器 |
| monthTitleHeight | double? | 22 | 月标题高度 |
| onCellClick | void Function(int value, DateSelectType type, TDate tdate)? | - | 点击日期时触发 |
| onCellLongPress | void Function(int value, DateSelectType type, TDate tdate)? | - | 长安日期时触发 |
| onChange | void Function(List<int> value)? | - | 选中值变化时触发 |
| onHeaderClick | void Function(int index, String week)? | - | 点击周时触发 |
| onMonthChange | ValueChanged<DateTime>? | - | 月份变化时触发 |
| pickerHeight | double? | 178 | 时间选择器List的视窗高度 |
| pickerItemCount | int? | 3 | 选择器List视窗中item个数，pickerHeight / pickerItemCount即item高度 |
| showLunarInfo | bool | false | 阳历模式下是否显示农历信息作为副标题 |
| style | TCalendarStyle? | - | 自定义样式 |
| timePickerModel | List<DatePickerModel>? | - | 自定义时间选择器 |
| title | String? | - | 标题 |
| titleWidget | Widget? | - | 标题组件 |
| type | CalendarType? | CalendarType.single | 日历的选择类型，single = 单选；multiple = 多选；range = 区间选择 |
| useSafeArea | bool? | true | 是否使用安全区域，默认true |
| useTimePicker | bool? | false | 是否显示时间选择器 |
| value | List<int>? | - | 当前选择的日期（fromMillisecondsSinceEpoch），不传则默认今天，当 type = single 时数组长度为1 |
| width | double? | - | 宽度 |


### TCalendarPopup
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文 |
| autoClose | bool? | true | 自动关闭；在点击关闭按钮、确认按钮、遮罩层时自动关闭 |
| builder | CalendarBuilder? | - | 控件构建器，优先级高于`child` |
| child | TCalendar? | - | 日历控件 |
| confirmBtn | Widget? | - | 自定义确认按钮 |
| onClose | VoidCallback? | - | 关闭时触发 |
| onConfirm | void Function(List<int> value)? | - | 点击确认按钮时触发 |
| top | double? | - | 距离顶部的距离 |
| visible | bool? | - | 默认是否显示日历 |


### TCalendarStyle

#### 工厂构造方法

##### TCalendarStyle.cellStyle

日期样式

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | - |
| type | DateSelectType? | - | - |


##### TCalendarStyle.generateStyle

生成默认样式

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | - |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| cellDecoration | BoxDecoration? | - | 日期decoration |
| cellPrefixStyle | TextStyle? | - | 日期前面的字符串的样式 |
| cellStyle | TextStyle? | - | 日期样式 |
| cellSuffixStyle | TextStyle? | - | 日期后面的字符串的样式 |
| centreColor | Color? | - | 日期范围内背景样式 |
| decoration | BoxDecoration? | - | - |
| monthTitleStyle | TextStyle? | - | body区域 年月文字样式 |
| titleCloseColor | Color? | - | header区域 关闭图标的颜色 |
| titleMaxLine | int? | - | header区域 `TCalendar.title`的行数 |
| titleStyle | TextStyle? | - | header区域 `TCalendar.title`的样式 |
| weekdayStyle | TextStyle? | - | header区域 周 文字样式 |

#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| bodyPadding | double? | - | 月与月之间的垂直间距 |
| todayStyle | TextStyle? | - | 当天日期样式 |
| verticalGap | double? | - | 日期垂直间距，水平间距为`verticalGap` / 2 |


### TCalendarDataSource

#### 方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| getLunarInfo | TLunarInfo? | required DateTime solarDate | 获取指定阳历日期的农历信息 返回 null 表示不显示农历信息 |
| formatDate | String | required DateTime date, required TCalendarDateType type, TLunarInfo? lunarInfo | 格式化日期文本 返回格式化后的日期字符串 |
| getSolarTerm | String? | required DateTime date | 获取节气信息（可选实现） 返回节气名称，如"春分"、"秋分"等，无节气则返回 null |
| getFestival | String? | required DateTime date, TLunarInfo? lunarInfo | 获取节日信息（可选实现） 返回节日名称，如"春节"、"中秋节"等，无节日则返回 null |
| getHolidayInfo | Map<String, String>? | required DateTime date | 获取假期信息（可选实现） 返回假期类型和名称： - 'holiday': 法定节假日/公共假期（如"国庆节"） - 'workday': 调休工作日（如"补班"） - null: 正常日期 示例返回值： - {'type': 'holiday', 'name': '国庆节'} - {'type': 'workday', 'name': '补班'} - null |
| formatYear | String | required int year, required TCalendarDateType type | 格式化年份文本 返回格式化后的年份字符串 阳历示例：2025 -> "2025年" 阴历示例：2025 -> "二〇二五年" |
| formatMonth | String | required int month, required TCalendarDateType type, bool isLeapMonth | 格式化月份文本 返回格式化后的月份字符串 阳历示例：3 -> "3月" 阴历示例：3 -> "三月"，闰3月 -> "闰三月" |
| formatDay | String | required int day, required TCalendarDateType type | 格式化日期文本 返回格式化后的日期字符串 阳历示例：7 -> "7日" 阴历示例：7 -> "初七" |


### TLunarInfo
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| day | int | - | 农历日期（数字，1-30） |
| dayText | String | - | 日期文本（如：初七） |
| isLeapMonth | bool | false | 是否是闰月 |
| month | int | - | 农历月份（数字，1-12） |
| monthText | String | - | 月份文本（如：三月、闰三月） |
| year | int | - | 农历年份（数字） |
| yearText | String | - | 年份文本（如：二〇二五） |


### TCalendarDateType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| solar | 阳历（公历） |
| lunar | 阴历（农历） |


### CalendarType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| single | - |
| multiple | - |
| range | - |


### CalendarTrigger
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| closeBtn | - |
| confirmBtn | - |
| overlay | - |


### DateSelectType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| selected | - |
| disabled | - |
| start | - |
| centre | - |
| end | - |
| empty | - |


### CalendarBuilder
#### 类型定义

```dart
typedef CalendarBuilder = Widget Function(BuildContext context);
```


### CalendarFormat
#### 类型定义

```dart
typedef CalendarFormat = TDate? Function(TDate? day);
```

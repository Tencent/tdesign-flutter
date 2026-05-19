## API
### TCalendar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| anchorDate | DateTime? | - | 锚点日期 |
| animateTo | bool? | false | 动画滚动到指定位置 |
| bottom | CalendarBottomBuilder? | - | 底部自定义区域构建器，以浮层方式叠加在日历主体之上。 |
| bottomExpanded | ValueListenable<bool>? | - | bottom 区域是否展开（响应式）。**仅能在 [TPopupBottomDisplayPanel] 内使用。** |
| cellHeight | double? | 60 | 日期高度 |
| cellWidget | Widget? Function(BuildContext context, TDate tdate, DateSelectType selectType)? | - | 自定义日期单元格组件 |
| dataSource | TCalendarDataSource? | - | 外部数据源，用于提供农历转换等功能 |
| dateType | TCalendarDateType | TCalendarDateType.solar | 日历类型：阳历或农历 |
| displayFormat | String? | 'year month' | 年月显示格式，`year`表示年，`month`表示月，如`year month`表示年在前、月在后、中间隔一个空格 |
| firstDayOfWeek | int? | 0 | 第一天从星期几开始，默认 0 = 周日 |
| format | CalendarFormat? | - | 用于格式化日期的函数，可定义日期前后的显示内容和日期样式 |
| height | double? | - | 高度，不传时内嵌模式自动按 5 行日期计算 |
| key |  | - |  |
| maxDate | int? | - | 最大可选的日期（fromMillisecondsSinceEpoch），不传则默认 2100-12-31 |
| minDate | int? | - | 最小可选的日期（fromMillisecondsSinceEpoch），不传则默认 1970-01-01 |
| monthTitleBuilder | Widget Function(BuildContext context, DateTime monthDate)? | - | 月标题构建器 |
| monthTitleHeight | double? | 22 | 月标题高度 |
| onCellClick | void Function(int value, DateSelectType type, TDate tdate)? | - | 点击日期时触发 |
| onCellLongPress | void Function(int value, DateSelectType type, TDate tdate)? | - | 长按日期时触发 |
| onChange | void Function(List<int> value)? | - | 选中值变化时触发 |
| onHeaderClick | void Function(int index, String week)? | - | 点击周时触发 |
| onMonthChange | ValueChanged<DateTime>? | - | 月份变化时触发 |
| showLunarInfo | bool | false | 阳历模式下是否显示农历信息作为副标题 |
| style | TCalendarStyle? | - | 自定义样式 |
| title | String? | - | 标题 |
| titleWidget | Widget? | - | 标题组件 |
| type | CalendarType? | CalendarType.single | 日历的选择类型，single = 单选；multiple = 多选；range = 区间选择 |
| useSafeArea | bool? | true | 是否使用安全区域（默认 true） |
| value | List<int>? | - | 当前选择的日期（fromMillisecondsSinceEpoch），不传则默认今天，当 type = single 时数组长度为1 |
| width | double? | - | 宽度 |


#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| showPopup |  |   required BuildContext context,  String? title,  CalendarType type,  List<int>? value,  int? minDate,  int? maxDate,  DateTime? anchorDate,  double? fixedHeight,  int? firstDayOfWeek,  String? displayFormat,  double? cellHeight,  TCalendarStyle? style,  CalendarFormat? format,  CalendarBottomBuilder? bottom,  ValueListenable<bool>? bottomExpanded,  Widget? confirmBtn,  void Function(List<int>)? onConfirm,  VoidCallback? onClose,  void Function(int value, DateSelectType type, TDate tdate)? onCellClick,  void Function(int value, DateSelectType type, TDate tdate)? onCellLongPress,  bool autoClose,  bool draggable,  Widget? Function(BuildContext context, TDate tdate, DateSelectType selectType)? cellWidget,  TCalendarDateType dateType,  TCalendarDataSource? dataSource,  bool showLunarInfo,  ValueChanged<DateTime>? onMonthChange,  Widget Function(BuildContext context, DateTime monthDate)? monthTitleBuilder, | 弹出日历选择器，返回选中的日期列表。     取消或关闭弹窗时返回 `null`；点击确认时返回选中日期的毫秒时间戳列表。     ```dart   final result = await TCalendar.showPopup(     context,     title: '请选择日期',     type: CalendarType.single,   );   if (result != null) {     print('选中了: $result');   }   ```     若需完全自定义布局，请直接使用 [TCalendar] + [TPopupBottomDisplayPanel]   + [TSlidePopupRoute] 自行组装。 |

```
```

### TCalendarStyle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| cellDecoration | BoxDecoration? | - | 日期decoration |
| cellPrefixStyle | TextStyle? | - | 日期前面的字符串的样式 |
| cellStyle | TextStyle? | - | 日期样式 |
| cellSuffixStyle | TextStyle? | - | 日期后面的字符串的样式 |
| centreColor | Color? | - | 日期范围内背景样式 |
| decoration |  | - |  |
| monthTitleStyle | TextStyle? | - | body区域 年月文字样式 |
| titleCloseColor | Color? | - | header区域 关闭图标的颜色 |
| titleMaxLine | int? | - | header区域 [TCalendar.title]的行数 |
| titleStyle | TextStyle? | - | header区域 [TCalendar.title]的样式 |
| todayStyle | TextStyle? | - | 当天日期样式 |
| weekdayStyle | TextStyle? | - | header区域 周 文字样式 |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TCalendarStyle.cellStyle  | 日期样式 |
| TCalendarStyle.generateStyle  | 生成默认样式 |

```
```

### TCalendarDataSource
```
```

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

## API
### TDate
#### 简介
时间对象
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| date | DateTime | - | 时间对象 |
| type | TDateType | - | 日期类型 |
| prefix | String? | - | 日期前面的字符串 |
| prefixWidget | Widget? | - | 日期前面的组件，优先级高于[prefix] |
| suffix | String? | - | 日期后面的字符串 |
| suffixWidget | Widget? | - | 日期后面的组件，优先级高于[suffix] |

```
```
 ### TDCalendarStyle
#### 简介
日历组件样式
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| weekdayStyle | TextStyle? | - | 周 文字样式 |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TDCalendarStyle.generateStyle  | 生成默认样式 |

```
```
 ### TDCalendar
#### 简介
单元格组件
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| autoClose | bool? | true | 自动关闭；在点击关闭按钮、确认按钮、遮罩层时自动关闭，不需要手动设置 visible |
| confirmBtn | Widget? | - | 自定义确认按钮 |
| firstDayOfWeek | int? | 0 | 第一天从星期几开始，默认 0 = 周日 |
| format | CalendarFormatType? | - | 用于格式化日期的函数 |
| maxDate | int? | - | 最大可选的日期，不传则默认半年后 |
| minDate | int? | - | 最小可选的日期，不传则默认今天 |
| title | String? | - | 标题 |
| titleWidget | Widget? | - | 标题组件 |
| type | CalendarType? | CalendarType.single | 日历的选择类型，single = 单选；multiple = 多选; range = 区间选择 |
| usePopup | bool? | true | 是否使用弹出层包裹日历 |
| value | List<int>? | - | 当前选择的日期，不传则默认今天，当 type = single 时数组长度为1 |
| visible | bool? | false | 是否显示日历；[usePopup] 为 true 时有效 |
| style | TDCalendarStyle? | - | 自定义样式 |

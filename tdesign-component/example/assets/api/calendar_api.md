## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TCalendar

#### 声明

```dart
class TCalendar extends StatefulWidget
```

#### 默认构造方法


```dart
TCalendar({
  super.key,
  required this.value,
  this.firstDayOfWeek = TCalendarFirstDayOfWeek.sunday,
  DateTime? minDate,
  DateTime? maxDate,
  this.variant = TCalendarVariant.single,
  this.onChanged,
  this.onMonthChanged,
  TCalendarMonthTitleBuilder? monthTitleBuilder,
  this.weekdayNames,
  this.cellBuilder,
  this.subtitleBuilder,
  this.animateTo = false,
  this.anchorDate,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| anchorDate | DateTime? | - | 滚动锚点日期。 | 否 |
| animateTo | bool | false | 锚点滚动是否使用动画。 | 否 |
| cellBuilder | TCalendarCellBuilder? | - | 日期格构建器。 | 否 |
| firstDayOfWeek | TCalendarFirstDayOfWeek | TCalendarFirstDayOfWeek.sunday | 每周从星期几开始，默认从星期日开始。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| maxDate | DateTime? | - | 最大可选日期。 | 否 |
| minDate | DateTime? | - | 最小可选日期。 | 否 |
| monthTitleBuilder | TCalendarMonthTitleBuilder? | - | 月标题构建器。 | 否 |
| onChanged | ValueChanged&lt;List&lt;DateTime&gt;&gt;? | - | 选中日期变化回调；为 null 时禁用。 | 否 |
| onMonthChanged | ValueChanged&lt;DateTime&gt;? | - | 可见月份变化回调。 | 否 |
| subtitleBuilder | TCalendarSubtitleBuilder? | - | 日期副标题构建器。 | 否 |
| value | List&lt;DateTime&gt; | - | 受控选中日期。 | 是 |
| variant | TCalendarVariant | TCalendarVariant.single | 选择模式。 | 否 |
| weekdayNames | List&lt;String&gt;? | - | 星期标题。未设置时使用当前资源代理中的文案。 | 否 |


### TCalendarStyle

#### 声明

```dart
class TCalendarStyle
```


#### 静态方法

##### TCalendarStyle.generateStyle

```dart
static TCalendarStyle generateStyle({BuildContext? context})
```


生成默认样式

返回类型：`TCalendarStyle`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| context | BuildContext? | - | - | 否 |

#### 默认构造方法


```dart
const TCalendarStyle({
  this.decoration,
  this.weekdayStyle,
  this.monthTitleStyle,
  this.dayStyle,
  this.todayDayStyle,
  this.cellDecoration,
  this.subtitleStyle,
  this.cellHeight = 60,
  this.monthTitleHeight = 22,
  this.verticalGap,
  this.bodyPadding,
  this.weekdayGap,
  this.centreColor,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| bodyPadding | double? | - | 内边距 | 否 |
| cellDecoration | BoxDecoration? | - | 日期单元格装饰（选中状态） | 否 |
| cellHeight | double | 60 | 日期单元格高度，默认 60 | 否 |
| centreColor | Color? | - | 区间中间格背景与格间衔接条颜色。 | 否 |
| dayStyle | TextStyle? | - | 日期数字样式 | 否 |
| decoration | BoxDecoration? | - | 组件容器装饰 | 否 |
| monthTitleHeight | double | 22 | 月份标题高度，默认 22 | 否 |
| monthTitleStyle | TextStyle? | - | 月份标题文字样式 | 否 |
| subtitleStyle | TextStyle? | - | 副标题样式 | 否 |
| todayDayStyle | TextStyle? | - | 今天日期数字样式 | 否 |
| verticalGap | double? | - | 日期格垂直间距，水平间距为 `verticalGap` / 2 | 否 |
| weekdayGap | double? | - | 星期之间的水平间距 | 否 |
| weekdayStyle | TextStyle? | - | 星期文字样式 | 否 |

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| weekdayHeight | double | - | 星期标题高度 |


#### 实例方法

##### TCalendarStyle.forSelectType

```dart
TCalendarStyle forSelectType(BuildContext context, DateSelectType? type)
```


按选中态生成单元格样式

返回类型：`TCalendarStyle`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | - | 是 |
| type | DateSelectType? | - | - | 是 |


### TCalendarCellModel

#### 声明

```dart
class TCalendarCellModel
```

#### 默认构造方法


```dart
const TCalendarCellModel({
  required this.date,
  required this.selectType,
  required this.isLastDayOfMonth,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| date | DateTime | - | 当前日期。 | 是 |
| isLastDayOfMonth | bool | - | 是否为当月最后一天。 | 是 |
| selectType | DateSelectType | - | 当前格的选中、区间或禁用展示状态。 | 是 |


### TCalendarSubtitleContext

#### 声明

```dart
class TCalendarSubtitleContext
```

#### 默认构造方法


```dart
const TCalendarSubtitleContext({
  required this.date,
  required this.selectType,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| date | DateTime | - | 当前格子的阳历日期（仅年月日，无时分秒）。 | 是 |
| selectType | DateSelectType | - | 当前格的选中/区间/禁用等展示状态，便于按态设置副标题样式。 | 是 |


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

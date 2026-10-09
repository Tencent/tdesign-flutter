## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TCalendar
#### 简介
严格受控的日历面板，不包含弹窗、工具栏或确认操作。
`value` 与 `onChanged` 构成受控选择状态；`onChanged` 为 null 时禁用。

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
| anchorDate | DateTime? | - | 滚动锚点日期：将列表定位到该日**所在月份**的首屏位置。 **不**自动把该日设为选中。运行期更新本参数会重新滚动（见 `animateTo`）。 未设置时：有非空 `value` 则滚到其中最早一日所在月，否则滚到 `minDate` 首月。 | 否 |
| animateTo | bool | false | `anchorDate` 或首屏定位变更导致滚动时，是否使用动画，默认 false。 | 否 |
| cellBuilder | TCalendarCellBuilder? | - | 整格自定义构建器；返回非 null 时替换该格默认布局（主数字 + 副标题均不渲染）。 返回非 null 时优先于 `subtitleBuilder`；返回 null 时使用默认日期格及副标题。 | 否 |
| firstDayOfWeek | TCalendarFirstDayOfWeek | TCalendarFirstDayOfWeek.sunday | 每周从星期几开始，默认从星期日开始。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| maxDate | DateTime? | - | 最大可选日期；未传时为 2100-12-31，取日期部分，不得早于 minDate。 | 否 |
| minDate | DateTime? | - | 最小可选日期；未传时为 1970-01-01，取日期部分，不得晚于 maxDate。 | 否 |
| monthTitleBuilder | TCalendarMonthTitleBuilder? | - | 月标题构建器。 | 否 |
| onChanged | ValueChanged&lt;List&lt;DateTime&gt;&gt;? | - | 选中结果变化时触发；为 null 时整个日历禁用。 单选立即触发，多选每次切换，区间在端点变化时触发。父组件应在回调中 更新 `value`。组件挂载时不会调用本回调。 | 否 |
| onMonthChanged | ValueChanged&lt;DateTime&gt;? | - | 可见月份变化且不处于程序化动画滚动期间时触发，参数为当月 1 日。 程序化动画滚动不保证在结束时通知；外置控制栏应自行同步 anchorDate 对应的目标月份，用户滑动时再根据本回调更新文案。 | 否 |
| subtitleBuilder | TCalendarSubtitleBuilder? | - | 副标题构建器，在日期主数字下方渲染自定义内容。 `TCalendarSubtitleContext.date` 为当前格日期； `TCalendarSubtitleContext.selectType` 为选中/区间/禁用等态。返回 null 不显示副标题行。 | 否 |
| value | List&lt;DateTime&gt; | - | 受控选中日期列表。 空列表表示未选择；single 通常使用 1 个元素，multiple 使用所有选中日期， range 使用 1 个起始日期或 2 个起止日期。日期会去除时分秒、去重并排序。 | 是 |
| variant | TCalendarVariant | TCalendarVariant.single | 日历的选择模式（保留 variant 命名，不表示视觉变体），决定点击后的行为： - `TCalendarVariant.single`：单选，点击新日期取消旧选中 - `TCalendarVariant.multiple`：多选，点击切换选中/取消 - `TCalendarVariant.range`：区间选择，依次选起止日期 | 否 |
| weekdayNames | List&lt;String&gt;? | - | 星期标题，按星期日到星期六排列。 未设置时使用 `TResourceManager` 提供的当前语言文案。 必须按星期日到星期六提供 7 个文案，与 firstDayOfWeek 无关。 | 否 |


### TCalendarCellModel
#### 简介
单个日期格的不可变展示快照，由日历的受控 value 派生。
自定义构建器通过 `selectType` 读取状态；选择更新由日历的 onChanged
通知调用方，再通过 value 重建，不直接修改日期格。

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
#### 简介
副标题构建上下文：告知 `TCalendarSubtitleBuilder` 当前渲染哪一格。

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


### TCalendarThemeData
#### 简介
TCalendar 组件级 ThemeExtension
包含日历的装饰、字体和布局默认值。
样式字段通过 `ThemeData.mergeExtension` 在子树覆盖，不需要额外的实例 style 参数。
{@category ComponentTheme}

#### 声明

```dart
class TCalendarThemeData extends ThemeExtension<TCalendarThemeData>
```

#### 默认构造方法


```dart
const TCalendarThemeData({
  this.height,
  this.decoration,
  this.weekdayStyle,
  this.monthTitleStyle,
  this.dayStyle,
  this.todayDayStyle,
  this.cellDecoration,
  this.subtitleStyle,
  this.cellHeight,
  this.monthTitleHeight,
  this.verticalGap,
  this.bodyPadding,
  this.weekdayGap,
  this.centreColor,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| bodyPadding | double? | - | 日历主体内边距；为 null 时使用全局 spacer2 Token。 | 否 |
| cellDecoration | BoxDecoration? | - | 日期单元格装饰（选中状态） null 时按日期格选择状态与全局 Token 解析默认装饰。 | 否 |
| cellHeight | double? | - | 日期单元格高度；为 null 时使用 60 逻辑像素。 | 否 |
| centreColor | Color? | - | 区间中间格背景与格间衔接条颜色 null 时按区间格的选择状态与当前 Token 解析区间背景。 | 否 |
| dayStyle | TextStyle? | - | 日期数字样式 null 时继承当前全局 Token 与日期格状态解析的样式。 | 否 |
| decoration | BoxDecoration? | - | 组件容器装饰 null 时继承当前全局 Token 解析的容器装饰。 | 否 |
| height | double? | - | 日历整体高度；为 null 时由星期栏、月份标题、六行日期、间距和内边距计算视窗高度，不按全部月份展开。 | 否 |
| monthTitleHeight | double? | - | 月份标题高度；为 null 时使用 22 逻辑像素。 | 否 |
| monthTitleStyle | TextStyle? | - | 月份标题文字样式 null 时继承当前全局 Token 解析的月份标题样式。 | 否 |
| subtitleStyle | TextStyle? | - | 副标题样式 null 时继承当前全局 Token 与选择状态解析的副标题样式。 | 否 |
| todayDayStyle | TextStyle? | - | 今天日期数字样式 null 时继承当前全局 Token 解析的今天样式。 | 否 |
| verticalGap | double? | - | 日期格垂直间距；为 null 时使用全局 spacer Token，水平间距为该值的一半。 | 否 |
| weekdayGap | double? | - | 星期之间的水平间距；为 null 时使用组件默认值 4 逻辑像素。 | 否 |
| weekdayStyle | TextStyle? | - | 星期文字样式 null 时继承当前全局 Token 解析的星期样式。 | 否 |


#### 实例方法

##### TCalendarThemeData.copyWith

```dart
TCalendarThemeData copyWith({
  double? height,
  BoxDecoration? decoration,
  TextStyle? weekdayStyle,
  TextStyle? monthTitleStyle,
  TextStyle? dayStyle,
  TextStyle? todayDayStyle,
  BoxDecoration? cellDecoration,
  TextStyle? subtitleStyle,
  double? cellHeight,
  double? monthTitleHeight,
  double? verticalGap,
  double? bodyPadding,
  double? weekdayGap,
  Color? centreColor,
})
```


复制主题配置。
## 返回值
返回主题副本；非空参数替换对应配置，null 参数保留当前配置。

返回类型：`TCalendarThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| height | double? | - | 日历整体高度；为 null 时由星期栏、月份标题、六行日期、间距和内边距计算视窗高度，不按全部月份展开。 | 否 |
| decoration | BoxDecoration? | - | 组件容器装饰 null 时继承当前全局 Token 解析的容器装饰。 | 否 |
| weekdayStyle | TextStyle? | - | 星期文字样式 null 时继承当前全局 Token 解析的星期样式。 | 否 |
| monthTitleStyle | TextStyle? | - | 月份标题文字样式 null 时继承当前全局 Token 解析的月份标题样式。 | 否 |
| dayStyle | TextStyle? | - | 日期数字样式 null 时继承当前全局 Token 与日期格状态解析的样式。 | 否 |
| todayDayStyle | TextStyle? | - | 今天日期数字样式 null 时继承当前全局 Token 解析的今天样式。 | 否 |
| cellDecoration | BoxDecoration? | - | 日期单元格装饰（选中状态） null 时按日期格选择状态与全局 Token 解析默认装饰。 | 否 |
| subtitleStyle | TextStyle? | - | 副标题样式 null 时继承当前全局 Token 与选择状态解析的副标题样式。 | 否 |
| cellHeight | double? | - | 日期单元格高度；为 null 时使用 60 逻辑像素。 | 否 |
| monthTitleHeight | double? | - | 月份标题高度；为 null 时使用 22 逻辑像素。 | 否 |
| verticalGap | double? | - | 日期格垂直间距；为 null 时使用全局 spacer Token，水平间距为该值的一半。 | 否 |
| bodyPadding | double? | - | 日历主体内边距；为 null 时使用全局 spacer2 Token。 | 否 |
| weekdayGap | double? | - | 星期之间的水平间距；为 null 时使用组件默认值 4 逻辑像素。 | 否 |
| centreColor | Color? | - | 区间中间格背景与格间衔接条颜色 null 时按区间格的选择状态与当前 Token 解析区间背景。 | 否 |


##### TCalendarThemeData.lerp

```dart
TCalendarThemeData lerp(
  ThemeExtension<TCalendarThemeData>? other,
  double t,
)
```


生成主题过渡配置。
## 返回值
按 t 在当前主题和目标主题之间生成过渡主题。
other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。

返回类型：`TCalendarThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TCalendarThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


### DateSelectType
#### 简介
日期在日历格中的选中和展示状态。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| selected | 单选或多选下的选中。 |
| disabled | 超出可选日期范围。 |
| start | 区间起点。 |
| centre | 区间中间日期。 |
| end | 区间终点。 |
| empty | 未选中且可选。 |


### TCalendarFirstDayOfWeek
#### 简介
每周的起始日。
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| sunday | 星期日作为一周第一天。 |
| monday | 星期一作为一周第一天。 |
| tuesday | 星期二作为一周第一天。 |
| wednesday | 星期三作为一周第一天。 |
| thursday | 星期四作为一周第一天。 |
| friday | 星期五作为一周第一天。 |
| saturday | 星期六作为一周第一天。 |


### TCalendarVariant
#### 简介
日历选择形态
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| single | 单选日期 |
| multiple | 多选日期 |
| range | 选择日期区间 |


### TCalendarSubtitleBuilder
#### 简介
副标题构建器；每个日期格渲染时调用一次。
通过 `TCalendarSubtitleContext` 获取日期与选中态。

`context` 日期格的构建上下文。
`subtitleContext` 当前日期及日期格的选中、区间和禁用状态。
## 返回值
日期格副标题内容；返回 null 时不显示副标题行。
#### 类型定义

```dart
typedef TCalendarSubtitleBuilder = Widget? Function(BuildContext context, TCalendarSubtitleContext subtitleContext);
```


### TCalendarCellBuilder
#### 简介
整格自定义构建器。
`context` 日期格的构建上下文。
`cell` 当前日期格的数据与状态。
## 返回值
完整日期格内容，包含主数字与副标题；返回 null 时使用默认日期格及副标题。
#### 类型定义

```dart
typedef TCalendarCellBuilder = Widget? Function(BuildContext context, TCalendarCellModel cell);
```


### TCalendarMonthTitleBuilder
#### 简介
月标题构建器。
`context` 月份标题的构建上下文。
`monthDate` 当前月份的第一天。
## 返回值
当前月份的标题内容。
#### 类型定义

```dart
typedef TCalendarMonthTitleBuilder = Widget Function(BuildContext context, DateTime monthDate);
```

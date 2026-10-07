## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TCalendar
#### 简介
严格受控的日历面板，不包含弹窗、工具栏或确认操作。
`value` 与 `onChanged` 构成受控选择状态；`onChanged` 为 null 时禁用。
#### 默认构造方法

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


### TCalendarCellModel
#### 简介
单个日期格的不可变展示快照，由日历的受控 value 派生。
自定义构建器通过 `selectType` 读取状态；选择更新由日历的 onChanged
通知调用方，再通过 value 重建，不直接修改日期格。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| date | DateTime | - | 当前日期。 | 是 |
| isLastDayOfMonth | bool | - | 是否为当月最后一天。 | 是 |
| selectType | DateSelectType | - | 当前格的选中、区间或禁用展示状态。 | 是 |


### TCalendarSubtitleContext
#### 简介
副标题构建上下文：告知 `TCalendarSubtitleBuilder` 当前渲染哪一格。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| date | DateTime | - | 当前格子的阳历日期（仅年月日，无时分秒）。 | 是 |
| selectType | DateSelectType | - | 当前格的选中/区间/禁用等展示状态，便于按态设置副标题样式。 | 是 |


### TCalendarThemeData
#### 简介
TCalendar 组件级 ThemeExtension
包含日历样式默认（装饰、字体、布局参数）。
样式字段通过 mergeExtension 子树覆盖，无需构造器 P0 `style` 参数。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| bodyPadding | double? | - | 内边距 | 否 |
| cellDecoration | BoxDecoration? | - | 日期单元格装饰（选中状态） | 否 |
| cellHeight | double? | - | 日期单元格高度，默认 60 | 否 |
| centreColor | Color? | - | 区间中间格背景与格间衔接条颜色 | 否 |
| dayStyle | TextStyle? | - | 日期数字样式 | 否 |
| decoration | BoxDecoration? | - | 组件容器装饰 | 否 |
| height | double? | - | 高度 | 否 |
| monthTitleHeight | double? | - | 月份标题高度，默认 22 | 否 |
| monthTitleStyle | TextStyle? | - | 月份标题文字样式 | 否 |
| subtitleStyle | TextStyle? | - | 副标题样式 | 否 |
| todayDayStyle | TextStyle? | - | 今天日期数字样式 | 否 |
| verticalGap | double? | - | 日期格垂直间距，水平间距为 `verticalGap` / 2 | 否 |
| weekdayGap | double? | - | 星期之间的水平间距 | 否 |
| weekdayStyle | TextStyle? | - | 星期文字样式 | 否 |


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
通过 `TCalendarSubtitleContext` 获取日期与选中态；返回 `null` 表示不显示副标题行。
#### 类型定义

```dart
typedef TCalendarSubtitleBuilder = Widget? Function(BuildContext context, TCalendarSubtitleContext subtitleContext);
```


### TCalendarCellBuilder
#### 简介
整格自定义构建器；返回非 null 时该格由接入方完全绘制（含主数字与副标题）。
#### 类型定义

```dart
typedef TCalendarCellBuilder = Widget? Function(BuildContext context, TCalendarCellModel cell);
```


### TCalendarMonthTitleBuilder
#### 简介
月标题构建器；`monthDate` 为当月 1 日。
#### 类型定义

```dart
typedef TCalendarMonthTitleBuilder = Widget Function(BuildContext context, DateTime monthDate);
```

## API

### TCalendar

#### 构造方法

##### TCalendar

| 名称 | 类型 | 默认值 | 说明 | 必传 |
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

#### 构造方法

##### TCalendarStyle

| 名称 | 类型 | 默认值 | 说明 | 必传 |
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


#### 属性

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| weekdayHeight | double | - | 星期标题高度 | - |


#### 静态方法

##### TCalendarStyle.generateStyle

生成默认样式

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext? | - | - | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TCalendarStyle | - | - | - |


#### 实例方法

##### TCalendarStyle.forSelectType

位置参数：`context, type`


按选中态生成单元格样式

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | - | 是 |
| type | DateSelectType? | - | - | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TCalendarStyle | - | - | - |


### TCalendarCellModel

#### 构造方法

##### TCalendarCellModel

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| date | DateTime | - | 当前日期。 | 是 |
| isLastDayOfMonth | bool | - | 是否为当月最后一天。 | 是 |
| selectType | DateSelectType | - | 当前格的选中、区间或禁用展示状态。 | 是 |


### TCalendarSubtitleContext

#### 构造方法

##### TCalendarSubtitleContext

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| date | DateTime | - | 当前格子的阳历日期（仅年月日，无时分秒）。 | 是 |
| selectType | DateSelectType | - | 当前格的选中/区间/禁用等展示状态，便于按态设置副标题样式。 | 是 |


### TCalendarSubtitleBuilder

位置参数：`context, subtitleContext`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | - | 是 |
| subtitleContext | TCalendarSubtitleContext | - | - | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Widget? | - | - | - |


### TCalendarCellBuilder

位置参数：`context, cell`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | - | 是 |
| cell | TCalendarCellModel | - | - | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Widget? | - | - | - |


### TCalendarMonthTitleBuilder

位置参数：`context, monthDate`


#### 回调参数

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | - | 是 |
| monthDate | DateTime | - | - | 是 |


#### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Widget | - | - | - |

## API
### TCalendar
#### 简介
严格受控的日历面板，不包含弹窗、工具栏或确认操作。
`value` 与 `onChanged` 构成受控选择状态；`onChanged` 为 null 时禁用。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| anchorDate | DateTime? | - | 滚动锚点日期：将列表定位到该日**所在月份**的首屏位置。 **不**自动把该日设为选中。运行期更新本参数会重新滚动（见 `animateTo`）。 未设置时：有非空 `value` 则滚到其中最早一日所在月，否则滚到 `minDate` 首月。 |
| animateTo | bool | false | `anchorDate` 或首屏定位变更导致滚动时，是否使用动画，默认 false。 |
| cellBuilder | TCalendarCellBuilder? | - | 整格自定义构建器；返回非 null 时替换该格默认布局（主数字 + 副标题均不渲染）。 与 `subtitleBuilder` 互斥：需要只改副标题时请用 `subtitleBuilder`。 |
| firstDayOfWeek | int | 0 | 第一天从星期几开始，0 = 周日，1 = 周一，…，6 = 周六。默认 0（周日）。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| maxDate | DateTime? | - | 最大可选的日期，默认 2100-12-31 |
| minDate | DateTime? | - | 最小可选的日期，默认 1970-01-01 |
| monthTitleBuilder | TCalendarMonthTitleBuilder? | - | 月标题构建器，参数 `DateTime` 为当月 1 日（仅年月有效）。 |
| onChanged | ValueChanged<List<DateTime>>? | - | 选中结果变化时触发（单选立即触发；多选每次切换；区间在端点变化时触发）。 父组件应在回调中更新 `value`。组件挂载时不会调用本回调。 |
| onMonthChanged | ValueChanged<DateTime>? | - | 可见月份变化时触发（用户滑动或程序化滚动结束后），参数为当月 1 日。 外置控制栏可只更新自身文案，避免为同步月份对 `TCalendar` 整组件 `setState`。 |
| subtitleBuilder | TCalendarSubtitleBuilder? | - | 副标题构建器，在日期主数字下方渲染自定义内容。 `TCalendarSubtitleContext.date` 为当前格日期； `TCalendarSubtitleContext.selectType` 为选中/区间/禁用等态。返回 null 不显示副标题行。 |
| value | List<DateTime> | - | 受控选中日期列表。 列表长度与 `variant` 对应： - `TCalendarVariant.single`：1 个元素（选中日期） - `TCalendarVariant.multiple`：N 个元素（所有选中日期） - `TCalendarVariant.range`：2 个元素（起始、结束日期） |
| variant | TCalendarVariant | TCalendarVariant.single | 日历的选择模式，决定点击日期后的选中行为： - `TCalendarVariant.single`：单选，点击新日期取消旧选中 - `TCalendarVariant.multiple`：多选，点击切换选中/取消 - `TCalendarVariant.range`：区间选择，依次选起止日期 |


### TCalendarCellModel
#### 简介
单个日期格数据（只读，选中态通过 `typeNotifier` 更新）
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| date | DateTime | - | 当前日期。 |
| isLastDayOfMonth | bool | - | 是否为当月最后一天。 |
| typeNotifier | DateSelectTypeNotifier | - | 日期选择状态通知器。 |


### TCalendarSubtitleContext
#### 简介
副标题构建上下文：告知 `TCalendarSubtitleBuilder` 当前渲染哪一格。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| date | DateTime | - | 当前格子的阳历日期（仅年月日，无时分秒）。 |
| selectType | DateSelectType | - | 当前格的选中/区间/禁用等展示状态，便于按态设置副标题样式。 |


### TCalendarThemeData
#### 简介
TCalendar 组件级 ThemeExtension
包含日历样式默认（装饰、字体、布局参数）。
样式字段通过 mergeExtension 子树覆盖，无需构造器 P0 `style` 参数。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| bodyPadding | double? | - | 内边距 |
| cellDecoration | BoxDecoration? | - | 日期单元格装饰（选中状态） |
| cellHeight | double? | - | 日期单元格高度，默认 60 |
| centreColor | Color? | - | 区间中间格背景与格间衔接条颜色 |
| dayStyle | TextStyle? | - | 日期数字样式 |
| decoration | BoxDecoration? | - | 组件容器装饰 |
| height | double? | - | 高度 |
| monthTitleHeight | double? | - | 月份标题高度，默认 22 |
| monthTitleStyle | TextStyle? | - | 月份标题文字样式 |
| subtitleStyle | TextStyle? | - | 副标题样式 |
| todayDayStyle | TextStyle? | - | 今天日期数字样式 |
| verticalGap | double? | - | 日期格垂直间距，水平间距为 `verticalGap` / 2 |
| weekdayGap | double? | - | 星期之间的水平间距 |
| weekdayStyle | TextStyle? | - | 星期文字样式 |


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

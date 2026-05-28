## API
### TCalendar
#### 简介
日历组件

#### 静态方法

##### TCalendar.showPopup

弹出日历选择器，返回选中的日期列表。
取消或关闭弹窗时返回 `null`；点击确认时返回选中的 `DateTime` 列表。
弹窗内点选过程无 `onChange`；实时联动请用 `popupOverlayBuilder` 的 `dates`，
或自行用 `TCalendarInherited` 监听 `TCalendarInherited.selectedListenable`。
```dart
final result = await TCalendar.showPopup(
  context,
  titleWidget: Text('请选择日期'),
  type: CalendarType.single,
);
if (result != null) {
  print('选中了: $result');
}
```
若需完全自定义布局，请直接使用 `TCalendar` + `TPopup.show`
/ `TPopupOptions.bottom` 自行组装。

返回类型：`Future<List<DateTime>?>`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | - |
| titleWidget | Widget? | - | 标题组件，可传入 Text 或自定义 Widget |
| type | CalendarType | CalendarType.single | 日历的选择模式，决定点击日期后的选中行为： - `CalendarType.single`：单选，点击新日期取消旧选中 - `CalendarType.multiple`：多选，点击切换选中/取消 - `CalendarType.range`：区间选择，依次选起止日期 |
| initialValue | List<DateTime>? | - | 初始选中日期列表，不传则默认今天。 **非受控语义**：仅用于首次挂载；用户点选后以 `onChange` 为准，由调用方自行 `setState` 保存。若父组件在运行期修改本参数，会同步选中态并刷新格子（与 range 行为一致）。 列表长度与 `type` 对应： - `CalendarType.single`：1 个元素（选中日期） - `CalendarType.multiple`：N 个元素（所有选中日期） - `CalendarType.range`：2 个元素（起始、结束日期） |
| minDate | DateTime? | - | 最小可选的日期，不传则默认 1970-01-01 |
| maxDate | DateTime? | - | 最大可选的日期，不传则默认 2100-12-31 |
| anchorDate | DateTime? | - | 锚点日期，打开时滚动到该日期所在月份。 |
| anchorRevision | int | 0 | 锚点滚动触发序号，默认 `0`。 与 `anchorDate` 配合：序号递增可重复滚到同一月份；仅改月份时也可只更新 `anchorDate`。 |
| popupHeight | double? | - | - |
| firstDayOfWeek | int | 0 | 第一天从星期几开始，0 = 周日，1 = 周一，…，6 = 周六。默认 0（周日）。 |
| cellHeight | double? | - | 日期单元格高度，默认 60。如需更大行高可传入自定义值（如 80） |
| style | TCalendarStyle? | - | 自定义样式 |
| popupOverlayBuilder | Widget Function(BuildContext context, List<DateTime> selectedDates)? | - | - |
| popupOverlayExpanded | ValueListenable<bool>? | - | - |
| confirmBtnBuilder | Widget Function(VoidCallback onConfirm)? | - | - |
| onConfirm | void Function(List<DateTime>)? | - | - |
| onClose | VoidCallback? | - | - |
| onCellClick | void Function(DateTime value, DateSelectType selectType, TCalendarCellModel cell)? | - | 点击日期时触发 |
| cellBuilder | TCalendarCellBuilder? | - | 整格自定义；设置后不再使用默认主区/副标题布局。 |
| subtitleBuilder | TCalendarSubtitleBuilder? | - | 副标题完全自定义；未设置时可使用 `dataSource.getSubtitle`。 |
| dataSource | TCalendarDataSource? | - | 可选数据源，提供副标题字符串（无 `subtitleBuilder` 时生效）。 |
| onMonthChange | ValueChanged<DateTime>? | - | 月份变化时触发 |
| monthTitleBuilder | Widget Function(BuildContext context, DateTime monthDate)? | - | 月标题构建器 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| anchorDate | DateTime? | - | 锚点日期，打开时滚动到该日期所在月份。 |
| anchorRevision | int | 0 | 锚点滚动触发序号，默认 `0`。 与 `anchorDate` 配合：序号递增可重复滚到同一月份；仅改月份时也可只更新 `anchorDate`。 |
| animateTo | bool | false | 滚动到选中日期/锚点日期所在月份时是否使用动画，默认 false |
| cellBuilder | TCalendarCellBuilder? | - | 整格自定义；设置后不再使用默认主区/副标题布局。 |
| cellHeight | double? | - | 日期单元格高度，默认 60。如需更大行高可传入自定义值（如 80） |
| dataSource | TCalendarDataSource? | - | 可选数据源，提供副标题字符串（无 `subtitleBuilder` 时生效）。 |
| firstDayOfWeek | int | 0 | 第一天从星期几开始，0 = 周日，1 = 周一，…，6 = 周六。默认 0（周日）。 |
| height | double? | - | 高度，不传时内嵌模式自动按 5 行日期计算 |
| initialValue | List<DateTime>? | - | 初始选中日期列表，不传则默认今天。 **非受控语义**：仅用于首次挂载；用户点选后以 `onChange` 为准，由调用方自行 `setState` 保存。若父组件在运行期修改本参数，会同步选中态并刷新格子（与 range 行为一致）。 列表长度与 `type` 对应： - `CalendarType.single`：1 个元素（选中日期） - `CalendarType.multiple`：N 个元素（所有选中日期） - `CalendarType.range`：2 个元素（起始、结束日期） |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| maxDate | DateTime? | - | 最大可选的日期，不传则默认 2100-12-31 |
| minDate | DateTime? | - | 最小可选的日期，不传则默认 1970-01-01 |
| monthTitleBuilder | Widget Function(BuildContext context, DateTime monthDate)? | - | 月标题构建器 |
| monthTitleHeight | double | 22 | 每月标题行高度（如 '2025年6月' 所在行），默认 22 |
| onCellClick | void Function(DateTime value, DateSelectType selectType, TCalendarCellModel cell)? | - | 点击日期时触发 |
| onChange | void Function(List<DateTime> value)? | - | 选中值变化时触发 |
| onMonthChange | ValueChanged<DateTime>? | - | 月份变化时触发 |
| safeAreaInset | bool | true | 是否适配底部安全区域（如 iPhone Home Indicator），默认 true |
| style | TCalendarStyle? | - | 自定义样式 |
| subtitleBuilder | TCalendarSubtitleBuilder? | - | 副标题完全自定义；未设置时可使用 `dataSource.getSubtitle`。 |
| titleWidget | Widget? | - | 标题组件，可传入 Text 或自定义 Widget |
| type | CalendarType | CalendarType.single | 日历的选择模式，决定点击日期后的选中行为： - `CalendarType.single`：单选，点击新日期取消旧选中 - `CalendarType.multiple`：多选，点击切换选中/取消 - `CalendarType.range`：区间选择，依次选起止日期 |


### TCalendarInherited
#### 简介
日历弹窗状态的 InheritedWidget 容器。
由上层（如 `TSlidePopupRoute` 的 builder）包裹在 `TCalendar` 外侧，
将选中态、确认/关闭回调等注入子树。

#### 静态方法

##### TCalendarInherited.of

返回类型：`TCalendarInherited?`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | - |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget | - | - |
| confirmBtnBuilder | Widget Function(VoidCallback onConfirm)? | - | 自定义确认按钮；`onConfirm` 与默认确认按钮一致（回传选中值并关闭弹窗）。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onClose | VoidCallback? | - | - |
| onConfirm | VoidCallback? | - | - |
| popupConfirmBtn | bool? | - | 是否由 `TCalendar` 渲染底部确认按钮。 为 `null`（默认）时跟随 `popupControls`；显式设置时覆盖。 |
| popupControls | bool | true | 是否由 `TCalendar` 自行渲染关闭按钮和标题行。 为 `true`（默认）时 `TCalendar` 渲染关闭按钮与标题行； 为 `false` 时由外层弹窗容器承载。 |
| popupOverlayBuilder | Widget Function(BuildContext context, List<DateTime> selectedDates)? | - | 弹窗模式下日历内容区底部浮层构建器（非 `TPopup` 面板底部）。 由 `TCalendar.showPopup` 或手动 `TCalendarInherited` 注入； `selectedDates` 随点选实时更新。 |
| popupOverlayExpanded | ValueListenable<bool>? | - | 浮层是否展开（响应式），需配合 `popupOverlayBuilder`。 |
| selected | ValueNotifier<List<DateTime>> | - | 选中态的可写引用（仅供 `TCalendar` 内部更新使用）。 对外消费方请使用 `selectedListenable` 这一只读视图。 |
| usePopup | bool? | true | - |


### TCalendarStyle
#### 简介
日历组件样式

#### 工厂构造方法

##### TCalendarStyle.forSelectType

按选中态生成单元格样式

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
| centreColor | Color? | - | 日期范围内背景样式 |
| dayStyle | TextStyle? | - | 日期主区（默认阳历日数字）样式 |
| decoration | BoxDecoration? | - | - |
| monthTitleStyle | TextStyle? | - | body区域 年月文字样式 |
| subtitleStyle | TextStyle? | - | 副标题样式（仅 `TCalendarDataSource.getSubtitle` 字符串路径使用） |
| titleCloseColor | Color? | - | header区域 关闭图标的颜色 |
| titleMaxLine | int? | - | header区域 `TCalendar.titleWidget`的行数 |
| titleStyle | TextStyle? | - | header区域 `TCalendar.titleWidget`的样式 |
| todayDayStyle | TextStyle? | - | 今天日期主区样式 |
| weekdayStyle | TextStyle? | - | header区域 周 文字样式 |

#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| bodyPadding | double? | - | 月与月之间的垂直间距 |
| verticalGap | double? | - | 日期垂直间距，水平间距为`verticalGap` / 2 |


### TCalendarDataSource
#### 简介
日历可选数据源：仅提供副标题文案（无 `subtitleBuilder` 时使用）。
农历、节气、节日等均由接入方在 `TCalendar.subtitleBuilder` 或
`getSubtitle` 中自行处理；组件主区默认只渲染阳历日数字。

#### 方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| getSubtitle | String? | required DateTime date | 副标题文案；返回 null 或空字符串时不显示副标题行。 |


### TCalendarCellModel
#### 简介
单个日期格数据（只读，选中态通过 `typeNotifier` 更新）
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| date | DateTime | - | - |
| isLastDayOfMonth | bool | - | - |
| typeNotifier | DateSelectTypeNotifier | - | - |


### CalendarType
#### 简介
日历选择模式
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| single | 单选：点击新日期时自动取消旧日期的选中状态 |
| multiple | 多选：点击日期切换选中/取消，可同时选中多个日期 |
| range | 区间选择：第一次点击选起点，第二次点击选终点，中间自动填充 |


### DateSelectType
#### 简介
日期在日历格中的选中/展示状态
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| selected | - |
| disabled | - |
| start | - |
| centre | - |
| end | - |
| empty | - |


### TCalendarSubtitleBuilder
#### 简介
副标题完全自定义
#### 类型定义

```dart
typedef TCalendarSubtitleBuilder = Widget? Function(BuildContext context, TCalendarSubtitleContext subtitleContext);
```


### TCalendarCellBuilder
#### 简介
整格自定义（主区 + 副标题均由接入方绘制）
#### 类型定义

```dart
typedef TCalendarCellBuilder = Widget? Function(BuildContext context, TCalendarCellModel cell);
```

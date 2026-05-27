## API
### TCalendar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| anchorDate | DateTime? | - | 锚点日期，打开时滚动到该日期所在月份。 |
| anchorRevision | int | 0 | 锚点滚动触发序号，默认 `0`。 |
| animateTo | bool | false | 滚动到选中日期/锚点日期所在月份时是否使用动画，默认 false |
| cellBuilder | TCalendarCellBuilder? | - | 整格自定义；设置后不再使用默认主区/副标题布局。 |
| cellHeight | double? | - | 日期单元格高度，默认 60。如需更大行高可传入自定义值（如 80） |
| dataSource | TCalendarDataSource? | - | 可选数据源，提供副标题字符串（无 [subtitleBuilder] 时生效）。 |
| firstDayOfWeek | int | 0 | 第一天从星期几开始，0 = 周日，1 = 周一，…，6 = 周六。默认 0（周日）。 |
| height | double? | - | 高度，不传时内嵌模式自动按 5 行日期计算 |
| initialValue | List<DateTime>? | - | 初始选中日期列表，不传则默认今天。 |
| key |  | - |  |
| maxDate | DateTime? | - | 最大可选的日期，不传则默认 2100-12-31 |
| minDate | DateTime? | - | 最小可选的日期，不传则默认 1970-01-01 |
| monthTitleBuilder | Widget Function(BuildContext context, DateTime monthDate)? | - | 月标题构建器 |
| monthTitleHeight | double | 22 | 每月标题行高度（如 '2025年6月' 所在行），默认 22 |
| onCellClick | void Function(DateTime value, DateSelectType selectType, TCalendarCellModel cell)? | - | 点击日期时触发 |
| onChange | void Function(List<DateTime> value)? | - | 选中值变化时触发 |
| onMonthChange | ValueChanged<DateTime>? | - | 月份变化时触发 |
| safeAreaInset | bool | true | 是否适配底部安全区域（如 iPhone Home Indicator），默认 true |
| style | TCalendarStyle? | - | 自定义样式 |
| subtitleBuilder | TCalendarSubtitleBuilder? | - | 副标题完全自定义；未设置时可使用 [dataSource.getSubtitle]。 |
| titleWidget | Widget? | - | 标题组件，可传入 Text 或自定义 Widget |
| type | CalendarType | CalendarType.single | 日历的选择模式，决定点击日期后的选中行为： |


#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| showPopup |  |   required BuildContext context,  Widget? titleWidget,  CalendarType type,  List<DateTime>? initialValue,  DateTime? minDate,  DateTime? maxDate,  DateTime? anchorDate,  int anchorRevision,  double? popupHeight,  int firstDayOfWeek,  double? cellHeight,  TCalendarStyle? style,  Widget Function(BuildContext context, List<DateTime> selectedDates)? popupOverlayBuilder,  ValueListenable<bool>? popupOverlayExpanded,  Widget Function(VoidCallback onConfirm)? confirmBtnBuilder,  void Function(List<DateTime>)? onConfirm,  VoidCallback? onClose,  void Function(DateTime value, DateSelectType selectType, TCalendarCellModel cell)? onCellClick,  TCalendarCellBuilder? cellBuilder,  TCalendarSubtitleBuilder? subtitleBuilder,  TCalendarDataSource? dataSource,  ValueChanged<DateTime>? onMonthChange,  Widget Function(BuildContext context, DateTime monthDate)? monthTitleBuilder, | 弹出日历选择器，返回选中的日期列表。     取消或关闭弹窗时返回 `null`；点击确认时返回选中的 [DateTime] 列表。   弹窗内点选过程无 [onChange]；实时联动请用 [popupOverlayBuilder] 的 `dates`，   或自行用 [TCalendarInherited] 监听 [TCalendarInherited.selectedListenable]。     ```dart   final result = await TCalendar.showPopup(     context,     titleWidget: Text('请选择日期'),     type: CalendarType.single,   );   if (result != null) {     print('选中了: $result');   }   ```     若需完全自定义布局，请直接使用 [TCalendar] + [TPopup.show]   / [TPopupOptions.bottom] 自行组装。 |

```
```

### TCalendarInherited
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child |  | - |  |
| confirmBtnBuilder | Widget Function(VoidCallback onConfirm)? | - | 自定义确认按钮；[onConfirm] 与默认确认按钮一致（回传选中值并关闭弹窗）。 |
| key |  | - |  |
| onClose |  | - |  |
| onConfirm |  | - |  |
| popupOverlayBuilder | Widget Function(BuildContext context, List<DateTime> selectedDates)? | - | 弹窗模式下日历内容区底部浮层构建器（非 TPopup 面板底部），由 [TCalendar.showPopup] 或手动 |
| popupOverlayExpanded | ValueListenable<bool>? | - | 浮层是否展开（响应式），需配合 [popupOverlayBuilder]。 |
| popupConfirmBtn | bool? | - | 是否由 [TCalendar] 渲染底部确认按钮。 |
| popupControls | bool | true | 是否由 [TCalendar] 自行渲染关闭按钮和标题行。 |
| selected | ValueNotifier<List<DateTime>> | - | 选中态的可写引用（仅供 [TCalendar] 内部更新使用）。 |
| usePopup |  | true |  |


#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| of |  |   required BuildContext context, |  |

```
```

### TCalendarStyle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| cellDecoration | BoxDecoration? | - | 日期decoration |
| centreColor | Color? | - | 日期范围内背景样式 |
| dayStyle | TextStyle? | - | 日期主区（默认阳历日数字）样式 |
| decoration |  | - |  |
| monthTitleStyle | TextStyle? | - | body区域 年月文字样式 |
| subtitleStyle | TextStyle? | - | 副标题样式（仅 [TCalendarDataSource.getSubtitle] 字符串路径使用） |
| titleCloseColor | Color? | - | header区域 关闭图标的颜色 |
| titleMaxLine | int? | - | header区域 [TCalendar.titleWidget]的行数 |
| titleStyle | TextStyle? | - | header区域 [TCalendar.titleWidget]的样式 |
| todayDayStyle | TextStyle? | - | 今天日期主区样式 |
| weekdayStyle | TextStyle? | - | header区域 周 文字样式 |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TCalendarStyle.forSelectType  | 按选中态生成单元格样式 |
| TCalendarStyle.generateStyle  | 生成默认样式 |

```
```

### TCalendarDataSource
```
```

### TCalendarCellModel
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| date |  | - |  |
| isLastDayOfMonth |  | - |  |
| typeNotifier |  | - |  |

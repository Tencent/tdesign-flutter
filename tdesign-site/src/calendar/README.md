---
title: Calendar 日历
description: 按照日历形式展示数据或日期的容器。
spline: base
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

在tdesign_flutter/tdesign_flutter.dart中有所有组件的路径。

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

[td_calendar_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_calendar_page.dart)

### 1 组件类型



          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildSimple(BuildContext context) {
  return const _SimpleDemo();
}</pre>

</td-code-block>
                
### 1 组件样式

自定义文案、按钮、单元格

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildStyle(BuildContext context) {
  const map = {
    1: '初一',
    2: '初二',
    3: '初三',
    14: '情人节',
    15: '元宵节',
  };

  final customTextSelected =
      ValueNotifier<List<DateTime>>([DateTime(2022, 1, 15)]);
  final customBtnSelected =
      ValueNotifier<List<DateTime>>([DateTime.now()]);
  final customCellSelected = ValueNotifier<List<DateTime>>(
      [DateTime.now().add(const Duration(days: 30))]);

  return ValueListenableBuilder(
    valueListenable: customTextSelected,
    builder: (context, textSelected, _) {
      return ValueListenableBuilder(
        valueListenable: customBtnSelected,
        builder: (context, btnSelected, _) {
          return ValueListenableBuilder(
            valueListenable: customCellSelected,
            builder: (context, cellValue, _) {
              final cellDate = cellValue[0];
              return TCellGroup(
                cells: [
          // 1. 自定义文案（cellWidget 回调自定义 cell 渲染）
          TCell(
            title: '自定义文案',
            arrow: true,
            note: _formatYmd(textSelected),
            onClick: (_) {
              TCalendar.showPopup(
                context,
                titleWidget: const Text('请选择日期'),
                initialValue: textSelected,
                minDate: DateTime(2022, 1, 1),
                maxDate: DateTime(2022, 2, 15),
                onConfirm: (value) => customTextSelected.value = value,
                cellWidget: (context, tdate, selectType) {
                  final isSpecial = tdate.date.month == 2 &&
                      map.keys.contains(tdate.date.day);
                  final suffix = isSpecial ? '¥100' : '¥60';
                  final prefix = isSpecial ? map[tdate.date.day] : null;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (prefix != null)
                        Text(prefix,
                            style: TextStyle(
                              fontSize: 9,
                              color: isSpecial
                                  ? TTheme.of(context).errorColor6
                                  : null,
                            )),
                      Text(
                        tdate.date.day.toString(),
                        style: TextStyle(
                          color: selectType == DateSelectType.selected
                              ? TTheme.of(context).fontWhColor1
                              : isSpecial
                                  ? TTheme.of(context).errorColor6
                                  : null,
                        ),
                      ),
                      Text(suffix,
                          style: TextStyle(
                            fontSize: 9,
                            color: selectType == DateSelectType.selected
                                ? TTheme.of(context).fontWhColor1
                                : isSpecial
                                    ? TTheme.of(context).errorColor6
                                    : null,
                          )),
                    ],
                  );
                },
              );
            },
          ),

          // 2. 自定义确认按钮
          TCell(
            title: '自定义按钮',
            arrow: true,
            note: _formatYmd(btnSelected),
            onClick: (_) {
              TCalendar.showPopup(
                context,
                titleWidget: const Text('请选择日期'),
                initialValue: btnSelected,
                confirmBtnBuilder: (onConfirm) => Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: TTheme.of(context).spacer16),
                  child: TButton(
                    theme: TButtonTheme.danger,
                    shape: TButtonShape.round,
                    text: 'ok',
                    isBlock: true,
                    size: TButtonSize.large,
                    onTap: onConfirm,
                  ),
                ),
                onConfirm: (value) => customBtnSelected.value = value,
              );
            },
          ),

          // 3. 自定义日期单元格（cellWidget 回调）
          TCell(
            title: '自定义日期单元格',
            arrow: true,
            note: '${cellDate.year}-${cellDate.month}-${cellDate.day}',
            onClick: (cell) {
              TCalendar.showPopup(
                context,
                titleWidget: const Text('请选择日期'),
                initialValue: cellValue,
                cellHeight: 80,
                onConfirm: (value) => customCellSelected.value = value,
                cellWidget: (context, tdate, selectType) {
                  final today = DateTime.now();
                  final isToday = tdate.date ==
                      DateTime(today.year, today.month, today.day);

                  if (isToday && selectType != DateSelectType.selected) {
                    return _CustomCellContainer(
                      color: TTheme.of(context).brandColor4,
                      child: const Text('今天',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    );
                  }
                  if (selectType == DateSelectType.selected) {
                    return _CustomCellContainer(
                      color: TTheme.of(context).successColor8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${tdate.date.day}',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          const Text('已选',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white)),
                        ],
                      ),
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${tdate.date.day}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const Text('自定义', style: TextStyle(fontSize: 8)),
                    ],
                  );
                },
              );
            },
          ),
                ],
              );
            },
          );
        },
      );
    },
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildStyle(BuildContext context) {
  const map = {
    1: '初一',
    2: '初二',
    3: '初三',
    14: '情人节',
    15: '元宵节',
  };

  final customTextSelected =
      ValueNotifier<List<DateTime>>([DateTime(2022, 1, 15)]);
  final customBtnSelected =
      ValueNotifier<List<DateTime>>([DateTime.now()]);
  final customCellSelected = ValueNotifier<List<DateTime>>(
      [DateTime.now().add(const Duration(days: 30))]);

  return ValueListenableBuilder(
    valueListenable: customTextSelected,
    builder: (context, textSelected, _) {
      return ValueListenableBuilder(
        valueListenable: customBtnSelected,
        builder: (context, btnSelected, _) {
          return ValueListenableBuilder(
            valueListenable: customCellSelected,
            builder: (context, cellValue, _) {
              final cellDate = cellValue[0];
              return TCellGroup(
                cells: [
          // 1. 自定义文案（cellWidget 回调自定义 cell 渲染）
          TCell(
            title: '自定义文案',
            arrow: true,
            note: _formatYmd(textSelected),
            onClick: (_) {
              TCalendar.showPopup(
                context,
                titleWidget: const Text('请选择日期'),
                initialValue: textSelected,
                minDate: DateTime(2022, 1, 1),
                maxDate: DateTime(2022, 2, 15),
                onConfirm: (value) => customTextSelected.value = value,
                cellWidget: (context, tdate, selectType) {
                  final isSpecial = tdate.date.month == 2 &&
                      map.keys.contains(tdate.date.day);
                  final suffix = isSpecial ? '¥100' : '¥60';
                  final prefix = isSpecial ? map[tdate.date.day] : null;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (prefix != null)
                        Text(prefix,
                            style: TextStyle(
                              fontSize: 9,
                              color: isSpecial
                                  ? TTheme.of(context).errorColor6
                                  : null,
                            )),
                      Text(
                        tdate.date.day.toString(),
                        style: TextStyle(
                          color: selectType == DateSelectType.selected
                              ? TTheme.of(context).fontWhColor1
                              : isSpecial
                                  ? TTheme.of(context).errorColor6
                                  : null,
                        ),
                      ),
                      Text(suffix,
                          style: TextStyle(
                            fontSize: 9,
                            color: selectType == DateSelectType.selected
                                ? TTheme.of(context).fontWhColor1
                                : isSpecial
                                    ? TTheme.of(context).errorColor6
                                    : null,
                          )),
                    ],
                  );
                },
              );
            },
          ),

          // 2. 自定义确认按钮
          TCell(
            title: '自定义按钮',
            arrow: true,
            note: _formatYmd(btnSelected),
            onClick: (_) {
              TCalendar.showPopup(
                context,
                titleWidget: const Text('请选择日期'),
                initialValue: btnSelected,
                confirmBtnBuilder: (onConfirm) => Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: TTheme.of(context).spacer16),
                  child: TButton(
                    theme: TButtonTheme.danger,
                    shape: TButtonShape.round,
                    text: 'ok',
                    isBlock: true,
                    size: TButtonSize.large,
                    onTap: onConfirm,
                  ),
                ),
                onConfirm: (value) => customBtnSelected.value = value,
              );
            },
          ),

          // 3. 自定义日期单元格（cellWidget 回调）
          TCell(
            title: '自定义日期单元格',
            arrow: true,
            note: '${cellDate.year}-${cellDate.month}-${cellDate.day}',
            onClick: (cell) {
              TCalendar.showPopup(
                context,
                titleWidget: const Text('请选择日期'),
                initialValue: cellValue,
                cellHeight: 80,
                onConfirm: (value) => customCellSelected.value = value,
                cellWidget: (context, tdate, selectType) {
                  final today = DateTime.now();
                  final isToday = tdate.date ==
                      DateTime(today.year, today.month, today.day);

                  if (isToday && selectType != DateSelectType.selected) {
                    return _CustomCellContainer(
                      color: TTheme.of(context).brandColor4,
                      child: const Text('今天',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    );
                  }
                  if (selectType == DateSelectType.selected) {
                    return _CustomCellContainer(
                      color: TTheme.of(context).successColor8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${tdate.date.day}',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          const Text('已选',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white)),
                        ],
                      ),
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${tdate.date.day}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const Text('自定义', style: TextStyle(fontSize: 8)),
                    ],
                  );
                },
              );
            },
          ),
                ],
              );
            },
          );
        },
      );
    },
  );
}</pre>

</td-code-block>
                

农历日历

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildLunar(BuildContext context) {
  return const _LunarCalendarDemo();
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildLunar(BuildContext context) {
  return const _LunarCalendarDemo();
}</pre>

</td-code-block>
                


## API
### TCalendar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| anchorDate | DateTime? | - | 锚点日期，弹出时自动滚动到该日期所在月份。 |
| animateTo | bool | false | 滚动到选中日期/锚点日期所在月份时是否使用动画，默认 false |
| cellHeight | double? | - | 日期单元格高度，默认 60。如需更大行高可传入自定义值（如 80） |
| cellWidget | Widget? Function(BuildContext context, TDate tdate, DateSelectType selectType)? | - | 自定义日期单元格组件 |
| dataSource | TCalendarDataSource? | - | 外部数据源，用于提供农历转换等功能。 |
| displayMode | TCalendarDisplayMode | TCalendarDisplayMode.solar | 日历显示模式，控制日期单元格的主/副文本内容： |
| firstDayOfWeek | int | 0 | 第一天从星期几开始，0 = 周日，1 = 周一，…，6 = 周六。默认 0（周日）。 |
| height | double? | - | 高度，不传时内嵌模式自动按 5 行日期计算 |
| initialValue | List<DateTime>? | - | 初始选中日期列表，不传则默认今天。 |
| key |  | - |  |
| maxDate | DateTime? | - | 最大可选的日期，不传则默认 2100-12-31 |
| minDate | DateTime? | - | 最小可选的日期，不传则默认 1970-01-01 |
| monthTitleBuilder | Widget Function(BuildContext context, DateTime monthDate)? | - | 月标题构建器 |
| monthTitleHeight | double | 22 | 每月标题行高度（如 '2025年6月' 所在行），默认 22 |
| onCellClick | void Function(DateTime value, DateSelectType selectType, TDate tdate)? | - | 点击日期时触发 |
| onChange | void Function(List<DateTime> value)? | - | 选中值变化时触发 |
| onMonthChange | ValueChanged<DateTime>? | - | 月份变化时触发 |
| safeAreaInset | bool | true | 是否适配底部安全区域（如 iPhone Home Indicator），默认 true |
| style | TCalendarStyle? | - | 自定义样式 |
| titleWidget | Widget? | - | 标题组件，可传入 Text 或自定义 Widget |
| type | CalendarType | CalendarType.single | 日历的选择模式，决定点击日期后的选中行为： |


#### 静态方法

| 名称 | 返回类型 | 参数 | 说明 |
| --- | --- | --- | --- |
| showPopup |  |   required BuildContext context,  Widget? titleWidget,  CalendarType type,  List<DateTime>? initialValue,  DateTime? minDate,  DateTime? maxDate,  DateTime? anchorDate,  double? popupHeight,  int firstDayOfWeek,  double? cellHeight,  TCalendarStyle? style,  Widget Function(BuildContext context, List<DateTime> selectedDates)? popupBottomBuilder,  ValueListenable<bool>? popupBottomExpanded,  Widget? confirmBtn,  Widget Function(VoidCallback onConfirm)? confirmBtnBuilder,  void Function(List<DateTime>)? onConfirm,  VoidCallback? onClose,  void Function(DateTime value, DateSelectType selectType, TDate tdate)? onCellClick,  bool autoClose,  bool draggable,  Widget? Function(BuildContext context, TDate tdate, DateSelectType selectType)? cellWidget,  TCalendarDisplayMode displayMode,  TCalendarDataSource? dataSource,  ValueChanged<DateTime>? onMonthChange,  Widget Function(BuildContext context, DateTime monthDate)? monthTitleBuilder, | 弹出日历选择器，返回选中的日期列表。     取消或关闭弹窗时返回 `null`；点击确认时返回选中的 [DateTime] 列表。     ```dart   final result = await TCalendar.showPopup(     context,     titleWidget: Text('请选择日期'),     type: CalendarType.single,   );   if (result != null) {     print('选中了: $result');   }   ```     若需完全自定义布局，请直接使用 [TCalendar] + [TPopupBottomDisplayPanel]   + [TSlidePopupRoute] 自行组装。 |

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
| titleMaxLine | int? | - | header区域 [TCalendar.titleWidget]的行数 |
| titleStyle | TextStyle? | - | header区域 [TCalendar.titleWidget]的样式 |
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


  
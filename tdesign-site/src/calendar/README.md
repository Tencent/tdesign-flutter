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
  final size = MediaQuery.of(context).size;
  final selected = ValueNotifier<List<int>>([DateTime.now().millisecondsSinceEpoch + 30 * 24 * 60 * 60 * 1000]);
  final selectedStartTime = ValueNotifier<List<int>>([DateTime.now().millisecondsSinceEpoch]);
  final selectedEndTime = ValueNotifier<List<int>>([DateTime.now().millisecondsSinceEpoch]);
  return Column(
    children: [
      ValueListenableBuilder(
        valueListenable: selected,
        builder: (context, value, child) {
          final date = DateTime.fromMillisecondsSinceEpoch(value[0]);

          return TDCellGroup(
            cells: [
              TDCell(
                title: '单个选择日历',
                arrow: true,
                note: '${date.year}-${date.month}-${date.day}',
                onClick: (cell) {
                  TDCalendarPopup(
                    context,
                    visible: true,
                    onConfirm: (value) {
                      print('onConfirm:$value');
                      selected.value = value;
                    },
                    onClose: () {
                      print('onClose');
                    },
                    child: TDCalendar(
                      title: '请选择日期',
                      value: value,
                      height: size.height * 0.6 + 176,
                      onCellClick: (value, type, tdate) {
                        print('onCellClick:$value');
                      },
                      onCellLongPress: (value, type, tdate) {
                        print('onCellLongPress:$value');
                      },
                      onHeaderClick: (index, week) {
                        print('onHeaderClick:$week');
                      },
                      onChange: (value) {
                        print('onChange:$value');
                      },
                    ),
                  );
                },
              ),
              TDCell(
                title: '多个选择日历',
                arrow: true,
                onClick: (cell) {
                  TDCalendarPopup(
                    context,
                    visible: true,
                    child: TDCalendar(
                      title: '请选择日期',
                      type: CalendarType.multiple,
                      value: [DateTime.now().millisecondsSinceEpoch],
                      height: size.height * 0.6 + 176,
                    ),
                  );
                },
              ),
              TDCell(
                title: '区间选择日历',
                arrow: true,
                onClick: (cell) {
                  TDCalendarPopup(
                    context,
                    visible: true,
                    child: TDCalendar(
                      title: '请选择日期区间',
                      type: CalendarType.range,
                      value: [
                        DateTime.now().millisecondsSinceEpoch,
                        DateTime.now().add(const Duration(days: 6)).millisecondsSinceEpoch,
                      ],
                      height: size.height * 0.6 + 176,
                    ),
                  );
                },
              ),
              TDCell(
                title: '单个选择日历和时间',
                arrow: true,
                note: '${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}',
                onClick: (cell) {
                  TDCalendarPopup(
                    context,
                    visible: true,
                    onConfirm: (value) {
                      print('onConfirm:$value');
                      selected.value = value;
                    },
                    onClose: () {
                      print('onClose');
                    },
                    child: TDCalendar(
                      title: '请选择日期和时间',
                      value: value,
                      height: size.height * 0.92,
                      useTimePicker: true,
                      // pickerHeight: 100,
                      // pickerItemCount: 2,
                      onCellClick: (value, type, tdate) {
                        print('onCellClick:$value');
                      },
                      onCellLongPress: (value, type, tdate) {
                        print('onCellLongPress:$value');
                      },
                      onHeaderClick: (index, week) {
                        print('onHeaderClick:$week');
                      },
                      onChange: (value) {
                        print('onChange:$value');
                      },
                    ),
                  );
                },
              ),
              TDCell(
                title: '区间选择日历和时间',
                arrow: true,
                onClick: (cell) {
                  TDCalendarPopup(
                    context,
                    visible: true,
                    onConfirm: (value) {
                      print('onConfirm:$value');
                    },
                    onClose: () {
                      print('onClose');
                    },
                    child: TDCalendar(
                      title: '请选择日期和时间区间',
                      height: size.height * 0.92,
                      type: CalendarType.range,
                      value: [
                        DateTime.now().millisecondsSinceEpoch,
                        DateTime.now().add(const Duration(days: 3)).millisecondsSinceEpoch,
                      ],
                      useTimePicker: true,
                      onCellClick: (value, type, tdate) {
                        print('onCellClick:$value');
                      },
                      onCellLongPress: (value, type, tdate) {
                        print('onCellLongPress:$value');
                      },
                      onHeaderClick: (index, week) {
                        print('onHeaderClick:$week');
                      },
                      onChange: (value) {
                        print('onChange:$value');
                      },
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
      ValueListenableBuilder(valueListenable: selectedStartTime, builder: (context, value, child) {
        DateTime dateStartTime = DateTime.fromMillisecondsSinceEpoch(value[0]);
        return TDCellGroup(  cells: [
          TDCell(
            title: '选择开始日历和时间',
            arrow: true,
            note:
            '${dateStartTime.year}-${dateStartTime.month}-${dateStartTime.day} ${dateStartTime.hour}:${dateStartTime.minute}:${dateStartTime.second}',
            onClick: (cell) {
              TDCalendarPopup(
                context,
                visible: true,
                onConfirm: (value) {
                  print('onConfirm:$value');
                  DateTime dateStartTime=  DateTime.fromMillisecondsSinceEpoch(value[0]);
                  print('${dateStartTime.year}-${dateStartTime.month}-${dateStartTime.day} ${dateStartTime.hour}:${dateStartTime.minute}:${dateStartTime.second}');
                  selectedStartTime.value = value;
                  selectedEndTime.value=value;
                },
                onClose: () {
                  print('onClose');
                },
                child: TDCalendar(
                  title: '选择开始日历和时间',
                  value: value,
                  height: size.height * 0.92,
                  useTimePicker: true,
                  // pickerHeight: 100,
                  // pickerItemCount: 2,
                  onCellClick: (value, type, tdate) {
                    print('onCellClick:$value');
                  },
                  onCellLongPress: (value, type, tdate) {
                    print('onCellLongPress:$value');
                  },
                  onHeaderClick: (index, week) {
                    print('onHeaderClick:$week');
                  },
                  onChange: (value) {
                    print('onChange:$value');
                  },
                ),
              );
            },
          ),
        ]);
      }),
      ValueListenableBuilder(valueListenable: selectedEndTime, builder: (context, value, child) {
        DateTime dateStartTime=DateTime.fromMillisecondsSinceEpoch(selectedStartTime.value[0]);
        DateTime dateEndTime = DateTime.fromMillisecondsSinceEpoch(value[0]);
        return TDCellGroup(  cells: [
          TDCell(
            title: '选择结束日历和时间',
            arrow: true,
            note:
            '${dateEndTime.year}-${dateEndTime.month}-${dateEndTime.day} ${dateEndTime.hour}:${dateEndTime.minute}:${dateEndTime.second}',
            onClick: (cell) {
              TDCalendarPopup(
                context,
                visible: true,
                onConfirm: (value) {
                  print('onConfirm:$value');

                  DateTime dateStartTime=DateTime.fromMillisecondsSinceEpoch(selectedStartTime.value[0]);
                  print( '开始：${dateStartTime.year}-${dateStartTime.month}-${dateStartTime.day} ${dateStartTime.hour}:${dateStartTime.minute}:${dateStartTime.second}');

                  DateTime dateEndTime=DateTime.fromMillisecondsSinceEpoch(value[0]);
                  print('结束：${dateEndTime.year}-${dateEndTime.month}-${dateEndTime.day} ${dateEndTime.hour}:${dateEndTime.minute}:${dateEndTime.second}');
                  selectedEndTime.value = value;
                },
                onClose: () {
                  print('onClose');
                },
                child: TDCalendar(
                  title: '选择结束日历和时间',
                  value: value,
                  minDate:selectedStartTime.value[0],
                  height: size.height * 0.92,
                  useTimePicker: true,
                  timePickerModel: [
                    DatePickerModel(
                      useYear: false,
                      useMonth: false,
                      useDay: false,
                      useWeekDay: false,
                      useHour: true,
                      useMinute: true,
                      useSecond: true,
                      dateStart: [
                        dateStartTime.year,
                        dateStartTime.month,
                        dateStartTime.day,
                        dateStartTime.hour,
                        dateStartTime.minute,
                        dateStartTime.second
                      ],
                      dateEnd: [2099, 12, 30, 23, 59, 59],
                      dateInitial:[dateEndTime.year, dateEndTime.month, dateEndTime.day, dateEndTime.hour, dateEndTime.minute, dateEndTime.second],
                    )
                  ],
                  // pickerHeight: 100,
                  // pickerItemCount: 2,
                  onCellClick: (value, type, tdate) {
                    print('onCellClick:$value');
                  },
                  onCellLongPress: (value, type, tdate) {
                    print('onCellLongPress:$value');
                  },
                  onHeaderClick: (index, week) {
                    print('onHeaderClick:$week');
                  },
                  onChange: (value) {
                    print('onChange:$value');
                  },
                ),
              );
            },
          ),
        ]);
      }),
    ],
  );
}</pre>

</td-code-block>
                
### 1 组件样式

可以自由定义想要的风格

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildStyle(BuildContext context) {
  final size = MediaQuery.of(context).size;
  const map = {
    1: '初一',
    2: '初二',
    3: '初三',
    14: '情人节',
    15: '元宵节',
  };
  return TDCellGroup(
    cells: [
      TDCell(
        title: '自定义文案',
        arrow: true,
        onClick: (cell) {
          TDCalendarPopup(
            context,
            visible: true,
            child: TDCalendar(
              title: '请选择日期',
              height: size.height * 0.6 + 176,
              minDate: DateTime(2022, 1, 1).millisecondsSinceEpoch,
              maxDate: DateTime(2022, 2, 15).millisecondsSinceEpoch,
              format: (day) {
                day?.suffix = '¥60';
                if (day?.date.month == 2) {
                  if (map.keys.contains(day?.date.day)) {
                    day?.suffix = '¥100';
                    day?.prefix = map[day.date.day];
                    day?.style = TextStyle(
                      fontSize: TDTheme.of(context).fontTitleMedium?.size,
                      height: TDTheme.of(context).fontTitleMedium?.height,
                      fontWeight: TDTheme.of(context).fontTitleMedium?.fontWeight,
                      color: TDTheme.of(context).errorColor6,
                    );
                    if (day?.typeNotifier.value == DateSelectType.selected) {
                      day?.style = day.style?.copyWith(color: TDTheme.of(context).fontWhColor1);
                    }
                  }
                }
                return null;
              },
            ),
          );
        },
      ),
      TDCell(
        title: '自定义按钮',
        arrow: true,
        onClick: (cell) {
          late final TDCalendarPopup calendar;
          calendar = TDCalendarPopup(
            context,
            visible: true,
            confirmBtn: Padding(
              padding: EdgeInsets.symmetric(vertical: TDTheme.of(context).spacer16),
              child: TDButton(
                theme: TDButtonTheme.danger,
                shape: TDButtonShape.round,
                text: 'ok',
                isBlock: true,
                size: TDButtonSize.large,
                onTap: () {
                  print(calendar.selected);
                  calendar.close();
                },
              ),
            ),
            child: TDCalendar(
              title: '请选择日期',
              value: [DateTime.now().millisecondsSinceEpoch],
              height: size.height * 0.6 + 176,
            ),
          );
        },
      ),
      TDCell(
        title: '自定义日期区间',
        arrow: true,
        onClick: (cell) {
          TDCalendarPopup(
            context,
            visible: true,
            child: TDCalendar(
              title: '请选择日期',
              minDate: DateTime(2000, 1, 1).millisecondsSinceEpoch,
              maxDate: DateTime(3000, 1, 1).millisecondsSinceEpoch,
              value: [DateTime(2024, 10, 1).millisecondsSinceEpoch],
              height: size.height * 0.6 + 176,
            ),
          );
        },
      ),
    ],
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildStyle(BuildContext context) {
  final size = MediaQuery.of(context).size;
  const map = {
    1: '初一',
    2: '初二',
    3: '初三',
    14: '情人节',
    15: '元宵节',
  };
  return TDCellGroup(
    cells: [
      TDCell(
        title: '自定义文案',
        arrow: true,
        onClick: (cell) {
          TDCalendarPopup(
            context,
            visible: true,
            child: TDCalendar(
              title: '请选择日期',
              height: size.height * 0.6 + 176,
              minDate: DateTime(2022, 1, 1).millisecondsSinceEpoch,
              maxDate: DateTime(2022, 2, 15).millisecondsSinceEpoch,
              format: (day) {
                day?.suffix = '¥60';
                if (day?.date.month == 2) {
                  if (map.keys.contains(day?.date.day)) {
                    day?.suffix = '¥100';
                    day?.prefix = map[day.date.day];
                    day?.style = TextStyle(
                      fontSize: TDTheme.of(context).fontTitleMedium?.size,
                      height: TDTheme.of(context).fontTitleMedium?.height,
                      fontWeight: TDTheme.of(context).fontTitleMedium?.fontWeight,
                      color: TDTheme.of(context).errorColor6,
                    );
                    if (day?.typeNotifier.value == DateSelectType.selected) {
                      day?.style = day.style?.copyWith(color: TDTheme.of(context).fontWhColor1);
                    }
                  }
                }
                return null;
              },
            ),
          );
        },
      ),
      TDCell(
        title: '自定义按钮',
        arrow: true,
        onClick: (cell) {
          late final TDCalendarPopup calendar;
          calendar = TDCalendarPopup(
            context,
            visible: true,
            confirmBtn: Padding(
              padding: EdgeInsets.symmetric(vertical: TDTheme.of(context).spacer16),
              child: TDButton(
                theme: TDButtonTheme.danger,
                shape: TDButtonShape.round,
                text: 'ok',
                isBlock: true,
                size: TDButtonSize.large,
                onTap: () {
                  print(calendar.selected);
                  calendar.close();
                },
              ),
            ),
            child: TDCalendar(
              title: '请选择日期',
              value: [DateTime.now().millisecondsSinceEpoch],
              height: size.height * 0.6 + 176,
            ),
          );
        },
      ),
      TDCell(
        title: '自定义日期区间',
        arrow: true,
        onClick: (cell) {
          TDCalendarPopup(
            context,
            visible: true,
            child: TDCalendar(
              title: '请选择日期',
              minDate: DateTime(2000, 1, 1).millisecondsSinceEpoch,
              maxDate: DateTime(3000, 1, 1).millisecondsSinceEpoch,
              value: [DateTime(2024, 10, 1).millisecondsSinceEpoch],
              height: size.height * 0.6 + 176,
            ),
          );
        },
      ),
    ],
  );
}</pre>

</td-code-block>
                

不使用Popup

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildBlock(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final selected = ValueNotifier<List<int>>([DateTime.now().millisecondsSinceEpoch + 30 * 24 * 60 * 60 * 1000]);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          SizedBox(width: TDTheme.of(context).spacer16),
          TDButton(
              text: '加一个月',
              size: TDButtonSize.small,
              theme: TDButtonTheme.primary,
              onTap: () {
                selected.value = [selected.value[0] + 30 * 24 * 60 * 60 * 1000];
              }),
          SizedBox(width: TDTheme.of(context).spacer16),
          TDButton(
              text: '减一个月',
              size: TDButtonSize.small,
              theme: TDButtonTheme.primary,
              onTap: () {
                selected.value = [selected.value[0] - 30 * 24 * 60 * 60 * 1000];
              }),
        ],
      ),
      SizedBox(height: TDTheme.of(context).spacer16),
      ValueListenableBuilder(
        valueListenable: selected,
        builder: (context, value, child) {
          return TDCalendar(
            title: '请选择日期',
            value: value,
            height: size.height * 0.6 + 176,
            animateTo: true,
          );
        },
      ),
    ],
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildBlock(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final selected = ValueNotifier<List<int>>([DateTime.now().millisecondsSinceEpoch + 30 * 24 * 60 * 60 * 1000]);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          SizedBox(width: TDTheme.of(context).spacer16),
          TDButton(
              text: '加一个月',
              size: TDButtonSize.small,
              theme: TDButtonTheme.primary,
              onTap: () {
                selected.value = [selected.value[0] + 30 * 24 * 60 * 60 * 1000];
              }),
          SizedBox(width: TDTheme.of(context).spacer16),
          TDButton(
              text: '减一个月',
              size: TDButtonSize.small,
              theme: TDButtonTheme.primary,
              onTap: () {
                selected.value = [selected.value[0] - 30 * 24 * 60 * 60 * 1000];
              }),
        ],
      ),
      SizedBox(height: TDTheme.of(context).spacer16),
      ValueListenableBuilder(
        valueListenable: selected,
        builder: (context, value, child) {
          return TDCalendar(
            title: '请选择日期',
            value: value,
            height: size.height * 0.6 + 176,
            animateTo: true,
          );
        },
      ),
    ],
  );
}</pre>

</td-code-block>
                


## API
### TDCalendarPopup
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | context | 上下文 |
| top | double? | - | 距离顶部的距离 |
| autoClose | bool? | true | 自动关闭；在点击关闭按钮、确认按钮、遮罩层时自动关闭 |
| confirmBtn | Widget? | - | 自定义确认按钮 |
| visible | bool? | - | 默认是否显示日历 |
| onClose | VoidCallback? | - | 关闭时触发 |
| onConfirm | void Function(List<int> value)? | - | 点击确认按钮时触发 |
| builder | CalendarBuilder? | - | 控件构建器，优先级高于[child] |
| child | TDCalendar? | - | 日历控件 |

```
```
 ### TDCalendar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| firstDayOfWeek | int? | 0 | 第一天从星期几开始，默认 0 = 周日 |
| format | CalendarFormat? | - | 用于格式化日期的函数，可定义日期前后的显示内容和日期样式 |
| maxDate | int? | - | 最大可选的日期(fromMillisecondsSinceEpoch)，不传则默认半年后 |
| minDate | int? | - | 最小可选的日期(fromMillisecondsSinceEpoch)，不传则默认今天 |
| title | String? | - | 标题 |
| titleWidget | Widget? | - | 标题组件 |
| type | CalendarType? | CalendarType.single | 日历的选择类型，single = 单选；multiple = 多选; range = 区间选择 |
| value | List<int>? | - | 当前选择的日期(fromMillisecondsSinceEpoch)，不传则默认今天，当 type = single 时数组长度为1 |
| displayFormat | String? | 'year month' | 年月显示格式，`year`表示年，`month`表示月，如`year month`表示年在前、月在后、中间隔一个空格 |
| cellHeight | double? | 60 | 日期高度 |
| height | double? | - | 高度 |
| width | double? | - | 宽度 |
| style | TDCalendarStyle? | - | 自定义样式 |
| onChange | void Function(List<int> value)? | - | 选中值变化时触发 |
| onCellClick | void Function(int value, DateSelectType type, TDate tdate)? | - | 点击日期时触发 |
| onCellLongPress | void Function(int value, DateSelectType type, TDate tdate)? | - | 长安日期时触发 |
| onHeaderClick | void Function(int index, String week)? | - | 点击周时触发 |
| useTimePicker | bool? | false | 是否显示时间选择器 |
| timePickerModel | List<DatePickerModel>? | - | 自定义时间选择器 |
| monthTitleHeight | double? | 22 | 月标题高度 |
| monthTitleBuilder | Widget Function(BuildContext context, DateTime monthDate)? | - | 月标题构建器 |
| pickerHeight | double? | 178 | 时间选择器List的视窗高度 |
| pickerItemCount | int? | 3 | 选择器List视窗中item个数，pickerHeight / pickerItemCount即item高度 |
| isTimeUnit | bool? | true | 是否显示时间单位 |
| animateTo | bool? | false | 动画滚动到指定位置 |

```
```
 ### TDCalendarStyle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| decoration |  | - |  |
| titleStyle | TextStyle? | - | header区域 [TDCalendar.title]的样式 |
| titleMaxLine | int? | - | header区域 [TDCalendar.title]的行数 |
| titleCloseColor | Color? | - | header区域 关闭图标的颜色 |
| weekdayStyle | TextStyle? | - | header区域 周 文字样式 |
| monthTitleStyle | TextStyle? | - | body区域 年月文字样式 |
| cellStyle | TextStyle? | - | 日期样式 |
| centreColor | Color? | - | 日期范围内背景样式 |
| cellDecoration | BoxDecoration? | - | 日期decoration |
| cellPrefixStyle | TextStyle? | - | 日期前面的字符串的样式 |
| cellSuffixStyle | TextStyle? | - | 日期后面的字符串的样式 |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TDCalendarStyle.generateStyle  | 生成默认样式 |
| TDCalendarStyle.cellStyle  | 日期样式 |


  
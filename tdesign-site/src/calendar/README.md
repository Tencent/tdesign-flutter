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
  final selected = ValueNotifier<List<int>>(
      [DateTime.now().millisecondsSinceEpoch + 30 * 24 * 60 * 60 * 1000]);
  return ValueListenableBuilder(
    valueListenable: selected,
    builder: (context, value, child) {
      final date = DateTime.fromMillisecondsSinceEpoch(value[0]);
      return TCellGroup(
        cells: [
          TCell(
            title: '单个选择日历',
            arrow: true,
            note: '${date.year}-${date.month}-${date.day}',
            onClick: (cell) {
              TCalendarPopup(
                context,
                visible: true,
                onConfirm: (value) {
                  print('onConfirm：$value');
                  selected.value = value;
                },
                onClose: () {
                  print('onClose');
                },
                child: TCalendar(
                  title: '请选择日期',
                  value: value,
                  height: size.height * 0.6 + 176,
                  onCellClick: (value, type, tdate) {
                    print('onCellClick: $value');
                  },
                  onCellLongPress: (value, type, tdate) {
                    print('onCellLongPress: $value');
                  },
                  onHeaderClick: (index, week) {
                    print('onHeaderClick: $week');
                  },
                  onChange: (value) {
                    print('onChange: $value');
                  },
                ),
              );
            },
          ),
          TCell(
            title: '多个选择日历',
            arrow: true,
            onClick: (cell) {
              TCalendarPopup(
                context,
                visible: true,
                child: TCalendar(
                  title: '请选择日期',
                  type: CalendarType.multiple,
                  value: [DateTime.now().millisecondsSinceEpoch],
                  height: size.height * 0.6 + 176,
                ),
              );
            },
          ),
          TCell(
            title: '区间选择日历',
            arrow: true,
            onClick: (cell) {
              TCalendarPopup(
                context,
                visible: true,
                child: TCalendar(
                  title: '请选择日期区间',
                  type: CalendarType.range,
                  value: [
                    DateTime.now().millisecondsSinceEpoch,
                    DateTime.now()
                        .add(const Duration(days: 6))
                        .millisecondsSinceEpoch,
                  ],
                  height: size.height * 0.6 + 176,
                ),
              );
            },
          ),
          TCell(
            title: '单个选择日历和时间',
            arrow: true,
            note:
                '${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}',
            onClick: (cell) {
              TCalendarPopup(
                context,
                visible: true,
                onConfirm: (value) {
                  print('onConfirm:$value');
                  selected.value = value;
                },
                onClose: () {
                  print('onClose');
                },
                child: TCalendar(
                  title: '请选择日期和时间',
                  value: value,
                  height: size.height * 0.92,
                  useTimePicker: true,
                  // pickerHeight: 100,
                  // pickerItemCount: 2,
                  onCellClick: (value, type, tdate) {
                    print('onCellClick: $value');
                  },
                  onCellLongPress: (value, type, tdate) {
                    print('onCellLongPress: $value');
                  },
                  onHeaderClick: (index, week) {
                    print('onHeaderClick: $week');
                  },
                  onChange: (value) {
                    print('onChange: $value');
                  },
                ),
              );
            },
          ),
          TCell(
            title: '区间选择日历和时间',
            arrow: true,
            onClick: (cell) {
              TCalendarPopup(
                context,
                visible: true,
                onConfirm: (value) {
                  print('onConfirm: $value');
                },
                onClose: () {
                  print('onClose');
                },
                child: TCalendar(
                  title: '请选择日期和时间区间',
                  height: size.height * 0.92,
                  type: CalendarType.range,
                  value: [
                    DateTime.now().millisecondsSinceEpoch,
                    DateTime.now()
                        .add(const Duration(days: 3))
                        .millisecondsSinceEpoch,
                  ],
                  useTimePicker: true,
                  onCellClick: (value, type, tdate) {
                    print('onCellClick: $value');
                  },
                  onCellLongPress: (value, type, tdate) {
                    print('onCellLongPress: $value');
                  },
                  onHeaderClick: (index, week) {
                    print('onHeaderClick: $week');
                  },
                  onChange: (value) {
                    print('onChange: $value');
                  },
                ),
              );
            },
          ),
          TCell(
            title: '添加锚点',
            arrow: true,
            note: '${date.year}-${date.month}-${date.day}',
            onClick: (cell) {
              TCalendarPopup(
                context,
                visible: true,
                onConfirm: (value) {
                  print('onConfirm：$value');
                  selected.value = value;
                },
                onClose: () {
                  print('onClose');
                },
                child: TCalendar(
                  title: '请选择日期',
                  minDate: DateTime(2022, 1, 1).millisecondsSinceEpoch,
                  maxDate: DateTime(2028, 2, 15).millisecondsSinceEpoch,
                  anchorDate: DateTime(2026, 5),
                  value: value,
                  height: size.height * 0.6 + 176,
                  onCellClick: (value, type, tdate) {
                    print('onCellClick: $value');
                  },
                  onCellLongPress: (value, type, tdate) {
                    print('onCellLongPress: $value');
                  },
                  onHeaderClick: (index, week) {
                    print('onHeaderClick: $week');
                  },
                  onChange: (value) {
                    print('onChange: $value');
                  },
                ),
              );
            },
          ),
        ],
      );
    },
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
  return TCellGroup(
    cells: [
      TCell(
        title: '自定义文案',
        arrow: true,
        onClick: (cell) {
          TCalendarPopup(
            context,
            visible: true,
            child: TCalendar(
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
                      fontSize: TTheme.of(context).fontTitleMedium?.size,
                      height: TTheme.of(context).fontTitleMedium?.height,
                      fontWeight:
                          TTheme.of(context).fontTitleMedium?.fontWeight,
                      color: TTheme.of(context).errorColor6,
                    );
                    if (day?.typeNotifier.value == DateSelectType.selected) {
                      day?.style = day.style
                          ?.copyWith(color: TTheme.of(context).fontWhColor1);
                    }
                  }
                }
                return null;
              },
            ),
          );
        },
      ),
      TCell(
        title: '自定义按钮',
        arrow: true,
        onClick: (cell) {
          late final TCalendarPopup calendar;
          calendar = TCalendarPopup(
            context,
            visible: true,
            confirmBtn: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: TTheme.of(context).spacer16),
              child: TButton(
                theme: TButtonTheme.danger,
                shape: TButtonShape.round,
                text: 'ok',
                isBlock: true,
                size: TButtonSize.large,
                onTap: () {
                  print(calendar.selected);
                  calendar.close();
                },
              ),
            ),
            child: TCalendar(
              title: '请选择日期',
              value: [DateTime.now().millisecondsSinceEpoch],
              height: size.height * 0.6 + 176,
            ),
          );
        },
      ),
      TCell(
        title: '自定义日期区间',
        arrow: true,
        onClick: (cell) {
          TCalendarPopup(
            context,
            visible: true,
            child: TCalendar(
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
  return TCellGroup(
    cells: [
      TCell(
        title: '自定义文案',
        arrow: true,
        onClick: (cell) {
          TCalendarPopup(
            context,
            visible: true,
            child: TCalendar(
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
                      fontSize: TTheme.of(context).fontTitleMedium?.size,
                      height: TTheme.of(context).fontTitleMedium?.height,
                      fontWeight:
                          TTheme.of(context).fontTitleMedium?.fontWeight,
                      color: TTheme.of(context).errorColor6,
                    );
                    if (day?.typeNotifier.value == DateSelectType.selected) {
                      day?.style = day.style
                          ?.copyWith(color: TTheme.of(context).fontWhColor1);
                    }
                  }
                }
                return null;
              },
            ),
          );
        },
      ),
      TCell(
        title: '自定义按钮',
        arrow: true,
        onClick: (cell) {
          late final TCalendarPopup calendar;
          calendar = TCalendarPopup(
            context,
            visible: true,
            confirmBtn: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: TTheme.of(context).spacer16),
              child: TButton(
                theme: TButtonTheme.danger,
                shape: TButtonShape.round,
                text: 'ok',
                isBlock: true,
                size: TButtonSize.large,
                onTap: () {
                  print(calendar.selected);
                  calendar.close();
                },
              ),
            ),
            child: TCalendar(
              title: '请选择日期',
              value: [DateTime.now().millisecondsSinceEpoch],
              height: size.height * 0.6 + 176,
            ),
          );
        },
      ),
      TCell(
        title: '自定义日期区间',
        arrow: true,
        onClick: (cell) {
          TCalendarPopup(
            context,
            visible: true,
            child: TCalendar(
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
                

自定义日期单元格

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildCustomCell(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final selected = ValueNotifier<List<int>>(
      [DateTime.now().millisecondsSinceEpoch + 30 * 24 * 60 * 60 * 1000]);
  return ValueListenableBuilder(
    valueListenable: selected,
    builder: (context, value, child) {
      final date = DateTime.fromMillisecondsSinceEpoch(value[0]);
      return TCellGroup(
        cells: [
          TCell(
            title: '自定义日期单元格',
            arrow: true,
            note: '${date.year}-${date.month}-${date.day}',
            onClick: (cell) {
              TCalendarPopup(
                context,
                visible: true,
                onConfirm: (value) {
                  print('onConfirm:$value');
                  selected.value = value;
                },
                onClose: () {
                  print('onClose');
                },
                child: TCalendar(
                    title: '请选择日期',
                    value: value,
                    cellHeight: 80,
                    height: size.height * 0.6 + 176,
                    onCellClick: (value, type, tdate) {
                      print('onCellClick: $value');
                    },
                    onCellLongPress: (value, type, tdate) {
                      print('onCellLongPress: $value');
                    },
                    onHeaderClick: (index, week) {
                      print('onHeaderClick: $week');
                    },
                    onChange: (value) {
                      print('onChange: $value');
                    },
                    cellWidget: (context, tdate, selectType) {
                      final today = DateTime.now();
                      //当前日期的自定义实现
                      if (tdate.date.millisecondsSinceEpoch ==
                              DateTime(today.year, today.month, today.day)
                                  .millisecondsSinceEpoch &&
                          selectType != DateSelectType.selected) {
                        return Container(
                          decoration: BoxDecoration(
                            color: TTheme.of(context).brandColor4,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          constraints: const BoxConstraints(
                              minWidth: 0, // 最小宽度为0
                              maxWidth: double.infinity, // 最大宽度无限
                              minHeight: 0, // 最小高度为0
                              maxHeight: double.infinity),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('今天',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ],
                          ),
                        );
                      }
                      if (selectType == DateSelectType.selected) {
                        return Container(
                          decoration: BoxDecoration(
                            color: TTheme.of(context).successColor8,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          constraints: const BoxConstraints(
                              minWidth: 0, // 最小宽度为0
                              maxWidth: double.infinity, // 最大宽度无限
                              minHeight: 0, // 最小高度为0
                              maxHeight: double.infinity),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${tdate.date.day}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              const Text('文案文案',
                                  style: TextStyle(
                                      fontSize: 6, color: Colors.white)),
                              const Text('自定义',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white)),
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
                          const Text('文案文案', style: TextStyle(fontSize: 8)),
                          const Text('自定义', style: TextStyle(fontSize: 8)),
                        ],
                      );
                    }),
              );
            },
          ),
        ],
      );
    },
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildCustomCell(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final selected = ValueNotifier<List<int>>(
      [DateTime.now().millisecondsSinceEpoch + 30 * 24 * 60 * 60 * 1000]);
  return ValueListenableBuilder(
    valueListenable: selected,
    builder: (context, value, child) {
      final date = DateTime.fromMillisecondsSinceEpoch(value[0]);
      return TCellGroup(
        cells: [
          TCell(
            title: '自定义日期单元格',
            arrow: true,
            note: '${date.year}-${date.month}-${date.day}',
            onClick: (cell) {
              TCalendarPopup(
                context,
                visible: true,
                onConfirm: (value) {
                  print('onConfirm:$value');
                  selected.value = value;
                },
                onClose: () {
                  print('onClose');
                },
                child: TCalendar(
                    title: '请选择日期',
                    value: value,
                    cellHeight: 80,
                    height: size.height * 0.6 + 176,
                    onCellClick: (value, type, tdate) {
                      print('onCellClick: $value');
                    },
                    onCellLongPress: (value, type, tdate) {
                      print('onCellLongPress: $value');
                    },
                    onHeaderClick: (index, week) {
                      print('onHeaderClick: $week');
                    },
                    onChange: (value) {
                      print('onChange: $value');
                    },
                    cellWidget: (context, tdate, selectType) {
                      final today = DateTime.now();
                      //当前日期的自定义实现
                      if (tdate.date.millisecondsSinceEpoch ==
                              DateTime(today.year, today.month, today.day)
                                  .millisecondsSinceEpoch &&
                          selectType != DateSelectType.selected) {
                        return Container(
                          decoration: BoxDecoration(
                            color: TTheme.of(context).brandColor4,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          constraints: const BoxConstraints(
                              minWidth: 0, // 最小宽度为0
                              maxWidth: double.infinity, // 最大宽度无限
                              minHeight: 0, // 最小高度为0
                              maxHeight: double.infinity),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('今天',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ],
                          ),
                        );
                      }
                      if (selectType == DateSelectType.selected) {
                        return Container(
                          decoration: BoxDecoration(
                            color: TTheme.of(context).successColor8,
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          constraints: const BoxConstraints(
                              minWidth: 0, // 最小宽度为0
                              maxWidth: double.infinity, // 最大宽度无限
                              minHeight: 0, // 最小高度为0
                              maxHeight: double.infinity),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${tdate.date.day}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              const Text('文案文案',
                                  style: TextStyle(
                                      fontSize: 6, color: Colors.white)),
                              const Text('自定义',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white)),
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
                          const Text('文案文案', style: TextStyle(fontSize: 8)),
                          const Text('自定义', style: TextStyle(fontSize: 8)),
                        ],
                      );
                    }),
              );
            },
          ),
        ],
      );
    },
  );
}</pre>

</td-code-block>
                

不使用Popup

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildBlock(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final selected = ValueNotifier<List<int>>(
    [DateTime.now().millisecondsSinceEpoch + 30 * 24 * 60 * 60 * 1000],
  );
  return Column(
    // spacing: TTheme.of(context).spacer16,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        // spacing: TTheme.of(context).spacer16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TButton(
            text: '加一个月',
            theme: TButtonTheme.primary,
            onTap: () {
              selected.value = [selected.value[0] + 30 * 24 * 60 * 60 * 1000];
            },
          ),
          const SizedBox(width: 16),
          TButton(
            text: '减一个月',
            theme: TButtonTheme.primary,
            onTap: () {
              selected.value = [selected.value[0] - 30 * 24 * 60 * 60 * 1000];
            },
          ),
        ],
      ),
      const SizedBox(height: 16),
      ValueListenableBuilder(
        valueListenable: selected,
        builder: (context, value, child) {
          return TCalendar(
            title: '请选择日期',
            value: value,
            height: size.height * 0.6 + 176,
            animateTo: true,
            // 不使用popup时，useSafeArea无效
            useSafeArea: true,
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
  final selected = ValueNotifier<List<int>>(
    [DateTime.now().millisecondsSinceEpoch + 30 * 24 * 60 * 60 * 1000],
  );
  return Column(
    // spacing: TTheme.of(context).spacer16,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        // spacing: TTheme.of(context).spacer16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TButton(
            text: '加一个月',
            theme: TButtonTheme.primary,
            onTap: () {
              selected.value = [selected.value[0] + 30 * 24 * 60 * 60 * 1000];
            },
          ),
          const SizedBox(width: 16),
          TButton(
            text: '减一个月',
            theme: TButtonTheme.primary,
            onTap: () {
              selected.value = [selected.value[0] - 30 * 24 * 60 * 60 * 1000];
            },
          ),
        ],
      ),
      const SizedBox(height: 16),
      ValueListenableBuilder(
        valueListenable: selected,
        builder: (context, value, child) {
          return TCalendar(
            title: '请选择日期',
            value: value,
            height: size.height * 0.6 + 176,
            animateTo: true,
            // 不使用popup时，useSafeArea无效
            useSafeArea: true,
          );
        },
      ),
    ],
  );
}</pre>

</td-code-block>
                

农历日历

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildLunar(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final dataSource = LunarDataSourceExample();
  
  // 当前月份状态
  final currentMonth = ValueNotifier<DateTime>(
    DateTime(DateTime.now().year, DateTime.now().month, 1),
  );
  
  // 农历开关状态
  final showLunarInfo = ValueNotifier<bool>(true);
  
  // 选中日期
  final selectedDate = ValueNotifier<List<int>>([
    DateTime.now().millisecondsSinceEpoch,
  ]);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 控制栏
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: ValueListenableBuilder(
          valueListenable: currentMonth,
          builder: (context, month, child) {
            // 获取当前月份的农历信息
            final lunarInfo = dataSource.getLunarInfo(month);
            final lunarMonth = lunarInfo != null 
                ? '${lunarInfo.yearText}年 ${lunarInfo.monthText}' 
                : '';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 农历年月显示
                if (lunarMonth.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      lunarMonth,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                // 按钮行
                Row(
                  children: [
                    // 上一月按钮
                    TButton(
                      text: '上一月',
                      size: TButtonSize.small,
                      theme: TButtonTheme.primary,
                      onTap: () {
                        currentMonth.value = DateTime(
                          month.year,
                          month.month - 1,
                          1,
                        );
                        selectedDate.value = [currentMonth.value.millisecondsSinceEpoch];
                      },
                    ),
                    const SizedBox(width: 8),
                    // 年份选择
                    Expanded(
                      child: TButton(
                        text: '${month.year}年',
                        size: TButtonSize.small,
                        theme: TButtonTheme.defaultTheme,
                        onTap: () async {
                          final year = await showModalBottomSheet<int>(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: 300,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Text(
                                        '选择年份',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: 50,
                                        itemBuilder: (context, index) {
                                          final year = DateTime.now().year - 10 + index;
                                          final isSelected = year == month.year;
                                          return ListTile(
                                            title: Text(
                                              '$year年',
                                              style: TextStyle(
                                                color: isSelected ? Colors.blue : null,
                                                fontWeight: isSelected ? FontWeight.bold : null,
                                              ),
                                            ),
                                            onTap: () => Navigator.pop(context, year),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                          if (year != null) {
                            currentMonth.value = DateTime(year, month.month, 1);
                            selectedDate.value = [currentMonth.value.millisecondsSinceEpoch];
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 月份选择
                    Expanded(
                      child: TButton(
                        text: '${month.month}月',
                        size: TButtonSize.small,
                        theme: TButtonTheme.defaultTheme,
                        onTap: () async {
                          final selectedMonth = await showModalBottomSheet<int>(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: 400,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Text(
                                        '选择月份',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GridView.builder(
                                        padding: const EdgeInsets.all(16),
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio: 2,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                        ),
                                        itemCount: 12,
                                        itemBuilder: (context, index) {
                                          final m = index + 1;
                                          final isSelected = m == month.month;
                                          return InkWell(
                                            onTap: () => Navigator.pop(context, m),
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: isSelected ? Colors.blue : Colors.grey.shade200,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                '$m月',
                                                style: TextStyle(
                                                  color: isSelected ? Colors.white : Colors.black,
                                                  fontWeight: isSelected ? FontWeight.bold : null,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                          if (selectedMonth != null) {
                            currentMonth.value = DateTime(month.year, selectedMonth, 1);
                            selectedDate.value = [currentMonth.value.millisecondsSinceEpoch];
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 下一月按钮
                    TButton(
                      text: '下一月',
                      size: TButtonSize.small,
                      theme: TButtonTheme.primary,
                      onTap: () {
                        currentMonth.value = DateTime(
                          month.year,
                          month.month + 1,
                          1,
                        );
                        selectedDate.value = [currentMonth.value.millisecondsSinceEpoch];
                      },
                    ),
                    const SizedBox(width: 16),
                    // 农历开关
                    ValueListenableBuilder(
                      valueListenable: showLunarInfo,
                      builder: (context, show, child) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '农历',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                            ),
                            Switch(
                              value: show,
                              onChanged: (value) {
                                showLunarInfo.value = value;
                              },
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      const SizedBox(height: 16),
      // 日历主体
      ValueListenableBuilder(
        valueListenable: showLunarInfo,
        builder: (context, show, child) {
          return ValueListenableBuilder(
            valueListenable: selectedDate,
            builder: (context, value, child) {
              return TCalendar(
                title: '',
                showLunarInfo: show,
                dataSource: dataSource,
                value: value,
                height: size.height * 0.6,
                onChange: (newValue) {
                  selectedDate.value = newValue;
                  
                  // 显示完整农历信息
                  final date = DateTime.fromMillisecondsSinceEpoch(newValue[0]);
                  final lunarInfo = dataSource.getLunarInfo(date);
                  final solarTerm = dataSource.getSolarTerm(date);
                  final festival = dataSource.getFestival(date, lunarInfo);
                  final holidayInfo = dataSource.getHolidayInfo(date);
                  
                  final buffer = StringBuffer();
                  buffer.write('阳历：${date.year}年${date.month}月${date.day}日');
                  
                  if (lunarInfo != null) {
                    buffer.write('\n农历：${lunarInfo.monthText}${lunarInfo.dayText}');
                  }
                  
                  if (solarTerm != null && solarTerm.isNotEmpty) {
                    buffer.write('\n节气：$solarTerm');
                  }
                  
                  if (festival != null && festival.isNotEmpty) {
                    buffer.write('\n节日：$festival');
                  }
                  
                  if (holidayInfo != null) {
                    final type = holidayInfo['type'] == 'holiday' ? '假期' : '调休';
                    buffer.write('\n$type：${holidayInfo['name']}');
                  }
                  
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(buffer.toString()),
                      duration: const Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    ],
  );
}</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
Widget _buildLunar(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final dataSource = LunarDataSourceExample();
  
  // 当前月份状态
  final currentMonth = ValueNotifier<DateTime>(
    DateTime(DateTime.now().year, DateTime.now().month, 1),
  );
  
  // 农历开关状态
  final showLunarInfo = ValueNotifier<bool>(true);
  
  // 选中日期
  final selectedDate = ValueNotifier<List<int>>([
    DateTime.now().millisecondsSinceEpoch,
  ]);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 控制栏
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: ValueListenableBuilder(
          valueListenable: currentMonth,
          builder: (context, month, child) {
            // 获取当前月份的农历信息
            final lunarInfo = dataSource.getLunarInfo(month);
            final lunarMonth = lunarInfo != null 
                ? '${lunarInfo.yearText}年 ${lunarInfo.monthText}' 
                : '';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 农历年月显示
                if (lunarMonth.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      lunarMonth,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                // 按钮行
                Row(
                  children: [
                    // 上一月按钮
                    TButton(
                      text: '上一月',
                      size: TButtonSize.small,
                      theme: TButtonTheme.primary,
                      onTap: () {
                        currentMonth.value = DateTime(
                          month.year,
                          month.month - 1,
                          1,
                        );
                        selectedDate.value = [currentMonth.value.millisecondsSinceEpoch];
                      },
                    ),
                    const SizedBox(width: 8),
                    // 年份选择
                    Expanded(
                      child: TButton(
                        text: '${month.year}年',
                        size: TButtonSize.small,
                        theme: TButtonTheme.defaultTheme,
                        onTap: () async {
                          final year = await showModalBottomSheet<int>(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: 300,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Text(
                                        '选择年份',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: 50,
                                        itemBuilder: (context, index) {
                                          final year = DateTime.now().year - 10 + index;
                                          final isSelected = year == month.year;
                                          return ListTile(
                                            title: Text(
                                              '$year年',
                                              style: TextStyle(
                                                color: isSelected ? Colors.blue : null,
                                                fontWeight: isSelected ? FontWeight.bold : null,
                                              ),
                                            ),
                                            onTap: () => Navigator.pop(context, year),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                          if (year != null) {
                            currentMonth.value = DateTime(year, month.month, 1);
                            selectedDate.value = [currentMonth.value.millisecondsSinceEpoch];
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 月份选择
                    Expanded(
                      child: TButton(
                        text: '${month.month}月',
                        size: TButtonSize.small,
                        theme: TButtonTheme.defaultTheme,
                        onTap: () async {
                          final selectedMonth = await showModalBottomSheet<int>(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: 400,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Text(
                                        '选择月份',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GridView.builder(
                                        padding: const EdgeInsets.all(16),
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio: 2,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                        ),
                                        itemCount: 12,
                                        itemBuilder: (context, index) {
                                          final m = index + 1;
                                          final isSelected = m == month.month;
                                          return InkWell(
                                            onTap: () => Navigator.pop(context, m),
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: isSelected ? Colors.blue : Colors.grey.shade200,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                '$m月',
                                                style: TextStyle(
                                                  color: isSelected ? Colors.white : Colors.black,
                                                  fontWeight: isSelected ? FontWeight.bold : null,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                          if (selectedMonth != null) {
                            currentMonth.value = DateTime(month.year, selectedMonth, 1);
                            selectedDate.value = [currentMonth.value.millisecondsSinceEpoch];
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 下一月按钮
                    TButton(
                      text: '下一月',
                      size: TButtonSize.small,
                      theme: TButtonTheme.primary,
                      onTap: () {
                        currentMonth.value = DateTime(
                          month.year,
                          month.month + 1,
                          1,
                        );
                        selectedDate.value = [currentMonth.value.millisecondsSinceEpoch];
                      },
                    ),
                    const SizedBox(width: 16),
                    // 农历开关
                    ValueListenableBuilder(
                      valueListenable: showLunarInfo,
                      builder: (context, show, child) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '农历',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                            ),
                            Switch(
                              value: show,
                              onChanged: (value) {
                                showLunarInfo.value = value;
                              },
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      const SizedBox(height: 16),
      // 日历主体
      ValueListenableBuilder(
        valueListenable: showLunarInfo,
        builder: (context, show, child) {
          return ValueListenableBuilder(
            valueListenable: selectedDate,
            builder: (context, value, child) {
              return TCalendar(
                title: '',
                showLunarInfo: show,
                dataSource: dataSource,
                value: value,
                height: size.height * 0.6,
                onChange: (newValue) {
                  selectedDate.value = newValue;
                  
                  // 显示完整农历信息
                  final date = DateTime.fromMillisecondsSinceEpoch(newValue[0]);
                  final lunarInfo = dataSource.getLunarInfo(date);
                  final solarTerm = dataSource.getSolarTerm(date);
                  final festival = dataSource.getFestival(date, lunarInfo);
                  final holidayInfo = dataSource.getHolidayInfo(date);
                  
                  final buffer = StringBuffer();
                  buffer.write('阳历：${date.year}年${date.month}月${date.day}日');
                  
                  if (lunarInfo != null) {
                    buffer.write('\n农历：${lunarInfo.monthText}${lunarInfo.dayText}');
                  }
                  
                  if (solarTerm != null && solarTerm.isNotEmpty) {
                    buffer.write('\n节气：$solarTerm');
                  }
                  
                  if (festival != null && festival.isNotEmpty) {
                    buffer.write('\n节日：$festival');
                  }
                  
                  if (holidayInfo != null) {
                    final type = holidayInfo['type'] == 'holiday' ? '假期' : '调休';
                    buffer.write('\n$type：${holidayInfo['name']}');
                  }
                  
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(buffer.toString()),
                      duration: const Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    ],
  );
}</pre>

</td-code-block>
                


## API
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
| titleMaxLine | int? | - | header区域 [TCalendar.title]的行数 |
| titleStyle | TextStyle? | - | header区域 [TCalendar.title]的样式 |
| weekdayStyle | TextStyle? | - | header区域 周 文字样式 |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TCalendarStyle.cellStyle  | 日期样式 |
| TCalendarStyle.generateStyle  | 生成默认样式 |

```
```

### TCalendar
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| anchorDate | DateTime? | - | 锚点日期 |
| animateTo | bool? | false | 动画滚动到指定位置 |
| cellHeight | double? | 60 | 日期高度 |
| cellWidget | Widget? Function(BuildContext context, TDate tdate, DateSelectType selectType)? | - | 自定义日期单元格组件 |
| dataSource | TCalendarDataSource? | - | 外部数据源，用于提供农历转换等功能 |
| dateType | TCalendarDateType | TCalendarDateType.solar | 日历类型：阳历或农历 |
| displayFormat | String? | 'year month' | 年月显示格式，`year`表示年，`month`表示月，如`year month`表示年在前、月在后、中间隔一个空格 |
| firstDayOfWeek | int? | 0 | 第一天从星期几开始，默认 0 = 周日 |
| format | CalendarFormat? | - | 用于格式化日期的函数，可定义日期前后的显示内容和日期样式 |
| height | double? | - | 高度 |
| isTimeUnit | bool? | true | 是否显示时间单位 |
| key |  | - |  |
| maxDate | int? | - | 最大可选的日期（fromMillisecondsSinceEpoch），不传则默认半年后 |
| minDate | int? | - | 最小可选的日期（fromMillisecondsSinceEpoch），不传则默认今天 |
| monthTitleBuilder | Widget Function(BuildContext context, DateTime monthDate)? | - | 月标题构建器 |
| monthTitleHeight | double? | 22 | 月标题高度 |
| onCellClick | void Function(int value, DateSelectType type, TDate tdate)? | - | 点击日期时触发 |
| onCellLongPress | void Function(int value, DateSelectType type, TDate tdate)? | - | 长安日期时触发 |
| onChange | void Function(List<int> value)? | - | 选中值变化时触发 |
| onHeaderClick | void Function(int index, String week)? | - | 点击周时触发 |
| onMonthChange | ValueChanged<DateTime>? | - | 月份变化时触发 |
| pickerHeight | double? | 178 | 时间选择器List的视窗高度 |
| pickerItemCount | int? | 3 | 选择器List视窗中item个数，pickerHeight / pickerItemCount即item高度 |
| showLunarInfo | bool | false | 阳历模式下是否显示农历信息作为副标题 |
| style | TCalendarStyle? | - | 自定义样式 |
| timePickerModel | List<DatePickerModel>? | - | 自定义时间选择器 |
| title | String? | - | 标题 |
| titleWidget | Widget? | - | 标题组件 |
| type | CalendarType? | CalendarType.single | 日历的选择类型，single = 单选；multiple = 多选；range = 区间选择 |
| useSafeArea | bool? | true | 是否使用安全区域，默认true |
| useTimePicker | bool? | false | 是否显示时间选择器 |
| value | List<int>? | - | 当前选择的日期（fromMillisecondsSinceEpoch），不传则默认今天，当 type = single 时数组长度为1 |
| width | double? | - | 宽度 |

```
```

### TCalendarDataSource
```
```

### TCalendarPopup
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| autoClose | bool? | true | 自动关闭；在点击关闭按钮、确认按钮、遮罩层时自动关闭 |
| builder | CalendarBuilder? | - | 控件构建器，优先级高于[child] |
| child | TCalendar? | - | 日历控件 |
| confirmBtn | Widget? | - | 自定义确认按钮 |
| context | BuildContext | context | 上下文 |
| onClose | VoidCallback? | - | 关闭时触发 |
| onConfirm | void Function(List<int> value)? | - | 点击确认按钮时触发 |
| top | double? | - | 距离顶部的距离 |
| visible | bool? | - | 默认是否显示日历 |

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


  
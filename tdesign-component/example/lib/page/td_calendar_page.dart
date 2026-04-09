import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../base/example_widget.dart';
import '../annotation/demo.dart';
import '../lunar_data_source_example.dart';

class TCalendarPage extends StatelessWidget {
  const TCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tdTitle(context),
      desc: '按照日历形式展示数据或日期的容器。',
      exampleCodeGroup: 'calendar',
      children: [
        ExampleModule(title: '组件类型', children: [
          ExampleItem(
            ignoreCode: true,
            center: false,
            builder: (BuildContext context) {
              return const CodeWrapper(builder: _buildSimple);
            },
          ),
        ]),
        ExampleModule(title: '组件样式', children: [
          ExampleItem(
            desc: '可以自由定义想要的风格',
            ignoreCode: true,
            center: false,
            builder: (BuildContext context) {
              return const CodeWrapper(builder: _buildStyle);
            },
          ),
          ExampleItem(
            desc: '自定义日期单元格',
            ignoreCode: true,
            center: false,
            builder: (BuildContext context) {
              return const CodeWrapper(builder: _buildCustomCell);
            },
          ),
          ExampleItem(
            desc: '不使用Popup',
            ignoreCode: true,
            center: false,
            builder: (BuildContext context) {
              return const CodeWrapper(builder: _buildBlock);
            },
          ),
          ExampleItem(
            desc: '农历日历',
            ignoreCode: true,
            center: false,
            builder: (BuildContext context) {
              return const CodeWrapper(builder: _buildLunar);
            },
          ),
        ]),
      ],
      test: const [],
    );
  }
}

@Demo(group: 'calendar')
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
}

@Demo(group: 'calendar')
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
}

@Demo(group: 'calendar')
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
}

@Demo(group: 'calendar')
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
}

@Demo(group: 'calendar')
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
}

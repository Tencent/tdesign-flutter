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
      title: tTitle(context),
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
  // 刷新触发器：所有示例 onConfirm 后 +1，驱动 builder 重建以更新 note
  final refreshTrigger = ValueNotifier(0);

  // 时间选择器 items（时 0-23、分 0-59），一次性构造避免重复创建
  final timeItems = TPickerColumns([
    [for (int i = 0; i < 24; i++) TPickerOption(label: '${i.toString().padLeft(2, '0')}时', value: i)],
    [for (int i = 0; i < 60; i++) TPickerOption(label: '${i.toString().padLeft(2, '0')}分', value: i)],
  ]);
  final now = DateTime.now();
  // 单个选择日历和时间 - 时分
  final pickedTime = ValueNotifier<List<int>>([now.hour, now.minute]);
  // 区间选择日历和时间 - [[开始时, 开始分], [结束时, 结束分]]
  final pickedRangeTime = ValueNotifier<List<List<int>>>([
    [now.hour, now.minute],
    [now.hour, now.minute],
  ]);
  final rangeTimeTab = ValueNotifier<int>(0);

  // 单个选择日历 - 已选日期（默认无选中）
  var singleSelected = <int>[];
  // 单个选择日历 - 天气面板是否展开（默认收起，点击日期/已有选中时展开）
  final singleWeatherExpanded = ValueNotifier<bool>(false);
  // 多个选择日历 - 已选日期（闭包捕获，在 builder 内通过 refreshTrigger 触发更新）
  var multipleDates = <int>[];
  // 区间选择日历 - 已选区间
  var rangeDates = [
    DateTime.now().millisecondsSinceEpoch,
    DateTime.now().add(const Duration(days: 6)).millisecondsSinceEpoch,
  ];
  // 区间选择日历和时间 - 已选区间（带时分）
  var rangeTimeDates = <int>[];

  return ValueListenableBuilder<int>(
    valueListenable: refreshTrigger,
    builder: (context, _, child) {
      final date = DateTime.fromMillisecondsSinceEpoch(selected.value[0]);
      // 多个选择 note
      final multipleNote = multipleDates.isEmpty
          ? '--'
          : '已选 ${multipleDates.length} 天';
      // 区间选择 note
      String fmtRange(int ms) {
        final d = DateTime.fromMillisecondsSinceEpoch(ms);
        return '${d.month}/${d.day}';
      }
      // 区间选择日历和时间 note
      String fmtRangeTime(int ms) {
        final d = DateTime.fromMillisecondsSinceEpoch(ms);
        return '${d.month}/${d.day} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
      }
      final rangeTimeNote = rangeTimeDates.length >= 2
          ? '${fmtRangeTime(rangeTimeDates.first)} ~ ${fmtRangeTime(rangeTimeDates.last)}'
          : '--';

      return TCellGroup(
        cells: [
          TCell(
            title: '单个选择日历',
            arrow: true,
            note: singleSelected.isEmpty
                ? '--'
                : () {
                    final d = DateTime.fromMillisecondsSinceEpoch(singleSelected.first);
                    return '${d.year}-${d.month}-${d.day}';
                  }(),
            onClick: (cell) {
              // 打开时：若已有选中值则默认展开天气，否则收起
              singleWeatherExpanded.value = singleSelected.isNotEmpty;
              TCalendarPopup(
                context,
                visible: true,
                onConfirm: (value) {
                  singleSelected = value;
                  refreshTrigger.value++;
                },
                onClose: () {},
                child: TCalendar(
                  title: '请选择日期',
                  value: singleSelected,
                  height: size.height * 0.6 + 176,
                  bottomExpandedListenable: singleWeatherExpanded,
                  onCellClick: (value, type, tdate) {
                    // 点击日期时展开天气面板
                    singleWeatherExpanded.value = true;
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
                  bottom: (context, selectedDates) {
                    // 随机天气数据
                    final weathers = ['☀️ 晴', '⛅ 多云', '🌧️ 小雨', '⛈️ 雷阵雨', '❄️ 小雪', '🌫️ 雾'];
                    final windDirs = ['北风', '南风', '东风', '西风', '微风'];
                    final w = weathers[DateTime.now().millisecond % weathers.length];
                    final temp = -5 + (DateTime.now().millisecond % 30);
                    final hum = 30 + (DateTime.now().millisecond % 50);
                    final wind = windDirs[DateTime.now().millisecond % windDirs.length];
                    final windLv = 1 + (DateTime.now().millisecond % 5);
                    final d = selectedDates.isEmpty
                        ? DateTime.now()
                        : DateTime.fromMillisecondsSinceEpoch(selectedDates.first);
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.04),
                            blurRadius: 12,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${d.year}-${d.month}-${d.day}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 4),
                              Text(w, style: const TextStyle(fontSize: 22)),
                            ],
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [const Icon(Icons.thermostat, size: 14), const SizedBox(width: 4), Text('$temp°C')]),
                                const SizedBox(height: 4),
                                Row(children: [const Icon(Icons.water_drop, size: 14), const SizedBox(width: 4), Text('$hum%')]),
                                const SizedBox(height: 4),
                                Row(children: [const Icon(Icons.air, size: 14), const SizedBox(width: 4), Text('$wind $windLv 级')]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
          TCell(
            title: '多个选择日历',
            arrow: true,
            note: multipleNote,
            onClick: (cell) {
              TCalendarPopup(
                context,
                visible: true,
                onConfirm: (value) {
                  multipleDates = value;
                  refreshTrigger.value++;
                },
                child: TCalendar(
                  title: '请选择日期',
                  type: CalendarType.multiple,
                  value: multipleDates.isEmpty
                      ? [DateTime.now().millisecondsSinceEpoch]
                      : multipleDates,
                  height: size.height * 0.6 + 176,
                  bottom: (context, selectedDates) {
                    final dates = selectedDates
                        .map(DateTime.fromMillisecondsSinceEpoch)
                        .toList()
                      ..sort();
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.04),
                            blurRadius: 12,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '已选择 ${dates.length} 天',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: dates
                                .map((d) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: TTheme.of(context).brandColor1,
                                        borderRadius:
                                            BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: TTheme.of(context)
                                                .brandColor7),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
          TCell(
            title: '区间选择日历',
            arrow: true,
            note: rangeDates.length >= 2
                ? '${fmtRange(rangeDates.first)} ~ ${fmtRange(rangeDates[1])}'
                : '--',
            onClick: (cell) {
              TCalendarPopup(
                context,
                visible: true,
                onConfirm: (value) {
                  rangeDates = value;
                  refreshTrigger.value++;
                },
                child: TCalendar(
                  title: '请选择日期区间',
                  type: CalendarType.range,
                  value: rangeDates,
                  height: size.height * 0.6 + 176,
                  bottom: (context, selectedDates) {
                    String formatDate(int ms) {
                      final d = DateTime.fromMillisecondsSinceEpoch(ms);
                      return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
                    }

                    final hasStart = selectedDates.isNotEmpty;
                    final hasEnd = selectedDates.length >= 2;
                    final days = hasEnd
                        ? ((selectedDates[1] - selectedDates[0]) /
                                    (24 * 60 * 60 * 1000))
                                .round() +
                            1
                        : (hasStart ? 1 : 0);

                    Widget buildSegment(String label, String? value) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                                fontSize: 12,
                                color: TTheme.of(context).fontGyColor3),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            value ?? '--',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: value != null
                                  ? TTheme.of(context).fontGyColor1
                                  : TTheme.of(context).fontGyColor3,
                            ),
                          ),
                        ],
                      );
                    }

                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.04),
                            blurRadius: 12,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: buildSegment('开始',
                                hasStart ? formatDate(selectedDates[0]) : null),
                          ),
                          Icon(Icons.arrow_forward,
                              size: 16,
                              color: TTheme.of(context).fontGyColor3),
                          const SizedBox(width: 12),
                          Expanded(
                            child: buildSegment('结束',
                                hasEnd ? formatDate(selectedDates[1]) : null),
                          ),
                          if (days > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: TTheme.of(context).brandColor1,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '共 $days 天',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: TTheme.of(context).brandColor7),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
          TCell(
            title: '单个选择日历和时间',
            arrow: true,
            note:
                '${date.year}-${date.month}-${date.day} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
            onClick: (cell) {
              TCalendarPopup(
                context,
                visible: true,
                onConfirm: (dates) {
                  // 将 Picker 选中的时分合并到日期时间戳
                  final merged = dates.map((ms) {
                    final d = DateTime.fromMillisecondsSinceEpoch(ms);
                    return DateTime(
                      d.year,
                      d.month,
                      d.day,
                      pickedTime.value[0],
                      pickedTime.value[1],
                    ).millisecondsSinceEpoch;
                  }).toList();
                  print('onConfirm:$merged');
                  selected.value = merged;
                  refreshTrigger.value++;
                },
                onClose: () {
                  print('onClose');
                },
                child: TCalendar(
                  title: '请选择日期和时间',
                  value: selected.value,
                  height: size.height * 0.92,
                  bottom: (context, selectedDates) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.04),
                            blurRadius: 12,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: TPicker(
                        items: timeItems,
                        initialValue: pickedTime.value,
                        height: 180,
                        itemCount: 5,
                        title: '选择时间',
                        onChange: (v) =>
                            pickedTime.value = List<int>.from(v.values),
                      ),
                    );
                  },
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
            note: rangeTimeNote,
            onClick: (cell) {
              TCalendarPopup(
                context,
                visible: true,
                onConfirm: (value) {
                  // 把开始/结束时分合并到对应日期
                  final rt = pickedRangeTime.value;
                  final merged = [
                    for (var i = 0; i < value.length; i++)
                      DateTime.fromMillisecondsSinceEpoch(value[i])
                          .copyWith(hour: rt[i][0], minute: rt[i][1])
                          .millisecondsSinceEpoch,
                  ];
                  print('onConfirm: $merged');
                  rangeTimeDates = merged;
                  refreshTrigger.value++;
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
                  bottom: (context, selectedDates) {
                    return DefaultTabController(
                      length: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.04),
                              blurRadius: 12,
                              offset: Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TTabBar(
                              height: 40,
                              showIndicator: true,
                              tabs: const [
                                TTab(text: '开始时间'),
                                TTab(text: '结束时间'),
                              ],
                              onTap: (i) => rangeTimeTab.value = i,
                            ),
                            ValueListenableBuilder<int>(
                              valueListenable: rangeTimeTab,
                              builder: (context, tab, _) => TPicker(
                                // 切换 tab 时重建，复位到对应时分
                                key: ValueKey(tab),
                                items: timeItems,
                                initialValue: pickedRangeTime.value[tab],
                                height: 180,
                                itemCount: 5,
                                onChange: (v) {
                                  final next = [...pickedRangeTime.value];
                                  next[tab] = List<int>.from(v.values);
                                  pickedRangeTime.value = next;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
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
                onConfirm: (dates) {
                  print('onConfirm：$dates');
                  selected.value = dates;
                  refreshTrigger.value++;
                },
                onClose: () {
                  print('onClose');
                },
                child: TCalendar(
                  title: '请选择日期',
                  minDate: DateTime(2022, 1, 1).millisecondsSinceEpoch,
                  maxDate: DateTime(2028, 2, 15).millisecondsSinceEpoch,
                  anchorDate: DateTime(2026, 5),
                  value: selected.value,
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

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
  return const _SimpleDemo();
}

/// 「组件类型」演示容器
class _SimpleDemo extends StatelessWidget {
  const _SimpleDemo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _SingleCalendarCell(),
        _MultipleCalendarCell(),
        _RangeCalendarCell(),
        _SingleTimeCalendarCell(),
        _RangeTimeCalendarCell(),
        _AnchorCalendarCell(),
      ],
    );
  }
}

// ========================= 1. 单选 + 天气 =========================
class _SingleCalendarCell extends StatefulWidget {
  const _SingleCalendarCell();
  @override
  State<_SingleCalendarCell> createState() => _SingleCalendarCellState();
}

class _SingleCalendarCellState extends State<_SingleCalendarCell> {
  List<int> _selected = const [];
  final ValueNotifier<bool> _expanded = ValueNotifier<bool>(false);
  final Map<int, _WeatherData> _cache = {};

  @override
  void dispose() {
    _expanded.dispose();
    super.dispose();
  }

  _WeatherData _weatherFor(DateTime date) {
    final key = date.year * 10000 + date.month * 100 + date.day;
    return _cache.putIfAbsent(key, () => _WeatherData.random(key));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return TCell(
      title: '单个选择日历',
      arrow: true,
      note: _formatYmd(_selected),
      onClick: (_) {
        _expanded.value = _selected.isNotEmpty;
        TCalendarPopup(
          context,
          visible: true,
          onConfirm: (value) => setState(() => _selected = value),
          onClose: () => _expanded.value = false,
          child: TCalendar(
            title: '请选择日期',
            value: _selected,
            height: size.height * 0.6 + 176,
            bottomExpanded: _expanded,
            onCellClick: (value, type, tdate) => _expanded.value = true,
            bottom: (ctx, dates) {
              final d = dates.isEmpty
                  ? DateTime.now()
                  : DateTime.fromMillisecondsSinceEpoch(dates.first);
              return _WeatherPanel(date: d, weather: _weatherFor(d));
            },
          ),
        );
      },
    );
  }
}

// ========================= 2. 多选 =========================
class _MultipleCalendarCell extends StatefulWidget {
  const _MultipleCalendarCell();
  @override
  State<_MultipleCalendarCell> createState() => _MultipleCalendarCellState();
}

class _MultipleCalendarCellState extends State<_MultipleCalendarCell> {
  List<int> _dates = const [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return TCell(
      title: '多个选择日历',
      arrow: true,
      note: _dates.isEmpty ? '--' : '已选 ${_dates.length} 天',
      onClick: (_) {
        TCalendarPopup(
          context,
          visible: true,
          onConfirm: (value) => setState(() => _dates = value),
          child: TCalendar(
            title: '请选择日期',
            type: CalendarType.multiple,
            value: _dates.isEmpty
                ? [DateTime.now().millisecondsSinceEpoch]
                : _dates,
            height: size.height * 0.6 + 176,
            bottom: (ctx, dates) => _MultipleSummary(selected: dates),
          ),
        );
      },
    );
  }
}

// ========================= 3. 区间 =========================
class _RangeCalendarCell extends StatefulWidget {
  const _RangeCalendarCell();
  @override
  State<_RangeCalendarCell> createState() => _RangeCalendarCellState();
}

class _RangeCalendarCellState extends State<_RangeCalendarCell> {
  late List<int> _dates = [
    DateTime.now().millisecondsSinceEpoch,
    DateTime.now().add(const Duration(days: 6)).millisecondsSinceEpoch,
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return TCell(
      title: '区间选择日历',
      arrow: true,
      note: _dates.length >= 2
          ? '${_formatMd(_dates.first)} ~ ${_formatMd(_dates[1])}'
          : '--',
      onClick: (_) {
        TCalendarPopup(
          context,
          visible: true,
          onConfirm: (value) => setState(() => _dates = value),
          child: TCalendar(
            title: '请选择日期区间',
            type: CalendarType.range,
            value: _dates,
            height: size.height * 0.6 + 176,
            bottom: (ctx, dates) => _RangeSummary(selected: dates),
          ),
        );
      },
    );
  }
}

// ========================= 4. 单选 + 时间 =========================
class _SingleTimeCalendarCell extends StatefulWidget {
  const _SingleTimeCalendarCell();
  @override
  State<_SingleTimeCalendarCell> createState() =>
      _SingleTimeCalendarCellState();
}

class _SingleTimeCalendarCellState extends State<_SingleTimeCalendarCell> {
  late List<int> _selected = [
    DateTime.now().millisecondsSinceEpoch + 30 * 24 * 60 * 60 * 1000,
  ];
  late final ValueNotifier<List<int>> _pickedTime;
  late final TPickerColumns _timeItems = _buildTimeItems();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _pickedTime = ValueNotifier<List<int>>([now.hour, now.minute]);
  }

  @override
  void dispose() {
    _pickedTime.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final d = DateTime.fromMillisecondsSinceEpoch(_selected.first);
    return TCell(
      title: '单个选择日历和时间',
      arrow: true,
      note: '${d.year}-${d.month}-${d.day} '
          '${d.hour.toString().padLeft(2, '0')}:'
          '${d.minute.toString().padLeft(2, '0')}',
      onClick: (_) {
        TCalendarPopup(
          context,
          visible: true,
          onConfirm: (dates) {
            final merged = dates.map((ms) {
              return DateTime.fromMillisecondsSinceEpoch(ms)
                  .copyWith(
                    hour: _pickedTime.value[0],
                    minute: _pickedTime.value[1],
                  )
                  .millisecondsSinceEpoch;
            }).toList();
            setState(() => _selected = merged);
          },
          child: TCalendar(
            title: '请选择日期和时间',
            value: _selected,
            height: size.height * 0.92,
            bottom: (ctx, _) => _TimePickerPanel(
              items: _timeItems,
              initialValue: _pickedTime.value,
              title: '选择时间',
              onChange: (v) => _pickedTime.value = v,
            ),
          ),
        );
      },
    );
  }
}

// ========================= 5. 区间 + 时间 =========================
class _RangeTimeCalendarCell extends StatefulWidget {
  const _RangeTimeCalendarCell();
  @override
  State<_RangeTimeCalendarCell> createState() => _RangeTimeCalendarCellState();
}

class _RangeTimeCalendarCellState extends State<_RangeTimeCalendarCell> {
  List<int> _dates = const [];
  late List<List<int>> _pickedRangeTime;
  int _currentTab = 0;
  late final TPickerColumns _timeItems = _buildTimeItems();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _pickedRangeTime = [
      [now.hour, now.minute],
      [now.hour, now.minute],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return TCell(
      title: '区间选择日历和时间',
      arrow: true,
      note: _dates.length >= 2
          ? '${_formatMdHm(_dates.first)} ~ ${_formatMdHm(_dates.last)}'
          : '--',
      onClick: (_) {
        TCalendarPopup(
          context,
          visible: true,
          onConfirm: (value) {
            final merged = [
              for (var i = 0; i < value.length; i++)
                DateTime.fromMillisecondsSinceEpoch(value[i])
                    .copyWith(
                      hour: _pickedRangeTime[i][0],
                      minute: _pickedRangeTime[i][1],
                    )
                    .millisecondsSinceEpoch,
            ];
            setState(() => _dates = merged);
          },
          child: TCalendar(
            title: '请选择日期和时间区间',
            height: size.height * 0.92,
            type: CalendarType.range,
            value: _dates.isEmpty
                ? [
                    DateTime.now().millisecondsSinceEpoch,
                    DateTime.now()
                        .add(const Duration(days: 3))
                        .millisecondsSinceEpoch,
                  ]
                : _dates,
            bottom: (ctx, _) => _RangeTimePickerPanel(
              items: _timeItems,
              currentTab: _currentTab,
              initialValues: _pickedRangeTime,
              onTabChanged: (tab) => _currentTab = tab,
              onPickerChanged: (tab, value) {
                _pickedRangeTime[tab] = value;
              },
            ),
          ),
        );
      },
    );
  }
}

// ========================= 6. 锚点 =========================
class _AnchorCalendarCell extends StatefulWidget {
  const _AnchorCalendarCell();
  @override
  State<_AnchorCalendarCell> createState() => _AnchorCalendarCellState();
}

class _AnchorCalendarCellState extends State<_AnchorCalendarCell> {
  late List<int> _selected = [
    DateTime.now().millisecondsSinceEpoch + 30 * 24 * 60 * 60 * 1000,
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return TCell(
      title: '添加锚点',
      arrow: true,
      note: _formatYmd(_selected),
      onClick: (_) {
        TCalendarPopup(
          context,
          visible: true,
          onConfirm: (dates) => setState(() => _selected = dates),
          child: TCalendar(
            title: '请选择日期',
            minDate: DateTime(2022, 1, 1).millisecondsSinceEpoch,
            maxDate: DateTime(2028, 2, 15).millisecondsSinceEpoch,
            anchorDate: DateTime(2026, 5),
            value: _selected,
            height: size.height * 0.6 + 176,
          ),
        );
      },
    );
  }
}

// ===== 共用：构建时间选择器 items =====
TPickerColumns _buildTimeItems() => TPickerColumns([
      [
        for (int i = 0; i < 24; i++)
          TPickerOption(label: '${i.toString().padLeft(2, '0')}时', value: i),
      ],
      [
        for (int i = 0; i < 60; i++)
          TPickerOption(label: '${i.toString().padLeft(2, '0')}分', value: i),
      ],
    ]);

// ===== 顶层格式化辅助函数 =====
String _formatYmd(List<int> dates) {
  if (dates.isEmpty) {
    return '--';
  }
  final d = DateTime.fromMillisecondsSinceEpoch(dates.first);
  return '${d.year}-${d.month}-${d.day}';
}

String _formatMd(int ms) {
  final d = DateTime.fromMillisecondsSinceEpoch(ms);
  return '${d.month}/${d.day}';
}

String _formatMdHm(int ms) {
  final d = DateTime.fromMillisecondsSinceEpoch(ms);
  return '${d.month}/${d.day} '
      '${d.hour.toString().padLeft(2, '0')}:'
      '${d.minute.toString().padLeft(2, '0')}';
}

String _formatYmdFull(int ms) {
  final d = DateTime.fromMillisecondsSinceEpoch(ms);
  return '${d.year}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}

// ===== 共用 bottom 面板装饰 =====
BoxDecoration _bottomCardDecoration(BuildContext context) => BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.04),
          blurRadius: 12,
          offset: Offset(0, -2),
        ),
      ],
    );

// ===== 天气数据模型 =====
class _WeatherData {
  const _WeatherData({
    required this.icon,
    required this.temp,
    required this.humidity,
    required this.wind,
    required this.windLevel,
  });

  final String icon;
  final int temp;
  final int humidity;
  final String wind;
  final int windLevel;

  factory _WeatherData.random(int seed) {
    const weathers = ['☀️ 晴', '⛅ 多云', '🌧️ 小雨', '⛈️ 雷阵雨', '❄️ 小雪', '🌫️ 雾'];
    const winds = ['北风', '南风', '东风', '西风', '微风'];
    return _WeatherData(
      icon: weathers[seed % weathers.length],
      temp: -5 + (seed % 30),
      humidity: 30 + (seed % 50),
      wind: winds[seed % winds.length],
      windLevel: 1 + (seed % 5),
    );
  }
}

// ===== 拆分出的私有 widget =====

class _WeatherPanel extends StatelessWidget {
  const _WeatherPanel({required this.date, required this.weather});

  final DateTime date;
  final _WeatherData weather;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: _bottomCardDecoration(context),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${date.year}-${date.month}-${date.day}',
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(weather.icon, style: const TextStyle(fontSize: 22)),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _IconRow(icon: Icons.thermostat, text: '${weather.temp}°C'),
                const SizedBox(height: 4),
                _IconRow(icon: Icons.water_drop, text: '${weather.humidity}%'),
                const SizedBox(height: 4),
                _IconRow(
                    icon: Icons.air,
                    text: '${weather.wind} ${weather.windLevel} 级'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconRow extends StatelessWidget {
  const _IconRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14),
        const SizedBox(width: 4),
        Text(text),
      ],
    );
  }
}

class _MultipleSummary extends StatelessWidget {
  const _MultipleSummary({required this.selected});

  final List<int> selected;

  @override
  Widget build(BuildContext context) {
    final dates = [...selected]..sort();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: _bottomCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('已选择 ${dates.length} 天',
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: dates
                .map((ms) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: TTheme.of(context).brandColor1,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _formatYmdFull(ms),
                        style: TextStyle(
                            fontSize: 12,
                            color: TTheme.of(context).brandColor7),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _RangeSummary extends StatelessWidget {
  const _RangeSummary({required this.selected});

  final List<int> selected;

  @override
  Widget build(BuildContext context) {
    final hasStart = selected.isNotEmpty;
    final hasEnd = selected.length >= 2;
    final days = hasEnd
        ? ((selected[1] - selected[0]) / (24 * 60 * 60 * 1000)).round() + 1
        : (hasStart ? 1 : 0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: _bottomCardDecoration(context),
      child: Row(
        children: [
          Expanded(
            child: _RangeSegment(
                label: '开始',
                value: hasStart ? _formatYmdFull(selected[0]) : null),
          ),
          Icon(Icons.arrow_forward,
              size: 16, color: TTheme.of(context).fontGyColor3),
          const SizedBox(width: 12),
          Expanded(
            child: _RangeSegment(
                label: '结束',
                value: hasEnd ? _formatYmdFull(selected[1]) : null),
          ),
          if (days > 0)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: TTheme.of(context).brandColor1,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '共 $days 天',
                style: TextStyle(
                    fontSize: 12, color: TTheme.of(context).brandColor7),
              ),
            ),
        ],
      ),
    );
  }
}

class _RangeSegment extends StatelessWidget {
  const _RangeSegment({required this.label, required this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 12, color: TTheme.of(context).fontGyColor3)),
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
}

class _TimePickerPanel extends StatelessWidget {
  const _TimePickerPanel({
    required this.items,
    required this.initialValue,
    required this.title,
    required this.onChange,
  });

  final TPickerColumns items;
  final List<int> initialValue;
  final String title;
  final ValueChanged<List<int>> onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _bottomCardDecoration(context),
      child: TPicker(
        items: items,
        initialValue: initialValue,
        height: 180,
        itemCount: 5,
        title: title,
        onChange: (v) => onChange(List<int>.from(v.values)),
      ),
    );
  }
}

/// 区间+时间 demo 的双时间选择器面板（Tab 切换开始/结束）
/// 使用回调模式：子组件不持有 ValueNotifier，数据由父管理。
class _RangeTimePickerPanel extends StatefulWidget {
  const _RangeTimePickerPanel({
    required this.items,
    required this.currentTab,
    required this.initialValues,
    required this.onTabChanged,
    required this.onPickerChanged,
  });

  final TPickerColumns items;
  final int currentTab;
  final List<List<int>> initialValues;
  final ValueChanged<int> onTabChanged;
  final void Function(int tab, List<int> value) onPickerChanged;

  @override
  State<_RangeTimePickerPanel> createState() => _RangeTimePickerPanelState();
}

class _RangeTimePickerPanelState extends State<_RangeTimePickerPanel> {
  late int _tab = widget.currentTab;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: _bottomCardDecoration(context),
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
              onTap: (i) {
                setState(() => _tab = i);
                widget.onTabChanged(i);
              },
            ),
            TPicker(
              key: ValueKey(_tab),
              items: widget.items,
              initialValue: widget.initialValues[_tab],
              height: 180,
              itemCount: 5,
              onChange: (v) =>
                  widget.onPickerChanged(_tab, List<int>.from(v.values)),
            ),
          ],
        ),
      ),
    );
  }
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

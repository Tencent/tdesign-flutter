import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import '../../base/example_widget.dart';
import '../annotation/demo.dart';
import '../lunar_data_source_example.dart';

/// TCalendar 日历组件示例页
///
/// 演示 [TCalendar] 的所有使用方式：
/// - **Popup 模式**：通过 [TCalendar.showPopup] 以弹窗形式展示日历
///   - 单选、多选、区间选择
///   - 单选 + 时间、区间 + 时间
///   - 锚点定位
/// - **自定义样式**：文案、按钮、日期单元格
/// - **农历日历**：结合 [TCalendarDataSource] 展示农历信息
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
            desc: '自定义文案、按钮、单元格',
            ignoreCode: true,
            center: false,
            builder: (BuildContext context) {
              return const CodeWrapper(builder: _buildStyle);
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
///
/// 包含 6 种 [TCalendar.showPopup] 弹窗模式：
/// 1. 单选 + 天气 bottom
/// 2. 多选 + 已选汇总 bottom
/// 3. 区间选择 + 区间摘要 bottom
/// 4. 单选 + 时间选择器 bottom
/// 5. 区间 + 双时间选择器 bottom（Tab 切换开始/结束）
/// 6. 锚点定位到指定月份
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
/// 单选日历 + bottom 天气面板
///
/// 演示 [TCalendar.showPopup] 的 popupBottomBuilder / popupBottomExpanded 用法
/// （底部区域仅弹窗模式，经 [TCalendarInherited] 注入，不可传给内嵌 [TCalendar]）：
/// - 选中日期后展开 bottom 区域显示天气信息
/// - 确认后回传选中值
class _SingleCalendarCell extends StatefulWidget {
  const _SingleCalendarCell();
  @override
  State<_SingleCalendarCell> createState() => _SingleCalendarCellState();
}

class _SingleCalendarCellState extends State<_SingleCalendarCell> {
  List<DateTime> _selected = const [];
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
    return TCell(
      title: '单个选择日历',
      arrow: true,
      note: _formatYmd(_selected),
      onClick: (_) {
        _expanded.value = _selected.isNotEmpty;
        TCalendar.showPopup(
          context,
          titleWidget: const Text('请选择日期'),
          initialValue: _selected,
          popupBottomExpanded: _expanded,
          onCellClick: (value, selectType, tdate) => _expanded.value = true,
          popupBottomBuilder: (bCtx, dates) {
            final d = dates.isEmpty ? DateTime.now() : dates.first;
            return _WeatherPanel(date: d, weather: _weatherFor(d));
          },
          onConfirm: (value) => setState(() => _selected = value),
          onClose: () => _expanded.value = false,
        );
      },
    );
  }
}

// ========================= 2. 多选 =========================
/// 多选日历 + bottom 已选汇总
///
/// 演示 [CalendarType.multiple] 多选模式，popupBottomBuilder 区域展示已选日期列表。
class _MultipleCalendarCell extends StatefulWidget {
  const _MultipleCalendarCell();
  @override
  State<_MultipleCalendarCell> createState() => _MultipleCalendarCellState();
}

class _MultipleCalendarCellState extends State<_MultipleCalendarCell> {
  List<DateTime> _dates = const [];

  @override
  Widget build(BuildContext context) {
    return TCell(
      title: '多个选择日历',
      arrow: true,
      note: _dates.isEmpty ? '--' : '已选 ${_dates.length} 天',
      onClick: (_) {
        TCalendar.showPopup(
          context,
          titleWidget: const Text('请选择日期'),
          type: CalendarType.multiple,
          initialValue: _dates.isEmpty ? [DateTime.now()] : _dates,
          popupBottomBuilder: (bCtx, dates) => _MultipleSummary(selected: dates),
          onConfirm: (value) => setState(() => _dates = value),
        );
      },
    );
  }
}

// ========================= 3. 区间 =========================
/// 区间选择日历 + bottom 区间摘要
///
/// 演示 [CalendarType.range] 区间模式，popupBottomBuilder 区域展示开始/结束日期及天数。
class _RangeCalendarCell extends StatefulWidget {
  const _RangeCalendarCell();
  @override
  State<_RangeCalendarCell> createState() => _RangeCalendarCellState();
}

class _RangeCalendarCellState extends State<_RangeCalendarCell> {
  late List<DateTime> _dates = [
    DateTime.now(),
    DateTime.now().add(const Duration(days: 6)),
  ];

  @override
  Widget build(BuildContext context) {
    return TCell(
      title: '区间选择日历',
      arrow: true,
      note: _dates.length >= 2
          ? '${_formatMd(_dates.first)} ~ ${_formatMd(_dates[1])}'
          : '--',
      onClick: (_) {
        TCalendar.showPopup(
          context,
          titleWidget: const Text('请选择日期区间'),
          type: CalendarType.range,
          initialValue: _dates,
          popupBottomBuilder: (bCtx, dates) => _RangeSummary(selected: dates),
          onConfirm: (value) => setState(() => _dates = value),
        );
      },
    );
  }
}

// ========================= 4. 单选 + 时间 =========================
/// 单选日历 + 时间选择器
///
/// 演示 popupBottomBuilder 区域放置 [TPicker] 时间选择器，
/// 确认时将日期和时间合并为完整 DateTime。
class _SingleTimeCalendarCell extends StatefulWidget {
  const _SingleTimeCalendarCell();
  @override
  State<_SingleTimeCalendarCell> createState() =>
      _SingleTimeCalendarCellState();
}

class _SingleTimeCalendarCellState extends State<_SingleTimeCalendarCell> {
  late List<DateTime> _selected;
  // 当前选中的时分（持久跨弹窗）
  late int _hour;
  late int _minute;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _hour = now.hour;
    _minute = now.minute;
    // 初始值就带上当前时分
    _selected = [
      DateTime.now()
          .add(const Duration(days: 30))
          .copyWith(hour: _hour, minute: _minute, second: 0, millisecond: 0),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final d = _selected.first;
    return TCell(
      title: '单个选择日历和时间',
      arrow: true,
      note: '${d.year}-${d.month.toString().padLeft(2, '0')}-'
          '${d.day.toString().padLeft(2, '0')} '
          '${d.hour.toString().padLeft(2, '0')}:'
          '${d.minute.toString().padLeft(2, '0')}',
      onClick: (_) {
        var popupHour = _hour;
        var popupMinute = _minute;
        TCalendar.showPopup(
          context,
          titleWidget: const Text('请选择日期和时间'),
          popupHeight: 780,
          initialValue: _selected,
          popupBottomBuilder: (_, __) => _TimePickerPanel(
            initialHour: popupHour,
            initialMinute: popupMinute,
            title: '选择时间',
            onChange: (hour, min) {
              popupHour = hour;
              popupMinute = min;
            },
          ),
          onConfirm: (dates) {
            final merged = dates.map((d) {
              return d.copyWith(
                hour: popupHour,
                minute: popupMinute,
                second: 0,
                millisecond: 0,
              );
            }).toList();
            setState(() {
              _selected = merged;
              _hour = popupHour;
              _minute = popupMinute;
            });
          },
        );
      },
    );
  }
}

// ========================= 5. 区间 + 时间 =========================
/// 区间选择 + 双时间选择器
///
/// 演示 popupBottomBuilder 区域使用 [TTabBar] + [TPicker] 组合，
/// 点击日期单元格时自动切换开始/结束时间 Tab，
/// 确认时分别合并开始和结束的日期+时间。
class _RangeTimeCalendarCell extends StatefulWidget {
  const _RangeTimeCalendarCell();
  @override
  State<_RangeTimeCalendarCell> createState() => _RangeTimeCalendarCellState();
}

class _RangeTimeCalendarCellState extends State<_RangeTimeCalendarCell> {
  late List<DateTime> _dates;
  // 持久跨弹窗的开始/结束时分
  late List<int> _startTime;
  late List<int> _endTime;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _startTime = [now.hour, now.minute];
    _endTime = [now.hour, now.minute];
    // 初始值就带上当前时分
    _dates = [
      now.copyWith(second: 0, millisecond: 0),
      now
          .add(const Duration(days: 3))
          .copyWith(second: 0, millisecond: 0),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return TCell(
      title: '区间选择日历和时间',
      arrow: true,
      note: _dates.length >= 2
          ? '${_formatMdHm(_dates.first)} ~ ${_formatMdHm(_dates.last)}'
          : '--',
      onClick: (_) {
        var popupStartTime = List<int>.from(_startTime);
        var popupEndTime = List<int>.from(_endTime);
        final panelKey = GlobalKey<_RangeTimePickerPanelState>();
        TCalendar.showPopup(
          context,
          titleWidget: const Text('请选择日期和时间区间'),
          popupHeight: 780,
          type: CalendarType.range,
          initialValue: _dates,
          onCellClick: (value, selectType, tdate) {
            if (selectType == DateSelectType.start) {
              panelKey.currentState?.switchTab(0);
            } else if (selectType == DateSelectType.end) {
              panelKey.currentState?.switchTab(1);
            }
          },
          popupBottomBuilder: (_, __) => _RangeTimePickerPanel(
            key: panelKey,
            initialStartTime: popupStartTime,
            initialEndTime: popupEndTime,
            onChanged: (isStart, hour, min) {
              if (isStart) {
                popupStartTime = [hour, min];
              } else {
                popupEndTime = [hour, min];
              }
            },
          ),
          onConfirm: (value) {
            if (value.length < 2) {
              return;
            }
            final merged = [
              value[0].copyWith(
                hour: popupStartTime[0],
                minute: popupStartTime[1],
                second: 0,
                millisecond: 0,
              ),
              value[1].copyWith(
                hour: popupEndTime[0],
                minute: popupEndTime[1],
                second: 0,
                millisecond: 0,
              ),
            ];
            setState(() {
              _dates = merged;
              _startTime = popupStartTime;
              _endTime = popupEndTime;
            });
          },
        );
      },
    );
  }
}

// ========================= 6. 锚点 =========================
/// 锚点定位
///
/// 演示 [TCalendar.showPopup] 的 anchorDate 参数，
/// 弹出日历时自动滚动到指定月份。
class _AnchorCalendarCell extends StatefulWidget {
  const _AnchorCalendarCell();
  @override
  State<_AnchorCalendarCell> createState() => _AnchorCalendarCellState();
}

class _AnchorCalendarCellState extends State<_AnchorCalendarCell> {
  List<DateTime> _selected = [DateTime(2026, 5, 1)];

  @override
  Widget build(BuildContext context) {
    return TCell(
      title: '添加锚点',
      arrow: true,
      note: _formatYmd(_selected),
      onClick: (_) {
        TCalendar.showPopup(
          context,
          titleWidget: const Text('请选择日期'),
          anchorDate: DateTime(2026),
          initialValue: _selected,
          onConfirm: (dates) => setState(() => _selected = dates),
        );
      },
    );
  }
}

// ===== 共用：构建时间选择器 items =====
/// 构建时间选择器的列数据（24 小时 × 60 分钟）
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
String _formatYmd(List<DateTime> dates) {
  if (dates.isEmpty) {
    return '--';
  }
  final d = dates.first;
  return '${d.year}-${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}

String _formatMd(DateTime d) {
  return '${d.month}/${d.day}';
}

String _formatMdHm(DateTime d) {
  return '${d.month}/${d.day} '
      '${d.hour.toString().padLeft(2, '0')}:'
      '${d.minute.toString().padLeft(2, '0')}';
}

String _formatYmdFull(DateTime d) {
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

/// 自定义单元格容器：统一圆角 + 填充色 + 撑满约束
class _CustomCellContainer extends StatelessWidget {
  const _CustomCellContainer({required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      constraints: const BoxConstraints.expand(),
      alignment: Alignment.center,
      child: child,
    );
  }
}

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

  final List<DateTime> selected;

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
                .map((d) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: TTheme.of(context).brandColor1,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _formatYmdFull(d),
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

  final List<DateTime> selected;

  @override
  Widget build(BuildContext context) {
    final hasStart = selected.isNotEmpty;
    final hasEnd = selected.length >= 2;
    final days = hasEnd
        ? selected[1].difference(selected[0]).inDays + 1
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

class _TimePickerPanel extends StatefulWidget {
  const _TimePickerPanel({
    required this.initialHour,
    required this.initialMinute,
    required this.title,
    required this.onChange,
  });

  final int initialHour;
  final int initialMinute;
  final String title;
  final void Function(int hour, int minute) onChange;

  @override
  State<_TimePickerPanel> createState() => _TimePickerPanelState();
}

class _TimePickerPanelState extends State<_TimePickerPanel> {
  late final TPickerColumns _items;
  late final List<dynamic> _initialValue;

  @override
  void initState() {
    super.initState();
    _items = _buildTimeItems();
    _initialValue = [widget.initialHour, widget.initialMinute];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _bottomCardDecoration(context),
      child: TPicker(
        items: _items,
        initialValue: _initialValue,
        height: 180,
        itemCount: 5,
        title: widget.title,
        onChange: (v) {
          final values = v.values;
          if (values.length >= 2 && values[0] is int && values[1] is int) {
            widget.onChange(values[0] as int, values[1] as int);
          }
        },
      ),
    );
  }
}

/// 区间+时间 demo 的双时间选择器面板（Tab 切换开始/结束）
///
/// 外部可通过 `switchTab` 方法驱动 Tab 切换（如日历 onCellClick 触发）。
/// 每个 Tab 内部的时间选择值会被缓存，切回时恢复。
class _RangeTimePickerPanel extends StatefulWidget {
  const _RangeTimePickerPanel({
    super.key,
    required this.initialStartTime,
    required this.initialEndTime,
    required this.onChanged,
  });

  final List<int> initialStartTime;
  final List<int> initialEndTime;
  final void Function(bool isStart, int hour, int minute) onChanged;

  @override
  State<_RangeTimePickerPanel> createState() => _RangeTimePickerPanelState();
}

class _RangeTimePickerPanelState extends State<_RangeTimePickerPanel>
    with SingleTickerProviderStateMixin {
  late final TPickerColumns _items;
  late final TabController _tabController;
  int _tab = 0;
  // 缓存用户在每个 tab 上最后选择的时分，不依赖 widget props 重置
  late List<int> _startSelected;
  late List<int> _endSelected;

  @override
  void initState() {
    super.initState();
    _items = _buildTimeItems();
    _tabController = TabController(length: 2, vsync: this);
    _startSelected = List<int>.from(widget.initialStartTime);
    _endSelected = List<int>.from(widget.initialEndTime);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<dynamic> get _currentInitialValue =>
      _tab == 0 ? _startSelected : _endSelected;

  /// 由外部（日历 onCellClick）驱动切换 tab
  void switchTab(int tab) {
    if (_tab == tab) {
      return;
    }
    setState(() => _tab = tab);
    _tabController.animateTo(tab);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _bottomCardDecoration(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TTabBar(
            height: 40,
            showIndicator: true,
            controller: _tabController,
            tabs: const [
              TTab(text: '开始时间'),
              TTab(text: '结束时间'),
            ],
            onTap: (i) => setState(() => _tab = i),
          ),
          TPicker(
            key: ValueKey(_tab),
            items: _items,
            initialValue: _currentInitialValue,
            height: 180,
            itemCount: 5,
            onChange: (v) {
              final values = v.values;
              if (values.length >= 2 && values[0] is int && values[1] is int) {
                final h = values[0] as int;
                final m = values[1] as int;
                // 缓存当前 tab 的选中值，切回 tab 时恢复位置
                if (_tab == 0) {
                  _startSelected = [h, m];
                } else {
                  _endSelected = [h, m];
                }
                widget.onChanged(_tab == 0, h, m);
              }
            },
          ),
        ],
      ),
    );
  }
}

/// 「组件样式 - 自定义文案 / 按钮 / 单元格」
@Demo(group: 'calendar')
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
          // 1. 自定义文案（cellBuilder，仅 showPopup 弹窗模式）
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
                cellBuilder: (context, cell) {
                  final isSpecial = cell.date.month == 2 &&
                      map.keys.contains(cell.date.day);
                  final sub = isSpecial ? '¥100' : '¥60';
                  final top = isSpecial ? map[cell.date.day] : null;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (top != null)
                        Text(top,
                            style: TextStyle(
                              fontSize: 9,
                              color: isSpecial
                                  ? TTheme.of(context).errorColor6
                                  : null,
                            )),
                      Text(
                        cell.date.day.toString(),
                        style: TextStyle(
                          color: cell.selectType == DateSelectType.selected
                              ? TTheme.of(context).fontWhColor1
                              : isSpecial
                                  ? TTheme.of(context).errorColor6
                                  : null,
                        ),
                      ),
                      Text(sub,
                          style: TextStyle(
                            fontSize: 9,
                            color: cell.selectType == DateSelectType.selected
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

          // 3. 自定义日期单元格（cellBuilder 回调）
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
                cellBuilder: (context, cell) {
                  final today = DateTime.now();
                  final isToday = cell.date ==
                      DateTime(today.year, today.month, today.day);

                  if (isToday && cell.selectType != DateSelectType.selected) {
                    return _CustomCellContainer(
                      color: TTheme.of(context).brandColor4,
                      child: const Text('今天',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    );
                  }
                  if (cell.selectType == DateSelectType.selected) {
                    return _CustomCellContainer(
                      color: TTheme.of(context).successColor8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${cell.date.day}',
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
                      Text('${cell.date.day}',
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
}

/// 「组件样式 - 农历日历」
///
/// 非弹窗内嵌模式，通过 [TCalendarDataSource.getSubtitle] 展示农历副标题，
/// 支持月份切换、年份/月份弹窗选择。
@Demo(group: 'calendar')
Widget _buildLunar(BuildContext context) {
  return const _LunarCalendarDemo();
}

/// 农历日历内嵌演示
///
/// 控制栏（_LunarControlBar）与日历（TCalendar）分离：
/// - 滑动日历时 onMonthChange 只更新控制栏，不重建日历，避免跳动
/// - 点击控制栏导航时才更新 anchorDate，驱动日历滚动
class _LunarCalendarDemo extends StatefulWidget {
  const _LunarCalendarDemo();

  @override
  State<_LunarCalendarDemo> createState() => _LunarCalendarDemoState();
}

class _LunarCalendarDemoState extends State<_LunarCalendarDemo> {
  final _dataSource = LunarDataSourceExample();

  // 日历可用日期范围。年份/月份选择器都基于这两个常量约束，
  // 避免越界导致组件层 clamp 兜底（视觉上会卡在端点月份）。
  static final DateTime _minDate = DateTime(2020, 1, 1);
  static final DateTime _maxDate = DateTime(2030, 12, 31);

  DateTime? _anchorDate;
  List<DateTime> _selected = [DateTime.now()];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LunarControlBar(
          key: _LunarControlBar.monthKey,
          dataSource: _dataSource,
          minDate: _minDate,
          maxDate: _maxDate,
          onNavigate: (anchor) {
            setState(() {
              _anchorDate = anchor;
            });
          },
        ),

        TCalendar(
          type: CalendarType.single,
          minDate: _minDate,
          maxDate: _maxDate,
          initialValue: _selected,
          anchorDate: _anchorDate,
          animateTo: true,
          dataSource: _dataSource,
          onMonthChange: (month) {
            // 只通知控制栏更新显示，不 setState 本身 → 日历不重建
            _LunarControlBar.monthKey.currentState
                ?.updateMonth(DateTime(month.year, month.month, 1));
          },
          onChange: (value) => setState(() => _selected = value),
        ),
      ],
    );
  }
}

/// 农历日历控制栏
///
/// 独立管理 _currentMonth 状态，滑动日历时只更新本 Widget，
/// 不触发上层日历重建，避免跳动。
class _LunarControlBar extends StatefulWidget {
  const _LunarControlBar({
    super.key,
    required this.dataSource,
    required this.minDate,
    required this.maxDate,
    required this.onNavigate,
  });

  final LunarDataSourceExample dataSource;
  final DateTime minDate;
  final DateTime maxDate;
  final ValueChanged<DateTime> onNavigate;

  /// 全局 Key，供父 Widget 通过 currentState.updateMonth() 同步月份
  static final GlobalKey<_LunarControlBarState> monthKey =
      GlobalKey<_LunarControlBarState>();

  @override
  State<_LunarControlBar> createState() => _LunarControlBarState();
}

class _LunarControlBarState extends State<_LunarControlBar> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = _clampMonth(DateTime(now.year, now.month, 1));
  }

  /// 将任意 (year, month) clamp 到 [minDate, maxDate] 区间内。
  DateTime _clampMonth(DateTime date) {
    final minKey = widget.minDate.year * 12 + widget.minDate.month;
    final maxKey = widget.maxDate.year * 12 + widget.maxDate.month;
    final key = (date.year * 12 + date.month).clamp(minKey, maxKey);
    final year = (key - 1) ~/ 12;
    final month = (key - 1) % 12 + 1;
    return DateTime(year, month, 1);
  }

  bool _canGoPrev() {
    final cur = _currentMonth.year * 12 + _currentMonth.month;
    final minKey = widget.minDate.year * 12 + widget.minDate.month;
    return cur > minKey;
  }

  bool _canGoNext() {
    final cur = _currentMonth.year * 12 + _currentMonth.month;
    final maxKey = widget.maxDate.year * 12 + widget.maxDate.month;
    return cur < maxKey;
  }

  /// 由日历 onMonthChange 回调驱动，仅更新显示。
  ///
  /// 注意：日历组件（TCalendarBody）内部已对程序化滚动期间的 onMonthChange 做静默，
  /// 因此这里收到的回调只会是「用户手势滑动」或「滚动落定后的最终月份」，
  /// 无需再做额外的中间值屏蔽。
  void updateMonth(DateTime month) {
    if (_currentMonth.year == month.year && _currentMonth.month == month.month) {
      return;
    }
    setState(() => _currentMonth = month);
  }

  void _navigateTo(DateTime month) {
    final clamped = _clampMonth(month);
    // 命中相同月份时直接返回，避免触发上层无意义重建。
    if (_currentMonth.year == clamped.year &&
        _currentMonth.month == clamped.month) {
      return;
    }
    // 立即更新控制栏显示，用户感知零延迟；
    // 日历组件会自行屏蔽随后程序化滚动期间的中间月份回调。
    setState(() => _currentMonth = clamped);
    widget.onNavigate(DateTime(clamped.year, clamped.month, 15));
  }

  Future<void> _pickYear() async {
    final minYear = widget.minDate.year;
    final maxYear = widget.maxDate.year;
    final count = maxYear - minYear + 1;
    final selectedIndex = _currentMonth.year - minYear;
    // 让选中项默认居中（每行约 56 dp，参考 ListTile 默认高度）。
    const itemExtent = 56.0;
    final controller = ScrollController(
      initialScrollOffset: (selectedIndex * itemExtent - 120).clamp(
        0.0,
        (count * itemExtent - 200).clamp(0.0, double.infinity),
      ),
    );
    final year = await showModalBottomSheet<int>(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('选择年份',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemExtent: itemExtent,
                  itemCount: count,
                  itemBuilder: (ctx, index) {
                    final y = minYear + index;
                    final isSelected = y == _currentMonth.year;
                    return ListTile(
                      title: Text('$y年',
                          style: TextStyle(
                            color: isSelected ? Colors.blue : null,
                            fontWeight:
                                isSelected ? FontWeight.bold : null,
                          )),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: Colors.blue)
                          : null,
                      onTap: () => Navigator.pop(ctx, y),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
    controller.dispose();
    if (year != null) {
      // 切年时，目标月可能在端点年越界，_navigateTo 内部会兜底 clamp。
      _navigateTo(DateTime(year, _currentMonth.month, 1));
    }
  }

  Future<void> _pickMonth() async {
    final minKey = widget.minDate.year * 12 + widget.minDate.month;
    final maxKey = widget.maxDate.year * 12 + widget.maxDate.month;
    final m = await showModalBottomSheet<int>(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: 400,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('选择月份',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  itemBuilder: (ctx, index) {
                    final month = index + 1;
                    final monthKey = _currentMonth.year * 12 + month;
                    final isDisabled =
                        monthKey < minKey || monthKey > maxKey;
                    final isSelected =
                        !isDisabled && month == _currentMonth.month;
                    final bgColor = isDisabled
                        ? Colors.grey.shade100
                        : (isSelected ? Colors.blue : Colors.grey.shade200);
                    final fgColor = isDisabled
                        ? Colors.grey.shade400
                        : (isSelected ? Colors.white : Colors.black);
                    return InkWell(
                      onTap: isDisabled
                          ? null
                          : () => Navigator.pop(ctx, month),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('$month月',
                            style: TextStyle(
                              color: fgColor,
                              fontWeight:
                                  isSelected ? FontWeight.bold : null,
                            )),
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
    if (m != null) {
      _navigateTo(DateTime(_currentMonth.year, m, 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    final lunarInfo = widget.dataSource.getLunarInfo(_currentMonth);
    final lunarMonth = lunarInfo != null
        ? '${lunarInfo.yearText}年 ${lunarInfo.monthText}'
        : '';
    final canPrev = _canGoPrev();
    final canNext = _canGoNext();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 固定高度容器，防止农历文字有无时布局跳动
          SizedBox(
            height: 20,
            child: lunarMonth.isNotEmpty
                ? Text(
                    lunarMonth,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  )
                : const SizedBox.shrink(),
          ),
          Row(
            children: [
              TButton(
                text: '◀',
                size: TButtonSize.small,
                theme: TButtonTheme.defaultTheme,
                disabled: !canPrev,
                onTap: canPrev
                    ? () => _navigateTo(DateTime(
                        _currentMonth.year, _currentMonth.month - 1, 1))
                    : null,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: TButton(
                  text: '${_currentMonth.year}年',
                  size: TButtonSize.small,
                  theme: TButtonTheme.defaultTheme,
                  onTap: _pickYear,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: TButton(
                  text: '${_currentMonth.month}月',
                  size: TButtonSize.small,
                  theme: TButtonTheme.defaultTheme,
                  onTap: _pickMonth,
                ),
              ),
              const SizedBox(width: 4),
              TButton(
                text: '▶',
                size: TButtonSize.small,
                theme: TButtonTheme.defaultTheme,
                disabled: !canNext,
                onTap: canNext
                    ? () => _navigateTo(DateTime(
                        _currentMonth.year, _currentMonth.month + 1, 1))
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

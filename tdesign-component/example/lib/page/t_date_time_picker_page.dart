import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';
import '../../base/example_widget.dart';

class TDateTimePickerPage extends StatefulWidget {
  const TDateTimePickerPage({super.key});

  @override
  State<TDateTimePickerPage> createState() => _TDateTimePickerPageState();
}

class _TDateTimePickerPageState extends State<TDateTimePickerPage> {
  TDateTimePickerValue _baseSelected = _kInlineValue;
  TDateTimePickerValue _yearMonthSelected = const TDateTimePickerValue(
    year: 2026,
    month: 5,
  );
  TDateTimePickerValue _timeSelected = const TDateTimePickerValue(
    hour: 12,
    minute: 30,
  );
  DateTime _calendarTimeSelected = DateTime(2026, 5, 15, 12, 30);
  TDateTimePickerValue? _rangeSelected;
  TDateTimePickerValue _weekSelected = _kInlineValue;
  final ValueNotifier<TDateTimePickerValue?> _inlineSelectedNotifier =
      ValueNotifier<TDateTimePickerValue?>(null);

  /// 内嵌滚轮的受控值。
  static const _kInlineValue = TDateTimePickerValue(
    year: 2026,
    month: 5,
    day: 15,
    hour: 12,
    minute: 30,
  );

  /// 自定义范围 demo：start/end 须含完整年月日时分秒，各级在边界日按时序收紧。
  static const _kRangeStart = TDateTimePickerValue(
    year: 2025,
    month: 2,
    day: 10,
    hour: 9,
    minute: 30,
    second: 0,
  );

  static const _kRangeEnd = TDateTimePickerValue(
    year: 2028,
    month: 8,
    day: 25,
    hour: 18,
    minute: 45,
    second: 30,
  );

  static const _kRangeInitial = TDateTimePickerValue(
    year: 2025,
    month: 7,
    day: 15,
    hour: 12,
    minute: 0,
    second: 0,
  );

  @override
  void dispose() {
    _inlineSelectedNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '内嵌示例实时响应 onChanged；弹窗示例仅在点击确定后提交。',
      exampleCodeGroup: 'date-time-picker',
      children: [
        ExampleModule(
          title: '内嵌用法',
          children: [ExampleItem(desc: '实时变化（内嵌）', builder: _buildInline)],
        ),
        ExampleModule(
          title: '弹出层用法',
          children: [
            ExampleItem(desc: '年月日选择器', builder: _buildBase),
            ExampleItem(desc: '选择年月', builder: _buildYearMonth),
            ExampleItem(desc: '选择时分', builder: _buildTime),
            ExampleItem(desc: '日历 + 时间', builder: _buildCalendarTime),
            ExampleItem(
              desc:
                  '自定义选择范围（2025-06-10 09:30:00 ~ 2025-08-25 18:45:30）；月/日/时/分/秒在边界上下文收紧',
              builder: _buildCustomRange,
            ),
            ExampleItem(desc: '年月日 + 星期', builder: _buildWeek),
          ],
        ),
      ],
    );
  }

  @ExampleCode(group: 'date-time-picker')
  Widget _buildInline(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: context.tTheme.bgColorContainer,
        borderRadius: BorderRadius.circular(context.tTheme.radiusDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: ValueListenableBuilder<TDateTimePickerValue?>(
              valueListenable: _inlineSelectedNotifier,
              builder: (context, selected, _) => TText(
                '当前选择：${_formatResult(selected)}',
                textColor: context.tTheme.textColorSecondary,
              ),
            ),
          ),
          TDateTimePicker(
            mode: DateTimePickerMode(
              dateMode: DateMode.date,
              timeMode: TimeMode.minute,
            ),
            value: _kInlineValue,
            onChanged: (result) => _inlineSelectedNotifier.value = result,
          ),
        ],
      ),
    );
  }

  /// 弹窗承载滚轮，滚动只更新草稿，点击确定后才提交到页面状态。
  void _showPickerPopup(
    BuildContext context, {
    required String title,
    required TDateTimePickerValue value,
    required DateTimePickerMode mode,
    TDateTimePickerValue? start,
    TDateTimePickerValue? end,
    DateTimePickerSteps? steps,
    bool showWeek = false,
    DateTimePickerRenderLabel? renderLabel,
    required ValueChanged<TDateTimePickerValue> onConfirm,
  }) {
    var draft = value;
    TPopup.show(
      context,
      options: TPopupOptions.bottom(
        headerBuilder: (_, close) => TPopupHeader(
          cancelButton: TextButton(onPressed: close, child: const TText('取消')),
          title: TText(title),
          confirmButton: TextButton(
            onPressed: () {
              if (mounted) {
                onConfirm(draft);
              }
              close();
            },
            child: const TText('确定'),
          ),
        ),
        child: Material(
          color: context.tTheme.bgColorContainer,
          child: SafeArea(
            top: false,
            child: StatefulBuilder(
              builder: (context, setPopupState) => TDateTimePicker(
                key: const Key('date-time-picker-popup-wheel'),
                mode: mode,
                value: draft,
                start: start,
                end: end,
                steps: steps,
                showWeek: showWeek,
                renderLabel: renderLabel,
                onChanged: (value) {
                  setPopupState(() => draft = value);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 将 TDateTimePicker.onChanged 返回的 partial 值格式化为展示文案。
  ///
  /// 仅拼接非 null 字段；无需 [TDateTimePickerValue.toDateTime]。
  String _formatResult(TDateTimePickerValue? v) {
    if (v == null) {
      return '请选择';
    }
    final parts = <String>[];

    final dateParts = <String>[];
    if (v.year != null) {
      dateParts.add('${v.year}');
    }
    if (v.month != null) {
      dateParts.add(v.month.toString().padLeft(2, '0'));
    }
    if (v.day != null) {
      dateParts.add(v.day.toString().padLeft(2, '0'));
    }
    if (dateParts.isNotEmpty) {
      parts.add(dateParts.join('-'));
    }

    final timeParts = <String>[];
    if (v.hour != null) {
      timeParts.add(v.hour.toString().padLeft(2, '0'));
    }
    if (v.minute != null) {
      timeParts.add(v.minute.toString().padLeft(2, '0'));
    }
    if (v.second != null) {
      timeParts.add(v.second.toString().padLeft(2, '0'));
    }
    if (timeParts.isNotEmpty) {
      parts.add(timeParts.join(':'));
    }

    return parts.join(' ');
  }

  // ========== Demo: base ==========

  @ExampleCode(group: 'date-time-picker')
  Widget _buildBase(BuildContext context) {
    return TCell(
      key: const Key('date-time-picker-base-trigger'),
      title: const Text('年月日选择器'),
      note: Text(_formatResult(_baseSelected)),
      arrow: true,
      onTap: () {
        _showPickerPopup(
          context,
          title: '选择日期',
          mode: DateTimePickerMode(dateMode: DateMode.date),
          value: _baseSelected,
          onConfirm: (result) => setState(() => _baseSelected = result),
        );
      },
    );
  }

  // ========== Demo: year-month ==========

  @ExampleCode(group: 'date-time-picker')
  Widget _buildYearMonth(BuildContext context) {
    return TCell(
      key: const Key('date-time-picker-year-month-trigger'),
      title: const Text('选择年月'),
      note: Text(_formatResult(_yearMonthSelected)),
      arrow: true,
      onTap: () {
        _showPickerPopup(
          context,
          title: '选择年月',
          mode: DateTimePickerMode(dateMode: DateMode.month),
          value: _yearMonthSelected,
          onConfirm: (result) => setState(() => _yearMonthSelected = result),
        );
      },
    );
  }

  // ========== Demo: time ==========

  @ExampleCode(group: 'date-time-picker')
  Widget _buildTime(BuildContext context) {
    return TCell(
      key: const Key('date-time-picker-time-trigger'),
      title: const Text('选择时分'),
      note: Text(_formatResult(_timeSelected)),
      arrow: true,
      onTap: () {
        _showPickerPopup(
          context,
          title: '选择时间',
          mode: DateTimePickerMode(timeMode: TimeMode.minute),
          value: _timeSelected,
          onConfirm: (result) => setState(() => _timeSelected = result),
        );
      },
    );
  }

  // ========== Demo: calendar + time ==========

  @ExampleCode(group: 'date-time-picker')
  Widget _buildCalendarTime(BuildContext context) {
    return TCell(
      key: const Key('calendar-time-trigger'),
      title: const Text('日历 + 时间'),
      note: Text(_formatDateTime(_calendarTimeSelected)),
      arrow: true,
      onTap: () {
        var draftDate = [
          DateTime(
            _calendarTimeSelected.year,
            _calendarTimeSelected.month,
            _calendarTimeSelected.day,
          ),
        ];
        var draftTime = TDateTimePickerValue(
          hour: _calendarTimeSelected.hour,
          minute: _calendarTimeSelected.minute,
        );
        TPopup.show(
          context,
          options: TPopupOptions.bottom(
            height: MediaQuery.sizeOf(context).height,
            headerBuilder: (_, close) => TPopupHeader(
              cancelButton: TextButton(
                onPressed: close,
                child: const TText('取消'),
              ),
              title: const TText('选择日期和时间'),
              confirmButton: TextButton(
                onPressed: () {
                  if (mounted && draftDate.isNotEmpty) {
                    final date = draftDate.first;
                    setState(() {
                      _calendarTimeSelected = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        draftTime.hour ?? _calendarTimeSelected.hour,
                        draftTime.minute ?? _calendarTimeSelected.minute,
                      );
                    });
                  }
                  close();
                },
                child: const TText('确定'),
              ),
            ),
            child: StatefulBuilder(
              builder: (context, setPopupState) => Column(
                key: const Key('calendar-time-popup'),
                children: [
                  Expanded(
                    child: TCalendar(
                      key: const Key('calendar-time-calendar'),
                      value: draftDate,
                      anchorDate: draftDate.first,
                      onChanged: (value) {
                        setPopupState(() {
                          draftDate = List<DateTime>.of(value);
                        });
                      },
                    ),
                  ),
                  const TDivider(),
                  TDateTimePicker(
                    key: const Key('calendar-time-wheel'),
                    mode: DateTimePickerMode(timeMode: TimeMode.minute),
                    value: draftTime,
                    onChanged: (value) {
                      setPopupState(() => draftTime = value);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime value) {
    String twoDigits(int part) => part.toString().padLeft(2, '0');
    return '${value.year}-${twoDigits(value.month)}-${twoDigits(value.day)} '
        '${twoDigits(value.hour)}:${twoDigits(value.minute)}';
  }

  // ========== Demo: custom-range ==========

  @ExampleCode(group: 'date-time-picker')
  Widget _buildCustomRange(BuildContext context) {
    return TCell(
      key: const Key('date-time-picker-range-trigger'),
      title: const Text('自定义选择范围'),
      note: Text(_formatResult(_rangeSelected)),
      arrow: true,
      onTap: () {
        _showPickerPopup(
          context,
          title: '选择日期和时间',
          mode: DateTimePickerMode(
            dateMode: DateMode.date,
            timeMode: TimeMode.second,
          ),
          start: _kRangeStart,
          end: _kRangeEnd,
          value: _rangeSelected ?? _kRangeInitial,
          onConfirm: (result) => setState(() => _rangeSelected = result),
        );
      },
    );
  }

  // ========== Demo: week ==========

  @ExampleCode(group: 'date-time-picker')
  Widget _buildWeek(BuildContext context) {
    return TCell(
      key: const Key('date-time-picker-week-trigger'),
      title: const Text('年月日 + 星期'),
      note: Text(_formatWeekResult(context, _weekSelected)),
      arrow: true,
      onTap: () {
        _showPickerPopup(
          context,
          title: '选择日期',
          mode: DateTimePickerMode(dateMode: DateMode.date),
          showWeek: true,
          value: _weekSelected,
          onConfirm: (result) => setState(() => _weekSelected = result),
        );
      },
    );
  }

  /// dateTimePicker: 星期由 [TDateTimePickerValue.toDateTime] 派生（weekday 1=周一…7=周日）。
  String _formatWeekResult(BuildContext context, TDateTimePickerValue? v) {
    if (v == null) {
      return '请选择';
    }
    final base = _formatResult(v);
    final week = _weekdayLabel(
      context,
      v.toDateTime(fallback: DateTime(2000, 1, 1)).weekday,
    );
    return '$base $week';
  }

  String _weekdayLabel(BuildContext context, int weekday) {
    final r = TResourceManager.instance.delegate(context);
    String compose(String shortName) {
      if (shortName.length == 1 && r.weeksLabel.isNotEmpty) {
        return '${r.weeksLabel}$shortName';
      }
      return shortName;
    }

    final names = [
      r.monday,
      r.tuesday,
      r.wednesday,
      r.thursday,
      r.friday,
      r.saturday,
      r.sunday,
    ];
    return compose(names[weekday - 1]);
  }
}

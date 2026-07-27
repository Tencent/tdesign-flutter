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
  TDateTimePickerValue _yearMonthSelected =
      const TDateTimePickerValue(year: 2026, month: 5);
  TDateTimePickerValue _timeSelected =
      const TDateTimePickerValue(hour: 12, minute: 30);
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
      desc: '纯滚轮选择日期/时间，选中值通过 onChanged 回调。',
      exampleCodeGroup: 'date-time-picker',
      children: [
        ExampleModule(title: '基础用法', children: [
          ExampleItem(desc: '不使用弹窗（内嵌）', builder: _buildInline),
          ExampleItem(desc: '年月日选择器', builder: _buildBase),
          ExampleItem(desc: '选择年月', builder: _buildYearMonth),
          ExampleItem(desc: '选择时分', builder: _buildTime),
          ExampleItem(
            desc:
                '自定义选择范围（2025-06-10 09:30:00 ~ 2025-08-25 18:45:30）；月/日/时/分/秒在边界上下文收紧',
            builder: _buildCustomRange,
          ),
          ExampleItem(desc: '年月日 + 星期', builder: _buildWeek),
        ]),
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

  /// 弹窗承载滚轮，选择值由 TDateTimePicker.onChanged 实时写入 state。
  void _showPickerPopup(BuildContext context, {required Widget picker}) {
    TPopup.show(
      context,
      options: TPopupOptions.bottom(
        cancelBuilder: null,
        confirmBuilder: null,
        child: Material(
          color: context.tTheme.bgColorContainer,
          child: SafeArea(top: false, child: picker),
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
      title: const Text('年月日选择器'),
      note: Text(_formatResult(_baseSelected)),
      arrow: true,
      onTap: () {
        _showPickerPopup(
          context,
          picker: TDateTimePicker(
            mode: DateTimePickerMode(dateMode: DateMode.date),
            value: _baseSelected,
            onChanged: (result) => setState(() => _baseSelected = result),
          ),
        );
      },
    );
  }

  // ========== Demo: year-month ==========

  @ExampleCode(group: 'date-time-picker')
  Widget _buildYearMonth(BuildContext context) {
    return TCell(
      title: const Text('选择年月'),
      note: Text(_formatResult(_yearMonthSelected)),
      arrow: true,
      onTap: () {
        _showPickerPopup(
          context,
          picker: TDateTimePicker(
            mode: DateTimePickerMode(dateMode: DateMode.month),
            value: _yearMonthSelected,
            onChanged: (result) => setState(() => _yearMonthSelected = result),
          ),
        );
      },
    );
  }

  // ========== Demo: time ==========

  @ExampleCode(group: 'date-time-picker')
  Widget _buildTime(BuildContext context) {
    return TCell(
      title: const Text('选择时分'),
      note: Text(_formatResult(_timeSelected)),
      arrow: true,
      onTap: () {
        _showPickerPopup(
          context,
          picker: TDateTimePicker(
            mode: DateTimePickerMode(timeMode: TimeMode.minute),
            value: _timeSelected,
            onChanged: (result) => setState(() => _timeSelected = result),
          ),
        );
      },
    );
  }

  // ========== Demo: custom-range ==========

  @ExampleCode(group: 'date-time-picker')
  Widget _buildCustomRange(BuildContext context) {
    return TCell(
      title: const Text('自定义选择范围'),
      note: Text(_formatResult(_rangeSelected)),
      arrow: true,
      onTap: () {
        _showPickerPopup(
          context,
          picker: TDateTimePicker(
            mode: DateTimePickerMode(
              dateMode: DateMode.date,
              timeMode: TimeMode.second,
            ),
            start: _kRangeStart,
            end: _kRangeEnd,
            value: _rangeSelected ?? _kRangeInitial,
            onChanged: (result) => setState(() => _rangeSelected = result),
          ),
        );
      },
    );
  }

  // ========== Demo: week ==========

  @ExampleCode(group: 'date-time-picker')
  Widget _buildWeek(BuildContext context) {
    return TCell(
      title: const Text('年月日 + 星期'),
      note: Text(_formatWeekResult(context, _weekSelected)),
      arrow: true,
      onTap: () {
        _showPickerPopup(
          context,
          picker: TDateTimePicker(
            mode: DateTimePickerMode(dateMode: DateMode.date),
            showWeek: true,
            value: _weekSelected,
            onChanged: (result) => setState(() => _weekSelected = result),
          ),
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

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/demo.dart';
import '../../base/example_widget.dart';

class TDateTimePickerPage extends StatefulWidget {
  const TDateTimePickerPage({super.key});

  @override
  State<TDateTimePickerPage> createState() => _TDateTimePickerPageState();
}

class _TDateTimePickerPageState extends State<TDateTimePickerPage> {
  TDateTimePickerValue? _baseSelected;
  TDateTimePickerValue? _yearMonthSelected;
  TDateTimePickerValue? _timeSelected;
  TDateTimePickerValue? _rangeSelected;
  TDateTimePickerValue? _weekSelected;
  final ValueNotifier<TDateTimePickerValue?> _inlineSelectedNotifier =
      ValueNotifier<TDateTimePickerValue?>(null);

  /// 内嵌滚轮首次展示的默认值（固定，勿与 [onChange] 写回绑定）。
  static const _kInlineInitialValue = TDateTimePickerValue(
    year: 2026,
    month: 5,
    day: 15,
    hour: 12,
    minute: 30,
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
      desc: '纯滚轮选择日期/时间，选中值通过 onChange 回调。',
      exampleCodeGroup: 'date-time-picker',
      children: [
        ExampleModule(title: '基础用法', children: [
          ExampleItem(desc: '不使用弹窗（内嵌）', builder: _buildInline),
          ExampleItem(desc: '年月日选择器', builder: _buildBase),
          ExampleItem(desc: '选择年月', builder: _buildYearMonth),
          ExampleItem(desc: '选择时分', builder: _buildTime),
          ExampleItem(
            desc:
                '自定义选择范围（2024–2026）；各列在 [start, end] 内按当前选中上下文收紧',
            builder: _buildCustomRange,
          ),
          ExampleItem(desc: '年月日 + 星期', builder: _buildWeek),
        ]),
      ],
    );
  }

  @Demo(group: 'date-time-picker')
  Widget _buildInline(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: TTheme.of(context).bgColorContainer,
        borderRadius: BorderRadius.circular(TTheme.of(context).radiusDefault),
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
                textColor: TTheme.of(context).textColorSecondary,
              ),
            ),
          ),
          TDateTimePicker(
            mode: DateTimePickerMode(
              dateMode: DateMode.date,
              timeMode: TimeMode.minute,
            ),
            initialValue: _kInlineInitialValue,
            onChange: (result) => _inlineSelectedNotifier.value = result,
          ),
        ],
      ),
    );
  }

  /// dateTimePicker: 弹窗承载滚轮；选中值由 [TDateTimePicker.onChange] 实时写入 state，点遮罩关闭。
  void _showPickerPopup(BuildContext context, {required Widget picker}) {
    TPopup.show(
      context,
      options: TPopupOptions.bottom(
        cancelBuilder: null,
        confirmBuilder: null,
        child: Material(
          color: TTheme.of(context).bgColorContainer,
          child: SafeArea(top: false, child: picker),
        ),
      ),
    );
  }

  /// dateTimePicker: 将 [TDateTimePicker.onChange] 存下的 partial 值格式化为展示文案。
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

  @Demo(group: 'date-time-picker')
  Widget _buildBase(BuildContext context) {
    return TCell(
      title: '年月日选择器',
      note: _formatResult(_baseSelected),
      arrow: true,
      onClick: (_) {
        _showPickerPopup(
          context,
          picker: TDateTimePicker(
            mode: DateTimePickerMode(dateMode: DateMode.date),
            initialValue: _baseSelected,
            onChange: (result) => setState(() => _baseSelected = result),
          ),
        );
      },
    );
  }

  // ========== Demo: year-month ==========

  @Demo(group: 'date-time-picker')
  Widget _buildYearMonth(BuildContext context) {
    return TCell(
      title: '选择年月',
      note: _formatResult(_yearMonthSelected),
      arrow: true,
      onClick: (_) {
        _showPickerPopup(
          context,
          picker: TDateTimePicker(
            mode: DateTimePickerMode(dateMode: DateMode.month),
            initialValue: _yearMonthSelected,
            onChange: (result) => setState(() => _yearMonthSelected = result),
          ),
        );
      },
    );
  }

  // ========== Demo: time ==========

  @Demo(group: 'date-time-picker')
  Widget _buildTime(BuildContext context) {
    return TCell(
      title: '选择时分',
      note: _formatResult(_timeSelected),
      arrow: true,
      onClick: (_) {
        _showPickerPopup(
          context,
          picker: TDateTimePicker(
            mode: DateTimePickerMode(timeMode: TimeMode.minute),
            initialValue: _timeSelected,
            onChange: (result) => setState(() => _timeSelected = result),
          ),
        );
      },
    );
  }

  // ========== Demo: custom-range ==========

  @Demo(group: 'date-time-picker')
  Widget _buildCustomRange(BuildContext context) {
    return TCell(
      title: '自定义选择范围',
      note: _formatResult(_rangeSelected),
      arrow: true,
      onClick: (_) {
        _showPickerPopup(
          context,
          picker: TDateTimePicker(
            mode: DateTimePickerMode(
              dateMode: DateMode.date,
              timeMode: TimeMode.minute,
            ),
            start: const TDateTimePickerValue(year: 2024, month: 1, day: 1),
            end: const TDateTimePickerValue(
              year: 2026,
              month: 12,
              day: 31,
              hour: 23,
              minute: 59,
            ),
            initialValue: _rangeSelected ??
                const TDateTimePickerValue(
                  year: 2025,
                  month: 6,
                  day: 15,
                  hour: 12,
                  minute: 30,
                ),
            onChange: (result) => setState(() => _rangeSelected = result),
          ),
        );
      },
    );
  }

  // ========== Demo: week ==========

  @Demo(group: 'date-time-picker')
  Widget _buildWeek(BuildContext context) {
    return TCell(
      title: '年月日 + 星期',
      note: _formatWeekResult(context, _weekSelected),
      arrow: true,
      onClick: (_) {
        _showPickerPopup(
          context,
          picker: TDateTimePicker(
            mode: DateTimePickerMode(dateMode: DateMode.date),
            showWeek: true,
            initialValue: _weekSelected,
            onChange: (result) => setState(() => _weekSelected = result),
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

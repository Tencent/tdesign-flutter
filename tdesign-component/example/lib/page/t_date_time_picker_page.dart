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

  /// 复用上次选择结果回放为 `initialValue` 时使用的固定 fallback。
  ///
  /// 避免 [TDateTimePickerValue.toDateTime] 在缺字段时用 `DateTime.now()`
  /// 回填导致 Dart 的 [DateTime] 静默溢出（典型场景：年月模式下今日为 31 日，
  /// 选 2 月后再次打开 → `DateTime(2026, 2, 31)` 会溢出成 `2026-03-03`）。
  static final _kReplayFallback = DateTime(2000, 1, 1);

  @override
  void dispose() {
    _inlineSelectedNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于选择一个时间点或者一个时间段。',
      exampleCodeGroup: 'date-time-picker',
      children: [
        ExampleModule(title: '基础用法', children: [
          ExampleItem(desc: '不使用弹窗（内嵌）', builder: _buildInline),
          ExampleItem(desc: '年月日选择器', builder: _buildBase),
          ExampleItem(desc: '选择年月', builder: _buildYearMonth),
          ExampleItem(desc: '选择时分', builder: _buildTime),
          ExampleItem(
            desc:
                '自定义选择范围（2024–2026）；细粒度列按「当前年/月/日」与边界对齐时裁剪，'
                '跨边界不全程收紧，详见 TDateTimePicker 文档',
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
            mode: DateTimePickerMode.combined(
              dateMode: DateMode.date,
              timeMode: TimeMode.minute,
            ),
            title: '内嵌日期时间选择',
            initialValue:
                _inlineSelectedNotifier.value
                        ?.toDateTime(fallback: _kReplayFallback) ??
                    DateTime.now(),
            onChange: (result) => _inlineSelectedNotifier.value = result,
            onConfirm: (result) => _inlineSelectedNotifier.value = result,
          ),
        ],
      ),
    );
  }

  /// 弹窗工具方法：从底部滑入选择器面板
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

  /// 将 [TDateTimePickerValue] 渲染为示例页展示文案。
  ///
  /// 仅展示当前 mode 涉及的字段（其它字段为 null 时不显示）。
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
            mode: DateTimePickerMode.ymd,
            title: '请选择日期',
            initialValue: _baseSelected?.toDateTime(fallback: _kReplayFallback),
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: (result) {
              setState(() => _baseSelected = result);
              Navigator.of(context).pop();
            },
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
            mode: DateTimePickerMode.month,
            title: '请选择年月',
            initialValue:
                _yearMonthSelected?.toDateTime(fallback: _kReplayFallback),
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: (result) {
              setState(() => _yearMonthSelected = result);
              Navigator.of(context).pop();
            },
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
            mode: DateTimePickerMode.combined(timeMode: TimeMode.minute),
            title: '请选择时分',
            initialValue: _timeSelected?.toDateTime(fallback: _kReplayFallback),
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: (result) {
              setState(() => _timeSelected = result);
              Navigator.of(context).pop();
            },
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
            mode: DateTimePickerMode.combined(
              dateMode: DateMode.date,
              timeMode: TimeMode.minute,
            ),
            title: '2024 ~ 2026',
            start: DateTime(2024, 1, 1),
            end: DateTime(2026, 12, 31, 23, 59),
            initialValue:
                _rangeSelected?.toDateTime(fallback: _kReplayFallback) ??
                    DateTime(2025, 6, 15, 12, 30),
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: (result) {
              setState(() => _rangeSelected = result);
              Navigator.of(context).pop();
            },
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
            mode: DateTimePickerMode.ymd,
            showWeek: true,
            title: '请选择日期',
            initialValue: _weekSelected?.toDateTime(fallback: _kReplayFallback),
            onCancel: () => Navigator.of(context).pop(),
            onConfirm: (result) {
              setState(() => _weekSelected = result);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  /// 星期信息从 [TDateTimePickerValue.toDateTime] 派生（weekday 1=周一…7=周日）。
  String _formatWeekResult(BuildContext context, TDateTimePickerValue? v) {
    if (v == null) {
      return '请选择';
    }
    final base = _formatResult(v);
    final dt = v.toDateTime(fallback: _kReplayFallback);
    final week = _weekdayLabel(context, dt.weekday);
    return '$base $week';
  }

  String _weekdayLabel(BuildContext context, int weekday) {
    final r = context.resource;
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

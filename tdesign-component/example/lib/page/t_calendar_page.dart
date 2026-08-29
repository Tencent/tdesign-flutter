import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

/// TCalendar 演示。
class TCalendarPage extends StatefulWidget {
  const TCalendarPage({super.key});

  @override
  State<TCalendarPage> createState() => _TCalendarPageState();
}

class _TCalendarPageState extends State<TCalendarPage> {
  List<DateTime> _singleValue = [DateTime.now()];
  List<DateTime> _multipleValue = [];
  List<DateTime> _rangeValue = [];
  List<DateTime> _popupSingleValue = [];
  List<DateTime> _popupMultipleValue = [];
  List<DateTime> _popupRangeValue = [];
  DateTime _anchorDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于单选、多选或区间选择日期。',
      exampleCodeGroup: 'calendar',
      children: [
        ExampleModule(
          title: '单选模式',
          children: [ExampleItem(builder: _buildSingle)],
        ),
        ExampleModule(
          title: '多选模式',
          children: [ExampleItem(builder: _buildMultiple)],
        ),
        ExampleModule(
          title: '区间模式',
          children: [ExampleItem(builder: _buildRange)],
        ),
        ExampleModule(
          title: 'Popup 组合',
          children: [ExampleItem(builder: _buildPopup)],
        ),
        ExampleModule(
          title: '滚动控制',
          children: [ExampleItem(builder: _buildAnchor)],
        ),
      ],
    );
  }

  @ExampleCode(group: 'calendar')
  Widget _buildSingle(BuildContext context) {
    return TCalendar(
      value: _singleValue,
      onChanged: (value) => setState(() => _singleValue = value),
    );
  }

  @ExampleCode(group: 'calendar')
  Widget _buildMultiple(BuildContext context) {
    return TCalendar(
      value: _multipleValue,
      variant: TCalendarVariant.multiple,
      onChanged: (value) => setState(() => _multipleValue = value),
    );
  }

  @ExampleCode(group: 'calendar')
  Widget _buildRange(BuildContext context) {
    return TCalendar(
      value: _rangeValue,
      variant: TCalendarVariant.range,
      onChanged: (value) => setState(() => _rangeValue = value),
    );
  }

  @ExampleCode(group: 'calendar')
  Widget _buildPopup(BuildContext context) {
    String formatDate(DateTime date) {
      final month = date.month.toString().padLeft(2, '0');
      final day = date.day.toString().padLeft(2, '0');
      return '${date.year}-$month-$day';
    }

    String displayValue(TCalendarVariant variant, List<DateTime> value) {
      if (value.isEmpty) {
        return '请选择';
      }
      switch (variant) {
        case TCalendarVariant.single:
          return formatDate(value.first);
        case TCalendarVariant.multiple:
          return '已选 ${value.length} 天';
        case TCalendarVariant.range:
          if (value.length < 2) {
            return '${formatDate(value.first)} 起';
          }
          return '${formatDate(value.first)} 至 ${formatDate(value.last)}';
      }
    }

    void showCalendar({
      required String title,
      required TCalendarVariant variant,
      required List<DateTime> value,
      required ValueChanged<List<DateTime>> onConfirm,
    }) {
      var draft = List<DateTime>.of(value);
      TPopup.show(
        context,
        options: TPopupOptions.bottom(
          height: MediaQuery.sizeOf(context).height * 0.72,
          headerBuilder: (_, close) => TPopupHeader(
            cancelButton: TextButton(
              onPressed: close,
              child: const TText('取消'),
            ),
            title: TText(title),
            confirmButton: TextButton(
              onPressed: () {
                if (mounted) {
                  onConfirm(List<DateTime>.of(draft));
                }
                close();
              },
              child: const TText('确定'),
            ),
          ),
          child: StatefulBuilder(
            builder: (context, setPopupState) => TCalendar(
              value: draft,
              variant: variant,
              anchorDate: draft.isEmpty ? DateTime.now() : draft.first,
              onChanged: (value) {
                setPopupState(() => draft = List<DateTime>.of(value));
              },
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        TCell(
          title: const TText('单选日期'),
          note: TText(displayValue(TCalendarVariant.single, _popupSingleValue)),
          arrow: true,
          onTap: () => showCalendar(
            title: '选择日期',
            variant: TCalendarVariant.single,
            value: _popupSingleValue,
            onConfirm: (value) => setState(() => _popupSingleValue = value),
          ),
        ),
        TCell(
          title: const TText('多选日期'),
          note: TText(
            displayValue(TCalendarVariant.multiple, _popupMultipleValue),
          ),
          arrow: true,
          onTap: () => showCalendar(
            title: '选择多个日期',
            variant: TCalendarVariant.multiple,
            value: _popupMultipleValue,
            onConfirm: (value) => setState(() => _popupMultipleValue = value),
          ),
        ),
        TCell(
          title: const TText('日期区间'),
          note: TText(displayValue(TCalendarVariant.range, _popupRangeValue)),
          arrow: true,
          onTap: () => showCalendar(
            title: '选择日期区间',
            variant: TCalendarVariant.range,
            value: _popupRangeValue,
            onConfirm: (value) => setState(() => _popupRangeValue = value),
          ),
        ),
      ],
    );
  }

  @ExampleCode(group: 'calendar')
  Widget _buildAnchor(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              tooltip: '上个月',
              icon: const Icon(Icons.chevron_left),
              onPressed: () => setState(() {
                _anchorDate = DateTime(_anchorDate.year, _anchorDate.month - 1);
              }),
            ),
            Expanded(
              child: TText(
                '${_anchorDate.year}-${_anchorDate.month.toString().padLeft(2, '0')}',
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              tooltip: '下个月',
              icon: const Icon(Icons.chevron_right),
              onPressed: () => setState(() {
                _anchorDate = DateTime(_anchorDate.year, _anchorDate.month + 1);
              }),
            ),
          ],
        ),
        TCalendar(
          value: _singleValue,
          anchorDate: _anchorDate,
          animateTo: true,
          onChanged: (value) => setState(() => _singleValue = value),
          onMonthChanged: (month) => _anchorDate = month,
        ),
      ],
    );
  }
}

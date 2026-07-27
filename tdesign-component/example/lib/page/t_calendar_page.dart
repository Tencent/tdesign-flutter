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
  DateTime _anchorDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于单选、多选或区间选择日期。',
      exampleCodeGroup: 'calendar',
      children: [
        ExampleModule(title: '选择模式', children: [
          ExampleItem(desc: '单选', builder: _buildSingle),
          ExampleItem(desc: '多选', builder: _buildMultiple),
          ExampleItem(desc: '区间', builder: _buildRange),
          ExampleItem(desc: '滚动锚点', builder: _buildAnchor),
        ]),
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
  Widget _buildAnchor(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              tooltip: '上个月',
              icon: const Icon(Icons.chevron_left),
              onPressed: () => setState(() {
                _anchorDate = DateTime(
                  _anchorDate.year,
                  _anchorDate.month - 1,
                );
              }),
            ),
            Expanded(
              child: Text(
                '${_anchorDate.year}-${_anchorDate.month.toString().padLeft(2, '0')}',
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              tooltip: '下个月',
              icon: const Icon(Icons.chevron_right),
              onPressed: () => setState(() {
                _anchorDate = DateTime(
                  _anchorDate.year,
                  _anchorDate.month + 1,
                );
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

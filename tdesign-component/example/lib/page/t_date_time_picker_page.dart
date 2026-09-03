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
  TDateTimePickerValue _date = const TDateTimePickerValue(
    year: 2021,
    month: 12,
    day: 23,
  );
  TDateTimePickerValue _month = const TDateTimePickerValue(
    year: 2021,
    month: 9,
  );
  TDateTimePickerValue _second = const TDateTimePickerValue(
    hour: 10,
    minute: 0,
    second: 0,
  );
  TDateTimePickerValue _minute = const TDateTimePickerValue(
    hour: 23,
    minute: 59,
  );
  TDateTimePickerValue _dateTime = const TDateTimePickerValue(
    year: 2021,
    month: 12,
    day: 23,
    hour: 10,
    minute: 0,
    second: 0,
  );
  TDateTimePickerValue _steps = const TDateTimePickerValue(
    hour: 10,
    minute: 0,
    second: 0,
  );
  TDateTimePickerValue _inline = const TDateTimePickerValue(
    year: 2021,
    month: 12,
    day: 23,
  );

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '用于选择一个时间点或者一个时间段。',
      exampleCodeGroup: 'date-time-picker',
      compactDemo: true,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '年月日选择器', builder: _buildDate),
            ExampleItem(desc: '年月选择器', builder: _buildMonth),
            ExampleItem(builder: _buildTime),
            ExampleItem(desc: '年月日时分秒选择器', builder: _buildDateTime),
          ],
        ),
        ExampleModule(
          title: '组件用法',
          children: [
            ExampleItem(desc: '调整步数', builder: _buildSteps),
            ExampleItem(desc: '不使用 Popup', builder: _buildInline),
          ],
        ),
      ],
    );
  }

  String _format(TDateTimePickerValue value) {
    String two(int? part) => part?.toString().padLeft(2, '0') ?? '';
    final date = [
      if (value.year != null) '${value.year}',
      if (value.month != null) two(value.month),
      if (value.day != null) two(value.day),
    ].join('-');
    final time = [
      if (value.hour != null) two(value.hour),
      if (value.minute != null) two(value.minute),
      if (value.second != null) two(value.second),
    ].join(':');
    return [if (date.isNotEmpty) date, if (time.isNotEmpty) time].join(' ');
  }

  void _showPicker({
    required String id,
    required String title,
    required TDateTimePickerValue value,
    required DateTimePickerMode mode,
    required ValueChanged<TDateTimePickerValue> onConfirm,
    DateTimePickerSteps? steps,
    bool showWeek = false,
  }) {
    var draft = value;
    TPopup.show(
      context,
      options: TPopupOptions.bottom(
        headerBuilder: (_, close) => TPopupHeader(
          cancelButton: TToolbarPressable(
            onTap: close,
            child: const TText('取消'),
          ),
          title: TText(title),
          confirmButton: TToolbarPressable(
            onTap: () {
              onConfirm(draft);
              close();
            },
            child: const TText('确定'),
          ),
        ),
        child: Material(
          color: context.tTheme.bgColorContainer,
          child: StatefulBuilder(
            builder: (_, setPopupState) => TDateTimePicker(
              key: ValueKey('date-time-picker-$id-panel'),
              value: draft,
              mode: mode,
              steps: steps,
              showWeek: showWeek,
              onChanged: (next) => setPopupState(() => draft = next),
            ),
          ),
        ),
      ),
    );
  }

  Widget _cell({
    required String id,
    required String title,
    required TDateTimePickerValue value,
    required DateTimePickerMode mode,
    required ValueChanged<TDateTimePickerValue> onConfirm,
    DateTimePickerSteps? steps,
    bool showWeek = false,
  }) => TCellGroup(
    cells: [
      TCell(
        key: ValueKey('date-time-picker-$id-trigger'),
        title: TText(title),
        note: TText(_format(value)),
        arrow: true,
        onTap: () => _showPicker(
          id: id,
          title: title,
          value: value,
          mode: mode,
          steps: steps,
          showWeek: showWeek,
          onConfirm: onConfirm,
        ),
      ),
    ],
  );

  @ExampleCode(group: 'date-time-picker')
  Widget _buildDate(BuildContext context) => _cell(
    id: 'date',
    title: '选择日期',
    value: _date,
    mode: DateTimePickerMode(dateMode: DateMode.date),
    showWeek: true,
    onConfirm: (value) => setState(() => _date = value),
  );

  @ExampleCode(group: 'date-time-picker')
  Widget _buildMonth(BuildContext context) => _cell(
    id: 'month',
    title: '选择日期',
    value: _month,
    mode: DateTimePickerMode(dateMode: DateMode.month),
    onConfirm: (value) => setState(() => _month = value),
  );

  @ExampleCode(group: 'date-time-picker')
  Widget _buildTime(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.all(context.tTheme.spacer16),
        child: const TText('时分秒选择器'),
      ),
      _cell(
        id: 'second',
        title: '选择时间',
        value: _second,
        mode: DateTimePickerMode(timeMode: TimeMode.second),
        onConfirm: (value) => setState(() => _second = value),
      ),
      Padding(
        padding: EdgeInsets.all(context.tTheme.spacer16),
        child: const TText('时分选择器'),
      ),
      _cell(
        id: 'minute',
        title: '选择时间',
        value: _minute,
        mode: DateTimePickerMode(timeMode: TimeMode.minute),
        onConfirm: (value) => setState(() => _minute = value),
      ),
    ],
  );

  @ExampleCode(group: 'date-time-picker')
  Widget _buildDateTime(BuildContext context) => _cell(
    id: 'date-time',
    title: '选择日期时间',
    value: _dateTime,
    mode: DateTimePickerMode(
      dateMode: DateMode.date,
      timeMode: TimeMode.second,
    ),
    onConfirm: (value) => setState(() => _dateTime = value),
  );

  @ExampleCode(group: 'date-time-picker')
  Widget _buildSteps(BuildContext context) => _cell(
    id: 'steps',
    title: '选择时间',
    value: _steps,
    mode: DateTimePickerMode(timeMode: TimeMode.second),
    steps: const DateTimePickerSteps(minute: 5),
    onConfirm: (value) => setState(() => _steps = value),
  );

  @ExampleCode(group: 'date-time-picker')
  Widget _buildInline(BuildContext context) => Material(
    color: context.tTheme.bgColorContainer,
    child: TDateTimePicker(
      key: const ValueKey('date-time-picker-inline-panel'),
      value: _inline,
      mode: DateTimePickerMode(dateMode: DateMode.date),
      start: const TDateTimePickerValue(year: 2000, month: 1, day: 1),
      end: const TDateTimePickerValue(year: 2030, month: 9, day: 9),
      onChanged: (value) => setState(() => _inline = value),
    ),
  );
}

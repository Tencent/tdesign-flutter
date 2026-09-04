import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';

class TDateTimePickerPage extends StatefulWidget {
  const TDateTimePickerPage({super.key});

  @override
  State<TDateTimePickerPage> createState() => _TDateTimePickerPageState();
}

class _TDateTimePickerPageState extends State<TDateTimePickerPage> {
  static const _date = TDateTimePickerValue(year: 2022, month: 8, day: 10);
  final _values = <String, TDateTimePickerValue>{
    'date': _date,
    'month': const TDateTimePickerValue(year: 2022, month: 8),
    'month-day': const TDateTimePickerValue(month: 8, day: 10),
    'second': const TDateTimePickerValue(hour: 12, minute: 50, second: 23),
    'minute': const TDateTimePickerValue(hour: 12, minute: 50),
    'date-time': const TDateTimePickerValue(
      year: 2022,
      month: 8,
      day: 10,
      hour: 12,
      minute: 50,
      second: 23,
    ),
    'week': _date,
    'title': _date,
    'without-title': _date,
  };

  @override
  Widget build(BuildContext context) => ExamplePage(
    title: tTitle(),
    desc: '用于选择一个时间点或者一个时间段。',
    exampleCodeGroup: 'date-time-picker',
    compactDemo: true,
    // Figma Demo 页面底色；深色模式继续使用当前主题。
    backgroundColor: Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFF6F6F6)
        : context.tTheme.bgColorPage,
    showTestModule: false,
    children: [
      ExampleModule(
        title: '组件类型',
        children: [
          ExampleItem(desc: '年月日选择器', builder: _buildDate),
          ExampleItem(desc: '年月选择器', builder: _buildMonth),
          ExampleItem(desc: '月日选择器', builder: _buildMonthDay),
          ExampleItem(desc: '时分秒选择器', builder: _buildSecond),
          ExampleItem(desc: '时分选择器', builder: _buildMinute),
          ExampleItem(desc: '年月日时分秒选择器', builder: _buildDateTime),
          ExampleItem(desc: '年月日带星期选择器', builder: _buildWeek),
        ],
      ),
      ExampleModule(
        title: '组件样式',
        children: [
          ExampleItem(desc: '是否带标题', builder: _buildTitle),
          ExampleItem(builder: _buildWithoutTitle),
        ],
      ),
    ],
  );

  String _format(TDateTimePickerValue value, {bool showWeek = false}) {
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
    final result = [
      if (date.isNotEmpty) date,
      if (time.isNotEmpty) time,
    ].join(' ');
    if (!showWeek) {
      return result;
    }
    final weekday = DateTime(value.year!, value.month!, value.day!).weekday;
    return '$result 周${['一', '二', '三', '四', '五', '六', '日'][weekday - 1]}';
  }

  void _showPicker(
    String id,
    DateTimePickerMode mode, {
    bool showWeek = false,
    bool showTitle = true,
  }) {
    var draft = _values[id]!;
    TPopup.show(
      context,
      options: TPopupOptions.bottom(
        height:
            (Theme.of(context).extension<TPickerThemeData>()?.height ?? 200) +
            TPopupHeader.headerHeight,
        headerBuilder: (_, close) => TPopupHeader(
          cancelButton: TToolbarPressable(
            onTap: close,
            child: TText(
              '取消',
              font: context.tTheme.fontBodyLarge,
              textColor: context.tTheme.textColorSecondary,
            ),
          ),
          title: showTitle
              ? TText('选择时间', font: context.tTheme.fontTitleLarge)
              : null,
          confirmButton: TToolbarPressable(
            onTap: () {
              setState(() => _values[id] = draft);
              close();
            },
            child: TText(
              '确定',
              font: context.tTheme.fontBodyLarge,
              textColor: context.tTheme.brandNormalColor,
            ),
          ),
        ),
        child: StatefulBuilder(
          builder: (_, setPopupState) => TDateTimePicker(
            key: ValueKey('date-time-picker-$id-panel'),
            value: draft,
            mode: mode,
            showWeek: showWeek,
            // 六列并排时年份省略单位，避免 375px 窄屏省略年份数字。
            renderLabel: id == 'date-time'
                ? (column, value) =>
                      column == DateTimeColumn.year ? '$value' : null
                : null,
            onChanged: (next) => setPopupState(() => draft = next),
          ),
        ),
      ),
    );
  }

  Widget _cell(
    String id,
    DateTimePickerMode mode, {
    String title = '选择时间',
    bool showWeek = false,
    bool showTitle = true,
  }) => TCellGroup(
    cells: [
      TCell(
        key: ValueKey('date-time-picker-$id-trigger'),
        title: TText(title),
        note: TText(_format(_values[id]!, showWeek: showWeek)),
        arrow: true,
        onTap: () =>
            _showPicker(id, mode, showWeek: showWeek, showTitle: showTitle),
      ),
    ],
  );

  @ExampleCode(group: 'date-time-picker')
  Widget _buildDate(BuildContext context) =>
      _cell('date', DateTimePickerMode(dateMode: DateMode.date));

  @ExampleCode(group: 'date-time-picker')
  Widget _buildMonth(BuildContext context) =>
      _cell('month', DateTimePickerMode(dateMode: DateMode.month));

  @ExampleCode(group: 'date-time-picker')
  Widget _buildMonthDay(BuildContext context) =>
      _cell('month-day', DateTimePickerMode(dateMode: DateMode.monthDay));

  @ExampleCode(group: 'date-time-picker')
  Widget _buildSecond(BuildContext context) =>
      _cell('second', DateTimePickerMode(timeMode: TimeMode.second));

  @ExampleCode(group: 'date-time-picker')
  Widget _buildMinute(BuildContext context) =>
      _cell('minute', DateTimePickerMode(timeMode: TimeMode.minute));

  @ExampleCode(group: 'date-time-picker')
  Widget _buildDateTime(BuildContext context) => _cell(
    'date-time',
    DateTimePickerMode(dateMode: DateMode.date, timeMode: TimeMode.second),
  );

  @ExampleCode(group: 'date-time-picker')
  Widget _buildWeek(BuildContext context) => _cell(
    'week',
    DateTimePickerMode(dateMode: DateMode.date),
    showWeek: true,
  );

  @ExampleCode(group: 'date-time-picker')
  Widget _buildTitle(BuildContext context) => _cell(
    'title',
    DateTimePickerMode(dateMode: DateMode.date),
    title: '带标题时间选择器',
  );

  @ExampleCode(group: 'date-time-picker')
  Widget _buildWithoutTitle(BuildContext context) => _cell(
    'without-title',
    DateTimePickerMode(dateMode: DateMode.date),
    title: '无标题时间选择器',
    showTitle: false,
  );
}

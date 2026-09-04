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
          ExampleItem(desc: '年月日选择器', builder: _buildDate, methodName: '_cell'),
          ExampleItem(desc: '年月选择器', builder: _buildMonth, methodName: '_cell'),
          ExampleItem(
            desc: '月日选择器',
            builder: _buildMonthDay,
            methodName: '_cell',
          ),
          ExampleItem(
            desc: '时分秒选择器',
            builder: _buildSecond,
            methodName: '_cell',
          ),
          ExampleItem(
            desc: '时分选择器',
            builder: _buildMinute,
            methodName: '_cell',
          ),
          ExampleItem(
            desc: '年月日时分秒选择器',
            builder: _buildDateTime,
            methodName: '_cell',
          ),
          ExampleItem(
            desc: '年月日带星期选择器',
            builder: _buildWeek,
            methodName: '_cell',
          ),
        ],
      ),
      ExampleModule(
        title: '组件样式',
        children: [
          ExampleItem(desc: '是否带标题', builder: _buildTitle, methodName: '_cell'),
          ExampleItem(builder: _buildWithoutTitle, methodName: '_cell'),
        ],
      ),
    ],
  );

  /// 核心组合片段：调用方使用 [TCell] 作为触发器，用 [TPopup] 组合标题栏
  /// 与纯滚轮 [TDateTimePicker]。滚动只更新草稿，确认时再通过 [onConfirm]
  /// 写回调用方状态，取消不会提交。
  ///
  /// 核心片段省略应用壳；导入 flutter/material.dart 和
  /// package:tdesign_flutter/tdesign_flutter.dart，在 StatefulWidget 的 State
  /// 中放置本方法。父级持有已确认的值，例如：
  /// ```dart
  /// var selected = const TDateTimePickerValue(year: 2022, month: 8, day: 10);
  /// // 在 build 中调用；取消保持 selected，确认后 setState 更新触发器文案。
  /// _cell(context, 'date', DateTimePickerMode(dateMode: DateMode.date),
  ///   value: selected, onConfirm: (next) => setState(() => selected = next));
  /// ```
  ///
  /// 九个入口使用同一组合，按下列实际配置提供 id、mode 和初始 value：
  /// - date：dateMode: DateMode.date；year: 2022, month: 8, day: 10。
  /// - month：dateMode: DateMode.month；year: 2022, month: 8。
  /// - month-day：dateMode: DateMode.monthDay；month: 8, day: 10，不传 year。
  /// - second：timeMode: TimeMode.second；hour: 12, minute: 50, second: 23。
  /// - minute：timeMode: TimeMode.minute；hour: 12, minute: 50。
  /// - date-time：dateMode: DateMode.date, timeMode: TimeMode.second；
  ///   year: 2022, month: 8, day: 10, hour: 12, minute: 50, second: 23。
  /// - week：同 date，showWeek: true。
  /// - title：同 date，title: '带标题时间选择器'。
  /// - without-title：同 date，title: '无标题时间选择器', showTitle: false。
  /// value 均构造为 TDateTimePickerValue；每个入口由父级单独持有选择值。
  /// title 是触发器文案；弹层标题为“选择时间”，showTitle 控制其显示。
  /// 不传的 showWeek 为 false、showTitle 为 true，title 为“选择时间”。
  @ExampleCode(group: 'date-time-picker')
  Widget _cell(
    BuildContext context,
    String id,
    DateTimePickerMode mode, {
    required TDateTimePickerValue value,
    required ValueChanged<TDateTimePickerValue> onConfirm,
    String title = '选择时间',
    bool showWeek = false,
    bool showTitle = true,
  }) {
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

    void showPicker() {
      var draft = value;
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
                onConfirm(draft);
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

    return TCellGroup(
      cells: [
        TCell(
          key: ValueKey('date-time-picker-$id-trigger'),
          title: TText(title),
          note: TText(_format(value, showWeek: showWeek)),
          arrow: true,
          onTap: showPicker,
        ),
      ],
    );
  }

  Widget _buildDate(BuildContext context) => _cell(
    context,
    'date',
    DateTimePickerMode(dateMode: DateMode.date),
    value: _values['date']!,
    onConfirm: (value) => setState(() => _values['date'] = value),
  );

  Widget _buildMonth(BuildContext context) => _cell(
    context,
    'month',
    DateTimePickerMode(dateMode: DateMode.month),
    value: _values['month']!,
    onConfirm: (value) => setState(() => _values['month'] = value),
  );

  Widget _buildMonthDay(BuildContext context) => _cell(
    context,
    'month-day',
    DateTimePickerMode(dateMode: DateMode.monthDay),
    value: _values['month-day']!,
    onConfirm: (value) => setState(() => _values['month-day'] = value),
  );

  Widget _buildSecond(BuildContext context) => _cell(
    context,
    'second',
    DateTimePickerMode(timeMode: TimeMode.second),
    value: _values['second']!,
    onConfirm: (value) => setState(() => _values['second'] = value),
  );

  Widget _buildMinute(BuildContext context) => _cell(
    context,
    'minute',
    DateTimePickerMode(timeMode: TimeMode.minute),
    value: _values['minute']!,
    onConfirm: (value) => setState(() => _values['minute'] = value),
  );

  Widget _buildDateTime(BuildContext context) => _cell(
    context,
    'date-time',
    DateTimePickerMode(dateMode: DateMode.date, timeMode: TimeMode.second),
    value: _values['date-time']!,
    onConfirm: (value) => setState(() => _values['date-time'] = value),
  );

  Widget _buildWeek(BuildContext context) => _cell(
    context,
    'week',
    DateTimePickerMode(dateMode: DateMode.date),
    value: _values['week']!,
    onConfirm: (value) => setState(() => _values['week'] = value),
    showWeek: true,
  );

  Widget _buildTitle(BuildContext context) => _cell(
    context,
    'title',
    DateTimePickerMode(dateMode: DateMode.date),
    value: _values['title']!,
    onConfirm: (value) => setState(() => _values['title'] = value),
    title: '带标题时间选择器',
  );

  Widget _buildWithoutTitle(BuildContext context) => _cell(
    context,
    'without-title',
    DateTimePickerMode(dateMode: DateMode.date),
    value: _values['without-title']!,
    onConfirm: (value) => setState(() => _values['without-title'] = value),
    title: '无标题时间选择器',
    showTitle: false,
  );
}

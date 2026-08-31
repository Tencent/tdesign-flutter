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
  List<DateTime> _singleValue = [];
  List<DateTime> _multipleValue = [];
  List<DateTime> _describedSingleValue = [DateTime(2022, 2, 18)];
  List<DateTime> _describedMultipleValue = [DateTime(2022, 2, 18)];
  List<DateTime> _switchValue = [DateTime(2022, 2, 27)];
  List<DateTime> _rangeValue = [DateTime(2024, 12, 5), DateTime(2024, 12, 10)];
  List<DateTime> _localizedValue = [DateTime(2022, 2, 18)];
  List<DateTime> _limitedValue = [DateTime(2022, 2, 18)];
  List<DateTime> _inlineValue = [DateTime.now()];

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '按照日历形式展示数据或日期的容器。',
      exampleCodeGroup: 'calendar',
      compactDemo: true,
      showTestModule: false,
      children: [
        ExampleModule(
          title: '组件类型',
          children: [
            ExampleItem(desc: '基础日历', builder: _buildSingle),
            ExampleItem(builder: _buildMultiple),
            ExampleItem(desc: '带单行描述的日历', builder: _buildDescribed),
            ExampleItem(desc: '带翻页功能的日历', builder: _buildSwitchMode),
            ExampleItem(desc: '可选择区间日期的日历', builder: _buildRange),
          ],
        ),
        ExampleModule(
          title: '组件样式',
          children: [
            ExampleItem(desc: '国际化', builder: _buildLocalized),
            ExampleItem(desc: '含不可选的日历', builder: _buildLimited),
            ExampleItem(desc: '不使用 Popup', builder: _buildInline),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  String _formatDates(List<DateTime> dates) => dates.map(_formatDate).join('、');

  void _showCalendar({
    required String title,
    required TCalendarVariant variant,
    required List<DateTime> value,
    required ValueChanged<List<DateTime>> onConfirm,
    DateTime? minDate,
    DateTime? maxDate,
    TCalendarSubtitleBuilder? subtitleBuilder,
    bool showMonthSwitcher = false,
    bool localized = false,
  }) {
    var draft = List<DateTime>.of(value);
    var anchor = draft.isEmpty ? minDate ?? DateTime.now() : draft.first;
    TPopup.show(
      context,
      options: TPopupOptions.bottom(
        height: MediaQuery.sizeOf(context).height * 0.78,
        headerBuilder: (_, close) => TPopupHeader(
          cancelButton: TToolbarPressable(
            onTap: close,
            child: TText(localized ? 'Cancel' : '取消'),
          ),
          title: TText(localized ? 'Select Date' : title),
          confirmButton: TToolbarPressable(
            onTap: () {
              onConfirm(List<DateTime>.of(draft));
              close();
            },
            child: TText(localized ? 'Confirm' : '确定'),
          ),
        ),
        child: StatefulBuilder(
          builder: (context, setPopupState) {
            final calendar = TCalendar(
              key: const ValueKey('calendar-popup-panel'),
              value: draft,
              variant: variant,
              minDate: minDate,
              maxDate: maxDate,
              anchorDate: anchor,
              animateTo: true,
              subtitleBuilder: subtitleBuilder,
              monthTitleBuilder: localized
                  ? (_, month) => TText(
                      '${_englishMonths[month.month - 1]} ${month.year}',
                    )
                  : null,
              onChanged: (next) => setPopupState(() => draft = next),
            );
            final body = showMonthSwitcher
                ? Column(
                    children: [
                      _CalendarMonthSwitcher(
                        month: anchor,
                        onChanged: (month) =>
                            setPopupState(() => anchor = month),
                      ),
                      Expanded(child: calendar),
                    ],
                  )
                : calendar;
            return localized
                ? Localizations.override(
                    context: context,
                    locale: const Locale('en'),
                    child: body,
                  )
                : body;
          },
        ),
      ),
    );
  }

  @ExampleCode(group: 'calendar')
  Widget _buildSingle(BuildContext context) => TCellGroup(
    cells: [
      TCell(
        key: const ValueKey('calendar-single-trigger'),
        title: const TText('单个选择日历'),
        note: TText(_formatDates(_singleValue)),
        arrow: true,
        onTap: () => _showCalendar(
          title: '选择日期',
          variant: TCalendarVariant.single,
          value: _singleValue,
          onConfirm: (value) => setState(() => _singleValue = value),
        ),
      ),
    ],
  );

  @ExampleCode(group: 'calendar')
  Widget _buildMultiple(BuildContext context) => TCellGroup(
    cells: [
      TCell(
        key: const ValueKey('calendar-multiple-trigger'),
        title: const TText('多个选择日历'),
        note: TText(_formatDates(_multipleValue)),
        arrow: true,
        onTap: () => _showCalendar(
          title: '选择多个日期',
          variant: TCalendarVariant.multiple,
          value: _multipleValue,
          onConfirm: (value) => setState(() => _multipleValue = value),
        ),
      ),
    ],
  );

  @ExampleCode(group: 'calendar')
  Widget _buildDescribed(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TCellGroup(
        cells: [
          TCell(
            key: const ValueKey('calendar-single-description-trigger'),
            title: const TText('带单行描述的日历'),
            note: TText(_formatDates(_describedSingleValue)),
            arrow: true,
            onTap: () => _showCalendar(
              title: '选择日期',
              variant: TCalendarVariant.single,
              value: _describedSingleValue,
              minDate: DateTime(2022, 2),
              maxDate: DateTime(2022, 3, 15),
              subtitleBuilder: (_, __) => const TText('¥60'),
              onConfirm: (value) =>
                  setState(() => _describedSingleValue = value),
            ),
          ),
        ],
      ),
      Padding(
        padding: EdgeInsets.all(context.tTheme.spacer16),
        child: const TText('带双行描述的日历'),
      ),
      TCellGroup(
        cells: [
          TCell(
            key: const ValueKey('calendar-double-description-trigger'),
            title: const TText('带双行描述的日历'),
            note: TText(_formatDates(_describedMultipleValue)),
            arrow: true,
            onTap: () => _showCalendar(
              title: '选择多个日期',
              variant: TCalendarVariant.multiple,
              value: _describedMultipleValue,
              minDate: DateTime(2022, 2),
              maxDate: DateTime(2022, 3, 15),
              subtitleBuilder: (_, model) {
                const holidays = {1: '初一', 2: '初二', 14: '情人节', 15: '元宵节'};
                return TText(holidays[model.date.day] ?? '¥60');
              },
              onConfirm: (value) =>
                  setState(() => _describedMultipleValue = value),
            ),
          ),
        ],
      ),
    ],
  );

  @ExampleCode(group: 'calendar')
  Widget _buildSwitchMode(BuildContext context) => TCellGroup(
    cells: [
      TCell(
        key: const ValueKey('calendar-switch-trigger'),
        title: const TText('带翻页功能的日历'),
        note: TText(_formatDates(_switchValue)),
        arrow: true,
        onTap: () => _showCalendar(
          title: '选择日期',
          variant: TCalendarVariant.single,
          value: _switchValue,
          minDate: DateTime(2022, 1, 10),
          maxDate: DateTime(2027, 11, 27),
          showMonthSwitcher: true,
          onConfirm: (value) => setState(() => _switchValue = value),
        ),
      ),
    ],
  );

  @ExampleCode(group: 'calendar')
  Widget _buildRange(BuildContext context) => InkWell(
    key: const ValueKey('calendar-range-trigger'),
    onTap: () => _showCalendar(
      title: '选择日期区间',
      variant: TCalendarVariant.range,
      value: _rangeValue,
      minDate: DateTime(2024, 11),
      maxDate: DateTime(2025),
      onConfirm: (value) => setState(() => _rangeValue = value),
    ),
    child: Container(
      color: context.tTheme.bgColorContainer,
      padding: EdgeInsets.all(context.tTheme.spacer16),
      child: Row(
        children: [
          Expanded(
            child: TText(
              _formatDate(_rangeValue.isEmpty ? null : _rangeValue.first),
              font: context.tTheme.fontTitleMedium,
            ),
          ),
          TIcon(TIcons.swap_right, color: context.tTheme.textColorPlaceholder),
          Expanded(
            child: TText(
              _formatDate(_rangeValue.length > 1 ? _rangeValue.last : null),
              textAlign: TextAlign.end,
              font: context.tTheme.fontTitleMedium,
            ),
          ),
        ],
      ),
    ),
  );

  @ExampleCode(group: 'calendar')
  Widget _buildLocalized(BuildContext context) => TCellGroup(
    cells: [
      TCell(
        key: const ValueKey('calendar-localized-trigger'),
        title: const TText('国际化'),
        note: TText(_formatDates(_localizedValue)),
        arrow: true,
        onTap: () => _showCalendar(
          title: 'Select Date',
          variant: TCalendarVariant.single,
          value: _localizedValue,
          minDate: DateTime(2022, 2),
          maxDate: DateTime(2022, 3, 15),
          localized: true,
          onConfirm: (value) => setState(() => _localizedValue = value),
        ),
      ),
    ],
  );

  @ExampleCode(group: 'calendar')
  Widget _buildLimited(BuildContext context) => TCellGroup(
    cells: [
      TCell(
        key: const ValueKey('calendar-limited-trigger'),
        title: const TText('含不可选的日历'),
        note: TText(_formatDates(_limitedValue)),
        arrow: true,
        onTap: () => _showCalendar(
          title: '选择日期',
          variant: TCalendarVariant.single,
          value: _limitedValue,
          minDate: DateTime(2022, 2, 18),
          maxDate: DateTime(2022, 3),
          onConfirm: (value) => setState(() => _limitedValue = value),
        ),
      ),
    ],
  );

  @ExampleCode(group: 'calendar')
  Widget _buildInline(BuildContext context) => Column(
    children: [
      Padding(
        padding: EdgeInsets.all(context.tTheme.spacer16),
        child: const TText('日历标题'),
      ),
      TCalendar(
        key: const ValueKey('calendar-inline-panel'),
        value: _inlineValue,
        variant: TCalendarVariant.multiple,
        minDate: DateTime.now(),
        maxDate: DateTime.now().add(const Duration(days: 180)),
        onChanged: (value) => setState(() => _inlineValue = value),
      ),
    ],
  );
}

class _CalendarMonthSwitcher extends StatelessWidget {
  const _CalendarMonthSwitcher({required this.month, required this.onChanged});

  final DateTime month;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: '上个月',
          onPressed: () => onChanged(DateTime(month.year, month.month - 1)),
          icon: const Icon(Icons.chevron_left),
        ),
        Expanded(
          child: TText(
            '${month.year} 年 ${month.month} 月',
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          tooltip: '下个月',
          onPressed: () => onChanged(DateTime(month.year, month.month + 1)),
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

const _englishMonths = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../annotation/example_code.dart';
import '../base/example_widget.dart';
import '../l10n/app_localizations.dart';

/// TCalendar 演示。
class TCalendarPage extends StatefulWidget {
  const TCalendarPage({super.key, this.referenceDate});

  /// 内嵌示例的参考日期，默认使用设计稿中的 2023-03-10。
  final DateTime? referenceDate;

  @override
  State<TCalendarPage> createState() => _TCalendarPageState();
}

class _TCalendarPageState extends State<TCalendarPage> {
  List<DateTime> _singleValue = [DateTime(2022, 2, 18)];
  List<DateTime> _multipleValue = [
    DateTime(2022, 2, 18),
    DateTime(2022, 2, 20),
    DateTime(2022, 2, 22),
  ];
  List<DateTime> _describedSingleValue = [DateTime(2022, 2, 18)];
  List<DateTime> _describedMultipleValue = [DateTime(2022, 2, 18)];
  List<DateTime> _switchValue = [DateTime(2022, 2, 18)];
  List<DateTime> _rangeValue = [DateTime(2022, 2, 19), DateTime(2022, 2, 21)];
  List<DateTime> _localizedValue = [DateTime(2022, 2, 18)];
  List<DateTime> _limitedValue = [DateTime(2022, 2, 18)];
  late final DateTime _referenceDate;
  late List<DateTime> _inlineValue;

  @override
  void initState() {
    super.initState();
    final now = widget.referenceDate ?? DateTime(2023, 3, 10);
    _referenceDate = DateTime(now.year, now.month, now.day);
    _inlineValue = [_referenceDate];
  }

  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      title: tTitle(),
      desc: '按照日历形式展示数据或日期的容器。',
      exampleCodeGroup: 'calendar',
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
            ExampleItem(desc: '基础日历', builder: _buildSingle),
            ExampleItem(builder: _buildMultiple),
            ExampleItem(desc: '带单行描述的日历', builder: _buildDescribed),
            ExampleItem(desc: '带双行描述的日历', builder: _buildDoubleDescribed),
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

  Widget _dateNote(List<DateTime> dates) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 170),
    child: TText(
      _formatDates(dates),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ),
  );

  void _showCalendar({
    required TCalendarVariant variant,
    required List<DateTime> value,
    required ValueChanged<List<DateTime>> onConfirm,
    DateTime? minDate,
    DateTime? maxDate,
    TCalendarSubtitleBuilder? subtitleBuilder,
    TCalendarCellBuilder? cellBuilder,
    bool showMonthSwitcher = false,
    bool localized = false,
  }) {
    var draft = List<DateTime>.of(value);
    final start = minDate ?? DateTime(2022, 2);
    final end = maxDate ?? DateTime(2022, 8);
    var anchor = draft.isEmpty ? start : draft.first;
    late TPopupHandle popup;
    popup = TPopup.show(
      context,
      options: TPopupOptions.bottom(
        height: MediaQuery.sizeOf(context).height * 0.85,
        headerBuilder: (_, close) => SizedBox(
          height: TPopupHeader.headerHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              TText(
                localized ? 'Select Date' : '请选择日期',
                font: context.tTheme.fontTitleLarge,
              ),
              Positioned(
                right: context.tTheme.spacer8,
                child: IconButton(
                  tooltip: localized ? 'Close' : '关闭',
                  onPressed: close,
                  icon: const TIcon(TIcons.close),
                ),
              ),
            ],
          ),
        ),
        child: StatefulBuilder(
          builder: (context, setPopupState) {
            final first = DateTime(anchor.year, anchor.month);
            final last = DateTime(anchor.year, anchor.month + 1, 0);
            final calendar = TCalendar(
              key: const ValueKey('calendar-popup-panel'),
              value: draft,
              variant: variant,
              minDate: showMonthSwitcher && first.isAfter(start)
                  ? first
                  : start,
              maxDate: showMonthSwitcher && last.isBefore(end) ? last : end,
              anchorDate: anchor,
              subtitleBuilder: subtitleBuilder,
              cellBuilder: cellBuilder,
              monthTitleBuilder: showMonthSwitcher
                  ? (_, __) => const SizedBox.shrink()
                  : localized
                  ? (_, month) => TText(
                      '${_englishMonths[month.month - 1]} ${month.year}',
                    )
                  : null,
              onChanged: (next) => setPopupState(() => draft = next),
            );
            final body = Material(
              color: context.tTheme.bgColorContainer,
              child: Column(
                children: [
                  if (showMonthSwitcher)
                    _CalendarMonthSwitcher(
                      month: anchor,
                      minDate: start,
                      maxDate: end,
                      onChanged: (month) => setPopupState(() => anchor = month),
                    ),
                  Expanded(
                    child: showMonthSwitcher
                        ? Theme(
                            data: Theme.of(context).mergeExtension(
                              (Theme.of(
                                        context,
                                      ).extension<TCalendarThemeData>() ??
                                      const TCalendarThemeData())
                                  .copyWith(monthTitleHeight: 0),
                            ),
                            child: calendar,
                          )
                        : calendar,
                  ),
                  Padding(
                    padding: EdgeInsets.all(context.tTheme.spacer16),
                    child: SizedBox(
                      width: double.infinity,
                      child: TButton(
                        colorScheme: TButtonColorScheme.primary,
                        size: TButtonSize.large,
                        onPressed:
                            draft.isEmpty ||
                                (variant == TCalendarVariant.range &&
                                    draft.length != 2)
                            ? null
                            : () {
                                onConfirm(List<DateTime>.of(draft));
                                popup.close();
                              },
                        child: Text(localized ? 'Confirm' : '确定'),
                      ),
                    ),
                  ),
                ],
              ),
            );
            return localized
                ? Localizations.override(
                    context: context,
                    locale: const Locale('en'),
                    delegates: AppLocalizations.localizationsDelegates,
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
        note: _dateNote(_singleValue),
        arrow: true,
        onTap: () => _showCalendar(
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
        note: _dateNote(_multipleValue),
        arrow: true,
        onTap: () => _showCalendar(
          variant: TCalendarVariant.multiple,
          value: _multipleValue,
          onConfirm: (value) => setState(() => _multipleValue = value),
        ),
      ),
    ],
  );

  @ExampleCode(group: 'calendar')
  Widget _buildDescribed(BuildContext context) => TCellGroup(
    cells: [
      TCell(
        key: const ValueKey('calendar-single-description-trigger'),
        title: const TText('带单行描述的日历'),
        note: _dateNote(_describedSingleValue),
        arrow: true,
        onTap: () => _showCalendar(
          variant: TCalendarVariant.single,
          value: _describedSingleValue,
          minDate: DateTime(2022, 2),
          maxDate: DateTime(2022, 3, 15),
          subtitleBuilder: (_, __) => const Text('¥60'),
          onConfirm: (value) => setState(() => _describedSingleValue = value),
        ),
      ),
    ],
  );

  @ExampleCode(group: 'calendar')
  Widget _buildDoubleDescribed(BuildContext context) => TCellGroup(
    cells: [
      TCell(
        key: const ValueKey('calendar-double-description-trigger'),
        title: const TText('带双行描述的日历'),
        note: _dateNote(_describedMultipleValue),
        arrow: true,
        onTap: () => _showCalendar(
          variant: TCalendarVariant.multiple,
          value: _describedMultipleValue,
          minDate: DateTime(2022, 2),
          maxDate: DateTime(2022, 3, 15),
          cellBuilder: (context, model) {
            const holidays = {1: '初一', 2: '初二', 14: '情人节', 15: '元宵节'};
            final selected = model.selectType == DateSelectType.selected;
            final color = model.selectType == DateSelectType.disabled
                ? context.tTheme.textDisabledColor
                : selected
                ? context.tTheme.textColorAnti
                : context.tTheme.textColorSecondary;
            return Stack(
              alignment: Alignment.center,
              children: [
                TText(
                  '${model.date.day}',
                  font: context.tTheme.fontTitleMedium,
                  textColor: color,
                ),
                Positioned(
                  top: context.tTheme.spacer4,
                  child: TText(
                    holidays[model.date.day] ?? '',
                    font: context.tTheme.fontBodyExtraSmall,
                    textColor: color,
                  ),
                ),
                Positioned(
                  bottom: context.tTheme.spacer4,
                  child: TText(
                    '¥60',
                    font: context.tTheme.fontBodyExtraSmall,
                    textColor: color,
                  ),
                ),
              ],
            );
          },
          onConfirm: (value) => setState(() => _describedMultipleValue = value),
        ),
      ),
    ],
  );

  @ExampleCode(group: 'calendar')
  Widget _buildSwitchMode(BuildContext context) => TCellGroup(
    cells: [
      TCell(
        key: const ValueKey('calendar-switch-trigger'),
        title: const TText('带翻页功能的日历'),
        note: _dateNote(_switchValue),
        arrow: true,
        onTap: () => _showCalendar(
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
      variant: TCalendarVariant.range,
      value: _rangeValue,
      minDate: DateTime(2022, 2),
      maxDate: DateTime(2022, 4),
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
        note: _dateNote(_localizedValue),
        arrow: true,
        onTap: () => _showCalendar(
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
        title: const TText('含不可选的日期'),
        note: _dateNote(_limitedValue),
        arrow: true,
        onTap: () => _showCalendar(
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
  Widget _buildInline(BuildContext context) => ColoredBox(
    color: context.tTheme.bgColorContainer,
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.all(context.tTheme.spacer16),
          child: TText('日历标题', font: context.tTheme.fontTitleLarge),
        ),
        TCalendar(
          key: const ValueKey('calendar-inline-panel'),
          value: _inlineValue,
          variant: TCalendarVariant.multiple,
          minDate: DateTime(_referenceDate.year, _referenceDate.month),
          maxDate: DateTime(_referenceDate.year, _referenceDate.month + 2, 0),
          onChanged: (value) => setState(() => _inlineValue = value),
        ),
        Padding(
          padding: EdgeInsets.all(context.tTheme.spacer16),
          child: SizedBox(
            width: double.infinity,
            child: TButton(
              colorScheme: TButtonColorScheme.primary,
              size: TButtonSize.large,
              onPressed: _inlineValue.isEmpty
                  ? null
                  : () => TToast.showText(
                      _formatDates(_inlineValue),
                      context: context,
                    ),
              child: const Text('确定'),
            ),
          ),
        ),
      ],
    ),
  );
}

class _CalendarMonthSwitcher extends StatelessWidget {
  const _CalendarMonthSwitcher({
    required this.month,
    required this.minDate,
    required this.maxDate,
    required this.onChanged,
  });

  final DateTime minDate;
  final DateTime maxDate;

  final DateTime month;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          tooltip: '上个月',
          onPressed:
              DateTime(
                month.year,
                month.month,
              ).isAfter(DateTime(minDate.year, minDate.month))
              ? () => onChanged(DateTime(month.year, month.month - 1))
              : null,
          icon: const TIcon(TIcons.chevron_left),
        ),
        Expanded(
          child: TText(
            '${month.year} 年 ${month.month} 月',
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          tooltip: '下个月',
          onPressed:
              DateTime(
                month.year,
                month.month,
              ).isBefore(DateTime(maxDate.year, maxDate.month))
              ? () => onChanged(DateTime(month.year, month.month + 1))
              : null,
          icon: const TIcon(TIcons.chevron_right),
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

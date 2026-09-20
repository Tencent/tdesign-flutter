import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

import '../../annotation/example_code.dart';

@ExampleCode(group: 'calendar')
class CalendarRangeExample extends StatefulWidget {
  const CalendarRangeExample({super.key});

  @override
  State<CalendarRangeExample> createState() => _CalendarRangeExampleState();
}

class _CalendarRangeExampleState extends State<CalendarRangeExample> {
  Widget _buildRange(BuildContext context) => InkWell(
    key: const ValueKey('calendar-range-trigger'),
    onTap: () => _showCalendar(
      variant: TCalendarVariant.range,
      value: _rangeValue,
      minDate: DateTime(2021, 3),
      maxDate: DateTime(2030, 3, 2),
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
    final start = minDate ?? DateTime(2021, 3);
    final end = maxDate ?? DateTime(2030, 3, 2);
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
                    CalendarRangeExampleCalendarMonthSwitcher(
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
                    delegates: GlobalMaterialLocalizations.delegates,
                    child: body,
                  )
                : body;
          },
        ),
      ),
    );
  }

  List<DateTime> _rangeValue = [DateTime(2022, 2, 19), DateTime(2022, 2, 21)];

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '';
    }
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    return _buildRange(context);
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

class CalendarRangeExampleCalendarMonthSwitcher extends StatelessWidget {
  const CalendarRangeExampleCalendarMonthSwitcher({
    super.key,
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

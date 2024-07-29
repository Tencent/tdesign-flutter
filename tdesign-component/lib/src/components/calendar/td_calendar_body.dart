import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';
import '../../util/iterable_ext.dart';
import '../../util/list_ext.dart';

class TDCalendarBody extends StatelessWidget {
  const TDCalendarBody({
    Key? key,
    this.maxDate,
    this.minDate,
    required this.type,
    this.value,
    required this.firstDayOfWeek,
    required this.cellBuilder,
    required this.bodyPadding,
    required this.displayFormat,
    required this.monthNames,
    this.monthTitleStyle,
    required this.dayGap,
  }) : super(key: key);

  final int? maxDate;
  final int? minDate;
  final CalendarType type;
  final List<int>? value;
  final int firstDayOfWeek;
  final TDCalendarCell Function(TDate? date) cellBuilder;
  final double bodyPadding;
  final String displayFormat;
  final List<String> monthNames;
  final TextStyle? monthTitleStyle;
  final double dayGap;

  @override
  Widget build(BuildContext context) {
    final min = _getDefDate(minDate);
    final max = _getDefDate(maxDate, 6);
    final months = _monthsBetween(min, max);
    final data = <DateTime, List<TDate?>>{};
    for (var i = 0; i < months.length; i++) {
      data[months[i]] = _getDaysInMonth(months[i], min, max);
    }
    return ListView.builder(
      itemCount: data.keys.length,
      itemBuilder: (context, index) {
        final monthDate = data.keys.elementAt(index);
        final monthYear = monthDate.year.toString() + context.resource.year;
        final monthMonth = monthNames[monthDate.month - 1];
        final monthDateText = displayFormat.replaceFirst('year', monthYear).replaceFirst('month', monthMonth);
        return Container(
          padding: EdgeInsets.all(bodyPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TDText(monthDateText, style: monthTitleStyle),
              ...List.generate(
                (data[monthDate]!.length / 7).ceil(),
                (rowIndex) => Padding(
                  padding: EdgeInsets.only(top: dayGap * 2),
                  child: Row(
                    children: List.generate(
                      7,
                      (colIndex) => [
                        Expanded(child: cellBuilder(data[monthDate]![rowIndex * 7 + colIndex])),
                        if (colIndex < 6) SizedBox(width: dayGap),
                      ],
                    ).expand((element) => element).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  DateTime _getDefDate(int? date, [int? addMonth]) {
    final now = date == null ? DateTime.now() : DateTime.fromMillisecondsSinceEpoch(date);
    if (addMonth == null) {
      return DateTime(now.year, now.month, now.day);
    }
    final month = now.month + addMonth;
    return DateTime(now.year, month, now.day);
  }

  List<DateTime> _monthsBetween(DateTime min, DateTime max) {
    final months = <DateTime>[];
    var current = DateTime(min.year, min.month);
    while (current.compareTo(max) <= 0) {
      months.add(current);
      current = DateTime(current.year, current.month + 1);
    }
    return months;
  }

  List<TDate?> _getDaysInMonth(DateTime date, DateTime min, DateTime max) {
    final year = date.year;
    final month = date.month;
    final dayOneWeek = DateTime(year, month).weekday;
    final daysInMonth = List<TDate?>.generate(dayOneWeek - firstDayOfWeek, (index) => null);
    final daysInMonthCount = DateTime(year, month + 1, 0).day; // 获取下个月的第一天的前一天，即当前月的最后一天
    for (var day = 1; day <= daysInMonthCount; day++) {
      final date = DateTime(year, month, day);
      var type = DateSelectType.empty;
      if (date.compareTo(min) == -1 || date.compareTo(max) == 1) {
        type = DateSelectType.disabled;
      } else if (type == CalendarType.single && (value?.length ?? 0) >= 1) {
        final val = DateTime.fromMillisecondsSinceEpoch(value![0]);
        if (date.compareTo(val) == 0) {
          type = DateSelectType.selected;
        }
      } else if (type == CalendarType.multiple && value != null) {
        final valList = value!.map(DateTime.fromMillisecondsSinceEpoch).toList();
        if (valList.isContains((e) => date.compareTo(e) == 0)) {
          type = DateSelectType.selected;
        }
      } else if (type == CalendarType.range && (value?.length ?? 0) >= 1) {
        final begin = DateTime.fromMillisecondsSinceEpoch(value![0]);
        final end = (value?.length ?? 0) > 1 ? DateTime.fromMillisecondsSinceEpoch(value![1]) : null;
        if (date.compareTo(begin) == 0) {
          type = DateSelectType.start;
        }
        if (end != null && begin.compareTo(end) < 0) {
          if (date.compareTo(end) == 0) {
            type = DateSelectType.end;
          }
          if (date.compareTo(begin) == 1 && date.compareTo(end) == -1) {
            type = DateSelectType.centre;
          }
        }
      }
      daysInMonth.add(TDate(
        date: date,
        type: type,
      ));
    }
    final dayLastWeek = daysInMonth.last!.date.weekday;
    List.generate(6 - dayLastWeek, (index) => daysInMonth.add(null));
    return daysInMonth;
  }
}

import 'package:flutter/material.dart';

import '../../util/iterable_ext.dart';
import '../../util/list_ext.dart';
import 'td_calendar.dart';

class TDCalendarBody extends StatelessWidget {
  const TDCalendarBody({
    Key? key,
    this.maxDate,
    this.minDate,
    this.format,
    required this.type,
    this.value,
    required this.firstDayOfWeek,
  }) : super(key: key);

  final int? maxDate;
  final int? minDate;
  final CalendarFormatType? format;
  final CalendarType type;
  final List<int>? value;
  final int firstDayOfWeek;

  @override
  Widget build(BuildContext context) {
    final min = _getDefDate(minDate);
    final max = _getDefDate(maxDate, 6);
    final months = _monthsBetween(min, max);
    final data = <DateTime, List<TDate?>>{};
    for (var i = 0; i < months.length; i++) {
      data[months[i]] = _getDaysInMonth(months[i], min, max);
    }
    return Container();
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
    final daysInMonth = <TDate?>[];
    final year = date.year;
    final monthNumber = date.month;
    final daysInMonthCount = DateTime(year, monthNumber + 1, 0).day; // 获取下个月的第一天的前一天，即当前月的最后一天
    for (var day = 1; day <= daysInMonthCount; day++) {
      final date = DateTime(year, monthNumber, day);
      var type = TDateType.empty;
      final compareMin = date.compareTo(min);
      final compareMax = date.compareTo(max);
      if (compareMin == -1 || compareMax == 1) {
        type = TDateType.disabled;
      } else if (type == CalendarType.single && (value?.length ?? 0) >= 1) {
        final val = DateTime.fromMillisecondsSinceEpoch(value![0]);
        if (date.compareTo(val) == 0) {
          type = TDateType.selected;
        }
      } else if (type == CalendarType.multiple && value != null) {
        final valList = value!.map(DateTime.fromMillisecondsSinceEpoch).toList();
        if (valList.isContains((e) => date.compareTo(e) == 0)) {
          type = TDateType.selected;
        }
      } else if (type == CalendarType.range && (value?.length ?? 0) >= 2) {
        final begin = DateTime.fromMillisecondsSinceEpoch(value![0]);
        final end = DateTime.fromMillisecondsSinceEpoch(value![1]);
        if (begin.compareTo(end) < 0) {
          if (date.compareTo(begin) == 0) {
            type = TDateType.start;
          }
          if (date.compareTo(end) == 0) {
            type = TDateType.end;
          }
          if (date.compareTo(begin) == 1 && date.compareTo(end) == -1) {
            type = TDateType.centre;
          }
        }
      }
      daysInMonth.add(TDate(
        date: date,
        type: type,
      ));
    }
    return daysInMonth;
  }
}

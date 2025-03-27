import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';
import '../../util/iterable_ext.dart';

class TDCalendarBody extends StatelessWidget {
  const TDCalendarBody({
    Key? key,
    this.maxDate,
    this.minDate,
    required this.type,
    this.value,
    required this.firstDayOfWeek,
    required this.builder,
    required this.bodyPadding,
    required this.displayFormat,
    required this.monthNames,
    this.monthTitleStyle,
    this.monthTitleBuilder,
    required this.cellHeight,
    required this.monthTitleHeight,
    required this.verticalGap,
    required this.animateTo,
  }) : super(key: key);

  final int? maxDate;
  final int? minDate;
  final CalendarType type;
  final List<DateTime>? value;
  final int firstDayOfWeek;
  final Widget Function(
      TDate? date, List<TDate?> dateList, Map<DateTime, List<TDate?>> data, int rowIndex, int colIndex) builder;
  final double bodyPadding;
  final String displayFormat;
  final List<String> monthNames;
  final TextStyle? monthTitleStyle;
  final Widget Function(BuildContext context, DateTime monthDate)? monthTitleBuilder;
  final double monthTitleHeight;
  final double verticalGap;
  final double cellHeight;
  final bool animateTo;

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    final min = _getDefDate(minDate);
    final max = _getDefDate(maxDate, 6);
    final months = _monthsBetween(min, max);
    final data = <DateTime, List<TDate?>>{};
    final monthHeight = <int, double>{};
    _scrollToItem(scrollController, months, monthHeight);
    return ListView.builder(
      padding: EdgeInsets.all(bodyPadding),
      controller: scrollController,
      itemCount: months.length,
      itemExtentBuilder: (index, dimensions) => _getMonthHeight(months, index, monthHeight),
      itemBuilder: (context, index) {
        final monthDate = months[index];
        final monthYear = monthDate.year.toString() + context.resource.year;
        final monthMonth = monthNames[monthDate.month - 1];
        final monthDateText = displayFormat.replaceFirst('year', monthYear).replaceFirst('month', monthMonth);
        late List<TDate?> monthData;
        if (data.containsKey(monthDate)) {
          monthData = data[monthDate]!;
        } else {
          monthData = data[monthDate] = _getDaysInMonth(monthDate, min, max);
        }

        final keyList = [...data.keys];
        final currentIndex = keyList.indexOf(monthDate);
        keyList.forEachWidthIndex((key, index) {
          if (index < currentIndex - 10 || index > currentIndex + 10) {
            // 保留最近 10 个月的数据，防止内存泄露
            data.remove(key);
          }
        });
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: monthTitleHeight,
              child: monthTitleBuilder?.call(context, monthDate) ?? TDText(monthDateText, style: monthTitleStyle),
            ),
            ...List.generate(
              (monthData.length / 7).ceil(),
              (rowIndex) => [
                SizedBox(height: verticalGap),
                Row(
                  children: List.generate(
                    7,
                    (colIndex) => [
                      if (colIndex != 0) SizedBox(width: verticalGap / 2),
                      Expanded(
                        child: builder(
                          monthData[rowIndex * 7 + colIndex],
                          monthData,
                          data,
                          rowIndex,
                          colIndex,
                        ),
                      ),
                    ],
                  ).expand((element) => element).toList(),
                ),
              ],
            ).expand((element) => element).toList(),
            SizedBox(height: index == months.length - 1 ? 0 : bodyPadding),
          ],
        );
      },
    );
  }

  void _scrollToItem(ScrollController scrollController, List<DateTime> months, Map<int, double> monthHeight) {
    if (value == null || value!.isEmpty) {
      return;
    }
    final scrollDate = value!.reduce((a, b) => a.isBefore(b) ? a : b);
    var lastMonthDay = DateTime(months.last.year, months.last.month + 1);
    lastMonthDay = lastMonthDay.add(const Duration(days: -1));
    if (months.first.isAfter(scrollDate) || lastMonthDay.isBefore(scrollDate)) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var height = 0.0;
      for (var i = 0; i < months.length; i++) {
        final item = months[i];
        if (item.year == scrollDate.year && item.month == scrollDate.month) {
          break;
        }
        height += (_getMonthHeight(months, i, monthHeight) ?? 0);
      }
      if (height <= 0) {
        return;
      }
      if (animateTo) {
        scrollController.animateTo(
          height,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      } else {
        scrollController.jumpTo(height);
      }
    });
  }

  DateTime _getDefDate(int? date, [int? addMonth]) {
    final now = date == null ? DateTime.now() : DateTime.fromMillisecondsSinceEpoch(date);
    if (addMonth == null) {
      return DateTime(now.year, now.month, now.day);
    }
    final month = now.month + addMonth;
    return DateTime(now.year, date == null ? month : now.month, now.day);
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

  List<TDate?> _getDaysInMonth(DateTime curDate, DateTime min, DateTime max) {
    final daysInMonth = List<TDate?>.generate(_getPreOffset(curDate), (index) => null);
    final daysInMonthCount = DateTime(curDate.year, curDate.month + 1, 0).day; // 获取下个月的第一天的前一天，即当前月的最后一天
    for (var day = 1; day <= daysInMonthCount; day++) {
      final date = DateTime(curDate.year, curDate.month, day);
      var selectType = DateSelectType.empty;
      if (date.compareTo(min) == -1 || date.compareTo(max) == 1) {
        selectType = DateSelectType.disabled;
      } else if (type == CalendarType.single && (value?.length ?? 0) >= 1) {
        if (date.compareTo(value![0]) == 0) {
          selectType = DateSelectType.selected;
        }
      } else if (type == CalendarType.multiple && value != null) {
        if (value!.isContains((e) => date.compareTo(e) == 0)) {
          selectType = DateSelectType.selected;
        }
      } else if (type == CalendarType.range && (value?.length ?? 0) >= 1) {
        final end = (value?.length ?? 0) > 1 ? value![1] : null;
        if (date.compareTo(value![0]) == 0) {
          selectType = DateSelectType.start;
        }
        if (end != null && value![0].compareTo(end) < 0) {
          if (date.compareTo(end) == 0) {
            selectType = DateSelectType.end;
          }
          if (date.compareTo(value![0]) == 1 && date.compareTo(end) == -1) {
            selectType = DateSelectType.centre;
          }
        }
      }
      daysInMonth.add(TDate(
        date: date,
        typeNotifier: DateSelectTypeNotifier(selectType),
        isLastDayOfMonth: daysInMonthCount == day,
      ));
    }
    var sufOffset = 7 - daysInMonth.length % 7;
    sufOffset = sufOffset == 7 ? 0 : sufOffset;
    List.generate(sufOffset, (index) => daysInMonth.add(null));
    return daysInMonth;
  }

  int _getPreOffset(DateTime date) {
    final year = date.year;
    final month = date.month;
    var dayOneWeek = DateTime(year, month).weekday;
    dayOneWeek = dayOneWeek == 7 ? 0 : dayOneWeek;
    var preOffset = dayOneWeek - firstDayOfWeek;
    preOffset = preOffset < 0 ? preOffset + 7 : preOffset;
    return preOffset;
  }

  /// 获取月份高度，带缓存
  double _getMonthHeight(List<DateTime> months, int index, Map<int, double> monthHeight) {
    if (months.getOrNull(index) == null) {
      return 1;
    }
    if (monthHeight.containsKey(index)) {
      return monthHeight[index]!;
    }
    final item = months[index];
    final isLast = index == months.length - 1;
    final preOffset = _getPreOffset(item);
    final daysInMonthCount = DateTime(item.year, item.month + 1, 0).day;
    final daysInMonth = preOffset + daysInMonthCount;
    final height =
        monthTitleHeight + (daysInMonth / 7).ceil() * (verticalGap + cellHeight) + (isLast ? 0 : bodyPadding);
    monthHeight[index] = height;
    return height;
  }
}

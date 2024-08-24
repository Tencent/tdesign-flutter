import 'package:flutter/material.dart';
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
    required this.verticalGap,
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
  final double verticalGap;

  @override
  Widget build(BuildContext context) {
    final itemKey = GlobalKey();
    final scrollController = ScrollController();
    var scrollToIndex = 0;
    final min = _getDefDate(minDate);
    final max = _getDefDate(maxDate, 6);
    final months = _monthsBetween(min, max);
    final data = <DateTime, List<TDate?>>{};
    for (var i = 0; i < months.length; i++) {
      data[months[i]] = _getDaysInMonth(months[i], min, max);
      final hasSelected = data[months[i]]?.isContains((item) =>
          item?.typeNotifier.value == DateSelectType.selected || item?.typeNotifier.value == DateSelectType.start);
      if (scrollToIndex == 0 && hasSelected == true) {
        scrollToIndex = i;
      }
    }
    _scrollToItem(itemKey, scrollController, scrollToIndex);
    return ListView.separated(
      padding: EdgeInsets.all(bodyPadding),
      controller: scrollController,
      itemCount: data.keys.length,
      itemBuilder: (context, index) {
        final key = index == 0 ? itemKey : null;
        final monthDate = data.keys.elementAt(index);
        final monthYear = monthDate.year.toString() + context.resource.year;
        final monthMonth = monthNames[monthDate.month - 1];
        final monthDateText = displayFormat.replaceFirst('year', monthYear).replaceFirst('month', monthMonth);
        final monthData = data[monthDate]!;
        return Column(
          key: key,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TDText(monthDateText, style: monthTitleStyle),
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
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: bodyPadding);
      },
    );
  }

  void _scrollToItem(GlobalKey itemKey, ScrollController scrollController, int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final height = (itemKey.currentContext?.findRenderObject() as RenderBox?)?.size.height ?? 0;
      scrollController.jumpTo(height * index + index * bodyPadding);
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

  List<TDate?> _getDaysInMonth(DateTime date, DateTime min, DateTime max) {
    final year = date.year;
    final month = date.month;
    var dayOneWeek = DateTime(year, month).weekday;
    dayOneWeek = dayOneWeek == 7 ? 0 : dayOneWeek;
    var preOffset = dayOneWeek - firstDayOfWeek;
    preOffset = preOffset < 0 ? preOffset + 7 : preOffset;
    final daysInMonth = List<TDate?>.generate(preOffset, (index) => null);
    final daysInMonthCount = DateTime(year, month + 1, 0).day; // 获取下个月的第一天的前一天，即当前月的最后一天
    for (var day = 1; day <= daysInMonthCount; day++) {
      final date = DateTime(year, month, day);
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
}

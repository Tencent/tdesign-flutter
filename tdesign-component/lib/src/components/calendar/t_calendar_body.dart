import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';
import '../../util/iterable_ext.dart';

class TCalendarBody extends StatefulWidget {
  const TCalendarBody({
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
    this.onMonthChange,
    this.anchorDate,
    this.dateType = TCalendarDateType.solar,
    this.dataSource,
  }) : super(key: key);

  final int? maxDate;
  final int? minDate;
  final CalendarType type;
  final List<DateTime>? value;
  final DateTime? anchorDate;
  final int firstDayOfWeek;
  final Widget Function(
    TDate? date,
    List<TDate?> dateList,
    Map<DateTime, List<TDate?>> data,
    int rowIndex,
    int colIndex,
  ) builder;
  final double bodyPadding;
  final String displayFormat;
  final List<String> monthNames;
  final TextStyle? monthTitleStyle;
  final Widget Function(
    BuildContext context,
    DateTime monthDate,
  )? monthTitleBuilder;
  final double monthTitleHeight;
  final double verticalGap;
  final double cellHeight;
  final bool animateTo;
  final ValueChanged<DateTime>? onMonthChange;
  final TCalendarDateType dateType;
  final TCalendarDataSource? dataSource;

  @override
  State<TCalendarBody> createState() => _TCalendarBodyState();
}

class _TCalendarBodyState extends State<TCalendarBody> {
  late final ScrollController _scrollController;
  DateTime? _lastPrintMonth;
  final _data = <DateTime, List<TDate?>>{};
  final _monthHeight = <int, double>{};
  late List<DateTime> _months;
  late DateTime _min;
  late DateTime _max;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _initMonths();
    _scrollToItem();
  }

  @override
  void didUpdateWidget(covariant TCalendarBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.minDate != widget.minDate ||
        oldWidget.maxDate != widget.maxDate) {
      _monthHeight.clear();
      _data.clear();
      _lastPrintMonth = null;
      _initMonths();
    }
    if (oldWidget.anchorDate != widget.anchorDate ||
        oldWidget.value != widget.value) {
      _scrollToItem();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _initMonths() {
    _min = _getDefDate(widget.minDate);
    _max = _getDefDate(widget.maxDate, true);
    _months = _monthsBetween(_min, _max);
  }

  int? _lastCleanupIndex;

  void _onScroll() {
    var currentOffset = 0.0;
    for (var i = 0; i < _months.length; i++) {
      final mh = _getMonthHeight(_months, i, _monthHeight);
      if (_scrollController.offset >= currentOffset &&
          _scrollController.offset < currentOffset + mh) {
        if (i + 1 < _months.length) {
          final currentMonth = _months[i + 1];
          if (_lastPrintMonth == null ||
              !_lastPrintMonth!.isAtSameMomentAs(currentMonth)) {
            _lastPrintMonth = currentMonth;
            widget.onMonthChange?.call(currentMonth);
          }
        }
        _cleanupCache(i);
        break;
      }
      currentOffset += mh;
    }
  }

  /// 清理距离当前可见月份过远的缓存数据，避免在 itemBuilder 中执行副作用。
  void _cleanupCache(int currentIndex) {
    if (_lastCleanupIndex == currentIndex) {
      return;
    }
    _lastCleanupIndex = currentIndex;
    final keysToRemove = <DateTime>[];
    final keyList = [..._data.keys];
    for (var i = 0; i < keyList.length; i++) {
      final monthIdx = _months.indexOf(keyList[i]);
      if (monthIdx < currentIndex - 10 || monthIdx > currentIndex + 10) {
        keysToRemove.add(keyList[i]);
      }
    }
    for (final key in keysToRemove) {
      _data.remove(key);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(widget.bodyPadding),
      controller: _scrollController,
      itemCount: _months.length,
      itemExtentBuilder: (index, dimensions) =>
          _getMonthHeight(_months, index, _monthHeight),
      itemBuilder: (context, index) {
        final monthDate = _months[index];
        final monthYear = monthDate.year.toString() + context.resource.year;
        final monthMonth = widget.monthNames[monthDate.month - 1];
        final monthDateText = widget.displayFormat
            .replaceFirst('year', monthYear)
            .replaceFirst('month', monthMonth);
        late List<TDate?> monthData;
        if (_data.containsKey(monthDate)) {
          monthData = _data[monthDate]!;
        } else {
          monthData = _data[monthDate] =
              _getDaysInMonth(monthDate, _min, _max);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: widget.monthTitleHeight,
              child: widget.monthTitleBuilder?.call(context, monthDate) ??
                  TText(monthDateText, style: widget.monthTitleStyle),
            ),
            ...List.generate(
              (monthData.length / 7).ceil(),
              (rowIndex) => [
                SizedBox(height: widget.verticalGap),
                Row(
                  children: [
                    for (int colIndex = 0; colIndex < 7; colIndex++) ...[
                      if (colIndex != 0)
                        SizedBox(width: widget.verticalGap / 2),
                      Expanded(
                        child: widget.builder(
                          (rowIndex * 7 + colIndex < monthData.length)
                              ? monthData[rowIndex * 7 + colIndex]
                              : null,
                          monthData,
                          _data,
                          rowIndex,
                          colIndex,
                        ),
                      ),
                    ]
                  ],
                ),
              ],
            ).expand((element) => element).toList(),
            SizedBox(
                height: index == _months.length - 1 ? 0 : widget.bodyPadding),
          ],
        );
      },
    );
  }

  void _scrollToItem() {
    var scrollToDate = widget.anchorDate;
    if (scrollToDate == null) {
      if (widget.value == null || widget.value!.isEmpty) {
        return;
      }
      scrollToDate = widget.value!.reduce((a, b) => a.isBefore(b) ? a : b);
    }
    var lastMonthDay = DateTime(_months.last.year, _months.last.month + 1);
    lastMonthDay = lastMonthDay.add(const Duration(days: -1));
    if (_months.first.isAfter(scrollToDate) ||
        lastMonthDay.isBefore(scrollToDate)) {
      return;
    }
    final targetDate = scrollToDate;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      var height = 0.0;
      for (var i = 0; i < _months.length; i++) {
        final item = _months[i];
        if (item.year == targetDate.year && item.month == targetDate.month) {
          break;
        }
        height += _getMonthHeight(_months, i, _monthHeight);
      }
      if (height <= 0) {
        return;
      }
      if (widget.animateTo) {
        _scrollController.animateTo(
          height,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      } else {
        _scrollController.jumpTo(height);
      }
    });
  }

  DateTime _getDefDate(int? date, [bool isMax = false]) {
    if (date != null) {
      final d = DateTime.fromMillisecondsSinceEpoch(date);
      return DateTime(d.year, d.month, d.day);
    }
    return isMax ? DateTime(2100, 12, 31) : DateTime(1970);
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
    final daysInMonth =
        List<TDate?>.generate(_getPreOffset(curDate), (index) => null);
    final daysInMonthCount = DateTime(curDate.year, curDate.month + 1, 0)
        .day; // 获取下个月的第一天的前一天，即当前月的最后一天
    for (var day = 1; day <= daysInMonthCount; day++) {
      final date = DateTime(curDate.year, curDate.month, day);
      var selectType = DateSelectType.empty;
      if (date.compareTo(min) == -1 || date.compareTo(max) == 1) {
        selectType = DateSelectType.disabled;
      } else if (widget.type == CalendarType.single &&
          (widget.value?.length ?? 0) >= 1) {
        if (date.compareTo(widget.value![0]) == 0) {
          selectType = DateSelectType.selected;
        }
      } else if (widget.type == CalendarType.multiple &&
          widget.value != null) {
        if (widget.value!.isContains((e) => date.compareTo(e) == 0)) {
          selectType = DateSelectType.selected;
        }
      } else if (widget.type == CalendarType.range &&
          (widget.value?.length ?? 0) >= 1) {
        final end =
            (widget.value?.length ?? 0) > 1 ? widget.value![1] : null;
        if (date.compareTo(widget.value![0]) == 0) {
          selectType = DateSelectType.start;
        }
        if (end != null && widget.value![0].compareTo(end) < 0) {
          if (date.compareTo(end) == 0) {
            selectType = DateSelectType.end;
          }
          if (date.compareTo(widget.value![0]) == 1 &&
              date.compareTo(end) == -1) {
            selectType = DateSelectType.centre;
          }
        }
      }
      // 获取农历信息
      TLunarInfo? lunarInfo;
      String? solarTerm;
      String? festival;
      Map<String, String>? holidayInfo;
      if (widget.dataSource != null) {
        lunarInfo = widget.dataSource!.getLunarInfo(date);
        solarTerm = widget.dataSource!.getSolarTerm(date);
        festival = widget.dataSource!.getFestival(date, lunarInfo);
        holidayInfo = widget.dataSource!.getHolidayInfo(date);
      }
      daysInMonth.add(TDate(
        date: date,
        typeNotifier: DateSelectTypeNotifier(selectType),
        isLastDayOfMonth: daysInMonthCount == day,
        lunarInfo: lunarInfo,
        solarTerm: solarTerm,
        festival: festival,
        holidayInfo: holidayInfo,
      ));
    }
    var sufOffset = 7 - daysInMonth.length % 7;
    sufOffset = sufOffset == 7 ? 0 : sufOffset;
    for (var i = 0; i < sufOffset; i++) {
      daysInMonth.add(null);
    }
    return daysInMonth;
  }

  int _getPreOffset(DateTime date) {
    final year = date.year;
    final month = date.month;
    var dayOneWeek = DateTime(year, month).weekday;
    dayOneWeek = dayOneWeek == 7 ? 0 : dayOneWeek;
    var preOffset = dayOneWeek - widget.firstDayOfWeek;
    preOffset = preOffset < 0 ? preOffset + 7 : preOffset;
    return preOffset;
  }

  /// 获取月份高度，带缓存
  double _getMonthHeight(
      List<DateTime> months, int index, Map<int, double> monthHeight) {
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
    final height = widget.monthTitleHeight +
        (daysInMonth / 7).ceil() * (widget.verticalGap + widget.cellHeight) +
        (isLast ? 0 : widget.bodyPadding);
    monthHeight[index] = height;
    return height;
  }
}

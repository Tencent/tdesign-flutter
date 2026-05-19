import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';
import '../../util/iterable_ext.dart';
import 't_calendar_cell.dart';

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

  final DateTime? maxDate;
  final DateTime? minDate;
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
    _initMonths();
    final initialOffset = _calcScrollOffset();
    _scrollController = ScrollController(initialScrollOffset: initialOffset);
    _scrollController.addListener(_onScroll);
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
    // anchorDate 变化时滚动：使用 identical 引用比较，
    // 让上层即使重复传同一年月（例如滑动到该月后再点击该月按钮）也能触发滚动；
    // 上层只要每次导航都构造新的 DateTime 实例即可。
    final newAnchor = widget.anchorDate;
    if (newAnchor != null && !identical(newAnchor, oldWidget.anchorDate)) {
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

  /// 计算目标日期所在月份的滚动偏移量
  ///
  /// 越界处理策略：
  /// - 早于 minDate → clamp 到第一个月
  /// - 晚于 maxDate → clamp 到最后一个月
  /// 这样上层即使传入越界 anchorDate，也不会出现"静默回到顶部"的异常表现。
  double _calcScrollOffset() {
    var scrollToDate = widget.anchorDate;
    if (scrollToDate == null) {
      if (widget.value == null || widget.value!.isEmpty) {
        return 0.0;
      }
      scrollToDate = widget.value!.reduce((a, b) => a.isBefore(b) ? a : b);
    }
    if (_months.isEmpty) {
      return 0.0;
    }
    // 用 (年*12 + 月) 作为可比较的标量，规避日级别比较带来的边界陷阱。
    final firstKey = _months.first.year * 12 + _months.first.month;
    final lastKey = _months.last.year * 12 + _months.last.month;
    final targetKey = scrollToDate.year * 12 + scrollToDate.month;
    final clampedKey = targetKey.clamp(firstKey, lastKey);
    var height = 0.0;
    for (var i = 0; i < _months.length; i++) {
      final item = _months[i];
      final itemKey = item.year * 12 + item.month;
      if (itemKey == clampedKey) {
        break;
      }
      height += _getMonthHeight(_months, i, _monthHeight);
    }
    return height;
  }

  int? _lastCleanupIndex;

  void _onScroll() {
    var currentOffset = 0.0;
    for (var i = 0; i < _months.length; i++) {
      final mh = _getMonthHeight(_months, i, _monthHeight);
      if (_scrollController.offset >= currentOffset &&
          _scrollController.offset < currentOffset + mh) {
        if (i < _months.length) {
          final currentMonth = _months[i];
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
        final monthDateText = '$monthYear $monthMonth';
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
    final height = _calcScrollOffset();
    // 等待 ScrollController 完成 attach 后再滚动，最多重试若干帧。
    void attemptScroll([int retry = 0]) {
      if (!mounted) {
        return;
      }
      if (!_scrollController.hasClients) {
        if (retry >= 5) {
          return;
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          attemptScroll(retry + 1);
        });
        return;
      }
      final position = _scrollController.position;
      final clamped = height.clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      );
      if (widget.animateTo) {
        _scrollController.animateTo(
          clamped,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      } else {
        _scrollController.jumpTo(clamped);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      attemptScroll();
    });
  }

  DateTime _getDefDate(DateTime? date, [bool isMax = false]) {
    if (date != null) {
      return DateTime(date.year, date.month, date.day);
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

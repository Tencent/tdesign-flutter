import 'package:flutter/material.dart';

import '../../util/list_ext.dart';
import '../text/td_text.dart';
import 'td_calendar.dart';

class TDCalendarCell extends StatefulWidget {
  const TDCalendarCell({
    Key? key,
    this.tdate,
    this.format,
    required this.type,
    this.onSelect,
    this.onChange,
    required this.height,
    required this.data,
    required this.padding,
    required this.isRowLast,
  }) : super(key: key);

  final TDate? tdate;
  final CalendarFormat? format;
  final CalendarType type;
  final void Function(int value, DateSelectType type)? onSelect;
  final void Function(List<int> value)? onChange;
  final double height;
  final Map<DateTime, List<TDate?>> data;
  final double padding;
  final bool isRowLast;

  @override
  _TDCalendarCellState createState() => _TDCalendarCellState();
}

class _TDCalendarCellState extends State<TDCalendarCell> {
  @override
  void initState() {
    super.initState();
    
    widget.tdate?.typeNotifier.addListener(_cellTypeChange);
  }

  @override
  void didUpdateWidget(TDCalendarCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tdate != oldWidget.tdate) {
      oldWidget.tdate?.typeNotifier.removeListener(_cellTypeChange);
      widget.tdate?.typeNotifier.addListener(_cellTypeChange);
    }
  }

  @override
  void dispose() {
    widget.tdate?.typeNotifier.removeListener(_cellTypeChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tdate == null) {
      return const SizedBox.shrink();
    }
    final tdate = widget.format?.call(widget.tdate) ?? widget.tdate!;
    final cellStyle = TDCalendarStyle.cellStyle(context, widget.tdate!._type);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _cellTap,
      child: Container(
        height: widget.height,
        decoration: tdate.decoration ?? cellStyle.cellDecoration,
        padding: EdgeInsets.all(widget.padding),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: tdate.prefixWidget ??
                  TDText(
                    tdate.prefix ?? '',
                    style: tdate.prefixStyle ?? cellStyle.cellPrefixStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: TDText(
                  forceVerticalCenter: true,
                  widget.tdate!.date.day.toString(),
                  style: tdate.style ?? cellStyle.cellStyle,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: tdate.suffixWidget ??
                  TDText(
                    tdate.suffix ?? '',
                    style: tdate.suffixStyle ?? cellStyle.cellSuffixStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _cellTap() {
    final selectType = widget.tdate!._type;
    if (selectType == DateSelectType.disabled) {
      return;
    }
    final list = widget.data.values.expand((element) => element).toList();
    final curDate = widget.tdate!._milliseconds;
    switch (widget.type) {
      case CalendarType.single:
        final date = list.find((item) => item?._type == DateSelectType.selected);
        date?._setType(DateSelectType.empty);
        widget.tdate!._setType(DateSelectType.selected);
        if (date?._milliseconds != curDate) {
          widget.onChange?.call([curDate]);
        }
        break;
      case CalendarType.multiple:
        final date = list.where((item) => item?._type == DateSelectType.selected).toList();
        final value = date.map((item) => item!._milliseconds).toList();
        if (date.find((item) => item?._milliseconds == curDate) != null) {
          widget.tdate!._setType(DateSelectType.empty);
          value.remove(curDate);
        } else {
          widget.tdate!._setType(DateSelectType.selected);
          value.add(curDate);
        }
        widget.onChange?.call(value);
        break;
      case CalendarType.range:
        final start = list.find((item) => item?._type == DateSelectType.start);
        final end = list.find((item) => item?._type == DateSelectType.end);
        final startTimes = start?._milliseconds;
        if ((start == null && end == null) ||
            (start != null && end != null) ||
            (start != null && end == null && startTimes! >= curDate)) {
          start?._setType(DateSelectType.empty);
          end?._setType(DateSelectType.empty);
          final centres = list.where((item) => item?._type == DateSelectType.centre).toList();
          centres.forEach((item) => item!._setType(DateSelectType.empty));
          widget.tdate!._setType(DateSelectType.start);
          widget.onChange?.call([curDate]);
        } else if (start != null && end == null && startTimes! < curDate) {
          widget.tdate!._setType(DateSelectType.end);
          var startIndex = list.indexOf(start) + 1;
          while (list[startIndex]!._milliseconds < curDate) {
            list[startIndex]!._setType(DateSelectType.centre);
            startIndex++;
          }
          widget.onChange?.call([startTimes, curDate]);
        }
        break;
    }
  }

  void _cellTypeChange() {
    setState(() {});
  }
}

/// 时间对象
class TDate {
  TDate({
    required this.date,
    required this.typeNotifier,
    this.prefix,
    this.prefixStyle,
    this.prefixWidget,
    this.suffix,
    this.suffixStyle,
    this.suffixWidget,
    this.style,
    this.decoration,
  });

  /// 时间对象
  final DateTime date;

  /// 日期类型
  final ValueNotifier<DateSelectType> typeNotifier;

  /// 日期前面的字符串
  String? prefix;

  /// 日期前面的字符串的样式
  TextStyle? prefixStyle;

  /// 日期前面的组件，优先级高于[prefix]
  Widget? prefixWidget;

  /// 日期后面的字符串
  String? suffix;

  /// 日期后面的字符串的样式
  TextStyle? suffixStyle;

  /// 日期后面的组件，优先级高于[suffix]
  Widget? suffixWidget;

  /// 日期样式
  TextStyle? style;

  /// 日期Decoration
  Decoration? decoration;

  int get _milliseconds => DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;

  DateSelectType get _type => typeNotifier.value;

  void _setType(DateSelectType type) {
    typeNotifier.value = type;
  }
}

import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';
import '../../util/iterable_ext.dart';
import '../../util/list_ext.dart';

class TDCalendarCell extends StatefulWidget {
  const TDCalendarCell({
    Key? key,
    this.tdate,
    this.format,
    required this.type,
    this.onCellClick,
    this.onCellLongPress,
    this.onChange,
    required this.height,
    required this.data,
    required this.padding,
    required this.rowIndex,
    required this.colIndex,
    required this.dateList,
  }) : super(key: key);

  final TDate? tdate;
  final CalendarFormat? format;
  final CalendarType type;
  final void Function(int value, DateSelectType type, TDate tdate)? onCellClick;
  final void Function(int value, DateSelectType type, TDate tdate)? onCellLongPress;
  final void Function(List<int> value)? onChange;
  final double height;
  final Map<DateTime, List<TDate?>> data;
  final double padding;
  final int rowIndex;
  final int colIndex;
  final List<TDate?> dateList;

  @override
  _TDCalendarCellState createState() => _TDCalendarCellState();
}

class _TDCalendarCellState extends State<TDCalendarCell> {
  late List<TDate?> list;
  var isToday = false;
  var positionOffset = 0;
  @override
  void initState() {
    super.initState();
    list = widget.data.values.expand((element) => element).toList();
    isToday = _isToday();
    widget.tdate?.typeNotifier.addListener(_cellTypeChange);
  }

  @override
  void didUpdateWidget(TDCalendarCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      list = widget.data.values.expand((element) => element).toList();
    }
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
    final decoration = tdate.decoration ?? cellStyle.cellDecoration;
    final positionColor = _getColor(cellStyle, decoration);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _cellTap,
      onLongPress: () {
        final selectType = widget.tdate!._type;
        final curDate = widget.tdate!._milliseconds;
        widget.onCellLongPress?.call(curDate, selectType, widget.tdate!);
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: widget.height,
            decoration: decoration,
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
                      style: (isToday ? cellStyle.todayStyle : null) ?? tdate.style ?? cellStyle.cellStyle,
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
          if (widget.colIndex < 6)
            Positioned(
              right: -widget.padding - positionOffset,
              child: Container(
                width: widget.padding + 2 * positionOffset,
                height: widget.height,
                color: positionColor,
              ),
            ),
        ],
      ),
    );
  }

  void _cellTap() {
    final selectType = widget.tdate!._type;
    final curDate = widget.tdate!._milliseconds;
    if (selectType == DateSelectType.disabled) {
      widget.onCellClick?.call(curDate, selectType, widget.tdate!);
      return;
    }
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
          start._setType(DateSelectType.start);
          widget.tdate!._setType(DateSelectType.end);
          var startIndex = list.indexOf(start) + 1;
          while (list[startIndex] == null || list[startIndex]!._milliseconds < curDate) {
            list[startIndex]?._setType(DateSelectType.centre);
            startIndex++;
          }
          widget.onChange?.call([startTimes, curDate]);
        }
        break;
    }
    widget.onCellClick?.call(curDate, widget.tdate!._type, widget.tdate!);
  }

  void _cellTypeChange() {
    setState(() {});
  }

  Color? _getColor(TDCalendarStyle cellStyle, BoxDecoration? decoration) {
    positionOffset = 0;
    final next = _nextDay();
    if (widget.tdate?._type == DateSelectType.start) {
      if (widget.tdate?.isLastDayOfMonth == true) {
        return null;
      }
      if (next?._type == DateSelectType.end) {
        positionOffset = 1;
        return decoration?.color;
      }
      if (next?._type == DateSelectType.centre) {
        return cellStyle.centreColor;
      }
    }
    if (widget.tdate?._type == DateSelectType.centre) {
      return cellStyle.centreColor;
    }
    return null;
  }

  TDate? _nextDay([int num = 1]) {
    final index = widget.rowIndex * 7 + widget.colIndex + num;
    final date = widget.dateList.getOrNull(index);
    return date;
  }

  bool _isToday() {
    final today = DateTime.now();
    return widget.tdate?._milliseconds == DateTime(today.year, today.month, today.day).millisecondsSinceEpoch;
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
    required this.isLastDayOfMonth,
  });

  /// 时间对象
  final DateTime date;

  /// 日期类型
  final DateSelectTypeNotifier typeNotifier;

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
  BoxDecoration? decoration;

  /// 是否是当月最后一天
  final bool isLastDayOfMonth;

  int get _milliseconds => DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;

  DateSelectType get _type => typeNotifier.value;

  void _setType(DateSelectType type) {
    typeNotifier.setType(type);
  }
}

class DateSelectTypeNotifier extends ChangeNotifier {
  DateSelectType value = DateSelectType.empty;
  DateSelectTypeNotifier(DateSelectType selectType) {
    value = selectType;
  }

  void setType(DateSelectType type) {
    value = type;
    notifyListeners();
  }
}

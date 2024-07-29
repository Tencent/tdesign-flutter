import 'package:flutter/material.dart';

import '../../theme/td_colors.dart';
import '../../theme/td_fonts.dart';
import '../../theme/td_theme.dart';
import '../text/td_text.dart';
import 'td_calendar.dart';

class TDCalendarCell extends StatefulWidget {
  const TDCalendarCell({
    Key? key,
    this.tdate,
    this.format,
    required this.type,
    // required this.clickCell,
    required this.selected,
    this.onSelect,
  }) : super(key: key);

  final TDate? tdate;
  final CalendarFormat? format;
  final CalendarType type;
  // final ValueNotifier<DateTime?> clickCell;
  final ValueNotifier<List<int>> selected;
  final void Function(int value, bool selected)? onSelect;

  @override
  _TDCalendarCellState createState() => _TDCalendarCellState();
}

class _TDCalendarCellState extends State<TDCalendarCell> {
  // @override
  // void initState() {
  //   super.initState();
  //   widget.clickCell.addListener(_clickCellChange);
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   widget.clickCell.removeListener(_clickCellChange);
  // }

  @override
  Widget build(BuildContext context) {
    final tdate = widget.format?.call(widget.tdate) ?? widget.tdate;
    if (tdate == null) {
      return const SizedBox.shrink();
    }
    return Container(
      height: 60,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: TDText(
          tdate.date.day.toString(),
          style: tdate.style ??
              TextStyle(
                fontSize: TDTheme.of(context).fontTitleMedium?.size,
                fontWeight: TDTheme.of(context).fontTitleMedium?.fontWeight,
                height: TDTheme.of(context).fontTitleMedium?.height,
                color: TDTheme.of(context).fontGyColor1,
              ),
        ),
      ),
    );
  }

  // void _clickCellChange() {

  // }
}

/// 时间对象
class TDate {
  TDate({
    required this.date,
    required this.type,
    this.prefix,
    this.prefixWidget,
    this.suffix,
    this.suffixWidget,
    this.style,
  });

  /// 时间对象
  final DateTime date;

  /// 日期类型
  DateSelectType type;

  /// 日期前面的字符串
  String? prefix;

  /// 日期前面的组件，优先级高于[prefix]
  Widget? prefixWidget;

  /// 日期后面的字符串
  String? suffix;

  /// 日期后面的组件，优先级高于[suffix]
  Widget? suffixWidget;

  /// 日期样式
  TextStyle? style;
}

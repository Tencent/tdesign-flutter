import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';

export 'td_calendar_body.dart';
export 'td_calendar_cell.dart';
export 'td_calendar_header.dart';
export 'td_calendar_popup.dart';
export 'td_calendar_style.dart';

typedef CalendarFormat = TDate? Function(TDate? day);

enum CalendarType { single, multiple, range }

enum CalendarTrigger { closeBtn, confirmBtn, overlay }

enum DateSelectType { selected, disabled, start, centre, end, empty }

/// 日历组件
class TDCalendar extends StatefulWidget {
  const TDCalendar({
    Key? key,
    this.firstDayOfWeek = 0,
    this.format,
    this.maxDate,
    this.minDate,
    this.title,
    this.titleWidget,
    this.type = CalendarType.single,
    this.value,
    this.displayFormat = 'year month',
    this.cellHeight = 60,
    this.height,
    this.width,
    this.style,
    this.onChange,
    this.onCellClick,
    this.onCellLongPress,
    this.onHeanderClick,
  }) : super(key: key);

  /// 第一天从星期几开始，默认 0 = 周日
  final int? firstDayOfWeek;

  /// 用于格式化日期的函数，可定义日期前后的显示内容和日期样式
  final CalendarFormat? format;

  /// 最大可选的日期(fromMillisecondsSinceEpoch)，不传则默认半年后
  final int? maxDate;

  /// 最小可选的日期(fromMillisecondsSinceEpoch)，不传则默认今天
  final int? minDate;

  /// 标题
  final String? title;

  /// 标题组件
  final Widget? titleWidget;

  /// 日历的选择类型，single = 单选；multiple = 多选; range = 区间选择
  final CalendarType? type;

  /// 当前选择的日期(fromMillisecondsSinceEpoch)，不传则默认今天，当 type = single 时数组长度为1
  final List<int>? value;

  /// 年月显示格式，`year`表示年，`month`表示月，如`year month`表示年在前、月在后、中间隔一个空格
  final String? displayFormat;

  /// 高度
  final double? height;

  /// 日期高度
  final double? cellHeight;

  /// 宽度
  final double? width;

  /// 自定义样式
  final TDCalendarStyle? style;

  /// 选中值变化时触发
  final void Function(List<int> value)? onChange;

  /// 点击日期时触发
  final void Function(int value, DateSelectType type, TDate tdate)? onCellClick;

  /// 长安日期时触发
  final void Function(int value, DateSelectType type, TDate tdate)? onCellLongPress;

  /// 点击周时触发
  final void Function(int index, String week)? onHeanderClick;

  List<DateTime>? get _value => value?.map((e) {
        final date = DateTime.fromMillisecondsSinceEpoch(e);
        return DateTime(date.year, date.month, date.day);
      }).toList();

  @override
  _TDCalendarState createState() => _TDCalendarState();
}

class _TDCalendarState extends State<TDCalendar> {
  late List<String> weekdayNames;
  late List<String> monthNames;
  late TDCalendarInherited? inherited;
  late TDCalendarStyle _style;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    weekdayNames = [
      context.resource.sunday,
      context.resource.monday,
      context.resource.tuesday,
      context.resource.wednesday,
      context.resource.thursday,
      context.resource.friday,
      context.resource.saturday,
    ];
    monthNames = [
      context.resource.january,
      context.resource.february,
      context.resource.march,
      context.resource.april,
      context.resource.may,
      context.resource.june,
      context.resource.july,
      context.resource.august,
      context.resource.september,
      context.resource.october,
      context.resource.november,
      context.resource.december,
    ];
    _style = widget.style ?? TDCalendarStyle.generateStyle(context);
  }

  @override
  void didUpdateWidget(TDCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      inherited?.selected.value = widget.value ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    inherited = TDCalendarInherited.of(context);
    inherited?.selected.value = widget.value ?? [];
    final verticalGap = TDTheme.of(context).spacer8;
    return Container(
      height: widget.height,
      width: widget.width ?? double.infinity,
      decoration: _style.decoration,
      child: Column(
        children: [
          TDCalendarHeader(
            firstDayOfWeek: widget.firstDayOfWeek ?? 0,
            weekdayGap: TDTheme.of(context).spacer4,
            padding: TDTheme.of(context).spacer16,
            weekdayStyle: _style.weekdayStyle,
            weekdayHeight: 46,
            title: widget.title,
            titleStyle: _style.titleStyle,
            titleWidget: widget.titleWidget,
            titleMaxLine: _style.titleMaxLine,
            titleOverflow: TextOverflow.ellipsis,
            closeBtn: inherited?.usePopup ?? false,
            closeColor: _style.titleCloseColor,
            weekdayNames: weekdayNames,
            onClose: inherited?.onClose,
            onClick: widget.onHeanderClick,
          ),
          Expanded(
            child: TDCalendarBody(
              type: widget.type ?? CalendarType.single,
              firstDayOfWeek: widget.firstDayOfWeek ?? 0,
              maxDate: widget.maxDate,
              minDate: widget.minDate,
              value: widget._value,
              bodyPadding: TDTheme.of(context).spacer16,
              displayFormat: widget.displayFormat ?? 'year month',
              monthNames: monthNames,
              monthTitleStyle: _style.monthTitleStyle,
              verticalGap: verticalGap,
              builder: (date, dateList, data, rowIndex, colIndex) {
                return TDCalendarCell(
                  height: widget.cellHeight ?? 60,
                  tdate: date,
                  format: widget.format,
                  type: widget.type ?? CalendarType.single,
                  data: data,
                  padding: verticalGap / 2,
                  onChange: (value) {
                    inherited?.selected.value = value;
                    widget.onChange?.call(value);
                  },
                  onCellClick: widget.onCellClick,
                  onCellLongPress: widget.onCellLongPress,
                  dateList: dateList,
                  rowIndex: rowIndex,
                  colIndex: colIndex,
                );
              },
            ),
          ),
          if (inherited?.usePopup == true)
            inherited?.confirmBtn ??
                Padding(
                  padding: EdgeInsets.symmetric(vertical: TDTheme.of(context).spacer16),
                  child: TDButton(
                    theme: TDButtonTheme.primary,
                    text: '确定',
                    isBlock: true,
                    size: TDButtonSize.large,
                    onTap: inherited?.onConfirm,
                  ),
                ),
        ],
      ),
    );
  }
}

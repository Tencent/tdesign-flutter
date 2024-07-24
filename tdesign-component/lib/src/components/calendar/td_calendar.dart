import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
export 'td_calendar_date.dart';
export 'td_calendar_header.dart';
export 'td_calendar_style.dart';

typedef CalendarFormatType = TDate Function(TDate day);

enum CalendarType { single, multiple, range }

/// 单元格组件
class TDCalendar extends StatefulWidget {
  const TDCalendar({
    Key? key,
    this.autoClose = true,
    this.confirmBtn,
    this.firstDayOfWeek = 0,
    this.format,
    this.maxDate,
    this.minDate,
    this.title,
    this.titleWidget,
    this.type = CalendarType.single,
    this.usePopup = true,
    this.value,
    this.visible = false,
    this.style,
  }) : super(key: key);

  /// 自动关闭；在点击关闭按钮、确认按钮、遮罩层时自动关闭，不需要手动设置 visible
  final bool? autoClose;

  /// 自定义确认按钮
  final Widget? confirmBtn;

  /// 第一天从星期几开始，默认 0 = 周日
  final int? firstDayOfWeek;

  /// 用于格式化日期的函数
  final CalendarFormatType? format;

  /// 最大可选的日期，不传则默认半年后
  final int? maxDate;

  /// 最小可选的日期，不传则默认今天
  final int? minDate;

  /// 标题
  final String? title;

  /// 标题组件
  final Widget? titleWidget;

  /// 日历的选择类型，single = 单选；multiple = 多选; range = 区间选择
  final CalendarType? type;

  /// 是否使用弹出层包裹日历
  final bool? usePopup;

  /// 当前选择的日期，不传则默认今天，当 type = single 时数组长度为1
  final List<int>? value;

  /// 是否显示日历；[usePopup] 为 true 时有效
  final bool? visible;

  /// 自定义样式
  final TDCalendarStyle? style;

  @override
  _TDCalendarState createState() => _TDCalendarState();
}

class _TDCalendarState extends State<TDCalendar> {
  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? TDCalendarStyle.generateStyle(context);
    return Column(
      children: [
        TDCalendarHeader(
          firstDayOfWeek: widget.firstDayOfWeek ?? 0,
          weekdayGap: TDTheme.of(context).spacer4,
          padding: TDTheme.of(context).spacer16,
          weekdayStyle: style.weekdayStyle,
          weekdayHeight: 46,
          title: widget.title,
          titleStyle: widget.title?.isNotEmpty == true
              ? TextStyle(
                  fontSize: TDTheme.of(context).fontTitleLarge?.size,
                  fontWeight: TDTheme.of(context).fontTitleLarge?.fontWeight,
                  color: TDTheme.of(context).fontGyColor1,
                )
              : null,
          titleWidget: widget.titleWidget,
        ),
      ],
    );
  }
}

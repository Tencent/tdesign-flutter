import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';

export 'td_calendar_body.dart';
export 'td_calendar_cell.dart';
export 'td_calendar_header.dart';
export 'td_calendar_style.dart';

typedef CalendarFormat = TDate? Function(TDate? day);

enum CalendarType { single, multiple, range }

enum CalendarTrigger { closeBtn, confirmBtn, overlay }

enum DateSelectType { selected, disabled, start, centre, end, empty }

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
    this.displayFormat = 'year month',
    this.cellHeight = 60,
    this.height,
    this.width,
    this.style,
    this.onChange,
    this.onClose,
    this.onConfirm,
    this.onSelect,
  }) : super(key: key);

  /// 自动关闭；在点击关闭按钮、确认按钮、遮罩层时自动关闭，不需要手动设置 visible
  final bool? autoClose;

  /// 自定义确认按钮
  final Widget? confirmBtn;

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

  /// 是否使用弹出层包裹日历
  final bool? usePopup;

  /// 当前选择的日期(fromMillisecondsSinceEpoch)，不传则默认今天，当 type = single 时数组长度为1
  final List<int>? value;

  /// 是否显示日历；[usePopup] 为 true 时有效
  final bool? visible;

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

  /// 关闭时触发
  final void Function(CalendarTrigger trigger)? onClose;

  /// 点击确认按钮时触发
  final void Function(List<int> value)? onConfirm;

  /// 点击日期时触发
  final void Function(int value, DateSelectType type)? onSelect;

  @override
  _TDCalendarState createState() => _TDCalendarState();
}

class _TDCalendarState extends State<TDCalendar> {
  late List<String> weekdayNames;
  late List<String> monthNames;

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
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? TDCalendarStyle.generateStyle(context);
    return SizedBox(
      height: widget.height,
      width: widget.height ?? double.infinity,
      child: Column(
        children: [
          TDCalendarHeader(
            firstDayOfWeek: widget.firstDayOfWeek ?? 0,
            weekdayGap: TDTheme.of(context).spacer4,
            padding: TDTheme.of(context).spacer16,
            weekdayStyle: style.weekdayStyle,
            weekdayHeight: 46,
            title: widget.title,
            titleStyle: style.titleStyle,
            titleWidget: widget.titleWidget,
            titleMaxLine: style.titleMaxLine,
            titleOverflow: TextOverflow.ellipsis,
            closeBtn: widget.usePopup ?? true,
            closeColor: style.titleCloseColor,
            weekdayNames: weekdayNames,
            onClose: () {},
          ),
          Expanded(
            child: TDCalendarBody(
              type: widget.type ?? CalendarType.single,
              firstDayOfWeek: widget.firstDayOfWeek ?? 0,
              maxDate: widget.maxDate,
              minDate: widget.minDate,
              value: widget.value,
              bodyPadding: TDTheme.of(context).spacer16,
              displayFormat: widget.displayFormat ?? 'year month',
              monthNames: monthNames,
              monthTitleStyle: style.monthTitleStyle,
              horizontalGap: TDTheme.of(context).spacer4,
              verticalGap: TDTheme.of(context).spacer8,
              builder: (date, data, index) {
                return TDCalendarCell(
                  height: widget.cellHeight ?? 60,
                  tdate: date,
                  format: widget.format,
                  type: widget.type ?? CalendarType.single,
                  data: data,
                  padding: TDTheme.of(context).spacer4,
                  onChange: widget.onChange,
                  onSelect: widget.onSelect,
                  isRowLast: index == 6,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

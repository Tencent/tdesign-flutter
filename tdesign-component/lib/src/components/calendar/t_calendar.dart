import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';
import '../../util/iterable_ext.dart';

export 't_calendar_body.dart';
export 't_calendar_cell.dart';
export 't_calendar_header.dart';
export 't_calendar_popup.dart';
export 't_calendar_style.dart';
export 't_calendar_data_source.dart';
export 't_lunar_date.dart';

typedef CalendarFormat = TDate? Function(TDate? day);

/// 底部自定义区域构建器
/// [context] 当前上下文
/// [selectedDates] 当前选中的日期列表（毫秒时间戳）
typedef CalendarBottomBuilder = Widget Function(
  BuildContext context,
  List<int> selectedDates,
);

enum CalendarType { single, multiple, range }

enum CalendarTrigger { closeBtn, confirmBtn, overlay }

enum DateSelectType { selected, disabled, start, centre, end, empty }

/// 日历组件
class TCalendar extends StatefulWidget {
  const TCalendar({
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
    this.onHeaderClick,
    this.useSafeArea = true,
    this.bottom,
    this.bottomExpanded = true,
    this.bottomExpandedListenable,
    this.monthTitleHeight = 22,
    this.monthTitleBuilder,
    this.animateTo = false,
    this.cellWidget,
    this.onMonthChange,
    this.anchorDate,
    this.dateType = TCalendarDateType.solar,
    this.dataSource,
    this.showLunarInfo = false,
  }) : super(key: key);

  /// 第一天从星期几开始，默认 0 = 周日
  final int? firstDayOfWeek;

  /// 用于格式化日期的函数，可定义日期前后的显示内容和日期样式
  final CalendarFormat? format;

  /// 最大可选的日期（fromMillisecondsSinceEpoch），不传则默认半年后
  final int? maxDate;

  /// 最小可选的日期（fromMillisecondsSinceEpoch），不传则默认今天
  final int? minDate;

  /// 标题
  final String? title;

  /// 标题组件
  final Widget? titleWidget;

  /// 日历的选择类型，single = 单选；multiple = 多选；range = 区间选择
  final CalendarType? type;

  /// 当前选择的日期（fromMillisecondsSinceEpoch），不传则默认今天，当 type = single 时数组长度为1
  final List<int>? value;

  /// 年月显示格式，`year`表示年，`month`表示月，如`year month`表示年在前、月在后、中间隔一个空格
  final String? displayFormat;

  /// 高度
  final double? height;

  /// 日期高度
  final double? cellHeight;

  /// 宽度
  final double? width;

  ///锚点日期
  final DateTime? anchorDate;

  /// 自定义样式
  final TCalendarStyle? style;

  /// 选中值变化时触发
  final void Function(List<int> value)? onChange;

  /// 点击日期时触发
  final void Function(
    int value,
    DateSelectType type,
    TDate tdate,
  )? onCellClick;

  /// 长安日期时触发
  final void Function(
    int value,
    DateSelectType type,
    TDate tdate,
  )? onCellLongPress;

  /// 点击周时触发
  final void Function(
    int index,
    String week,
  )? onHeaderClick;

  /// 月份变化时触发
  final ValueChanged<DateTime>? onMonthChange;

  /// 是否使用安全区域，默认true
  final bool? useSafeArea;

  /// 底部自定义区域构建器，位于日历主体浮层上方
  final CalendarBottomBuilder? bottom;

  /// bottom 区域是否展开，默认 true
  final bool bottomExpanded;

  /// bottom 区域是否展开（响应式版本，优先级高于 [bottomExpanded]）。
  /// 传入后，bottom 展开/收起会跟随该 listenable 变化自动播放动画。
  final ValueListenable<bool>? bottomExpandedListenable;

  /// 月标题高度
  final double? monthTitleHeight;

  /// 月标题构建器
  final Widget Function(
    BuildContext context,
    DateTime monthDate,
  )? monthTitleBuilder;

  /// 动画滚动到指定位置
  final bool? animateTo;

  /// 自定义日期单元格组件
  final Widget? Function(
    BuildContext context,
    TDate tdate,
    DateSelectType selectType,
  )? cellWidget;

  /// 日历类型：阳历或农历
  final TCalendarDateType dateType;

  /// 外部数据源，用于提供农历转换等功能
  final TCalendarDataSource? dataSource;

  /// 阳历模式下是否显示农历信息作为副标题
  final bool showLunarInfo;

  List<DateTime>? get _value => value?.map((e) {
        final date = DateTime.fromMillisecondsSinceEpoch(e);
        return DateTime(date.year, date.month, date.day);
      }).toList();

  @override
  _TCalendarState createState() => _TCalendarState();
}

class _TCalendarState extends State<TCalendar> {
  late List<String> weekdayNames;
  late List<String> monthNames;
  late TCalendarInherited? inherited;
  late TCalendarStyle _style;

  /// bottom 展开时日历主体固定上移高度
  static const double _bottomOffset = 30.0;

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
    _style = widget.style ?? TCalendarStyle.generateStyle(context);
  }

  @override
  Widget build(BuildContext context) {
    inherited = TCalendarInherited.of(context);
    _initValue();
    final verticalGap = _style.verticalGap ?? TTheme.of(context).spacer8;
    final hasBottom = widget.bottom != null;

    if (widget.bottomExpandedListenable != null) {
      // 响应式：监听 listenable 变化，让 padding 与 bottom 区动画同步重建
      return ValueListenableBuilder<bool>(
        valueListenable: widget.bottomExpandedListenable!,
        builder: (context, expanded, _) {
          return _buildBody(context, verticalGap, hasBottom, expanded);
        },
      );
    }
    return _buildBody(context, verticalGap, hasBottom, widget.bottomExpanded);
  }

  Widget _buildBody(
      BuildContext context, double verticalGap, bool hasBottom, bool expanded) {
    final bottomPadding = hasBottom && expanded ? _bottomOffset : 0.0;

    return Container(
      height: widget.height,
      width: widget.width ?? double.infinity,
      decoration: _style.decoration,
      child: Stack(
        children: [
          Column(
            children: [
              TCalendarHeader(
                firstDayOfWeek: widget.firstDayOfWeek ?? 0,
                weekdayGap: TTheme.of(context).spacer4,
                padding: TTheme.of(context).spacer16,
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
                onClick: widget.onHeaderClick,
              ),
              Expanded(
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.only(bottom: bottomPadding),
                  child: TCalendarBody(
                    type: widget.type ?? CalendarType.single,
                    firstDayOfWeek: widget.firstDayOfWeek ?? 0,
                    maxDate: widget.maxDate,
                    anchorDate: widget.anchorDate,
                    minDate: widget.minDate,
                    value: widget._value,
                    bodyPadding:
                        _style.bodyPadding ?? TTheme.of(context).spacer16,
                    displayFormat: widget.displayFormat ?? 'year month',
                    monthNames: monthNames,
                    monthTitleStyle: _style.monthTitleStyle,
                    verticalGap: verticalGap,
                    cellHeight: _getEffectiveCellHeight(),
                    monthTitleHeight: widget.monthTitleHeight ?? 22,
                    monthTitleBuilder: widget.monthTitleBuilder,
                    animateTo: widget.animateTo ?? false,
                    onMonthChange: widget.onMonthChange,
                    dateType: widget.dateType,
                    dataSource: widget.dataSource,
                    builder: (date, dateList, data, rowIndex, colIndex) {
                      return TCalendarCell(
                        height: _getEffectiveCellHeight(),
                        tdate: date,
                        format: widget.format,
                        type: widget.type ?? CalendarType.single,
                        data: data,
                        padding: verticalGap / 2,
                        onChange: (value) {
                          final time = _getValue(value);
                          inherited?.selected.value = time;
                          widget.onChange?.call(time);
                        },
                        onCellClick: widget.onCellClick,
                        onCellLongPress: widget.onCellLongPress,
                        dateList: dateList,
                        rowIndex: rowIndex,
                        colIndex: colIndex,
                        cellWidget: widget.cellWidget,
                        dateType: widget.dateType,
                        showLunarInfo: widget.showLunarInfo,
                      );
                    },
                  ),
                ),
              ),
              if (inherited?.usePopup == true)
                inherited?.confirmBtn ??
                    Padding(
                      padding: widget.useSafeArea == true
                          ? EdgeInsets.only(top: TTheme.of(context).spacer16)
                          : EdgeInsets.symmetric(
                              vertical: TTheme.of(context).spacer16),
                      child: TButton(
                        theme: TButtonTheme.primary,
                        text: context.resource.confirm,
                        isBlock: true,
                        size: TButtonSize.large,
                        onTap: inherited?.onConfirm,
                      ),
                    ),
              if (widget.useSafeArea == true)
                SizedBox(height: MediaQuery.of(context).padding.bottom)
            ],
          ),
          if (hasBottom) _buildBottom(expanded),
        ],
      ),
    );
  }

  Widget _buildBottom(bool expanded) {
    final bottomOffset = (inherited?.usePopup == true)
        ? (widget.useSafeArea == true
            ? MediaQuery.of(context).padding.bottom +
                TTheme.of(context).spacer16 +
                48
            : TTheme.of(context).spacer16 * 2 + 48)
        : (widget.useSafeArea == true
            ? MediaQuery.of(context).padding.bottom
            : 0.0);

    return Positioned(
      left: 0,
      right: 0,
      bottom: bottomOffset,
      child: ClipRect(
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 200),
          offset: expanded ? Offset.zero : const Offset(0, 1),
          child: inherited != null
              ? ValueListenableBuilder<List<int>>(
                  valueListenable: inherited!.selected,
                  builder: (context, selectedDates, _) {
                    return widget.bottom!(context, selectedDates);
                  },
                )
              : widget.bottom!(context, widget.value ?? []),
        ),
      ),
    );
  }

  List<int> _getValue(List<int> value) {
    return value.map((e) {
      final date = DateTime.fromMillisecondsSinceEpoch(e);
      return DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
    }).toList();
  }

  void _initValue() {
    if (inherited == null) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      inherited!.selected.value = _getValue(widget.value ?? []);
    });
  }
  /// 获取有效的单元格高度
  /// 当显示农历信息时，需要更大的高度以容纳额外的文本
  double _getEffectiveCellHeight() {
    if (widget.cellHeight != null) {
      return widget.cellHeight!;
    }
    // 显示农历信息时使用更大的默认高度（80px 完全避免溢出）
    return widget.showLunarInfo ? 80 : 60;
  }
}

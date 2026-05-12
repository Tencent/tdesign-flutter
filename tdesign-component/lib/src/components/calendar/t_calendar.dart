import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';
import '../../util/iterable_ext.dart';

export 't_calendar_body.dart';
export 't_calendar_cell.dart';
export 't_calendar_data_source.dart';
export 't_calendar_header.dart';
export 't_calendar_popup.dart';
export 't_calendar_style.dart';
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
    this.bottomExpanded,
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

  /// 底部自定义区域构建器，位于日历主体浮层上方。
  ///
  /// `selectedDates` 是当前选中日期的毫秒时间戳列表，会随用户点击单元格自动更新。
  ///
  /// 典型用法：在 bottom 中渲染时间选择器、统计信息、操作按钮等。
  final CalendarBottomBuilder? bottom;

  /// bottom 区域是否展开（响应式）。
  ///
  /// - 传 `null`（默认）：bottom 始终展开
  /// - 传 `ValueListenable<bool>`：bottom 展开/收起会跟随该 listenable 变化播放滑动动画，
  ///   常配合 [ValueNotifier] 实现"按钮触发展开/收起"。
  ///
  /// 示例：
  /// ```dart
  /// final expanded = ValueNotifier<bool>(false);
  /// TCalendar(
  ///   bottomExpanded: expanded,
  ///   onCellClick: (v, t, d) => expanded.value = true,
  ///   bottom: (ctx, dates) => MyFooter(),
  /// );
  /// ```
  final ValueListenable<bool>? bottomExpanded;

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

  /// bottom 展开时日历主体上移高度，露出 bottom "把手"区域
  /// （设计稿固定值，与 [_buildBottom] 的 bottom offset 配合）
  static const double _bottomPeekHeight = 30.0;

  /// 标记是否已完成首次 selected 同步，避免 didChangeDependencies 重复触发
  bool _initializedSelected = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    inherited = TCalendarInherited.of(context);
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
    // 仅首次挂载时同步 widget.value → inherited.selected
    if (!_initializedSelected) {
      _initializedSelected = true;
      _syncSelectedToInherited();
    }
  }

  @override
  void didUpdateWidget(covariant TCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 仅当 widget.value 内容变化时，才重置 inherited.selected
    if (!listEquals(oldWidget.value, widget.value)) {
      _syncSelectedToInherited();
    }
  }

  /// 把 widget.value 同步到 inherited.selected（仅在首次或 value 变化时调用）
  void _syncSelectedToInherited() {
    if (inherited == null) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      inherited!.selected.value = _getValue(widget.value ?? []);
    });
  }

  @override
  Widget build(BuildContext context) {
    final verticalGap = _style.verticalGap ?? TTheme.of(context).spacer8;
    final hasBottom = widget.bottom != null;

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
                child: _buildAnimatedBody(verticalGap, hasBottom),
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
          if (hasBottom) _buildBottom(),
        ],
      ),
    );
  }

  /// 仅在此处监听 bottomExpanded，局部化重建范围（只影响 padding 动画）
  Widget _buildAnimatedBody(double verticalGap, bool hasBottom) {
    if (!hasBottom || widget.bottomExpanded == null) {
      // 无 bottom 或始终展开 → 静态 padding
      final padding = hasBottom ? _bottomPeekHeight : 0.0;
      return Padding(
        padding: EdgeInsets.only(bottom: padding),
        child: _buildCalendarBody(verticalGap),
      );
    }
    // 响应式 → 仅 AnimatedPadding 重建
    return ValueListenableBuilder<bool>(
      valueListenable: widget.bottomExpanded!,
      builder: (context, expanded, child) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.only(
              bottom: expanded ? _bottomPeekHeight : 0.0),
          child: child!,
        );
      },
      child: _buildCalendarBody(verticalGap),
    );
  }

  Widget _buildCalendarBody(double verticalGap) {
    return TCalendarBody(
      type: widget.type ?? CalendarType.single,
      firstDayOfWeek: widget.firstDayOfWeek ?? 0,
      maxDate: widget.maxDate,
      anchorDate: widget.anchorDate,
      minDate: widget.minDate,
      value: widget._value,
      bodyPadding: _style.bodyPadding ?? TTheme.of(context).spacer16,
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
    );
  }

  /// bottom 浮层：仅 AnimatedSlide 响应 expanded，其余内容通过 inherited.selected 驱动
  Widget _buildBottom() {
    final bottomOffset = (inherited?.usePopup == true)
        ? (widget.useSafeArea == true
            ? MediaQuery.of(context).padding.bottom +
                TTheme.of(context).spacer16 +
                48
            : TTheme.of(context).spacer16 * 2 + 48)
        : (widget.useSafeArea == true
            ? MediaQuery.of(context).padding.bottom
            : 0.0);

    // bottom 内容：跟随选中日期更新
    final content = inherited != null
        ? ValueListenableBuilder<List<int>>(
            valueListenable: inherited!.selected,
            builder: (context, selectedDates, _) {
              return widget.bottom!(context, selectedDates);
            },
          )
        : widget.bottom!(context, widget.value ?? []);

    // 如果有 bottomExpanded listenable → 用 ValueListenableBuilder 局部化 slide 动画
    if (widget.bottomExpanded != null) {
      return Positioned(
        left: 0,
        right: 0,
        bottom: bottomOffset,
        child: ClipRect(
          child: ValueListenableBuilder<bool>(
            valueListenable: widget.bottomExpanded!,
            builder: (context, expanded, child) {
              return AnimatedSlide(
                duration: const Duration(milliseconds: 200),
                offset: expanded ? Offset.zero : const Offset(0, 1),
                child: child!,
              );
            },
            child: content,
          ),
        ),
      );
    }

    // 无 listenable → 始终展开
    return Positioned(
      left: 0,
      right: 0,
      bottom: bottomOffset,
      child: content,
    );
  }

  List<int> _getValue(List<int> value) {
    return value.map((e) {
      final date = DateTime.fromMillisecondsSinceEpoch(e);
      return DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
    }).toList();
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

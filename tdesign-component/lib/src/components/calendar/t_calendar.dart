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

/// [TCalendar.bottom] 的构建器签名。`selectedDates` 为只读视图，详细行为见 [TCalendar.bottom]。
typedef CalendarBottomBuilder = Widget Function(
  BuildContext context,
  List<int> selectedDates,
);

enum CalendarType { single, multiple, range }

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
  })  : assert(
          bottomExpanded == null || bottom != null,
          'bottomExpanded 需配合 bottom 使用',
        ),
        super(key: key);

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

  /// 锚点日期
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

  /// 长按日期时触发
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

  /// 是否使用安全区域（默认 true）
  final bool? useSafeArea;

  /// 底部自定义区域构建器，以浮层方式叠加在日历主体之上。
  ///
  /// **仅能在 [TCalendarPopup] 内使用**（作为其 [child] / [builder] 的子树）。
  ///
  /// - **不会撑高 [TCalendar]**，请在 [height] 中预留 bottom 自身的占用高度；
  /// - `selectedDates` 随弹窗内日期点击实时更新；
  /// - 传入的 `selectedDates` 是只读视图（[List.unmodifiable]），请勿原地修改。
  ///
  /// ```dart
  /// TCalendarPopup(
  ///   context,
  ///   child: TCalendar(
  ///     height: 600,
  ///     bottom: (ctx, dates) => MyFooter(selectedDates: dates),
  ///   ),
  /// );
  /// ```
  final CalendarBottomBuilder? bottom;

  /// bottom 区域是否展开（响应式）。**仅能在 [TCalendarPopup] 内使用。**
  ///
  /// 为 `null`（默认）时 bottom 始终展开；传入 [ValueListenable] 时，
  /// bottom 展开/收起将跟随其值变化播放滑动动画，常配合 [ValueNotifier] 使用。
  ///
  /// ```dart
  /// final expanded = ValueNotifier<bool>(false);
  /// TCalendarPopup(
  ///   context,
  ///   child: TCalendar(
  ///     bottomExpanded: expanded,
  ///     onCellClick: (v, t, d) => expanded.value = true,
  ///     bottom: (ctx, dates) => MyFooter(),
  ///   ),
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
  TCalendarInherited? inherited;
  late TCalendarStyle _style;

  List<DateTime>? _cachedValueDates;

  // bottom 展开时日历主体上移的距离，露出 bottom 顶部"把手"区域。
  static const double _bottomPeekHeight = 30.0;

  static const double _confirmBtnHeight = 48.0;
  static const Duration _animDuration = Duration(milliseconds: 200);
  static const Curve _animCurve = Curves.easeInOut;

  bool _initializedSelected = false;

  bool get _usePopupBottom => inherited?.usePopup == true;

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
    if (!_initializedSelected) {
      _initializedSelected = true;
      _refreshValueCache();
      _syncSelectedToInheritedSync();
    }
  }

  @override
  void didUpdateWidget(covariant TCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.value, widget.value)) {
      _refreshValueCache();
      _syncSelectedToInheritedDeferred();
    }
  }

  void _refreshValueCache() {
    _cachedValueDates = widget._value;
  }

  void _assertPopupOnlyBottom() {
    assert(
      widget.bottom == null || _usePopupBottom,
      '[TCalendar] bottom 仅能在 TCalendarPopup 内使用',
    );
    assert(
      widget.bottomExpanded == null || _usePopupBottom,
      '[TCalendar] bottomExpanded 仅能在 TCalendarPopup 内使用',
    );
  }

  // 仅在非 build phase 调用。
  void _syncSelectedToInheritedSync() {
    if (inherited == null) {
      return;
    }
    inherited!.selected.value = _getValue(widget.value ?? const <int>[]);
  }

  // 适用于 build phase 调用，写操作延迟到下一帧。
  void _syncSelectedToInheritedDeferred() {
    if (inherited == null) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || inherited == null) {
        return;
      }
      inherited!.selected.value = _getValue(widget.value ?? const <int>[]);
    });
  }

  @override
  Widget build(BuildContext context) {
    _assertPopupOnlyBottom();
    final verticalGap = _style.verticalGap ?? TTheme.of(context).spacer8;
    final hasBottom = widget.bottom != null && _usePopupBottom;

    Widget stackContent(bool bottomExpanded) {
      return Stack(
        children: [
          _buildMainColumn(verticalGap, hasBottom, bottomExpanded),
          if (hasBottom) _buildBottom(bottomExpanded),
        ],
      );
    }

    final child = hasBottom && widget.bottomExpanded != null
        ? ValueListenableBuilder<bool>(
            valueListenable: widget.bottomExpanded!,
            builder: (context, expanded, _) => stackContent(expanded),
          )
        : stackContent(hasBottom);

    return Container(
      height: widget.height,
      width: widget.width ?? double.infinity,
      decoration: _style.decoration,
      child: child,
    );
  }

  Widget _buildMainColumn(
    double verticalGap,
    bool hasBottom,
    bool bottomExpanded,
  ) {
    return Column(
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
          child: _buildBodyArea(verticalGap, hasBottom, bottomExpanded),
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
    );
  }

  Widget _buildBodyArea(
    double verticalGap,
    bool hasBottom,
    bool bottomExpanded,
  ) {
    final body = _buildCalendarBody(verticalGap);
    if (!hasBottom) {
      return body;
    }
    if (widget.bottomExpanded == null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: _bottomPeekHeight),
        child: body,
      );
    }
    return AnimatedPadding(
      duration: _animDuration,
      curve: _animCurve,
      padding: EdgeInsets.only(
        bottom: bottomExpanded ? _bottomPeekHeight : 0.0,
      ),
      child: body,
    );
  }

  Widget _buildCalendarBody(double verticalGap) {
    return TCalendarBody(
      type: widget.type ?? CalendarType.single,
      firstDayOfWeek: widget.firstDayOfWeek ?? 0,
      maxDate: widget.maxDate,
      anchorDate: widget.anchorDate,
      minDate: widget.minDate,
      value: _cachedValueDates,
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
          onChange: _handleCellChange,
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

  void _handleCellChange(List<int> value) {
    final time = _getValue(value);
    inherited?.selected.value = time;
    widget.onChange?.call(time);
  }

  // 行为约定详见 [TCalendar.bottom]。
  Widget _buildBottom(bool bottomExpanded) {
    assert(widget.bottom != null);
    assert(inherited != null);

    final bottomOffset = _calcBottomOffset();

    final content = ValueListenableBuilder<List<int>>(
      valueListenable: inherited!.selected,
      builder: (context, selectedDates, _) {
        return widget.bottom!(
          context,
          List<int>.unmodifiable(selectedDates),
        );
      },
    );

    if (widget.bottomExpanded != null) {
      return Positioned(
        left: 0,
        right: 0,
        bottom: bottomOffset,
        child: ClipRect(
          child: AnimatedSlide(
            duration: _animDuration,
            curve: _animCurve,
            offset: bottomExpanded ? Offset.zero : const Offset(0, 1),
            child: content,
          ),
        ),
      );
    }

    return Positioned(
      left: 0,
      right: 0,
      bottom: bottomOffset,
      child: content,
    );
  }

  // 该值需与 build() 中 Column 底部区域（confirmBtn padding + safeArea）保持一致；
  // 修改底部布局时需同步更新本方法。
  double _calcBottomOffset() {
    final safeBottom = widget.useSafeArea == true
        ? MediaQuery.of(context).padding.bottom
        : 0.0;

    if (inherited?.usePopup == true) {
      final btnPadding = widget.useSafeArea == true
          ? TTheme.of(context).spacer16
          : TTheme.of(context).spacer16 * 2;
      // 仅默认确认按钮使用固定高度；自定义 confirmBtn 由调用方保证 bottom 不重叠。
      final btnHeight =
          inherited?.confirmBtn == null ? _confirmBtnHeight : 0.0;
      return safeBottom + btnPadding + btnHeight;
    }

    return safeBottom;
  }

  List<int> _getValue(List<int> value) {
    return value.map((e) {
      final date = DateTime.fromMillisecondsSinceEpoch(e);
      return DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
    }).toList();
  }

  double _getEffectiveCellHeight() {
    if (widget.cellHeight != null) {
      return widget.cellHeight!;
    }
    return widget.showLunarInfo ? 80 : 60;
  }
}

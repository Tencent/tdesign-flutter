import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';
import '../../util/iterable_ext.dart';
import 't_calendar_body.dart';
import 't_calendar_cell.dart';
import 't_calendar_header.dart';

export 't_calendar_cell.dart' show TDate, DateSelectTypeNotifier;
export 't_calendar_data_source.dart';
export 't_calendar_style.dart';
export 't_lunar_date.dart';

// ---------------------------------------------------------------------------
// TCalendarInherited — 日历弹窗状态托管，供 TCalendar 内部读取
// ---------------------------------------------------------------------------

/// 日历弹窗状态的 InheritedWidget 容器。
///
/// 由上层（如 [TSlidePopupRoute] 的 builder）包裹在 [TCalendar] 外侧，
/// 将选中态、确认/关闭回调等注入子树。
class TCalendarInherited extends InheritedWidget {
  const TCalendarInherited({
    required Widget child,
    this.onClose,
    required this.selected,
    this.usePopup = true,
    this.popupControls = true,
    this.popupConfirmBtn,
    this.onConfirm,
    this.confirmBtn,
    Key? key,
  }) : super(child: child, key: key);

  final VoidCallback? onClose;

  /// 选中态的可写引用（仅供 [TCalendar] 内部更新使用）。
  ///
  /// 对外消费方请使用 [selectedListenable] 这一只读视图。
  final ValueNotifier<List<DateTime>> selected;

  /// 选中态的只读视图，供下游 widget 监听变化。
  ValueListenable<List<DateTime>> get selectedListenable => selected;

  final bool? usePopup;

  /// 是否由 [TCalendar] 自行渲染关闭按钮和标题行。
  ///
  /// 为 `true`（默认）时 [TCalendar] 渲染关闭按钮与标题行；
  /// 为 `false` 时由外层面板（如 [TPopupBottomDisplayPanel]）承载。
  final bool popupControls;

  /// 是否由 [TCalendar] 渲染底部确认按钮。
  ///
  /// 为 `null`（默认）时跟随 [popupControls]；显式设置时覆盖。
  final bool? popupConfirmBtn;

  /// 实际是否渲染底部确认按钮。
  bool get effectivePopupConfirmBtn => popupConfirmBtn ?? popupControls;

  final VoidCallback? onConfirm;
  final Widget? confirmBtn;

  @override
  bool updateShouldNotify(covariant TCalendarInherited oldWidget) => false;

  static TCalendarInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TCalendarInherited>();
  }
}

/// 日历选择模式
enum CalendarType {
  /// 单选：点击新日期时自动取消旧日期的选中状态
  single,

  /// 多选：点击日期切换选中/取消，可同时选中多个日期
  multiple,

  /// 区间选择：第一次点击选起点，第二次点击选终点，中间自动填充
  range,
}

/// 日期在日历中的选中状态
enum DateSelectType { selected, disabled, start, centre, end, empty }

/// 日历显示模式，控制日期单元格的主/副文本内容
enum TCalendarDisplayMode {
  /// 纯阳历：主文本显示阳历日期数字，无副文本
  solar,

  /// 阳历 + 农历副标题：主文本显示阳历日期数字，副文本显示农历（如"初七"）
  solarWithLunar,

  /// 农历为主：主文本显示农历（如"初七"），副文本显示阳历日期数字
  lunar,
}

/// 日历组件
class TCalendar extends StatefulWidget {
  const TCalendar({
    Key? key,
    this.firstDayOfWeek = 0,
    this.maxDate,
    this.minDate,
    this.titleWidget,
    this.type = CalendarType.single,
    this.initialValue,
    this.cellHeight,
    this.height,
    this.style,
    this.onChange,
    this.onCellClick,
    this.safeAreaInset = true,
    this.popupBottomBuilder,
    this.popupBottomExpanded,
    this.monthTitleHeight = 22,
    this.monthTitleBuilder,
    this.animateTo = false,
    this.cellWidget,
    this.onMonthChange,
    this.anchorDate,
    this.displayMode = TCalendarDisplayMode.solar,
    this.dataSource,
  })  : assert(
          popupBottomExpanded == null || popupBottomBuilder != null,
          'popupBottomExpanded 需配合 popupBottomBuilder 使用',
        ),
        super(key: key);

  /// 第一天从星期几开始，0 = 周日，1 = 周一，…，6 = 周六。默认 0（周日）。
  final int firstDayOfWeek;

  /// 最大可选的日期，不传则默认 2100-12-31
  final DateTime? maxDate;

  /// 最小可选的日期，不传则默认 1970-01-01
  final DateTime? minDate;

  /// 标题组件，可传入 Text 或自定义 Widget
  final Widget? titleWidget;

  /// 日历的选择模式，决定点击日期后的选中行为：
  /// - [CalendarType.single]：单选，点击新日期取消旧选中
  /// - [CalendarType.multiple]：多选，点击切换选中/取消
  /// - [CalendarType.range]：区间选择，依次选起止日期
  final CalendarType type;

  /// 初始选中日期列表，不传则默认今天。
  ///
  /// 列表长度与 [type] 对应：
  /// - [CalendarType.single]：1 个元素（选中日期）
  /// - [CalendarType.multiple]：N 个元素（所有选中日期）
  /// - [CalendarType.range]：2 个元素（起始、结束日期）
  final List<DateTime>? initialValue;

  /// 高度，不传时内嵌模式自动按 5 行日期计算
  final double? height;

  /// 日期单元格高度，默认 60。如需更大行高可传入自定义值（如 80）
  final double? cellHeight;

  /// 自定义样式
  final TCalendarStyle? style;

  /// 选中值变化时触发
  final void Function(List<DateTime> value)? onChange;

  /// 点击日期时触发
  final void Function(
    DateTime value,
    DateSelectType selectType,
    TDate tdate,
  )? onCellClick;

  /// 月份变化时触发
  final ValueChanged<DateTime>? onMonthChange;

  /// 是否适配底部安全区域（如 iPhone Home Indicator），默认 true
  final bool safeAreaInset;

  /// 弹窗底部自定义区域构建器，以浮层方式叠加在日历主体之上。
  ///
  /// **仅在弹窗模式下生效**（即 [TCalendar] 作为 [TPopupBottomDisplayPanel] 的子树时）。
  /// 非弹窗模式下传入此参数将被忽略。
  ///
  /// - **不会撑高 [TCalendar]**，请在 `popupHeight` 中预留 bottom 自身的占用高度；
  /// - `selectedDates` 随弹窗内日期点击实时更新；
  /// - 传入的 `selectedDates` 是只读视图（[List.unmodifiable]），请勿原地修改。
  ///
  /// ```dart
  /// TPopupBottomDisplayPanel(
  ///   fixedHeight: 600,
  ///   child: TCalendar(
  ///     popupBottomBuilder: (ctx, dates) => MyFooter(selectedDates: dates),
  ///   ),
  /// );
  /// ```
  final Widget Function(BuildContext context, List<DateTime> selectedDates)?
      popupBottomBuilder;

  /// 弹窗底部区域是否展开（响应式）。**仅在弹窗模式下生效。**
  ///
  /// 为 `null`（默认）时 bottom 始终展开；传入 [ValueListenable] 时，
  /// bottom 展开/收起将跟随其值变化播放滑动动画，常配合 [ValueNotifier] 使用。
  ///
  /// ```dart
  /// final expanded = ValueNotifier<bool>(false);
  /// TPopupBottomDisplayPanel(
  ///   fixedHeight: 600,
  ///   child: TCalendar(
  ///     popupBottomExpanded: expanded,
  ///     onCellClick: (v, t, d) => expanded.value = true,
  ///     popupBottomBuilder: (ctx, dates) => MyFooter(),
  ///   ),
  /// );
  /// ```
  final ValueListenable<bool>? popupBottomExpanded;

  /// 每月标题行高度（如 '2025年6月' 所在行），默认 22
  final double monthTitleHeight;

  /// 月标题构建器
  final Widget Function(
    BuildContext context,
    DateTime monthDate,
  )? monthTitleBuilder;

  /// 滚动到选中日期/锚点日期所在月份时是否使用动画，默认 false
  final bool animateTo;

  /// 自定义日期单元格组件
  final Widget? Function(
    BuildContext context,
    TDate tdate,
    DateSelectType selectType,
  )? cellWidget;

  /// 锚点日期，弹出时自动滚动到该日期所在月份。
  /// 传入 [DateTime] 对象，如 `DateTime(2025, 6, 15)`。
  final DateTime? anchorDate;

  /// 日历显示模式，控制日期单元格的主/副文本内容：
  /// - [TCalendarDisplayMode.solar]：纯阳历，主文本显示阳历日期数字
  /// - [TCalendarDisplayMode.solarWithLunar]：阳历 + 农历副标题
  /// - [TCalendarDisplayMode.lunar]：农历为主文本，阳历为副文本
  final TCalendarDisplayMode displayMode;

  /// 外部数据源，用于提供农历转换等功能。
  /// 当 [displayMode] 为 [TCalendarDisplayMode.solarWithLunar] 或
  /// [TCalendarDisplayMode.lunar] 时必须提供。
  final TCalendarDataSource? dataSource;

  List<DateTime>? get _value => initialValue?.map((e) {
        return DateTime(e.year, e.month, e.day);
      }).toList();

  // ---------------------------------------------------------------------------
  // 默认高度计算常量
  // ---------------------------------------------------------------------------
  static const double _kPanelHeaderHeight = 58.0;
  static const double _kWeekdayHeight = 46.0;
  static const double _kMonthTitleHeight = 22.0;
  static const double _kCellHeight = 60.0;
  static const double _kVerticalGap = 8.0;
  static const int _kVisibleRows = 5;
  static const double _kConfirmBtnAreaHeight = 64.0;
  static const double _kBodyPadding = 16.0;
  static const double _kPopupHeightRatio = 0.9;

  static double _calcDefaultHeight(double safeBottom, double screenHeight) {
    const calendarContentHeight = _kWeekdayHeight +
        _kMonthTitleHeight +
        _kVisibleRows * (_kVerticalGap + _kCellHeight) +
        _kBodyPadding * 2;
    final idealHeight = _kPanelHeaderHeight +
        calendarContentHeight +
        _kConfirmBtnAreaHeight +
        safeBottom;
    return idealHeight.clamp(0.0, screenHeight * _kPopupHeightRatio);
  }

  /// 弹出日历选择器，返回选中的日期列表。
  ///
  /// 取消或关闭弹窗时返回 `null`；点击确认时返回选中的 [DateTime] 列表。
  ///
  /// ```dart
  /// final result = await TCalendar.showPopup(
  ///   context,
  ///   titleWidget: Text('请选择日期'),
  ///   type: CalendarType.single,
  /// );
  /// if (result != null) {
  ///   print('选中了: $result');
  /// }
  /// ```
  ///
  /// 若需完全自定义布局，请直接使用 [TCalendar] + [TPopupBottomDisplayPanel]
  /// + [TSlidePopupRoute] 自行组装。
  static Future<List<DateTime>?> showPopup(
    BuildContext context, {
    /// 弹窗标题组件
    Widget? titleWidget,

    /// 日历选择模式
    CalendarType type = CalendarType.single,

    /// 初始选中日期列表
    List<DateTime>? initialValue,

    /// 最小可选日期
    DateTime? minDate,

    /// 最大可选日期
    DateTime? maxDate,

    /// 锚点日期，弹出时自动滚动到该日期所在月份
    DateTime? anchorDate,

    /// 弹窗面板高度（不传时自动计算）
    double? popupHeight,

    /// 第一天从星期几开始，0 = 周日，1 = 周一，…，6 = 周六。默认 0（周日）。
    int firstDayOfWeek = 0,

    /// 日期单元格高度
    double? cellHeight,

    /// 自定义样式
    TCalendarStyle? style,

    /// 弹窗底部自定义区域构建器
    Widget Function(BuildContext context, List<DateTime> selectedDates)?
        popupBottomBuilder,

    /// 弹窗底部区域是否展开（响应式）
    ValueListenable<bool>? popupBottomExpanded,

    /// 自定义确认按钮
    Widget? confirmBtn,

    /// 点击确认按钮时触发
    void Function(List<DateTime>)? onConfirm,

    /// 弹窗关闭后触发（无论确认还是取消）
    VoidCallback? onClose,

    /// 点击日期时触发
    void Function(DateTime value, DateSelectType selectType, TDate tdate)?
        onCellClick,

    /// 点击遮罩或物理返回是否关闭
    bool autoClose = true,

    /// 面板是否可拖动
    bool draggable = false,

    /// 自定义日期单元格组件
    Widget? Function(
      BuildContext context,
      TDate tdate,
      DateSelectType selectType,
    )? cellWidget,

    /// 日历显示模式
    TCalendarDisplayMode displayMode = TCalendarDisplayMode.solar,

    /// 外部数据源，用于提供农历转换等功能
    TCalendarDataSource? dataSource,

    /// 月份变化时触发
    ValueChanged<DateTime>? onMonthChange,

    /// 月标题构建器
    Widget Function(BuildContext context, DateTime monthDate)? monthTitleBuilder,
  }) async {
    final selected = ValueNotifier<List<DateTime>>(initialValue ?? []);
    List<DateTime>? result;
    var closing = false;

    void doClose(NavigatorState nav) {
      if (closing) {
        return;
      }
      closing = true;
      nav.pop();
    }

    await Navigator.of(context).push(TSlidePopupRoute(
      isDismissible: autoClose,
      slideTransitionFrom: SlideTransitionFrom.bottom,
      builder: (ctx) {
        final nav = Navigator.of(context);
        final safeBottom = MediaQuery.of(ctx).padding.bottom;
        final screenHeight = MediaQuery.of(ctx).size.height;

        final panelHeight =
            popupHeight ?? _calcDefaultHeight(safeBottom, screenHeight);

        // 提取标题文字给 TPopupBottomDisplayPanel
        String? panelTitle;
        if (titleWidget != null) {
          panelTitle = _extractTextFromWidget(titleWidget);
        }

        return TCalendarInherited(
          selected: selected,
          usePopup: true,
          popupControls: false,
          popupConfirmBtn: true,
          confirmBtn: confirmBtn,
          onClose: () {
            if (autoClose) {
              doClose(nav);
            }
          },
          onConfirm: () {
            result = List<DateTime>.from(selected.value);
            onConfirm?.call(result!);
            if (autoClose) {
              doClose(nav);
            }
          },
          child: TPopupBottomDisplayPanel(
            title: panelTitle,
            draggable: draggable,
            fixedHeight: panelHeight,
            closeClick: () {
              if (autoClose) {
                doClose(nav);
              }
            },
            child: TCalendar(
              titleWidget: titleWidget,
              type: type,
              initialValue: initialValue,
              minDate: minDate,
              maxDate: maxDate,
              anchorDate: anchorDate,
              firstDayOfWeek: firstDayOfWeek,
              cellHeight: cellHeight,
              style: style,
              popupBottomBuilder: popupBottomBuilder,
              popupBottomExpanded: popupBottomExpanded,
              onCellClick: onCellClick,
              cellWidget: cellWidget,
              displayMode: displayMode,
              dataSource: dataSource,
              onMonthChange: onMonthChange,
              monthTitleBuilder: monthTitleBuilder,
            ),
          ),
        );
      },
    ));

    onClose?.call();
    return result;
  }

  /// 尝试从 Widget 中提取文本内容，用于 TPopupBottomDisplayPanel 的标题。
  /// 仅支持 Text 和 RichText 两种常见情况。
  static String? _extractTextFromWidget(Widget widget) {
    if (widget is Text) {
      return widget.data;
    }
    if (widget is RichText) {
      final text = widget.text;
      if (text is TextSpan) {
        return text.toPlainText();
      }
    }
    return null;
  }

  @override
  _TCalendarState createState() => _TCalendarState();
}

class _TCalendarState extends State<TCalendar> {
  late List<String> weekdayNames;
  late List<String> monthNames;
  TCalendarInherited? inherited;
  late TCalendarStyle _style;

  List<DateTime>? _cachedValueDates;

  /// single 模式下当前选中的 TDate 引用（来自 body 缓存的当前实例）。
  ///
  /// cell 不再反查 `_data` 找上一个 selected：state 维护这条权威引用，点击
  /// 时直接 setType(empty) 即可。引用会随 body 缓存重生成（cleanup 后再滚回
  /// 该月）被 [_handleTDateGenerated] 覆盖为新实例，不会出现"指向已 detach
  /// 的 TDate"导致视觉残留。
  TDate? _selectedSingleRef;

  /// multiple 模式下当前所有选中的 TDate 引用，按日期键。
  ///
  /// 点击切换时直接查表决定 select/empty，避免遍历可见月份缓存。
  final Map<DateTime, TDate> _selectedMultipleRefs = {};

  // bottom 展开时日历主体上移的距离，露出 bottom 顶部"把手"区域。
  static const double _bottomPeekHeight = 30.0;

  static const double _confirmBtnHeight = 48.0;
  static const Duration _animDuration = Duration(milliseconds: 200);
  static const Curve _animCurve = Curves.easeInOut;

  bool _initializedSelected = false;

  bool get _usePopupBottom => inherited?.usePopup == true;

  /// 解析 displayMode 为旧的 dateType 和 showLunarInfo
  TCalendarDateType get _dateType {
    switch (widget.displayMode) {
      case TCalendarDisplayMode.solar:
      case TCalendarDisplayMode.solarWithLunar:
        return TCalendarDateType.solar;
      case TCalendarDisplayMode.lunar:
        return TCalendarDateType.lunar;
    }
  }

  bool get _showLunarInfo =>
      widget.displayMode == TCalendarDisplayMode.solarWithLunar ||
      widget.displayMode == TCalendarDisplayMode.lunar;

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
    if (!listEquals(oldWidget.initialValue, widget.initialValue)) {
      _refreshValueCache();
      _syncSelectedToInheritedDeferred();
    }
  }

  void _refreshValueCache() {
    _cachedValueDates = widget._value;
  }

  void _assertPopupOnlyBottom() {
    assert(
      widget.popupBottomBuilder == null || _usePopupBottom,
      '[TCalendar] popupBottomBuilder 仅能在弹窗模式下使用',
    );
    assert(
      widget.popupBottomExpanded == null || _usePopupBottom,
      '[TCalendar] popupBottomExpanded 仅能在弹窗模式下使用',
    );
  }

  // 仅在非 build phase 调用。
  void _syncSelectedToInheritedSync() {
    if (inherited == null) {
      return;
    }
    inherited!.selected.value = _getValue(widget.initialValue ?? const []);
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
      inherited!.selected.value = _getValue(widget.initialValue ?? const []);
    });
  }

  @override
  Widget build(BuildContext context) {
    _assertPopupOnlyBottom();
    final verticalGap = _style.verticalGap ?? TTheme.of(context).spacer8;
    final hasBottom = widget.popupBottomBuilder != null && _usePopupBottom;

    Widget stackContent(bool bottomExpanded) {
      return Stack(
        fit: StackFit.expand,
        children: [
          _buildMainColumn(verticalGap, hasBottom, bottomExpanded),
          if (hasBottom) _buildBottom(bottomExpanded),
        ],
      );
    }

    final child = hasBottom && widget.popupBottomExpanded != null
        ? ValueListenableBuilder<bool>(
            valueListenable: widget.popupBottomExpanded!,
            builder: (context, expanded, _) => stackContent(expanded),
          )
        : stackContent(hasBottom);

    return Container(
      height: widget.height ?? _calcInlineDefaultHeight(verticalGap),
      width: double.infinity,
      decoration: _style.decoration,
      child: child,
    );
  }

  /// 当 [TCalendarInherited.popupControls] 为 `true` 时，由 [TCalendar]
  /// 自行渲染关闭按钮与标题行；为 `false` 时由外层面板承载。
  bool get _showPopupControls =>
      (inherited?.usePopup ?? false) && (inherited?.popupControls ?? true);

  /// 是否渲染底部确认按钮，由 [TCalendarInherited.popupConfirmBtn] 控制。
  bool get _showPopupConfirmBtn =>
      (inherited?.usePopup ?? false) &&
      (inherited?.effectivePopupConfirmBtn ?? false);

  Widget _buildMainColumn(
    double verticalGap,
    bool hasBottom,
    bool bottomExpanded,
  ) {
    return Column(
      children: [
        TCalendarHeader(
          firstDayOfWeek: widget.firstDayOfWeek,
          weekdayGap: TTheme.of(context).spacer4,
          padding: TTheme.of(context).spacer16,
          weekdayStyle: _style.weekdayStyle,
          weekdayHeight: 46,
          titleWidget: _showPopupControls ? widget.titleWidget : null,
          titleStyle: _style.titleStyle,
          titleMaxLine: _style.titleMaxLine,
          titleOverflow: TextOverflow.ellipsis,
          closeBtn: _showPopupControls,
          closeColor: _style.titleCloseColor,
          weekdayNames: weekdayNames,
          onClose: inherited?.onClose,
        ),
        Expanded(
          child: _buildBodyArea(verticalGap, hasBottom, bottomExpanded),
        ),
        if (_showPopupConfirmBtn)
          inherited?.confirmBtn ??
              Padding(
                padding: widget.safeAreaInset
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
        if (widget.safeAreaInset)
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
    if (widget.popupBottomExpanded == null) {
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
      type: widget.type,
      firstDayOfWeek: widget.firstDayOfWeek,
      maxDate: widget.maxDate,
      anchorDate: widget.anchorDate,
      minDate: widget.minDate,
      value: _cachedValueDates,
      bodyPadding: _style.bodyPadding ?? TTheme.of(context).spacer16,
      monthNames: monthNames,
      monthTitleStyle: _style.monthTitleStyle,
      verticalGap: verticalGap,
      cellHeight: _getEffectiveCellHeight(),
      monthTitleHeight: widget.monthTitleHeight,
      monthTitleBuilder: widget.monthTitleBuilder,
      animateTo: widget.animateTo,
      onMonthChange: widget.onMonthChange,
      dateType: _dateType,
      dataSource: widget.dataSource,
      onTDateGenerated: _handleTDateGenerated,
      onCacheInvalidated: _handleCacheInvalidated,
      builder: (date, dateList, rowIndex, colIndex) {
        return TCalendarCell(
          height: _getEffectiveCellHeight(),
          tdate: date,
          padding: verticalGap / 2,
          onTap: _handleCellTap,
          dateList: dateList,
          rowIndex: rowIndex,
          colIndex: colIndex,
          cellWidget: widget.cellWidget,
          dateType: _dateType,
          showLunarInfo: _showLunarInfo,
        );
      },
    );
  }

  /// 月份 TDate 列表新生成时被 body 调用：登记 selected/start/end 引用，
  /// 让 state 不依赖 body 内部缓存即可定位"当前选中的那些 TDate 实例"。
  ///
  /// single：每月最多一个 selected，遇到即覆盖 _selectedSingleRef。
  /// multiple：把当月所有 selected 的引用按 date 写入 map。
  /// range：本身走 widget.value 重建路径，不需要登记。
  void _handleTDateGenerated(DateTime monthDate, List<TDate?> tdates) {
    if (widget.type == CalendarType.range) {
      return;
    }
    for (final tdate in tdates) {
      if (tdate == null) {
        continue;
      }
      if (tdate.typeNotifier.value != DateSelectType.selected) {
        continue;
      }
      if (widget.type == CalendarType.single) {
        _selectedSingleRef = tdate;
      } else if (widget.type == CalendarType.multiple) {
        _selectedMultipleRefs[tdate.date] = tdate;
      }
    }
  }

  /// 当 body 整体清空缓存时（minDate/maxDate 变化等），同步清空选中映射，
  /// 避免悬挂指向已被替换的 TDate 实例。后续月份重新生成时会再次登记。
  void _handleCacheInvalidated() {
    _selectedSingleRef = null;
    _selectedMultipleRefs.clear();
  }

  /// 三种模式统一入口：cell 仅上抛被点击的 TDate，由本方法做所有决策。
  ///
  /// 行为约定：
  /// - disabled：仅触发 onCellClick，不改变选中态
  /// - single：切换 _selectedSingleRef，旧引用置 empty、新引用置 selected
  /// - multiple：根据 _selectedMultipleRefs 切换该日期的选中态
  /// - range：交由 [_resolveRangeSelection] 决策后走 setState 重建（保持原有路径）
  void _handleCellTap(TDate tdate) {
    final selectType = tdate.typeNotifier.value;
    final curDate = tdate.date;

    if (selectType == DateSelectType.disabled) {
      widget.onCellClick?.call(curDate, selectType, tdate);
      return;
    }

    switch (widget.type) {
      case CalendarType.single:
        // 已经是当前选中：仅触发 onCellClick，不重复 onChange
        if (identical(_selectedSingleRef, tdate)) {
          widget.onCellClick?.call(curDate, tdate.typeNotifier.value, tdate);
          return;
        }
        _selectedSingleRef?.typeNotifier.setType(DateSelectType.empty);
        tdate.typeNotifier.setType(DateSelectType.selected);
        _selectedSingleRef = tdate;
        _emitSelection([curDate], rebuild: false);
        widget.onCellClick?.call(curDate, tdate.typeNotifier.value, tdate);
        break;
      case CalendarType.multiple:
        final existing = _selectedMultipleRefs[curDate];
        List<DateTime> nextValue;
        if (existing != null) {
          existing.typeNotifier.setType(DateSelectType.empty);
          _selectedMultipleRefs.remove(curDate);
        } else {
          tdate.typeNotifier.setType(DateSelectType.selected);
          _selectedMultipleRefs[curDate] = tdate;
        }
        nextValue = _selectedMultipleRefs.keys.toList()..sort();
        _emitSelection(nextValue, rebuild: false);
        widget.onCellClick?.call(curDate, tdate.typeNotifier.value, tdate);
        break;
      case CalendarType.range:
        // range 仍走老路径：state 决策 start/end，刷新 value，触发 body 重建。
        final resolved = _resolveRangeSelection([curDate]);
        _emitSelection(resolved, rebuild: true);
        // 上抛点击时已根据 resolved 推导出本次的语义类型（start / end），
        // 这样调用方无需等到 body 重建后再读 typeNotifier，可直接用于
        // 切换关联 UI（如时间选择器 Tab）。
        final reportedType = resolved.length >= 2 && resolved[1] == curDate
            ? DateSelectType.end
            : DateSelectType.start;
        widget.onCellClick?.call(curDate, reportedType, tdate);
        break;
    }
  }

  /// 统一更新 _cachedValueDates / inherited.selected / onChange，并按需触发 setState。
  void _emitSelection(List<DateTime> value, {required bool rebuild}) {
    _cachedValueDates = value;
    inherited?.selected.value = value;
    widget.onChange?.call(value);
    if (rebuild && mounted) {
      setState(() {});
    }
  }

  /// range 模式专用的选区决策：
  /// - 无 start：作为新 start
  /// - 已有 start 且无 end，且点击晚于 start：作为 end，区间完成
  /// - 其它（已完成区间 / 点击早于等于 start）：以本次点击重新开始
  List<DateTime> _resolveRangeSelection(List<DateTime> rawValue) {
    if (rawValue.isEmpty) {
      return const [];
    }
    final tapped = DateTime(
      rawValue.first.year,
      rawValue.first.month,
      rawValue.first.day,
    );
    final current = _cachedValueDates ?? const [];
    final hasStart = current.isNotEmpty;
    final hasEnd = current.length >= 2;
    if (hasStart && !hasEnd && tapped.isAfter(current[0])) {
      return [current[0], tapped];
    }
    return [tapped];
  }

  // 行为约定详见 [TCalendar.popupBottomBuilder]。
  Widget _buildBottom(bool bottomExpanded) {
    assert(widget.popupBottomBuilder != null);
    assert(inherited != null);

    final bottomOffset = _calcBottomOffset();

    final content = ValueListenableBuilder<List<DateTime>>(
      valueListenable: inherited!.selected,
      builder: (context, selectedDates, _) {
        return widget.popupBottomBuilder!(
          context,
          List<DateTime>.unmodifiable(selectedDates),
        );
      },
    );

    if (widget.popupBottomExpanded != null) {
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
    final safeBottom = widget.safeAreaInset
        ? MediaQuery.of(context).padding.bottom
        : 0.0;

    if (_showPopupConfirmBtn) {
      final btnPadding = widget.safeAreaInset
          ? TTheme.of(context).spacer16
          : TTheme.of(context).spacer16 * 2;
      // 仅默认确认按钮使用固定高度；自定义 confirmBtn 由调用方保证 bottom 不重叠。
      final btnHeight =
          inherited?.confirmBtn == null ? _confirmBtnHeight : 0.0;
      return safeBottom + btnPadding + btnHeight;
    }

    return safeBottom;
  }

  List<DateTime> _getValue(List<DateTime> value) {
    return value.map((e) => DateTime(e.year, e.month, e.day)).toList();
  }

  double _getEffectiveCellHeight() {
    if (widget.cellHeight != null) {
      return widget.cellHeight!;
    }
    return 60;
  }

  /// 内嵌模式下不传 `height` 时的默认高度。
  ///
  /// 布局 = weekday(46) + monthTitle(22) + 5行(cellHeight + verticalGap) + bodyPadding*2
  double _calcInlineDefaultHeight(double verticalGap) {
    const weekdayHeight = 46.0;
    final monthTitleHeight = widget.monthTitleHeight;
    final cellHeight = _getEffectiveCellHeight();
    final bodyPadding = _style.bodyPadding ?? TTheme.of(context).spacer16;
    const visibleRows = 5;
    return weekdayHeight +
        monthTitleHeight +
        visibleRows * (cellHeight + verticalGap) +
        bodyPadding * 2;
  }
}

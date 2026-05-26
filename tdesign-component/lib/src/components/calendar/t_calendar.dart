import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';
import '../../util/iterable_ext.dart';
import 't_calendar_body.dart';
import 't_calendar_cell.dart';
import 't_calendar_header.dart';

export 't_calendar_cell.dart'
    show
        TCalendarCellModel,
        DateSelectTypeNotifier,
        DateSelectType,
        TCalendarSubtitleContext,
        TCalendarSubtitleBuilder,
        TCalendarCellBuilder;
export 't_calendar_data_source.dart';
export 't_calendar_style.dart';

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
    this.confirmBtnBuilder,
    this.popupBottomBuilder,
    this.popupBottomExpanded,
    Key? key,
  })  : assert(
          popupBottomExpanded == null || popupBottomBuilder != null,
          'popupBottomExpanded 需配合 popupBottomBuilder 使用',
        ),
        super(child: child, key: key);

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
  /// 为 `false` 时由外层弹窗容器承载。
  final bool popupControls;

  /// 是否由 [TCalendar] 渲染底部确认按钮。
  ///
  /// 为 `null`（默认）时跟随 [popupControls]；显式设置时覆盖。
  final bool? popupConfirmBtn;

  /// 实际是否渲染底部确认按钮。
  bool get effectivePopupConfirmBtn => popupConfirmBtn ?? popupControls;

  final VoidCallback? onConfirm;

  /// 自定义确认按钮；[onConfirm] 与默认确认按钮一致（回传选中值并关闭弹窗）。
  final Widget Function(VoidCallback onConfirm)? confirmBtnBuilder;

  /// 弹窗底部自定义区域构建器（仅弹窗模式，由 [TCalendar.showPopup] 或手动
  /// [TCalendarInherited] 注入）。
  final Widget Function(BuildContext context, List<DateTime> selectedDates)?
      popupBottomBuilder;

  /// 弹窗底部区域是否展开（响应式），需配合 [popupBottomBuilder]。
  final ValueListenable<bool>? popupBottomExpanded;

  /// 仅当 Inherited 上的**静态配置**变化时通知依赖方重建。
  ///
  /// [selected] 为 [ValueNotifier]，变更走 [selectedListenable]，不依赖本方法。
  /// 若返回 `false`，在运行期替换 [popupBottomBuilder] 等回调时，子树不会自动重建，
  /// 弹窗场景一般在 push 时一次性注入，内嵌高级用法请整体替换 Inherited。
  @override
  bool updateShouldNotify(covariant TCalendarInherited oldWidget) {
    return oldWidget.usePopup != usePopup ||
        oldWidget.popupControls != popupControls ||
        oldWidget.popupConfirmBtn != popupConfirmBtn ||
        oldWidget.onClose != onClose ||
        oldWidget.onConfirm != onConfirm ||
        oldWidget.confirmBtnBuilder != confirmBtnBuilder ||
        oldWidget.popupBottomBuilder != popupBottomBuilder ||
        oldWidget.popupBottomExpanded != popupBottomExpanded;
  }

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
    this.monthTitleHeight = 22,
    this.monthTitleBuilder,
    this.animateTo = false,
    this.cellBuilder,
    this.subtitleBuilder,
    this.onMonthChange,
    this.anchorDate,
    this.anchorRevision = 0,
    this.dataSource,
  }) : super(key: key);

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
  /// **非受控语义**：仅用于首次挂载；用户点选后以 [onChange] 为准，由调用方自行
  /// `setState` 保存。若父组件在运行期修改本参数，会同步选中态并刷新格子（与 range
  /// 行为一致）。
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
    TCalendarCellModel cell,
  )? onCellClick;

  /// 月份变化时触发
  final ValueChanged<DateTime>? onMonthChange;

  /// 是否适配底部安全区域（如 iPhone Home Indicator），默认 true
  final bool safeAreaInset;

  /// 每月标题行高度（如 '2025年6月' 所在行），默认 22
  final double monthTitleHeight;

  /// 月标题构建器
  final Widget Function(
    BuildContext context,
    DateTime monthDate,
  )? monthTitleBuilder;

  /// 滚动到选中日期/锚点日期所在月份时是否使用动画，默认 false
  final bool animateTo;

  /// 整格自定义；设置后不再使用默认主区/副标题布局。
  final TCalendarCellBuilder? cellBuilder;

  /// 副标题完全自定义；未设置时可使用 [dataSource.getSubtitle]。
  final TCalendarSubtitleBuilder? subtitleBuilder;

  /// 锚点日期，打开时滚动到该日期所在月份。
  final DateTime? anchorDate;

  /// 锚点滚动触发序号，默认 `0`。
  ///
  /// 与 [anchorDate] 配合：序号递增可重复滚到同一月份；仅改月份时也可只更新 [anchorDate]。
  final int anchorRevision;

  /// 可选数据源，提供副标题字符串（无 [subtitleBuilder] 时生效）。
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
  /// 弹窗内点选过程无 [onChange]；实时联动请用 [popupBottomBuilder] 的 `dates`，
  /// 或自行用 [TCalendarInherited] 监听 [TCalendarInherited.selectedListenable]。
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
  /// 若需完全自定义布局，请直接使用 [TCalendar] + [TPopup.show]
  /// / [TPopupOptions.bottom] 自行组装。
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

    /// 锚点滚动触发序号，见 [TCalendar.anchorRevision]
    int anchorRevision = 0,

    /// 弹窗面板高度（不传时自动计算）
    double? popupHeight,

    /// 第一天从星期几开始，0 = 周日，1 = 周一，…，6 = 周六。默认 0（周日）。
    int firstDayOfWeek = 0,

    /// 日期单元格高度
    double? cellHeight,

    /// 自定义样式
    TCalendarStyle? style,

    /// 弹窗底部自定义区域构建器（经 [TCalendarInherited] 注入，仅弹窗内生效）。
    Widget Function(BuildContext context, List<DateTime> selectedDates)?
        popupBottomBuilder,

    /// 弹窗底部区域是否展开（响应式），需配合 [popupBottomBuilder]。
    ValueListenable<bool>? popupBottomExpanded,

    /// 自定义确认按钮，[onConfirm] 与默认确认按钮一致。
    Widget Function(VoidCallback onConfirm)? confirmBtnBuilder,

    /// 点击确认按钮时触发
    void Function(List<DateTime>)? onConfirm,

    /// 弹窗关闭后触发（无论确认还是取消）
    VoidCallback? onClose,

    /// 点击日期时触发
    void Function(
      DateTime value,
      DateSelectType selectType,
      TCalendarCellModel cell,
    )? onCellClick,

    /// 点击遮罩或物理返回是否关闭
    bool autoClose = true,

    TCalendarCellBuilder? cellBuilder,
    TCalendarSubtitleBuilder? subtitleBuilder,
    TCalendarDataSource? dataSource,

    /// 月份变化时触发
    ValueChanged<DateTime>? onMonthChange,

    /// 月标题构建器
    Widget Function(BuildContext context, DateTime monthDate)? monthTitleBuilder,
  }) async {
    final selected = ValueNotifier<List<DateTime>>(initialValue ?? []);
    final completer = Completer<List<DateTime>?>();
    TPopupHandle? handle;
    List<DateTime>? result;
    var closed = false;

    void closePopup() {
      if (closed) {
        return;
      }
      handle?.close();
    }

    void completeClose() {
      if (closed) {
        return;
      }
      closed = true;
      onClose?.call();
      if (!completer.isCompleted) {
        completer.complete(result);
      }
    }

    final mediaQuery = MediaQuery.of(context);
    final panelHeight = popupHeight ??
        _calcDefaultHeight(mediaQuery.padding.bottom, mediaQuery.size.height);
    final calendarHeight =
        (panelHeight - _kPanelHeaderHeight).clamp(0.0, double.infinity);

    handle = TPopup.show(
      context,
      options: TPopupOptions.bottom(
        headerBuilder: (ctx, close) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (titleWidget != null) Center(child: titleWidget),
              if (autoClose)
                Positioned(
                  right: -8,
                  child: IconButton(
                    icon: Icon(
                      TIcons.close,
                      color: style?.titleCloseColor,
                    ),
                    onPressed: close,
                  ),
                ),
            ],
          ),
        ),
        titleWidget: null,
        cancelBuilder: null,
        confirmBuilder: null,
        height: panelHeight,
        closeOnOverlayClick: autoClose,
        onClosed: completeClose,
        child: PopScope(
          canPop: autoClose,
          child: TCalendarInherited(
            selected: selected,
            usePopup: true,
            popupControls: false,
            popupConfirmBtn: true,
            confirmBtnBuilder: confirmBtnBuilder,
            popupBottomBuilder: popupBottomBuilder,
            popupBottomExpanded: popupBottomExpanded,
            onClose: () {
              if (autoClose) {
                closePopup();
              }
            },
            onConfirm: () {
              result = List<DateTime>.from(selected.value);
              onConfirm?.call(result!);
              if (autoClose) {
                closePopup();
              }
            },
            child: TCalendar(
              height: calendarHeight,
              titleWidget: titleWidget,
              type: type,
              initialValue: initialValue,
              minDate: minDate,
              maxDate: maxDate,
              anchorDate: anchorDate,
              anchorRevision: anchorRevision,
              firstDayOfWeek: firstDayOfWeek,
              cellHeight: cellHeight,
              style: style,
              onCellClick: onCellClick,
              cellBuilder: cellBuilder,
              subtitleBuilder: subtitleBuilder,
              dataSource: dataSource,
              onMonthChange: onMonthChange,
              monthTitleBuilder: monthTitleBuilder,
            ),
          ),
        ),
      ),
    );

    return completer.future;
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

  /// single 模式下当前选中的单元格引用（来自 body 缓存的当前实例）。
  ///
  /// cell 不再反查 `_data` 找上一个 selected：state 维护这条权威引用，点击
  /// 时直接 setType(empty) 即可。引用会随 body 缓存重生成（cleanup 后再滚回
  /// 该月）被 [_handleCellGenerated] 覆盖为新实例，不会出现"指向已 detach
  /// 的 cell"导致视觉残留。
  TCalendarCellModel? _selectedSingleRef;

  /// multiple 模式下当前所有选中的单元格引用，按日期键。
  final Map<DateTime, TCalendarCellModel> _selectedMultipleRefs = {};

  // bottom 展开时日历主体上移的距离，露出 bottom 顶部"把手"区域。
  static const double _bottomPeekHeight = 30.0;

  static const double _confirmBtnHeight = 48.0;
  static const Duration _animDuration = Duration(milliseconds: 200);
  static const Curve _animCurve = Curves.easeInOut;

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
    final verticalGap = _style.verticalGap ?? TTheme.of(context).spacer8;
    final popupBottomBuilder = inherited?.popupBottomBuilder;
    final popupBottomExpanded = inherited?.popupBottomExpanded;
    final hasBottom =
        inherited?.usePopup == true && popupBottomBuilder != null;

    Widget stackContent(bool bottomExpanded) {
      return Stack(
        fit: StackFit.expand,
        children: [
          _buildMainColumn(verticalGap, hasBottom, bottomExpanded),
          if (hasBottom) _buildBottom(bottomExpanded),
        ],
      );
    }

    final child = hasBottom && popupBottomExpanded != null
        ? ValueListenableBuilder<bool>(
            valueListenable: popupBottomExpanded,
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
        if (_showPopupConfirmBtn) _buildConfirmBtnArea(context),
        if (widget.safeAreaInset)
          SizedBox(height: MediaQuery.of(context).padding.bottom)
      ],
    );
  }

  Widget _buildConfirmBtnArea(BuildContext context) {
    final onConfirm = inherited?.onConfirm;
    if (inherited?.confirmBtnBuilder != null) {
      return inherited!.confirmBtnBuilder!(onConfirm ?? () {});
    }
    return Padding(
      padding: widget.safeAreaInset
          ? EdgeInsets.only(top: TTheme.of(context).spacer16)
          : EdgeInsets.symmetric(vertical: TTheme.of(context).spacer16),
      child: TButton(
        theme: TButtonTheme.primary,
        text: context.resource.confirm,
        isBlock: true,
        size: TButtonSize.large,
        onTap: onConfirm,
      ),
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
    if (inherited?.popupBottomExpanded == null) {
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
      anchorRevision: widget.anchorRevision,
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
      onCellGenerated: _handleCellGenerated,
      onCacheInvalidated: _handleCacheInvalidated,
      builder: (cell, dateList, rowIndex, colIndex) {
        return TCalendarCell(
          height: _getEffectiveCellHeight(),
          cell: cell,
          padding: verticalGap / 2,
          onTap: _handleCellTap,
          dateList: dateList,
          rowIndex: rowIndex,
          colIndex: colIndex,
          cellBuilder: widget.cellBuilder,
          subtitleBuilder: widget.subtitleBuilder,
          dataSource: widget.dataSource,
          dayStyle: _style.dayStyle,
          todayDayStyle: _style.todayDayStyle,
          subtitleStyle: _style.subtitleStyle,
        );
      },
    );
  }

  /// 月份单元格列表新生成时被 body 调用：登记 selected 引用，
  /// 让 state 不依赖 body 内部缓存即可定位当前选中的 cell 实例。
  ///
  /// single：每月最多一个 selected，遇到即覆盖 _selectedSingleRef。
  /// multiple：把当月所有 selected 的引用按 date 写入 map。
  /// range：本身走 widget.value 重建路径，不需要登记。
  void _handleCellGenerated(DateTime monthDate, List<TCalendarCellModel?> cells) {
    if (widget.type == CalendarType.range) {
      return;
    }
    for (final cell in cells) {
      if (cell == null) {
        continue;
      }
      if (cell.typeNotifier.value != DateSelectType.selected) {
        continue;
      }
      if (widget.type == CalendarType.single) {
        _selectedSingleRef = cell;
      } else if (widget.type == CalendarType.multiple) {
        _selectedMultipleRefs[cell.date] = cell;
      }
    }
  }

  /// 当 body 整体清空缓存时（minDate/maxDate 变化等），同步清空选中映射，
  /// 避免悬挂指向已被替换的 cell 实例。后续月份重新生成时会再次登记。
  void _handleCacheInvalidated() {
    _selectedSingleRef = null;
    _selectedMultipleRefs.clear();
  }

  /// 三种模式统一入口：cell 仅上抛被点击的模型，由本方法做所有决策。
  ///
  /// 行为约定：
  /// - disabled：仅触发 onCellClick，不改变选中态
  /// - single：切换 _selectedSingleRef，旧引用置 empty、新引用置 selected
  /// - multiple：根据 _selectedMultipleRefs 切换该日期的选中态
  /// - range：交由 [_resolveRangeSelection] 决策后走 setState 重建（保持原有路径）
  void _handleCellTap(TCalendarCellModel cell) {
    final selectType = cell.typeNotifier.value;
    final curDate = cell.date;

    if (selectType == DateSelectType.disabled) {
      widget.onCellClick?.call(curDate, selectType, cell);
      return;
    }

    switch (widget.type) {
      case CalendarType.single:
        if (identical(_selectedSingleRef, cell)) {
          widget.onCellClick?.call(curDate, cell.typeNotifier.value, cell);
          return;
        }
        _selectedSingleRef?.typeNotifier.setType(DateSelectType.empty);
        cell.typeNotifier.setType(DateSelectType.selected);
        _selectedSingleRef = cell;
        _emitSelection([curDate], rebuild: false);
        widget.onCellClick?.call(curDate, cell.typeNotifier.value, cell);
        break;
      case CalendarType.multiple:
        final existing = _selectedMultipleRefs[curDate];
        List<DateTime> nextValue;
        if (existing != null) {
          existing.typeNotifier.setType(DateSelectType.empty);
          _selectedMultipleRefs.remove(curDate);
        } else {
          cell.typeNotifier.setType(DateSelectType.selected);
          _selectedMultipleRefs[curDate] = cell;
        }
        nextValue = _selectedMultipleRefs.keys.toList()..sort();
        _emitSelection(nextValue, rebuild: false);
        widget.onCellClick?.call(curDate, cell.typeNotifier.value, cell);
        break;
      case CalendarType.range:
        final resolved = _resolveRangeSelection([curDate]);
        _emitSelection(resolved, rebuild: true);
        final reportedType = resolved.length >= 2 && resolved[1] == curDate
            ? DateSelectType.end
            : DateSelectType.start;
        widget.onCellClick?.call(curDate, reportedType, cell);
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

  // 行为约定详见 [TCalendarInherited.popupBottomBuilder]。
  Widget _buildBottom(bool bottomExpanded) {
    final popupBottomBuilder = inherited!.popupBottomBuilder!;
    final bottomOffset = _calcBottomOffset();

    final content = ValueListenableBuilder<List<DateTime>>(
      valueListenable: inherited!.selected,
      builder: (context, selectedDates, _) {
        return popupBottomBuilder(
          context,
          List<DateTime>.unmodifiable(selectedDates),
        );
      },
    );

    if (inherited!.popupBottomExpanded != null) {
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
      // 默认与自定义确认按钮均预留固定高度，避免 popupBottomBuilder 浮层重叠。
      // 若自定义按钮更高，请在 popupHeight 中额外预留空间。
      return safeBottom + btnPadding + _confirmBtnHeight;
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

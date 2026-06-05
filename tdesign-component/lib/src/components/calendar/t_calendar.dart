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
        TCalendarCellBuilder,
        TCalendarMonthTitleBuilder;
export 't_calendar_style.dart';

// ---------------------------------------------------------------------------
// TCalendar — 纯日历组件
// ---------------------------------------------------------------------------

/// 日历选择模式
enum CalendarType {
  /// 单选：点击新日期时自动取消旧日期的选中状态
  single,

  /// 多选：点击日期切换选中/取消，可同时选中多个日期
  multiple,

  /// 区间选择：第一次点击选起点，第二次点击选终点，中间自动填充区间
  range,
}

/// 日历组件（纯日历面板，不含弹窗、表单等封装）。
///
/// 与 [`TDateTimePicker`]、[`TPicker`] 为三个独立对外组件，本组件与二者无代码依赖；
/// 滚轮选日期/时间请使用 [`TDateTimePicker`]，月历格点选使用本组件。
///
/// ## 状态约定
///
/// - [initialValue]：**非受控**，仅在组件首次挂载时写入选中态；运行期修改本参数不会
///   同步到界面。外部重置选中请更换 [Key] 或销毁后重建（如弹层关闭再打开）。
/// - [onChange]：用户点选导致选中变化时触发；挂载阶段不会调用。选中高亮由组件内部维护。
/// - [anchorDate]：首屏及运行期可更新的**滚动锚点**，滚到该日所在月份，不自动改选中。
/// - [onMonthChanged]：用户滑动导致可见月份变化时触发，便于外置年月条同步文案。
///
/// ## 自定义展示
///
/// - [subtitleBuilder]：日期主数字下方的**副标题**（农历、价格、节日等）。
/// - [cellBuilder]：**整格**自定义，设置后不再渲染默认主数字与副标题布局。
/// - [monthTitleBuilder]：每个月份区块顶部的年月标题。
///
/// 弹层场景请自行 `showModalBottomSheet` 包裹本组件，并用新 [Key] 或新实例传入
/// [initialValue]；外置月份导航请更新 [anchorDate] 而非回写 [initialValue]。
class TCalendar extends StatefulWidget {
  TCalendar({
    Key? key,
    this.firstDayOfWeek = 0,
    DateTime? minDate,
    DateTime? maxDate,
    this.type = CalendarType.single,
    this.initialValue,
    this.height,
    TCalendarStyle? style,
    required this.onChange,
    this.onCellTap,
    this.onMonthChanged,
    TCalendarMonthTitleBuilder? monthTitleBuilder,
    this.cellBuilder,
    this.subtitleBuilder,
    this.animateTo = false,
    this.anchorDate,
  })  : assert(minDate == null || maxDate == null || minDate.isBefore(maxDate),
            'minDate 必须早于 maxDate'),
        minDate = minDate ?? _getDefaultMinDate(),
        maxDate = maxDate ?? _getDefaultMaxDate(),
        monthTitleBuilder = monthTitleBuilder ?? _defaultMonthTitleBuilder,
        style = style ?? TCalendarStyle.generateStyle(context: null),
        super(key: key);

  /// 第一天从星期几开始，0 = 周日，1 = 周一，…，6 = 周六。默认 0（周日）。
  final int firstDayOfWeek;

  /// 最小可选的日期，默认 1970-01-01
  final DateTime minDate;

  /// 最大可选的日期，默认 2100-12-31
  final DateTime maxDate;

  /// 日历的选择模式，决定点击日期后的选中行为：
  /// - [CalendarType.single]：单选，点击新日期取消旧选中
  /// - [CalendarType.multiple]：多选，点击切换选中/取消
  /// - [CalendarType.range]：区间选择，依次选起止日期
  final CalendarType type;

  /// 初始选中日期列表，**仅在组件首次挂载时**写入内部选中态，运行期变更不会同步。
  ///
  /// 若需从外部重置选中，请为 [TCalendar] 指定新的 [Key] 或销毁后重新创建实例
  ///（例如弹层关闭再打开）。不传时内部选中为空列表，首屏滚动见 [anchorDate]。
  ///
  /// 列表长度与 [type] 对应：
  /// - [CalendarType.single]：1 个元素（选中日期）
  /// - [CalendarType.multiple]：N 个元素（所有选中日期）
  /// - [CalendarType.range]：2 个元素（起始、结束日期）
  final List<DateTime>? initialValue;

  /// 高度，不传时自动按 5 行日期计算
  final double? height;

  /// 自定义样式（包含 cellHeight、monthTitleHeight 等布局参数）
  final TCalendarStyle style;

  /// 选中结果变化时触发（单选立即触发；多选每次切换；区间在端点变化时触发）。
  ///
  /// 用于同步业务侧 State 或 [ValueNotifier]；勿依赖运行期回写 [initialValue] 驱动 UI。
  /// 组件挂载时不会调用本回调。
  final ValueChanged<List<DateTime>> onChange;

  /// 每次点击日期格时触发（含禁用格、单选重复点击已选格）。
  ///
  /// 仅用于埋点、提示等副作用；**选中结果以 [onChange] 为准**。
  final void Function(TCalendarCellModel cell)? onCellTap;

  /// 可见月份变化时触发（用户滑动或程序化滚动结束后），参数为当月 1 日。
  ///
  /// 外置控制栏可只更新自身文案，避免为同步月份对 [TCalendar] 整组件 `setState`。
  final ValueChanged<DateTime>? onMonthChanged;

  /// 月标题构建器，参数 [DateTime] 为当月 1 日（仅年月有效）。
  final TCalendarMonthTitleBuilder monthTitleBuilder;

  /// 整格自定义构建器；返回非 null 时替换该格默认布局（主数字 + 副标题均不渲染）。
  ///
  /// 与 [subtitleBuilder] 互斥：需要只改副标题时请用 [subtitleBuilder]。
  final TCalendarCellBuilder? cellBuilder;

  /// 副标题构建器，在日期主数字下方渲染自定义内容。
  ///
  /// [TCalendarSubtitleContext.date] 为当前格日期；
  /// [TCalendarSubtitleContext.selectType] 为选中/区间/禁用等态。返回 null 不显示副标题行。
  final TCalendarSubtitleBuilder? subtitleBuilder;

  /// [anchorDate] 或首屏定位变更导致滚动时，是否使用动画，默认 false。
  final bool animateTo;

  /// 滚动锚点日期：将列表定位到该日**所在月份**的首屏位置。
  ///
  /// **不**自动把该日设为选中。运行期更新本参数会重新滚动（见 [animateTo]）。
  /// 未设置时：有非空 [initialValue] 则滚到其中最早一日所在月，否则滚到 [minDate] 首月。
  final DateTime? anchorDate;

  // ---------------------------------------------------------------------------
  // 默认值
  // ---------------------------------------------------------------------------
  static DateTime _getDefaultMinDate() => DateTime(1970, 1, 1);
  static DateTime _getDefaultMaxDate() => DateTime(2100, 12, 31);
  static const double _kWeekdayHeight = 46.0;

  // ---------------------------------------------------------------------------
  // 默认构建器
  // ---------------------------------------------------------------------------
  static Widget _defaultMonthTitleBuilder(
    BuildContext context,
    DateTime monthDate,
  ) {
    final monthYear = '${monthDate.year}${context.resource.year}';
    final monthNames = [
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
    return TText('$monthYear ${monthNames[monthDate.month - 1]}');
  }

  /// 将 [initialValue] 规范为仅含年月日的 [DateTime] 列表，避免动态列表或带时分秒导致比较异常。
  static List<DateTime> _normalizeDateList(Iterable<DateTime> dates) {
    return dates
        .map((d) => DateTime(d.year, d.month, d.day))
        .toList(growable: false);
  }

  List<DateTime>? get _value {
    final raw = initialValue;
    if (raw == null) {
      return null;
    }
    return _normalizeDateList(raw);
  }

  @override
  _TCalendarState createState() => _TCalendarState();
}

class _TCalendarState extends State<TCalendar> {
  late List<String> weekdayNames;
  late List<String> monthNames;
  late TCalendarStyle _style;

  List<DateTime>? _cachedValueDates;

  /// single 模式下当前选中的单元格引用（来自 body 缓存的当前实例）。
  TCalendarCellModel? _selectedSingleRef;

  /// multiple 模式下当前所有选中的单元格引用，按日期键。
  final Map<DateTime, TCalendarCellModel> _selectedMultipleRefs = {};

  bool _initializedSelected = false;

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
    _style = widget.style;
    if (!_initializedSelected) {
      _initializedSelected = true;
      _applyInitialValue();
    }
  }

  /// 挂载时从 [initialValue] 种子化内部选中缓存，不向 [onChange] 回传。
  void _applyInitialValue() {
    _cachedValueDates = widget._value ?? const <DateTime>[];
  }

  @override
  Widget build(BuildContext context) {
    final verticalGap = _style.verticalGap ?? TTheme.of(context).spacer8;

    return Container(
      height: widget.height ?? _calcInlineDefaultHeight(verticalGap),
      width: double.infinity,
      decoration: _style.decoration,
      child: Column(
        children: [
          TCalendarHeader(
            firstDayOfWeek: widget.firstDayOfWeek,
            weekdayGap: _style.weekdayGap ?? TTheme.of(context).spacer4,
            padding: _style.bodyPadding ?? TTheme.of(context).spacer16,
            weekdayStyle: _style.weekdayStyle,
            weekdayHeight: _style.weekdayHeight ?? TCalendar._kWeekdayHeight,
            weekdayNames: weekdayNames,
          ),
          Expanded(
            child: _buildCalendarBody(verticalGap),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarBody(double verticalGap) {
    return TCalendarBody(
      type: widget.type,
      firstDayOfWeek: widget.firstDayOfWeek,
      minDate: widget.minDate,
      maxDate: widget.maxDate,
      initialValue: _cachedValueDates,
      bodyPadding: _style.bodyPadding ?? TTheme.of(context).spacer16,
      monthNames: monthNames,
      monthTitleStyle: _style.monthTitleStyle,
      verticalGap: verticalGap,
      cellHeight: _style.cellHeight ?? 60,
      monthTitleHeight: _style.monthTitleHeight ?? 22,
      monthTitleBuilder: widget.monthTitleBuilder,
      anchorDate: widget.anchorDate,
      animateTo: widget.animateTo,
      onMonthChange: widget.onMonthChanged,
      onCellGenerated: _handleCellGenerated,
      onCacheInvalidated: _handleCacheInvalidated,
      builder: (cell, dateList, rowIndex, colIndex) {
        return TCalendarCell(
          height: _style.cellHeight ?? 60,
          cell: cell,
          padding: verticalGap / 2,
          onTap: _handleCellTap,
          dateList: dateList,
          rowIndex: rowIndex,
          colIndex: colIndex,
          cellBuilder: widget.cellBuilder,
          subtitleBuilder: widget.subtitleBuilder,
          dayStyle: _style.dayStyle,
          todayDayStyle: _style.todayDayStyle,
          subtitleStyle: _style.subtitleStyle,
        );
      },
    );
  }

  /// 月份单元格列表新生成时被 body 调用：登记 selected 引用，
  /// 让 state 不依赖 body 内部缓存即可定位当前选中的 cell 实例。
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
  void _handleCellTap(TCalendarCellModel cell) {
    final selectType = cell.typeNotifier.value;
    final curDate = cell.date;

    if (selectType == DateSelectType.disabled) {
      widget.onCellTap?.call(cell);
      return;
    }

    switch (widget.type) {
      case CalendarType.single:
        if (identical(_selectedSingleRef, cell)) {
          widget.onCellTap?.call(cell);
          return;
        }
        _selectedSingleRef?.typeNotifier.setType(DateSelectType.empty);
        cell.typeNotifier.setType(DateSelectType.selected);
        _selectedSingleRef = cell;
        _emitSelection([curDate], rebuild: false);
        widget.onCellTap?.call(cell);
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
        widget.onCellTap?.call(cell);
        break;
      case CalendarType.range:
        final resolved = _resolveRangeSelection([curDate]);
        _emitSelection(resolved, rebuild: true);
        widget.onCellTap?.call(cell);
        break;
    }
  }

  /// 统一更新选中值并触发回调。
  void _emitSelection(List<DateTime> value, {required bool rebuild}) {
    final normalized = TCalendar._normalizeDateList(value);
    _cachedValueDates = normalized;
    widget.onChange(List<DateTime>.from(normalized));
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

  /// 内嵌模式下不传 `height` 时的默认高度。
  ///
  /// 布局 = weekday(46) + monthTitle(22) + 5行(cellHeight + verticalGap) + bodyPadding*2
  double _calcInlineDefaultHeight(double verticalGap) {
    final weekdayHeight = TCalendar._kWeekdayHeight;
    final monthTitleHeight = _style.monthTitleHeight ?? 22;
    final cellHeight = _style.cellHeight ?? 60;
    final bodyPadding = _style.bodyPadding ?? TTheme.of(context).spacer16;
    const visibleRows = 5;
    return weekdayHeight +
        monthTitleHeight +
        visibleRows * (cellHeight + verticalGap) +
        bodyPadding * 2;
  }
}

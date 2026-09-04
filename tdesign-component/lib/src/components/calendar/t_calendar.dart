import 'package:flutter/material.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import '../../util/context_extension.dart';
import '../text/t_text.dart';
import 't_calendar_body.dart';
import 't_calendar_cell.dart';
import 't_calendar_header.dart';
import 't_calendar_style.dart';
import 't_calendar_theme_data.dart';
import 't_calendar_types.dart';

export 't_calendar_cell.dart'
    show
        TCalendarCellModel,
        TCalendarSubtitleContext,
        TCalendarSubtitleBuilder,
        TCalendarCellBuilder,
        TCalendarMonthTitleBuilder;
export 't_calendar_types.dart' show DateSelectType, TCalendarFirstDayOfWeek;

// ---------------------------------------------------------------------------
// TCalendar — 纯日历组件
// ---------------------------------------------------------------------------

/// 严格受控的日历面板，不包含弹窗、工具栏或确认操作。
///
/// [value] 与 [onChanged] 构成受控选择状态；[onChanged] 为 null 时禁用。
class TCalendar extends StatefulWidget {
  TCalendar({
    super.key,

    /// 受控选中日期。
    required this.value,

    /// 每周从星期几开始，默认从星期日开始。
    this.firstDayOfWeek = TCalendarFirstDayOfWeek.sunday,

    /// 最小可选日期。
    DateTime? minDate,

    /// 最大可选日期。
    DateTime? maxDate,

    /// 选择模式。
    this.variant = TCalendarVariant.single,

    /// 选中日期变化回调；为 null 时禁用。
    this.onChanged,

    /// 可见月份变化回调。
    this.onMonthChanged,

    /// 月标题构建器。
    TCalendarMonthTitleBuilder? monthTitleBuilder,

    /// 日期格构建器。
    this.cellBuilder,

    /// 日期副标题构建器。
    this.subtitleBuilder,

    /// 锚点滚动是否使用动画。
    this.animateTo = false,

    /// 滚动锚点日期。
    this.anchorDate,
  }) : assert(
         minDate == null ||
             maxDate == null ||
             !_dateOnly(minDate).isAfter(_dateOnly(maxDate)),
         'minDate 不能晚于 maxDate',
       ),
       minDate = minDate == null ? _getDefaultMinDate() : _dateOnly(minDate),
       maxDate = maxDate == null ? _getDefaultMaxDate() : _dateOnly(maxDate),
       monthTitleBuilder = monthTitleBuilder ?? _defaultMonthTitleBuilder;

  /// 每周从星期几开始，默认从星期日开始。
  final TCalendarFirstDayOfWeek firstDayOfWeek;

  /// 最小可选的日期，默认 1970-01-01
  final DateTime minDate;

  /// 最大可选的日期，默认 2100-12-31
  final DateTime maxDate;

  /// 日历的选择模式（保留 variant 命名，不表示视觉变体），决定点击后的行为：
  /// - [TCalendarVariant.single]：单选，点击新日期取消旧选中
  /// - [TCalendarVariant.multiple]：多选，点击切换选中/取消
  /// - [TCalendarVariant.range]：区间选择，依次选起止日期
  final TCalendarVariant variant;

  /// 受控选中日期列表。
  ///
  /// 列表长度与 [variant] 对应：
  /// - [TCalendarVariant.single]：1 个元素（选中日期）
  /// - [TCalendarVariant.multiple]：N 个元素（所有选中日期）
  /// - [TCalendarVariant.range]：2 个元素（起始、结束日期）
  final List<DateTime> value;

  /// 选中结果变化时触发（单选立即触发；多选每次切换；区间在端点变化时触发）。
  ///
  /// 父组件应在回调中更新 [value]。组件挂载时不会调用本回调。
  final ValueChanged<List<DateTime>>? onChanged;

  /// 可见月份变化时触发（用户滑动或程序化滚动结束后），参数为当月 1 日。
  ///
  /// 外置控制栏可只更新自身文案，避免为同步月份对 [TCalendar] 整组件 `setState`。
  final ValueChanged<DateTime>? onMonthChanged;

  /// 月标题构建器，参数 [DateTime] 为当月 1 日（仅年月有效）。
  final TCalendarMonthTitleBuilder monthTitleBuilder;

  /// 整格自定义构建器；返回非 null 时替换该格默认布局（主数字 + 副标题均不渲染）。
  ///
  /// 返回非 null 时优先于 [subtitleBuilder]；返回 null 时使用默认日期格及副标题。
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
  /// 未设置时：有非空 [value] 则滚到其中最早一日所在月，否则滚到 [minDate] 首月。
  final DateTime? anchorDate;

  // ---------------------------------------------------------------------------
  // 默认值
  // ---------------------------------------------------------------------------
  static DateTime _getDefaultMinDate() => DateTime(1970, 1, 1);
  static DateTime _getDefaultMaxDate() => DateTime(2100, 12, 31);
  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);
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

  /// 将 [value] 规范为仅含年月日的 [DateTime] 列表，避免动态列表或带时分秒导致比较异常。
  static List<DateTime> _normalizeDateList(Iterable<DateTime> dates) {
    return dates
        .map((d) => DateTime(d.year, d.month, d.day))
        .toList(growable: false);
  }

  List<DateTime> get _value => _normalizeDateList(value);

  @override
  _TCalendarState createState() => _TCalendarState();
}

class _TCalendarState extends State<TCalendar> {
  late List<String> weekdayNames;
  late List<String> monthNames;
  late TCalendarStyle _style;

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
    _style = _resolveStyle(context);
  }

  /// P1: 从 ThemeExtension 解析样式（mergeExtension 子树覆盖 → token 默认）
  TCalendarStyle _resolveStyle(BuildContext context) {
    final theme = Theme.of(context).extension<TCalendarThemeData>();
    final base = TCalendarStyle.generateStyle(context: context);
    return TCalendarStyle(
      decoration: theme?.decoration ?? base.decoration,
      weekdayStyle: theme?.weekdayStyle ?? base.weekdayStyle,
      monthTitleStyle: theme?.monthTitleStyle ?? base.monthTitleStyle,
      dayStyle: theme?.dayStyle ?? base.dayStyle,
      todayDayStyle: theme?.todayDayStyle ?? base.todayDayStyle,
      cellDecoration: theme?.cellDecoration ?? base.cellDecoration,
      subtitleStyle: theme?.subtitleStyle ?? base.subtitleStyle,
      cellHeight: theme?.cellHeight ?? base.cellHeight,
      monthTitleHeight: theme?.monthTitleHeight ?? base.monthTitleHeight,
      verticalGap: theme?.verticalGap ?? base.verticalGap,
      bodyPadding: theme?.bodyPadding ?? base.bodyPadding,
      weekdayGap: theme?.weekdayGap ?? base.weekdayGap,
      centreColor: theme?.centreColor ?? base.centreColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final verticalGap = _style.verticalGap ?? context.tTheme.spacer8;

    final calendar = Container(
      height:
          Theme.of(context).extension<TCalendarThemeData>()?.height ??
          _calcInlineDefaultHeight(verticalGap),
      width: double.infinity,
      decoration: _style.decoration,
      child: Column(
        children: [
          TCalendarHeader(
            firstDayOfWeek: widget.firstDayOfWeek.index,
            weekdayGap: _style.weekdayGap ?? context.tTheme.spacer4,
            padding: _style.bodyPadding ?? context.tTheme.spacer16,
            weekdayStyle: _style.weekdayStyle,
            weekdayHeight: _style.weekdayHeight,
            weekdayNames: weekdayNames,
          ),
          Expanded(child: _buildCalendarBody(verticalGap)),
        ],
      ),
    );
    final isDisabled = widget.onChanged == null;
    return Semantics(
      enabled: !isDisabled,
      child: AnimatedOpacity(
        opacity: isDisabled ? 0.5 : 1,
        duration: const Duration(milliseconds: 150),
        child: AbsorbPointer(absorbing: isDisabled, child: calendar),
      ),
    );
  }

  Widget _buildCalendarBody(double verticalGap) {
    return TCalendarBody(
      type: widget.variant,
      firstDayOfWeek: widget.firstDayOfWeek.index,
      minDate: widget.minDate,
      maxDate: widget.maxDate,
      value: widget._value,
      bodyPadding: _style.bodyPadding ?? context.tTheme.spacer16,
      monthNames: monthNames,
      monthTitleStyle: _style.monthTitleStyle,
      verticalGap: verticalGap,
      cellHeight: _style.cellHeight,
      monthTitleHeight: _style.monthTitleHeight,
      monthTitleBuilder: widget.monthTitleBuilder,
      anchorDate: widget.anchorDate,
      animateTo: widget.animateTo,
      onMonthChange: widget.onMonthChanged,
      builder: (cell, dateList, rowIndex, colIndex) {
        return TCalendarCell(
          height: _style.cellHeight,
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
          cellDecoration: _style.cellDecoration,
          centreColor: _style.centreColor,
        );
      },
    );
  }

  /// 三种模式统一入口：cell 仅上抛被点击的模型，由本方法做所有决策。
  void _handleCellTap(TCalendarCellModel cell) {
    if (widget.onChanged == null) {
      return;
    }
    final selectType = cell.selectType;
    final curDate = cell.date;

    if (selectType == DateSelectType.disabled) {
      return;
    }

    final current = widget._value;
    switch (widget.variant) {
      case TCalendarVariant.single:
        if (current.length == 1 && current.first == curDate) {
          return;
        }
        _emitSelection([curDate]);
        break;
      case TCalendarVariant.multiple:
        final nextValue = List<DateTime>.from(current);
        if (nextValue.contains(curDate)) {
          nextValue.remove(curDate);
        } else {
          nextValue.add(curDate);
        }
        nextValue.sort();
        _emitSelection(nextValue);
        break;
      case TCalendarVariant.range:
        final resolved = _resolveRangeSelection([curDate]);
        _emitSelection(resolved);
        break;
    }
  }

  /// 统一更新选中值并触发回调。
  void _emitSelection(List<DateTime> value) {
    final normalized = TCalendar._normalizeDateList(value);
    widget.onChanged?.call(List<DateTime>.from(normalized));
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
    final current = widget._value;
    final hasStart = current.isNotEmpty;
    final hasEnd = current.length >= 2;
    if (hasStart && !hasEnd && tapped.isAfter(current[0])) {
      return [current[0], tapped];
    }
    return [tapped];
  }

  /// 内嵌模式下不传 `height` 时的默认高度。
  ///
  /// 布局 = weekday(46) + monthTitle(22) + 6行(cellHeight + verticalGap) + bodyPadding*2
  double _calcInlineDefaultHeight(double verticalGap) {
    const weekdayHeight = TCalendar._kWeekdayHeight;
    final monthTitleHeight = _style.monthTitleHeight;
    final cellHeight = _style.cellHeight;
    final bodyPadding = _style.bodyPadding ?? context.tTheme.spacer16;
    const visibleRows = 6;
    return weekdayHeight +
        monthTitleHeight +
        visibleRows * (cellHeight + verticalGap) +
        bodyPadding * 2;
  }
}

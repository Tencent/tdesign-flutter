import 'package:flutter/material.dart';
import '../../theme/t_colors.dart';
import '../../theme/t_theme.dart';
import '../../util/iterable_ext.dart';
import '../text/t_text.dart';
import 't_calendar_style.dart';
import 't_calendar_types.dart';

export 't_calendar_types.dart' show DateSelectType;

/// 副标题构建上下文：告知 [TCalendarSubtitleBuilder] 当前渲染哪一格。
class TCalendarSubtitleContext {
  const TCalendarSubtitleContext({
    required this.date,
    required this.selectType,
  });

  /// 当前格子的阳历日期（仅年月日，无时分秒）。
  final DateTime date;

  /// 当前格的选中/区间/禁用等展示状态，便于按态设置副标题样式。
  final DateSelectType selectType;
}

/// 副标题构建器；每个日期格渲染时调用一次。
///
/// 通过 [TCalendarSubtitleContext] 获取日期与选中态；返回 `null` 表示不显示副标题行。
///
/// ```dart
/// subtitleBuilder: (context, ctx) {
///   final text = lunarLabel(ctx.date);
///   if (text == null) return null;
///   return TText(text, style: TextStyle(fontSize: 9));
/// },
/// ```
typedef TCalendarSubtitleBuilder = Widget? Function(
  BuildContext context,
  TCalendarSubtitleContext subtitleContext,
);

/// 整格自定义构建器；返回非 null 时该格由接入方完全绘制（含主数字与副标题）。
typedef TCalendarCellBuilder = Widget? Function(
  BuildContext context,
  TCalendarCellModel cell,
);

/// 月标题构建器；[monthDate] 为当月 1 日。
typedef TCalendarMonthTitleBuilder = Widget Function(
  BuildContext context,
  DateTime monthDate,
);

/// 单个日期格数据（只读，选中态通过 [typeNotifier] 更新）
class TCalendarCellModel {
  TCalendarCellModel({
    required this.date,
    required this.typeNotifier,
    required this.isLastDayOfMonth,
  });

  /// 当前日期。
  final DateTime date;

  /// 日期选择状态通知器。
  final DateSelectTypeNotifier typeNotifier;

  /// 是否为当月最后一天。
  final bool isLastDayOfMonth;

  DateSelectType get selectType => typeNotifier.value;
}

class DateSelectTypeNotifier extends ChangeNotifier {
  DateSelectType value = DateSelectType.empty;

  DateSelectTypeNotifier(DateSelectType selectType) {
    value = selectType;
  }

  void setType(DateSelectType type) {
    value = type;
    notifyListeners();
  }
}

class TCalendarCell extends StatefulWidget {
  const TCalendarCell({
    Key? key,
    this.cell,
    this.onTap,
    required this.height,
    required this.padding,
    required this.rowIndex,
    required this.colIndex,
    required this.dateList,
    this.cellBuilder,
    this.subtitleBuilder,
    this.dayStyle,
    this.todayDayStyle,
    this.subtitleStyle,
  }) : super(key: key);

  final TCalendarCellModel? cell;

  final void Function(TCalendarCellModel cell)? onTap;

  final double height;
  final double padding;
  final int rowIndex;
  final int colIndex;
  final List<TCalendarCellModel?> dateList;
  final TCalendarCellBuilder? cellBuilder;
  final TCalendarSubtitleBuilder? subtitleBuilder;
  final TextStyle? dayStyle;
  final TextStyle? todayDayStyle;
  final TextStyle? subtitleStyle;

  @override
  State<TCalendarCell> createState() => _TCalendarCellState();
}

class _TCalendarCellState extends State<TCalendarCell> {
  var _isToday = false;
  var _positionOffset = 0;

  @override
  void initState() {
    super.initState();
    _isToday = _checkIsToday();
    widget.cell?.typeNotifier.addListener(_onSelectTypeChange);
  }

  @override
  void didUpdateWidget(TCalendarCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.cell != oldWidget.cell) {
      _isToday = _checkIsToday();
      oldWidget.cell?.typeNotifier.removeListener(_onSelectTypeChange);
      widget.cell?.typeNotifier.addListener(_onSelectTypeChange);
    }
  }

  @override
  void dispose() {
    widget.cell?.typeNotifier.removeListener(_onSelectTypeChange);
    super.dispose();
  }

  bool _checkIsToday() {
    final today = DateTime.now();
    return widget.cell?.date == DateTime(today.year, today.month, today.day);
  }

  @override
  Widget build(BuildContext context) {
    final cell = widget.cell;
    if (cell == null) {
      return const SizedBox.shrink();
    }

    final themedStyle = TCalendarStyle.generateStyle(context: context)
        .forSelectType(context, cell.selectType);
    final decoration = themedStyle.cellDecoration;
    final positionColor = _rangeBridgeColor(context, themedStyle, decoration);

    final content = widget.cellBuilder?.call(context, cell) ??
        _buildDefaultCell(context, cell, themedStyle);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => widget.onTap?.call(cell),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRect(
            child: Container(
              width: double.infinity,
              height: widget.height,
              decoration: decoration,
              child: content,
            ),
          ),
          if (widget.colIndex < 6)
            Positioned(
              right: -widget.padding - _positionOffset,
              child: Container(
                width: widget.padding + 2 * _positionOffset,
                height: widget.height,
                color: positionColor,
              ),
            ),
        ],
      ),
    );
  }

  void _onSelectTypeChange() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Color? _rangeBridgeColor(
    BuildContext context,
    TCalendarStyle cellStyle,
    BoxDecoration? decoration,
  ) {
    _positionOffset = 0;
    final bridgeColor = cellStyle.centreColor ?? context.tTheme.brandLightColor;
    final next = _nextDay();
    if (widget.cell?.selectType == DateSelectType.start) {
      if (widget.cell?.isLastDayOfMonth == true) {
        return null;
      }
      if (next?.selectType == DateSelectType.end) {
        _positionOffset = 1;
        return decoration?.color;
      }
      if (next?.selectType == DateSelectType.centre) {
        return bridgeColor;
      }
    }
    if (widget.cell?.selectType == DateSelectType.centre) {
      return bridgeColor;
    }
    return null;
  }

  TCalendarCellModel? _nextDay([int offset = 1]) {
    final index = widget.rowIndex * 7 + widget.colIndex + offset;
    return widget.dateList.getOrNull(index);
  }

  Widget _buildDefaultCell(
    BuildContext context,
    TCalendarCellModel cell,
    TCalendarStyle cellStyle,
  ) {
    final dayText = cell.date.day.toString();
    final dayTextStyle = (_isToday ? cellStyle.todayDayStyle : null) ??
        widget.todayDayStyle ??
        cellStyle.dayStyle ??
        widget.dayStyle;

    final subtitle = _buildSubtitle(context, cell, cellStyle);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TText(
          dayText,
          forceVerticalCenter: subtitle == null,
          style: dayTextStyle,
        ),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: subtitle,
          ),
      ],
    );
  }

  Widget? _buildSubtitle(
    BuildContext context,
    TCalendarCellModel cell,
    TCalendarStyle cellStyle,
  ) {
    return widget.subtitleBuilder?.call(
      context,
      TCalendarSubtitleContext(
        date: cell.date,
        selectType: cell.selectType,
      ),
    );
  }
}

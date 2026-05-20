import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';
import '../../util/iterable_ext.dart';
import 't_calendar_data_source.dart';
import 't_calendar_style.dart';

/// 日期在日历格中的选中/展示状态
enum DateSelectType { selected, disabled, start, centre, end, empty }

/// 副标题构建上下文
class TCalendarSubtitleContext {
  const TCalendarSubtitleContext({
    required this.date,
    required this.selectType,
  });

  final DateTime date;
  final DateSelectType selectType;
}

/// 副标题完全自定义
typedef TCalendarSubtitleBuilder = Widget? Function(
  BuildContext context,
  TCalendarSubtitleContext subtitleContext,
);

/// 整格自定义（主区 + 副标题均由接入方绘制）
typedef TCalendarCellBuilder = Widget? Function(
  BuildContext context,
  TCalendarCellModel cell,
);

/// 单个日期格数据（只读，选中态通过 [typeNotifier] 更新）
class TCalendarCellModel {
  TCalendarCellModel({
    required this.date,
    required this.typeNotifier,
    required this.isLastDayOfMonth,
  });

  final DateTime date;
  final DateSelectTypeNotifier typeNotifier;
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
    this.dataSource,
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
  final TCalendarDataSource? dataSource;
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
    return widget.cell?.date ==
        DateTime(today.year, today.month, today.day);
  }

  @override
  Widget build(BuildContext context) {
    final cell = widget.cell;
    if (cell == null) {
      return const SizedBox.shrink();
    }

    final themedStyle =
        TCalendarStyle.forSelectType(context, cell.selectType);
    final decoration =
        themedStyle.cellDecoration;
    final positionColor = _rangeBridgeColor(themedStyle, decoration);

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
    setState(() {});
  }

  Color? _rangeBridgeColor(
      TCalendarStyle cellStyle, BoxDecoration? decoration) {
    _positionOffset = 0;
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
        return cellStyle.centreColor;
      }
    }
    if (widget.cell?.selectType == DateSelectType.centre) {
      return cellStyle.centreColor;
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
    if (widget.subtitleBuilder != null) {
      return widget.subtitleBuilder!(
        context,
        TCalendarSubtitleContext(
          date: cell.date,
          selectType: cell.selectType,
        ),
      );
    }

    final text = widget.dataSource?.getSubtitle(cell.date);
    if (text == null || text.isEmpty) {
      return null;
    }

    return TText(
      text,
      style: cellStyle.subtitleStyle ??
          widget.subtitleStyle?.copyWith(fontSize: 9),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

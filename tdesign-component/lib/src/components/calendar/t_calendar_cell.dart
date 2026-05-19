import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';
import '../../util/iterable_ext.dart';

class TCalendarCell extends StatefulWidget {
  const TCalendarCell({
    Key? key,
    this.tdate,
    this.onTap,
    required this.height,
    required this.padding,
    required this.rowIndex,
    required this.colIndex,
    required this.dateList,
    this.cellWidget,
    this.dateType = TCalendarDateType.solar,
    this.showLunarInfo = false,
  }) : super(key: key);

  final TDate? tdate;

  /// 点击回调。cell 不再负责任何选中态决策，只把"被点击的这一格"上抛给
  /// 上层 state，由其结合 [CalendarType] 决定如何更新选中。
  ///
  /// 当点击 disabled cell 时同样会回调（state 内部按需要分流到 onCellClick）。
  final void Function(TDate tdate)? onTap;

  final double height;
  final double padding;
  final int rowIndex;
  final int colIndex;
  final List<TDate?> dateList;
  final Widget? Function(
    BuildContext context,
    TDate tdate,
    DateSelectType selectType,
  )? cellWidget;
  final TCalendarDateType dateType;
  final bool showLunarInfo;

  @override
  _TCalendarCellState createState() => _TCalendarCellState();
}

class _TCalendarCellState extends State<TCalendarCell> {
  var isToday = false;
  var positionOffset = 0;

  @override
  void initState() {
    super.initState();
    isToday = _isToday();
    widget.tdate?.typeNotifier.addListener(_cellTypeChange);
  }

  @override
  void didUpdateWidget(TCalendarCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tdate != oldWidget.tdate) {
      isToday = _isToday();
      oldWidget.tdate?.typeNotifier.removeListener(_cellTypeChange);
      widget.tdate?.typeNotifier.addListener(_cellTypeChange);
    }
  }

  @override
  void dispose() {
    widget.tdate?.typeNotifier.removeListener(_cellTypeChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tdate = widget.tdate;
    if (tdate == null) {
      return const SizedBox.shrink();
    }
    final cellStyle = TCalendarStyle.cellStyle(context, tdate._type);
    final decoration = tdate.decoration ?? cellStyle.cellDecoration;
    final positionColor = _getColor(cellStyle, decoration);

    // 新增自定义cell内容判断逻辑
    final content = widget.cellWidget?.call(context, tdate, tdate._type) ??
        _buildDefaultCell(context, tdate, cellStyle);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _cellTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRect(
            child: Container(
              width: double.infinity,
              height: widget.height,
              decoration: decoration,
              child: content, // 使用自定义内容
            ),
          ),
          if (widget.colIndex < 6)
            Positioned(
              right: -widget.padding - positionOffset,
              child: Container(
                width: widget.padding + 2 * positionOffset,
                height: widget.height,
                color: positionColor,
              ),
            ),
        ],
      ),
    );
  }

  void _cellTap() {
    final tdate = widget.tdate;
    if (tdate == null) {
      return;
    }
    // 三种模式统一：cell 不再做任何决策，只把被点击的 TDate 上抛。
    // 由 [_TCalendarState] 结合 widget.type / 当前选中映射 / value 决定如何更新。
    widget.onTap?.call(tdate);
  }

  void _cellTypeChange() {
    setState(() {});
  }

  Color? _getColor(TCalendarStyle cellStyle, BoxDecoration? decoration) {
    positionOffset = 0;
    final next = _nextDay();
    if (widget.tdate?._type == DateSelectType.start) {
      if (widget.tdate?.isLastDayOfMonth == true) {
        return null;
      }
      if (next?._type == DateSelectType.end) {
        positionOffset = 1;
        return decoration?.color;
      }
      if (next?._type == DateSelectType.centre) {
        return cellStyle.centreColor;
      }
    }
    if (widget.tdate?._type == DateSelectType.centre) {
      return cellStyle.centreColor;
    }
    return null;
  }

  TDate? _nextDay([int num = 1]) {
    final index = widget.rowIndex * 7 + widget.colIndex + num;
    final date = widget.dateList.getOrNull(index);
    return date;
  }

  bool _isToday() {
    final today = DateTime.now();
    return widget.tdate?.date ==
        DateTime(today.year, today.month, today.day);
  }

  /// 构建默认单元格内容
  Widget _buildDefaultCell(
      BuildContext context, TDate tdate, TCalendarStyle cellStyle) {
    // 根据 dateType 和 showLunarInfo 决定显示内容
    var mainText = widget.tdate!.date.day.toString();
    String? subText;

    if (widget.dateType == TCalendarDateType.lunar && tdate.lunarInfo != null) {
      // 农历模式：主文本显示农历，副文本显示阳历日期
      mainText = tdate.lunarInfo!.dayText;
      subText = widget.tdate!.date.day.toString();
    } else if (widget.dateType == TCalendarDateType.solar &&
        widget.showLunarInfo) {
      // 阳历模式+显示农历信息
      mainText = widget.tdate!.date.day.toString();

      // 优先级：节日 > 节气 > 农历日期
      if (tdate.festival != null && tdate.festival!.isNotEmpty) {
        subText = tdate.festival;
      } else if (tdate.solarTerm != null && tdate.solarTerm!.isNotEmpty) {
        subText = tdate.solarTerm;
      } else if (tdate.lunarInfo != null) {
        subText = tdate.lunarInfo!.dayText;
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // prefix 区域 - 不强制高度
        if (tdate.prefix != null || tdate.prefixWidget != null)
          SizedBox(
            height: 12,
            child: tdate.prefixWidget ??
                TText(
                  tdate.prefix ?? '',
                  style: tdate.prefixStyle ?? cellStyle.cellPrefixStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
          ),
        // 主内容区域 - 自适应高度
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TText(
                  forceVerticalCenter: subText == null,
                  mainText,
                  style: (isToday ? cellStyle.todayStyle : null) ??
                      tdate.style ??
                      cellStyle.cellStyle,
                ),
                if (subText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: TText(
                      subText,
                      style: cellStyle.cellSuffixStyle?.copyWith(fontSize: 9),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        ),
        // suffix 区域 - 不强制高度
        if (tdate.suffix != null || tdate.suffixWidget != null)
          SizedBox(
            height: 12,
            child: tdate.suffixWidget ??
                TText(
                  tdate.suffix ?? '',
                  style: tdate.suffixStyle ?? cellStyle.cellSuffixStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
          ),
      ],
    );
  }
}

/// 时间对象
///
/// 不可变数据载体（除 [typeNotifier] 外所有字段均为 final）。
///
/// 选中类型的变化通过 [typeNotifier] 通知监听者；其它视觉字段（[prefix] /
/// [suffix] / [style] / [decoration] 等）请在构造时传入，不要构造后再 mutate
/// ——这些字段不发出变更通知，cell 也不会响应运行时修改。
class TDate {
  TDate({
    required this.date,
    required this.typeNotifier,
    this.prefix,
    this.prefixStyle,
    this.prefixWidget,
    this.suffix,
    this.suffixStyle,
    this.suffixWidget,
    this.style,
    this.decoration,
    required this.isLastDayOfMonth,
    this.lunarInfo,
    this.solarTerm,
    this.festival,
    this.holidayInfo,
  });

  /// 时间对象
  final DateTime date;

  /// 日期类型
  final DateSelectTypeNotifier typeNotifier;

  /// 日期前面的字符串
  final String? prefix;

  /// 日期前面的字符串的样式
  final TextStyle? prefixStyle;

  /// 日期前面的组件，优先级高于[prefix]
  final Widget? prefixWidget;

  /// 日期后面的字符串
  final String? suffix;

  /// 日期后面的字符串的样式
  final TextStyle? suffixStyle;

  /// 日期后面的组件，优先级高于[suffix]
  final Widget? suffixWidget;

  /// 日期样式
  final TextStyle? style;

  /// 日期Decoration
  final BoxDecoration? decoration;

  /// 是否是当月最后一天
  final bool isLastDayOfMonth;

  /// 农历信息
  final TLunarInfo? lunarInfo;

  /// 节气信息（如"春分"、"立夏"）
  final String? solarTerm;

  /// 节日信息（如"春节"、"中秋节"）
  final String? festival;

  /// 假期信息（包含类型和名称）
  /// type: 'holiday' 或 'workday'
  /// name: 假期名称
  final Map<String, String>? holidayInfo;

  DateSelectType get _type => typeNotifier.value;
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

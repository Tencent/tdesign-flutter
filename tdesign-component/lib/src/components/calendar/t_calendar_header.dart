import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';
import 't_calendar_cell.dart';

class TCalendarHeader extends StatelessWidget {
  const TCalendarHeader({
    Key? key,
    required this.firstDayOfWeek,
    required this.weekdayGap,
    required this.padding,
    this.weekdayStyle,
    required this.weekdayHeight,
    this.titleWidget,
    this.titleStyle,
    this.titleMaxLine,
    this.titleOverflow,
    this.closeBtn = true,
    this.closeColor,
    this.onClose,
    required this.weekdayNames,
  }) : super(key: key);

  final int firstDayOfWeek;
  final double weekdayGap;
  final double padding;
  final TextStyle? weekdayStyle;
  final double weekdayHeight;
  final Widget? titleWidget;
  final TextStyle? titleStyle;
  final int? titleMaxLine;
  final TextOverflow? titleOverflow;
  final bool closeBtn;
  final Color? closeColor;
  final VoidCallback? onClose;
  final List<String> weekdayNames;

  List<String> _getWeeks(BuildContext context) {
    final ans = <String>[];
    var i = firstDayOfWeek % 7;
    while (ans.length < 7) {
      ans.add(weekdayNames[i]);
      i = (i + 1) % 7;
    }
    return ans;
  }

  @override
  Widget build(BuildContext context) {
    final list = _getWeeks(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Column(
        children: [
          if (titleWidget != null || closeBtn)
            Container(
              padding: EdgeInsets.symmetric(vertical: padding),
              child: Row(
                children: [
                  if (closeBtn) const SizedBox(width: 24),
                  Expanded(
                    child: Center(
                      child: titleWidget ?? const SizedBox.shrink(),
                    ),
                  ),
                  if (closeBtn)
                    SizedBox(
                      width: 24,
                      child: GestureDetector(
                        child: Icon(TIcons.close, color: closeColor),
                        onTap: () {
                          onClose?.call();
                        },
                      ),
                    ),
                ],
              ),
            ),
          Row(
            children: [
              for (int index = 0; index < list.length; index++) ...[
                if (index != 0) SizedBox(width: weekdayGap),
                Expanded(
                  child: SizedBox(
                    height: weekdayHeight,
                    child: Center(
                      child: TText(
                        list[index],
                        style: weekdayStyle,
                      ),
                    ),
                  ),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}

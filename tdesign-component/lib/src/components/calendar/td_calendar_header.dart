import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

class TDCalendarHeader extends StatelessWidget {
  const TDCalendarHeader({
    Key? key,
    required this.firstDayOfWeek,
    required this.weekdayGap,
    required this.padding,
    this.weekdayStyle,
    required this.weekdayHeight,
    this.title,
    this.titleStyle,
    this.titleWidget,
    this.titleMaxLine,
    this.titleOverflow,
    this.closeBtn = true,
    this.closeColor,
    this.onClose,
    this.onClick,
    required this.weekdayNames,
  }) : super(key: key);

  final int firstDayOfWeek;
  final double weekdayGap;
  final double padding;
  final TextStyle? weekdayStyle;
  final double weekdayHeight;
  final String? title;
  final TextStyle? titleStyle;
  final Widget? titleWidget;
  final int? titleMaxLine;
  final TextOverflow? titleOverflow;
  final bool closeBtn;
  final Color? closeColor;
  final VoidCallback? onClose;
  final List<String> weekdayNames;
  final void Function(int index, String week)? onClick;

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
      padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
      child: Column(
        children: [
          if (title?.isNotEmpty == true || titleWidget != null || closeBtn)
            Container(
              padding: EdgeInsets.fromLTRB(0, padding, 0, padding),
              child: Row(
                children: [
                  if (closeBtn) const SizedBox(width: 24),
                  Expanded(
                    child: Center(
                      child: titleWidget ??
                          TDText(
                            title,
                            style: titleStyle,
                            maxLines: titleMaxLine,
                            overflow: TextOverflow.ellipsis,
                          ),
                    ),
                  ),
                  if (closeBtn)
                    SizedBox(
                      width: 24,
                      child: GestureDetector(
                        child: Icon(TDIcons.close, color: closeColor),
                        onTap: () {
                          onClose?.call();
                        },
                      ),
                    ),
                ],
              ),
            ),
          Row(
            children: List.generate(list.length, (index) {
              return [
                if (index != 0) SizedBox(width: weekdayGap),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      onClick?.call(index, list[index]);
                    },
                    child: SizedBox(
                      height: weekdayHeight,
                      child: Center(
                        child: TDText(
                          list[index],
                          style: weekdayStyle,
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            }).expand((element) => element).toList(),
          ),
        ],
      ),
    );
  }
}

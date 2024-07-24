import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import '../../util/context_extension.dart';

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
    this.closeBtn = true,
    this.onClose,
  }) : super(key: key);

  final int firstDayOfWeek;
  final double weekdayGap;
  final double padding;
  final TextStyle? weekdayStyle;
  final double weekdayHeight;
  final String? title;
  final TextStyle? titleStyle;
  final Widget? titleWidget;
  final bool closeBtn;
  final VoidCallback? onClose;

  List<String> getDays(BuildContext context) {
    final raw = [
      context.resource.sunday,
      context.resource.monday,
      context.resource.tuesday,
      context.resource.wednesday,
      context.resource.thursday,
      context.resource.friday,
      context.resource.saturday,
    ];
    final ans = <String>[];
    var i = firstDayOfWeek % 7;
    while (ans.length < 7) {
      ans.add(raw[i]);
      i = (i + 1) % 7;
    }
    return ans;
  }

  @override
  Widget build(BuildContext context) {
    final list = getDays(context);
    return Container(
      padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
      child: Column(
        children: [
          if (title?.isNotEmpty == true || titleWidget != null)
            Container(
              padding: EdgeInsets.fromLTRB(0, padding, 0, padding),
              child: Center(
                child: titleWidget ??
                    TDText(
                      title,
                      style: titleStyle,
                    ),
              ),
            ),
          Row(
            children: List.generate(list.length, (index) {
              return Expanded(
                child: Container(
                  height: weekdayHeight,
                  margin: list.length == index + 1 ? null : EdgeInsets.only(right: weekdayGap),
                  child: Center(
                    child: TDText(
                      list[index],
                      style: weekdayStyle,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

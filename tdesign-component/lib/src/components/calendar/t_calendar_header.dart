import 'package:flutter/material.dart';

import '../text/t_text.dart';

// ---------------------------------------------------------------------------
// TCalendarHeader — 星期标题栏
// ---------------------------------------------------------------------------

/// 日历的星期标题栏。
class TCalendarHeader extends StatelessWidget {
  const TCalendarHeader({
    Key? key,
    required this.firstDayOfWeek,
    required this.weekdayGap,
    required this.padding,
    this.weekdayStyle,
    required this.weekdayHeight,
    required this.weekdayNames,
  }) : super(key: key);

  /// 第一天从星期几开始，0 = 周日，1 = 周一，…，6 = 周六。
  final int firstDayOfWeek;

  /// 星期之间的水平间距
  final double weekdayGap;

  /// 内边距
  final double padding;

  /// 星期文字样式
  final TextStyle? weekdayStyle;

  /// 星期行高度
  final double weekdayHeight;

  /// 星期名称列表（内部自动获取）
  final List<String> weekdayNames;

  List<String> _getWeeks() {
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
    final list = _getWeeks();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Row(
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
    );
  }
}

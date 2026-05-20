import 'package:flutter/foundation.dart';

/// 农历日期信息（仅示例用，业务请自行定义模型）。
///
/// 日历组件只要求 [TCalendarDataSource.getSubtitle] 返回字符串；
/// 本类演示如何从农历库组装副标题，非 `tdesign_flutter` 公共 API。
@immutable
class LunarInfo {
  final int year;
  final int month;
  final int day;
  final bool isLeapMonth;
  final String yearText;
  final String monthText;
  final String dayText;

  const LunarInfo({
    required this.year,
    required this.month,
    required this.day,
    this.isLeapMonth = false,
    required this.yearText,
    required this.monthText,
    required this.dayText,
  });

  String get fullText => '$yearText年 $monthText$dayText';

  @override
  String toString() => fullText;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is LunarInfo &&
        other.year == year &&
        other.month == month &&
        other.day == day &&
        other.isLeapMonth == isLeapMonth;
  }

  @override
  int get hashCode =>
      year.hashCode ^
      month.hashCode ^
      day.hashCode ^
      isLeapMonth.hashCode;
}

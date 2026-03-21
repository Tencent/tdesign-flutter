import 'package:flutter/foundation.dart';

/// 农历日期信息模型
@immutable
class TDLunarInfo {
  /// 农历年份（数字）
  final int year;

  /// 农历月份（数字，1-12）
  final int month;

  /// 农历日期（数字，1-30）
  final int day;

  /// 是否是闰月
  final bool isLeapMonth;

  /// 年份文本（如：二〇二五）
  final String yearText;

  /// 月份文本（如：三月、闰三月）
  final String monthText;

  /// 日期文本（如：初七）
  final String dayText;

  const TDLunarInfo({
    required this.year,
    required this.month,
    required this.day,
    this.isLeapMonth = false,
    required this.yearText,
    required this.monthText,
    required this.dayText,
  });

  /// 获取完整的农历日期文本
  String get fullText => '$yearText年 $monthText$dayText';

  @override
  String toString() => fullText;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is TDLunarInfo &&
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

/// 日历类型枚举
enum TDCalendarDateType {
  /// 阳历（公历）
  solar,

  /// 阴历（农历）
  lunar,
}

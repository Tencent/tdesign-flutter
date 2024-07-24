import 'package:flutter/material.dart';

enum TDateType { selected, disabled, start, centre, end, empty }

/// 时间对象
class TDate {
  TDate({
    required this.date,
    required this.type,
    this.prefix,
    this.prefixWidget,
    this.suffix,
    this.suffixWidget,
  }) {
    day = date.day;
    weekday = date.weekday;
  }

  /// 时间对象
  final DateTime date;
  /// 日
  int? day;
  /// 星期
  int? weekday;
  /// 日期类型
  final TDateType type;
  /// 日期前面的字符串
  final String? prefix;
  /// 日期前面的组件，优先级高于[prefix]
  final Widget? prefixWidget;
  /// 日期后面的字符串
  final String? suffix;
  /// 日期后面的组件，优先级高于[suffix]
  final Widget? suffixWidget;

}
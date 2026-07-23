import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TCalendar 组件级 ThemeExtension
///
/// 包含日历样式默认（装饰、字体、布局参数）。
/// 样式字段通过 mergeExtension 子树覆盖，无需构造器 P0 `style` 参数。
class TCalendarThemeData extends ThemeExtension<TCalendarThemeData> {
  /// 高度
  final double? height;

  /// 组件容器装饰
  final BoxDecoration? decoration;

  /// 星期文字样式
  final TextStyle? weekdayStyle;

  /// 月份标题文字样式
  final TextStyle? monthTitleStyle;

  /// 日期数字样式
  final TextStyle? dayStyle;

  /// 今天日期数字样式
  final TextStyle? todayDayStyle;

  /// 日期单元格装饰（选中状态）
  final BoxDecoration? cellDecoration;

  /// 副标题样式
  final TextStyle? subtitleStyle;

  /// 日期单元格高度，默认 60
  final double? cellHeight;

  /// 月份标题高度，默认 22
  final double? monthTitleHeight;

  /// 日期格垂直间距，水平间距为 [verticalGap] / 2
  final double? verticalGap;

  /// 内边距
  final double? bodyPadding;

  /// 星期之间的水平间距
  final double? weekdayGap;

  /// 区间中间格背景与格间衔接条颜色
  final Color? centreColor;

  const TCalendarThemeData({
    this.height,
    this.decoration,
    this.weekdayStyle,
    this.monthTitleStyle,
    this.dayStyle,
    this.todayDayStyle,
    this.cellDecoration,
    this.subtitleStyle,
    this.cellHeight,
    this.monthTitleHeight,
    this.verticalGap,
    this.bodyPadding,
    this.weekdayGap,
    this.centreColor,
  });

  @override
  TCalendarThemeData copyWith({
    double? height,
    BoxDecoration? decoration,
    TextStyle? weekdayStyle,
    TextStyle? monthTitleStyle,
    TextStyle? dayStyle,
    TextStyle? todayDayStyle,
    BoxDecoration? cellDecoration,
    TextStyle? subtitleStyle,
    double? cellHeight,
    double? monthTitleHeight,
    double? verticalGap,
    double? bodyPadding,
    double? weekdayGap,
    Color? centreColor,
  }) {
    return TCalendarThemeData(
      height: height ?? this.height,
      decoration: decoration ?? this.decoration,
      weekdayStyle: weekdayStyle ?? this.weekdayStyle,
      monthTitleStyle: monthTitleStyle ?? this.monthTitleStyle,
      dayStyle: dayStyle ?? this.dayStyle,
      todayDayStyle: todayDayStyle ?? this.todayDayStyle,
      cellDecoration: cellDecoration ?? this.cellDecoration,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      cellHeight: cellHeight ?? this.cellHeight,
      monthTitleHeight: monthTitleHeight ?? this.monthTitleHeight,
      verticalGap: verticalGap ?? this.verticalGap,
      bodyPadding: bodyPadding ?? this.bodyPadding,
      weekdayGap: weekdayGap ?? this.weekdayGap,
      centreColor: centreColor ?? this.centreColor,
    );
  }

  @override
  TCalendarThemeData lerp(ThemeExtension<TCalendarThemeData>? other, double t) {
    if (other is! TCalendarThemeData) {
      return this;
    }
    return TCalendarThemeData(
      height: lerpDouble(height, other.height, t),
      decoration: BoxDecoration.lerp(decoration, other.decoration, t),
      weekdayStyle: TextStyle.lerp(weekdayStyle, other.weekdayStyle, t),
      monthTitleStyle:
          TextStyle.lerp(monthTitleStyle, other.monthTitleStyle, t),
      dayStyle: TextStyle.lerp(dayStyle, other.dayStyle, t),
      todayDayStyle: TextStyle.lerp(todayDayStyle, other.todayDayStyle, t),
      cellDecoration:
          BoxDecoration.lerp(cellDecoration, other.cellDecoration, t),
      subtitleStyle: TextStyle.lerp(subtitleStyle, other.subtitleStyle, t),
      cellHeight: lerpDouble(cellHeight, other.cellHeight, t),
      monthTitleHeight: lerpDouble(monthTitleHeight, other.monthTitleHeight, t),
      verticalGap: lerpDouble(verticalGap, other.verticalGap, t),
      bodyPadding: lerpDouble(bodyPadding, other.bodyPadding, t),
      weekdayGap: lerpDouble(weekdayGap, other.weekdayGap, t),
      centreColor: Color.lerp(centreColor, other.centreColor, t),
    );
  }
}

/// 日历选择形态
enum TCalendarVariant {
  /// 单选日期
  single,

  /// 多选日期
  multiple,

  /// 选择日期区间
  range,
}

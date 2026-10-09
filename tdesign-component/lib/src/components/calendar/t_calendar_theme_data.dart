import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TCalendar 组件级 ThemeExtension
///
/// 包含日历的装饰、字体和布局默认值。
/// 样式字段通过 `ThemeData.mergeExtension` 在子树覆盖，不需要额外的实例 style 参数。
///
/// {@category ComponentTheme}
class TCalendarThemeData extends ThemeExtension<TCalendarThemeData> {
  /// 日历整体高度；为 null 时由星期栏、月份标题、六行日期、间距和内边距计算视窗高度，不按全部月份展开。
  final double? height;

  /// 组件容器装饰
  /// null 时继承当前全局 Token 解析的容器装饰。
  final BoxDecoration? decoration;

  /// 星期文字样式
  /// null 时继承当前全局 Token 解析的星期样式。
  final TextStyle? weekdayStyle;

  /// 月份标题文字样式
  /// null 时继承当前全局 Token 解析的月份标题样式。
  final TextStyle? monthTitleStyle;

  /// 日期数字样式
  /// null 时继承当前全局 Token 与日期格状态解析的样式。
  final TextStyle? dayStyle;

  /// 今天日期数字样式
  /// null 时继承当前全局 Token 解析的今天样式。
  final TextStyle? todayDayStyle;

  /// 日期单元格装饰（选中状态）
  /// null 时按日期格选择状态与全局 Token 解析默认装饰。
  final BoxDecoration? cellDecoration;

  /// 副标题样式
  /// null 时继承当前全局 Token 与选择状态解析的副标题样式。
  final TextStyle? subtitleStyle;

  /// 日期单元格高度；为 null 时使用 60 逻辑像素。
  final double? cellHeight;

  /// 月份标题高度；为 null 时使用 22 逻辑像素。
  final double? monthTitleHeight;

  /// 日期格垂直间距；为 null 时使用全局 spacer Token，水平间距为该值的一半。
  final double? verticalGap;

  /// 日历主体内边距；为 null 时使用全局 spacer2 Token。
  final double? bodyPadding;

  /// 星期之间的水平间距；为 null 时使用组件默认值 4 逻辑像素。
  final double? weekdayGap;

  /// 区间中间格背景与格间衔接条颜色
  /// null 时按区间格的选择状态与当前 Token 解析区间背景。
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

  /// 复制主题配置。
  ///
  /// ## 返回值
  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
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

  /// 生成主题过渡配置。
  ///
  /// ## 返回值
  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TCalendarThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TCalendarThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TCalendarThemeData) {
      return this;
    }
    return TCalendarThemeData(
      height: lerpDouble(height, other.height, t),
      decoration: BoxDecoration.lerp(decoration, other.decoration, t),
      weekdayStyle: TextStyle.lerp(weekdayStyle, other.weekdayStyle, t),
      monthTitleStyle: TextStyle.lerp(
        monthTitleStyle,
        other.monthTitleStyle,
        t,
      ),
      dayStyle: TextStyle.lerp(dayStyle, other.dayStyle, t),
      todayDayStyle: TextStyle.lerp(todayDayStyle, other.todayDayStyle, t),
      cellDecoration: BoxDecoration.lerp(
        cellDecoration,
        other.cellDecoration,
        t,
      ),
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

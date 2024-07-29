import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

/// 日历组件样式
class TDCalendarStyle {
  TDCalendarStyle({
    this.titleStyle,
    this.weekdayStyle,
    this.titleMaxLine,
    this.closeColor,
    this.monthTitleStyle,
  });

  /// header区域 [TDCalendar.title]的样式
  TextStyle? titleStyle;

  /// header区域 [TDCalendar.title]的行数
  int? titleMaxLine;

  /// header区域 周 文字样式
  TextStyle? weekdayStyle;

  /// header区域 关闭图标的颜色
  Color? closeColor;

  /// body区域 年月文字样式
  TextStyle? monthTitleStyle;

  /// 生成默认样式
  TDCalendarStyle.generateStyle(BuildContext context) {
    titleStyle = TextStyle(
      fontSize: TDTheme.of(context).fontTitleLarge?.size,
      fontWeight: TDTheme.of(context).fontTitleLarge?.fontWeight,
      color: TDTheme.of(context).fontGyColor1,
    );
    weekdayStyle = TextStyle(
      fontSize: TDTheme.of(context).fontTitleSmall?.size,
      color: TDTheme.of(context).fontGyColor2,
    );
    titleMaxLine = 1;
    closeColor = titleStyle?.color;
    monthTitleStyle = TextStyle(
      fontSize: TDTheme.of(context).fontMarkMedium?.size,
      fontWeight: TDTheme.of(context).fontMarkMedium?.fontWeight,
      color: TDTheme.of(context).fontGyColor1,
    );
  }
}

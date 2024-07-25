import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

/// 日历组件样式
class TDCalendarStyle {
  TDCalendarStyle({
    this.titleStyle,
    this.weekdayStyle,
    this.titleMaxLine,
    this.closeColor,
  });

  ///  [TDCalendar.title]的样式
  TextStyle? titleStyle;

  /// 周 文字样式
  TextStyle? weekdayStyle;

  /// [TDCalendar.title]的行数
  int? titleMaxLine;

  /// 关闭图标的颜色
  Color? closeColor;

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
  }
}

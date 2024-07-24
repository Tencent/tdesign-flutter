import 'package:flutter/material.dart';
import '../../../tdesign_flutter.dart';

/// 日历组件样式
class TDCalendarStyle {
  TDCalendarStyle({
    this.weekdayStyle,
  });

  /// 周 文字样式
  TextStyle? weekdayStyle;

  /// 生成默认样式
  TDCalendarStyle.generateStyle(BuildContext context) {
    weekdayStyle = TextStyle(
      fontSize: TDTheme.of(context).fontTitleSmall?.size,
      color: TDTheme.of(context).fontGyColor2,
    );
  }
}

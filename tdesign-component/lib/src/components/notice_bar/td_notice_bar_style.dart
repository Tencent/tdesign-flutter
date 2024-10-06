import 'package:flutter/material.dart';

import '../../theme/td_colors.dart';
import '../../theme/td_theme.dart';
import 'td_notice_bar.dart';

/// 公告栏类型
enum TDNoticeBarType {
  /// 静止（默认）
  none,

  /// 滚动
  scroll,

  /// 步进
  step
}

/// 公告栏主题
enum TDNoticeBarTheme {
  /// 默认
  info,

  /// 成功
  success,

  /// 警告
  warning,

  /// 错误
  error
}

/// 公告栏样式
class TDNoticeBarStyle {
  TDNoticeBarStyle(
      {this.context,
      this.backgroundColor,
      this.textStyle,
      this.leftIconColor,
      this.rightIconColor,
      this.padding});

  /// 上下文
  BuildContext? context;

  /// 公告栏背景色
  Color? backgroundColor;

  /// 公告栏左侧图标颜色
  Color? leftIconColor;

  /// 公告栏右侧图标颜色
  Color? rightIconColor;

  /// 公告栏内边距
  EdgeInsetsGeometry? padding;

  /// 公告栏内容样式
  TextStyle? textStyle;

  /// 公告栏内边距，用于获取默认值
  EdgeInsetsGeometry get getPadding =>
      padding ??
      const EdgeInsets.only(top: 13, bottom: 13, left: 16, right: 12);

  /// 公告栏内容样式，用于获取默认值
  TextStyle get getTextStyle =>
      textStyle ??
      TextStyle(
        color: TDTheme.of(context).fontGyColor1,
        fontSize: 14,
        height: 1,
        fontWeight: FontWeight.normal,
        fontStyle: FontStyle.normal,
      );

  /// 根据主题生成样式
  TDNoticeBarStyle.generateTheme(BuildContext context,
      {TDNoticeBarTheme? theme = TDNoticeBarTheme.info}) {
    rightIconColor = TDTheme.of(context).grayColor7;
    switch (theme) {
      case TDNoticeBarTheme.warning:
        leftIconColor = TDTheme.of(context).warningNormalColor;
        backgroundColor = TDTheme.of(context).warningLightColor;
        break;
      case TDNoticeBarTheme.error:
        leftIconColor = TDTheme.of(context).errorNormalColor;
        backgroundColor = TDTheme.of(context).errorLightColor;
        break;
      case TDNoticeBarTheme.success:
        leftIconColor = TDTheme.of(context).successNormalColor;
        backgroundColor = TDTheme.of(context).successLightColor;
        break;
      default:
        leftIconColor = TDTheme.of(context).brandNormalColor;
        backgroundColor = TDTheme.of(context).brandLightColor;
        break;
    }
  }
}

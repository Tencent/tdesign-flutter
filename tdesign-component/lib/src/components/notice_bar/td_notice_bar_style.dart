import 'package:flutter/material.dart';

import '../../theme/td_colors.dart';
import '../../theme/td_fonts.dart';
import '../../theme/td_theme.dart';
import 'td_notice_bar.dart';

/// 公告栏类型
enum TNoticeBarType {
  /// 静止（默认）
  none,

  /// 滚动
  scroll,

  /// 步进
  step
}

/// 公告栏主题
enum TNoticeBarTheme {
  /// 信息（默认）
  info,

  /// 成功
  success,

  /// 警告
  warning,

  /// 错误
  error
}

/// 公告栏样式
class TNoticeBarStyle {
  TNoticeBarStyle({
    this.context,
    this.backgroundColor,
    this.textStyle,
    this.leftIconColor,
    this.rightIconColor,
    this.padding,
  });

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

  /// 根据主题生成样式
  TNoticeBarStyle.generateTheme(
    BuildContext context, {
    TNoticeBarTheme? theme = TNoticeBarTheme.info,
  }) {
    rightIconColor = TTheme.of(context).textColorPlaceholder;
    textStyle = textStyle ??
        TextStyle(
          color: TTheme.of(context).textColorPrimary,
          fontSize: TTheme.of(context).fontBodyMedium?.size,
          height: TTheme.of(context).fontBodyMedium?.height,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
        );
    switch (theme) {
      case TNoticeBarTheme.warning:
        leftIconColor = TTheme.of(context).warningNormalColor;
        backgroundColor = TTheme.of(context).warningLightColor;
        break;
      case TNoticeBarTheme.error:
        leftIconColor = TTheme.of(context).errorNormalColor;
        backgroundColor = TTheme.of(context).errorLightColor;
        break;
      case TNoticeBarTheme.success:
        leftIconColor = TTheme.of(context).successNormalColor;
        backgroundColor = TTheme.of(context).successLightColor;
        break;
      default:
        leftIconColor = TTheme.of(context).brandNormalColor;
        backgroundColor = TTheme.of(context).brandLightColor;
        break;
    }
  }
}

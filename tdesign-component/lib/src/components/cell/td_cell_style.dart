import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

/// 单元格组件样式
class TDCellStyle {
  TDCellStyle({
    this.leftIconColor,
    this.titleStyle,
    this.requiredStyle,
    this.descriptionStyle,
    this.noteStyle,
    this.arrowColor,
  });

  /// 左侧图标颜色
  Color? leftIconColor;

  /// 标题文字样式
  TextStyle? titleStyle;

  /// 必填星号文字样式
  TextStyle? requiredStyle;

  /// 内容描述文字样式
  TextStyle? descriptionStyle;

  /// 说明文字样式
  TextStyle? noteStyle;

  /// 箭头颜色
  Color? arrowColor;

  /// 生成默认样式
  TDCellStyle.generateStyle(BuildContext context) {
    leftIconColor = TDTheme.of(context).brandColor7;
    titleStyle = TextStyle(
      color: TDTheme.of(context).fontGyColor1,
      fontSize: TDTheme.of(context).fontBodyLarge?.size ?? 16,
      height: TDTheme.of(context).fontBodyLarge?.height ?? 24,
      fontWeight: TDTheme.of(context).fontBodyLarge?.fontWeight ?? FontWeight.w400,
    );
    requiredStyle = titleStyle!.copyWith(color: TDTheme.of(context).errorColor6);
    descriptionStyle = TextStyle(
      color: TDTheme.of(context).fontGyColor2,
      fontSize: TDTheme.of(context).fontBodyMedium?.size ?? 14,
      height: TDTheme.of(context).fontBodyMedium?.height ?? 22,
      fontWeight: TDTheme.of(context).fontBodyMedium?.fontWeight ?? FontWeight.w400,
    );
    noteStyle = titleStyle!.copyWith(color: TDTheme.of(context).fontGyColor3);
    arrowColor = TDTheme.of(context).fontGyColor3;
  }
}

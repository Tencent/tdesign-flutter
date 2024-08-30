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
    this.borderedColor,
    this.groupBorderedColor,
    this.backgroundColor,
  });

  /// 左侧图标颜色
  Color? leftIconColor;

  /// 右侧图标颜色
  Color? rightIconColor;

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

  /// 单元格边框颜色
  Color? borderedColor;

  /// 单元格组边框颜色
  Color? groupBorderedColor;

  /// 默认状态背景颜色
  Color? backgroundColor;

  /// 点击状态背景颜色
  Color? clickBackgroundColor;

  /// 单元组标题文字样式
  TextStyle? groupTitleStyle;

  /// 生成单元格默认样式
  TDCellStyle.cellStyle(BuildContext context) {
    backgroundColor = Colors.white;
    clickBackgroundColor = TDTheme.of(context).grayColor1;
    leftIconColor = TDTheme.of(context).brandColor7;
    rightIconColor = TDTheme.of(context).brandColor7;
    titleStyle = TextStyle(
      color: TDTheme.of(context).fontGyColor1,
      fontSize: TDTheme.of(context).fontBodyLarge?.size ?? 16,
      height: TDTheme.of(context).fontBodyLarge?.height ?? 24,
      fontWeight: FontWeight.w400,
    );
    requiredStyle = titleStyle!.copyWith(color: TDTheme.of(context).errorColor6);
    descriptionStyle = TextStyle(
      color: TDTheme.of(context).fontGyColor2,
      fontSize: TDTheme.of(context).fontBodyMedium?.size ?? 14,
      height: TDTheme.of(context).fontBodyMedium?.height ?? 22,
      fontWeight: FontWeight.w400,
    );
    noteStyle = titleStyle!.copyWith(color: TDTheme.of(context).fontGyColor3);
    arrowColor = TDTheme.of(context).fontGyColor3;

    groupBorderedColor = TDTheme.of(context).grayColor3;
    borderedColor = TDTheme.of(context).grayColor3;
    groupTitleStyle = TextStyle(
      color: TDTheme.of(context).fontGyColor1,
      fontSize: TDTheme.of(context).fontTitleLarge?.size ?? 18,
      height: TDTheme.of(context).fontTitleLarge?.height ?? 26,
      fontWeight: TDTheme.of(context).fontTitleLarge?.fontWeight ?? FontWeight.w600,
    );
  }
}

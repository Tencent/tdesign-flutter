import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

/// 单元格组件样式
class TCellStyle {
  TCellStyle({
    this.context,
    this.leftIconColor,
    this.rightIconColor,
    this.titleStyle,
    this.requiredStyle,
    this.descriptionStyle,
    this.noteStyle,
    this.arrowColor,
    this.borderedColor,
    this.groupBorderedColor,
    this.backgroundColor,
    this.clickBackgroundColor,
    this.groupTitleStyle,
    this.padding,
    this.cardBorderRadius,
    this.cardPadding,
    this.titlePadding,
    @deprecated this.titleBackgroundColor,
  }) {
    if (context != null) {
      defaultStyle(context!);
    }
  }

  /// 传递context，会生成默认样式
  BuildContext? context;

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

  /// 单元格内边距
  EdgeInsets? padding;

  /// 卡片模式边框圆角
  BorderRadius? cardBorderRadius;

  /// 卡片模式内边距
  EdgeInsets? cardPadding;

  /// 单元格组标题内边距
  EdgeInsets? titlePadding;

  /// 单元格组标题背景颜色
  Color? titleBackgroundColor;

  /// 生成单元格默认样式
  TCellStyle.cellStyle(BuildContext context) {
    defaultStyle(context);
  }

  defaultStyle(BuildContext context) {
    backgroundColor = TTheme.of(context).bgColorContainer;
    clickBackgroundColor = TTheme.of(context).bgColorContainerHover;
    leftIconColor = TTheme.of(context).brandNormalColor;
    rightIconColor = TTheme.of(context).brandNormalColor;
    titleStyle = TextStyle(
      color: TTheme.of(context).textColorPrimary,
      fontSize: TTheme.of(context).fontBodyLarge?.size ?? 16,
      height: TTheme.of(context).fontBodyLarge?.height ?? 24,
      fontWeight: FontWeight.w400,
    );
    requiredStyle =
        titleStyle!.copyWith(color: TTheme.of(context).errorNormalColor);
    descriptionStyle = TextStyle(
      color: TTheme.of(context).textColorSecondary,
      fontSize: TTheme.of(context).fontBodyMedium?.size ?? 14,
      height: TTheme.of(context).fontBodyMedium?.height ?? 22,
      fontWeight: FontWeight.w400,
    );
    noteStyle =
        titleStyle!.copyWith(color: TTheme.of(context).textColorPlaceholder);
    arrowColor = TTheme.of(context).textColorPlaceholder;

    groupBorderedColor = TTheme.of(context).componentStrokeColor;
    borderedColor = TTheme.of(context).componentStrokeColor;
    groupTitleStyle = TextStyle(
      color: TTheme.of(context).textColorPrimary,
      fontSize: TTheme.of(context).fontTitleLarge?.size ?? 18,
      height: TTheme.of(context).fontTitleLarge?.height ?? 26,
      fontWeight:
          TTheme.of(context).fontTitleLarge?.fontWeight ?? FontWeight.w600,
    );

    padding = EdgeInsets.all(TTheme.of(context).spacer16);
    cardBorderRadius =
        BorderRadius.all(Radius.circular(TTheme.of(context).radiusLarge));
    cardPadding =
        EdgeInsets.symmetric(horizontal: TTheme.of(context).spacer16);
    titlePadding = EdgeInsets.only(
      left: TTheme.of(context).spacer16,
      right: TTheme.of(context).spacer16,
      top: TTheme.of(context).spacer24,
      bottom: TTheme.of(context).spacer8,
    );
    titleBackgroundColor = Colors.transparent;
  }
}

import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 't_cell.dart' show TCellAlign;

/// 单元格组视觉形态。
enum TCellGroupVariant {
  /// 通栏形态。
  standard,

  /// 卡片形态。
  card,
}

/// Cell 与 CellGroup 的组件级 ThemeExtension。
///
/// 仅保存视觉和布局默认值，不保存内容、回调或列表数据。
class TCellThemeData extends ThemeExtension<TCellThemeData> {
  const TCellThemeData({
    this.titleStyle,
    this.requiredStyle,
    this.subtitleStyle,
    this.noteStyle,
    this.groupTitleStyle,
    this.arrowColor,
    this.borderColor,
    this.groupBorderColor,
    this.backgroundColor,
    this.pressedColor,
    this.padding,
    this.cardBorderRadius,
    this.cardPadding,
    this.titlePadding,
    this.align,
    this.showBottomBorder,
    this.height,
    this.groupVariant,
    this.groupBordered,
    this.showLastDivider,
  });

  /// 标题文字样式。
  final TextStyle? titleStyle;

  /// 必填标记样式。
  final TextStyle? requiredStyle;

  /// 副标题文字样式。
  final TextStyle? subtitleStyle;

  /// 右侧说明文字样式。
  final TextStyle? noteStyle;

  /// 单元格组标题样式。
  final TextStyle? groupTitleStyle;

  /// 箭头颜色。
  final Color? arrowColor;

  /// 分隔线颜色。
  final Color? borderColor;

  /// 单元格组边框颜色。
  final Color? groupBorderColor;

  /// 默认背景色。
  final Color? backgroundColor;

  /// 按压背景色。
  final Color? pressedColor;

  /// 单元格内边距。
  final EdgeInsetsGeometry? padding;

  /// 卡片组圆角。
  final BorderRadius? cardBorderRadius;

  /// 卡片组内边距。
  final EdgeInsetsGeometry? cardPadding;

  /// 组标题内边距。
  final EdgeInsetsGeometry? titlePadding;

  /// 默认内容对齐方式。
  final TCellAlign? align;

  /// 是否显示 Cell 底部分隔线。
  final bool? showBottomBorder;

  /// Cell 固定高度。
  final double? height;

  /// CellGroup 默认形态。
  final TCellGroupVariant? groupVariant;

  /// 是否显示组外边框。
  final bool? groupBordered;

  /// 是否显示最后一个 Cell 后的分隔线。
  final bool? showLastDivider;

  @override
  TCellThemeData copyWith({
    TextStyle? titleStyle,
    TextStyle? requiredStyle,
    TextStyle? subtitleStyle,
    TextStyle? noteStyle,
    TextStyle? groupTitleStyle,
    Color? arrowColor,
    Color? borderColor,
    Color? groupBorderColor,
    Color? backgroundColor,
    Color? pressedColor,
    EdgeInsetsGeometry? padding,
    BorderRadius? cardBorderRadius,
    EdgeInsetsGeometry? cardPadding,
    EdgeInsetsGeometry? titlePadding,
    TCellAlign? align,
    bool? showBottomBorder,
    double? height,
    TCellGroupVariant? groupVariant,
    bool? groupBordered,
    bool? showLastDivider,
  }) {
    return TCellThemeData(
      titleStyle: titleStyle ?? this.titleStyle,
      requiredStyle: requiredStyle ?? this.requiredStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      noteStyle: noteStyle ?? this.noteStyle,
      groupTitleStyle: groupTitleStyle ?? this.groupTitleStyle,
      arrowColor: arrowColor ?? this.arrowColor,
      borderColor: borderColor ?? this.borderColor,
      groupBorderColor: groupBorderColor ?? this.groupBorderColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      pressedColor: pressedColor ?? this.pressedColor,
      padding: padding ?? this.padding,
      cardBorderRadius: cardBorderRadius ?? this.cardBorderRadius,
      cardPadding: cardPadding ?? this.cardPadding,
      titlePadding: titlePadding ?? this.titlePadding,
      align: align ?? this.align,
      showBottomBorder: showBottomBorder ?? this.showBottomBorder,
      height: height ?? this.height,
      groupVariant: groupVariant ?? this.groupVariant,
      groupBordered: groupBordered ?? this.groupBordered,
      showLastDivider: showLastDivider ?? this.showLastDivider,
    );
  }

  @override
  TCellThemeData lerp(TCellThemeData? other, double t) {
    if (other == null) {
      return this;
    }
    return TCellThemeData(
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
      requiredStyle: TextStyle.lerp(requiredStyle, other.requiredStyle, t),
      subtitleStyle: TextStyle.lerp(subtitleStyle, other.subtitleStyle, t),
      noteStyle: TextStyle.lerp(noteStyle, other.noteStyle, t),
      groupTitleStyle:
          TextStyle.lerp(groupTitleStyle, other.groupTitleStyle, t),
      arrowColor: Color.lerp(arrowColor, other.arrowColor, t),
      borderColor: Color.lerp(borderColor, other.borderColor, t),
      groupBorderColor: Color.lerp(groupBorderColor, other.groupBorderColor, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      pressedColor: Color.lerp(pressedColor, other.pressedColor, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      cardBorderRadius:
          BorderRadius.lerp(cardBorderRadius, other.cardBorderRadius, t),
      cardPadding: EdgeInsetsGeometry.lerp(cardPadding, other.cardPadding, t),
      titlePadding:
          EdgeInsetsGeometry.lerp(titlePadding, other.titlePadding, t),
      align: t < 0.5 ? align : other.align,
      showBottomBorder: t < 0.5 ? showBottomBorder : other.showBottomBorder,
      height: lerpDouble(height, other.height, t),
      groupVariant: t < 0.5 ? groupVariant : other.groupVariant,
      groupBordered: t < 0.5 ? groupBordered : other.groupBordered,
      showLastDivider: t < 0.5 ? showLastDivider : other.showLastDivider,
    );
  }
}

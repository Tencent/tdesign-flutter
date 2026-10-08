import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

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
/// 文字样式按字段覆盖全局 Token 派生的组件默认值；未配置字段保持默认。
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
    this.showBottomBorder,
    this.height,
    this.groupBordered,
    this.showLastDivider,
  });

  /// 标题文字样式。
  /// 默认使用 fontBodyLarge / textColorPrimary Token，按字段合并本样式。
  final TextStyle? titleStyle;

  /// 必填标记样式。
  final TextStyle? requiredStyle;

  /// 副标题文字样式。
  /// 默认使用 fontBodyMedium / textColorSecondary Token，按字段合并本样式。
  final TextStyle? subtitleStyle;

  /// 右侧说明文字样式。
  /// 默认使用 fontBodyLarge / textColorPlaceholder Token，按字段合并本样式。
  final TextStyle? noteStyle;

  /// 单元格组标题样式。
  /// 默认使用 fontBodyMedium / textColorPrimary Token，按字段合并本样式。
  final TextStyle? groupTitleStyle;

  /// 箭头颜色。
  /// 未配置时使用 textColorPlaceholder Token。
  final Color? arrowColor;

  /// 分隔线颜色。
  /// 未配置时使用 componentStroke Token。
  final Color? borderColor;

  /// 单元格组边框颜色。
  /// 未配置时使用 componentStroke Token。
  final Color? groupBorderColor;

  /// 默认背景色。
  /// 未配置时使用 bgColorContainer Token。
  final Color? backgroundColor;

  /// 按压背景色。
  /// 未配置时使用 bgColorSecondaryContainer Token；交互反馈由实例 enableFeedback 控制。
  final Color? pressedColor;

  /// 单元格内边距。
  /// 未配置时四边均使用 spacer2 Token。
  final EdgeInsetsGeometry? padding;

  /// 卡片组圆角。
  /// 仅卡片形态生效，未配置时为 8 逻辑像素圆角。
  final BorderRadius? cardBorderRadius;

  /// 卡片组内边距。
  /// 仅卡片形态生效，未配置时为左右 16 逻辑像素。
  final EdgeInsetsGeometry? cardPadding;

  /// 组标题内边距。
  /// 未配置时四边均为 16 逻辑像素。
  final EdgeInsetsGeometry? titlePadding;

  /// 是否显示 Cell 底部分隔线。
  /// 未配置时为 false，组内分隔线由 CellGroup 独立绘制。
  final bool? showBottomBorder;

  /// Cell 固定高度。
  /// 未配置时由内容和内边距自然决定高度。
  final double? height;

  /// 是否显示组外边框。
  /// 未配置时为 false。
  final bool? groupBordered;

  /// 是否显示最后一个 Cell 后的分隔线。
  /// 未配置时为 false。
  final bool? showLastDivider;

  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
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
    bool? showBottomBorder,
    double? height,
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
      showBottomBorder: showBottomBorder ?? this.showBottomBorder,
      height: height ?? this.height,
      groupBordered: groupBordered ?? this.groupBordered,
      showLastDivider: showLastDivider ?? this.showLastDivider,
    );
  }

  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TCellThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    TCellThemeData? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other == null) {
      return this;
    }
    return TCellThemeData(
      titleStyle: TextStyle.lerp(titleStyle, other.titleStyle, t),
      requiredStyle: TextStyle.lerp(requiredStyle, other.requiredStyle, t),
      subtitleStyle: TextStyle.lerp(subtitleStyle, other.subtitleStyle, t),
      noteStyle: TextStyle.lerp(noteStyle, other.noteStyle, t),
      groupTitleStyle: TextStyle.lerp(
        groupTitleStyle,
        other.groupTitleStyle,
        t,
      ),
      arrowColor: Color.lerp(arrowColor, other.arrowColor, t),
      borderColor: Color.lerp(borderColor, other.borderColor, t),
      groupBorderColor: Color.lerp(groupBorderColor, other.groupBorderColor, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      pressedColor: Color.lerp(pressedColor, other.pressedColor, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      cardBorderRadius: BorderRadius.lerp(
        cardBorderRadius,
        other.cardBorderRadius,
        t,
      ),
      cardPadding: EdgeInsetsGeometry.lerp(cardPadding, other.cardPadding, t),
      titlePadding: EdgeInsetsGeometry.lerp(
        titlePadding,
        other.titlePadding,
        t,
      ),
      showBottomBorder: t < 0.5 ? showBottomBorder : other.showBottomBorder,
      height: lerpDouble(height, other.height, t),
      groupBordered: t < 0.5 ? groupBordered : other.groupBordered,
      showLastDivider: t < 0.5 ? showLastDivider : other.showLastDivider,
    );
  }
}

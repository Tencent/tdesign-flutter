import 'package:flutter/material.dart';

/// DropdownMenu 的组件级视觉与布局默认值。
///
/// {@category ComponentTheme}
class TDropdownThemeData extends ThemeExtension<TDropdownThemeData> {
  const TDropdownThemeData({
    this.barHeight,
    this.barBackgroundColor,
    this.dividerColor,
    this.textStyle,
    this.activeTextStyle,
    this.disabledTextStyle,
    this.iconColor,
    this.activeIconColor,
    this.disabledIconColor,
    this.iconSize,
    this.panelBackgroundColor,
    this.overlayColor,
    this.optionHeight,
    this.optionPadding,
    this.optionTextStyle,
    this.selectedOptionTextStyle,
    this.disabledOptionTextStyle,
    this.optionColor,
    this.selectedOptionColor,
    this.disabledOptionColor,
    this.optionBorderRadius,
    this.actionAreaPadding,
    this.actionGap,
  });

  /// 筛选栏高度，默认 48 逻辑像素。
  final double? barHeight;

  /// 筛选栏背景色；为空时读取全局 bgColorContainer。
  final Color? barBackgroundColor;

  /// 筛选栏底部分隔线颜色；为空时读取全局 componentStroke。
  final Color? dividerColor;

  /// 默认触发项文本样式。
  final TextStyle? textStyle;

  /// 打开面板的触发项文本样式。
  final TextStyle? activeTextStyle;

  /// 禁用触发项文本样式。
  final TextStyle? disabledTextStyle;

  /// 默认触发项箭头颜色。
  final Color? iconColor;

  /// 打开面板的触发项箭头颜色。
  final Color? activeIconColor;

  /// 禁用触发项箭头颜色。
  final Color? disabledIconColor;

  /// 触发项箭头尺寸，默认 24 逻辑像素。
  final double? iconSize;

  /// 面板背景色；为空时读取全局 bgColorContainer。
  final Color? panelBackgroundColor;

  /// 遮罩颜色，包含透明度。未指定时为黑色 60%，动画按展开进度缩放透明度。
  final Color? overlayColor;

  /// 单选列表行高度，默认 56 逻辑像素。
  final double? optionHeight;

  /// 选项内边距；为空时使用全局 spacer2 水平间距。
  final EdgeInsetsGeometry? optionPadding;

  /// 选项默认文本样式。
  final TextStyle? optionTextStyle;

  /// 选中选项文本样式。
  final TextStyle? selectedOptionTextStyle;

  /// 禁用选项文本样式。
  final TextStyle? disabledOptionTextStyle;

  /// 多列选项默认背景色。
  final Color? optionColor;

  /// 多列选项选中背景色。
  final Color? selectedOptionColor;

  /// 多列选项禁用背景色。
  final Color? disabledOptionColor;

  /// 多列选项圆角；为空时读取全局 radiusDefault。
  final BorderRadius? optionBorderRadius;

  /// 多选面板底部操作区内边距。
  final EdgeInsetsGeometry? actionAreaPadding;

  /// 多选面板底部按钮之间的间距；为空时读取全局 spacer2。
  final double? actionGap;

  /// 合并主题配置。
  ///
  /// ## 返回值
  /// 返回合并后的主题；[other] 的非空字段覆盖当前字段，other 为空时返回当前主题。
  TDropdownThemeData merge(
    /// 要合并的目标主题；为空时保留当前配置。
    TDropdownThemeData? other,
  ) {
    if (other == null) {
      return this;
    }
    return copyWith(
      barHeight: other.barHeight,
      barBackgroundColor: other.barBackgroundColor,
      dividerColor: other.dividerColor,
      textStyle: other.textStyle,
      activeTextStyle: other.activeTextStyle,
      disabledTextStyle: other.disabledTextStyle,
      iconColor: other.iconColor,
      activeIconColor: other.activeIconColor,
      disabledIconColor: other.disabledIconColor,
      iconSize: other.iconSize,
      panelBackgroundColor: other.panelBackgroundColor,
      overlayColor: other.overlayColor,
      optionHeight: other.optionHeight,
      optionPadding: other.optionPadding,
      optionTextStyle: other.optionTextStyle,
      selectedOptionTextStyle: other.selectedOptionTextStyle,
      disabledOptionTextStyle: other.disabledOptionTextStyle,
      optionColor: other.optionColor,
      selectedOptionColor: other.selectedOptionColor,
      disabledOptionColor: other.disabledOptionColor,
      optionBorderRadius: other.optionBorderRadius,
      actionAreaPadding: other.actionAreaPadding,
      actionGap: other.actionGap,
    );
  }

  /// 复制主题配置。
  ///
  /// ## 返回值
  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TDropdownThemeData copyWith({
    double? barHeight,
    Color? barBackgroundColor,
    Color? dividerColor,
    TextStyle? textStyle,
    TextStyle? activeTextStyle,
    TextStyle? disabledTextStyle,
    Color? iconColor,
    Color? activeIconColor,
    Color? disabledIconColor,
    double? iconSize,
    Color? panelBackgroundColor,
    Color? overlayColor,
    double? optionHeight,
    EdgeInsetsGeometry? optionPadding,
    TextStyle? optionTextStyle,
    TextStyle? selectedOptionTextStyle,
    TextStyle? disabledOptionTextStyle,
    Color? optionColor,
    Color? selectedOptionColor,
    Color? disabledOptionColor,
    BorderRadius? optionBorderRadius,
    EdgeInsetsGeometry? actionAreaPadding,
    double? actionGap,
  }) {
    return TDropdownThemeData(
      barHeight: barHeight ?? this.barHeight,
      barBackgroundColor: barBackgroundColor ?? this.barBackgroundColor,
      dividerColor: dividerColor ?? this.dividerColor,
      textStyle: textStyle ?? this.textStyle,
      activeTextStyle: activeTextStyle ?? this.activeTextStyle,
      disabledTextStyle: disabledTextStyle ?? this.disabledTextStyle,
      iconColor: iconColor ?? this.iconColor,
      activeIconColor: activeIconColor ?? this.activeIconColor,
      disabledIconColor: disabledIconColor ?? this.disabledIconColor,
      iconSize: iconSize ?? this.iconSize,
      panelBackgroundColor: panelBackgroundColor ?? this.panelBackgroundColor,
      overlayColor: overlayColor ?? this.overlayColor,
      optionHeight: optionHeight ?? this.optionHeight,
      optionPadding: optionPadding ?? this.optionPadding,
      optionTextStyle: optionTextStyle ?? this.optionTextStyle,
      selectedOptionTextStyle:
          selectedOptionTextStyle ?? this.selectedOptionTextStyle,
      disabledOptionTextStyle:
          disabledOptionTextStyle ?? this.disabledOptionTextStyle,
      optionColor: optionColor ?? this.optionColor,
      selectedOptionColor: selectedOptionColor ?? this.selectedOptionColor,
      disabledOptionColor: disabledOptionColor ?? this.disabledOptionColor,
      optionBorderRadius: optionBorderRadius ?? this.optionBorderRadius,
      actionAreaPadding: actionAreaPadding ?? this.actionAreaPadding,
      actionGap: actionGap ?? this.actionGap,
    );
  }

  /// 生成主题过渡配置。
  ///
  /// ## 返回值
  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TDropdownThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    covariant ThemeExtension<TDropdownThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TDropdownThemeData) {
      return this;
    }
    return TDropdownThemeData(
      barHeight: _lerpDouble(barHeight, other.barHeight, t),
      barBackgroundColor: Color.lerp(
        barBackgroundColor,
        other.barBackgroundColor,
        t,
      ),
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      activeTextStyle: TextStyle.lerp(
        activeTextStyle,
        other.activeTextStyle,
        t,
      ),
      disabledTextStyle: TextStyle.lerp(
        disabledTextStyle,
        other.disabledTextStyle,
        t,
      ),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      activeIconColor: Color.lerp(activeIconColor, other.activeIconColor, t),
      disabledIconColor: Color.lerp(
        disabledIconColor,
        other.disabledIconColor,
        t,
      ),
      iconSize: _lerpDouble(iconSize, other.iconSize, t),
      panelBackgroundColor: Color.lerp(
        panelBackgroundColor,
        other.panelBackgroundColor,
        t,
      ),
      overlayColor: Color.lerp(overlayColor, other.overlayColor, t),
      optionHeight: _lerpDouble(optionHeight, other.optionHeight, t),
      optionPadding: EdgeInsetsGeometry.lerp(
        optionPadding,
        other.optionPadding,
        t,
      ),
      optionTextStyle: TextStyle.lerp(
        optionTextStyle,
        other.optionTextStyle,
        t,
      ),
      selectedOptionTextStyle: TextStyle.lerp(
        selectedOptionTextStyle,
        other.selectedOptionTextStyle,
        t,
      ),
      disabledOptionTextStyle: TextStyle.lerp(
        disabledOptionTextStyle,
        other.disabledOptionTextStyle,
        t,
      ),
      optionColor: Color.lerp(optionColor, other.optionColor, t),
      selectedOptionColor: Color.lerp(
        selectedOptionColor,
        other.selectedOptionColor,
        t,
      ),
      disabledOptionColor: Color.lerp(
        disabledOptionColor,
        other.disabledOptionColor,
        t,
      ),
      optionBorderRadius: BorderRadius.lerp(
        optionBorderRadius,
        other.optionBorderRadius,
        t,
      ),
      actionAreaPadding: EdgeInsetsGeometry.lerp(
        actionAreaPadding,
        other.actionAreaPadding,
        t,
      ),
      actionGap: _lerpDouble(actionGap, other.actionGap, t),
    );
  }

  static double? _lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return (a ?? b)! + ((b ?? a)! - (a ?? b)!) * t;
  }
}

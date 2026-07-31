import 'package:flutter/material.dart';

/// DropdownMenu 的组件级视觉与布局默认值。
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
    this.animationDuration,
  });

  final double? barHeight;
  final Color? barBackgroundColor;
  final Color? dividerColor;
  final TextStyle? textStyle;
  final TextStyle? activeTextStyle;
  final TextStyle? disabledTextStyle;
  final Color? iconColor;
  final Color? activeIconColor;
  final Color? disabledIconColor;
  final double? iconSize;
  final Color? panelBackgroundColor;
  final Color? overlayColor;
  final double? optionHeight;
  final EdgeInsetsGeometry? optionPadding;
  final TextStyle? optionTextStyle;
  final TextStyle? selectedOptionTextStyle;
  final TextStyle? disabledOptionTextStyle;
  final Color? optionColor;
  final Color? selectedOptionColor;
  final Color? disabledOptionColor;
  final BorderRadius? optionBorderRadius;
  final EdgeInsetsGeometry? actionAreaPadding;
  final double? actionGap;
  final Duration? animationDuration;

  TDropdownThemeData merge(TDropdownThemeData? other) {
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
      animationDuration: other.animationDuration,
    );
  }

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
    Duration? animationDuration,
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
      animationDuration: animationDuration ?? this.animationDuration,
    );
  }

  @override
  TDropdownThemeData lerp(
    covariant ThemeExtension<TDropdownThemeData>? other,
    double t,
  ) {
    if (other is! TDropdownThemeData) {
      return this;
    }
    return TDropdownThemeData(
      barHeight: _lerpDouble(barHeight, other.barHeight, t),
      barBackgroundColor:
          Color.lerp(barBackgroundColor, other.barBackgroundColor, t),
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      activeTextStyle:
          TextStyle.lerp(activeTextStyle, other.activeTextStyle, t),
      disabledTextStyle:
          TextStyle.lerp(disabledTextStyle, other.disabledTextStyle, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      activeIconColor: Color.lerp(activeIconColor, other.activeIconColor, t),
      disabledIconColor:
          Color.lerp(disabledIconColor, other.disabledIconColor, t),
      iconSize: _lerpDouble(iconSize, other.iconSize, t),
      panelBackgroundColor:
          Color.lerp(panelBackgroundColor, other.panelBackgroundColor, t),
      overlayColor: Color.lerp(overlayColor, other.overlayColor, t),
      optionHeight: _lerpDouble(optionHeight, other.optionHeight, t),
      optionPadding:
          EdgeInsetsGeometry.lerp(optionPadding, other.optionPadding, t),
      optionTextStyle:
          TextStyle.lerp(optionTextStyle, other.optionTextStyle, t),
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
      selectedOptionColor:
          Color.lerp(selectedOptionColor, other.selectedOptionColor, t),
      disabledOptionColor:
          Color.lerp(disabledOptionColor, other.disabledOptionColor, t),
      optionBorderRadius:
          BorderRadius.lerp(optionBorderRadius, other.optionBorderRadius, t),
      actionAreaPadding: EdgeInsetsGeometry.lerp(
          actionAreaPadding, other.actionAreaPadding, t),
      actionGap: _lerpDouble(actionGap, other.actionGap, t),
      animationDuration: t < 0.5 ? animationDuration : other.animationDuration,
    );
  }

  static double? _lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return (a ?? b)! + ((b ?? a)! - (a ?? b)!) * t;
  }
}

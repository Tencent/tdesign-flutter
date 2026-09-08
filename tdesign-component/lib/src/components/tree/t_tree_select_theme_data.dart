import 'package:flutter/material.dart';

const _kDefaultHeight = 336.0;
const _kDefaultRootColumnWidth = 103.0;
const _kDefaultItemHeight = 56.0;

/// TTreeSelect 组件级 ThemeExtension。
class TTreeSelectThemeData extends ThemeExtension<TTreeSelectThemeData> {
  const TTreeSelectThemeData({
    /// 面板高度。
    this.height,

    /// 根列宽度。
    this.rootColumnWidth,

    /// 子列宽度。
    this.columnWidth,

    /// 单项最小高度。
    this.itemHeight,

    /// 面板背景色。
    this.backgroundColor,

    /// 根列背景色。
    this.rootBackgroundColor,

    /// 选中项背景色。
    this.selectedBackgroundColor,

    /// 普通文案样式。
    this.textStyle,

    /// 选中文案样式。
    this.selectedTextStyle,

    /// 禁用文案样式。
    this.disabledTextStyle,

    /// 选中图标颜色。
    this.indicatorColor,
  });

  /// 面板高度。
  final double? height;

  /// 根列宽度。
  final double? rootColumnWidth;

  /// 子列宽度。
  final double? columnWidth;

  /// 单项最小高度。
  final double? itemHeight;

  /// 面板背景色。
  final Color? backgroundColor;

  /// 根列背景色。
  final Color? rootBackgroundColor;

  /// 选中项背景色。
  final Color? selectedBackgroundColor;

  /// 普通文案样式。
  final TextStyle? textStyle;

  /// 选中文案样式。
  final TextStyle? selectedTextStyle;

  /// 禁用文案样式。
  final TextStyle? disabledTextStyle;

  /// 选中图标颜色。
  final Color? indicatorColor;

  @override
  TTreeSelectThemeData copyWith({
    double? height,
    double? rootColumnWidth,
    double? columnWidth,
    double? itemHeight,
    Color? backgroundColor,
    Color? rootBackgroundColor,
    Color? selectedBackgroundColor,
    TextStyle? textStyle,
    TextStyle? selectedTextStyle,
    TextStyle? disabledTextStyle,
    Color? indicatorColor,
  }) {
    return TTreeSelectThemeData(
      height: height ?? this.height,
      rootColumnWidth: rootColumnWidth ?? this.rootColumnWidth,
      columnWidth: columnWidth ?? this.columnWidth,
      itemHeight: itemHeight ?? this.itemHeight,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      rootBackgroundColor: rootBackgroundColor ?? this.rootBackgroundColor,
      selectedBackgroundColor:
          selectedBackgroundColor ?? this.selectedBackgroundColor,
      textStyle: textStyle ?? this.textStyle,
      selectedTextStyle: selectedTextStyle ?? this.selectedTextStyle,
      disabledTextStyle: disabledTextStyle ?? this.disabledTextStyle,
      indicatorColor: indicatorColor ?? this.indicatorColor,
    );
  }

  @override
  TTreeSelectThemeData lerp(
    ThemeExtension<TTreeSelectThemeData>? other,
    double t,
  ) {
    if (other is! TTreeSelectThemeData) {
      return this;
    }
    return TTreeSelectThemeData(
      height: _lerpDoubleWithDefault(height, other.height, t, _kDefaultHeight),
      rootColumnWidth: _lerpDoubleWithDefault(
        rootColumnWidth,
        other.rootColumnWidth,
        t,
        _kDefaultRootColumnWidth,
      ),
      columnWidth: _lerpNullable(
        columnWidth,
        other.columnWidth,
        t,
        _lerpDouble,
      ),
      itemHeight: _lerpDoubleWithDefault(
        itemHeight,
        other.itemHeight,
        t,
        _kDefaultItemHeight,
      ),
      backgroundColor: _lerpNullable(
        backgroundColor,
        other.backgroundColor,
        t,
        _lerpColor,
      ),
      rootBackgroundColor: _lerpNullable(
        rootBackgroundColor,
        other.rootBackgroundColor,
        t,
        _lerpColor,
      ),
      selectedBackgroundColor: _lerpNullable(
        selectedBackgroundColor,
        other.selectedBackgroundColor,
        t,
        _lerpColor,
      ),
      textStyle: _lerpNullable(textStyle, other.textStyle, t, _lerpTextStyle),
      selectedTextStyle: _lerpNullable(
        selectedTextStyle,
        other.selectedTextStyle,
        t,
        _lerpTextStyle,
      ),
      disabledTextStyle: _lerpNullable(
        disabledTextStyle,
        other.disabledTextStyle,
        t,
        _lerpTextStyle,
      ),
      indicatorColor: _lerpNullable(
        indicatorColor,
        other.indicatorColor,
        t,
        _lerpColor,
      ),
    );
  }
}

T? _lerpNullable<T>(
  T? begin,
  T? end,
  double t,
  T Function(T begin, T end, double t) lerp,
) {
  if (begin == null || end == null) {
    return t < 0.5 ? begin : end;
  }
  return lerp(begin, end, t);
}

double _lerpDouble(double begin, double end, double t) {
  return begin * (1 - t) + end * t;
}

double? _lerpDoubleWithDefault(
  double? begin,
  double? end,
  double t,
  double defaultValue,
) {
  if (begin == null && end == null) {
    return null;
  }
  return _lerpDouble(begin ?? defaultValue, end ?? defaultValue, t);
}

Color _lerpColor(Color begin, Color end, double t) {
  return Color.lerp(begin, end, t)!;
}

TextStyle _lerpTextStyle(TextStyle begin, TextStyle end, double t) {
  return TextStyle.lerp(begin, end, t)!;
}

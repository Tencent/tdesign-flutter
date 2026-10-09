import 'package:flutter/material.dart';

const _kDefaultHeight = 336.0;
const _kDefaultRootColumnWidth = 103.0;
const _kDefaultItemHeight = 56.0;

/// TTreeSelect 组件级 ThemeExtension。
class TTreeSelectThemeData extends ThemeExtension<TTreeSelectThemeData> {
  const TTreeSelectThemeData({
    this.height,
    this.rootColumnWidth,
    this.columnWidth,
    this.itemHeight,
    this.backgroundColor,
    this.rootBackgroundColor,
    this.selectedBackgroundColor,
    this.textStyle,
    this.selectedTextStyle,
    this.disabledTextStyle,
    this.indicatorColor,
  });

  /// 面板高度。
  /// 未配置时为 336 逻辑像素。
  final double? height;

  /// 根列宽度。
  /// 未配置时为 103 逻辑像素。
  final double? rootColumnWidth;

  /// 所有非根列的固定宽度；为 null 时由组件按可用宽度自动布局。
  ///
  /// 设置后每个非根列均使用该宽度，面板总宽度超过可用宽度时可横向滚动。
  final double? columnWidth;

  /// 单项最小高度。
  /// 未配置时为 56 逻辑像素。
  final double? itemHeight;

  /// 面板背景色。
  /// null 时使用 bgColorContainer Token。
  final Color? backgroundColor;

  /// 根列背景色。
  /// null 时使用 bgColorSecondaryContainer Token。
  final Color? rootBackgroundColor;

  /// 选中项背景色。
  /// null 时使用 bgColorContainer Token。
  final Color? selectedBackgroundColor;

  /// 普通文案样式。
  /// null 时使用当前全局 Token 解析的文字样式。
  final TextStyle? textStyle;

  /// 选中文案样式。
  final TextStyle? selectedTextStyle;

  /// 禁用文案样式。
  /// null 时沿用默认文字样式并使用 textColorDisabled Token。
  final TextStyle? disabledTextStyle;

  /// 选中图标颜色。
  /// null 时使用 brandColor Token。
  final Color? indicatorColor;

  /// 复制主题配置。
  ///
  /// ## 返回值
  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
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

  /// 生成主题过渡配置。
  ///
  /// ## 返回值
  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TTreeSelectThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TTreeSelectThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
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

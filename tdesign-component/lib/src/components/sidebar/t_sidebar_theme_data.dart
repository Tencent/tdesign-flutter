import 'package:flutter/material.dart';

/// 侧边栏样式
enum TSideBarVariant {
  /// 左侧品牌色指示线样式
  line,

  /// 选中项为圆角标签样式
  tag,
}

/// 侧边栏组件 ThemeExtension
///
/// 管理 TSideBar 的子树级视觉样式（内边距、选中/未选中颜色等）。
/// 实例参数负责选中值、形态和交互；具体视觉值由本组件 Theme 配置。
///
/// {@category ComponentTheme}
class TSideBarThemeData extends ThemeExtension<TSideBarThemeData> {
  /// 默认自定义文本框内边距
  final EdgeInsetsGeometry? contentPadding;

  /// 未选中标签文字样式；颜色同时用于未选中图标。
  /// 选中项只继承排版字段，不继承这里的颜色；禁用态使用全局禁用色。
  /// 未指定颜色时使用全局正文色。
  final TextStyle? textStyle;

  /// 选中文字样式；其中的 color 同时控制选中图标和指示线。
  /// 未指定 color 时读取全局品牌色；禁用态始终使用全局禁用色。
  final TextStyle? selectedTextStyle;

  /// 默认选中背景颜色
  final Color? selectedBgColor;

  /// 默认未选中背景颜色
  final Color? unSelectedBgColor;

  const TSideBarThemeData({
    this.contentPadding,
    this.textStyle,
    this.selectedTextStyle,
    this.selectedBgColor,
    this.unSelectedBgColor,
  });

  /// 复制主题配置。
  ///
  /// ## 返回值
  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TSideBarThemeData copyWith({
    EdgeInsetsGeometry? contentPadding,
    TextStyle? textStyle,
    TextStyle? selectedTextStyle,
    Color? selectedBgColor,
    Color? unSelectedBgColor,
  }) {
    return TSideBarThemeData(
      contentPadding: contentPadding ?? this.contentPadding,
      textStyle: textStyle ?? this.textStyle,
      selectedTextStyle: selectedTextStyle ?? this.selectedTextStyle,
      selectedBgColor: selectedBgColor ?? this.selectedBgColor,
      unSelectedBgColor: unSelectedBgColor ?? this.unSelectedBgColor,
    );
  }

  /// 生成主题过渡配置。
  ///
  /// ## 返回值
  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TSideBarThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TSideBarThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TSideBarThemeData) {
      return this;
    }
    return TSideBarThemeData(
      contentPadding: _lerpNullableInsets(
        contentPadding,
        other.contentPadding,
        t,
      ),
      textStyle: _lerpNullableTextStyle(textStyle, other.textStyle, t),
      selectedTextStyle: _lerpNullableTextStyle(
        selectedTextStyle,
        other.selectedTextStyle,
        t,
      ),
      selectedBgColor: _lerpNullableColor(
        selectedBgColor,
        other.selectedBgColor,
        t,
      ),
      unSelectedBgColor: _lerpNullableColor(
        unSelectedBgColor,
        other.unSelectedBgColor,
        t,
      ),
    );
  }
}

EdgeInsetsGeometry? _lerpNullableInsets(
  EdgeInsetsGeometry? begin,
  EdgeInsetsGeometry? end,
  double t,
) {
  if (begin == null || end == null) {
    return t < 0.5 ? begin : end;
  }
  return EdgeInsetsGeometry.lerp(begin, end, t);
}

Color? _lerpNullableColor(Color? begin, Color? end, double t) {
  if (begin == null || end == null) {
    return t < 0.5 ? begin : end;
  }
  return Color.lerp(begin, end, t);
}

TextStyle? _lerpNullableTextStyle(TextStyle? begin, TextStyle? end, double t) {
  if (begin == null || end == null) {
    return t < 0.5 ? begin : end;
  }
  return TextStyle.lerp(begin, end, t);
}

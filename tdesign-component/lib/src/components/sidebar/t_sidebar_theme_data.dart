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
class TSideBarThemeData extends ThemeExtension<TSideBarThemeData> {
  /// 默认自定义文本框内边距
  final EdgeInsetsGeometry? contentPadding;

  /// 默认未选中颜色
  final Color? unSelectedColor;

  /// 选中文字样式；其中的 color 同时控制选中图标和指示线。
  /// 未指定 color 时读取全局品牌色。
  final TextStyle? selectedTextStyle;

  /// 默认选中背景颜色
  final Color? selectedBgColor;

  /// 默认未选中背景颜色
  final Color? unSelectedBgColor;

  const TSideBarThemeData({
    this.contentPadding,
    this.unSelectedColor,
    this.selectedTextStyle,
    this.selectedBgColor,
    this.unSelectedBgColor,
  });

  @override
  TSideBarThemeData copyWith({
    EdgeInsetsGeometry? contentPadding,
    Color? unSelectedColor,
    TextStyle? selectedTextStyle,
    Color? selectedBgColor,
    Color? unSelectedBgColor,
  }) {
    return TSideBarThemeData(
      contentPadding: contentPadding ?? this.contentPadding,
      unSelectedColor: unSelectedColor ?? this.unSelectedColor,
      selectedTextStyle: selectedTextStyle ?? this.selectedTextStyle,
      selectedBgColor: selectedBgColor ?? this.selectedBgColor,
      unSelectedBgColor: unSelectedBgColor ?? this.unSelectedBgColor,
    );
  }

  @override
  TSideBarThemeData lerp(ThemeExtension<TSideBarThemeData>? other, double t) {
    if (other is! TSideBarThemeData) {
      return this;
    }
    return TSideBarThemeData(
      contentPadding: _lerpNullableInsets(
        contentPadding,
        other.contentPadding,
        t,
      ),
      unSelectedColor: _lerpNullableColor(
        unSelectedColor,
        other.unSelectedColor,
        t,
      ),
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

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
/// 构造器参数优先级高于 ThemeData。
class TSideBarThemeData extends ThemeExtension<TSideBarThemeData> {
  /// 默认自定义文本框内边距
  final EdgeInsetsGeometry? contentPadding;

  /// 默认选中颜色
  final Color? selectedColor;

  /// 默认未选中颜色
  final Color? unSelectedColor;

  /// 默认选中文字样式
  final TextStyle? selectedTextStyle;

  /// 默认选中背景颜色
  final Color? selectedBgColor;

  /// 默认未选中背景颜色
  final Color? unSelectedBgColor;

  const TSideBarThemeData({
    this.contentPadding,
    this.selectedColor,
    this.unSelectedColor,
    this.selectedTextStyle,
    this.selectedBgColor,
    this.unSelectedBgColor,
  });

  @override
  TSideBarThemeData copyWith({
    EdgeInsetsGeometry? contentPadding,
    Color? selectedColor,
    Color? unSelectedColor,
    TextStyle? selectedTextStyle,
    Color? selectedBgColor,
    Color? unSelectedBgColor,
  }) {
    return TSideBarThemeData(
      contentPadding: contentPadding ?? this.contentPadding,
      selectedColor: selectedColor ?? this.selectedColor,
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
      contentPadding: EdgeInsetsGeometry.lerp(
        contentPadding,
        other.contentPadding,
        t,
      ),
      selectedColor: Color.lerp(selectedColor, other.selectedColor, t),
      unSelectedColor: Color.lerp(unSelectedColor, other.unSelectedColor, t),
      selectedTextStyle: TextStyle.lerp(
        selectedTextStyle,
        other.selectedTextStyle,
        t,
      ),
      selectedBgColor: Color.lerp(selectedBgColor, other.selectedBgColor, t),
      unSelectedBgColor: Color.lerp(
        unSelectedBgColor,
        other.unSelectedBgColor,
        t,
      ),
    );
  }
}

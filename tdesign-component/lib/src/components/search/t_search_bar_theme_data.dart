import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// `TSearchBar` 的默认视觉配置。
class TSearchBarThemeData extends ThemeExtension<TSearchBarThemeData> {
  const TSearchBarThemeData({
    this.variant,
    this.height,
    this.inputBackgroundColor,
    this.contentPadding,
    this.textStyle,
    this.hintStyle,
    this.searchIconTheme,
    this.clearIconTheme,
    this.actionTextStyle,
    this.actionGap,
    this.cursorHeight,
  });

  /// 搜索框形态。
  final TSearchBarVariant? variant;

  /// 搜索框高度，默认 40dp。
  final double? height;

  /// 输入区域背景色，默认 `bgColorSecondaryContainer` Token。
  final Color? inputBackgroundColor;

  /// 输入区域内部留白，默认水平方向 12dp。
  final EdgeInsetsGeometry? contentPadding;

  /// 输入文字样式，未设置字段继承 `fontBodyLarge` Token。
  final TextStyle? textStyle;

  /// 占位文字样式，未设置字段继承 `fontBodyLarge` 和占位色 Token。
  final TextStyle? hintStyle;

  /// 搜索图标主题。
  final IconThemeData? searchIconTheme;

  /// 清除图标主题。
  final IconThemeData? clearIconTheme;

  /// 右侧操作文字样式。
  final TextStyle? actionTextStyle;

  /// 搜索框与右侧操作文字的间距，默认 15dp。
  final double? actionGap;

  /// 光标高度。
  final double? cursorHeight;

  @override
  TSearchBarThemeData copyWith({
    TSearchBarVariant? variant,
    double? height,
    Color? inputBackgroundColor,
    EdgeInsetsGeometry? contentPadding,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    IconThemeData? searchIconTheme,
    IconThemeData? clearIconTheme,
    TextStyle? actionTextStyle,
    double? actionGap,
    double? cursorHeight,
  }) {
    return TSearchBarThemeData(
      variant: variant ?? this.variant,
      height: height ?? this.height,
      inputBackgroundColor: inputBackgroundColor ?? this.inputBackgroundColor,
      contentPadding: contentPadding ?? this.contentPadding,
      textStyle: textStyle ?? this.textStyle,
      hintStyle: hintStyle ?? this.hintStyle,
      searchIconTheme: searchIconTheme ?? this.searchIconTheme,
      clearIconTheme: clearIconTheme ?? this.clearIconTheme,
      actionTextStyle: actionTextStyle ?? this.actionTextStyle,
      actionGap: actionGap ?? this.actionGap,
      cursorHeight: cursorHeight ?? this.cursorHeight,
    );
  }

  @override
  TSearchBarThemeData lerp(
    ThemeExtension<TSearchBarThemeData>? other,
    double t,
  ) {
    if (other is! TSearchBarThemeData) {
      return this;
    }
    return TSearchBarThemeData(
      variant: t < 0.5 ? variant : other.variant,
      height: lerpDouble(height, other.height, t),
      inputBackgroundColor: Color.lerp(
        inputBackgroundColor,
        other.inputBackgroundColor,
        t,
      ),
      contentPadding: EdgeInsetsGeometry.lerp(
        contentPadding,
        other.contentPadding,
        t,
      ),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      hintStyle: TextStyle.lerp(hintStyle, other.hintStyle, t),
      searchIconTheme: IconThemeData.lerp(
        searchIconTheme,
        other.searchIconTheme,
        t,
      ),
      clearIconTheme: IconThemeData.lerp(
        clearIconTheme,
        other.clearIconTheme,
        t,
      ),
      actionTextStyle: TextStyle.lerp(
        actionTextStyle,
        other.actionTextStyle,
        t,
      ),
      actionGap: lerpDouble(actionGap, other.actionGap, t),
      cursorHeight: lerpDouble(cursorHeight, other.cursorHeight, t),
    );
  }
}

/// 搜索框形态。
enum TSearchBarVariant {
  /// 方形搜索框。
  square,

  /// 圆角搜索框。
  round,
}

/// 搜索框文本对齐方式。
enum TSearchBarAlignment {
  /// 左对齐。
  left,

  /// 居中对齐。
  center,
}

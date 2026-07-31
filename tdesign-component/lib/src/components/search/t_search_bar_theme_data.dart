import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TSearchBar 组件级 ThemeExtension。
class TSearchBarThemeData extends ThemeExtension<TSearchBarThemeData> {
  const TSearchBarThemeData({
    /// 搜索框形态。
    this.variant,

    /// 文本对齐方式。
    this.textAlignment,

    /// 背景颜色。
    this.backgroundColor,

    /// 外层内边距。
    this.padding,

    /// 光标高度。
    this.cursorHeight,

    /// 是否自动高度。
    this.autoHeight,
  });

  /// 搜索框形态。
  final TSearchBarVariant? variant;

  /// 文本对齐方式。
  final TSearchBarAlignment? textAlignment;

  /// 背景颜色。
  final Color? backgroundColor;

  /// 外层内边距。
  final EdgeInsetsGeometry? padding;

  /// 光标高度。
  final double? cursorHeight;

  /// 是否自动高度。
  final bool? autoHeight;

  @override
  TSearchBarThemeData copyWith({
    TSearchBarVariant? variant,
    TSearchBarAlignment? textAlignment,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
    double? cursorHeight,
    bool? autoHeight,
  }) {
    return TSearchBarThemeData(
      variant: variant ?? this.variant,
      textAlignment: textAlignment ?? this.textAlignment,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      padding: padding ?? this.padding,
      cursorHeight: cursorHeight ?? this.cursorHeight,
      autoHeight: autoHeight ?? this.autoHeight,
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
      textAlignment: t < 0.5 ? textAlignment : other.textAlignment,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      cursorHeight: lerpDouble(cursorHeight, other.cursorHeight, t),
      autoHeight: t < 0.5 ? autoHeight : other.autoHeight,
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

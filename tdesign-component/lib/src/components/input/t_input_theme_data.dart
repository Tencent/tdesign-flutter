import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// TInput 与 TTextarea 共用的组件级 ThemeExtension。
///
/// Material 能表达的边框、颜色、内边距和文本样式可通过输入组件的
/// decoration 显式传入；默认状态不继承全局填充色，避免输入区被
/// [ThemeData.inputDecorationTheme] 污染。
class TInputThemeData extends ThemeExtension<TInputThemeData> {
  const TInputThemeData({
    /// 是否默认显示清除按钮。
    this.showClearButton,

    /// 清除图标尺寸。
    this.clearIconSize,

    /// 多行输入默认最小行数。
    this.multilineMinLines,
  });

  /// 是否默认显示清除按钮。
  final bool? showClearButton;

  /// 清除图标尺寸。
  final double? clearIconSize;

  /// 多行输入默认最小行数。
  final int? multilineMinLines;

  @override
  TInputThemeData copyWith({
    bool? showClearButton,
    double? clearIconSize,
    int? multilineMinLines,
  }) {
    return TInputThemeData(
      showClearButton: showClearButton ?? this.showClearButton,
      clearIconSize: clearIconSize ?? this.clearIconSize,
      multilineMinLines: multilineMinLines ?? this.multilineMinLines,
    );
  }

  @override
  TInputThemeData lerp(
    ThemeExtension<TInputThemeData>? other,
    double t,
  ) {
    if (other is! TInputThemeData) {
      return this;
    }
    return TInputThemeData(
      showClearButton: t < 0.5 ? showClearButton : other.showClearButton,
      clearIconSize: lerpDouble(clearIconSize, other.clearIconSize, t),
      multilineMinLines: t < 0.5 ? multilineMinLines : other.multilineMinLines,
    );
  }
}

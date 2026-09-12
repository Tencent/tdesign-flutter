import 'package:flutter/material.dart';

import '../../theme/basic.dart' show Font;

/// 空态组件级 ThemeExtension
class TEmptyThemeData extends ThemeExtension<TEmptyThemeData> {
  /// 描述文字颜色
  final Color? emptyTextColor;

  /// 描述文字字号
  final Font? emptyTextFont;

  const TEmptyThemeData({this.emptyTextColor, this.emptyTextFont});

  @override
  TEmptyThemeData copyWith({Color? emptyTextColor, Font? emptyTextFont}) {
    return TEmptyThemeData(
      emptyTextColor: emptyTextColor ?? this.emptyTextColor,
      emptyTextFont: emptyTextFont ?? this.emptyTextFont,
    );
  }

  @override
  TEmptyThemeData lerp(ThemeExtension<TEmptyThemeData>? other, double t) {
    if (other is! TEmptyThemeData) {
      return this;
    }
    return TEmptyThemeData(
      emptyTextColor: Color.lerp(emptyTextColor, other.emptyTextColor, t),
      emptyTextFont: t < 0.5 ? emptyTextFont : other.emptyTextFont,
    );
  }
}

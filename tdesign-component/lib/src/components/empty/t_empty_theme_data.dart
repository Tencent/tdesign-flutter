import 'package:flutter/material.dart';

import '../../theme/basic.dart' show Font;

/// 空态组件级 ThemeExtension
class TEmptyThemeData extends ThemeExtension<TEmptyThemeData> {
  /// 描述文字颜色
  /// 未配置时使用 textColorPlaceholder Token。
  final Color? emptyTextColor;

  /// 描述文字字号
  /// 未配置时使用 fontBodyMedium Token。
  final Font? emptyTextFont;

  const TEmptyThemeData({this.emptyTextColor, this.emptyTextFont});

  /// 复制主题配置。
  ///
  /// ## 返回值
  /// 返回主题副本；非空参数替换对应配置，null 参数保留当前配置。
  @override
  TEmptyThemeData copyWith({Color? emptyTextColor, Font? emptyTextFont}) {
    return TEmptyThemeData(
      emptyTextColor: emptyTextColor ?? this.emptyTextColor,
      emptyTextFont: emptyTextFont ?? this.emptyTextFont,
    );
  }

  /// 生成主题过渡配置。
  ///
  /// ## 返回值
  /// 按 t 在当前主题和目标主题之间生成过渡主题。
  /// other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。
  @override
  TEmptyThemeData lerp(
    /// 目标主题；为空或类型不匹配时保留当前主题。
    ThemeExtension<TEmptyThemeData>? other,

    /// 插值进度；通常 0 表示当前主题，1 表示目标主题。
    double t,
  ) {
    if (other is! TEmptyThemeData) {
      return this;
    }
    return TEmptyThemeData(
      emptyTextColor: Color.lerp(emptyTextColor, other.emptyTextColor, t),
      emptyTextFont: t < 0.5 ? emptyTextFont : other.emptyTextFont,
    );
  }
}

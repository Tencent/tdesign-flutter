import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_theme.dart';
import 't_switch_theme_data.dart';
import 't_switch_types.dart';

/// Switch 样式解析结果。
@immutable
class TSwitchResolvedStyle {
  const TSwitchResolvedStyle({
    required this.trackOnColor,
    required this.trackOffColor,
    required this.thumbContentOnColor,
    required this.thumbContentOffColor,
    required this.thumbContentOnFont,
    required this.thumbContentOffFont,
  });

  final Color trackOnColor;
  final Color trackOffColor;
  final Color thumbContentOnColor;
  final Color thumbContentOffColor;
  final TextStyle thumbContentOnFont;
  final TextStyle thumbContentOffFont;
}

/// Switch 的唯一样式解析入口。
class TSwitchResolve {
  static double width(TSwitchSize size) => switch (size) {
        TSwitchSize.large => 52,
        TSwitchSize.medium => 45,
        TSwitchSize.small => 39,
      };

  static double height(TSwitchSize size) => switch (size) {
        TSwitchSize.large => 32,
        TSwitchSize.medium => 28,
        TSwitchSize.small => 24,
      };

  static TSwitchResolvedStyle resolve({
    required BuildContext context,
    TSwitchThemeData? theme,
  }) {
    final token = context.tTheme;
    return TSwitchResolvedStyle(
      trackOnColor: theme?.trackOnColor ?? token.brandNormalColor,
      trackOffColor: theme?.trackOffColor ?? token.textDisabledColor,
      thumbContentOnColor: theme?.thumbContentOnColor ?? token.brandNormalColor,
      thumbContentOffColor:
          theme?.thumbContentOffColor ?? token.textDisabledColor,
      thumbContentOnFont: theme?.thumbContentOnFont ??
          TextStyle(fontSize: token.fontBodyMedium?.size ?? 14),
      thumbContentOffFont: theme?.thumbContentOffFont ??
          TextStyle(fontSize: token.fontBodyMedium?.size ?? 14),
    );
  }
}

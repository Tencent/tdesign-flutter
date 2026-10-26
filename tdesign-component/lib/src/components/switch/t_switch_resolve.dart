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
    required this.disabledTrackOnColor,
    required this.disabledTrackOffColor,
    required this.thumbColor,
    required this.disabledThumbColor,
    required this.loadingColor,
    required this.thumbContentOnColor,
    required this.thumbContentOffColor,
    required this.thumbContentOnFont,
    required this.thumbContentOffFont,
  });

  final Color trackOnColor;
  final Color trackOffColor;
  final Color disabledTrackOnColor;
  final Color disabledTrackOffColor;
  final Color thumbColor;
  final Color disabledThumbColor;
  final Color loadingColor;
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TSwitchResolvedStyle(
      trackOnColor: theme?.trackOnColor ?? token.brandColor,
      trackOffColor:
          theme?.trackOffColor ?? token.bgColorSecondaryContainerActive,
      disabledTrackOnColor:
          theme?.disabledTrackOnColor ?? token.brandColorDisabled,
      disabledTrackOffColor:
          theme?.disabledTrackOffColor ?? token.bgColorComponentDisabled,
      thumbColor: theme?.thumbColor ?? token.textColorAnti,
      disabledThumbColor:
          theme?.disabledThumbColor ??
          (isDark ? token.fontWhite2 : token.fontWhite1),
      loadingColor:
          theme?.loadingColor ?? (isDark ? token.fontWhite1 : token.brandColor),
      thumbContentOnColor: theme?.thumbContentOnColor ?? token.brandColor,
      thumbContentOffColor:
          theme?.thumbContentOffColor ?? token.textColorDisabled,
      thumbContentOnFont:
          theme?.thumbContentOnFont ??
          TextStyle(fontSize: token.fontBodyMedium?.size ?? 14),
      thumbContentOffFont:
          theme?.thumbContentOffFont ??
          TextStyle(fontSize: token.fontBodyMedium?.size ?? 14),
    );
  }
}

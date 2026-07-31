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
    required bool enabled,
    TSwitchThemeData? theme,
  }) {
    final token = context.tTheme;
    final material = Theme.of(context);
    final switchTheme = material.switchTheme;
    final colorScheme = material.tExplicitColorScheme;
    final onStates = <WidgetState>{
      WidgetState.selected,
      if (!enabled) WidgetState.disabled,
    };
    final offStates = <WidgetState>{if (!enabled) WidgetState.disabled};
    return TSwitchResolvedStyle(
      trackOnColor:
          theme?.trackOnColor ??
          switchTheme.trackColor?.resolve(onStates) ??
          colorScheme?.primary ??
          token.brandNormalColor,
      trackOffColor:
          theme?.trackOffColor ??
          switchTheme.trackColor?.resolve(offStates) ??
          colorScheme?.surfaceContainerHighest ??
          token.textDisabledColor,
      thumbContentOnColor:
          theme?.thumbContentOnColor ??
          switchTheme.thumbColor?.resolve(onStates) ??
          colorScheme?.onPrimary ??
          token.brandNormalColor,
      thumbContentOffColor:
          theme?.thumbContentOffColor ??
          switchTheme.thumbColor?.resolve(offStates) ??
          colorScheme?.onSurfaceVariant ??
          token.textDisabledColor,
      thumbContentOnFont:
          theme?.thumbContentOnFont ??
          TextStyle(fontSize: token.fontBodyMedium?.size ?? 14),
      thumbContentOffFont:
          theme?.thumbContentOffFont ??
          TextStyle(fontSize: token.fontBodyMedium?.size ?? 14),
    );
  }
}

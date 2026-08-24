import 'package:flutter/material.dart';

import '../../theme/basic.dart';
import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_spacers.dart';
import '../../theme/t_theme.dart';
import 't_link_theme_data.dart';
import 't_link_types.dart';

/// Link 样式的唯一解析入口。
class TLinkResolve {
  TLinkResolve._(); // coverage:ignore-line

  /// 解析 normal / active / disabled 链接颜色。
  static Color resolveColor({
    required BuildContext context,
    required TLinkColorScheme colorScheme,
    required TLinkThemeData? theme,
    required bool isDisabled,
    required bool isActive,
  }) {
    final token = context.tTheme;
    final material = Theme.of(context).tExplicitColorScheme;

    if (isDisabled) {
      return switch (colorScheme) {
        TLinkColorScheme.primary => token.brandDisabledColor,
        TLinkColorScheme.defaultTheme => token.textDisabledColor,
        TLinkColorScheme.danger => token.errorDisabledColor,
        TLinkColorScheme.warning => token.warningDisabledColor,
        TLinkColorScheme.success => token.successDisabledColor,
      };
    }

    if (isActive) {
      return switch (colorScheme) {
        TLinkColorScheme.primary ||
        TLinkColorScheme.defaultTheme => token.brandClickColor,
        TLinkColorScheme.danger => token.errorClickColor,
        TLinkColorScheme.warning => token.warningClickColor,
        TLinkColorScheme.success => token.successClickColor,
      };
    }

    final themedColor = theme?.textStyle?.color;
    if (themedColor != null) {
      return themedColor;
    }
    return switch (colorScheme) {
      TLinkColorScheme.primary => material?.primary ?? token.brandNormalColor,
      TLinkColorScheme.defaultTheme =>
        material?.onSurface ?? token.textColorPrimary,
      TLinkColorScheme.danger => material?.error ?? token.errorNormalColor,
      TLinkColorScheme.warning => token.warningNormalColor,
      TLinkColorScheme.success => token.successNormalColor,
    };
  }

  /// 解析包含字号、行高、字重与颜色的完整文字样式。
  static TextStyle resolveTextStyle({
    required BuildContext context,
    required TLinkSize size,
    required TLinkThemeData? theme,
    required Color color,
  }) {
    final font = _fontForSize(context, size);
    final base = TextStyle(
      fontSize: font.size,
      height: font.height,
      fontWeight: font.fontWeight,
    );
    return base.merge(theme?.textStyle).copyWith(color: color);
  }

  /// 解析图标尺寸。
  static double resolveIconSize({
    required TLinkSize size,
    required TLinkThemeData? theme,
  }) {
    return theme?.iconSize ??
        switch (size) {
          TLinkSize.small => 14,
          TLinkSize.medium => 16,
          TLinkSize.large => 18,
        };
  }

  /// 解析图标与文字间距。
  static double resolveIconGap({
    required BuildContext context,
    required TLinkThemeData? theme,
  }) {
    return theme?.iconGap ?? context.tTheme.spacer4;
  }

  static Font _fontForSize(BuildContext context, TLinkSize size) {
    final token = context.tTheme;
    return switch (size) {
      TLinkSize.small => token.fontBodySmall ?? Font(size: 12, lineHeight: 20),
      TLinkSize.medium =>
        token.fontBodyMedium ?? Font(size: 14, lineHeight: 22),
      TLinkSize.large => token.fontBodyLarge ?? Font(size: 16, lineHeight: 24),
    };
  }
}

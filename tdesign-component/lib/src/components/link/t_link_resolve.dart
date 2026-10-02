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
    required TLinkColorPreset colorPreset,
    required TLinkThemeData? theme,
    required bool isDisabled,
    required bool isActive,
  }) {
    final token = context.tTheme;

    if (isDisabled) {
      return switch (colorPreset) {
        TLinkColorPreset.primary => token.brandColorDisabled,
        TLinkColorPreset.defaultTheme => token.textColorDisabled,
        TLinkColorPreset.danger => token.errorColorDisabled,
        TLinkColorPreset.warning => token.warningColorDisabled,
        TLinkColorPreset.success => token.successColorDisabled,
      };
    }

    if (isActive) {
      return switch (colorPreset) {
        TLinkColorPreset.primary ||
        TLinkColorPreset.defaultTheme => token.brandColorActive,
        TLinkColorPreset.danger => token.errorColorActive,
        TLinkColorPreset.warning => token.warningColorActive,
        TLinkColorPreset.success => token.successColorActive,
      };
    }

    final themedColor = theme?.textStyle?.color;
    if (themedColor != null) {
      return themedColor;
    }
    return switch (colorPreset) {
      TLinkColorPreset.primary => token.brandColor,
      TLinkColorPreset.defaultTheme => token.textColorPrimary,
      TLinkColorPreset.danger => token.errorColor,
      TLinkColorPreset.warning => token.warningColor,
      TLinkColorPreset.success => token.successColor,
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
    return theme?.iconGap ?? 4.0;
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

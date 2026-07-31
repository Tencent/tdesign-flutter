import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_theme.dart';
import 't_link_theme_data.dart';
import 't_link_types.dart';

/// Link 样式解析器
///
/// 优先级链：构造器参数 > TLinkThemeData > 显式 Material/ColorScheme
/// > Token 默认值
/// 这是唯一的样式 merge 入口，build 内禁止内联颜色/尺寸计算。
class TLinkResolve {
  TLinkResolve._(); // coverage:ignore-line

  /// 解析链接文本颜色
  ///
  /// 优先级：构造器 color > Theme.color > colorScheme × disabled 映射
  static Color resolveColor({
    required BuildContext context,
    required TLinkColorScheme? colorScheme,
    required TLinkThemeData? theme,
    required bool isDisabled,
    Color? instanceColor,
  }) {
    // L1：构造器参数
    if (instanceColor != null) {
      return instanceColor;
    }
    // L2：Theme
    final themeColor = theme?.color;
    if (themeColor != null) {
      return themeColor;
    }
    // L3：颜色映射
    final tTheme = context.tTheme;
    final materialScheme = Theme.of(context).tExplicitColorScheme;
    final scheme = colorScheme ?? TLinkColorScheme.primary;

    if (isDisabled) {
      return _disabledColor(scheme, tTheme, materialScheme);
    }
    return _normalColor(scheme, tTheme, materialScheme);
  }

  /// 解析字号
  ///
  /// 优先级：构造器 fontSize > Theme.fontSize > size 默认
  static double resolveFontSize({
    required TLinkSize size,
    required TLinkThemeData? theme,
    double? instanceFontSize,
  }) {
    if (instanceFontSize != null) {
      return instanceFontSize;
    }
    if (theme?.fontSize != null) {
      return theme!.fontSize!;
    }
    return _defaultFontSize(size);
  }

  /// 解析图标尺寸
  ///
  /// 优先级：构造器 iconSize > Theme.iconSize > size 默认
  static double resolveIconSize({
    required TLinkSize size,
    required TLinkThemeData? theme,
    double? instanceIconSize,
  }) {
    if (instanceIconSize != null) {
      return instanceIconSize;
    }
    if (theme?.iconSize != null) {
      // coverage:ignore-line
      return theme!.iconSize!; // coverage:ignore-line
    }
    return _defaultIconSize(size);
  }

  /// 解析图标与文本间距
  ///
  /// 返回 (leftGap, rightGap)
  /// 优先级：构造器参数 > Theme > size 默认
  static (double leftGap, double rightGap) resolveGap({
    required TLinkSize size,
    required TLinkThemeData? theme,
    double? instanceLeftGap,
    double? instanceRightGap,
  }) {
    return (
      instanceLeftGap ?? theme?.leftGapWithIcon ?? _defaultLeftGap(size),
      instanceRightGap ?? theme?.rightGapWithIcon ?? _defaultRightGap(size),
    );
  }

  // ---- 内部颜色映射 ----

  /// 正常态颜色映射
  static Color _normalColor(
    TLinkColorScheme scheme,
    TThemeData tTheme,
    ColorScheme? material,
  ) {
    return switch (scheme) {
      TLinkColorScheme.primary => material?.primary ?? tTheme.brandNormalColor,
      TLinkColorScheme.danger =>
        material?.error ?? tTheme.errorNormalColor, // coverage:ignore-line
      TLinkColorScheme.warning =>
        tTheme.warningNormalColor, // coverage:ignore-line
      TLinkColorScheme.success =>
        tTheme.successNormalColor, // coverage:ignore-line
      TLinkColorScheme.defaultTheme =>
        material?.onSurface ?? tTheme.textColorPrimary, // coverage:ignore-line
    };
  }

  /// 禁用态颜色映射
  static Color _disabledColor(
    TLinkColorScheme scheme,
    TThemeData tTheme,
    ColorScheme? material,
  ) {
    final materialDisabled = material?.onSurface.withValues(alpha: 0.38);
    return switch (scheme) {
      TLinkColorScheme.primary => materialDisabled ?? tTheme.brandDisabledColor,
      TLinkColorScheme.danger => materialDisabled ?? tTheme.errorDisabledColor,
      TLinkColorScheme.warning =>
        tTheme.warningDisabledColor, // coverage:ignore-line
      TLinkColorScheme.success =>
        tTheme.successDisabledColor, // coverage:ignore-line
      TLinkColorScheme.defaultTheme =>
        materialDisabled ?? tTheme.textDisabledColor, // coverage:ignore-line
    };
  }

  // ---- 默认值 ----

  static double _defaultFontSize(TLinkSize size) {
    return switch (size) {
      TLinkSize.large => 16,
      TLinkSize.medium => 14,
      TLinkSize.small => 12,
    };
  }

  static double _defaultIconSize(TLinkSize size) {
    return switch (size) {
      TLinkSize.large => 18,
      TLinkSize.medium => 16,
      TLinkSize.small => 14, // coverage:ignore-line
    };
  }

  static double _defaultLeftGap(TLinkSize size) {
    return switch (size) {
      TLinkSize.large => 8,
      TLinkSize.medium => 6.34,
      TLinkSize.small => 6.05, // coverage:ignore-line
    };
  }

  static double _defaultRightGap(TLinkSize size) {
    return switch (size) {
      TLinkSize.large => 8,
      TLinkSize.medium => 7,
      TLinkSize.small => 6.63, // coverage:ignore-line
    };
  }
}

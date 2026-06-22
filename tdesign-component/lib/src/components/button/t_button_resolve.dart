import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';
import 't_button.dart';
import 't_button_theme_data.dart';

/// 按钮样式解析器
///
/// 优先级链：shape → P2 色板 → colorScheme 覆色 → size 尺寸 → Theme padding → P0 [style]
/// 这是唯一的 [ButtonStyle] merge 入口，build 内禁止内联 variant/colorScheme/shape merge。
class TButtonResolve {
  TButtonResolve._();

  /// 解析最终的 [ButtonStyle]
  static ButtonStyle resolve({
    required TButtonVariant variant,
    required TButtonColorScheme? colorScheme,
    required TButtonSize size,
    required Widget? icon,
    required TButtonIconPosition iconPosition,
    required TButtonThemeData? theme,
    required ButtonStyle? instanceStyle,
    required BuildContext context,
  }) {
    final tTheme = TTheme.of(context);
    final effectiveShape = theme?.effectiveShape ?? TButtonShape.rectangle;

    // 1. P2 色板（variant 级）
    final variantPalette = _variantPalette(theme, variant);

    // 2. colorScheme 覆色
    final colorStyle = _resolveColors(
      context: context,
      variant: variant,
      colorScheme: colorScheme,
      tTheme: tTheme,
    );

    // 3. shape → ButtonStyle.shape
    final shapeStyle = _resolveShape(
      context: context,
      effectiveShape: effectiveShape,
      tTheme: tTheme,
    );

    // 4. size → minimumSize + padding
    final sizeStyle = _resolveSize(
      size: size,
      hasIcon: icon != null,
      hasChild: true, // v1.0 始终有 child
      effectiveShape: effectiveShape,
    );

    // 5. Theme padding 覆盖默认
    final paddingStyle = theme?.padding != null
        ? ButtonStyle(padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(theme!.padding!))
        : null;

    // 6. iconSpacing
    final spacing = theme?.iconSpacing ?? 8.0;
    final iconSpacingStyle = _resolveIconSpacing(spacing, iconPosition);

    // 合并：P2 色板 → colorScheme → shape → size → Theme padding → iconSpacing → P0
    ButtonStyle resolved = variantPalette ?? const ButtonStyle();
    resolved = resolved.merge(colorStyle);
    resolved = resolved.merge(shapeStyle);
    resolved = resolved.merge(sizeStyle);
    if (paddingStyle != null) {
      resolved = resolved.merge(paddingStyle);
    }
    resolved = resolved.merge(iconSpacingStyle);

    // P0：实例 style 覆盖所有
    if (instanceStyle != null) {
      resolved = resolved.merge(instanceStyle);
    }

    return resolved;
  }

  /// 获取 variant 对应的 P2 色板
  static ButtonStyle? _variantPalette(TButtonThemeData? theme, TButtonVariant variant) {
    return switch (variant) {
      TButtonVariant.fill => theme?.filledStyle,
      TButtonVariant.outline => theme?.outlinedStyle,
      TButtonVariant.text => theme?.textButtonStyle,
      TButtonVariant.ghost => theme?.ghostStyle,
    };
  }

  /// 根据 variant + colorScheme 生成颜色 ButtonStyle
  static ButtonStyle _resolveColors({
    required BuildContext context,
    required TButtonVariant variant,
    required TButtonColorScheme? colorScheme,
    required TThemeData tTheme,
  }) {
    final scheme = colorScheme ?? TButtonColorScheme.defaultTheme;

    switch (variant) {
      case TButtonVariant.fill:
        return _resolveFillColors(context, scheme, tTheme);
      case TButtonVariant.outline:
        return _resolveOutlineColors(context, scheme, tTheme);
      case TButtonVariant.text:
        return _resolveTextColors(context, scheme, tTheme);
      case TButtonVariant.ghost:
        return _resolveGhostColors(context, scheme, tTheme);
    }
  }

  /// fill 变体颜色
  static ButtonStyle _resolveFillColors(
      BuildContext context, TButtonColorScheme scheme, TThemeData tTheme) {
    Color bg;
    Color fg;

    switch (scheme) {
      case TButtonColorScheme.primary:
        bg = tTheme.brandNormalColor;
        fg = tTheme.textColorAnti;
      case TButtonColorScheme.danger:
        bg = tTheme.errorNormalColor;
        fg = tTheme.textColorAnti;
      case TButtonColorScheme.light:
        bg = tTheme.brandLightColor;
        fg = tTheme.brandNormalColor;
      case TButtonColorScheme.defaultTheme:
        bg = tTheme.bgColorComponent;
        fg = tTheme.textColorPrimary;
    }

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return _disabledBackgroundColor(scheme, tTheme);
        }
        if (states.contains(WidgetState.pressed)) {
          return _pressedBackgroundColor(scheme, tTheme);
        }
        return bg;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return tTheme.textDisabledColor;
        }
        return fg;
      }),
      elevation: WidgetStatePropertyAll<double>(0),
    );
  }

  /// outline 变体颜色
  static ButtonStyle _resolveOutlineColors(
      BuildContext context, TButtonColorScheme scheme, TThemeData tTheme) {
    Color? borderColor;
    Color fg;

    switch (scheme) {
      case TButtonColorScheme.primary:
        borderColor = tTheme.brandNormalColor;
        fg = tTheme.brandNormalColor;
      case TButtonColorScheme.danger:
        borderColor = tTheme.errorNormalColor;
        fg = tTheme.errorNormalColor;
      case TButtonColorScheme.light:
        borderColor = tTheme.brandNormalColor;
        fg = tTheme.brandNormalColor;
      case TButtonColorScheme.defaultTheme:
        borderColor = tTheme.componentBorderColor;
        fg = tTheme.textColorPrimary;
    }

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return tTheme.bgColorContainerActive;
        }
        return Colors.transparent;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return tTheme.textDisabledColor;
        }
        return fg;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(color: tTheme.componentBorderColor.withValues(alpha: 0.4), width: 1);
        }
        return BorderSide(color: borderColor ?? tTheme.componentBorderColor, width: 1);
      }),
      elevation: WidgetStatePropertyAll<double>(0),
    );
  }

  /// text 变体颜色
  static ButtonStyle _resolveTextColors(
      BuildContext context, TButtonColorScheme scheme, TThemeData tTheme) {
    Color fg;

    switch (scheme) {
      case TButtonColorScheme.primary:
        fg = tTheme.brandNormalColor;
      case TButtonColorScheme.danger:
        fg = tTheme.errorNormalColor;
      case TButtonColorScheme.light:
        fg = tTheme.brandNormalColor;
      case TButtonColorScheme.defaultTheme:
        fg = tTheme.textColorPrimary;
    }

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return tTheme.bgColorContainerActive;
        }
        return Colors.transparent;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return tTheme.textDisabledColor;
        }
        return fg;
      }),
      elevation: WidgetStatePropertyAll<double>(0),
    );
  }

  /// ghost 变体颜色
  static ButtonStyle _resolveGhostColors(
      BuildContext context, TButtonColorScheme scheme, TThemeData tTheme) {
    Color fg;

    switch (scheme) {
      case TButtonColorScheme.primary:
        fg = tTheme.brandNormalColor;
      case TButtonColorScheme.danger:
        fg = tTheme.errorNormalColor;
      case TButtonColorScheme.light:
        fg = tTheme.brandNormalColor;
      case TButtonColorScheme.defaultTheme:
        fg = tTheme.fontWhColor1;
    }

    return ButtonStyle(
      backgroundColor: WidgetStatePropertyAll<Color>(Colors.transparent),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return tTheme.fontWhColor4;
        }
        return fg;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        final color = states.contains(WidgetState.disabled)
            ? tTheme.fontWhColor4
            : fg;
        return BorderSide(color: color, width: 1);
      }),
      elevation: WidgetStatePropertyAll<double>(0),
    );
  }

  /// 将内部 shape 枚举展开为 [ButtonStyle.shape]
  static ButtonStyle _resolveShape({
    required BuildContext context,
    required TButtonShape effectiveShape,
    required TThemeData tTheme,
  }) {
    final OutlinedBorder shape = switch (effectiveShape) {
      TButtonShape.rectangle || TButtonShape.square => RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(tTheme.radiusDefault),
          ),
        ),
      TButtonShape.round => RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(tTheme.radiusRound),
          ),
        ),
      TButtonShape.circle => const CircleBorder(),
      TButtonShape.filled => const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
    };
    return ButtonStyle(
      shape: WidgetStatePropertyAll<OutlinedBorder>(shape),
    );
  }

  /// 根据 size + shape 推导 minimumSize 和 padding
  static ButtonStyle _resolveSize({
    required TButtonSize size,
    required bool hasIcon,
    required bool hasChild,
    required TButtonShape effectiveShape,
  }) {
    final isSquareOrCircle = effectiveShape == TButtonShape.square ||
        effectiveShape == TButtonShape.circle;
    // square/circle 纯 icon 按钮：等宽高 + 等边 padding
    final onlyIcon = hasIcon && !hasChild;

    double sideLength;
    double paddingValue;

    switch (size) {
      case TButtonSize.large:
        sideLength = 48;
        paddingValue = onlyIcon ? 12 : 20;
      case TButtonSize.medium:
        sideLength = 40;
        paddingValue = onlyIcon ? 10 : 16;
      case TButtonSize.small:
        sideLength = 32;
        paddingValue = onlyIcon ? 7 : 12;
      case TButtonSize.extraSmall:
        sideLength = 28;
        paddingValue = onlyIcon ? 5 : 8;
    }

    double? minWidth;
    double minHeight = sideLength;

    if (isSquareOrCircle) {
      // square/circle：固定宽高
      minWidth = sideLength;
    }

    // padding：纵向按 size，横向按内容
    final padH = (isSquareOrCircle && onlyIcon) ? paddingValue : paddingValue;
    final padV = (isSquareOrCircle && onlyIcon) ? paddingValue : _verticalPadding(size);

    return ButtonStyle(
      minimumSize: WidgetStatePropertyAll<Size>(
        Size(minWidth ?? 0, minHeight),
      ),
      padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(horizontal: padH, vertical: padV),
      ),
    );
  }

  /// 根据 size 获取纵向 padding
  static double _verticalPadding(TButtonSize size) {
    switch (size) {
      case TButtonSize.large:
        return 12;
      case TButtonSize.medium:
        return 8;
      case TButtonSize.small:
        return 5;
      case TButtonSize.extraSmall:
        return 3;
    }
  }

  /// 图标与文案间距
  static ButtonStyle _resolveIconSpacing(double spacing, TButtonIconPosition iconPosition) {
    // 使用 visualDensity 或通过 padding 间接控制间距
    // 此处由 TButton.build 内部 Row 的间隙控制，不写入 ButtonStyle
    return const ButtonStyle();
  }

  // --- 辅助颜色计算 ---

  static Color _disabledBackgroundColor(TButtonColorScheme scheme, TThemeData tTheme) {
    switch (scheme) {
      case TButtonColorScheme.primary:
        return tTheme.brandDisabledColor;
      case TButtonColorScheme.danger:
        return tTheme.errorDisabledColor;
      case TButtonColorScheme.light:
        return tTheme.brandLightColor;
      case TButtonColorScheme.defaultTheme:
        return tTheme.bgColorComponentDisabled;
    }
  }

  static Color _pressedBackgroundColor(TButtonColorScheme scheme, TThemeData tTheme) {
    switch (scheme) {
      case TButtonColorScheme.primary:
        return tTheme.brandClickColor;
      case TButtonColorScheme.danger:
        return tTheme.errorClickColor;
      case TButtonColorScheme.light:
        return tTheme.brandFocusColor;
      case TButtonColorScheme.defaultTheme:
        return tTheme.bgColorComponentHover;
    }
  }
}

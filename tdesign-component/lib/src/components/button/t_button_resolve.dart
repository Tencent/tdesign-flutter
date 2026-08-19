import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_theme.dart';
import 't_button_theme_data.dart';
import 't_button_types.dart';

/// 按钮样式解析器
///
/// 优先级链：
/// Token → ColorScheme → Material ButtonTheme → 组件 ThemeExtension
/// → 显式实例参数 → P0 style。
/// 这是唯一的 [ButtonStyle] merge 入口，build 内禁止内联 variant/colorScheme/shape merge。
class TButtonResolve {
  TButtonResolve._();

  /// 解析最终的 [ButtonStyle]
  ///
  /// [variant] 按钮形态，决定 fill / outline / text / ghost 的基础样式链路。
  /// [colorScheme] 语义色方案；为 null 时使用默认色方案。
  /// [size] 尺寸规格，用于推导最小尺寸、内边距和默认字号。
  /// [icon] 图标内容；与 [hasChild] 一起决定图标尺寸。
  /// [hasChild] 是否存在文本或自定义内容，用于区分纯图标按钮与图文按钮。
  /// [theme] P1 组件主题，提供默认形态、色板、间距、渐变等配置。
  /// [instanceStyle] P0 实例样式，优先级最高，会覆盖所有 resolve 结果。
  /// [context] 当前构建上下文，用于读取 TDesign 全局 Token。
  /// [hasGradient] 是否启用渐变背景；启用时会清理 Material 默认背景和阴影污染。
  static ButtonStyle resolve({
    /// 按钮形态，决定 fill / outline / text / ghost 的基础样式链路。
    required TButtonVariant variant,

    /// 语义色方案；为 null 时使用默认色方案。
    required TButtonColorScheme? colorScheme,

    /// 尺寸规格，用于推导最小尺寸、内边距和默认字号。
    required TButtonSize size,

    /// 图标内容；与 `hasChild` 一起决定图标尺寸。
    required Widget? icon,

    /// 是否存在文本或自定义内容，用于区分纯图标按钮与图文按钮。
    required bool hasChild,

    /// P1 组件主题，提供默认形态、色板、间距、渐变等配置。
    required TButtonThemeData? theme,

    /// P0 实例样式，优先级最高，会覆盖所有 resolve 结果。
    required ButtonStyle? instanceStyle,

    /// 当前构建上下文，用于读取 TDesign 全局 Token。
    required BuildContext context,

    /// 是否启用渐变背景；启用时会清理 Material 默认背景和阴影污染。
    required bool hasGradient,
  }) {
    final tTheme = context.tTheme;
    // 1. P3 ColorScheme，内部仅在 ColorScheme 无对应语义时回退 Token。
    final colorStyle = _resolveColors(
      context: context,
      variant: variant,
      colorScheme: colorScheme ?? TButtonColorScheme.defaultTheme,
    );

    // 2. P2 Material：按 TButton 变体读取对应的 Flutter ButtonTheme。
    final materialPalette = _materialPalette(context, variant);

    // 3. P1 组件 ThemeExtension：只在调用方显式提供字段时覆盖 Material。
    final componentPalette = _variantPalette(theme, variant);

    // 4. Token 默认 shape；Material 可覆盖，显式组件 shape 再覆盖 Material。
    final tokenShapeStyle = _resolveShape(
      context: context,
      effectiveShape: TButtonShape.rectangle,
      tTheme: tTheme,
    );
    final componentShapeStyle = theme?.shape == null
        ? null
        : _resolveShape(
            context: context,
            effectiveShape: theme!.shape!,
            tTheme: tTheme,
          );

    // 5. 实例 size > 组件 defaultSize，并据此生成组件规格尺寸。
    final effectiveShape = theme?.shape ?? TButtonShape.rectangle;
    final sizeStyle = _resolveSize(
      size: size,
      hasIcon: icon != null,
      hasChild: hasChild,
      effectiveShape: effectiveShape,
    );

    // 5.5 textStyle → 保留 Material 字体字段，仅覆盖组件规格字号。
    final tokenFont = tTheme.fontLinkMedium;
    final materialLabelStyle = Theme.of(context).textTheme.labelLarge;
    final textStyleStyle = ButtonStyle(
      textStyle: WidgetStatePropertyAll<TextStyle>(
        TextStyle(
              fontSize: tokenFont?.size,
              height: tokenFont?.height,
              fontWeight: tokenFont?.fontWeight,
              fontFamily: materialLabelStyle?.fontFamily,
              fontFamilyFallback: materialLabelStyle?.fontFamilyFallback,
            )
            .merge(Theme.of(context).tExplicitTextTheme?.labelLarge)
            .copyWith(fontSize: _fontSizeForSize(size)),
      ),
    );

    // 6. P1 Theme padding 覆盖规格默认。
    final paddingStyle = theme?.padding != null
        ? ButtonStyle(
            padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
              theme!.padding!,
            ),
          )
        : null;

    // 合并：Token shape / P3 ColorScheme → P2 Material → P1 组件 Theme。
    var resolved = _overrideWith(tokenShapeStyle, colorStyle);
    if (materialPalette != null) {
      resolved = _overrideWith(resolved, materialPalette);
    }
    if (componentPalette != null) {
      resolved = _overrideWith(resolved, componentPalette);
    }
    if (componentShapeStyle != null) {
      resolved = _overrideWith(resolved, componentShapeStyle);
    }
    resolved = _overrideWith(resolved, sizeStyle);
    resolved = _overrideWith(resolved, textStyleStyle);
    if (paddingStyle != null) {
      resolved = _overrideWith(resolved, paddingStyle);
    }

    // 显式实例 colorScheme 属于 P0 参数，覆盖组件与 Material 色板。
    if (colorScheme != null) {
      resolved = _overrideWith(resolved, colorStyle);
    }

    // 渐变存在时强制背景 null（触发 MaterialType.transparency），阻止 M3 默认样式污染渐变效果（在 P0 之前，允许 P0 覆盖）
    if (hasGradient) {
      resolved = _overrideWith(
        resolved,
        const ButtonStyle(
          // 设为 null 而非 Colors.transparent，确保 ButtonStyleButton 使用 MaterialType.transparency
          backgroundColor: WidgetStatePropertyAll<Color?>(null),
          overlayColor: WidgetStatePropertyAll<Color>(Colors.transparent),
          surfaceTintColor: WidgetStatePropertyAll<Color>(Colors.transparent),
          shadowColor: WidgetStatePropertyAll<Color>(Colors.transparent),
        ),
      );
    }

    // P0：实例 style 覆盖所有
    if (instanceStyle != null) {
      resolved = _overrideWith(resolved, instanceStyle);
    }

    return resolved;
  }

  /// 使用 [overrideStyle] 覆盖 [base] 中同名字段。
  static ButtonStyle _overrideWith(
    ButtonStyle base,
    ButtonStyle overrideStyle,
  ) {
    return overrideStyle.merge(base);
  }

  /// 获取 variant 对应的 P2 色板

  static ButtonStyle? _variantPalette(
    TButtonThemeData? theme,
    TButtonVariant variant,
  ) {
    return switch (variant) {
      TButtonVariant.fill => theme?.filledStyle,
      TButtonVariant.outline => theme?.outlinedStyle,
      TButtonVariant.text => theme?.textButtonStyle,
      TButtonVariant.ghost => theme?.ghostStyle,
    };
  }

  /// 获取当前变体对应的 Flutter Material ButtonTheme。
  static ButtonStyle? _materialPalette(
    BuildContext context,
    TButtonVariant variant,
  ) {
    final material = Theme.of(context);
    final palette = switch (variant) {
      TButtonVariant.fill => material.elevatedButtonTheme.style,
      TButtonVariant.outline => material.outlinedButtonTheme.style,
      TButtonVariant.text => material.textButtonTheme.style,
      TButtonVariant.ghost => material.outlinedButtonTheme.style,
    };
    return material.tIsTokenProjectedButtonStyle(palette) ? null : palette;
  }

  /// 根据 variant + colorScheme 生成颜色 ButtonStyle
  static ButtonStyle _resolveColors({
    required BuildContext context,
    required TButtonVariant variant,
    required TButtonColorScheme colorScheme,
  }) {
    final scheme = colorScheme;

    switch (variant) {
      case TButtonVariant.fill:
        return _resolveFillColors(context, scheme);
      case TButtonVariant.outline:
        return _resolveOutlineColors(context, scheme);
      case TButtonVariant.text:
        return _resolveTextColors(context, scheme);
      case TButtonVariant.ghost:
        return _resolveGhostColors(context, scheme);
    }
  }

  /// fill 变体颜色
  static ButtonStyle _resolveFillColors(
    BuildContext context,
    TButtonColorScheme scheme,
  ) {
    final tTheme = context.tTheme;
    final colorScheme = Theme.of(context).tExplicitColorScheme;
    Color bg;
    Color fg;

    switch (scheme) {
      case TButtonColorScheme.primary:
        bg = colorScheme?.primary ?? tTheme.brandNormalColor;
        fg = colorScheme?.onPrimary ?? tTheme.textColorAnti;
      case TButtonColorScheme.danger:
        bg = colorScheme?.error ?? tTheme.errorNormalColor;
        fg = colorScheme?.onError ?? tTheme.textColorAnti;
      case TButtonColorScheme.light:
        bg = colorScheme?.primaryContainer ?? tTheme.brandLightColor;
        fg = colorScheme?.onPrimaryContainer ?? tTheme.brandNormalColor;
      case TButtonColorScheme.defaultTheme:
        bg = colorScheme?.surfaceContainerHighest ?? tTheme.bgColorComponent;
        fg = colorScheme?.onSurface ?? tTheme.textColorPrimary;
    }

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme?.onSurface.withValues(alpha: 0.12) ??
              _disabledBackgroundColor(scheme, tTheme);
        }
        if (states.contains(WidgetState.pressed)) {
          return colorScheme == null
              ? _pressedBackgroundColor(scheme, tTheme)
              : Color.alphaBlend(fg.withValues(alpha: 0.12), bg);
        }
        return bg;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme?.onSurface.withValues(alpha: 0.38) ??
              tTheme.textDisabledColor;
        }
        return fg;
      }),
      overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      surfaceTintColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      shadowColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      elevation: const WidgetStatePropertyAll<double>(0),
    );
  }

  /// outline 变体颜色
  static ButtonStyle _resolveOutlineColors(
    BuildContext context,
    TButtonColorScheme scheme,
  ) {
    final tTheme = context.tTheme;
    final colorScheme = Theme.of(context).tExplicitColorScheme;
    late final Color borderColor;
    Color fg;
    // 禁用态文字色与边框色一致，对齐 tdesign 官方规范（_var.less）
    late final Color disabledColor;

    switch (scheme) {
      case TButtonColorScheme.primary:
        borderColor = colorScheme?.primary ?? tTheme.brandNormalColor;
        fg = colorScheme?.primary ?? tTheme.brandNormalColor;
        disabledColor = tTheme.brandDisabledColor;
      case TButtonColorScheme.danger:
        borderColor = colorScheme?.error ?? tTheme.errorNormalColor;
        fg = colorScheme?.error ?? tTheme.errorNormalColor;
        disabledColor = tTheme.errorDisabledColor;
      case TButtonColorScheme.light:
        borderColor = colorScheme?.primary ?? tTheme.brandNormalColor;
        fg = colorScheme?.primary ?? tTheme.brandNormalColor;
        disabledColor = tTheme.brandDisabledColor;
      case TButtonColorScheme.defaultTheme:
        borderColor = colorScheme?.outline ?? tTheme.componentBorderColor;
        fg = colorScheme?.onSurface ?? tTheme.textColorPrimary;
        disabledColor = tTheme.componentBorderColor;
    }

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return colorScheme?.onSurface.withValues(alpha: 0.08) ??
              tTheme.bgColorContainerActive;
        }
        return Colors.transparent;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme?.onSurface.withValues(alpha: 0.38) ??
              disabledColor;
        }
        return fg;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(
            color: colorScheme?.onSurface.withValues(alpha: 0.38) ??
                disabledColor,
            width: 1,
          );
        }
        return BorderSide(color: borderColor, width: 1);
      }),
      overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      surfaceTintColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      shadowColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      elevation: const WidgetStatePropertyAll<double>(0),
    );
  }

  /// text 变体颜色
  static ButtonStyle _resolveTextColors(
    BuildContext context,
    TButtonColorScheme scheme,
  ) {
    final tTheme = context.tTheme;
    final colorScheme = Theme.of(context).tExplicitColorScheme;
    Color fg;

    switch (scheme) {
      case TButtonColorScheme.primary:
        fg = colorScheme?.primary ?? tTheme.brandNormalColor;
      case TButtonColorScheme.danger:
        fg = colorScheme?.error ?? tTheme.errorNormalColor;
      case TButtonColorScheme.light:
        fg = colorScheme?.primary ?? tTheme.brandNormalColor;
      case TButtonColorScheme.defaultTheme:
        fg = colorScheme?.onSurface ?? tTheme.textColorPrimary;
    }

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return colorScheme?.onSurface.withValues(alpha: 0.08) ??
              tTheme.bgColorContainerActive;
        }
        return Colors.transparent;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme?.onSurface.withValues(alpha: 0.38) ??
              tTheme.textDisabledColor;
        }
        return fg;
      }),
      overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      surfaceTintColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      shadowColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      elevation: const WidgetStatePropertyAll<double>(0),
    );
  }

  /// ghost 变体颜色
  static ButtonStyle _resolveGhostColors(
    BuildContext context,
    TButtonColorScheme scheme,
  ) {
    final tTheme = context.tTheme;
    final colorScheme = Theme.of(context).tExplicitColorScheme;
    Color fg;

    switch (scheme) {
      case TButtonColorScheme.primary:
        fg = colorScheme?.primary ?? tTheme.brandNormalColor;
      case TButtonColorScheme.danger:
        fg = colorScheme?.error ?? tTheme.errorNormalColor;
      case TButtonColorScheme.light:
        fg = colorScheme?.primary ?? tTheme.brandNormalColor;
      case TButtonColorScheme.defaultTheme:
        fg = colorScheme?.onInverseSurface ?? tTheme.fontWhColor1;
    }

    return ButtonStyle(
      backgroundColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme?.onInverseSurface.withValues(alpha: 0.38) ??
              tTheme.fontWhColor4;
        }
        return fg;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        final color = states.contains(WidgetState.disabled)
            ? colorScheme?.onInverseSurface.withValues(alpha: 0.38) ??
                  tTheme.fontWhColor4
            : fg;
        return BorderSide(color: color, width: 1);
      }),
      overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      surfaceTintColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      shadowColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      elevation: const WidgetStatePropertyAll<double>(0),
    );
  }

  /// 将内部 shape 枚举展开为 [ButtonStyle.shape]
  static ButtonStyle _resolveShape({
    required BuildContext context,
    required TButtonShape effectiveShape,
    required TThemeData tTheme,
  }) {
    final shape = switch (effectiveShape) {
      TButtonShape.rectangle => RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(tTheme.radiusDefault)),
      ),
      TButtonShape.square => const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      TButtonShape.round => RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(tTheme.radiusRound)),
      ),
      TButtonShape.circle => const CircleBorder(),
      TButtonShape.filled => const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
    };
    return ButtonStyle(shape: WidgetStatePropertyAll<OutlinedBorder>(shape));
  }

  /// 根据 size + shape 推导 minimumSize 和 padding
  static ButtonStyle _resolveSize({
    required TButtonSize size,
    required bool hasIcon,
    required bool hasChild,
    required TButtonShape effectiveShape,
  }) {
    final isSquareOrCircle =
        effectiveShape == TButtonShape.square ||
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
    var minHeight = sideLength;

    if (isSquareOrCircle) {
      // square/circle：固定宽高
      minWidth = sideLength;
    }

    // padding：纵向按 size，横向按内容
    final padH = (isSquareOrCircle && onlyIcon) ? paddingValue : paddingValue;
    final padV = (isSquareOrCircle && onlyIcon)
        ? paddingValue
        : _verticalPadding(size);

    return ButtonStyle(
      minimumSize: WidgetStatePropertyAll<Size>(Size(minWidth ?? 0, minHeight)),
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

  /// 根据 size 获取字号（与 t_button.dart _fontSizeForButton 对齐）
  static double _fontSizeForSize(TButtonSize size) {
    return switch (size) {
      TButtonSize.large => 16,
      TButtonSize.medium => 14,
      TButtonSize.small => 12,
      TButtonSize.extraSmall => 10,
    };
  }

  static Color _disabledBackgroundColor(
    TButtonColorScheme scheme,
    TThemeData tTheme,
  ) {
    return switch (scheme) {
      TButtonColorScheme.primary => tTheme.brandDisabledColor,
      TButtonColorScheme.danger => tTheme.errorDisabledColor,
      TButtonColorScheme.light => tTheme.brandLightColor,
      TButtonColorScheme.defaultTheme => tTheme.bgColorComponentDisabled,
    };
  }

  static Color _pressedBackgroundColor(
    TButtonColorScheme scheme,
    TThemeData tTheme,
  ) {
    return switch (scheme) {
      TButtonColorScheme.primary => tTheme.brandClickColor,
      TButtonColorScheme.danger => tTheme.errorClickColor,
      TButtonColorScheme.light => tTheme.brandFocusColor,
      TButtonColorScheme.defaultTheme => tTheme.bgColorComponentHover,
    };
  }
}

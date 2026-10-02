import 'package:flutter/material.dart';

import '../../theme/t_colors.dart';
import '../../theme/t_font_family.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_radius.dart';
import '../../theme/t_theme.dart';
import 't_button_types.dart';

/// 按钮样式解析器
///
/// 优先级链：
/// Token → ColorScheme → Material ButtonTheme → 实例结构选择 → style。
/// 这是唯一的 [ButtonStyle] merge 入口，build 内禁止内联 variant/colorPreset/shape merge。
class TButtonResolve {
  TButtonResolve._();

  /// 解析最终的 [ButtonStyle]
  ///
  /// [variant] 按钮形态，决定 fill / outline / text / ghost 的基础样式链路。
  /// [colorPreset] 内置配色预设；为 null 时使用默认预设，不是 Material ColorScheme。
  /// [size] 尺寸规格，用于推导最小尺寸、内边距和默认字号。
  /// [icon] 图标内容；与 [hasChild] 一起决定图标尺寸。
  /// [hasChild] 是否存在文本或自定义内容，用于区分纯图标按钮与图文按钮。
  /// [shape] 结构形状选择。
  /// [instanceStyle] P0 实例样式，优先级最高，会覆盖所有 resolve 结果。
  /// [context] 当前构建上下文，用于读取 TDesign 全局 Token。
  /// [hasGradient] 是否启用渐变背景；启用时会清理 Material 默认背景和阴影污染。
  static ButtonStyle resolve({
    /// 按钮形态，决定 fill / outline / text / ghost 的基础样式链路。
    required TButtonVariant variant,

    /// 按钮结构形状。
    required TButtonShape shape,

    /// 语义色方案；为 null 时使用默认色方案，仅选择内置色板。
    required TButtonColorPreset? colorPreset,

    /// 尺寸规格，用于推导最小尺寸、内边距和默认字号。
    required TButtonSize size,

    /// 图标内容；与 `hasChild` 一起决定图标尺寸。
    required Widget? icon,

    /// 是否存在文本或自定义内容，用于区分纯图标按钮与图文按钮。
    required bool hasChild,

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
      colorPreset: colorPreset ?? TButtonColorPreset.defaultTheme,
    );

    // 2. P2 Material：按 TButton 变体读取对应的 Flutter ButtonTheme。
    final materialPalette = _materialPalette(context, variant);

    // 3. Token 默认 shape；实例形状选择决定布局。
    final tokenShapeStyle = _resolveShape(
      effectiveShape: TButtonShape.rectangle,
      tTheme: tTheme,
    );
    final selectedShapeStyle = _resolveShape(
      effectiveShape: shape,
      tTheme: tTheme,
    );

    // 5. 实例 size 选择组件规格尺寸。
    final tapTargetSize =
        materialPalette?.tapTargetSize ?? MaterialTapTargetSize.shrinkWrap;
    final sizeStyle = _resolveSize(
      size: size,
      hasIcon: icon != null,
      hasChild: hasChild,
      effectiveShape: shape,
      tapTargetSize: tapTargetSize,
    );

    // 5.5 textStyle 在各主题层合并完成后解析，保留其 stateful 字体字段，
    // 再以组件 size 规格锁定字号、行高与字重。
    final metrics = sizeMetrics(size, tTheme);

    // 合并：Token shape / ColorScheme → Material → 结构形状。
    var resolved = _overrideWith(tokenShapeStyle, colorStyle);
    if (materialPalette != null) {
      resolved = _overrideWith(resolved, materialPalette);
    }
    if (shape != TButtonShape.rectangle) {
      resolved = _overrideWith(resolved, selectedShapeStyle);
    }
    resolved = _overrideWith(resolved, sizeStyle);
    final themedTextStyle = resolved.textStyle;
    final tokenTextStyle = TextStyle(
      fontSize: metrics.fontSize,
      height: metrics.fontHeight,
      fontWeight: metrics.fontWeight,
      fontFamily: tTheme.fontFamily?.flutterFontFamily,
      fontFamilyFallback: tTheme.fontFamily?.flutterFontFamilyFallback,
    );
    final textStyleStyle = ButtonStyle(
      textStyle: WidgetStateProperty.resolveWith((states) {
        return tokenTextStyle
            .merge(themedTextStyle?.resolve(states))
            .copyWith(
              fontSize: metrics.fontSize,
              height: metrics.fontHeight,
              fontWeight: metrics.fontWeight,
            );
      }),
    );
    resolved = _overrideWith(resolved, textStyleStyle);

    // 渐变存在时强制背景 null（触发 MaterialType.transparency），阻止 M3 默认样式污染渐变效果。
    if (hasGradient) {
      resolved = _overrideWith(
        resolved,
        const ButtonStyle(
          // 设为 null 而非 Colors.transparent，确保 ButtonStyleButton 使用 MaterialType.transparency
          backgroundColor: WidgetStatePropertyAll<Color?>(null),
          surfaceTintColor: WidgetStatePropertyAll<Color>(Colors.transparent),
          shadowColor: WidgetStatePropertyAll<Color>(Colors.transparent),
        ),
      );
    }

    if (instanceStyle != null) {
      resolved = _overrideWith(resolved, instanceStyle);
    }

    // 最终样式未显式配置交互层时，使用最终前景色生成 Flutter 原生 WidgetState 反馈。
    // 只补空缺，不覆盖 Material 或组件 Theme 的显式 overlayColor。
    if (resolved.overlayColor == null) {
      final foreground = resolved.foregroundColor;
      final background = resolved.backgroundColor;
      final hasPressedBackground =
          background?.resolve(const <WidgetState>{WidgetState.pressed}) !=
          background?.resolve(const <WidgetState>{});
      resolved = _overrideWith(
        resolved,
        ButtonStyle(
          overlayColor: _interactionOverlay(
            foreground,
            fallbackColor: tTheme.textColorPrimary,
            includePressed: !hasPressedBackground,
          ),
        ),
      );
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

  /// 根据 variant + colorPreset 生成颜色 ButtonStyle
  static ButtonStyle _resolveColors({
    required BuildContext context,
    required TButtonVariant variant,
    required TButtonColorPreset colorPreset,
  }) {
    final scheme = colorPreset;

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
    TButtonColorPreset scheme,
  ) {
    final tTheme = context.tTheme;
    final colorScheme = Theme.of(context).tExplicitColorScheme;
    Color bg;
    Color fg;

    switch (scheme) {
      case TButtonColorPreset.primary:
        bg = colorScheme?.primary ?? tTheme.brandColor;
        fg = colorScheme?.onPrimary ?? tTheme.textColorAnti;
      case TButtonColorPreset.danger:
        bg = colorScheme?.error ?? tTheme.errorColor;
        fg = colorScheme?.onError ?? tTheme.textColorAnti;
      case TButtonColorPreset.light:
        bg = colorScheme?.primaryContainer ?? tTheme.brandColorLight;
        fg = colorScheme?.onPrimaryContainer ?? tTheme.brandColor;
      case TButtonColorPreset.defaultTheme:
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
              _disabledFillForegroundColor(scheme, tTheme);
        }
        return fg;
      }),
      surfaceTintColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      shadowColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      elevation: const WidgetStatePropertyAll<double>(0),
    );
  }

  /// outline 变体颜色
  static ButtonStyle _resolveOutlineColors(
    BuildContext context,
    TButtonColorPreset scheme,
  ) {
    final tTheme = context.tTheme;
    final colorScheme = Theme.of(context).tExplicitColorScheme;
    late final Color borderColor;
    Color fg;

    switch (scheme) {
      case TButtonColorPreset.primary:
        borderColor = colorScheme?.primary ?? tTheme.brandColor;
        fg = colorScheme?.primary ?? tTheme.brandColor;
      case TButtonColorPreset.danger:
        borderColor = colorScheme?.error ?? tTheme.errorColor;
        fg = colorScheme?.error ?? tTheme.errorColor;
      case TButtonColorPreset.light:
        borderColor = colorScheme?.primary ?? tTheme.brandColor;
        fg = colorScheme?.primary ?? tTheme.brandColor;
      case TButtonColorPreset.defaultTheme:
        borderColor = colorScheme?.outline ?? tTheme.componentBorder;
        fg = colorScheme?.onSurface ?? tTheme.textColorPrimary;
    }

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return scheme == TButtonColorPreset.primary
              ? Colors.transparent
              : colorScheme?.surface ?? tTheme.bgColorContainer;
        }
        if (states.contains(WidgetState.pressed)) {
          return scheme == TButtonColorPreset.light
              ? colorScheme?.primaryContainer ?? tTheme.brandColorLightActive
              : colorScheme?.onSurface.withValues(alpha: 0.08) ??
                    tTheme.bgColorContainerActive;
        }
        return scheme == TButtonColorPreset.light
            ? colorScheme?.primaryContainer ?? tTheme.brandColorLight
            : colorScheme?.surface ?? tTheme.bgColorContainer;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme?.onSurface.withValues(alpha: 0.38) ??
              switch (scheme) {
                TButtonColorPreset.defaultTheme => tTheme.componentBorder,
                TButtonColorPreset.primary ||
                TButtonColorPreset.light => tTheme.brandColorDisabled,
                TButtonColorPreset.danger => tTheme.errorColorDisabled,
              };
        }
        if (states.contains(WidgetState.pressed)) {
          return switch (scheme) {
            TButtonColorPreset.primary || TButtonColorPreset.light =>
              colorScheme?.primary ?? tTheme.brandColorActive,
            TButtonColorPreset.danger =>
              colorScheme?.error ?? tTheme.errorColorActive,
            TButtonColorPreset.defaultTheme => fg,
          };
        }
        return fg;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(
            color:
                colorScheme?.onSurface.withValues(alpha: 0.12) ??
                switch (scheme) {
                  TButtonColorPreset.defaultTheme => tTheme.componentBorder,
                  TButtonColorPreset.primary ||
                  TButtonColorPreset.light => tTheme.brandColorDisabled,
                  TButtonColorPreset.danger => tTheme.errorColorDisabled,
                },
            width: 1,
          );
        }
        if (states.contains(WidgetState.pressed)) {
          return BorderSide(
            color: switch (scheme) {
              TButtonColorPreset.defaultTheme => borderColor,
              TButtonColorPreset.primary || TButtonColorPreset.light =>
                colorScheme?.primary ?? tTheme.brandColorActive,
              TButtonColorPreset.danger =>
                colorScheme?.error ?? tTheme.errorColorActive,
            },
            width: 1,
          );
        }
        return BorderSide(color: borderColor, width: 1);
      }),
      surfaceTintColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      shadowColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      elevation: const WidgetStatePropertyAll<double>(0),
    );
  }

  /// text 变体颜色
  static ButtonStyle _resolveTextColors(
    BuildContext context,
    TButtonColorPreset scheme,
  ) {
    final tTheme = context.tTheme;
    final colorScheme = Theme.of(context).tExplicitColorScheme;
    Color fg;

    switch (scheme) {
      case TButtonColorPreset.primary:
        fg = colorScheme?.primary ?? tTheme.brandColor;
      case TButtonColorPreset.danger:
        fg = colorScheme?.error ?? tTheme.errorColor;
      case TButtonColorPreset.light:
        fg = colorScheme?.primary ?? tTheme.brandColor;
      case TButtonColorPreset.defaultTheme:
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
              _disabledNonFillForegroundColor(scheme, tTheme);
        }
        return fg;
      }),
      surfaceTintColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      shadowColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      elevation: const WidgetStatePropertyAll<double>(0),
    );
  }

  /// ghost 变体颜色
  static ButtonStyle _resolveGhostColors(
    BuildContext context,
    TButtonColorPreset scheme,
  ) {
    final tTheme = context.tTheme;
    final colorScheme = Theme.of(context).tExplicitColorScheme;
    Color fg;

    switch (scheme) {
      case TButtonColorPreset.primary:
        fg = colorScheme?.primary ?? tTheme.brandColor;
      case TButtonColorPreset.danger:
        fg = colorScheme?.error ?? tTheme.errorColor;
      case TButtonColorPreset.light:
        fg = colorScheme?.primary ?? tTheme.brandColor;
      case TButtonColorPreset.defaultTheme:
        fg = colorScheme?.onInverseSurface ?? tTheme.fontWhite1;
    }

    return ButtonStyle(
      backgroundColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme?.onInverseSurface.withValues(alpha: 0.38) ??
              tTheme.fontWhite4;
        }
        return fg;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        final color = states.contains(WidgetState.disabled)
            ? colorScheme?.onInverseSurface.withValues(alpha: 0.38) ??
                  tTheme.fontWhite4
            : fg;
        return BorderSide(color: color, width: 1);
      }),
      surfaceTintColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      shadowColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      elevation: const WidgetStatePropertyAll<double>(0),
    );
  }

  /// 将内部 shape 枚举展开为 [ButtonStyle.shape]
  static ButtonStyle _resolveShape({
    required TButtonShape effectiveShape,
    required TThemeData tTheme,
  }) {
    final shape = switch (effectiveShape) {
      TButtonShape.rectangle => RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(tTheme.radiusDefault)),
      ),
      TButtonShape.square => RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(tTheme.radiusDefault)),
      ),
      TButtonShape.round => RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(tTheme.radiusRound)),
      ),
      TButtonShape.circle => const CircleBorder(),
    };
    return ButtonStyle(shape: WidgetStatePropertyAll<OutlinedBorder>(shape));
  }

  /// 根据 size + shape 推导 minimumSize 和 padding
  static ButtonStyle _resolveSize({
    required TButtonSize size,
    required bool hasIcon,
    required bool hasChild,
    required TButtonShape effectiveShape,
    required MaterialTapTargetSize tapTargetSize,
  }) {
    final isSquareOrCircle =
        effectiveShape == TButtonShape.square ||
        effectiveShape == TButtonShape.circle;
    // square/circle 纯 icon 按钮：等宽高 + 等边 padding
    final onlyIcon = hasIcon && !hasChild;

    final metrics = sizeMetrics(size, null);
    final paddingValue = onlyIcon
        ? metrics.iconOnlyPadding
        : metrics.horizontalPadding;

    final minHeight = metrics.height;
    final fixedIconShape = isSquareOrCircle && onlyIcon;

    // padding：纵向按 size，横向按内容
    final padV = fixedIconShape ? paddingValue : metrics.verticalPadding;

    return ButtonStyle(
      minimumSize: WidgetStatePropertyAll<Size>(
        Size(fixedIconShape ? metrics.height : 0, minHeight),
      ),
      tapTargetSize: tapTargetSize,
      padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(horizontal: paddingValue, vertical: padV),
      ),
      iconSize: WidgetStatePropertyAll<double>(metrics.iconSize),
    );
  }

  /// 返回普通与渐变按钮共用的 TDesign 尺寸规格。
  static TButtonSizeMetrics sizeMetrics(TButtonSize size, TThemeData? theme) {
    final font = switch (size) {
      TButtonSize.large || TButtonSize.medium => theme?.fontMarkLarge,
      TButtonSize.small || TButtonSize.extraSmall => theme?.fontMarkMedium,
    };
    return switch (size) {
      TButtonSize.large => TButtonSizeMetrics(
        height: 48,
        horizontalPadding: 20,
        verticalPadding: 12,
        iconOnlyPadding: 12,
        iconSize: 24,
        fontSize: font?.size ?? 16,
        fontHeight: font?.height ?? 1.5,
        fontWeight: font?.fontWeight ?? FontWeight.w600,
      ),
      TButtonSize.medium => TButtonSizeMetrics(
        height: 40,
        horizontalPadding: 16,
        verticalPadding: 8,
        iconOnlyPadding: 10,
        iconSize: 20,
        fontSize: font?.size ?? 16,
        fontHeight: font?.height ?? 1.5,
        fontWeight: font?.fontWeight ?? FontWeight.w600,
      ),
      TButtonSize.small => TButtonSizeMetrics(
        height: 32,
        horizontalPadding: 12,
        verticalPadding: 5,
        iconOnlyPadding: 7,
        iconSize: 18,
        fontSize: font?.size ?? 14,
        fontHeight: font?.height ?? 22 / 14,
        fontWeight: font?.fontWeight ?? FontWeight.w600,
      ),
      TButtonSize.extraSmall => TButtonSizeMetrics(
        height: 28,
        horizontalPadding: 8,
        verticalPadding: 3,
        iconOnlyPadding: 5,
        iconSize: 18,
        fontSize: font?.size ?? 14,
        fontHeight: font?.height ?? 22 / 14,
        fontWeight: font?.fontWeight ?? FontWeight.w600,
      ),
    };
  }

  static Color _disabledBackgroundColor(
    TButtonColorPreset scheme,
    TThemeData tTheme,
  ) {
    return switch (scheme) {
      TButtonColorPreset.primary => tTheme.brandColorDisabled,
      TButtonColorPreset.danger => tTheme.errorColorDisabled,
      TButtonColorPreset.light => tTheme.brandColorLight,
      TButtonColorPreset.defaultTheme => tTheme.bgColorComponentDisabled,
    };
  }

  static Color _disabledFillForegroundColor(
    TButtonColorPreset scheme,
    TThemeData tTheme,
  ) {
    return switch (scheme) {
      TButtonColorPreset.primary => tTheme.textColorAnti,
      TButtonColorPreset.light => tTheme.brandColorDisabled,
      TButtonColorPreset.danger ||
      TButtonColorPreset.defaultTheme => tTheme.textColorDisabled,
    };
  }

  static Color _disabledNonFillForegroundColor(
    TButtonColorPreset scheme,
    TThemeData tTheme,
  ) {
    return switch (scheme) {
      TButtonColorPreset.primary ||
      TButtonColorPreset.light => tTheme.brandColorDisabled,
      TButtonColorPreset.danger ||
      TButtonColorPreset.defaultTheme => tTheme.textColorDisabled,
    };
  }

  static Color _pressedBackgroundColor(
    TButtonColorPreset scheme,
    TThemeData tTheme,
  ) {
    return switch (scheme) {
      TButtonColorPreset.primary => tTheme.brandColorActive,
      TButtonColorPreset.danger => tTheme.errorColorActive,
      TButtonColorPreset.light => tTheme.brandColorFocus,
      TButtonColorPreset.defaultTheme => tTheme.bgColorComponent,
    };
  }

  /// 默认 Flutter 交互状态层。
  ///
  /// 按压/聚焦使用 12% 前景色，悬浮使用 8%；禁用和静止状态不绘制。
  static WidgetStateProperty<Color> _interactionOverlay(
    WidgetStateProperty<Color?>? foreground, {
    required Color fallbackColor,
    required bool includePressed,
  }) {
    return WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return Colors.transparent;
      }
      final color = foreground?.resolve(states) ?? fallbackColor;
      if (states.contains(WidgetState.pressed)) {
        return includePressed
            ? color.withValues(alpha: 0.12)
            : Colors.transparent;
      }
      if (states.contains(WidgetState.focused)) {
        return color.withValues(alpha: 0.12);
      }
      if (states.contains(WidgetState.hovered)) {
        return color.withValues(alpha: 0.08);
      }
      return Colors.transparent;
    });
  }
}

/// Button 内部尺寸规格，不从包入口导出。
class TButtonSizeMetrics {
  const TButtonSizeMetrics({
    required this.height,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.iconOnlyPadding,
    required this.iconSize,
    required this.fontSize,
    required this.fontHeight,
    required this.fontWeight,
  });

  final double height;
  final double horizontalPadding;
  final double verticalPadding;
  final double iconOnlyPadding;
  final double iconSize;
  final double fontSize;
  final double fontHeight;
  final FontWeight fontWeight;
}

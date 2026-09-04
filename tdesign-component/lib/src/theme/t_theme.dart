import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../util/log.dart';
import '../util/string_util.dart';
import 'basic.dart';
import 'resource_delegate.dart';
import 't_colors.dart';
import 't_component_theme_data.dart';
import 't_default_theme.dart';
import 't_fonts.dart';

bool _tTextThemeEquivalent(TextTheme left, TextTheme right) {
  TextStyle? normalize(TextStyle? style) =>
      style?.copyWith(debugLabel: 'normalized');

  return normalize(left.displayLarge) == normalize(right.displayLarge) &&
      normalize(left.displayMedium) == normalize(right.displayMedium) &&
      normalize(left.displaySmall) == normalize(right.displaySmall) &&
      normalize(left.headlineLarge) == normalize(right.headlineLarge) &&
      normalize(left.headlineMedium) == normalize(right.headlineMedium) &&
      normalize(left.headlineSmall) == normalize(right.headlineSmall) &&
      normalize(left.titleLarge) == normalize(right.titleLarge) &&
      normalize(left.titleMedium) == normalize(right.titleMedium) &&
      normalize(left.titleSmall) == normalize(right.titleSmall) &&
      normalize(left.bodyLarge) == normalize(right.bodyLarge) &&
      normalize(left.bodyMedium) == normalize(right.bodyMedium) &&
      normalize(left.bodySmall) == normalize(right.bodySmall) &&
      normalize(left.labelLarge) == normalize(right.labelLarge) &&
      normalize(left.labelMedium) == normalize(right.labelMedium) &&
      normalize(left.labelSmall) == normalize(right.labelSmall);
}

bool _tTextStyleTypographyEquivalent(TextStyle? left, TextStyle? right) {
  if (left == null || right == null) {
    return left == right;
  }
  const lists = ListEquality<Object?>();
  return left.inherit == right.inherit &&
      left.fontFamily == right.fontFamily &&
      lists.equals(left.fontFamilyFallback, right.fontFamilyFallback) &&
      left.fontSize == right.fontSize &&
      left.fontWeight == right.fontWeight &&
      left.fontStyle == right.fontStyle &&
      left.letterSpacing == right.letterSpacing &&
      left.wordSpacing == right.wordSpacing &&
      left.textBaseline == right.textBaseline &&
      left.height == right.height &&
      left.leadingDistribution == right.leadingDistribution &&
      left.locale == right.locale &&
      lists.equals(left.fontFeatures, right.fontFeatures) &&
      lists.equals(left.fontVariations, right.fontVariations) &&
      left.decoration == right.decoration &&
      left.decorationStyle == right.decorationStyle &&
      left.decorationThickness == right.decorationThickness;
}

bool _tTextThemeTypographyEquivalent(TextTheme left, TextTheme right) {
  return _tTextStyleTypographyEquivalent(
        left.displayLarge,
        right.displayLarge,
      ) &&
      _tTextStyleTypographyEquivalent(
        left.displayMedium,
        right.displayMedium,
      ) &&
      _tTextStyleTypographyEquivalent(left.displaySmall, right.displaySmall) &&
      _tTextStyleTypographyEquivalent(
        left.headlineLarge,
        right.headlineLarge,
      ) &&
      _tTextStyleTypographyEquivalent(
        left.headlineMedium,
        right.headlineMedium,
      ) &&
      _tTextStyleTypographyEquivalent(
        left.headlineSmall,
        right.headlineSmall,
      ) &&
      _tTextStyleTypographyEquivalent(left.titleLarge, right.titleLarge) &&
      _tTextStyleTypographyEquivalent(left.titleMedium, right.titleMedium) &&
      _tTextStyleTypographyEquivalent(left.titleSmall, right.titleSmall) &&
      _tTextStyleTypographyEquivalent(left.bodyLarge, right.bodyLarge) &&
      _tTextStyleTypographyEquivalent(left.bodyMedium, right.bodyMedium) &&
      _tTextStyleTypographyEquivalent(left.bodySmall, right.bodySmall) &&
      _tTextStyleTypographyEquivalent(left.labelLarge, right.labelLarge) &&
      _tTextStyleTypographyEquivalent(left.labelMedium, right.labelMedium) &&
      _tTextStyleTypographyEquivalent(left.labelSmall, right.labelSmall);
}

// ============================================================
// L2: 全局 theme.of 基础设施
// ============================================================

/// BuildContext 扩展：便捷获取全局 TThemeData Token
///
/// 统一走 Material 的 `Theme.of(context)`。
/// 全库读取全局 Token（色板/间距/圆角/字体）统一用 `context.tTheme`。
extension TThemeContextExtension on BuildContext {
  /// 获取全局 TThemeData（P4 Token），取不到则回退默认值
  TThemeData get tTheme =>
      Theme.of(this).extension<TThemeData>() ?? TThemeData.defaultData();

  /// 返回显式子树 [DefaultTextStyle]，过滤 ThemeData 自动注入的文本样式。
  TextStyle? get tExplicitDefaultTextStyle {
    final material = Theme.of(this);
    final inherited = DefaultTextStyle.of(this).style;
    if (material.tExplicitTextTheme != null) {
      return inherited;
    }
    final implicitStyles = <TextStyle?>[
      material.textTheme.displayLarge,
      material.textTheme.displayMedium,
      material.textTheme.displaySmall,
      material.textTheme.headlineLarge,
      material.textTheme.headlineMedium,
      material.textTheme.headlineSmall,
      material.textTheme.titleLarge,
      material.textTheme.titleMedium,
      material.textTheme.titleSmall,
      material.textTheme.bodyLarge,
      material.textTheme.bodyMedium,
      material.textTheme.bodySmall,
      material.textTheme.labelLarge,
      material.textTheme.labelMedium,
      material.textTheme.labelSmall,
    ];
    return implicitStyles.contains(inherited) ? null : inherited;
  }

  /// 返回显式子树或 ThemeData IconTheme，过滤 Flutter 自动默认值。
  IconThemeData? get tExplicitIconTheme {
    final material = Theme.of(this);
    final inherited = IconTheme.of(this);
    final explicitRoot = material.tExplicitIconTheme;
    if (explicitRoot != null) {
      return inherited;
    }
    return inherited == material.iconTheme ||
            inherited ==
                const IconThemeData.fallback().merge(material.iconTheme) ||
            inherited == const IconThemeData.fallback()
        ? null
        : inherited;
  }
}

/// ThemeData 扩展：子树 merge Extension（禁用 copyWith(extensions:) 覆盖）
///
/// 子树覆盖统一用 `mergeExtension(...)`，
/// 禁止 `copyWith(extensions: [...])`（会覆盖其它 Extension）。
extension TThemeDataMergeExtension on ThemeData {
  /// 合并 Extension：保留现有所有 Extension，仅替换指定类型
  ///
  /// 示例：
  /// ```dart
  /// Theme(
  ///   data: Theme.of(context).mergeExtension(
  ///     TButtonThemeData(defaultVariant: TButtonVariant.outline),
  ///   ),
  ///   child: TButton(onPressed: () {}, child: Text('描边区')),
  /// )
  /// ```
  ThemeData mergeExtension<T extends ThemeExtension<T>>(T extension) {
    final merged = Map<Type, ThemeExtension<dynamic>>.from(extensions);
    merged[T] = extension;
    return copyWith(extensions: merged.values.toList());
  }
}

/// 返回调用方显式定制的 [ColorScheme]。
///
/// Flutter 会在没有任何配置时也生成一套 Material 默认色板。组件不能把
/// 这套隐式默认值当成 P3 配置，否则仅仅升级到 Material 3 就会改变
/// TDesign 的默认视觉。[TThemeBuilder] 的 Token 投影同样视为默认来源。
/// 未检测到显式色板时返回 null，由组件继续回退 Token。
extension TExplicitColorSchemeExtension on ThemeData {
  bool get tUsesTokenColorScheme {
    final projection = extension<_TMaterialProjectionThemeData>();
    return projection != null && colorScheme == projection.colorScheme;
  }

  ColorScheme? get tExplicitColorScheme {
    if (tUsesTokenColorScheme) {
      return null;
    }
    final materialDefault = ThemeData(
      brightness: brightness,
      useMaterial3: useMaterial3,
    ).colorScheme;
    final hasExplicitSemanticColor =
        colorScheme.primary != materialDefault.primary ||
        colorScheme.onPrimary != materialDefault.onPrimary ||
        colorScheme.surface != materialDefault.surface ||
        colorScheme.onSurface != materialDefault.onSurface ||
        colorScheme.error != materialDefault.error ||
        colorScheme.outline != materialDefault.outline;
    return hasExplicitSemanticColor ? colorScheme : null;
  }
}

/// 只暴露调用方显式配置的 Material 默认字段。
///
/// [ThemeData] 会根据 Material 版本和 ColorScheme 自动补全 TextTheme、
/// IconTheme、disabledColor 等值。TDesign 组件不能把这些自动值放在 Token
/// 之前；只有与同配置下的 Flutter 默认主题不同，且不是 [TThemeBuilder]
/// 的 Token 投影时，才视为显式 Material 配置。
extension TExplicitMaterialThemeExtension on ThemeData {
  ThemeData get _tImplicitMaterialDefaults => ThemeData(
    brightness: brightness,
    colorScheme: colorScheme,
    useMaterial3: useMaterial3,
  );

  TextTheme? get tExplicitTextTheme {
    final projection = extension<_TMaterialProjectionThemeData>();
    if (projection != null &&
        _tTextThemeEquivalent(
          textTheme,
          _tLocalizedTextTheme(projection.textTheme),
        )) {
      return null;
    }
    return _tTextThemeTypographyEquivalent(
          textTheme,
          _tLocalizedTextTheme(
            ThemeData(
              brightness: brightness,
              useMaterial3: useMaterial3,
            ).textTheme,
          ),
        )
        ? null
        : textTheme;
  }

  TextTheme _tLocalizedTextTheme(TextTheme base) {
    final typography = useMaterial3
        ? Typography.material2021(platform: platform)
        : Typography.material2014(platform: platform);
    return typography.englishLike.merge(base);
  }

  IconThemeData? get tExplicitIconTheme {
    final projection = extension<_TMaterialProjectionThemeData>();
    if (projection != null && iconTheme == projection.iconTheme) {
      return null;
    }
    if (iconTheme == const IconThemeData() ||
        iconTheme == const IconThemeData.fallback()) {
      return null;
    }
    return iconTheme == _tImplicitMaterialDefaults.iconTheme ? null : iconTheme;
  }

  Color? get tExplicitDisabledColor {
    final defaults = _tImplicitMaterialDefaults;
    return disabledColor == defaults.disabledColor ? null : disabledColor;
  }

  Color? get tExplicitDividerColor {
    final projection = extension<_TMaterialProjectionThemeData>();
    if (projection != null && dividerTheme == projection.dividerTheme) {
      return null;
    }
    final defaults = _tImplicitMaterialDefaults;
    if (dividerTheme.color != null &&
        dividerTheme.color != defaults.dividerTheme.color) {
      return dividerTheme.color;
    }
    return dividerColor == defaults.dividerColor ? null : dividerColor;
  }

  VisualDensity? get tExplicitVisualDensity {
    final defaults = _tImplicitMaterialDefaults;
    return visualDensity == defaults.visualDensity ? null : visualDensity;
  }

  MaterialTapTargetSize? get tExplicitMaterialTapTargetSize {
    final defaults = _tImplicitMaterialDefaults;
    return materialTapTargetSize == defaults.materialTapTargetSize
        ? null
        : materialTapTargetSize;
  }
}

/// 识别 [TMaterialThemeBuilder] 自动投影的 Material ButtonStyle。
///
/// 自动投影用于让原生 Material Button 继承 TDesign Token，但对 TButton
/// 来说它仍属于 Token 默认值，不能反过来覆盖组件既有视觉。这里记录样式
/// 来源而不是比较具体颜色，确保调用方 copyWith 后的显式定制仍可被识别。
extension TMaterialProjectionExtension on ThemeData {
  bool tIsTokenProjectedButtonStyle(ButtonStyle? style) {
    final projection = extension<_TMaterialProjectionThemeData>();
    return style != null &&
        projection != null &&
        (style == projection.elevatedButtonStyle ||
            style == projection.outlinedButtonStyle ||
            style == projection.textButtonStyle);
  }

  /// 返回调用方显式配置的 [BadgeThemeData]。
  ///
  /// [TThemeBuilder] 会为原生 Material [Badge] 投影一份 TDesign 默认主题，
  /// 但该投影不能覆盖 `TBadge` 自己的尺寸 Token。这里按来源对象识别投影，
  /// 避免用字体、内边距等数值相等关系猜测调用方是否显式配置。
  BadgeThemeData? get tExplicitBadgeTheme {
    final projection = extension<_TMaterialProjectionThemeData>();
    return projection != null && identical(badgeTheme, projection.badgeTheme)
        ? null
        : badgeTheme;
  }
}

class _TMaterialProjectionThemeData
    extends ThemeExtension<_TMaterialProjectionThemeData> {
  const _TMaterialProjectionThemeData({
    required this.colorScheme,
    required this.textTheme,
    required this.iconTheme,
    required this.dividerTheme,
    required this.badgeTheme,
    required this.elevatedButtonStyle,
    required this.outlinedButtonStyle,
    required this.textButtonStyle,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final IconThemeData iconTheme;
  final DividerThemeData dividerTheme;
  final BadgeThemeData badgeTheme;
  final ButtonStyle elevatedButtonStyle;
  final ButtonStyle outlinedButtonStyle;
  final ButtonStyle textButtonStyle;

  @override
  _TMaterialProjectionThemeData copyWith({
    ColorScheme? colorScheme,
    TextTheme? textTheme,
    IconThemeData? iconTheme,
    DividerThemeData? dividerTheme,
    BadgeThemeData? badgeTheme,
    ButtonStyle? elevatedButtonStyle,
    ButtonStyle? outlinedButtonStyle,
    ButtonStyle? textButtonStyle,
  }) {
    return _TMaterialProjectionThemeData(
      colorScheme: colorScheme ?? this.colorScheme,
      textTheme: textTheme ?? this.textTheme,
      iconTheme: iconTheme ?? this.iconTheme,
      dividerTheme: dividerTheme ?? this.dividerTheme,
      badgeTheme: badgeTheme ?? this.badgeTheme,
      elevatedButtonStyle: elevatedButtonStyle ?? this.elevatedButtonStyle,
      outlinedButtonStyle: outlinedButtonStyle ?? this.outlinedButtonStyle,
      textButtonStyle: textButtonStyle ?? this.textButtonStyle,
    );
  }

  @override
  _TMaterialProjectionThemeData lerp(
    covariant _TMaterialProjectionThemeData? other,
    double t,
  ) {
    if (other == null) {
      return this;
    }
    return _TMaterialProjectionThemeData(
      colorScheme: ColorScheme.lerp(colorScheme, other.colorScheme, t),
      textTheme: TextTheme.lerp(textTheme, other.textTheme, t),
      iconTheme: IconThemeData.lerp(iconTheme, other.iconTheme, t),
      dividerTheme: DividerThemeData.lerp(dividerTheme, other.dividerTheme, t),
      badgeTheme: BadgeThemeData.lerp(badgeTheme, other.badgeTheme, t),
      elevatedButtonStyle: ButtonStyle.lerp(
        elevatedButtonStyle,
        other.elevatedButtonStyle,
        t,
      )!,
      outlinedButtonStyle: ButtonStyle.lerp(
        outlinedButtonStyle,
        other.outlinedButtonStyle,
        t,
      )!,
      textButtonStyle: ButtonStyle.lerp(
        textButtonStyle,
        other.textButtonStyle,
        t,
      )!,
    );
  }
}

/// P0–P4 统一样式解析器
///
/// 优先级（覆盖方向，强 → 弱）：
/// **P0 实例 > P1 组件 Theme > P2 Material > P3 ColorScheme > P4 Token**
///
/// 用法：
/// ```dart
/// final resolver = TStyleResolver.of(context);
/// final token = resolver.token;              // P4
/// final buttonTheme = resolver.componentExtension<TButtonThemeData>(); // P1
/// final colorScheme = resolver.colorScheme;  // P3
/// ```
class TStyleResolver {
  TStyleResolver._(this._context);

  final BuildContext _context;

  /// 创建解析器实例
  static TStyleResolver of(BuildContext context) => TStyleResolver._(context);

  /// P4: 全局设计 Token（色板 / 间距原始值）
  TThemeData get token =>
      Theme.of(_context).extension<TThemeData>() ?? TThemeData.defaultData();

  /// P3: Material ColorScheme
  ColorScheme get colorScheme => Theme.of(_context).colorScheme;

  /// P3: Material TextTheme
  TextTheme get textTheme => Theme.of(_context).textTheme;

  /// P2: Material ThemeData（子主题）
  ThemeData get materialTheme => Theme.of(_context);

  /// P1: 组件 ThemeExtension
  E? componentExtension<E extends ThemeExtension<E>>() =>
      Theme.of(_context).extension<E>();
}

/// Token → 完整 ThemeData 的构建器
///
/// 四层架构的 L2 层：接收 [TThemeData] token，产出完整 [ThemeData]。
/// 内部完成 Token → ColorScheme 映射、Token Font → TextTheme、
/// Token 颜色 → M3 子主题，同时将 [TThemeData] 自身作为 Extension 注入。
///
/// 通常不直接使用，通过 [TThemeBuilder.light] / [TThemeBuilder.dark] 入口。
class TMaterialThemeBuilder {
  const TMaterialThemeBuilder(this.token);

  /// Token 数据源
  final TThemeData token;

  /// 构建亮色 ThemeData
  ThemeData buildLight() {
    final light = token.light;
    return _buildBase(
      extensionData: light,
      colorScheme: _lightColorScheme(light),
      brightness: Brightness.light,
    );
  }

  /// 构建暗色 ThemeData
  ThemeData buildDark() {
    final dark = token.dark ?? token;
    return _buildBase(
      extensionData: dark,
      colorScheme: _darkColorScheme(dark),
      brightness: Brightness.dark,
    );
  }

  /// 构建基础 ThemeData（亮/暗共用）
  ThemeData _buildBase({
    required TThemeData extensionData,
    required ColorScheme colorScheme,
    required Brightness brightness,
  }) {
    final textTheme = _textTheme(extensionData).apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );
    final iconTheme = IconThemeData(color: extensionData.textColorPrimary);
    final dividerTheme = DividerThemeData(
      color: extensionData.componentStrokeColor,
      thickness: 0.5,
    );
    final buttonStyle = _materialButtonStyle(extensionData, colorScheme);
    final outlinedButtonStyle = buttonStyle.copyWith(
      backgroundColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      foregroundColor: WidgetStatePropertyAll<Color>(colorScheme.primary),
      side: WidgetStatePropertyAll<BorderSide>(
        BorderSide(color: colorScheme.primary),
      ),
    );
    final textButtonStyle = buttonStyle.copyWith(
      backgroundColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      foregroundColor: WidgetStatePropertyAll<Color>(colorScheme.primary),
      side: const WidgetStatePropertyAll<BorderSide>(BorderSide.none),
    );
    final base = ThemeData(
      extensions: [..._themeExtensions(extensionData)],
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      iconTheme: iconTheme,
      textTheme: textTheme,
      dividerTheme: dividerTheme,
      badgeTheme: BadgeThemeData(
        backgroundColor: extensionData.errorNormalColor,
        textColor: extensionData.textColorAnti,
        textStyle: _textStyle(
          extensionData.fontMarkExtraSmall,
        )?.copyWith(color: extensionData.textColorAnti),
        largeSize: 16,
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),
      filledButtonTheme: FilledButtonThemeData(style: buttonStyle),
      elevatedButtonTheme: ElevatedButtonThemeData(style: buttonStyle),
      outlinedButtonTheme: OutlinedButtonThemeData(style: outlinedButtonStyle),
      textButtonTheme: TextButtonThemeData(style: textButtonStyle),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        fillColor: Colors.transparent,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: extensionData.textColorPlaceholder,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: extensionData.componentBorderColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: extensionData.componentStrokeColor),
        ),
      ),
      useMaterial3: true,
    );
    return base.copyWith(
      extensions: [
        ...base.extensions.values,
        _TMaterialProjectionThemeData(
          colorScheme: base.colorScheme,
          textTheme: base.textTheme,
          iconTheme: base.iconTheme,
          dividerTheme: base.dividerTheme,
          badgeTheme: base.badgeTheme,
          elevatedButtonStyle: base.elevatedButtonTheme.style!,
          outlinedButtonStyle: base.outlinedButtonTheme.style!,
          textButtonStyle: base.textButtonTheme.style!,
        ),
      ],
    );
  }

  List<ThemeExtension<dynamic>> _themeExtensions(TThemeData token) {
    return <ThemeExtension<dynamic>>[
      token,
      const TButtonThemeData(),
      _textExtension(token),
      _iconTheme(token),
      _dividerTheme(token),
      _linkTheme(token),
      const TFabThemeData(),
      const TAvatarThemeData(),
      const TBackTopThemeData(),
      const TBadgeThemeData(),
      const TCalendarThemeData(),
      const TCascaderThemeData(),
      const TCellThemeData(),
      const TCheckboxThemeData(),
      const TCollapseThemeData(),
      const TDrawerThemeData(),
      const TEmptyThemeData(),
      const TFooterThemeData(),
      const TFormThemeData(),
      const TImageThemeData(),
      const TImageViewerThemeData(),
      const TIndexesThemeData(),
      const TInputThemeData(),
      const TLoadingThemeData(),
      const TMessageThemeData(),
      const TNavBarThemeData(),
      const TNoticeBarThemeData(),
      const TPickerThemeData(),
      const TPopoverThemeData(),
      const TPopupThemeData(),
      const TProgressThemeData(),
      const TRadioThemeData(),
      const TRateThemeData(),
      const TResultThemeData(),
      const TSearchBarThemeData(),
      const TSideBarThemeData(),
      const TSliderThemeData(),
      const TStepperThemeData(),
      const TStepsThemeData(),
      const TSwipeCellThemeData(),
      const TSwiperThemeData(),
      const TSwitchThemeData(),
      const TTabBarThemeData(),
      const TTableThemeData(),
      const TTabsBarThemeData(),
      const TTagThemeData(),
      const TTimeCounterThemeData(),
      const TToastThemeData(),
      const TTreeSelectThemeData(),
      const TUploadThemeData(),
    ];
  }

  TextTheme _textTheme(TThemeData token) {
    return TextTheme(
      displayLarge: _textStyle(token.fontDisplayLarge),
      displayMedium: _textStyle(token.fontDisplayMedium),
      headlineLarge: _textStyle(token.fontHeadlineLarge),
      headlineMedium: _textStyle(token.fontHeadlineMedium),
      headlineSmall: _textStyle(token.fontHeadlineSmall),
      titleLarge: _textStyle(token.fontTitleLarge),
      titleMedium: _textStyle(token.fontTitleMedium),
      titleSmall: _textStyle(token.fontTitleSmall),
      bodyLarge: _textStyle(token.fontBodyLarge),
      bodyMedium: _textStyle(token.fontBodyMedium),
      bodySmall: _textStyle(token.fontBodySmall),
      labelLarge: _textStyle(token.fontLinkLarge),
      labelMedium: _textStyle(token.fontLinkMedium),
      labelSmall: _textStyle(token.fontLinkSmall),
    );
  }

  TextStyle? _textStyle(Font? font) {
    if (font == null) {
      return null;
    }
    return TextStyle(
      fontSize: font.size,
      height: font.height,
      fontWeight: font.fontWeight,
    );
  }

  ButtonStyle _materialButtonStyle(TThemeData token, ColorScheme colorScheme) {
    return _buttonStyle(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      disabledBackgroundColor: token.bgColorComponentDisabled,
      disabledForegroundColor: token.textDisabledColor,
      textStyle: _textStyle(token.fontLinkMedium),
    );
  }

  ButtonStyle _buttonStyle({
    required Color backgroundColor,
    required Color foregroundColor,
    required Color disabledBackgroundColor,
    required Color disabledForegroundColor,
    Color? sideColor,
    Color? disabledSideColor,
    TextStyle? textStyle,
  }) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledBackgroundColor;
        }
        return backgroundColor;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledForegroundColor;
        }
        return foregroundColor;
      }),
      side: sideColor == null
          ? null
          : WidgetStateProperty.resolveWith((states) {
              final color = states.contains(WidgetState.disabled)
                  ? (disabledSideColor ?? sideColor)
                  : sideColor;
              return BorderSide(color: color);
            }),
      textStyle: textStyle == null
          ? null
          : WidgetStatePropertyAll<TextStyle>(textStyle),
      overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      surfaceTintColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      shadowColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      elevation: const WidgetStatePropertyAll<double>(0),
    );
  }

  TTextThemeData _textExtension(TThemeData _) {
    // Token defaults are exposed through Material TextTheme and TText's final
    // fallback. Keeping this extension empty lets local DefaultTextStyle work.
    return const TTextThemeData();
  }

  TIconThemeData _iconTheme(TThemeData _) {
    return const TIconThemeData();
  }

  TDividerThemeData _dividerTheme(TThemeData _) {
    return const TDividerThemeData();
  }

  TLinkThemeData _linkTheme(TThemeData _) {
    return const TLinkThemeData();
  }

  /// 亮色 ColorScheme 映射（Token → ColorScheme）
  ColorScheme _lightColorScheme(TThemeData t) {
    return ColorScheme.light(
      // 品牌主色
      primary: t.brandNormalColor,
      onPrimary: t.textColorAnti,
      primaryContainer: t.brandLightColor,
      onPrimaryContainer: t.brandNormalColor,
      // 次级
      secondary: t.brandHoverColor,
      onSecondary: t.textColorAnti,
      secondaryContainer: t.bgColorSecondaryContainer,
      onSecondaryContainer: t.textColorPrimary,
      // 警告色
      tertiary: t.warningNormalColor,
      onTertiary: t.textColorAnti,
      tertiaryContainer: t.warningLightColor,
      onTertiaryContainer: t.warningNormalColor,
      // 错误色
      error: t.errorNormalColor,
      onError: t.textColorAnti,
      errorContainer: t.errorLightColor,
      onErrorContainer: t.errorNormalColor,
      // 背景与表面
      surface: t.bgColorContainer,
      onSurface: t.textColorPrimary,
      surfaceContainerHighest: t.bgColorComponent,
      onSurfaceVariant: t.textColorSecondary,
      // 描边
      outline: t.componentBorderColor,
      outlineVariant: t.componentStrokeColor,
      // 反色
      inverseSurface: t.grayColor13,
      onInverseSurface: t.fontWhColor1,
      inversePrimary: t.brandColor3,
      // 基础
      shadow: Colors.black,
      scrim: Colors.black,
    );
  }

  /// 暗色 ColorScheme 映射（Token → ColorScheme）
  ColorScheme _darkColorScheme(TThemeData t) {
    return ColorScheme.dark(
      // 品牌主色
      primary: t.brandNormalColor,
      onPrimary: t.textColorAnti,
      primaryContainer: t.brandLightColor,
      onPrimaryContainer: t.brandNormalColor,
      // 次级
      secondary: t.brandHoverColor,
      onSecondary: t.textColorAnti,
      secondaryContainer: t.bgColorSecondaryContainer,
      onSecondaryContainer: t.textColorPrimary,
      // 警告色
      tertiary: t.warningNormalColor,
      onTertiary: t.textColorAnti,
      tertiaryContainer: t.warningLightColor,
      onTertiaryContainer: t.warningNormalColor,
      // 错误色
      error: t.errorNormalColor,
      onError: t.textColorAnti,
      errorContainer: t.errorLightColor,
      onErrorContainer: t.errorNormalColor,
      // 背景与表面
      surface: t.bgColorContainer,
      onSurface: t.textColorPrimary,
      surfaceContainerHighest: t.bgColorComponent,
      onSurfaceVariant: t.textColorSecondary,
      // 描边
      outline: t.componentBorderColor,
      outlineVariant: t.componentStrokeColor,
      // 反色
      inverseSurface: t.grayColor13,
      onInverseSurface: t.fontWhColor1,
      inversePrimary: t.brandColor3,
      // 基础
      shadow: Colors.black,
      scrim: Colors.black,
    );
  }
}

/// 应用入口：Token → 完整 ThemeData
///
/// 对齐 `MaterialApp.theme` / `darkTheme` / `themeMode` 三参数模式。
///
/// 用法：
/// ```dart
/// MaterialApp(
///   theme: TThemeBuilder.light(token),
///   darkTheme: TThemeBuilder.dark(token),
///   themeMode: ThemeMode.system,
/// )
/// ```
class TThemeBuilder {
  const TThemeBuilder._();

  /// 亮色主题
  static ThemeData light(TThemeData token) =>
      TMaterialThemeBuilder(token).buildLight();

  /// 暗色主题
  static ThemeData dark(TThemeData token) =>
      TMaterialThemeBuilder(token).buildDark();
}

/// 设置全局资源代理。
///
/// [needAlwaysBuild]=true: 每次都会走 build 方法；如果全局有多个 Delegate，
/// 需要区分情况去获取，则可以设置 needAlwaysBuild 为 true，业务自己判断返回哪个 delegate。
/// [needAlwaysBuild]=false: 返回 delegate 为 null，则每次都会走 build 方法。
void setTResourceBuilder(
  TResourceBuilder delegate, {
  bool needAlwaysBuild = false,
}) {
  TResourceManager.instance.setResourceBuilder(delegate, needAlwaysBuild);
}

// ============================================================
// L1: TThemeData（JSON Token）—— 保持不变
// ============================================================

/// 主题数据
class TThemeData extends ThemeExtension<TThemeData> {
  static const String _defaultThemeName = 'default';
  static const String _defaultDartThemeName = 'defaultDark';
  static TThemeData? _defaultThemeData;

  /// 暗色主题
  TThemeData? dark;

  /// 亮色主题
  late TThemeData light;

  /// 名称
  late String name;

  /// 颜色
  late TMap<String, Color> colorMap;

  /// 字体尺寸
  late TMap<String, Font> fontMap;

  /// 圆角
  late TMap<String, double> radiusMap;

  /// 字体样式
  late TMap<String, FontFamily> fontFamilyMap;

  /// 阴影
  late TMap<String, List<BoxShadow>> shadowMap;

  /// 间隔
  late TMap<String, double> spacerMap;

  /// 映射关系
  late TMap<String, String> refMap;

  /// 额外定义的结构
  late TExtraThemeData? extraThemeData;

  TThemeData({
    required this.name,
    required this.colorMap,
    required this.fontMap,
    required this.radiusMap,
    required this.fontFamilyMap,
    required this.shadowMap,
    required this.spacerMap,
    required this.refMap,
    this.extraThemeData,
  }) {
    light = this;
  }

  /// 获取默认Data，一个App里只有一个，用于没有context的地方
  static TThemeData defaultData({TExtraThemeData? extraThemeData}) {
    _defaultThemeData ??= fromJson(
      _defaultThemeName,
      TDefaultTheme.defaultThemeConfig,
      darkName: _defaultDartThemeName,
      extraThemeData: extraThemeData,
    );
    if (_defaultThemeData == null) {
      var emptyData = _emptyData(
        _defaultThemeName,
        extraThemeData: extraThemeData,
      );
      emptyData.light = emptyData;
      _defaultThemeData = emptyData;
    }

    return _defaultThemeData!;
  }

  /// 从父类拷贝
  TThemeData copyWithTThemeData(
    String name, {
    Map<String, Color>? colorMap,
    Map<String, Font>? fontMap,
    Map<String, double>? radiusMap,
    Map<String, FontFamily>? fontFamilyMap,
    Map<String, List<BoxShadow>>? shadowMap,
    Map<String, double>? marginMap,
    TExtraThemeData? extraThemeData,
  }) {
    return copyWith(
          name: name,
          colorMap: colorMap,
          fontMap: fontMap,
          radiusMap: radiusMap,
          fontFamilyMap: fontFamilyMap,
          shadowMap: shadowMap,
          marginMap: marginMap,
          extraThemeData: extraThemeData,
        )
        as TThemeData;
  }

  @override
  ThemeExtension<TThemeData> copyWith({
    String? name,
    Map<String, Color>? colorMap,
    Map<String, Font>? fontMap,
    Map<String, double>? radiusMap,
    Map<String, FontFamily>? fontFamilyMap,
    Map<String, List<BoxShadow>>? shadowMap,
    Map<String, double>? marginMap,
    TExtraThemeData? extraThemeData,
  }) {
    return TThemeData(
      name: name ?? 'default',
      colorMap: _copyMap<Color>(this.colorMap, colorMap),
      fontMap: _copyMap<Font>(this.fontMap, fontMap),
      radiusMap: _copyMap<double>(this.radiusMap, radiusMap),
      fontFamilyMap: _copyMap<FontFamily>(this.fontFamilyMap, fontFamilyMap),
      shadowMap: _copyMap<List<BoxShadow>>(this.shadowMap, shadowMap),
      spacerMap: _copyMap<double>(spacerMap, marginMap),
      refMap: _copyMap<String>(refMap, refMap),
      extraThemeData: extraThemeData ?? this.extraThemeData,
    );
  }

  /// 拷贝Map,防止内层
  TMap<String, T> _copyMap<T>(TMap<String, T> src, Map<String, T>? add) {
    var map = TMap<String, T>(factory: () => src);

    src.forEach((key, value) {
      map[key] = value;
    });
    if (add != null) {
      map.addAll(add);
    }
    return map;
  }

  /// 创建空对象
  static TThemeData _emptyData(String name, {TExtraThemeData? extraThemeData}) {
    var refMap = TMap<String, String>();
    return TThemeData(
      name: name,
      colorMap: TMap(factory: () => defaultData().colorMap, refs: refMap),
      fontMap: TMap(factory: () => defaultData().fontMap, refs: refMap),
      radiusMap: TMap(factory: () => defaultData().radiusMap, refs: refMap),
      fontFamilyMap: TMap(
        factory: () => defaultData().fontFamilyMap,
        refs: refMap,
      ),
      shadowMap: TMap(factory: () => defaultData().shadowMap, refs: refMap),
      spacerMap: TMap(factory: () => defaultData().spacerMap, refs: refMap),
      refMap: refMap,
    );
  }

  /// 解析配置的json文件为主题数据
  ///
  /// [name] 主题名称，目前只支持一级键
  ///
  /// [themeJson] 主题json字符串，要求json配置必须正确
  ///
  /// [recoverDefault] 是否恢复为默认主题数据
  ///
  /// [extraThemeData] 额外扩展的主题数据
  static TThemeData? fromJson(
    String name,
    String themeJson, {

    /// 暗色主题名称；为空时使用 `${name}Dark`。
    String? darkName,
    bool recoverDefault = false,
    TExtraThemeData? extraThemeData,
  }) {
    if (themeJson.isEmpty) {
      Log.e('TTheme', 'parse themeJson is empty');
      return null;
    }
    try {
      /// 要求json配置必须正确
      final themeConfig = json.decode(themeJson);
      if (themeConfig.containsKey(name)) {
        var theme = parseThemeData(name, themeConfig, extraThemeData);
        theme.light = theme;
        darkName ??= '${name}Dark';
        if (themeConfig[darkName] != null) {
          // 解析暗色模式
          var darkTheme = parseThemeData(darkName, themeConfig, extraThemeData);
          darkTheme.light = theme;
          theme.dark = darkTheme;
          // 填充暗色模式缺失数据
          theme.refMap.forEach((key, value) {
            darkTheme.refMap.putIfAbsent(key, () => value);
          });
        }
        if (recoverDefault) {
          _defaultThemeData = theme;
        }
        return theme;
      } else {
        Log.e(
          'TTheme',
          'load theme error ,not found the theme with name:${name}',
        );
        return null;
      }
    } catch (e) {
      Log.e('TTheme', 'parse theme data error:${e}');
      return null;
    }
  }

  static TThemeData parseThemeData(
    String name,

    /// 已解析的主题 JSON 配置。
    dynamic themeConfig,
    TExtraThemeData? extraThemeData,
  ) {
    var theme = _emptyData(name);
    Map<String, dynamic>? curThemeMap = themeConfig['$name'];
    if (curThemeMap?.isEmpty ?? true) {
      return theme;
    }

    /// 设置颜色
    Map<String, dynamic>? colorsMap = curThemeMap?['color'];
    colorsMap?.forEach((key, value) {
      var color = toColor(value);
      if (color != null) {
        theme.colorMap[key] = color;
      }
    });

    /// 设置颜色
    Map<String, dynamic>? refMap = curThemeMap?['ref'];
    refMap?.forEach((key, value) {
      theme.refMap[key] = value;
    });

    /// 设置字体尺寸
    Map<String, dynamic>? fontsMap = curThemeMap?['font'];
    fontsMap?.forEach((key, value) {
      theme.fontMap[key] = Font.fromJson(value);
    });

    /// 设置圆角
    Map<String, dynamic>? cornersMap = curThemeMap?['radius'];
    cornersMap?.forEach((key, value) {
      theme.radiusMap[key] = value.toDouble();
    });

    /// 设置字体
    Map<String, dynamic>? fontFamilyMap = curThemeMap?['fontFamily'];
    fontFamilyMap?.forEach((key, value) {
      theme.fontFamilyMap[key] = FontFamily.fromJson(value);
    });

    /// 设置阴影
    Map<String, dynamic>? shadowMap = curThemeMap?['shadow'];
    shadowMap?.forEach((key, value) {
      var list = <BoxShadow>[];
      (value as List).forEach((element) {
        list.add(
          BoxShadow(
            color: toColor(element['color']) ?? Colors.black,
            blurRadius: element['blurRadius'].toDouble(),
            spreadRadius: element['spreadRadius'].toDouble(),
            offset: Offset(
              element['offset']?['x'].toDouble() ?? 0,
              element['offset']?['y'].toDouble() ?? 0,
            ),
          ),
        );
      });

      theme.shadowMap[key] = list;
    });

    /// 设置Margin
    Map<String, dynamic>? marginsMap = curThemeMap?['margin'];
    marginsMap?.forEach((key, value) {
      theme.spacerMap[key] = value.toDouble();
    });

    if (extraThemeData != null && curThemeMap != null) {
      extraThemeData.parse(name, curThemeMap);
      theme.extraThemeData = extraThemeData;
    }
    return theme;
  }

  Color? ofColor(String? key) {
    return colorMap[key];
  }

  Font? ofFont(String? key) {
    return fontMap[key];
  }

  double? ofCorner(String? key) {
    return radiusMap[key];
  }

  FontFamily? ofFontFamily(String? key) {
    return fontFamilyMap[key];
  }

  List<BoxShadow>? ofShadow(String? key) {
    return shadowMap[key];
  }

  T? ofExtra<T extends TExtraThemeData>() {
    try {
      return extraThemeData as T;
    } catch (e) {
      Log.e('TThemeData ofExtra error: $e');
    }
    return null;
  }

  @override
  ThemeExtension<TThemeData> lerp(ThemeExtension<TThemeData>? other, double t) {
    if (other is! TThemeData) {
      return this;
    }
    return TThemeData(
      name: other.name,
      colorMap: other.colorMap,
      fontMap: other.fontMap,
      radiusMap: other.radiusMap,
      fontFamilyMap: other.fontFamilyMap,
      shadowMap: other.shadowMap,
      spacerMap: other.spacerMap,
      refMap: other.refMap,
    );
  }
}

/// 扩展主题数据
abstract class TExtraThemeData {
  /// 解析json
  void parse(String name, Map<String, dynamic> curThemeMap);
}

typedef DefaultMapFactory = TMap? Function();

/// 自定义Map
class TMap<K, V> extends DelegatingMap<K, V> {
  TMap({this.factory, this.refs}) : super({});
  DefaultMapFactory? factory;
  TMap? refs;

  @override
  V? operator [](Object? key) {
    // return super[key];
    key = refs?[key] ?? key;
    var value = super[key];
    if (value != null) {
      return value;
    }
    var defaultValue = factory?.call()?.get(key);
    if (defaultValue is V) {
      return defaultValue;
    }
    return null;
  }

  V? get(Object? key) {
    return super[key];
  }
}

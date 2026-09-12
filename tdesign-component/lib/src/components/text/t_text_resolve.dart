import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../theme/basic.dart';
import '../../theme/t_colors.dart';
import '../../theme/t_fonts.dart';
import '../../theme/t_text_theme_source.dart';
import '../../theme/t_theme.dart';
import 't_text.dart' show TText, TTextSpan;
import 't_text_theme_data.dart';

/// TText 与 TTextSpan 的 Flutter 原生样式解析器。
class TTextResolve {
  TTextResolve._();

  /// 解析 [TText] 最终样式。
  ///
  /// 优先级：实例 style > 实例便利参数 > TTextThemeData >
  /// DefaultTextStyle > Material TextTheme > 组合组件 defaults > TDesign Token。
  ///
  /// [defaults] 仅供组合组件提供内置文字样式，不代表调用方显式覆盖。
  /// 调用方的部分主题配置只替换对应字段，未配置字段仍使用组件默认值。
  static TextStyle resolve({
    required BuildContext context,
    TextStyle? defaults,
    TextStyle? style,
    Font? font,
    FontWeight? fontWeight,
    FontFamily? fontFamily,
    Color? textColor,
    bool? isTextThrough,
    Color? lineThroughColor,
  }) {
    final token = context.tTheme;
    final tokenFont = token.fontBodyLarge ?? Font(size: 16, lineHeight: 24);
    final material = Theme.of(context);
    final componentTheme = material.extension<TTextThemeData>();

    final ambientTextStyle = DefaultTextStyle.of(context).style;
    var resolved = _isMaterialFallbackStyle(ambientTextStyle)
        ? const TextStyle()
        : ambientTextStyle;
    resolved = _merge(
      resolved,
      _fontStyle(tokenFont).copyWith(color: token.textColorPrimary),
    );
    resolved = _merge(resolved, defaults);
    // 既有 TText 调用保留原有解析；组合组件 defaults 使用字段级来源解析。
    resolved = _merge(
      resolved,
      defaults == null
          ? material.tExplicitTextTheme?.bodyLarge
          : _explicitMaterialTextStyle(material),
    );
    final defaultTextStyle = defaults == null
        ? context.tExplicitDefaultTextStyle
        : _explicitDefaultTextStyle(context);
    if (!_isMaterialFallbackStyle(defaultTextStyle)) {
      resolved = _merge(resolved, defaultTextStyle);
    }
    resolved = _merge(resolved, _fontStyleOrNull(componentTheme?.font));
    resolved = _merge(resolved, componentTheme?.textStyle);
    resolved = _merge(
      resolved,
      _explicitStyle(
        font: font,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        textColor: textColor,
        isTextThrough: isTextThrough,
        lineThroughColor: lineThroughColor,
      ),
    );
    resolved = _merge(resolved, style);

    // 样式已经按完整优先级解析，禁止原生 Text 再次合并同一个
    // DefaultTextStyle。否则 MaterialApp 在缺少 Material 祖先时注入的诊断
    // 样式会把黄色双下划线等字段重新带回最终结果。
    return resolved.inherit ? resolved.copyWith(inherit: false) : resolved;
  }

  /// 解析 [TTextSpan] 的显式样式。
  ///
  /// Span 不读取 Theme 或 Token；未指定的字段保持为空并继承父 Span。
  static TextStyle? resolveSpan({
    TextStyle? style,
    Font? font,
    FontWeight? fontWeight,
    FontFamily? fontFamily,
    Color? textColor,
    bool? isTextThrough,
    Color? lineThroughColor,
  }) {
    final explicit = _explicitStyle(
      font: font,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
      textColor: textColor,
      isTextThrough: isTextThrough,
      lineThroughColor: lineThroughColor,
    );
    if (explicit == null) {
      return style;
    }
    return style == null ? explicit : explicit.merge(style);
  }

  static TextStyle? _explicitMaterialTextStyle(ThemeData material) {
    final projection = material.extensions.values
        .whereType<TTextThemeSource>()
        .firstOrNull;
    final base =
        projection?.textTheme ??
        ThemeData(
          brightness: material.brightness,
          colorScheme: material.colorScheme,
          useMaterial3: material.useMaterial3,
        ).textTheme;
    final typography = material.useMaterial3
        ? Typography.material2021(platform: material.platform)
        : Typography.material2014(platform: material.platform);
    return _styleDifference(
      material.textTheme.bodyLarge,
      typography.englishLike.merge(base).bodyLarge,
    );
  }

  static TextStyle? _explicitDefaultTextStyle(BuildContext context) {
    final material = Theme.of(context);
    final inherited = DefaultTextStyle.of(context).style;
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
    if (implicitStyles.contains(inherited)) {
      return null;
    }
    TextStyle? materialDefault;
    TextStyle? ancestorStyle;
    context.visitAncestorElements((element) {
      final widget = element.widget;
      if (widget is DefaultTextStyle) {
        ancestorStyle = widget.style;
        if (implicitStyles.contains(widget.style)) {
          materialDefault = widget.style;
          return false;
        }
      }
      if (widget is AnimatedDefaultTextStyle &&
          implicitStyles.contains(widget.style)) {
        materialDefault = ancestorStyle;
        return false;
      }
      return true;
    });
    // DefaultTextStyle.merge 同样会携带 Material 的补全字段。
    return _styleDifference(inherited, materialDefault);
  }

  static TextStyle? _styleDifference(TextStyle? value, TextStyle? defaults) {
    if (value == null ||
        defaults == null ||
        (!value.inherit && defaults.inherit)) {
      return value;
    }
    const equality = ListEquality<Object?>();
    final result = TextStyle(
      color: value.color == defaults.color ? null : value.color,
      backgroundColor: value.backgroundColor == defaults.backgroundColor
          ? null
          : value.backgroundColor,
      fontFamily: value.fontFamily == defaults.fontFamily
          ? null
          : value.fontFamily,
      fontSize: value.fontSize == defaults.fontSize ? null : value.fontSize,
      fontWeight: value.fontWeight == defaults.fontWeight
          ? null
          : value.fontWeight,
      fontStyle: value.fontStyle == defaults.fontStyle ? null : value.fontStyle,
      letterSpacing: value.letterSpacing == defaults.letterSpacing
          ? null
          : value.letterSpacing,
      wordSpacing: value.wordSpacing == defaults.wordSpacing
          ? null
          : value.wordSpacing,
      textBaseline: value.textBaseline == defaults.textBaseline
          ? null
          : value.textBaseline,
      height: value.height == defaults.height ? null : value.height,
      leadingDistribution:
          value.leadingDistribution == defaults.leadingDistribution
          ? null
          : value.leadingDistribution,
      locale: value.locale == defaults.locale ? null : value.locale,
      foreground: value.foreground == defaults.foreground
          ? null
          : value.foreground,
      background: value.background == defaults.background
          ? null
          : value.background,
      decoration: value.decoration == defaults.decoration
          ? null
          : value.decoration,
      decorationColor: value.decorationColor == defaults.decorationColor
          ? null
          : value.decorationColor,
      decorationStyle: value.decorationStyle == defaults.decorationStyle
          ? null
          : value.decorationStyle,
      decorationThickness:
          value.decorationThickness == defaults.decorationThickness
          ? null
          : value.decorationThickness,
      overflow: value.overflow == defaults.overflow ? null : value.overflow,
      fontFamilyFallback:
          equality.equals(value.fontFamilyFallback, defaults.fontFamilyFallback)
          ? null
          : value.fontFamilyFallback,
      shadows: equality.equals(value.shadows, defaults.shadows)
          ? null
          : value.shadows,
      fontFeatures: equality.equals(value.fontFeatures, defaults.fontFeatures)
          ? null
          : value.fontFeatures,
      fontVariations:
          equality.equals(value.fontVariations, defaults.fontVariations)
          ? null
          : value.fontVariations,
    );
    return result == const TextStyle() ? null : result;
  }

  static TextStyle _merge(TextStyle base, TextStyle? override) {
    return override == null ? base : base.merge(override);
  }

  static bool _isMaterialFallbackStyle(TextStyle? style) {
    return style?.debugLabel?.contains(
          'fallback style; consider putting your text in a Material',
        ) ??
        false;
  }

  static TextStyle _fontStyle(Font font) {
    return TextStyle(
      fontSize: font.size,
      height: font.height,
      fontWeight: font.fontWeight,
    );
  }

  static TextStyle? _fontStyleOrNull(Font? font) {
    return font == null ? null : _fontStyle(font);
  }

  static TextStyle? _explicitStyle({
    Font? font,
    FontWeight? fontWeight,
    FontFamily? fontFamily,
    Color? textColor,
    bool? isTextThrough,
    Color? lineThroughColor,
  }) {
    if (font == null &&
        fontWeight == null &&
        fontFamily == null &&
        textColor == null &&
        isTextThrough == null &&
        lineThroughColor == null) {
      return null;
    }
    return TextStyle(
      color: textColor,
      fontSize: font?.size,
      height: font?.height,
      fontWeight: fontWeight ?? font?.fontWeight,
      fontFamily: fontFamily?.fontFamily,
      package: fontFamily?.package,
      decoration: isTextThrough == null
          ? null
          : isTextThrough
          ? TextDecoration.lineThrough
          : TextDecoration.none,
      decorationColor: lineThroughColor,
    );
  }
}

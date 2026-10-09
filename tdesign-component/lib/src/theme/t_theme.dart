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
  ///     const TTagThemeData(squareBorderRadius: 6),
  ///   ),
  ///   child: const TTag('局部圆角'),
  /// )
  /// ```
  ThemeData mergeExtension<T extends ThemeExtension<T>>(T extension) {
    final merged = Map<Type, ThemeExtension<dynamic>>.from(extensions);
    merged[T] = extension;
    return copyWith(extensions: merged.values.toList());
  }
}

/// TDesign 样式解析器。
///
/// 实例显式样式、组件 Theme 和全局 Token 是单向样式链。
///
/// 用法：
/// ```dart
/// final resolver = TStyleResolver.of(context);
/// final token = resolver.token;              // P4
/// final buttonTheme = resolver.componentExtension<TButtonThemeData>(); // P1
/// ```
class TStyleResolver {
  TStyleResolver._(this._context);

  final BuildContext _context;

  /// 创建解析器实例
  static TStyleResolver of(BuildContext context) => TStyleResolver._(context);

  /// 全局设计 Token（色板 / 间距原始值）。
  TThemeData get token =>
      Theme.of(_context).extension<TThemeData>() ?? TThemeData.defaultData();

  /// 组件 ThemeExtension。
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
      color: extensionData.componentStroke,
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
        backgroundColor: extensionData.errorColor,
        textColor: extensionData.textColorAnti,
        textStyle: _textStyle(
          extensionData.fontMarkExtraSmall,
        )?.copyWith(color: extensionData.textColorAnti, letterSpacing: 0),
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
          borderSide: BorderSide(color: extensionData.componentBorder),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: extensionData.componentStroke),
        ),
      ),
      useMaterial3: true,
    );
    return base;
  }

  List<ThemeExtension<dynamic>> _themeExtensions(TThemeData token) {
    return <ThemeExtension<dynamic>>[
      token,
      const TButtonThemeData(),
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
      const TSwipeCellThemeData(),
      const TSwiperThemeData(),
      const TSwitchThemeData(),
      const TTabBarThemeData(),
      const TTableThemeData(),
      const TTabsBarThemeData(),
      const TTagThemeData(),
      const TTextThemeData(),
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
      disabledForegroundColor: token.textColorDisabled,
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
      primary: t.brandColor,
      onPrimary: t.textColorAnti,
      primaryContainer: t.brandColorLight,
      onPrimaryContainer: t.brandColor,
      // 次级
      secondary: t.brandColor6,
      onSecondary: t.textColorAnti,
      secondaryContainer: t.bgColorSecondaryContainer,
      onSecondaryContainer: t.textColorPrimary,
      // 警告色
      tertiary: t.warningColor,
      onTertiary: t.textColorAnti,
      tertiaryContainer: t.warningColorLight,
      onTertiaryContainer: t.warningColor,
      // 错误色
      error: t.errorColor,
      onError: t.textColorAnti,
      errorContainer: t.errorColorLight,
      onErrorContainer: t.errorColor,
      // 背景与表面
      surface: t.bgColorContainer,
      onSurface: t.textColorPrimary,
      surfaceContainerHighest: t.bgColorComponent,
      onSurfaceVariant: t.textColorSecondary,
      // 描边
      outline: t.componentBorder,
      outlineVariant: t.componentStroke,
      // 反色
      inverseSurface: t.grayColor13,
      onInverseSurface: t.fontWhite1,
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
      primary: t.brandColor,
      onPrimary: t.textColorAnti,
      primaryContainer: t.brandColorLight,
      onPrimaryContainer: t.brandColor,
      // 次级
      secondary: t.brandColor6,
      onSecondary: t.textColorAnti,
      secondaryContainer: t.bgColorSecondaryContainer,
      onSecondaryContainer: t.textColorPrimary,
      // 警告色
      tertiary: t.warningColor,
      onTertiary: t.textColorAnti,
      tertiaryContainer: t.warningColorLight,
      onTertiaryContainer: t.warningColor,
      // 错误色
      error: t.errorColor,
      onError: t.textColorAnti,
      errorContainer: t.errorColorLight,
      onErrorContainer: t.errorColor,
      // 背景与表面
      surface: t.bgColorContainer,
      onSurface: t.textColorPrimary,
      surfaceContainerHighest: t.bgColorComponent,
      onSurfaceVariant: t.textColorSecondary,
      // 描边
      outline: t.componentBorder,
      outlineVariant: t.componentStroke,
      // 反色
      inverseSurface: t.grayColor13,
      onInverseSurface: t.fontWhite1,
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

  /// 小程序独立字号与行高 Token，单位为 Flutter 逻辑像素。
  late TMap<String, double> fontMetricMap;

  /// 圆角
  late TMap<String, double> radiusMap;

  /// 字体样式
  late TMap<String, FontFamily> fontFamilyMap;

  /// 阴影
  late TMap<String, List<BoxShadow>> shadowMap;

  /// 小程序 blur=0 的内投影在 Flutter 中对应的内侧边线。
  late TMap<String, BorderSide> insetShadowMap;

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
    TMap<String, double>? fontMetricMap,
    required this.radiusMap,
    required this.fontFamilyMap,
    required this.shadowMap,
    TMap<String, BorderSide>? insetShadowMap,
    required this.spacerMap,
    required this.refMap,
    this.extraThemeData,
  }) {
    this.fontMetricMap = fontMetricMap ?? TMap<String, double>();
    this.insetShadowMap = insetShadowMap ?? TMap<String, BorderSide>();
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

  /// 复制 Token 主题并合并非空映射，返回具体的 [TThemeData]。
  /// 未传入的映射值、名称和扩展数据保留。
  @override
  TThemeData copyWith({
    String? name,
    Map<String, Color>? colorMap,
    Map<String, Font>? fontMap,
    Map<String, double>? fontMetricMap,
    Map<String, double>? radiusMap,
    Map<String, FontFamily>? fontFamilyMap,
    Map<String, List<BoxShadow>>? shadowMap,
    Map<String, BorderSide>? insetShadowMap,

    /// 间距 Token 的增量映射；非空值覆盖同名 Token，其他间距沿用当前配置。
    Map<String, double>? spacerMap,
    TExtraThemeData? extraThemeData,
  }) {
    final copiedRefs = _copyMap<String>(refMap, null);
    return TThemeData(
      name: name ?? this.name,
      colorMap: _copyMap<Color>(this.colorMap, colorMap, copiedRefs),
      fontMap: _copyMap<Font>(this.fontMap, fontMap, copiedRefs),
      fontMetricMap: _copyMap<double>(
        this.fontMetricMap,
        fontMetricMap,
        copiedRefs,
      ),
      radiusMap: _copyMap<double>(this.radiusMap, radiusMap, copiedRefs),
      fontFamilyMap: _copyMap<FontFamily>(
        this.fontFamilyMap,
        fontFamilyMap,
        copiedRefs,
      ),
      shadowMap: _copyMap<List<BoxShadow>>(
        this.shadowMap,
        shadowMap,
        copiedRefs,
      ),
      insetShadowMap: _copyMap<BorderSide>(
        this.insetShadowMap,
        insetShadowMap,
        copiedRefs,
      ),
      spacerMap: _copyMap<double>(this.spacerMap, spacerMap, copiedRefs),
      refMap: copiedRefs,
      extraThemeData: extraThemeData ?? this.extraThemeData,
    );
  }

  /// 拷贝Map,防止内层
  TMap<String, T> _copyMap<T>(
    TMap<String, T> src,
    Map<String, T>? add, [
    TMap<String, String>? refs,
  ]) {
    var map = TMap<String, T>(factory: () => src, refs: refs);

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
    var refMap = TMap<String, String>(factory: () => defaultData().refMap);
    return TThemeData(
      name: name,
      colorMap: TMap(factory: () => defaultData().colorMap, refs: refMap),
      fontMap: TMap(factory: () => defaultData().fontMap, refs: refMap),
      fontMetricMap: TMap(
        factory: () => defaultData().fontMetricMap,
        refs: refMap,
      ),
      radiusMap: TMap(factory: () => defaultData().radiusMap, refs: refMap),
      fontFamilyMap: TMap(
        factory: () => defaultData().fontFamilyMap,
        refs: refMap,
      ),
      shadowMap: TMap(factory: () => defaultData().shadowMap, refs: refMap),
      insetShadowMap: TMap(
        factory: () => defaultData().insetShadowMap,
        refs: refMap,
      ),
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
        var theme = _parseThemeData(name, themeConfig, extraThemeData);
        theme.light = theme;
        darkName ??= '${name}Dark';
        if (themeConfig[darkName] != null) {
          // 解析暗色模式
          var darkTheme = _parseThemeData(
            darkName,
            themeConfig,
            extraThemeData,
          );
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

  static TThemeData _parseThemeData(
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

    /// 小程序字体尺寸与行高可独立覆盖，不能只保留复合 Font。
    Map<String, dynamic>? fontMetricsMap = curThemeMap?['fontMetric'];
    fontMetricsMap?.forEach((key, value) {
      theme.fontMetricMap[key] = (value as num).toDouble();
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

    /// 当前小程序内阴影均为 blur=0、扩散=0 的 0.5px 内侧描边。
    Map<String, dynamic>? insetShadowsMap = curThemeMap?['insetShadow'];
    insetShadowsMap?.forEach((key, value) {
      theme.insetShadowMap[key] = BorderSide(
        color: toColor(value['color']) ?? Colors.transparent,
        width: (value['width'] as num).toDouble(),
      );
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

  /// 在当前主题与目标主题间生成过渡配置。
  ///
  /// t 为 0 或 1 时返回对应端点；目标为空时返回当前主题。
  /// 颜色、字号、行高、圆角、阴影和间距按有效 Token 值插值，
  /// 单侧存在的 Token 保留；名称、字体族、业务扩展和明暗关联在 t=0.5 切换。
  /// 相同且未显式覆盖的 Token 引用继续沿用，其他值保存在新的映射中。
  ///
  /// ## 返回值
  /// 两端之间的 Token 主题；端点返回原主题，中间值返回独立映射。
  @override
  TThemeData lerp(
    /// 目标主题；为空或类型不匹配时返回当前主题。
    ThemeExtension<TThemeData>? other,

    /// 过渡进度；0 为当前主题，1 为目标主题，离散配置在 0.5 切换。
    double t,
  ) {
    if (other is! TThemeData || identical(this, other) || t == 0) {
      return this;
    }
    if (t == 1) {
      return other;
    }
    final selected = t < 0.5 ? this : other;
    final refs = _copyMap<String>(selected.refMap, null);
    final result = TThemeData(
      name: selected.name,
      colorMap: _lerpMap(
        colorMap,
        other.colorMap,
        refs,
        t,
        (a, b, t) => Color.lerp(a, b, t)!,
      ),
      fontMap: _lerpMap(fontMap, other.fontMap, refs, t, _lerpFont),
      fontMetricMap: _lerpMap(
        fontMetricMap,
        other.fontMetricMap,
        refs,
        t,
        _lerpNumber,
      ),
      radiusMap: _lerpMap(radiusMap, other.radiusMap, refs, t, _lerpNumber),
      fontFamilyMap: _lerpMap(
        fontFamilyMap,
        other.fontFamilyMap,
        refs,
        t,
        (a, b, t) => t < 0.5 ? a : b,
      ),
      shadowMap: _lerpMap(
        shadowMap,
        other.shadowMap,
        refs,
        t,
        (a, b, t) => BoxShadow.lerpList(a, b, t)!,
      ),
      insetShadowMap: _lerpMap(
        insetShadowMap,
        other.insetShadowMap,
        refs,
        t,
        BorderSide.lerp,
      ),
      spacerMap: _lerpMap(spacerMap, other.spacerMap, refs, t, _lerpNumber),
      refMap: refs,
      extraThemeData: selected.extraThemeData,
    );
    result.light = identical(selected.light, selected)
        ? result
        : selected.light;
    result.dark = selected.dark;
    return result;
  }

  static double _lerpNumber(double a, double b, double t) => a + (b - a) * t;

  static Font _lerpFont(Font a, Font b, double t) {
    final result = Font(
      size: 1,
      lineHeight: 1,
      fontWeight: FontWeight.lerp(a.fontWeight, b.fontWeight, t)!,
    );
    result.size = _lerpNumber(a.size, b.size, t);
    final lineHeight = _lerpNumber(a.size * a.height, b.size * b.height, t);
    result.height = result.size == 0
        ? _lerpNumber(a.height, b.height, t)
        : lineHeight / result.size;
    return result;
  }

  static Set<String> _tokenKeys(TMap<dynamic, dynamic> map) {
    final keys = <String>{};
    final visited = <TMap<dynamic, dynamic>>{};
    void collect(TMap<dynamic, dynamic> current) {
      if (!visited.add(current)) {
        return;
      }
      keys.addAll(current.keys.whereType<String>());
      final refs = current.refs;
      if (refs != null) {
        collect(refs);
      }
      final fallback = current.factory?.call();
      if (fallback != null) {
        collect(fallback);
      }
    }

    collect(map);
    return keys;
  }

  TMap<String, V> _lerpMap<V>(
    TMap<String, V> a,
    TMap<String, V> b,
    TMap<String, String> refs,
    double t,
    V Function(V, V, double) interpolate,
  ) {
    final result = TMap<String, V>(refs: refs);
    for (final key in {..._tokenKeys(a), ..._tokenKeys(b)}) {
      final reference = a.refs?[key];
      if (reference != null &&
          reference == b.refs?[key] &&
          a.get(key) == null &&
          b.get(key) == null) {
        continue;
      }
      final first = a[key];
      final second = b[key];
      final value = first == null
          ? second
          : second == null
          ? first
          : interpolate(first, second, t);
      if (value != null) {
        result[key] = value;
      }
    }
    return result;
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
    return _resolve(key, <Object?>{});
  }

  V? _resolve(Object? key, Set<Object?> visited) {
    if (!visited.add(key)) {
      return null;
    }
    // An explicitly configured token wins over its default reference. This
    // mirrors a CSS custom property overriding a var(--td-...) fallback.
    final localValue = super[key];
    if (localValue != null) {
      return localValue;
    }
    final reference = refs?[key];
    if (reference != null) {
      final referencedValue = _resolve(reference, visited);
      if (referencedValue != null) {
        return referencedValue;
      }
    }
    final fallback = factory?.call();
    if (identical(fallback, this)) {
      return null;
    }
    final defaultValue = fallback?[key];
    return defaultValue is V ? defaultValue : null;
  }

  V? get(Object? key) {
    return super[key];
  }
}

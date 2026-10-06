import 'dart:convert';

import 'package:css2token/css2token.dart';
import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// Parses a website message into the theme consumed by the Flutter Web Demo.
///
/// Browser origin validation stays in the Web listener so this function remains
/// platform independent and can be covered by normal Flutter tests.
dynamic decodeWebThemeMessageData(dynamic data) {
  if (data is! String) {
    return data;
  }
  try {
    return jsonDecode(data);
  } on Object {
    return null;
  }
}

ThemeMode? parseWebThemeMode(dynamic message) {
  if (message is! Map ||
      !const {
        'flutter-theme-update',
        'flutter-css-theme-update',
      }.contains(message['type'])) {
    return null;
  }
  return switch (message['themeMode']) {
    'dark' => ThemeMode.dark,
    'light' => ThemeMode.light,
    _ => null,
  };
}

/// Parses a decoded website message into a Flutter theme.
TThemeData? parseWebThemeUpdateMessage(dynamic message) {
  if (message is! Map ||
      !const {
        'flutter-theme-update',
        'flutter-css-theme-update',
      }.contains(message['type'])) {
    return null;
  }
  try {
    final Map theme;
    if (message['type'] == 'flutter-css-theme-update') {
      final css = _cssParts(message['css']);
      final baseline = _cssParts(message['baseline']);
      if (css == null ||
          baseline == null ||
          parseWebThemeMode(message) == null) {
        return null;
      }
      theme = cssToFlutterTokens(
        lightCss: css.light,
        darkCss: css.dark,
        extraCss: css.extra,
        baseline: baseline,
      ).toJson();
    } else {
      final supplied = message['theme'];
      if (supplied is! Map ||
          supplied['light'] is! Map ||
          supplied['dark'] is! Map) {
        return null;
      }
      theme = supplied;
    }
    final lightOverrides = _parseThemePart('custom', theme['light'] as Map);
    final darkOverrides = _parseThemePart('customDark', theme['dark'] as Map);
    if (lightOverrides == null || darkOverrides == null) {
      return null;
    }

    final defaults = TThemeData.defaultData();
    final lightValues = theme['light'] as Map;
    final darkValues = theme['dark'] as Map;
    final light = _mergeTheme(defaults, lightOverrides, lightValues, 'custom');
    final dark = _mergeTheme(
      defaults.dark ?? defaults,
      darkOverrides,
      darkValues,
      'customDark',
    );
    light.light = light;
    light.dark = dark;
    dark.light = light;
    return light;
  } on Object {
    return null;
  }
}

TThemeData? _parseThemePart(String name, Map<dynamic, dynamic> values) {
  final groups = Map<dynamic, dynamic>.of(values);
  final fonts = groups.remove('font');
  final theme = TThemeData.fromJson(name, jsonEncode({name: groups}));
  if (theme == null) {
    return null;
  }
  if (fonts != null) {
    for (final entry in (fonts as Map).entries) {
      final font = entry.value as Map;
      final size = (font['size'] as num).toDouble();
      final lineHeight = (font['lineHeight'] as num).toDouble();
      final weight = (font['fontWeight'] ?? 4) as int;
      if (!size.isFinite ||
          !lineHeight.isFinite ||
          size <= 0 ||
          lineHeight <= 0 ||
          weight < 1 ||
          weight > FontWeight.values.length) {
        return null;
      }
      // The controller emits fractional metrics in incremental height mode.
      // Font's JSON constructor takes ints, but its stored metrics are doubles.
      theme.fontMap[entry.key as String] =
          Font(
              size: 1,
              lineHeight: 1,
              fontWeight: FontWeight.values[weight - 1],
            )
            ..size = size
            ..height = lineHeight / size;
    }
  }
  return theme;
}

TThemeData _mergeTheme(
  TThemeData base,
  TThemeData overrides,
  Map<dynamic, dynamic> values,
  String name,
) {
  final refMap = TMap<String, String>()
    ..addAll(base.refMap)
    ..addAll(_declaredValues<String>(overrides.refMap, values['ref']));
  return TThemeData(
    name: name,
    colorMap: TMap<String, Color>(factory: () => base.colorMap, refs: refMap)
      ..addAll(_declaredValues<Color>(overrides.colorMap, values['color'])),
    fontMap: TMap<String, Font>(factory: () => base.fontMap, refs: refMap)
      ..addAll(_declaredValues<Font>(overrides.fontMap, values['font'])),
    fontMetricMap:
        TMap<String, double>(factory: () => base.fontMetricMap, refs: refMap)
          ..addAll(
            _declaredValues<double>(
              overrides.fontMetricMap,
              values['fontMetric'],
            ),
          ),
    insetShadowMap:
        TMap<String, BorderSide>(
          factory: () => base.insetShadowMap,
          refs: refMap,
        )..addAll(
          _declaredValues<BorderSide>(
            overrides.insetShadowMap,
            values['insetShadow'],
          ),
        ),
    radiusMap: TMap<String, double>(factory: () => base.radiusMap, refs: refMap)
      ..addAll(_declaredValues<double>(overrides.radiusMap, values['radius'])),
    fontFamilyMap:
        TMap<String, FontFamily>(
          factory: () => base.fontFamilyMap,
          refs: refMap,
        )..addAll(
          _declaredValues<FontFamily>(
            overrides.fontFamilyMap,
            values['fontFamily'],
          ),
        ),
    shadowMap:
        TMap<String, List<BoxShadow>>(
          factory: () => base.shadowMap,
          refs: refMap,
        )..addAll(
          _declaredValues<List<BoxShadow>>(
            overrides.shadowMap,
            values['shadow'],
          ),
        ),
    spacerMap: TMap<String, double>(factory: () => base.spacerMap, refs: refMap)
      ..addAll(_declaredValues<double>(overrides.spacerMap, values['margin'])),
    refMap: refMap,
    extraThemeData: base.extraThemeData,
  );
}

Map<String, T> _declaredValues<T>(Map<String, T> parsed, dynamic values) {
  if (values is! Map) {
    return {};
  }
  return {
    for (final key in values.keys.whereType<String>())
      if (parsed[key] case final T value) key: value,
  };
}

CssThemeParts? _cssParts(dynamic value) {
  if (value is! Map ||
      value['light'] is! String ||
      value['dark'] is! String ||
      value['extra'] is! String) {
    return null;
  }
  return CssThemeParts(
    light: value['light'] as String,
    dark: value['dark'] as String,
    extra: value['extra'] as String,
  );
}

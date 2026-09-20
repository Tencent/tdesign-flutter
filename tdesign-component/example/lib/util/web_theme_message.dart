import 'dart:convert';

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
  if (message is! Map || message['type'] != 'flutter-theme-update') {
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
  if (message is! Map || message['type'] != 'flutter-theme-update') {
    return null;
  }
  final theme = message['theme'];
  if (theme is! Map || theme['light'] is! Map || theme['dark'] is! Map) {
    return null;
  }

  try {
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
  return TThemeData.fromJson(name, jsonEncode(<String, dynamic>{name: values}));
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

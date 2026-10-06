import 'dart:convert';
import 'dart:io';

import 'package:css2token/css2token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:tdesign_flutter_example/util/web_theme_message.dart';

void main() {
  test('parses every TThemeData group and its dark theme', () {
    final message = <String, dynamic>{
      'type': 'flutter-theme-update',
      'theme': {
        'light': _theme('#FF112233', 18),
        'dark': _theme('#FF445566', 20),
      },
    };

    final theme = parseWebThemeUpdateMessage(message);

    expect(theme, isNotNull);
    expect(theme!.brandColor, const Color(0xFF112233));
    expect(theme.fontBodyMedium?.size, 18);
    expect(theme.fontBodyMedium?.height, 26 / 18);
    expect(theme.fontSizeBodyMedium, 18);
    expect(theme.lineHeightBodyMedium, 26);
    expect(theme.shadowInsetTop?.width, 2);
    expect(theme.shadowInsetRight, TThemeData.defaultData().shadowInsetRight);
    expect(theme.radiusDefault, 8);
    expect(theme.shadow1?.single.blurRadius, 9);
    expect(theme.spacer2, 21);
    expect(theme.fontFamilyMap['numberFontFamily']?.fontFamily, 'TCloudNumber');
    expect(theme.dark?.brandColor, const Color(0xFF445566));
    expect(theme.dark?.fontBodyMedium?.size, 20);
    expect(theme.bgColorPage, TThemeData.defaultData().bgColorPage);
    expect(
      theme.fontSizeTitleMedium,
      TThemeData.defaultData().fontSizeTitleMedium,
    );
    expect(theme.dark?.bgColorPage, TThemeData.defaultData().dark?.bgColorPage);
    expect(theme.dark?.bgColorPage, isNot(theme.bgColorPage));
  });

  test('converts raw controller CSS in Dart and applies every theme group', () {
    final message = _cssMessage();
    final theme = parseWebThemeUpdateMessage(message)!;
    expect(theme.brandColor, const Color(0xFF112233));
    expect(theme.dark!.brandColor, const Color(0xFF445566));
    expect(theme.fontBodyMedium!.size, 18);
    expect(theme.lineHeightBodyMedium, 27);
    expect(theme.radiusDefault, 8);
    expect(theme.shadow1!.single.blurRadius, 9);
    expect(theme.shadowInsetTop!.width, 2);
    expect(theme.spacer2, 24);
    expect(theme.dark!.fontSizeBodyMedium, 18);
    expect(theme.bgColorPage, TThemeData.defaultData().bgColorPage);
    expect(parseWebThemeMode(message), ThemeMode.dark);
    expect(
      parseWebThemeUpdateMessage(
        decodeWebThemeMessageData(jsonEncode(message)),
      )!.brandColor,
      theme.brandColor,
    );
  });

  test(
    'pristine CSS preserves Flutter defaults and clears previous overrides',
    () {
      final baseline =
          jsonDecode(
                File(
                  '../../packages/css2token/test/fixtures/controller-defaults.json',
                ).readAsStringSync(),
              )
              as Map;
      final message = {
        'type': 'flutter-css-theme-update',
        'themeMode': 'light',
        'css': baseline,
        'baseline': baseline,
      };
      final theme = parseWebThemeUpdateMessage(message)!;
      final defaults = TThemeData.defaultData();
      expect(theme.brandColor, defaults.brandColor);
      expect(theme.fontSizeBodyMedium, defaults.fontSizeBodyMedium);
      expect(theme.spacer2, defaults.spacer2);
      expect(theme.dark!.brandColor, defaults.dark!.brandColor);
      expect(theme.dark!.bgColorPage, defaults.dark!.bgColorPage);
    },
  );

  test('fractional CSS metrics preserve both themes and other overrides', () {
    final message = _cssMessage();
    (message['css'] as Map)['extra'] =
        '--td-font-size-body-medium:15.5px; '
        '--td-line-height-body-medium:23.25px; --td-radius-default:7px;';
    final theme = parseWebThemeUpdateMessage(message)!;
    for (final mode in [theme, theme.dark!]) {
      expect(mode.fontBodyMedium!.size, 15.5);
      expect(mode.fontBodyMedium!.height, 1.5);
      expect(mode.fontSizeBodyMedium, 15.5);
      expect(mode.lineHeightBodyMedium, 23.25);
      expect(mode.radiusDefault, 7);
    }
    expect(theme.brandColor, const Color(0xFF112233));
    expect(theme.dark!.brandColor, const Color(0xFF445566));
  });

  test(
    'raw CSS message rejects malformed parts, missing baseline and mode',
    () {
      for (final key in ['css', 'baseline', 'themeMode']) {
        final message = _cssMessage()..remove(key);
        expect(parseWebThemeUpdateMessage(message), isNull);
      }
      expect(
        parseWebThemeUpdateMessage(
          _cssMessage()..['css'] = {'light': 42, 'dark': '', 'extra': ''},
        ),
        isNull,
      );
      expect(
        parseWebThemeUpdateMessage(_cssMessage()..['themeMode'] = 'system'),
        isNull,
      );
    },
  );

  test(
    'real controller output contains only currently consumed Flutter tokens',
    () {
      final css =
          jsonDecode(
                File(
                  '../../packages/css2token/test/fixtures/controller-defaults.json',
                ).readAsStringSync(),
              )
              as Map;
      final result = cssToFlutterTokens(
        lightCss: css['light'] as String,
        darkCss: css['dark'] as String,
        extraCss: css['extra'] as String,
      );
      const files = {
        'ref': 't_colors.dart',
        'color': 't_colors.dart',
        'font': 't_fonts.dart',
        'fontMetric': 't_fonts.dart',
        'radius': 't_radius.dart',
        'shadow': 't_shadows.dart',
        'insetShadow': 't_shadows.dart',
        'margin': 't_spacers.dart',
      };
      for (final mode in [result.light, result.dark]) {
        for (final group in mode.toJson().entries) {
          final source = File(
            '../lib/src/theme/${files[group.key]}',
          ).readAsStringSync();
          final getters = RegExp(
            r'\bget (\w+)',
          ).allMatches(source).map((m) => m[1]).toSet();
          for (final key in (group.value as Map).keys) {
            expect(getters, contains(key), reason: '${group.key}.$key');
          }
        }
      }
    },
  );

  test('rejects unrelated or incomplete messages', () {
    expect(parseWebThemeUpdateMessage(null), isNull);
    expect(parseWebThemeUpdateMessage({'type': 'theme-mode-change'}), isNull);
    expect(
      parseWebThemeUpdateMessage({
        'type': 'flutter-theme-update',
        'theme': {'light': <String, dynamic>{}},
      }),
      isNull,
    );
  });

  test('decodes JSON string messages used by JavaScript postMessage', () {
    final data = decodeWebThemeMessageData(
      '{"type":"flutter-theme-update","themeMode":"dark","theme":{"light":{},"dark":{}}}',
    );

    expect(data, {
      'type': 'flutter-theme-update',
      'themeMode': 'dark',
      'theme': {'light': {}, 'dark': {}},
    });
    expect(parseWebThemeMode(data), ThemeMode.dark);
    expect(
      parseWebThemeMode({'type': 'theme-mode-change', 'themeMode': 'dark'}),
      isNull,
    );
    expect(decodeWebThemeMessageData('{invalid'), isNull);
  });
}

Map<String, dynamic> _theme(String color, int fontSize) {
  return {
    'color': {'brandColor7': color},
    'ref': {'brandColor': 'brandColor7'},
    'font': {
      'fontBodyMedium': {'size': fontSize, 'lineHeight': 26, 'fontWeight': 4},
    },
    'fontMetric': {'fontSizeBodyMedium': fontSize, 'lineHeightBodyMedium': 26},
    'insetShadow': {
      'shadowInsetTop': {'color': '#112233', 'width': 2},
    },
    'fontFamily': {
      'numberFontFamily': {
        'fontFamily': 'TCloudNumber',
        'package': 'tdesign_flutter',
      },
    },
    'radius': {'radiusDefault': 8},
    'shadow': {
      'shadow1': [
        {
          'color': '#22000000',
          'blurRadius': 9,
          'spreadRadius': 1,
          'offset': {'x': 2, 'y': 3},
        },
      ],
    },
    'margin': {'spacer2': 21},
  };
}

Map<String, dynamic> _cssMessage() => {
  'type': 'flutter-css-theme-update',
  'themeMode': 'dark',
  'baseline': {'light': '', 'dark': '', 'extra': ''},
  'css': {
    'light':
        '--td-brand-color-7:#123; --td-brand-color:var(--td-brand-color-7);',
    'dark':
        '--td-brand-color-7:#456; --td-brand-color:var(--td-brand-color-7);',
    'extra':
        '--td-font-size-body-medium:18px; --td-line-height-body-medium:27px; --td-radius-default:8px; --td-shadow-1:0 3px 9px 1px #22000000; --td-shadow-inset-top:inset 0 2px 0 0 #123; --td-size-6:24px;',
  },
};

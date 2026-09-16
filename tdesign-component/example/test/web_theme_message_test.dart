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
    expect(theme!.brandNormalColor, const Color(0xFF112233));
    expect(theme.fontBodyMedium?.size, 18);
    expect(theme.fontBodyMedium?.height, 26 / 18);
    expect(theme.radiusDefault, 8);
    expect(theme.shadowsBase?.single.blurRadius, 9);
    expect(theme.spacer16, 21);
    expect(theme.numberFontFamily?.fontFamily, 'TCloudNumber');
    expect(theme.dark?.brandNormalColor, const Color(0xFF445566));
    expect(theme.dark?.fontBodyMedium?.size, 20);
    expect(theme.bgColorPage, TThemeData.defaultData().bgColorPage);
    expect(theme.dark?.bgColorPage, TThemeData.defaultData().dark?.bgColorPage);
    expect(theme.dark?.bgColorPage, isNot(theme.bgColorPage));
  });

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
      '{"type":"theme-mode-change","themeMode":"dark"}',
    );

    expect(data, {'type': 'theme-mode-change', 'themeMode': 'dark'});
    expect(decodeWebThemeMessageData('{invalid'), isNull);
  });
}

Map<String, dynamic> _theme(String color, int fontSize) {
  return {
    'color': {'brandColor7': color},
    'ref': {'brandNormalColor': 'brandColor7'},
    'font': {
      'fontBodyMedium': {'size': fontSize, 'lineHeight': 26, 'fontWeight': 4},
    },
    'fontFamily': {
      'numberFontFamily': {
        'fontFamily': 'TCloudNumber',
        'package': 'tdesign_flutter',
      },
    },
    'radius': {'radiusDefault': 8},
    'shadow': {
      'shadowsBase': [
        {
          'color': '#22000000',
          'blurRadius': 9,
          'spreadRadius': 1,
          'offset': {'x': 2, 'y': 3},
        },
      ],
    },
    'margin': {'spacer16': 21},
  };
}

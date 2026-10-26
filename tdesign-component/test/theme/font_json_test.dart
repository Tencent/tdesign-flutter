import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  test(
    'integer JSON and the existing integer constructor retain their metrics',
    () {
      final direct = Font(size: 16, lineHeight: 24);
      final parsed = Font.fromJson({'size': 16, 'lineHeight': 24});
      expect(parsed.size, direct.size);
      expect(parsed.height, direct.height);
      expect(parsed.fontWeight, FontWeight.w400);
    },
  );

  test(
    'public named light/dark JSON retains fractional font metrics and weight',
    () {
      final theme = TThemeData.fromJson(
        'ocean',
        jsonEncode({
          'ocean': {
            'font': {
              'fontBodyMedium': {
                'size': 14.25,
                'lineHeight': 22.75,
                'fontWeight': 6,
              },
            },
          },
          'oceanDark': {
            'font': {
              'fontBodyMedium': {'size': 16.5, 'lineHeight': 25.25},
            },
          },
        }),
      );
      expect(theme, isNotNull);
      expect(theme!.fontBodyMedium!.size, 14.25);
      expect(theme.fontBodyMedium!.height, 22.75 / 14.25);
      expect(theme.fontBodyMedium!.fontWeight, FontWeight.w600);
      expect(theme.dark!.fontBodyMedium!.size, 16.5);
      expect(theme.dark!.fontBodyMedium!.height, 25.25 / 16.5);
      expect(theme.dark!.fontBodyMedium!.fontWeight, FontWeight.w400);
      expect(theme.radiusDefault, TThemeData.defaultData().radiusDefault);
    },
  );

  test('fractional JSON retains more than three decimal places', () {
    const size = 14.1234567890123, lineHeight = 22.9876543210987;
    final theme = TThemeData.fromJson(
      'precise',
      jsonEncode({
        'precise': {
          'font': {
            'fontBodyMedium': {'size': size, 'lineHeight': lineHeight},
          },
        },
      }),
    )!;
    expect(theme.fontBodyMedium!.size, size);
    expect(theme.fontBodyMedium!.height, lineHeight / size);
  });

  test(
    'legacy zero line height remains valid for integer and decimal JSON',
    () {
      final original = Font(size: 16, lineHeight: 0);
      for (final zero in <num>[0, 0.0]) {
        final font = Font.fromJson({'size': 16, 'lineHeight': zero});
        expect(font.height, original.height);
        final theme = TThemeData.fromJson(
          'zero',
          jsonEncode({
            'zero': {
              'font': {
                'fontBodyMedium': {'size': 16, 'lineHeight': zero},
              },
            },
          }),
        );
        expect(theme!.fontBodyMedium!.height, 0);
      }
    },
  );

  test('finite inputs producing an infinite height ratio are rejected', () {
    final config = {'size': 5e-324, 'lineHeight': 24};
    expect(() => Font.fromJson(config), throwsFormatException);
    expect(
      TThemeData.fromJson(
        'bad',
        jsonEncode({
          'bad': {
            'font': {'fontBodyMedium': config},
          },
        }),
      ),
      isNull,
    );
  });

  for (final key in ['size', 'lineHeight']) {
    for (final value in <Object?>[
      null,
      '16',
      true,
      0,
      -1,
      double.nan,
      double.infinity,
      double.maxFinite,
    ]) {
      // maxFinite is finite and valid; it must not be rounded through int.
      test('$key handles $value', () {
        final map = <String, dynamic>{'size': 16, 'lineHeight': 24, key: value};
        if (value == double.maxFinite || (key == 'lineHeight' && value == 0)) {
          expect(Font.fromJson(map), isA<Font>());
        } else {
          expect(() => Font.fromJson(map), throwsFormatException);
        }
      });
    }
  }
  for (final value in <Object>[-1, 0, 10, 4.0, '4', true]) {
    test('invalid weight $value is rejected', () {
      expect(
        () =>
            Font.fromJson({'size': 16, 'lineHeight': 24, 'fontWeight': value}),
        throwsFormatException,
      );
    });
  }
  test('invalid named-theme config still returns null', () {
    expect(
      TThemeData.fromJson(
        'ocean',
        jsonEncode({
          'ocean': {
            'font': {
              'fontBodyMedium': {'size': 'bad', 'lineHeight': 24},
            },
          },
        }),
      ),
      isNull,
    );
  });
}

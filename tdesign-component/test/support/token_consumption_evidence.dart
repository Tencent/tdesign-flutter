import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

/// Diagnostic observations are opt-in; assertions run on every CI execution.
/// A rendered value is distinct from a completed cross-platform pixel review.
void tokenObservation(
  String name, {
  required String scenario,
  required Object? actual,
  required Object? expected,
  bool enforce = true,
}) {
  Object? encode(Object? value) => switch (value) {
    Color color => '#${color.toARGB32().toRadixString(16).padLeft(8, '0')}',
    double number => double.parse(number.toStringAsFixed(8)),
    num number => number,
    bool boolean => boolean,
    null => null,
    _ => value.toString(),
  };
  final matches = actual is num && expected is num
      ? (actual - expected).abs() <= 1e-8
      : actual == expected;
  if (Platform.environment['TDESIGN_TOKEN_EVIDENCE'] == '1') {
    // ignore: avoid_print
    print(
      'TOKEN_EVIDENCE ${jsonEncode({'name': name, 'scenario': scenario, 'actual': encode(actual), 'expected': encode(expected), 'matches': matches, 'enforced': enforce})}',
    );
  }
  if (enforce) {
    expect(
      actual,
      expected is num ? closeTo(expected, 1e-8) : expected,
      reason: '$name ($scenario)',
    );
  }
}

TThemeData evidenceTokens(Brightness brightness, {required bool custom}) {
  final defaults = TThemeData.defaultData();
  final base = brightness == Brightness.dark ? defaults.dark! : defaults;
  if (!custom) {
    return base;
  }
  const keys = [
    'brandColor',
    'brandColorActive',
    'brandColorDisabled',
    'brandColorLight',
    'brandColorLightActive',
    'errorColor',
    'errorColorActive',
    'errorColorDisabled',
    'errorColor3',
    'bgColorComponent',
    'bgColorComponentActive',
    'bgColorComponentDisabled',
    'bgColorContainer',
    'bgColorContainerActive',
    'bgColorSecondaryContainerActive',
    'componentBorder',
    'componentStroke',
    'textColorPrimary',
    'textColorPlaceholder',
    'textColorDisabled',
    'textColorAnti',
    'fontWhite1',
    'fontWhite2',
    'fontWhite4',
    'successColor',
    'warningColor',
    'successColorActive',
    'successColorDisabled',
    'warningColorActive',
    'warningColorDisabled',
  ];
  return base.copyWith(
    colorMap: {
      for (var index = 0; index < keys.length; index++)
        keys[index]: Color(0xff210000 + (index + 1) * 0x010307),
    },
    fontMetricMap: {
      'fontSizeXl': 31,
      'fontSizeM': 21,
      'fontSizeBase': 18,
      'fontSizeS': 15,
    },
    fontMap: {
      'fontMarkLarge': Font(
        size: 19,
        lineHeight: 27,
        fontWeight: FontWeight.w700,
      ),
      'fontMarkMedium': Font(
        size: 17,
        lineHeight: 25,
        fontWeight: FontWeight.w700,
      ),
      'fontBodyLarge': Font(size: 20, lineHeight: 28),
      'fontBodyMedium': Font(size: 19, lineHeight: 27),
      'fontTitleExtraLarge': Font(
        size: 23,
        lineHeight: 31,
        fontWeight: FontWeight.w500,
      ),
    },
    radiusMap: {'radiusDefault': 13, 'radiusCircle': 23},
    spacerMap: {'spacer': 11, 'spacer2': 19, 'spacer4': 37},
  );
}

Widget evidenceHost(
  Widget child, {
  required Brightness brightness,
  required TThemeData token,
  List<ThemeExtension<dynamic>> extensions = const [],
}) => MaterialApp(
  theme: ThemeData(brightness: brightness, extensions: [token, ...extensions]),
  home: Scaffold(body: Center(child: child)),
);

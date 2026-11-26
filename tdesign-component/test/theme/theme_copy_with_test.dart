import 'package:flutter_test/flutter_test.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

void main() {
  final defaults = TThemeData.defaultData();
  final originalDark = defaults.dark!;
  test(
    'colorMap two overrides on both modes, originals retain original values',
    () {
      final overrides = <String, Color>{
        'labA': const Color(0xFF123456),
        'labB': const Color(0xFF654321),
      };
      final copy = defaults.copyWith(colorMap: overrides);
      for (final entry in overrides.entries) {
        expect(copy.colorMap[entry.key], equals(entry.value));
        expect(copy.dark!.colorMap[entry.key], equals(entry.value));
        expect(defaults.colorMap[entry.key], isNull);
        expect(originalDark.colorMap[entry.key], isNull);
      }
      final untouched = originalDark.colorMap.keys.firstOrNull;
      if (untouched != null) {
        expect(
          copy.dark!.colorMap[untouched],
          equals(originalDark.colorMap[untouched]),
        );
      }
    },
  );
  test(
    'fontMap two overrides on both modes, originals retain original values',
    () {
      final overrides = <String, Font>{
        'labA': Font(size: 13, lineHeight: 20),
        'labB': Font(size: 17, lineHeight: 26),
      };
      final copy = defaults.copyWith(fontMap: overrides);
      for (final entry in overrides.entries) {
        expect(copy.fontMap[entry.key], equals(entry.value));
        expect(copy.dark!.fontMap[entry.key], equals(entry.value));
        expect(defaults.fontMap[entry.key], isNull);
        expect(originalDark.fontMap[entry.key], isNull);
      }
      final untouched = originalDark.fontMap.keys.firstOrNull;
      if (untouched != null) {
        expect(
          copy.dark!.fontMap[untouched],
          equals(originalDark.fontMap[untouched]),
        );
      }
    },
  );
  test(
    'fontMetricMap two overrides on both modes, originals retain original values',
    () {
      final overrides = <String, double>{'labA': 13.5, 'labB': 22.5};
      final copy = defaults.copyWith(fontMetricMap: overrides);
      for (final entry in overrides.entries) {
        expect(copy.fontMetricMap[entry.key], equals(entry.value));
        expect(copy.dark!.fontMetricMap[entry.key], equals(entry.value));
        expect(defaults.fontMetricMap[entry.key], isNull);
        expect(originalDark.fontMetricMap[entry.key], isNull);
      }
      final untouched = originalDark.fontMetricMap.keys.firstOrNull;
      if (untouched != null) {
        expect(
          copy.dark!.fontMetricMap[untouched],
          equals(originalDark.fontMetricMap[untouched]),
        );
      }
    },
  );
  test(
    'radiusMap two overrides on both modes, originals retain original values',
    () {
      final overrides = <String, double>{'labA': 7.0, 'labB': 11.0};
      final copy = defaults.copyWith(radiusMap: overrides);
      for (final entry in overrides.entries) {
        expect(copy.radiusMap[entry.key], equals(entry.value));
        expect(copy.dark!.radiusMap[entry.key], equals(entry.value));
        expect(defaults.radiusMap[entry.key], isNull);
        expect(originalDark.radiusMap[entry.key], isNull);
      }
      final untouched = originalDark.radiusMap.keys.firstOrNull;
      if (untouched != null) {
        expect(
          copy.dark!.radiusMap[untouched],
          equals(originalDark.radiusMap[untouched]),
        );
      }
    },
  );
  test(
    'fontFamilyMap two overrides on both modes, originals retain original values',
    () {
      final overrides = <String, FontFamily>{
        'labA': FontFamily(fontFamily: 'Lab A'),
        'labB': FontFamily(fontFamily: 'Lab B'),
      };
      final copy = defaults.copyWith(fontFamilyMap: overrides);
      for (final entry in overrides.entries) {
        expect(copy.fontFamilyMap[entry.key], equals(entry.value));
        expect(copy.dark!.fontFamilyMap[entry.key], equals(entry.value));
        expect(defaults.fontFamilyMap[entry.key], isNull);
        expect(originalDark.fontFamilyMap[entry.key], isNull);
      }
      final untouched = originalDark.fontFamilyMap.keys.firstOrNull;
      if (untouched != null) {
        expect(
          copy.dark!.fontFamilyMap[untouched],
          equals(originalDark.fontFamilyMap[untouched]),
        );
      }
    },
  );
  test(
    'shadowMap two overrides on both modes, originals retain original values',
    () {
      final overrides = <String, List<BoxShadow>>{
        'labA': const [BoxShadow(blurRadius: 4)],
        'labB': const [BoxShadow(blurRadius: 8)],
      };
      final copy = defaults.copyWith(shadowMap: overrides);
      for (final entry in overrides.entries) {
        expect(copy.shadowMap[entry.key], equals(entry.value));
        expect(copy.dark!.shadowMap[entry.key], equals(entry.value));
        expect(defaults.shadowMap[entry.key], isNull);
        expect(originalDark.shadowMap[entry.key], isNull);
      }
      final untouched = originalDark.shadowMap.keys.firstOrNull;
      if (untouched != null) {
        expect(
          copy.dark!.shadowMap[untouched],
          equals(originalDark.shadowMap[untouched]),
        );
      }
    },
  );
  test(
    'insetShadowMap two overrides on both modes, originals retain original values',
    () {
      final overrides = <String, BorderSide>{
        'labA': const BorderSide(width: 2),
        'labB': const BorderSide(width: 3),
      };
      final copy = defaults.copyWith(insetShadowMap: overrides);
      for (final entry in overrides.entries) {
        expect(copy.insetShadowMap[entry.key], equals(entry.value));
        expect(copy.dark!.insetShadowMap[entry.key], equals(entry.value));
        expect(defaults.insetShadowMap[entry.key], isNull);
        expect(originalDark.insetShadowMap[entry.key], isNull);
      }
      final untouched = originalDark.insetShadowMap.keys.firstOrNull;
      if (untouched != null) {
        expect(
          copy.dark!.insetShadowMap[untouched],
          equals(originalDark.insetShadowMap[untouched]),
        );
      }
    },
  );
  test(
    'spacerMap two overrides on both modes, originals retain original values',
    () {
      final overrides = <String, double>{'labA': 5.0, 'labB': 19.0};
      final copy = defaults.copyWith(spacerMap: overrides);
      for (final entry in overrides.entries) {
        expect(copy.spacerMap[entry.key], equals(entry.value));
        expect(copy.dark!.spacerMap[entry.key], equals(entry.value));
        expect(defaults.spacerMap[entry.key], isNull);
        expect(originalDark.spacerMap[entry.key], isNull);
      }
      final untouched = originalDark.spacerMap.keys.firstOrNull;
      if (untouched != null) {
        expect(
          copy.dark!.spacerMap[untouched],
          equals(originalDark.spacerMap[untouched]),
        );
      }
    },
  );
  test(
    'sizeMap two overrides on both modes, originals retain original values',
    () {
      final overrides = <String, double>{'labA': 28.0, 'labB': 36.0};
      final copy = defaults.copyWith(sizeMap: overrides);
      for (final entry in overrides.entries) {
        expect(copy.sizeMap[entry.key], equals(entry.value));
        expect(copy.dark!.sizeMap[entry.key], equals(entry.value));
        expect(defaults.sizeMap[entry.key], isNull);
        expect(originalDark.sizeMap[entry.key], isNull);
      }
      final untouched = originalDark.sizeMap.keys.firstOrNull;
      if (untouched != null) {
        expect(
          copy.dark!.sizeMap[untouched],
          equals(originalDark.sizeMap[untouched]),
        );
      }
    },
  );

  test('preserves two refMap aliases, with distinct local maps', () {
    final theme = TThemeData.fromJson('lab', '''
      {"lab":{"size":{"x":12,"y":20},"ref":{"a":"x","b":"y"}},
       "labDark":{"size":{"x":14,"y":22}}}
    ''')!;
    final copy = theme.copyWith();
    for (final side in [copy, copy.dark!]) {
      expect(side.refMap['a'], 'x');
      expect(side.refMap['b'], 'y');
    }
    expect([copy.sizeMap['a'], copy.sizeMap['b']], [12.0, 20.0]);
    expect([copy.dark!.sizeMap['a'], copy.dark!.sizeMap['b']], [14.0, 22.0]);
    expect(copy.refMap, isNot(same(theme.refMap)));
  });

  test('two-way pair, no dark pairing, direct dark copy and mode lookup', () {
    final custom = defaults.copyWith(sizeMap: {'size8': 28});
    expect(custom.light, same(custom));
    expect(custom.dark!.light, same(custom));
    expect(originalDark.light, same(defaults));
    expect(
      TThemeBuilder.light(custom.dark!).extension<TThemeData>()!.size8,
      28,
    );
    expect(
      TThemeBuilder.dark(custom).colorScheme.surface,
      originalDark.bgColorContainer,
    );
    final darkOnly = originalDark.copyWith(sizeMap: {'size8': 32});
    expect(darkOnly.light, same(defaults));
    expect(darkOnly.dark, isNull);
    final unpaired = TThemeData.fromJson('solo', '{"solo":{}}')!;
    final solo = unpaired.copyWith(sizeMap: {'size8': 33});
    expect(solo.dark, isNull);
    expect(TThemeBuilder.dark(solo).extension<TThemeData>()!.size8, 33);
    expect(TThemeBuilder.dark(darkOnly).extension<TThemeData>()!.size8, 32);
  });

  test(
    'explicit color override reaches actual Material surface in both modes',
    () {
      const color = Color(0xFFFFFFFF);
      final copy = defaults.copyWith(colorMap: {'bgColorContainer': color});
      expect(TThemeBuilder.light(copy).colorScheme.surface, color);
      expect(TThemeBuilder.dark(copy).colorScheme.surface, color);
      expect(originalDark.bgColorContainer, isNot(color));
    },
  );

  test('bounded theme-object copying even on a cyclic dark field', () {
    final input = TThemeData.fromJson('lab', '{"lab":{}}')!;
    input.dark = input;
    final copy = input.copyWith(sizeMap: {'size8': 28});
    expect(copy.dark!.light, same(copy));
    expect(copy.dark!.dark, isNull);
  });

  test('source map mutations after copy', () {
    final original = TThemeData.fromJson('app', '''
      {"app":{"size":{"kept":10,"explicit":11},"ref":{"lateAlias":"late","oldAlias":"kept"}},
       "appDark":{"size":{"kept":20,"explicit":21}}}
    ''')!;
    final copy = original.copyWith(sizeMap: {'explicit': 28});
    for (final side in [original, original.dark!]) {
      side.sizeMap['kept'] = 55;
      side.sizeMap['explicit'] = 56;
      side.sizeMap['late'] = 57;
      side.refMap['newAlias'] = 'late';
    }
    for (final side in [copy, copy.dark!]) {
      final actual = <String, double?>{
        for (final key in [
          'kept',
          'explicit',
          'late',
          'lateAlias',
          'oldAlias',
          'newAlias',
          'size8',
        ])
          key: side.sizeMap[key],
      };
      final isDark = identical(side, copy.dark);
      final baseline = isDark ? 20.0 : 10.0;
      final defaults = TThemeData.defaultData();
      expect(actual, {
        'kept': baseline,
        'explicit': 28.0,
        'late': 57.0,
        'lateAlias': 57.0,
        'oldAlias': baseline,
        'newAlias': 57.0,
        'size8': (isDark ? defaults.dark! : defaults).size8,
      });
      expect(side.refMap['newAlias'], 'late');
    }
  });
}

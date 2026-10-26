import 'dart:convert';
import 'dart:io';

import 'package:css2token/css2token.dart';
import 'package:test/test.dart';

void main() {
  test(
    'font stacks preserve quoted commas, references and sparse defaults',
    () {
      const baseline = '--td-font-family: Arial, sans-serif;';
      final result = parseCssToFlutterTokens(
        '--td-stack: "Example, Sans", "Noto Sans", sans-serif; '
        '--td-font-family: var(--td-stack); '
        '--td-font-family-medium: "Medium Sans", serif;',
        baselineCss: baseline,
      );
      expect(result.fontFamily['fontFamily'], {
        'fontFamily': 'Example, Sans',
        'fallback': ['Noto Sans', 'sans-serif'],
      });
      expect(result.fontFamily['fontFamilyMedium'], {
        'fontFamily': 'Medium Sans',
        'fallback': ['serif'],
      });
      expect(
        parseCssToFlutterTokens(baseline, baselineCss: baseline).fontFamily,
        isEmpty,
      );
      for (final invalid in [
        'inherit',
        'unset',
        '"unterminated',
        'Arial,,serif',
      ]) {
        expect(
          parseCssToFlutterTokens('--td-font-family: $invalid;').fontFamily,
          isEmpty,
        );
      }
    },
  );
  test('all size steps preserve fractions, mode separation and restoration',
      () {
    final css =
        [for (var i = 1; i <= 16; i++) '--td-size-$i: ${i + 0.5}px;'].join();
    final result = cssToFlutterTokens(
        lightCss: css,
        darkCss: '',
        baseline: const CssThemeParts(light: '', dark: ''));
    expect(result.light.size, {
      for (var i = 1; i <= 16; i++) 'size$i': i + 0.5,
    });
    expect(result.dark.size, isEmpty);
    expect(parseCssToFlutterTokens(css, baselineCss: css).size, isEmpty);
    for (final invalid in ['-1px', 'Infinity', '20em']) {
      expect(parseCssToFlutterTokens('--td-size-6:$invalid;').size, isEmpty);
    }
  });
  test('explicit mobile font levels override legacy derived aliases', () {
    final result = parseCssToFlutterTokens(
      '--td-font-size-title-extraLarge:30px; '
      '--td-font-size-title-large:26px; '
      '--td-font-size-body-extraSmall:11px; '
      '--td-font-size-body-small:15px; '
      '--td-font-size-mark-large:21px; '
      '--td-font-size-mark-medium:17px;',
    );
    expect(result.font['fontTitleExtraLarge'], {'size': 30.0});
    expect(result.font['fontTitleLarge'], {'size': 26.0});
    expect(result.font['fontBodyExtraSmall'], {'size': 11.0});
    expect(result.font['fontMarkLarge'], {'size': 21.0});
    expect(result.font['fontMarkMedium'], {'size': 17.0});
  });
  final fixtures =
      jsonDecode(File('test/fixtures/themes.json').readAsStringSync()) as List;
  for (final fixture in fixtures.cast<Map<String, dynamic>>()) {
    test(fixture['name'] as String, () {
      final base = fixture['baseline'] as Map<String, dynamic>?;
      final result = cssToFlutterTokens(
        lightCss: fixture['light'] as String,
        darkCss: fixture['dark'] as String,
        extraCss: fixture['extra'] as String,
        baseline: base == null
            ? null
            : CssThemeParts(
                light: base['light'] as String,
                dark: base['dark'] as String,
                extra: base['extra'] as String,
              ),
      );
      final json = result.toJson();
      // Historical fixtures predate the additive size group, tested below.
      for (final mode in ['light', 'dark']) {
        (json[mode] as Map).remove('size');
      }
      expect(json, fixture['expected']);
    });
  }
  test('normalizes CSS rgba to Flutter argb', () {
    expect(normalizeCssColor('#abcd'), '#DDAABBCC');
    expect(normalizeCssColor('#11223344'), '#44112233');
    expect(normalizeCssColor('rgb(100% 0% 0% / 50%)'), '#80FF0000');
    expect(normalizeCssColor('rgba(..., 2, 3, 1)'), isNull);
  });
  test(
    'baseline observes fallback dependencies and restoration clears overrides',
    () {
      const baseline =
          '--td-text-color-primary:var(--td-missing,var(--td-a)); --td-a:#123;';
      expect(
        parseCssToFlutterTokens(
          baseline.replaceFirst('#123', '#456'),
          baselineCss: baseline,
        ).color['textColorPrimary'],
        '#445566',
      );
      expect(
        parseCssToFlutterTokens(
          baseline,
          baselineCss: baseline,
        ).toJson().values,
        everyElement(isEmpty),
      );
    },
  );
}

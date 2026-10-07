import 'dart:convert';
import 'dart:io';

import 'package:css2token/css2token.dart';
import 'package:test/test.dart';

void main() {
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
      expect(result.toJson(), fixture['expected']);
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

import 'package:css2token/css2token.dart';
import 'package:test/test.dart';

void main() {
  test('full generator selector lists keep shared and mode values independent',
      () {
    final parts = splitGeneratorCss('''
/* export */
:root, :root[theme-mode="light"] { --td-brand-color: #123456; }
:root.dark, :root[theme-mode='dark'] { --td-brand-color: #abcdef; }
:root { --td-radius-default: 7.5px; --td-brand-color: #ffffff; }
:root[ theme-mode = dark ] { --td-radius-default: 11px; }
''');
    final tokens =
        cssToFlutterTokens(lightCss: parts.light, darkCss: parts.dark);
    expect(tokens.light.color['brandColor'], '#123456');
    expect(tokens.dark.color['brandColor'], '#ABCDEF');
    expect(tokens.light.radius['radiusDefault'], 7.5);
    expect(tokens.dark.radius['radiusDefault'], 11);
  });

  test(
      'same-specificity duplicate blocks and shared references use source order',
      () {
    final parts = splitGeneratorCss('''
:root { --td-radius-small: 3px; --td-brand-color: var(--td-custom); }
:root[theme-mode="light"] { --td-custom: #123456; }
:root.dark { --td-custom: #abcdef; }
:root { --td-radius-small: 4px; }
:root.dark { --td-custom: #112233; }
''');
    final tokens =
        cssToFlutterTokens(lightCss: parts.light, darkCss: parts.dark);
    expect(tokens.light.color['brandColor'], '#123456');
    expect(tokens.dark.color['brandColor'], '#112233');
    expect(tokens.light.radius['radiusSmall'], 4);
  });

  test('web seven-step radius scale lands on the Flutter tiers', () {
    // tdesign-common/style/web/theme/_radius.less as exported by the generator.
    final parts = splitGeneratorCss('''
:root, :root[theme-mode="light"] {
  --td-radius-small: 2px;
  --td-radius-default: 3px;
  --td-radius-medium: 6px;
  --td-radius-large: 9px;
  --td-radius-extraLarge: 12px;
  --td-radius-round: 999px;
  --td-radius-circle: 50%;
}
:root.dark, :root[theme-mode="dark"] {
  --td-radius-small: 2px;
  --td-radius-default: 3px;
  --td-radius-medium: 6px;
  --td-radius-large: 9px;
  --td-radius-extraLarge: 12px;
  --td-radius-round: 999px;
  --td-radius-circle: 50%;
}
''');
    final tokens =
        cssToFlutterTokens(lightCss: parts.light, darkCss: parts.dark);
    for (final radius in [tokens.light.radius, tokens.dark.radius]) {
      // Web medium is what Flutter calls default; web default is its small.
      expect(radius['radiusDefault'], 6);
      expect(radius['radiusSmall'], 3);
      expect(radius['radiusLarge'], 9);
      expect(radius['radiusExtraLarge'], 12);
      expect(radius['radiusRound'], 999);
      expect(radius['radiusCircle'], 9999);
      expect(radius.containsKey('radiusMedium'), isFalse);
    }
  });

  test('mobile radius scale keeps its own tier names', () {
    final parts = splitGeneratorCss('''
:root, :root[theme-mode="light"] {
  --td-radius-small: 4px;
  --td-radius-default: 8px;
  --td-radius-large: 12px;
}
:root.dark, :root[theme-mode="dark"] {
  --td-radius-small: 4px;
  --td-radius-default: 8px;
  --td-radius-large: 12px;
}
''');
    final tokens =
        cssToFlutterTokens(lightCss: parts.light, darkCss: parts.dark);
    expect(tokens.light.radius['radiusSmall'], 4);
    expect(tokens.light.radius['radiusDefault'], 8);
    expect(tokens.dark.radius['radiusDefault'], 8);
  });

  for (final css in [
    '',
    ':root[theme-mode="light\'] {a:b;} :root.dark {a:b;}',
    ':root[theme-mode=light"] {a:b;} :root.dark {a:b;}',
    ':root { --td-radius-small: 3px; }',
    ':root.dark { a:b; } trailing',
    '@media (prefers-color-scheme:dark) { :root {a:b;} }',
    '.light {a:b;} :root.dark {a:b;}',
    ':root[theme-mode="light"] {a:b;} :root.dark {a:b;',
  ]) {
    test('reject incomplete or unsupported stylesheet: $css', () {
      expect(() => splitGeneratorCss(css), throwsFormatException);
    });
  }
}

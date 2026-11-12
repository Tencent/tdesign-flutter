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

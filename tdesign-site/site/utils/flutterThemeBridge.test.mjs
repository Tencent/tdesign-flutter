import assert from 'node:assert/strict';
import test from 'node:test';
import { readFileSync } from 'node:fs';
import { loadControllerBaseline } from './controllerBaseline.mjs';

import {
  ensureFlutterThemeTokenCoverage,
  createFlutterThemeMessage,
  flutterThemeContract,
  generateFlutterThemeFromParts,
  normalizeCssColor,
  parseCssToFlutterTheme,
} from './flutterThemeBridge.mjs';

test('normalizes every CSS color form accepted by the theme controller', () => {
  assert.equal(normalizeCssColor('#abc'), '#AABBCC');
  assert.equal(normalizeCssColor('#abcd'), '#DDAABBCC');
  assert.equal(normalizeCssColor('#11223344'), '#44112233');
  assert.equal(normalizeCssColor('rgba(1, 2, 3, 50%)'), '#80010203');
  assert.equal(normalizeCssColor('rgb(4 5 6 / .25)'), '#40040506');
  assert.equal(normalizeCssColor('transparent'), '#00000000');
});

test('converts palette, semantic, typography, radius, shadow and spacing tokens', () => {
  const theme = parseCssToFlutterTheme(`
    :root {
      --td-brand-color-1: #123;
      --td-brand-color-7: rgba(1, 2, 3, 50%);
      --td-font-gray-1: rgba(0, 0, 0, .9);
      --td-brand-color: var(--td-brand-color-7);
      --td-text-color-primary: var(--td-font-gray-1);
      --td-bg-color-container: #abcdef;
      --td-component-stroke: var(--td-brand-color);
      --td-font-size-title-large: 21px;
      --td-line-height-title-large: 31px;
      --td-radius-small: 4px;
      --td-radius-default: 8px;
      --td-radius-medium: 10px;
      --td-radius-large: 12px;
      --td-radius-extraLarge: 16px;
      --td-radius-round: 999px;
      --td-radius-circle: 50%;
      --td-shadow-1: 0 1px 10px rgba(0, 0, 0, 5%), 0 4px 5px -1px #11223344;
      --td-size-2: 5px;
      --td-size-4: 10px;
      --td-size-5: 15px;
      --td-size-6: 20px;
      --td-size-8: 30px;
      --td-size-10: 40px;
      --td-size-12: 50px;
      --td-size-13: 60px;
      --td-size-15: 80px;
    }
  `);

  assert.equal(theme.color.brandColor1, '#112233');
  assert.equal(theme.color.brandColor7, '#80010203');
  assert.equal(theme.ref.brandNormalColor, 'brandColor7');
  assert.equal(theme.ref.componentStrokeColor, 'brandColor7');
  assert.equal(theme.color.bgColorContainer, '#ABCDEF');
  assert.equal(theme.ref.bgColorContainer, 'bgColorContainer');
  assert.deepEqual(theme.font.fontTitleLarge, {
    size: 19,
    lineHeight: 31,
    fontWeight: 6,
  });
  assert.equal(theme.font.fontTitleExtraLarge.size, 21);
  assert.equal(Object.keys(theme.font).length, flutterThemeContract.fontTokens.length);
  assert.deepEqual(Object.keys(theme.radius), flutterThemeContract.radiusTokens);
  assert.equal(theme.radius.radiusSmall, 8);
  assert.equal(theme.radius.radiusDefault, 10);
  assert.equal(theme.radius.radiusCircle, 9999);
  assert.deepEqual(theme.shadow.shadowsBase, [
    {
      color: '#0D000000',
      blurRadius: 10,
      spreadRadius: 0,
      offset: { x: 0, y: 1 },
    },
    {
      color: '#44112233',
      blurRadius: 5,
      spreadRadius: -1,
      offset: { x: 0, y: 4 },
    },
  ]);
  assert.deepEqual(theme.margin, {
    spacer4: 5,
    spacer8: 10,
    spacer12: 15,
    spacer16: 20,
    spacer24: 30,
    spacer32: 40,
    spacer40: 50,
    spacer48: 60,
    spacer64: 80,
    spacer96: 120,
    spacer160: 200,
  });
});

test('emits only overrides relative to the initial controller theme', () => {
  const baseline = `:root {
    --td-brand-color-7: #0052d9;
    --td-brand-color: var(--td-brand-color-7);
    --td-gray-color-3: #e8e8e8;
    --td-component-stroke: var(--td-gray-color-3);
    --td-font-size-body-large: 16px;
    --td-line-height-body-large: 24px;
    --td-radius-medium: 6px;
    --td-shadow-1: 0 1px 10px rgba(0, 0, 0, 5%);
    --td-size-2: 4px;
  }`;
  const unchanged = parseCssToFlutterTheme(baseline, baseline);
  assert.deepEqual(unchanged, { ref: {}, color: {}, font: {}, fontMetric: {}, radius: {}, shadow: {}, insetShadow: {}, margin: {} });

  const changed = baseline.replace('#0052d9', '#112233').replace('16px', '18px');
  const theme = parseCssToFlutterTheme(changed, baseline);
  assert.deepEqual(theme.color, { brandColor7: '#112233' });
  assert.equal(theme.ref.brandNormalColor, 'brandColor7');
  assert.equal(theme.font.fontBodyLarge.size, 18);
  assert.equal(theme.fontMetric.fontSizeBodyLarge, 18);
  assert.deepEqual(theme.radius, {});
  assert.deepEqual(theme.shadow, {});
  assert.deepEqual(theme.margin, {});
});

test('completes mobile CSS once and keeps light and dark values independent', () => {
  const extra = ':root { --td-font-size-body-medium: 18px; }';
  const completed = ensureFlutterThemeTokenCoverage(extra);
  assert.equal(ensureFlutterThemeTokenCoverage(completed), completed);
  assert.match(completed, /--td-line-height-body-medium: 22px/);
  assert.match(completed, /--td-size-16: 72px/);

  const output = generateFlutterThemeFromParts(
    ':root { --td-brand-color-7: #010203; --td-brand-color: var(--td-brand-color-7); }',
    ':root { --td-brand-color-7: #aabbcc; --td-brand-color: var(--td-brand-color-7); }',
    extra,
  );
  assert.equal(output.light.color.brandColor7, '#010203');
  assert.equal(output.dark.color.brandColor7, '#AABBCC');
  assert.equal(output.light.font.fontBodyMedium.size, 18);
  assert.equal(output.dark.font.fontBodyMedium.size, 18);
});

test('builds one complete message for mode and token updates', () => {
  const theme = { light: { color: {} }, dark: { color: {} } };
  assert.deepEqual(createFlutterThemeMessage(theme, 'dark'), {
    type: 'flutter-theme-update',
    themeMode: 'dark',
    theme,
  });
  assert.equal(createFlutterThemeMessage(theme, 'system').themeMode, 'light');
});

test('maps the controller size scale to current Flutter spacers', () => {
  const baseline = { light: '', dark: '', extra: ':root { --td-size-6: 16px; --td-size-15: 64px; }' };
  const theme = generateFlutterThemeFromParts('', '', ':root { --td-size-6: 24px; --td-size-15: 80px; }', baseline);
  assert.deepEqual(theme.light.margin, { spacer2: 24, spacer6: 100 });
  assert.deepEqual(theme.dark.margin, theme.light.margin);
  assert.equal(parseCssToFlutterTheme(':root { --td-size-6: 24px; --td-spacer-2: 19px; }').margin.spacer2, 19);
});

test('preserves numeric round radius and clears external and inset shadows', () => {
  const theme = parseCssToFlutterTheme(`:root {
    --td-radius-round: 25px;
    --td-radius-circle: 50%;
    --td-shadow-1: none;
    --td-shadow-inset-top: inset 0 2px 0 0 #123;
    --td-shadow-inset-left: none;
  }`);
  assert.equal(theme.radius.radiusRound, 25);
  assert.equal(theme.radius.radiusCircle, 9999);
  assert.deepEqual(theme.shadow.shadow1, []);
  assert.deepEqual(theme.insetShadow.shadowInsetTop, { color: '#112233', width: 2 });
  assert.deepEqual(theme.insetShadow.shadowInsetLeft, { color: '#00000000', width: 0 });
});

test('updates independent font metrics used directly by components', () => {
  const theme = parseCssToFlutterTheme(':root { --td-font-size-body-medium: 18px; --td-line-height-body-medium: 27px; }');
  assert.equal(theme.fontMetric.fontSizeBodyMedium, 18);
  assert.equal(theme.fontMetric.lineHeightBodyMedium, 27);
  assert.deepEqual(theme.font.fontBodyMedium, { size: 18, lineHeight: 27, fontWeight: 4 });
});

test('compares persisted controller overrides against pristine package defaults', () => {
  const baseline = loadControllerBaseline();
  const untouched = generateFlutterThemeFromParts(baseline.light, baseline.dark, baseline.extra, baseline);
  for (const group of Object.values(untouched.light)) assert.deepEqual(group, {});
  const persisted = baseline.extra.replace(/(--td-font-size-body-large:\s*)[^;]+;/, '$118px;');
  const restored = generateFlutterThemeFromParts(baseline.light, baseline.dark, persisted, baseline);
  assert.equal(restored.light.fontMetric.fontSizeBodyLarge, 18);
  assert.equal(restored.dark.fontMetric.fontSizeBodyLarge, 18);
});

test('controller defaults emit only global tokens consumed by current Flutter', () => {
  const baseline = loadControllerBaseline();
  const theme = generateFlutterThemeFromParts(baseline.light, baseline.dark, baseline.extra).light;
  const files = {
    color: 't_colors.dart', ref: 't_colors.dart', font: 't_fonts.dart',
    fontMetric: 't_fonts.dart', radius: 't_radius.dart', shadow: 't_shadows.dart',
    insetShadow: 't_shadows.dart', margin: 't_spacers.dart',
  };
  for (const [group, file] of Object.entries(files)) {
    const source = readFileSync(new URL(`../../../tdesign-component/lib/src/theme/${file}`, import.meta.url), 'utf8');
    const getters = new Set([...source.matchAll(/\bget (\w+)/g)].map(match => match[1]));
    for (const key of Object.keys(theme[group])) {
      assert.ok(getters.has(key), `${group}.${key} has no current Flutter consumer`);
    }
  }
});

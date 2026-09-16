import assert from 'node:assert/strict';
import test from 'node:test';

import {
  ensureFlutterThemeTokenCoverage,
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
  assert.deepEqual(unchanged, { ref: {}, color: {}, font: {}, radius: {}, shadow: {}, margin: {} });

  const changed = baseline.replace('#0052d9', '#112233').replace('16px', '18px');
  const theme = parseCssToFlutterTheme(changed, baseline);
  assert.deepEqual(theme.color, { brandColor7: '#112233' });
  assert.equal(theme.ref.brandNormalColor, 'brandColor7');
  assert.equal(theme.font.fontBodyLarge.size, 18);
  assert.equal(theme.font.fontBodyExtraLarge.size, 20);
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

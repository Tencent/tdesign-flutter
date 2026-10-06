// Controller CSS completion and browser message adaptation only.
const FLUTTER_EXTRA_DEFAULTS = `
  --td-line-height-link-small: 20px;
  --td-line-height-link-medium: 22px;
  --td-line-height-link-large: 24px;
  --td-line-height-mark-extraSmall: 16px;
  --td-line-height-mark-small: 20px;
  --td-line-height-mark-medium: 22px;
  --td-line-height-mark-large: 24px;
  --td-line-height-body-extraSmall: 16px;
  --td-line-height-body-small: 20px;
  --td-line-height-body-medium: 22px;
  --td-line-height-body-large: 24px;
  --td-line-height-body-extraLarge: 26px;
  --td-line-height-title-small: 22px;
  --td-line-height-title-medium: 24px;
  --td-line-height-title-large: 26px;
  --td-line-height-title-extraLarge: 28px;
  --td-line-height-headline-small: 32px;
  --td-line-height-headline-medium: 36px;
  --td-line-height-headline-large: 44px;
  --td-line-height-display-medium: 56px;
  --td-line-height-display-large: 72px;
  --td-size-1: 2px;
  --td-size-2: 4px;
  --td-size-3: 6px;
  --td-size-4: 8px;
  --td-size-5: 12px;
  --td-size-6: 16px;
  --td-size-7: 20px;
  --td-size-8: 24px;
  --td-size-9: 28px;
  --td-size-10: 32px;
  --td-size-11: 36px;
  --td-size-12: 40px;
  --td-size-13: 48px;
  --td-size-14: 56px;
  --td-size-15: 64px;
  --td-size-16: 72px;
  --td-comp-size-xxxs: var(--td-size-6);
  --td-comp-size-xxs: var(--td-size-7);
  --td-comp-size-xs: var(--td-size-8);
  --td-comp-size-s: var(--td-size-9);
  --td-comp-size-m: var(--td-size-10);
  --td-comp-size-l: var(--td-size-11);
  --td-comp-size-xl: var(--td-size-12);
  --td-comp-size-xxl: var(--td-size-13);
  --td-comp-size-xxxl: var(--td-size-14);
  --td-comp-size-xxxxl: var(--td-size-15);
  --td-comp-size-xxxxxl: var(--td-size-16);
  --td-pop-padding-s: var(--td-size-2);
  --td-pop-padding-m: var(--td-size-3);
  --td-pop-padding-l: var(--td-size-4);
  --td-pop-padding-xl: var(--td-size-5);
  --td-pop-padding-xxl: var(--td-size-6);
  --td-comp-paddingLR-xxs: var(--td-size-1);
  --td-comp-paddingLR-xs: var(--td-size-2);
  --td-comp-paddingLR-s: var(--td-size-4);
  --td-comp-paddingLR-m: var(--td-size-5);
  --td-comp-paddingLR-l: var(--td-size-6);
  --td-comp-paddingLR-xl: var(--td-size-8);
  --td-comp-paddingLR-xxl: var(--td-size-10);
  --td-comp-paddingTB-xxs: var(--td-size-1);
  --td-comp-paddingTB-xs: var(--td-size-2);
  --td-comp-paddingTB-s: var(--td-size-4);
  --td-comp-paddingTB-m: var(--td-size-5);
  --td-comp-paddingTB-l: var(--td-size-6);
  --td-comp-paddingTB-xl: var(--td-size-8);
  --td-comp-paddingTB-xxl: var(--td-size-10);
  --td-comp-margin-xxs: var(--td-size-1);
  --td-comp-margin-xs: var(--td-size-2);
  --td-comp-margin-s: var(--td-size-4);
  --td-comp-margin-m: var(--td-size-5);
  --td-comp-margin-l: var(--td-size-6);
  --td-comp-margin-xl: var(--td-size-7);
  --td-comp-margin-xxl: var(--td-size-8);
  --td-comp-margin-xxxl: var(--td-size-10);
  --td-comp-margin-xxxxl: var(--td-size-12);
`;

export function ensureFlutterThemeTokenCoverage(cssText) {
  const variables = new Map([...cssText.matchAll(/(--td-[\w-]+)\s*:/g)].map((match) => [match[1], true]));
  const defaults = new Map([...FLUTTER_EXTRA_DEFAULTS.matchAll(/(--td-[\w-]+)\s*:\s*([^;]+);/g)].map((match) => [match[1], match[2].trim()]));
  const missing = [...defaults].filter(([name]) => !variables.has(name));
  if (missing.length === 0) return cssText;
  const declarations = missing.map(([name, value]) => `  ${name}: ${value};`).join('\n');
  return `${cssText || ''}\n:root {\n${declarations}\n}\n`;
}

export function createFlutterCssThemeMessage(css, themeMode, baseline) {
  return {
    type: 'flutter-css-theme-update',
    themeMode: themeMode === 'dark' ? 'dark' : 'light',
    css: { ...css, extra: ensureFlutterThemeTokenCoverage(css.extra || '') },
    baseline: { ...baseline, extra: ensureFlutterThemeTokenCoverage(baseline.extra || '') },
  };
}

const COLOR_TOKEN_PREFIXES = ['primary', 'brand', 'warning', 'error', 'success', 'gray'];

const SEMANTIC_COLOR_TOKENS = {
  '--td-brand-color': ['brandColor'],
  '--td-brand-color-focus': ['brandColorFocus'],
  '--td-brand-color-active': ['brandColorActive'],
  '--td-brand-color-disabled': ['brandColorDisabled'],
  '--td-brand-color-light': ['brandColorLight'],
  '--td-brand-color-light-hover': ['brandColorLightActive'],
  '--td-brand-color-light-active': ['brandColorLightActive'],
  '--td-warning-color': ['warningColor'],
  '--td-warning-color-focus': ['warningColorFocus'],
  '--td-warning-color-active': ['warningColorActive'],
  '--td-warning-color-disabled': ['warningColorDisabled'],
  '--td-warning-color-light': ['warningColorLight'],
  '--td-warning-color-light-hover': ['warningColorLightActive'],
  '--td-warning-color-light-active': ['warningColorLightActive'],
  '--td-error-color': ['errorColor'],
  '--td-error-color-focus': ['errorColorFocus'],
  '--td-error-color-active': ['errorColorActive'],
  '--td-error-color-disabled': ['errorColorDisabled'],
  '--td-error-color-light': ['errorColorLight'],
  '--td-error-color-light-hover': ['errorColorLightActive'],
  '--td-error-color-light-active': ['errorColorLightActive'],
  '--td-success-color': ['successColor'],
  '--td-success-color-focus': ['successColorFocus'],
  '--td-success-color-active': ['successColorActive'],
  '--td-success-color-disabled': ['successColorDisabled'],
  '--td-success-color-light': ['successColorLight'],
  '--td-success-color-light-hover': ['successColorLightActive'],
  '--td-success-color-light-active': ['successColorLightActive'],
  '--td-bg-color-page': ['bgColorPage'],
  '--td-bg-color-container': ['bgColorContainer'],
  '--td-bg-color-container-active': ['bgColorContainerActive'],
  '--td-bg-color-secondarycontainer': ['bgColorSecondaryContainer'],
  '--td-bg-color-secondarycontainer-active': ['bgColorSecondaryContainerActive'],
  '--td-bg-color-component': ['bgColorComponent'],
  '--td-bg-color-component-active': ['bgColorComponentActive'],
  '--td-bg-color-component-disabled': ['bgColorComponentDisabled'],
  '--td-bg-color-secondarycomponent': ['bgColorSecondaryComponent'],
  '--td-bg-color-secondarycomponent-active': ['bgColorSecondaryComponentActive'],
  '--td-bg-color-specialcomponent': ['bgColorSpecialComponent'],
  '--td-text-color-primary': ['textColorPrimary'],
  '--td-text-color-secondary': ['textColorSecondary'],
  '--td-text-color-placeholder': ['textColorPlaceholder'],
  '--td-text-color-disabled': ['textColorDisabled'],
  '--td-text-color-brand': ['textColorBrand'],
  '--td-text-color-link': ['textColorLink'],
  '--td-text-color-anti': ['textColorAnti'],
  '--td-mask-active': ['maskActive'],
  '--td-mask-disabled': ['maskDisabled'],
  '--td-component-stroke': ['componentStroke'],
  '--td-component-border': ['componentBorder'],
  '--td-border-level-1-color': ['borderLevel1Color'],
  '--td-border-level-2-color': ['borderLevel2Color'],
};

const FONT_SPECS = [
  ['fontDisplayLarge', 'display-large', 0, 64, 'display-large', 72, 6],
  ['fontDisplayMedium', 'display-medium', 0, 48, 'display-medium', 56, 6],
  ['fontHeadlineLarge', 'headline-large', 0, 36, 'headline-large', 44, 6],
  ['fontHeadlineMedium', 'headline-medium', 0, 28, 'headline-medium', 36, 6],
  ['fontHeadlineSmall', 'headline-small', 0, 24, 'headline-small', 32, 6],
  // Mobile CSS has fewer typography levels than Flutter. Keep every Flutter
  // token controllable by deriving the adjacent level from the same slider.
  ['fontTitleExtraLarge', 'title-large', 0, 20, 'title-extraLarge', 28, 6],
  ['fontTitleLarge', 'title-large', -2, 18, 'title-large', 26, 6],
  ['fontTitleMedium', 'title-medium', 0, 16, 'title-medium', 24, 6],
  ['fontTitleSmall', 'title-small', 0, 14, 'title-small', 22, 4],
  ['fontBodyLarge', 'body-large', 0, 16, 'body-large', 24, 4],
  ['fontBodyMedium', 'body-medium', 0, 14, 'body-medium', 22, 4],
  ['fontBodySmall', 'body-small', 0, 12, 'body-small', 20, 4],
  ['fontBodyExtraSmall', 'body-small', -2, 10, 'body-extraSmall', 16, 4],
  ['fontMarkLarge', 'mark-medium', 2, 16, 'mark-large', 24, 6],
  ['fontMarkMedium', 'mark-medium', 0, 14, 'mark-medium', 22, 6],
  ['fontMarkSmall', 'mark-small', 0, 12, 'mark-small', 20, 6],
  ['fontMarkExtraSmall', 'mark-small', -2, 10, 'mark-extraSmall', 16, 6],
  ['fontLinkLarge', 'link-large', 0, 16, 'link-large', 24, 4],
  ['fontLinkMedium', 'link-medium', 0, 14, 'link-medium', 22, 4],
  ['fontLinkSmall', 'link-small', 0, 12, 'link-small', 20, 4],
];

const RADIUS_TOKENS = {
  radiusSmall: '--td-radius-small',
  radiusDefault: '--td-radius-default',
  radiusLarge: '--td-radius-large',
  radiusExtraLarge: '--td-radius-extraLarge',
  radiusRound: '--td-radius-round',
  radiusCircle: '--td-radius-circle',
};

const SHADOW_TOKENS = {
  shadow1: '--td-shadow-1',
  shadow2: '--td-shadow-2',
  shadow3: '--td-shadow-3',
  shadow4: '--td-shadow-4',
};

const SPACER_SOURCES = {
  spacer: ['--td-spacer', '--td-size-4'],
  spacer1: ['--td-spacer-1', '--td-size-5'],
  spacer2: ['--td-spacer-2', '--td-size-6'],
  spacer3: ['--td-spacer-3', '--td-size-8'],
  spacer4: ['--td-spacer-4', '--td-size-10'],
  spacer5: ['--td-spacer-5', '--td-size-13'],
  spacer6: ['--td-spacer-6', '--td-size-15', 1.25],
};

const INSET_SHADOW_TOKENS = {
  shadowInsetTop: '--td-shadow-inset-top',
  shadowInsetRight: '--td-shadow-inset-right',
  shadowInsetBottom: '--td-shadow-inset-bottom',
  shadowInsetLeft: '--td-shadow-inset-left',
};

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

export function parseCssVariables(cssText) {
  const variables = new Map();
  const expression = /(--td-[\w-]+)\s*:\s*([^;]+);/g;
  let match;
  while ((match = expression.exec(cssText || '')) !== null) {
    variables.set(match[1], match[2].replace(/\s*!important\s*$/, '').trim());
  }
  return variables;
}

export function ensureFlutterThemeTokenCoverage(cssText) {
  const variables = parseCssVariables(cssText);
  const defaults = parseCssVariables(`:root {${FLUTTER_EXTRA_DEFAULTS}}`);
  const missing = [...defaults].filter(([name]) => !variables.has(name));
  if (missing.length === 0) return cssText;
  const declarations = missing.map(([name, value]) => `  ${name}: ${value};`).join('\n');
  return `${cssText || ''}\n:root {\n${declarations}\n}\n`;
}

function cssNameToFlutterColor(cssName) {
  const palette = cssName.match(/^--td-(primary|brand|warning|error|success|gray)-color-(\d+)$/);
  if (palette && COLOR_TOKEN_PREFIXES.includes(palette[1])) {
    return `${palette[1]}Color${palette[2]}`;
  }
  const white = cssName.match(/^--td-font-white-(\d+)$/);
  if (white) return `fontWhite${white[1]}`;
  const gray = cssName.match(/^--td-font-gray-(\d+)$/);
  if (gray) return `fontGray${gray[1]}`;
  return null;
}

function clampChannel(value) {
  return Math.min(255, Math.max(0, Math.round(value)));
}

function hexByte(value) {
  return clampChannel(value).toString(16).padStart(2, '0').toUpperCase();
}

export function normalizeCssColor(value) {
  const input = value?.trim();
  if (!input) return null;
  if (input.toLowerCase() === 'transparent') return '#00000000';
  const hex = input.match(/^#([\da-f]+)$/i)?.[1];
  if (hex) {
    if (hex.length === 3)
      return `#${[...hex]
        .map((part) => part + part)
        .join('')
        .toUpperCase()}`;
    if (hex.length === 4) {
      const [r, g, b, a] = [...hex].map((part) => part + part);
      return `#${a}${r}${g}${b}`.toUpperCase();
    }
    if (hex.length === 6) return `#${hex.toUpperCase()}`;
    if (hex.length === 8) return `#${hex.slice(6)}${hex.slice(0, 6)}`.toUpperCase();
    return null;
  }
  const rgb = input.match(/^rgba?\(\s*([\d.]+)[,\s]+([\d.]+)[,\s]+([\d.]+)(?:\s*[,/]\s*([\d.]+%?))?\s*\)$/i);
  if (!rgb) return null;
  const alphaText = rgb[4] ?? '1';
  const alpha = alphaText.endsWith('%')
    ? (Number.parseFloat(alphaText) * 255) / 100
    : Number.parseFloat(alphaText) * 255;
  return `#${hexByte(alpha)}${hexByte(Number(rgb[1]))}${hexByte(Number(rgb[2]))}${hexByte(Number(rgb[3]))}`;
}

function referencedVariable(value) {
  return value?.match(/^var\(\s*(--td-[\w-]+)/)?.[1] ?? null;
}

function resolveValue(name, variables, seen = new Set()) {
  if (!name || seen.has(name)) return null;
  const value = variables.get(name);
  if (!value) return null;
  const reference = referencedVariable(value);
  if (!reference) return value;
  seen.add(name);
  return resolveValue(reference, variables, seen);
}

function resolveLeafColorToken(name, variables, seen = new Set()) {
  if (!name || seen.has(name)) return null;
  const flutterName = cssNameToFlutterColor(name);
  if (flutterName) return flutterName;
  const reference = referencedVariable(variables.get(name));
  if (!reference) return null;
  seen.add(name);
  return resolveLeafColorToken(reference, variables, seen);
}

function variableChainChanged(name, variables, baselineVariables, seen = new Set()) {
  if (!baselineVariables || !name || seen.has(name)) return !baselineVariables;
  if (variables.get(name) !== baselineVariables.get(name)) return true;
  const reference = referencedVariable(variables.get(name));
  if (!reference) return false;
  seen.add(name);
  return variableChainChanged(reference, variables, baselineVariables, seen);
}

function parseLength(name, variables) {
  const value = resolveValue(name, variables);
  if (!value || value.endsWith('%')) return null;
  const match = value.match(/^(-?[\d.]+)(?:px)?$/i);
  return match ? Number(match[1]) : null;
}

function splitTopLevel(value) {
  const parts = [];
  let depth = 0;
  let start = 0;
  for (let index = 0; index < value.length; index += 1) {
    if (value[index] === '(') depth += 1;
    if (value[index] === ')') depth -= 1;
    if (value[index] === ',' && depth === 0) {
      parts.push(value.slice(start, index));
      start = index + 1;
    }
  }
  parts.push(value.slice(start));
  return parts;
}

function parseShadow(value, variables) {
  if (!value || value === 'none') return [];
  return splitTopLevel(value).flatMap((part) => {
    const input = part.trim();
    if (input.startsWith('inset')) return [];
    const match = input.match(
      /^(-?[\d.]+)(?:px)?\s+(-?[\d.]+)(?:px)?\s+([\d.]+)(?:px)?(?:\s+(-?[\d.]+)(?:px)?)?\s+(.+)$/,
    );
    if (!match) return [];
    const colorValue = referencedVariable(match[5]) ? resolveValue(referencedVariable(match[5]), variables) : match[5];
    const color = normalizeCssColor(colorValue);
    if (!color) return [];
    return [
      {
        color,
        blurRadius: Number(match[3]),
        spreadRadius: Number(match[4] ?? 0),
        offset: { x: Number(match[1]), y: Number(match[2]) },
      },
    ];
  });
}

export function parseCssToFlutterTheme(cssText, baselineCssText = null) {
  const variables = parseCssVariables(cssText);
  const baselineVariables = baselineCssText === null ? null : parseCssVariables(baselineCssText);
  const changed = (name) => variableChainChanged(name, variables, baselineVariables);
  const color = {};
  const ref = {};

  variables.forEach((value, cssName) => {
    const flutterName = cssNameToFlutterColor(cssName);
    if (!flutterName || !changed(cssName)) return;
    const normalized = normalizeCssColor(resolveValue(cssName, variables));
    if (normalized) color[flutterName] = normalized;
  });

  Object.entries(SEMANTIC_COLOR_TOKENS).forEach(([cssName, flutterNames]) => {
    if (!variables.has(cssName) || !changed(cssName)) return;
    const leaf = resolveLeafColorToken(cssName, variables);
    const directColor = normalizeCssColor(resolveValue(cssName, variables));
    flutterNames.forEach((flutterName) => {
      if (cssName.startsWith('--td-border-level-') && (ref[flutterName] || color[flutterName])) return;
      if (leaf) {
        ref[flutterName] = leaf;
      } else if (directColor) {
        color[flutterName] = directColor;
        ref[flutterName] = flutterName;
      }
    });
  });

  const font = {};
  const fontMetric = {};
  FONT_SPECS.forEach(
    ([name, sizeSuffix, sizeOffset, defaultSize, lineHeightSuffix, defaultLineHeight, fontWeight]) => {
      const sizeToken = `--td-font-size-${sizeSuffix}`;
      const lineHeightToken = `--td-line-height-${lineHeightSuffix}`;
      if (!changed(sizeToken) && !changed(lineHeightToken)) return;
      const sourceSize = parseLength(sizeToken, variables);
      const size = sourceSize === null ? defaultSize : sourceSize + sizeOffset;
      const lineHeight = parseLength(lineHeightToken, variables) ?? defaultLineHeight;
      if (!(size > 0) || !(lineHeight > 0)) return;
      font[name] = { size, lineHeight, fontWeight };
      const suffix = name.slice('font'.length);
      fontMetric[`fontSize${suffix}`] = size;
      fontMetric[`lineHeight${suffix}`] = lineHeight;
    },
  );

  const radius = {};
  Object.entries(RADIUS_TOKENS).forEach(([name, cssName]) => {
    if (!changed(cssName)) return;
    const rawValue = resolveValue(cssName, variables);
    const value = parseLength(cssName, variables);
    if (name === 'radiusCircle' && rawValue?.endsWith('%')) {
      radius[name] = 9999;
    } else if (value !== null && value >= 0) {
      radius[name] = value;
    }
  });

  const shadow = {};
  Object.entries(SHADOW_TOKENS).forEach(([name, cssName]) => {
    if (!changed(cssName)) return;
    const parsed = parseShadow(resolveValue(cssName, variables), variables);
    if (parsed.length > 0 || resolveValue(cssName, variables) === 'none') shadow[name] = parsed;
  });

  const insetShadow = {};
  Object.entries(INSET_SHADOW_TOKENS).forEach(([name, cssName]) => {
    if (!changed(cssName)) return;
    const raw = resolveValue(cssName, variables);
    if (raw === 'none') {
      insetShadow[name] = { color: '#00000000', width: 0 };
      return;
    }
    const parsed = parseShadow(raw?.replace(/^inset\s+/, ''), variables);
    const edge = parsed[0];
    if (parsed.length === 1 && edge.blurRadius === 0 && edge.spreadRadius === 0) {
      insetShadow[name] = { color: edge.color, width: Math.abs(edge.offset.x || edge.offset.y) };
    }
  });

  const margin = {};
  Object.entries(SPACER_SOURCES).forEach(([name, [nativeCss, controllerCss, scale = 1]]) => {
    const explicit = variables.has(nativeCss);
    const cssName = explicit ? nativeCss : controllerCss;
    if (!changed(cssName)) return;
    const value = parseLength(cssName, variables);
    if (value !== null && value >= 0) margin[name] = value * (explicit ? 1 : scale);
  });

  return { ref, color, font, fontMetric, radius, shadow, insetShadow, margin };
}

export function generateFlutterThemeFromParts(lightCss, darkCss, extraCss, baseline = null) {
  const sharedCss = ensureFlutterThemeTokenCoverage(extraCss);
  const baselineSharedCss = baseline ? ensureFlutterThemeTokenCoverage(baseline.extra) : null;
  return {
    light: parseCssToFlutterTheme(
      `${lightCss || ''}\n${sharedCss}`,
      baseline ? `${baseline.light || ''}\n${baselineSharedCss}` : null,
    ),
    dark: parseCssToFlutterTheme(
      `${darkCss || ''}\n${sharedCss}`,
      baseline ? `${baseline.dark || ''}\n${baselineSharedCss}` : null,
    ),
  };
}

export function createFlutterThemeMessage(theme, themeMode = 'light') {
  return {
    type: 'flutter-theme-update',
    themeMode: themeMode === 'dark' ? 'dark' : 'light',
    theme,
  };
}

export const flutterThemeContract = Object.freeze({
  fontTokens: FONT_SPECS.map(([name]) => name),
  radiusTokens: Object.keys(RADIUS_TOKENS),
  shadowTokens: Object.keys(SHADOW_TOKENS),
  insetShadowTokens: Object.keys(INSET_SHADOW_TOKENS),
  spacerTokens: Object.keys(SPACER_SOURCES),
});

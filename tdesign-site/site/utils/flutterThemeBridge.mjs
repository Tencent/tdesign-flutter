// Controller CSS completion and browser message adaptation only.
export function ensureFlutterThemeTokenCoverage(cssText, extraDefaults) {
  const variables = new Map([...cssText.matchAll(/(--td-[\w-]+)\s*:/g)].map((match) => [match[1], true]));
  const defaults = new Map([...extraDefaults.matchAll(/(--td-[\w-]+)\s*:\s*([^;]+);/g)].map((match) => [match[1], match[2].trim()]));
  const missing = [...defaults].filter(([name]) => !variables.has(name));
  if (missing.length === 0) return cssText;
  const declarations = missing.map(([name, value]) => `  ${name}: ${value};`).join('\n');
  return `${cssText || ''}\n:root {\n${declarations}\n}\n`;
}

export function createFlutterCssThemeMessage(css, themeMode, baseline, extraDefaults) {
  return {
    type: 'flutter-css-theme-update',
    themeMode: themeMode === 'dark' ? 'dark' : 'light',
    css: { ...css, extra: ensureFlutterThemeTokenCoverage(css.extra || '', extraDefaults) },
    baseline: { ...baseline, extra: ensureFlutterThemeTokenCoverage(baseline.extra || '', extraDefaults) },
  };
}

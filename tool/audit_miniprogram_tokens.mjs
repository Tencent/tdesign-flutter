import fs from 'node:fs';
import path from 'node:path';
import { execFileSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';

// Usage: node tool/audit_miniprogram_tokens.mjs /path/to/tdesign-miniprogram
// Archive snapshots without .git may pass --miniprogram-commit=<source SHA>.
const flutterRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const miniRoot = process.argv[2] && path.resolve(process.argv[2]);
const markdownTable = process.argv.find(arg => arg.startsWith('--markdown='))?.slice('--markdown='.length);
const outputFile = process.argv.find(arg => arg.startsWith('--output='))?.slice('--output='.length);
if (!miniRoot || !fs.existsSync(path.join(miniRoot, 'packages/components/common/style/theme/_light.less'))) {
  throw new Error('Pass a tdesign-miniprogram checkout as the first argument.');
}
const snapshotCommit = process.argv.find(arg => arg.startsWith('--miniprogram-commit='))?.slice('--miniprogram-commit='.length);
if (snapshotCommit && !/^[a-f0-9]{40}$/.test(snapshotCommit)) {
  throw new Error('Expected a 40-character source SHA for --miniprogram-commit.');
}
const miniprogramCommit = snapshotCommit ??
  execFileSync('git', ['rev-parse', 'HEAD'], { cwd: miniRoot, encoding: 'utf8' }).trim();
const themeDir = path.join(miniRoot, 'packages/components/common/style/theme');
const flutterSource = fs.readFileSync(path.join(flutterRoot, 'tdesign-component/lib/src/theme/t_default_theme.dart'), 'utf8');
const flutterTheme = JSON.parse(flutterSource.match(/\x27{3}([\s\S]*?)\x27{3}/)[1]);
const compoundNames = new Map([
  ['bgColorSecondarycontainer', 'bgColorSecondaryContainer'],
  ['bgColorSecondarycontainerActive', 'bgColorSecondaryContainerActive'],
  ['bgColorSecondarycomponent', 'bgColorSecondaryComponent'],
  ['bgColorSecondarycomponentActive', 'bgColorSecondaryComponentActive'],
  ['bgColorSpecialcomponent', 'bgColorSpecialComponent'],
]);
const kebabToCamel = key => {
  const direct = key.replace(/-([a-z0-9])/g, (_, letter) => letter.toUpperCase());
  return compoundNames.get(direct) ?? direct;
};
const miniFiles = fs.readdirSync(themeDir).filter(name =>
  name.endsWith('.less') && name !== '_index.less' && name !== '_components.less');
const miniComponentOverrides = [...fs.readFileSync(path.join(themeDir, '_components.less'), 'utf8')
  .matchAll(/--td-([\w-]+)\s*:/g)].map(match => kebabToCamel(match[1]));
const miniTokens = new Map();
for (const name of miniFiles) {
  const source = fs.readFileSync(path.join(themeDir, name), 'utf8');
  for (const match of source.matchAll(/--td-([\w-]+)\s*:\s*([^;]+);/g)) {
    const key = kebabToCamel(match[1]);
    const entry = miniTokens.get(key) ?? [];
    entry.push({ file: name, value: match[2].trim() });
    miniTokens.set(key, entry);
  }
}
const flutterKeys = new Set(Object.values(flutterTheme).flatMap(theme => Object.values(theme).flatMap(group => Object.keys(group))));
const miniKeys = new Set(miniTokens.keys());
const common = [...flutterKeys].filter(key => miniKeys.has(key)).sort();
const flutterOnly = [...flutterKeys].filter(key => !miniKeys.has(key)).sort();
const miniOnly = [...miniKeys].filter(key => !flutterKeys.has(key)).sort();
const componentVarNames = new Set();
const componentVariables = new Map();
const componentSourceLines = new Map();
const componentCounts = [];
const componentsDir = path.join(miniRoot, 'packages/components');
const flutterComponentsDir = path.join(flutterRoot, 'tdesign-component/lib/src/components');
function lessFiles(dir) {
  return fs.readdirSync(dir, { withFileTypes: true }).flatMap(entry => {
    const name = path.join(dir, entry.name);
    return entry.isDirectory() ? lessFiles(name) : entry.name.endsWith('.less') ? [name] : [];
  });
}
for (const entry of fs.readdirSync(componentsDir, { withFileTypes: true })) {
  if (!entry.isDirectory() || entry.name === 'common') continue;
  const vars = new Set();
  for (const file of lessFiles(path.join(componentsDir, entry.name))) {
    const source = fs.readFileSync(file, 'utf8');
    for (const [index, line] of source.split('\n').entries()) {
      for (const match of line.matchAll(/var\(--td-([\w-]+)/g)) {
        const name = kebabToCamel(match[1]);
        if (!miniKeys.has(name)) {
          vars.add(name);
          componentVarNames.add(name);
          const usage = componentVariables.get(name) ?? new Set();
          usage.add(`${path.relative(miniRoot, file)}:${index + 1}`);
          componentVariables.set(name, usage);
          const expressions = componentSourceLines.get(name) ?? new Set();
          expressions.add(line.trim());
          componentSourceLines.set(name, expressions);
        }
      }
    }
  }
  if (vars.size) componentCounts.push({ component: entry.name, count: vars.size });
}
componentCounts.sort((a, b) => b.count - a.count);
const definitions = {};
for (const mode of ['default', 'defaultDark']) {
  const selected = mode === 'default' ? '_light.less' : '_dark.less';
  const fileNames = miniFiles.filter(name => name !== '_light.less' && name !== '_dark.less' && name !== '_components.less');
  fileNames.push('_light.less');
  if (selected !== '_light.less') fileNames.push(selected);
  const tokens = new Map();
  for (const name of fileNames) {
    const source = fs.readFileSync(path.join(themeDir, name), 'utf8');
    for (const match of source.matchAll(/--td-([\w-]+)\s*:\s*([^;]+);/g)) {
      tokens.set(kebabToCamel(match[1]), match[2].trim());
    }
  }
  definitions[mode] = tokens;
}
function resolveMini(key, mode, seen = new Set()) {
  if (seen.has(key)) return '<cycle>';
  const value = definitions[mode].get(key);
  if (!value) return undefined;
  const next = new Set([...seen, key]);
  const match = value.match(/^var\(--td-([\w-]+)\)$/);
  return match ? resolveMini(kebabToCamel(match[1]), mode, next) : value;
}
function resolveFlutter(key, mode, seen = new Set()) {
  if (seen.has(key)) return '<cycle>';
  const group = flutterTheme[mode];
  const entry = Object.values(group).find(section => Object.hasOwn(section, key)) ??
    Object.values(flutterTheme.default).find(section => Object.hasOwn(section, key));
  if (!entry) return undefined;
  const value = entry[key];
  return typeof value === 'string' && Object.values(group).some(section => Object.hasOwn(section, value))
    ? resolveFlutter(value, mode, new Set([...seen, key]))
    : value;
}
function normalize(value) {
  if (typeof value !== 'string') return value;
  if (/^-?[\d.]+$/.test(value)) return Number(value);
  const rpx = value.match(/^(-?[\d.]+)rpx$/);
  if (rpx) return Number(rpx[1]) / 2;
  const px = value.match(/^(-?[\d.]+)px$/);
  if (px) return Number(px[1]);
  const percentage = value.match(/^([\d.]+)%$/);
  if (percentage) return Number(percentage[1]) / 100;
  return value.toLowerCase().replace(/\s+/g, ' ');
}
function colorChannels(value) {
  if (typeof value !== 'string') return undefined;
  const shortHex = value.match(/^#([\da-f]{3})$/i);
  if (shortHex) {
    const rgb = [...shortHex[1]].map(channel => parseInt(channel.repeat(2), 16));
    return [...rgb, 1];
  }
  const hex = value.match(/^#([\da-f]{6}|[\da-f]{8})$/i);
  if (hex) {
    const digits = hex[1];
    const alpha = digits.length === 8 ? parseInt(digits.slice(0, 2), 16) / 255 : 1;
    const rgb = digits.length === 8 ? digits.slice(2) : digits;
    return [0, 2, 4].map(index => parseInt(rgb.slice(index, index + 2), 16)).concat(alpha);
  }
  const rgba = value.match(/^rgba\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*([\d.]+)(%)?\s*\)$/i);
  if (rgba) {
    return [Number(rgba[1]), Number(rgba[2]), Number(rgba[3]),
      Number(rgba[4]) / (rgba[5] ? 100 : 1)];
  }
  return undefined;
}
function equivalent(left, right) {
  const leftColor = colorChannels(left);
  const rightColor = colorChannels(right);
  if (leftColor && rightColor) {
    return leftColor.slice(0, 3).every((channel, index) => channel === rightColor[index]) &&
      Math.abs(leftColor[3] - rightColor[3]) <= 1 / 255;
  }
  return normalize(left) === normalize(right);
}
function splitShadowLayers(value) {
  const layers = [];
  let depth = 0;
  let start = 0;
  for (let index = 0; index < value.length; index++) {
    if (value[index] === '(') depth++;
    if (value[index] === ')') depth--;
    if (value[index] === ',' && depth === 0) {
      layers.push(value.slice(start, index).trim());
      start = index + 1;
    }
  }
  layers.push(value.slice(start).trim());
  return layers;
}
function parseShadowLayer(value) {
  const color = value.match(/rgba\([^)]*\)|#[\da-f]{3,8}/i)?.[0];
  if (!color) return undefined;
  const numbers = value.replace(color, '').replace(/\binset\b/, '').trim().split(/\s+/);
  if (numbers.length < 3 || numbers.length > 4 ||
      numbers.some(number => !/^-?[\d.]+(?:rpx|px)?$/.test(number))) return undefined;
  const [x, y, blurRadius, spreadRadius = 0] = numbers.map(normalize);
  return { x, y, blurRadius, spreadRadius, color };
}
function compareShadow(key, mini, flutter) {
  if (typeof mini !== 'string') return undefined;
  if (key.startsWith('shadowInset')) {
    const layer = parseShadowLayer(mini);
    if (!layer || !mini.includes('inset') || !flutter || Array.isArray(flutter)) return undefined;
    const expectedOffsets = {
      shadowInsetTop: [0, 0.5], shadowInsetRight: [0.5, 0],
      shadowInsetBottom: [0, -0.5], shadowInsetLeft: [-0.5, 0],
    };
    const [x, y] = expectedOffsets[key] ?? [];
    return layer.x === x && layer.y === y && layer.blurRadius === 0 &&
      layer.spreadRadius === 0 && flutter.width === Math.abs(x || y) &&
      equivalent(layer.color, flutter.color);
  }
  if (!Array.isArray(flutter)) return undefined;
  const layers = splitShadowLayers(mini).map(parseShadowLayer);
  if (layers.some(layer => !layer)) return undefined;
  return layers.length === flutter.length && layers.every((layer, index) => {
    const target = flutter[index];
    return layer.x === target.offset?.x && layer.y === target.offset?.y &&
      layer.blurRadius === target.blurRadius &&
      layer.spreadRadius === target.spreadRadius &&
      equivalent(layer.color, target.color);
  });
}
function compareFontFamily(mini, flutter) {
  if (typeof mini !== 'string' || !flutter || Array.isArray(flutter)) return undefined;
  const families = mini.split(',').map(value => value.trim());
  return families[0] === flutter.fontFamily &&
    JSON.stringify(families.slice(1)) === JSON.stringify(flutter.fallback);
}
function miniFont(key, mode) {
  const raw = definitions[mode].get(key);
  if (!raw) return undefined;
  const sizeKey = raw.match(/var\(--td-(font-size-[\w-]+)\)/)?.[1];
  const heightKey = raw.match(/var\(--td-(line-height-[\w-]+)\)/)?.[1];
  if (!sizeKey || !heightKey) return undefined;
  return {
    size: normalize(resolveMini(kebabToCamel(sizeKey), mode)),
    lineHeight: normalize(resolveMini(kebabToCamel(heightKey), mode)),
    fontWeight: raw.trim().startsWith('600') ? 6 : undefined,
  };
}
const miniComponentThemeOverrides = { default: new Map(), defaultDark: new Map() };
const componentOverrideSource = fs.readFileSync(path.join(themeDir, '_components.less'), 'utf8');
for (const match of componentOverrideSource.matchAll(/@media \(prefers-color-scheme: (light|dark)\)([\s\S]*?)(?=@media \(prefers-color-scheme:|$)/g)) {
  const mode = match[1] === 'light' ? 'default' : 'defaultDark';
  for (const variable of match[2].matchAll(/--td-([\w-]+)\s*:\s*([^;]+);/g)) {
    miniComponentThemeOverrides[mode].set(kebabToCamel(variable[1]), variable[2].trim());
  }
}
function componentFallback(name) {
  const candidates = new Set();
  for (const line of componentSourceLines.get(name) ?? []) {
    for (const match of line.matchAll(/var\(--td-([\w-]+)/g)) {
      if (kebabToCamel(match[1]) !== name) continue;
      let depth = 1;
      let comma = -1;
      let end = -1;
      for (let index = match.index + match[0].length; index < line.length; index++) {
        if (line[index] === '(') depth++;
        else if (line[index] === ')' && --depth === 0) {
          end = index;
          break;
        } else if (line[index] === ',' && depth === 1 && comma < 0) comma = index;
      }
      if (comma >= 0 && end > comma) candidates.add(line.slice(comma + 1, end).trim());
    }
  }
  return [...candidates];
}
const componentFallbacks = new Map(
  [...componentVariables.keys()].map(name => [name, componentFallback(name)]),
);
const lessDefinitions = new Map();
for (const file of lessFiles(componentsDir)) {
  const owner = path.relative(componentsDir, file).split(path.sep)[0];
  const source = fs.readFileSync(file, 'utf8');
  for (const match of source.matchAll(/@([\w-]+)\s*:\s*([^;]+);/g)) {
    const entries = lessDefinitions.get(match[1]) ?? [];
    entries.push({ owner, value: match[2].trim() });
    lessDefinitions.set(match[1], entries);
  }
}
function resolveLessExpression(value, owner, mode, seen) {
  const variable = value.match(/^var\(--([\w-]+)(?:,\s*([\s\S]+))?\)$/);
  if (variable) {
    const key = kebabToCamel(variable[1].replace(/^td-/, ''));
    if (variable[1].startsWith('td-') && definitions[mode].has(key)) {
      return String(resolveMini(key, mode));
    }
    if (variable[2]) return resolveLessExpression(variable[2], owner, mode, seen);
    return value;
  }
  const expandedLess = value.replace(/@([\w-]+)/g, (reference, lessName) => {
    const key = kebabToCamel(lessName);
    if (definitions[mode].has(key)) return String(resolveMini(key, mode));
    if (componentFallbacks.has(key)) return resolveComponentFallback(key, mode, seen);
    const candidates = lessDefinitions.get(lessName) ?? [];
    const preferred = candidates.filter(item => item.owner === owner);
    const common = candidates.filter(item => item.owner === 'common');
    const choice = preferred.length === 1 ? preferred[0] :
      common.length === 1 ? common[0] : candidates.length === 1 ? candidates[0] : undefined;
    if (!choice || seen.has(`@${lessName}`)) return reference;
    return resolveLessExpression(choice.value, owner, mode, new Set([...seen, `@${lessName}`]));
  });
  return expandedLess.replace(/var\(--td-([\w-]+)\)/g, (reference, tokenName) => {
    const key = kebabToCamel(tokenName);
    return definitions[mode].has(key) ? String(resolveMini(key, mode)) : reference;
  }).replace(/(-?[\d.]+)rpx\b/g, (_, amount) => `${Number(amount) / 2}dp`);
}
function resolveComponentFallback(name, mode, seen = new Set()) {
  if (seen.has(name)) return '<cycle>';
  const override = miniComponentThemeOverrides[mode].get(name);
  if (override !== undefined) {
    const globalReference = override.match(/^var\(--td-([\w-]+)\)$/);
    if (globalReference) return String(resolveMini(kebabToCamel(globalReference[1]), mode));
    return override;
  }
  const fallbacks = componentFallbacks.get(name) ?? [];
  if (fallbacks.length === 0) return '<no fallback>';
  if (fallbacks.length > 1) return '<conflicting fallbacks>';
  const next = new Set([...seen, name]);
  const owner = [...componentVariables.get(name)][0].split('/')[2];
  return resolveLessExpression(fallbacks[0], owner, mode, next);
}
function conflictingComponentDefaults(name, mode) {
  const fallbacks = componentFallbacks.get(name) ?? [];
  if (fallbacks.length < 2) return [];
  const owner = [...componentVariables.get(name)][0].split('/')[2];
  return fallbacks.map(value => resolveLessExpression(value, owner, mode, new Set([name])));
}
function dartFiles(dir) {
  return fs.readdirSync(dir, { withFileTypes: true }).flatMap(entry => {
    const name = path.join(dir, entry.name);
    return entry.isDirectory() ? dartFiles(name) : entry.name.endsWith('.dart') ? [name] : [];
  });
}
const flutterSources = new Map();
const flutterThemeFields = [];
for (const entry of fs.readdirSync(flutterComponentsDir, { withFileTypes: true })) {
  if (!entry.isDirectory()) continue;
  const dir = path.join(flutterComponentsDir, entry.name);
  flutterSources.set(entry.name, dartFiles(dir).map(file => fs.readFileSync(file, 'utf8')).join('\n'));
  for (const file of dartFiles(dir).filter(file => file.endsWith('theme_data.dart'))) {
    const source = fs.readFileSync(file, 'utf8');
    for (const match of source.matchAll(/\bfinal\s+[\w<>?, ]+\s+(\w+)\s*;/g)) {
      const prefix = kebabToCamel(entry.name.replaceAll('_', '-'));
      const candidate = prefix + match[1].replace(/^./, first => first.toUpperCase());
      flutterThemeFields.push({
        component: entry.name,
        field: match[1],
        file: path.relative(flutterRoot, file),
        sameNameMiniVariable: componentVarNames.has(candidate) ? candidate : null,
      });
    }
  }
}
const flutterThemeCandidates = new Map();
for (const field of flutterThemeFields) {
  if (!field.sameNameMiniVariable) continue;
  const candidates = flutterThemeCandidates.get(field.sameNameMiniVariable) ?? [];
  candidates.push(`${field.component}.${field.field}`);
  flutterThemeCandidates.set(field.sameNameMiniVariable, candidates);
}
const flutterThemeSource = fs.readdirSync(path.join(flutterRoot, 'tdesign-component/lib/src/theme'))
  .filter(name => name.endsWith('.dart'))
  .map(name => fs.readFileSync(path.join(flutterRoot, 'tdesign-component/lib/src/theme', name), 'utf8'))
  .join('\n');
function miniReference(key, mode) {
  const raw = definitions[mode].get(key);
  const match = raw?.match(/^var\(--td-([\w-]+)\)$/);
  return match ? kebabToCamel(match[1]) : null;
}
function flutterReference(key, mode) {
  return flutterTheme[mode].ref?.[key] ?? flutterTheme.default.ref?.[key] ?? null;
}
const referenceMismatches = {};
for (const mode of ['default', 'defaultDark']) {
  referenceMismatches[mode] = common.flatMap(key => {
    const mini = miniReference(key, mode);
    const flutter = flutterReference(key, mode);
    return mini === flutter ? [] : [{ key, mini, flutter }];
  });
}
const missingGetters = common.filter(key =>
  !new RegExp(`\\bget\\s+${key}\\b`).test(flutterThemeSource));
const rawMismatches = {};
const uncomparable = {};
for (const mode of ['default', 'defaultDark']) {
  uncomparable[mode] = [];
  rawMismatches[mode] = common.flatMap(key => {
    const mini = resolveMini(key, mode);
    const flutter = resolveFlutter(key, mode);
    if (mini === undefined || flutter === undefined) {
      uncomparable[mode].push({ key, mini, flutter, reason: 'missing-mode-value' });
      return [];
    }
    if (typeof flutter === 'object') {
      let matches;
      let miniValue = mini;
      if (key.startsWith('shadow')) matches = compareShadow(key, mini, flutter);
      else if (key.startsWith('fontFamily')) matches = compareFontFamily(mini, flutter);
      else if (key.startsWith('font')) {
        miniValue = miniFont(key, mode);
        matches = miniValue && ['size', 'lineHeight', 'fontWeight']
          .every(field => miniValue[field] === flutter[field]);
      }
      if (matches === undefined) {
        uncomparable[mode].push({ key, mini, flutter, reason: 'unsupported-object' });
        return [];
      }
      return matches ? [] : [{ key, mini: miniValue, flutter }];
    }
    return equivalent(mini, flutter) ? [] : [{ key, mini, flutter }];
  });
}
// 保留原始差异，不把获批的跨平台几何例外伪装成同值。
const allowedGlobalValueExceptions = {
  radiusCircle: '小程序 CSS 50%；Flutter 固定 9999dp 圆角',
};
const unexpectedRawMismatches = Object.fromEntries(
  Object.entries(rawMismatches).map(([mode, items]) => [
    mode,
    items.filter(item => !Object.hasOwn(allowedGlobalValueExceptions, item.key)),
  ]),
);
const globalRows = common.map(key => {
  const group = Object.entries(flutterTheme.default).find(([, section]) => Object.hasOwn(section, key))?.[0];
  const lightValue = resolveFlutter(key, 'default');
  const darkValue = resolveFlutter(key, 'defaultDark');
  const mismatch = rawMismatches.default.some(item => item.key === key) ||
    rawMismatches.defaultDark.some(item => item.key === key);
  const referenceMismatch = referenceMismatches.default.some(item => item.key === key) ||
    referenceMismatches.defaultDark.some(item => item.key === key);
  return {
    key,
    group,
    miniSources: [...new Set((miniTokens.get(key) ?? []).map(item => item.file))].sort(),
    miniLightRaw: definitions.default.get(key),
    miniDarkRaw: definitions.defaultDark.get(key),
    miniLightResolved: resolveMini(key, 'default'),
    miniDarkResolved: resolveMini(key, 'defaultDark'),
    flutterLightRaw: flutterTheme.default[group]?.[key],
    flutterDarkRaw: flutterTheme.defaultDark[group]?.[key] ?? flutterTheme.default[group]?.[key],
    flutterLightResolved: lightValue,
    flutterDarkResolved: darkValue,
    miniLightReference: miniReference(key, 'default'),
    miniDarkReference: miniReference(key, 'defaultDark'),
    flutterLightReference: flutterReference(key, 'default'),
    flutterDarkReference: flutterReference(key, 'defaultDark'),
    getterAvailable: !missingGetters.includes(key),
    status: mismatch && allowedGlobalValueExceptions[key]
      ? `已批准值差：${allowedGlobalValueExceptions[key]}` :
      mismatch ? '值/几何差异' : referenceMismatch ? '引用链差异' :
      missingGetters.includes(key) ? '缺少同名 getter' :
      uncomparable.default.some(item => item.key === key) ||
      uncomparable.defaultDark.some(item => item.key === key) ? '未完成值比较' :
      (typeof lightValue === 'object' || typeof darkValue === 'object' || key.startsWith('shadow'))
        ? '平台表达待视觉核对' : '值一致',
  };
});
const audit = {
  miniprogramCommit,
  miniCount: miniKeys.size,
  flutterCount: flutterKeys.size,
  commonCount: common.length,
  common,
  flutterOnly,
  miniOnly,
  miniComponentOverrides: [...new Set(miniComponentOverrides)].sort(),
  rawMismatches,
  allowedGlobalValueExceptions,
  unexpectedRawMismatches,
  referenceMismatches,
  missingGetters,
  uncomparable,
  globalRows,
  componentVariableCount: componentVarNames.size,
  componentCounts,
  flutterThemeFields,
  componentVariables: [...componentVariables].sort(([a], [b]) => a.localeCompare(b)).map(([name, locations]) => ({
    name,
    locations: [...locations].sort(),
    sourceExpressions: [...componentSourceLines.get(name)].sort(),
    fallbackExpressions: componentFallbacks.get(name),
    miniLightOverride: miniComponentThemeOverrides.default.get(name) ?? null,
    miniDarkOverride: miniComponentThemeOverrides.defaultDark.get(name) ?? null,
    miniLightDefault: resolveComponentFallback(name, 'default'),
    miniDarkDefault: resolveComponentFallback(name, 'defaultDark'),
    miniLightCandidates: conflictingComponentDefaults(name, 'default'),
    miniDarkCandidates: conflictingComponentDefaults(name, 'defaultDark'),
    matchingFlutterThemeFields: flutterThemeCandidates.get(name) ?? [],
    globalFallbackToken: (() => {
      const fallbacks = componentFallbacks.get(name) ?? [];
      const match = fallbacks.length === 1 ? fallbacks[0].match(/^@([\w-]+)$/) : null;
      const key = match && kebabToCamel(match[1]);
      return key && definitions.default.has(key) ? key : null;
    })(),
    ...(() => {
      const consumers = [...new Set([...locations].map(location => location.split('/')[2]))].sort();
      const owner = consumers.find(component => name.startsWith(kebabToCamel(component))) ?? consumers[0];
      const flutterOwner = owner.replaceAll('-', '_');
      const flutterDir = path.join(flutterComponentsDir, flutterOwner);
      const prefix = kebabToCamel(owner);
      const suffix = name.startsWith(prefix)
        ? name.slice(prefix.length).replace(/^./, first => first.toLowerCase()) : undefined;
      const themeFiles = fs.existsSync(flutterDir)
        ? fs.readdirSync(flutterDir).filter(file => file.endsWith('theme_data.dart')) : [];
      const themeFieldFound = !!suffix && themeFiles.some(file =>
        new RegExp(`\\bfinal\\s+[\\w<>?, ]+\\s+${suffix}\\s*;`).test(fs.readFileSync(path.join(flutterDir, file), 'utf8')));
      const fallback = componentFallbacks.get(name) ?? [];
      const globalMatch = fallback.length === 1 ? fallback[0].match(/^@([\w-]+)$/) : null;
      const globalKey = globalMatch && kebabToCamel(globalMatch[1]);
      const flutterSource = flutterSources.get(flutterOwner);
      const directGlobalGetterFound = !!flutterSource && !!globalKey &&
        new RegExp(`\\.${globalKey}\\b`).test(flutterSource);
      return {
        miniComponent: owner,
        miniConsumers: consumers,
        flutterComponent: fs.existsSync(flutterDir) ? flutterOwner : null,
        candidateThemeField: suffix ?? null,
        matchingThemeField: themeFieldFound,
        directGlobalGetterFound,
      };
    })(),
  })),
};
for (const row of audit.componentVariables) {
  row.miniValueStatus = row.miniLightDefault === '<no fallback>' ? '无源码回退' :
    row.miniLightDefault === '<conflicting fallbacks>' || row.miniDarkDefault === '<conflicting fallbacks>'
      ? '同名变量有多套回退' :
      /@[\w-]+|var\(--/.test(`${row.miniLightDefault} ${row.miniDarkDefault}`)
        ? '表达仍含未解析引用' :
        /calc\(/.test(`${row.miniLightDefault} ${row.miniDarkDefault}`)
          ? '含 CSS calc，尚未数值化' : '默认表达已解析';
  row.flutterValueStatus = '最终消费值未逐项验证';
}
audit.componentAuditSummary = {
  total: audit.componentVariables.length,
  withSameNameFlutterDirectory: audit.componentVariables.filter(row => row.flutterComponent).length,
  withSameNameThemeField: audit.componentVariables.filter(row => row.matchingThemeField).length,
  withSameNameThemeFieldAcrossDirectories: audit.componentVariables.filter(row =>
    row.matchingFlutterThemeFields.length > 0).length,
  withGlobalFallback: audit.componentVariables.filter(row => row.globalFallbackToken).length,
  withGlobalGetterInOwnerDirectory: audit.componentVariables.filter(row => row.directGlobalGetterFound).length,
  noFallback: audit.componentVariables.filter(row => row.miniLightDefault === '<no fallback>').map(row => row.name),
  conflictingFallbacks: audit.componentVariables.filter(row =>
    row.miniLightDefault === '<conflicting fallbacks>' || row.miniDarkDefault === '<conflicting fallbacks>').map(row => row.name),
  unresolvedSourceExpression: audit.componentVariables.filter(row =>
    /@[\w-]+|var\(--/.test(`${row.miniLightDefault} ${row.miniDarkDefault}`))
    .map(row => ({ name: row.name, light: row.miniLightDefault, dark: row.miniDarkDefault })),
  cssCalcExpressions: audit.componentVariables.filter(row =>
    /calc\(/.test(`${row.miniLightDefault} ${row.miniDarkDefault}`)).map(row => row.name),
};
function cell(value) {
  const raw = Array.isArray(value) ? value.join('<br>') :
    value === undefined || value === null ? '' :
      typeof value === 'object' ? JSON.stringify(value) : String(value);
  return raw.replaceAll('|', '\\|').replaceAll('\n', '<br>');
}
function table(headers, rows) {
  return [
    `| ${headers.join(' | ')} |`,
    `| ${headers.map(() => '---').join(' | ')} |`,
    ...rows.map(row => `| ${row.map(cell).join(' | ')} |`),
  ].join('\n');
}
function emit(value) {
  if (!outputFile) {
    console.log(value);
    return;
  }
  const target = path.resolve(flutterRoot, outputFile);
  if (!target.startsWith(`${flutterRoot}${path.sep}`)) {
    throw new Error('Output must be inside the Flutter repository.');
  }
  fs.writeFileSync(target, `${value}\n`);
}
if (markdownTable === 'global') {
  emit(`# 全局 Token 逐项对照\n\n小程序基准：\`${miniprogramCommit}\`；尺寸以 375 宽下 2rpx = 1dp 比较。\n\n` +
    table(['Token', '组', '小程序来源', '浅色原式', '浅色最终值', 'Flutter 浅色', '浅色引用（小程序 / Flutter）', '暗色原式', '暗色最终值', 'Flutter 暗色', '暗色引用（小程序 / Flutter）', 'getter', '结论'],
      globalRows.map(row => [row.key, row.group, row.miniSources.map(file => `packages/components/common/style/theme/${file}`).join('<br>'),
        row.miniLightRaw, row.miniLightResolved, row.flutterLightResolved,
        `${row.miniLightReference ?? '—'} / ${row.flutterLightReference ?? '—'}`,
        row.miniDarkRaw, row.miniDarkResolved, row.flutterDarkResolved,
        `${row.miniDarkReference ?? '—'} / ${row.flutterDarkReference ?? '—'}`,
        row.getterAvailable ? '有' : '缺', row.status])));
} else if (markdownTable === 'component') {
  emit(`# 组件变量逐项映射\n\n小程序基准：\`${miniprogramCommit}\`。默认表达已展开可确定的引用；CSS \`calc()\`、百分比等仍保留表达形式。Flutter Theme 字段仅按名称静态匹配；没有验证每项的实际消费值或视觉。\n\n` +
    table(['小程序变量', '组件', '使用位置', '定义/回退表达式', '浅色默认表达', '暗色默认表达', '冲突候选值（浅色 / 暗色）', '小程序值状态', 'Flutter 目录', 'Theme 字段候选', '跨目录同名字段', '同名全局 getter 被引用', 'Flutter 值状态'],
      audit.componentVariables.map(row => [row.name, row.miniConsumers.join(', '), row.locations,
        row.sourceExpressions, row.miniLightDefault, row.miniDarkDefault,
        row.miniLightCandidates.length ? `${row.miniLightCandidates.join(' / ')}；${row.miniDarkCandidates.join(' / ')}` : '',
        row.miniValueStatus, row.flutterComponent, row.candidateThemeField,
        row.matchingFlutterThemeFields,
        row.globalFallbackToken ? row.directGlobalGetterFound ? '是（仅目录级线索）' : '否（需核替代路径）' : '不适用',
        row.flutterValueStatus])));
} else if (markdownTable === 'flutter-theme') {
  emit(`# Flutter 组件 Theme 字段清单\n\n仅按同名候选与小程序组件变量对照；字段不一定应与 CSS 变量一一对应。\n\n` +
    table(['Flutter 组件', 'Theme 字段', '源码', '小程序同名候选'],
      flutterThemeFields.map(row => [row.component, row.field, row.file, row.sameNameMiniVariable])));
} else if (markdownTable) {
  throw new Error(`Unknown Markdown table: ${markdownTable}`);
} else {
  emit(JSON.stringify(audit, null, 2));
}

import { existsSync, readFileSync, readdirSync, writeFileSync } from 'node:fs';
import { spawnSync } from 'node:child_process';
import { dirname, join, relative, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

// Static evidence only: a matching field/getter is not proof of a final paint value.
const repo = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const source = join(repo, 'tdesign-component/lib/src/components');
const miniRepo = process.env.TDESIGN_MINIPROGRAM_ROOT
  ? resolve(process.env.TDESIGN_MINIPROGRAM_ROOT)
  : resolve(repo, '../tdesign-miniprogram');
const audit = JSON.parse(
  readFileSync(join(repo, 'specs/047-miniprogram-token-alignment/token-audit.json'), 'utf8'),
);
const output = join(repo, 'specs/048-component-token-theme-ownership/component-consumption-audit.json');
const flutterDirectoryAliases = {
  'back-top': 'backtop',
  'dropdown-item': 'dropdown_menu',
  'pull-down-refresh': 'refresh',
  'side-bar': 'sidebar',
  'side-bar-item': 'sidebar',
  'step-item': 'steps',
  'tab-bar': 'tabbar',
  'tab-bar-item': 'tabbar',
  paragraph: 'text',
};

function dartFiles(directory) {
  if (!existsSync(directory)) return [];
  return readdirSync(directory, { withFileTypes: true }).flatMap((entry) => {
    const path = join(directory, entry.name);
    if (entry.isDirectory()) return dartFiles(path);
    return entry.name.endsWith('.dart') ? [path] : [];
  });
}

function ownerDirectory(variable) {
  const alias = flutterDirectoryAliases[variable.miniComponent];
  if (alias && existsSync(join(source, alias))) return join(source, alias);
  const names = [variable.flutterComponent, variable.miniComponent]
    .filter(Boolean)
    .map((name) => name.replaceAll('-', '_'));
  for (const name of names) {
    const path = join(source, name);
    if (existsSync(path)) return path;
  }
  for (const name of names) {
    const parts = name.split('_');
    while (parts.length > 1) {
      parts.pop();
      const path = join(source, parts.join('_'));
      if (existsSync(path)) return path;
    }
  }
  return null;
}

const fileCache = new Map();
function lines(path) {
  if (!fileCache.has(path)) fileCache.set(path, readFileSync(path, 'utf8').split('\n'));
  return fileCache.get(path);
}

function matches(files, expression, { excludeThemeDeclarations = false } = {}) {
  if (!expression) return [];
  const pattern = new RegExp(`\\.\\s*${expression}\\b`);
  const results = [];
  for (const path of files) {
    if (excludeThemeDeclarations && /theme_data\.dart$/.test(path)) continue;
    lines(path).forEach((line, index) => {
      if (pattern.test(line)) {
        results.push(`${relative(repo, path)}:${index + 1}`);
      }
    });
  }
  return results;
}

function miniGit(args) {
  const result = spawnSync('git', ['-C', miniRepo, ...args], {
    encoding: 'utf8',
    maxBuffer: 20 * 1024 * 1024,
  });
  if (result.status !== 0) {
    throw new Error(`Cannot read frozen miniprogram source: ${result.stderr}`);
  }
  return result.stdout;
}

const miniPaths = miniGit([
  'ls-tree', '-r', '--name-only', audit.miniprogramCommit, '--', 'packages/components',
]).trim().split('\n').filter((path) => path.endsWith('.less'));
const miniSources = miniPaths.map((path) => miniGit(['show', `${audit.miniprogramCommit}:${path}`]));
const miniDynamicLessComponents = new Set(
  miniPaths.filter((path, index) => miniSources[index].includes('@@'))
    .map((path) => path.split('/')[2]),
);
const miniVariableReferences = new Map();
const miniReferenceLines = miniGit([
  'grep', '-n', '--', '--td-', audit.miniprogramCommit, '--', 'packages/components',
]).split('\n');
for (const match of miniReferenceLines) {
  const parts = match.match(/^[^:]+:(.+?):\d+:(.*)$/);
  if (!parts || !/\.(?:less|wxss|wxml|wxs|js|ts)$/.test(parts[1])) continue;
  for (const variable of parts[2].matchAll(/--td-[\w-]+/g)) {
    const key = variable[0];
    miniVariableReferences.set(key, (miniVariableReferences.get(key) ?? 0) + 1);
  }
}
function miniAliasEvidence(variable) {
  const alias = variable.sourceExpressions[0]?.match(/^@([\w-]+)\s*:/)?.[1];
  if (!alias || miniSources.length === 0) return { alias: alias ?? null, uses: null };
  const pattern = new RegExp(`@${alias}(?![\\w-])`, 'g');
  const total = miniSources.reduce(
    (count, sourceText) => count + [...sourceText.matchAll(pattern)].length,
    0,
  );
  return { alias, uses: Math.max(0, total - 1) };
}

// Reviewed against the frozen Less defaults, TButtonResolve.sizeMetrics,
// and the rendered-widget assertions in t_button_test.dart.
const buttonWidgetValues = new Map([
  ['buttonExtraSmallHeight', '28dp'],
  ['buttonExtraSmallIconSize', '18dp'],
  ['buttonExtraSmallPaddingHorizontal', '8dp'],
  ['buttonSmallHeight', '32dp'],
  ['buttonSmallIconSize', '18dp'],
  ['buttonSmallPaddingHorizontal', '12dp'],
  ['buttonMediumHeight', '40dp'],
  ['buttonMediumIconSize', '20dp'],
  ['buttonMediumPaddingHorizontal', '16dp'],
  ['buttonLargeHeight', '48dp'],
  ['buttonLargeIconSize', '24dp'],
  ['buttonLargePaddingHorizontal', '20dp'],
]);
const tagSizeWidgetValues = new Set([
  'tagExtraLargeFont', 'tagExtraLargeIconSize', 'tagExtraLargePadding',
  'tagLargeFont', 'tagLargeIconSize', 'tagLargePadding',
  'tagMediumFont', 'tagMediumIconSize', 'tagMediumPadding',
  'tagSmallFont', 'tagSmallIconSize', 'tagSmallPadding',
]);
const tagWidgetEvidence = new Map([
  ['tagWarningLightColor', ['tdesign-component/test/components/tag/t_tag_test.dart:151', 'tdesign-component/test/components/tag/t_tag_test.dart:239']],
  ['tagDangerLightColor', ['tdesign-component/test/components/tag/t_tag_test.dart:151', 'tdesign-component/test/components/tag/t_tag_test.dart:239']],
  ['tagOutlineBgColor', ['tdesign-component/test/components/tag/t_tag_test.dart:508']],
  ['tagDefaultColor', ['tdesign-component/test/components/tag/t_tag_test.dart:508']],
  ['tagCloseIconColor', ['tdesign-component/test/components/tag/t_tag_test.dart:630']],
]);
const tagThemeWidgetEvidence = new Map([
  ['tagDangerColor', [
    'tdesign-component/test/components/tag/t_tag_test.dart:969',
    'tdesign-component/test/components/tag/t_select_tag_test.dart:168',
  ]],
  ['tagSquareBorderRadius', [
    'tdesign-component/test/components/tag/t_tag_test.dart:372',
    'tdesign-component/test/components/tag/t_tag_test.dart:1071',
  ]],
  ['tagSuccessColor', [
    'tdesign-component/test/components/tag/t_tag_test.dart:852',
    'tdesign-component/test/components/tag/t_select_tag_test.dart:19',
  ]],
  ['tagSuccessLightColor', [
    'tdesign-component/test/components/tag/t_tag_test.dart:852',
    'tdesign-component/test/components/tag/t_tag_test.dart:926',
  ]],
]);

const rows = audit.componentVariables.map((variable) => {
  const directory = ownerDirectory(variable);
  const files = directory == null ? [] : dartFiles(directory);
  const themeFieldUses = variable.matchingThemeField
    ? matches(files, variable.candidateThemeField, { excludeThemeDeclarations: true })
    : [];
  const fallbackUses = matches(files, variable.globalFallbackToken);
  const sourceLocations = variable.locations;
  const miniAlias = miniAliasEvidence(variable);
  const miniCssName = variable.sourceExpressions[0]?.match(/--td-[\w-]+/)?.[0] ?? null;
  const miniVariableDeclarations = variable.sourceExpressions.filter(
    (expression) => /^@[\w-]+\s*:/.test(expression),
  ).length;
  const miniOtherCssReferences = miniCssName == null
    ? null
    : Math.max(0, (miniVariableReferences.get(miniCssName) ?? 0) - miniVariableDeclarations);
  const miniHasDynamicLessLookup = miniDynamicLessComponents.has(variable.miniComponent);
  const miniSourceUse = miniOtherCssReferences != null && miniOtherCssReferences > 0
    ? 'referenced'
    : miniAlias.uses == null || miniOtherCssReferences == null
      ? 'undetermined'
      : miniAlias.uses === 0
        ? miniHasDynamicLessLookup
          ? 'dynamic-less-possible'
          : 'no-static-consumer-evidence'
        : 'referenced';
  if (buttonWidgetValues.has(variable.name) &&
      (variable.miniLightDefault !== buttonWidgetValues.get(variable.name) ||
       variable.miniDarkDefault !== buttonWidgetValues.get(variable.name))) {
    throw new Error(`Reviewed Button default changed: ${variable.name}`);
  }
  const reviewDecision = miniSourceUse === 'no-static-consumer-evidence'
    ? 'no-frozen-source-consumer-found'
    : directory == null
      ? 'outside-current-flutter-component-surface'
      : buttonWidgetValues.has(variable.name) || tagSizeWidgetValues.has(variable.name)
        ? 'default-widget-value-verified'
        : tagThemeWidgetEvidence.has(variable.name)
          ? 'component-theme-widget-verified-visual-pending'
          : tagWidgetEvidence.has(variable.name)
            ? 'fallback-widget-verified-visual-pending'
            : 'pending';
  const reviewEvidence = buttonWidgetValues.has(variable.name)
    ? ['tdesign-component/test/components/button/t_button_test.dart:432']
    : tagSizeWidgetValues.has(variable.name)
      ? ['tdesign-component/test/components/tag/t_tag_test.dart:431']
    : tagThemeWidgetEvidence.has(variable.name)
      ? tagThemeWidgetEvidence.get(variable.name)
      : tagWidgetEvidence.has(variable.name)
        ? tagWidgetEvidence.get(variable.name)
        : [];
  let staticStatus;
  if (directory == null) {
    staticStatus = 'no-matching-flutter-component-directory';
  } else if (themeFieldUses.length > 0 && fallbackUses.length > 0) {
    staticStatus = 'theme-field-and-global-getter-candidates';
  } else if (themeFieldUses.length > 0) {
    staticStatus = 'theme-field-candidate';
  } else if (fallbackUses.length > 0) {
    staticStatus = 'global-getter-candidate';
  } else {
    staticStatus = 'no-direct-consumer-evidence';
  }
  return {
    name: variable.name,
    miniComponent: variable.miniComponent,
    sourceLocations,
    fallbackExpressions: variable.fallbackExpressions,
    miniLightDefault: variable.miniLightDefault,
    miniDarkDefault: variable.miniDarkDefault,
    miniValueStatus: variable.miniValueStatus,
    miniAlias: miniAlias.alias,
    miniAliasUsesBeyondDefinition: miniAlias.uses,
    miniCssName,
    miniOtherCssReferences,
    miniHasDynamicLessLookup,
    miniSourceUse,
    flutterDirectory: directory == null ? null : relative(repo, directory),
    themeField: variable.matchingThemeField ? variable.candidateThemeField : null,
    themeFieldUses,
    globalFallbackGetter: variable.globalFallbackToken,
    fallbackUses,
    staticStatus,
    reviewDecision,
    reviewEvidence,
    finalPaintVerified: false,
  };
});

if (rows.length !== audit.componentVariableCount ||
    new Set(rows.map((row) => row.name)).size !== rows.length) {
  throw new Error('Component variable inventory changed or contains duplicate names.');
}

const statusCounts = Object.fromEntries(
  [...new Set(rows.map((row) => row.staticStatus))]
    .sort()
    .map((status) => [status, rows.filter((row) => row.staticStatus === status).length]),
);
const reviewDecisionCounts = Object.fromEntries(
  [...new Set(rows.map((row) => row.reviewDecision))]
    .sort()
    .map((decision) => [decision, rows.filter((row) => row.reviewDecision === decision).length]),
);
writeFileSync(output, `${JSON.stringify({
  miniprogramCommit: audit.miniprogramCommit,
  total: rows.length,
  statusCounts,
  reviewDecisionCounts,
  caveat: 'Directory matches are static candidates. reviewDecision records limited source and Widget-test judgments; finalPaintVerified remains false until visual and state coverage is complete.',
  rows,
}, null, 2)}\n`);
console.log(JSON.stringify({
  output: relative(repo, output), total: rows.length, statusCounts, reviewDecisionCounts,
}, null, 2));

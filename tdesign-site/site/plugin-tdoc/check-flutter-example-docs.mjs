import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import {
  defaultExampleCodeDirectory,
  listFlutterExampleKeys,
  replaceFlutterExampleDirectives,
} from './flutter-example-code.mjs';

const pluginDirectory = path.dirname(fileURLToPath(import.meta.url));
const docsDirectory = path.resolve(pluginDirectory, '../../docs/components');
const normalize = (value) => value.replace(/[-_]/g, '').toLowerCase();
const assetGroups = new Map();

for (const fileName of fs.readdirSync(defaultExampleCodeDirectory)) {
  if (!fileName.endsWith('.txt')) continue;
  const group = fileName.slice(0, fileName.indexOf('.'));
  assetGroups.set(normalize(group), group);
}

const errors = [];
let mappedExampleCount = 0;
let documentCount = 0;
const mappedGroups = new Set();

for (const slug of fs.readdirSync(docsDirectory).sort()) {
  const readme = path.join(docsDirectory, slug, 'README.md');
  if (!fs.existsSync(readme)) continue;
  documentCount += 1;

  const expectedGroup = assetGroups.get(normalize(slug));
  if (!expectedGroup) {
    errors.push(`${slug}: no matching generated Flutter example group`);
    continue;
  }

  const source = fs.readFileSync(readme, 'utf8');
  const directives = [...source.matchAll(/\{\{\s*flutter-example-group\s+([^\s}]+)\s*\}\}/g)].map((match) => match[1]);
  if (directives.length !== 1 || directives[0] !== expectedGroup) {
    errors.push(
      `${slug}: expected exactly "{{ flutter-example-group ${expectedGroup} }}", found ${JSON.stringify(directives)}`,
    );
    continue;
  }
  if (/<td-code-block\s+panel="Dart">/.test(source) || /\{\{\s*flutter-example\s+/.test(source)) {
    errors.push(`${slug}: contains a hand-maintained or single-example Dart mapping`);
    continue;
  }

  const keys = listFlutterExampleKeys(expectedGroup);
  const rendered = replaceFlutterExampleDirectives(source);
  const renderedBlocks = rendered.match(/<td-code-block\s+panel="Dart">/g) ?? [];
  if (renderedBlocks.length !== keys.length || /\{\{\s*flutter-example/.test(rendered)) {
    errors.push(`${slug}: rendered ${renderedBlocks.length} Dart blocks for ${keys.length} generated examples`);
    continue;
  }
  mappedExampleCount += keys.length;
  mappedGroups.add(expectedGroup);
}

if (errors.length > 0) {
  console.error(errors.map((error) => `[flutter-example-docs] ${error}`).join('\n'));
  process.exitCode = 1;
} else {
  const excludedGroups = [...new Set(assetGroups.values())].filter((group) => !mappedGroups.has(group)).sort();
  console.log(
    `[flutter-example-docs] ${documentCount} component documents map ${mappedExampleCount} generated examples; non-component groups: ${
      excludedGroups.join(', ') || 'none'
    }`,
  );
}

import { readFileSync, writeFileSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

export const repositoryRoot = resolve(dirname(fileURLToPath(import.meta.url)), '..');
export const migrationSource = 'tdesign-site/site/docs/migration-0.2.7-to-1.0.md';
const exampleSource = 'tdesign-component/tool/fixtures/token_migration/lib/migration_027_examples.dart';
const github = 'https://github.com/Tencent/tdesign-flutter/blob/develop/';
const site = 'https://tdesign.tencent.com/flutter/';

// The existing public migration URL remains stable after the source rename.
function guideRoute(slug) {
  return slug === 'migration-0.2.7-to-1.0' ? 'migration-1-0' : slug;
}

export function guideLinks(content, { absolute = false } = {}) {
  const local = content.replace(/\]\(\.\/([a-z0-9.-]+)\.md(#[^)]*)?\)/g, (_, slug, fragment = '') =>
    `](/flutter/${guideRoute(slug)}${fragment})`);
  // Keep navigation inside the local preview; package readers need full URLs.
  return local.replace(/\]\((?:https:\/\/tdesign\.tencent\.com)?\/flutter\/([^)]*)\)/g,
    (_, target) => `](${absolute ? site : '/flutter/'}${target})`);
}

// Package readers cannot resolve repository-only relative paths.
export function packageLinks(content) {
  return content.replace(/\]\(([^)]+)\)/g, (link, target) => {
    if (/^(?:[a-z][a-z0-9+.-]*:|#|\/)/i.test(target)) return link;
    const clean = target.replace(/^\.\//, '');
    if (clean.split('#')[0] === migrationSource) return `](./MIGRATION.md${clean.includes('#') ? `#${clean.split('#')[1]}` : ''})`;
    if (/^README(?:_zh_CN)?\.md(?:#.*)?$/.test(clean)) return link;
    if (clean.startsWith('tdesign-site/site/docs/')) {
      const [file, fragment] = clean.slice('tdesign-site/site/docs/'.length).split('#');
      return `](${site}${guideRoute(file.replace(/\.md$/, ''))}${fragment ? `#${fragment}` : ''})`;
    }
    return `](${github}${clean})`;
  });
}

export function renderExamples(guide, examples, family = 'migration') {
  const seen = new Set();
  const pattern = new RegExp(`<!-- ${family}-example:([a-z-]+):start -->[\\s\\S]*?<!-- ${family}-example:\\1:end -->`, 'g');
  const rendered = guide.replace(pattern, (_, name) => {
    if (seen.has(name)) throw new Error(`Duplicate ${family} example: ${name}`);
    seen.add(name);
    const start = `// ${family}:${name}:start`;
    const end = `// ${family}:${name}:end`;
    if (examples.split(start).length !== 2 || examples.split(end).length !== 2) {
      throw new Error(`Missing or duplicate ${family} example: ${name}`);
    }
    const offset = examples.indexOf(start) + start.length;
    const endOffset = examples.indexOf(end, offset);
    if (endOffset < 0) throw new Error(`Invalid ${family} example order: ${name}`);
    return `<!-- ${family}-example:${name}:start -->\n\`\`\`dart\n${examples.slice(offset, endOffset).trim()}\n\`\`\`\n<!-- ${family}-example:${name}:end -->`;
  });
  const markers = [...rendered.matchAll(new RegExp(`<!-- ${family}-example:[^>]+ -->`, 'g'))];
  if (markers.length !== seen.size * 2 || seen.size === 0) throw new Error(`Unmatched ${family} example markers`);
  return rendered;
}

export function renderMigrationExamples(guide, examples) {
  return renderExamples(guide, examples);
}

export function generatedDocument(source, body) {
  return `<!-- Generated from ${source}; do not edit this copy. -->\n\n${body}`;
}

// Compute every output before writing; --check never changes any source or copy.
export function syncDocuments({ root = repositoryRoot, check = false } = {}) {
  const read = file => readFileSync(resolve(root, file), 'utf8');
  const guide = renderMigrationExamples(read(migrationSource), read(exampleSource));
  const outputs = new Map([[migrationSource, guide]]);
  const documentationExamples = read('tdesign-component/example/lib/documentation_examples.dart');
  for (const file of ['custom-theme', 'internationalization']) {
    const path = `tdesign-site/site/docs/${file}.md`;
    outputs.set(path, renderExamples(read(path), documentationExamples, 'documentation'));
  }
  for (const source of ['README.md', 'README_zh_CN.md']) {
    outputs.set(`tdesign-component/${source}`, generatedDocument(source, packageLinks(read(source))));
  }
  const portableGuide = guide.replace(/^---\r?\n[\s\S]*?\r?\n---\r?\n\s*/, '');
  outputs.set('tdesign-component/MIGRATION.md', generatedDocument(migrationSource, guideLinks(portableGuide, { absolute: true })));
  const stale = [...outputs].filter(([file, expected]) => {
    try { return read(file) !== expected; } catch (error) {
      if (error.code === 'ENOENT') return true;
      throw error;
    }
  });
  if (check && stale.length) throw new Error(`Stale documentation: ${stale.map(([file]) => file).join(', ')}. Run node scripts/sync-readme.mjs`);
  if (!check) for (const [file, content] of stale) writeFileSync(resolve(root, file), content);
  console.log(`[documentation] ${check ? 'checked' : 'synchronized'} ${outputs.size} documents; ${stale.length} ${check ? 'stale' : 'updated'}`);
}

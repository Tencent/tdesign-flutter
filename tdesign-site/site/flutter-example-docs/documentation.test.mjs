import assert from 'node:assert/strict';
import { mkdtempSync, mkdirSync, readFileSync, writeFileSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';
import { fileURLToPath } from 'node:url';
import { migrationSource, packageLinks, renderMigrationExamples, syncDocuments } from '../../../scripts/documentation.mjs';
import { adaptGuideLinks, adaptRepositoryDocument } from './repository-document.mjs';

const root = fileURLToPath(new URL('../../../', import.meta.url));
const marker = '<!-- migration-example:button:start -->\nold\n<!-- migration-example:button:end -->';
const example = '// migration:button:start\nconst TButton();\n// migration:button:end';

test('package README links stay usable without repository-only files', () => {
  const output = packageLinks(`[迁移](./${migrationSource}) [章节](./${migrationSource}#button) [贡献](CONTRIBUTING.md) [中文](./README_zh_CN.md) [主题](./tdesign-site/site/docs/custom-theme.md#局部) [外链](https://example.com)`);
  assert.match(output, /\[迁移\]\(\.\/MIGRATION.md\)/);
  assert.match(output, /\[章节\]\(\.\/MIGRATION.md#button\)/);
  assert.match(output, /blob\/develop\/CONTRIBUTING.md/);
  assert.match(output, /\[中文\]\(\.\/README_zh_CN.md\)/);
  assert.match(output, /flutter\/custom-theme#局部/);
  assert.match(output, /\[外链\]\(https:\/\/example.com\)/);
});

test('migration examples reject missing, duplicate and unmatched markers', () => {
  assert.match(renderMigrationExamples(marker, example), /const TButton/);
  assert.throws(() => renderMigrationExamples(marker, ''), /Missing/);
  assert.throws(() => renderMigrationExamples(marker + marker, example), /Duplicate/);
  assert.throws(() => renderMigrationExamples(marker + '<!-- migration-example:form:start -->', example), /Unmatched/);
});

test('check mode detects stale copies and missing sources without writing files', () => {
  const temp = mkdtempSync(path.join(tmpdir(), 'tdesign-docs-test-'));
  const write = (file, text) => { mkdirSync(path.dirname(path.join(temp, file)), { recursive: true }); writeFileSync(path.join(temp, file), text); };
  const read = file => readFileSync(path.join(temp, file), 'utf8');
  try {
    write(migrationSource, `---\ntitle: migration\n---\n\n${marker}\n[主题](./custom-theme.md)`);
    write('README.md', '# project');
    write('README_zh_CN.md', '# 项目');
    write('tdesign-component/tool/fixtures/token_migration/test/support/migration_027_examples.dart', example);
    assert.throws(() => syncDocuments({ root: temp, check: true }), /Stale/);
    assert.match(read(migrationSource), /old/);
    syncDocuments({ root: temp });
    const portable = read('tdesign-component/MIGRATION.md');
    assert.match(portable, /Generated from/);
    assert.doesNotMatch(portable, /title: migration/);
    assert.match(portable, /https:\/\/tdesign.tencent.com\/flutter\/custom-theme/);
    syncDocuments({ root: temp, check: true });
    write('tdesign-component/README.md', 'stale');
    assert.throws(() => syncDocuments({ root: temp, check: true }), /tdesign-component\/README.md/);
    assert.equal(read('tdesign-component/README.md'), 'stale');
    rmSync(path.join(temp, 'README.md'));
    assert.throws(() => syncDocuments({ root: temp }), /ENOENT/);
    assert.equal(read('tdesign-component/README.md'), 'stale');
  } finally { rmSync(temp, { recursive: true, force: true }); }
});

test('site contribution page reads canonical rules and resolves repository links', () => {
  const source = '# CONTRIBUTING\n\n[spec](./specs/README.md)';
  const rendered = adaptRepositoryDocument(source, path.join(root, 'CONTRIBUTING.md'));
  assert.match(rendered, /^---\ntitle: 贡献指南/);
  assert.match(rendered, /blob\/develop\/specs\/README.md/);
  assert.doesNotMatch(rendered, /^# CONTRIBUTING/m);
  assert.equal(adaptRepositoryDocument(source, path.join(root, 'README.md')), source);
});

test('guide links use stable routes and remain untouched in non-guide content', () => {
  const source = '[迁移](./migration-0.2.7-to-1.0.md#button) [主题](./custom-theme.md)';
  const rendered = adaptGuideLinks(source, path.join(root, 'tdesign-site/site/docs/getting-started.md'));
  assert.match(rendered, /\(\/flutter\/migration-1-0#button\)/);
  assert.match(rendered, /\(\/flutter\/custom-theme\)/);
  assert.equal(adaptGuideLinks(source, path.join(root, 'README.md')), source);
});

test('repository copies and runnable migration snippets are synchronized', () => {
  syncDocuments({ check: true });
});

import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';

import siteConfig from '../site.config.mjs';

test('migration guide is discoverable in the start menu with one stable route', () => {
  const start = siteConfig.docs.find(group => group.title === '开始');
  assert.deepEqual(start.children.map(page => page.title), [
    '快速开始', '迁移指南', '1.0 → 1.1 升级指南', '组件概览', '常见问题', '更新日志', '贡献指南',
  ]);
  const pages = [...siteConfig.standalone, ...siteConfig.docs.flatMap(group => group.children ?? [])];
  const migration = pages.filter(page => page.path === '/flutter/migration-1-0');
  assert.equal(migration.length, 1);
  assert.equal(migration[0].name, 'migration-1-0');
  assert.equal(migration[0].meta.docType, 'explain');
  const nextMigration = pages.filter(page => page.path === '/flutter/migration-1-0-to-1-1');
  assert.equal(nextMigration.length, 1);
  assert.equal(nextMigration[0].name, 'migration-1-1');
  assert.ok(!start.children.some(page => page.name === 'dark-mode'));
});

test('1.1 upgrade details have their own guide and the old guide keeps its anchors', () => {
  const oldGuide = readFileSync(new URL('../docs/migration-0.2.7-to-1.0.md', import.meta.url), 'utf8');
  const nextGuide = readFileSync(new URL('../docs/migration-1-0-to-1-1.md', import.meta.url), 'utf8');
  assert.doesNotMatch(oldGuide, /1\.1\.0/);
  assert.match(oldGuide, /id="migration-after-1-0"/);
  assert.match(oldGuide, /id="自定义文字槽默认值统一（patch）"/);
  assert.match(oldGuide, /\]\(\.\/migration-1-0-to-1-1\.md\)/);
  assert.match(nextGuide, /1\.0\.0 → 1\.1\.0 事件与主题配置/);
});

test('getting started offers official demos and keeps the migration entry', () => {
  const source = readFileSync(new URL('../docs/getting-started.md', import.meta.url), 'utf8');
  assert.ok(source.indexOf('## 快速体验') < source.indexOf('## 接入'));
  assert.doesNotMatch(source, /Web 在线体验|指定版本体验/);
  assert.match(source, /https:\/\/tdesign\.gtimg\.com\/flutter\/tdesign_flutter_example\.apk/);
  assert.match(source, /https:\/\/github\.com\/Tencent\/tdesign-flutter\/releases/);
  assert.match(source, /migration-0\.2\.7-to-1\.0\.md/);
  assert.doesNotMatch(source, /版本差异|核对应用版本|预发布版/);
  assert.match(source, /Android 真机体验[^\n]*<img src="\/assets\/qrcode\/t_apk_qrcode\.png"/);
  assert.doesNotMatch(source, /raw\.githubusercontent\.com/);
});

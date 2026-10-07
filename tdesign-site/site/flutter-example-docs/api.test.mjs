import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import test from 'node:test';

import { defaultApiDirectory, replaceFlutterApiDirectives } from './api.mjs';
import siteConfig from '../site.config.mjs';

test('every component page renders the complete Demo API, including Theme and controllers', () => {
  const manifest = JSON.parse(fs.readFileSync(new URL('../../../tdesign-component/tool/components.json', import.meta.url), 'utf8'));
  const routePaths = new Set();
  const visit = (items) => items.forEach((item) => item.children ? visit(item.children) : routePaths.add(item.path));
  visit(siteConfig.docs);
  for (const component of manifest.components) {
    assert.ok(routePaths.has(`/flutter/components/${component.slug}`), `${component.slug}: missing site route`);
    const source = fs.readFileSync(new URL(`../../docs/components/${component.slug}/README.md`, import.meta.url), 'utf8');
    assert.match(source, new RegExp(`\\{\\{ flutter-api ${component.slug} \\}\\}`));
    const rendered = replaceFlutterApiDirectives(source);
    const api = fs.readFileSync(path.join(defaultApiDirectory, `${component.slug}_api.md`), 'utf8').trimEnd();
    assert.ok(rendered.includes(api), component.slug);
    for (const name of [...component.api.names, ...(component.api.functions || [])]) {
      assert.ok(rendered.includes(`### ${name}\n`), `${component.slug}: ${name}`);
      assert.equal(rendered.split(`### ${name}\n`).length - 1, 1, `${component.slug}: duplicate ${name}`);
    }
    assert.equal((rendered.match(/^## API$/gm) || []).length, 1);
  }
});

test('rejects missing API assets and paths outside the asset directory', () => {
  assert.throws(() => replaceFlutterApiDirectives('{{ flutter-api not-a-component }}'), /Missing generated/);
  assert.throws(() => replaceFlutterApiDirectives('{{ flutter-api ..\/button }}'), /Invalid Flutter API slug/);
});

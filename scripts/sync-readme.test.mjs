import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { mkdtempSync, mkdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import test from 'node:test';

const script = readFileSync(new URL('./sync-readme.mjs', import.meta.url), 'utf8');
const root = fileURLToPath(new URL('../', import.meta.url));
const start = '<!-- getting-started:start -->';
const end = '<!-- getting-started:end -->';
const targetPaths = ['tdesign-component/README.md', 'tdesign-component/README_zh_CN.md', 'tdesign-site/site/docs/getting-started.md'];

function fixture(t, chinese) {
  const dir = mkdtempSync(path.join(tmpdir(), 'tdesign-readme-'));
  t.after(() => rmSync(dir, { recursive: true, force: true }));
  for (const folder of ['scripts', 'tdesign-component', 'tdesign-site/site/docs']) {
    mkdirSync(path.join(dir, folder), { recursive: true });
  }
  writeFileSync(path.join(dir, 'scripts/sync-readme.mjs'), script);
  writeFileSync(path.join(dir, 'README.md'), 'English README\n');
  writeFileSync(path.join(dir, 'README_zh_CN.md'), chinese);
  for (const target of targetPaths) writeFileSync(path.join(dir, target), 'existing content\n');
  return {
    run: () => execFileSync(process.execPath, [path.join(dir, 'scripts/sync-readme.mjs')], { stdio: 'pipe' }),
    read: (target) => readFileSync(path.join(dir, target), 'utf8'),
  };
}

test('sync preserves package READMEs and renders only the delimited guide without changing code indentation', (t) => {
  const body = '## 安装\n\n```dart\nclass App {\n  void run() {}\n}\n```';
  const chinese = `项目介绍\n${start}\n${body}\n${end}\n贡献者名单\n`;
  const f = fixture(t, chinese);
  f.run();
  assert.equal(f.read(targetPaths[0]), 'English README\n');
  assert.equal(f.read(targetPaths[1]), chinese);
  const guide = f.read(targetPaths[2]);
  assert.match(guide, /^---\ntitle: 快速开始\n/);
  assert.ok(guide.endsWith(`${body}\n`));
  assert.doesNotMatch(guide, /项目介绍|贡献者名单|getting-started:start/);
  f.run();
  assert.equal(f.read(targetPaths[2]), guide);
});

test('site navigation stays on the current origin while package links remain absolute', (t) => {
  const links = '[主题](https://tdesign.tencent.com/flutter/custom-theme#品牌色)\n[源码](https://github.com/Tencent/tdesign-flutter)';
  const chinese = `${start}\n${links}\n${end}`;
  const f = fixture(t, chinese);
  f.run();
  assert.equal(f.read(targetPaths[1]), chinese);
  assert.ok(f.read(targetPaths[2]).includes('[主题](/flutter/custom-theme#品牌色)'));
  assert.ok(f.read(targetPaths[2]).includes('[源码](https://github.com/Tencent/tdesign-flutter)'));
});

for (const [name, content] of [
  ['missing markers', '## 安装'],
  ['duplicate start', `${start}${start}正文${end}`],
  ['duplicate end', `${start}正文${end}${end}`],
  ['reversed markers', `${end}正文${start}`],
  ['empty content', `${start}\n  \n${end}`],
]) {
  test(`${name} fails before replacing any output`, (t) => {
    const f = fixture(t, content);
    assert.throws(f.run, /getting-started/);
    for (const target of targetPaths) assert.equal(f.read(target), 'existing content\n');
  });
}

test('committed README sources produce exactly the committed package and site outputs', (t) => {
  const chinese = readFileSync(path.join(root, 'README_zh_CN.md'), 'utf8');
  const f = fixture(t, chinese);
  const english = readFileSync(path.join(root, 'README.md'), 'utf8');
  // The fixture uses a fixed English source; compare the real English copy directly.
  assert.equal(readFileSync(path.join(root, targetPaths[0]), 'utf8'), english);
  f.run();
  assert.equal(f.read(targetPaths[1]), readFileSync(path.join(root, targetPaths[1]), 'utf8'));
  assert.equal(f.read(targetPaths[2]), readFileSync(path.join(root, targetPaths[2]), 'utf8'));
});

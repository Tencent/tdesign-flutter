// 验证调度边界与真实批处理的选项隔离、失败中止；全量产物另做双 SDK 对比。
import assert from 'node:assert/strict';
import { mkdtempSync, mkdirSync, readFileSync, writeFileSync, copyFileSync, readdirSync, realpathSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { dirname, join } from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import test from 'node:test';

function fixture(t) {
  const root = realpathSync(mkdtempSync(join(tmpdir(), 'api driver test ')));
  t.after(() => rmSync(root, {recursive: true, force: true}));
  for (const dir of ['tool', 'example/assets/api', 'source', 'bin', 'temp']) {
    mkdirSync(join(root, dir), {recursive: true});
  }
  copyFileSync(join(dirname(fileURLToPath(import.meta.url)), 'generate_api.mjs'), join(root, 'tool/generate_api.mjs'));
  writeFileSync(join(root, 'source/sample.dart'), 'class Sample {}');
  const components = [
    {slug: 'folder', source: {type: 'folder', path: 'source'}, api: {names: ['Sample'], functions: ['helper'], getComments: true}},
    {slug: 'file', source: {type: 'file', path: 'source/sample.dart'}, api: {names: ['Sample']}},
  ];
  writeFileSync(join(root, 'tool/components.json'), JSON.stringify({schemaVersion: 1, components}));
  for (const c of components) writeFileSync(join(root, 'example/assets/api', c.slug + '_api.md'), 'doc:' + c.slug + '\n');
  writeFileSync(join(root, 'bin/dart'), `#!${process.execPath}
const fs = require('node:fs');
const tasks = JSON.parse(fs.readFileSync(0, 'utf8'));
fs.appendFileSync(process.env.TRACE, JSON.stringify({args: process.argv.slice(2), tasks}) + '\\n');
if (process.env.FAIL_ENTRY) process.exit(9);
for (const task of tasks) {
  if (task.slug === process.env.FAIL_COMPONENT) process.exit(7);
  fs.writeFileSync(require('node:path').join(task.output, task.slug + '_api.md'), 'doc:' + task.slug + '\\n');
}
`, {mode: 0o755});
  const trace = join(root, 'trace.jsonl');
  return {
    root,
    run(args = [], extraEnv = {}) {
      writeFileSync(trace, '');
      const result = spawnSync(process.execPath, [join(root, 'tool/generate_api.mjs'), ...args], {
        cwd: tmpdir(), encoding: 'utf8', env: {
          ...process.env, PATH: join(root, 'bin') + ':' + process.env.PATH,
          TRACE: trace, TMPDIR: join(root, 'temp'), TMP: join(root, 'temp'), TEMP: join(root, 'temp'), ...extraEnv,
        },
      });
      const calls = readFileSync(trace, 'utf8').trim().split('\n').filter(Boolean).map(JSON.parse);
      assert.deepEqual(readdirSync(join(root, 'temp')), [], 'Temporary check directory leaked');
      return {...result, calls};
    },
  };
}

// 假可执行文件使用 POSIX shebang，CI 和本地 macOS 均可执行。
const options = {skip: process.platform === 'win32'};
test('one Dart invocation preserves task options and check/dry-run are read-only', options, (t) => {
  const f = fixture(t);
  const result = f.run(['--check']);
  assert.equal(result.status, 0, result.stderr);
  assert.equal(result.calls.length, 1);
  assert.deepEqual(result.calls[0].args, ['run', join(f.root, 'tool/generate_api_batch.dart')]);
  const [first, second] = result.calls[0].tasks;
  assert.deepEqual({...first, output: '<temporary>'}, {
    slug: 'folder', sourceType: 'folder', sourcePath: join(f.root, 'source'),
    names: ['Sample', 'helper'], getComments: true, output: '<temporary>',
  });
  assert.equal(second.sourceType, 'file');
  assert.equal(second.sourcePath, join(f.root, 'source/sample.dart'));
  assert.equal(second.getComments, false);
  const dry = f.run(['--dry-run']);
  assert.equal(dry.status, 0, dry.stderr);
  assert.deepEqual(dry.calls, []);
  assert.match(dry.stdout, /tdesign_flutter_tools:main/);
  const doc = join(f.root, 'example/assets/api/folder_api.md');
  writeFileSync(doc, 'stale\n');
  const drift = f.run(['--check']);
  assert.notEqual(drift.status, 0);
  assert.match(drift.stderr, /Stale API documents: folder_api.md/);
  assert.equal(readFileSync(doc, 'utf8'), 'stale\n');
  assert.equal(f.run().status, 0);
  assert.equal(readFileSync(doc, 'utf8'), 'doc:folder\n');
});

test('entry and component failures propagate and clean up; invalid flags never start Dart', options, (t) => {
  const f = fixture(t);
  for (const [env, code] of [[{FAIL_ENTRY: '1'}, 9], [{FAIL_COMPONENT: 'folder'}, 7]]) {
    const result = f.run(['--check'], env);
    assert.notEqual(result.status, 0);
    assert.equal(result.calls.length, 1);
    assert.match(result.stderr, new RegExp('API generation failed \\(' + code + '\\)'));
  }
  const invalid = f.run(['--unknown']);
  assert.notEqual(invalid.status, 0);
  assert.deepEqual(invalid.calls, []);
  const manifest = join(f.root, 'tool/components.json');
  const content = JSON.parse(readFileSync(manifest, 'utf8'));
  content.components[0].source.type = 'unsupported';
  writeFileSync(manifest, JSON.stringify(content));
  const invalidType = f.run();
  assert.notEqual(invalidType.status, 0);
  assert.deepEqual(invalidType.calls, []);
});

test('real batch preserves per-component options and stops at the first generation error', (t) => {
  const root = realpathSync(mkdtempSync(join(tmpdir(), 'api batch test ')));
  t.after(() => rmSync(root, {recursive: true, force: true}));
  const source = join(root, 'sample.dart');
  writeFileSync(source, '/// Sample introduction.\nclass Sample {}\n/// Unselected type.\nclass Other {}\n');
  const task = {sourceType: 'file', sourcePath: source, names: ['Sample'], getComments: true, output: root + '/'};
  const tasks = [
    {...task, slug: 'with_comments'},
    {...task, slug: 'without_comments', getComments: false},
    {...task, slug: 'broken', sourcePath: join(root, 'missing.dart')},
    {...task, slug: 'must_not_run'},
  ];
  const result = spawnSync('dart', ['run', join(dirname(fileURLToPath(import.meta.url)), 'generate_api_batch.dart')], {
    cwd: join(dirname(fileURLToPath(import.meta.url)), '..'),
    input: JSON.stringify(tasks), encoding: 'utf8',
  });
  assert.equal(result.status, 1, result.stderr);
  assert.match(result.stderr, /broken: API generation failed/);
  const withComments = readFileSync(join(root, 'with_comments_api.md'), 'utf8');
  const withoutComments = readFileSync(join(root, 'without_comments_api.md'), 'utf8');
  assert.match(withComments, /Sample introduction/);
  assert.doesNotMatch(withoutComments, /Sample introduction/);
  assert.doesNotMatch(withComments, /Unselected type/);
  assert.deepEqual(readdirSync(root).sort(), ['sample.dart', 'with_comments_api.md', 'without_comments_api.md']);
});

// Exercise the real shell entry with isolated executables, including failure exit codes.
import assert from 'node:assert/strict';
import { copyFileSync, mkdirSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { dirname, join } from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import test from 'node:test';

function fixture(t) {
  const root = mkdtempSync(join(tmpdir(), 'tooling-entry-'));
  t.after(() => rmSync(root, {recursive: true, force: true}));
  for (const dir of ['scripts', 'tdesign-component/tool', 'packages/css2token', 'bin']) {
    mkdirSync(join(root, dir), {recursive: true});
  }
  const entry = join(root, 'scripts/run-tooling-checks.sh');
  copyFileSync(join(dirname(fileURLToPath(import.meta.url)), 'run-tooling-checks.sh'), entry);
  writeFileSync(join(root, 'tdesign-component/tool/sample_test.mjs'), '');
  const trace = join(root, 'trace.jsonl');
  for (const executable of ['dart', 'flutter', 'node']) {
    writeFileSync(join(root, 'bin', executable), `#!${process.execPath}
const fs = require('node:fs');
const tool = require('node:path').basename(process.argv[1]);
const args = process.argv.slice(2);
fs.appendFileSync(process.env.TOOLING_TRACE, JSON.stringify({tool, args, cwd: process.cwd()}) + '\\n');
if (tool === process.env.FAIL_TOOL && (!process.env.FAIL_ARGUMENT || args.includes(process.env.FAIL_ARGUMENT))) process.exit(7);
`, {mode: 0o755});
  }
  return (args = [], extraEnv = {}) => {
    writeFileSync(trace, '');
    const result = spawnSync('bash', [entry, ...args], {
      cwd: tmpdir(), encoding: 'utf8',
      env: {...process.env, PATH: join(root, 'bin') + ':' + process.env.PATH, TOOLING_TRACE: trace, ...extraEnv},
    });
    const calls = readFileSync(trace, 'utf8').trim().split('\n').filter(Boolean).map(JSON.parse);
    return {...result, calls};
  };
}

const options = {skip: process.platform === 'win32'};
test('full entry uses one ordered sequence and discovers the tool test directory', options, (t) => {
  const result = fixture(t)();
  assert.equal(result.status, 0, result.stderr);
  assert.deepEqual(result.calls.map((c) => c.tool), [
    'dart', 'dart', 'dart', 'dart', 'flutter', 'node', 'node', 'node', 'dart', 'node', 'dart', 'dart', 'node',
  ]);
  assert.ok(result.calls.slice(0, 3).every((c) => c.cwd.endsWith('/packages/css2token')));
  assert.ok(result.calls.slice(3).every((c) => c.cwd.endsWith('/tdesign-component')));
  assert.deepEqual(result.calls[4].args, ['test', '--no-pub', 'test/tool']);
  assert.ok(result.calls.some((c) => c.args[0] === 'tool/generate_api.mjs' && c.args.includes('--check')));
  assert.ok(result.calls.some((c) => c.args.some((a) => a.endsWith('/scripts/sync-readme.mjs')) && c.args.includes('--check')));
});

test('a selected step executes alone and invalid arguments never launch a tool', options, (t) => {
  const run = fixture(t);
  const result = run(['api-docs']);
  assert.equal(result.status, 0, result.stderr);
  assert.equal(result.calls.length, 1);
  assert.deepEqual(result.calls[0].args, ['tool/generate_api.mjs', '--check']);
  for (const args of [['unknown'], ['tool-tests', 'api-docs']]) {
    const invalid = run(args);
    assert.equal(invalid.status, 64);
    assert.deepEqual(invalid.calls, []);
  }
});

test('whole entry and multi-command steps stop on the original failure', options, (t) => {
  const run = fixture(t);
  const full = run([], {FAIL_TOOL: 'flutter'});
  assert.equal(full.status, 7);
  assert.equal(full.calls.length, 5);
  assert.equal(full.calls.at(-1).tool, 'flutter');
  const css = run(['css2token'], {FAIL_TOOL: 'dart', FAIL_ARGUMENT: 'pub'});
  assert.equal(css.status, 7);
  assert.equal(css.calls.length, 1);
});

test('GitHub and CNB execute the complete shared tooling sequence', () => {
  const scripts = dirname(fileURLToPath(import.meta.url));
  const entry = readFileSync(join(scripts, 'run-tooling-checks.sh'), 'utf8');
  const steps = entry.match(/^steps=\(([^)]+)\)/m)[1].trim().split(/\s+/);
  const github = readFileSync(join(scripts, '../.github/workflows/test-build.yml'), 'utf8');
  const selected = [...github.matchAll(/run: bash scripts\/run-tooling-checks\.sh (\S+)/g)].map((m) => m[1]);
  assert.deepEqual(selected, steps);
  const cnb = readFileSync(join(scripts, '../.cnb/.reusable-stages.yml'), 'utf8');
  assert.match(cnb, /script: bash scripts\/with-tooling-node\.sh bash scripts\/run-tooling-checks\.sh\n/);
  assert.equal([...cnb.matchAll(/!reference \[\.tooling-checks\]/g)].length, 2);
});

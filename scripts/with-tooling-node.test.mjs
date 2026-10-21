// Verify cache reuse and fail-closed bootstrap behavior without network access.
import assert from 'node:assert/strict';
import { copyFileSync, existsSync, mkdirSync, mkdtempSync, readFileSync, readdirSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { dirname, join } from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import test from 'node:test';

function fixture(t, cachedVersion) {
  const root = mkdtempSync(join(tmpdir(), 'tooling-node-'));
  t.after(() => rmSync(root, {recursive: true, force: true}));
  const source = join(dirname(fileURLToPath(import.meta.url)), 'with-tooling-node.sh');
  const version = readFileSync(source, 'utf8').match(/^version=(\S+)/m)[1];
  const entry = join(root, 'with-tooling-node.sh');
  copyFileSync(source, entry);
  const bin = join(root, 'bin');
  const cache = join(root, 'cache');
  mkdirSync(bin);
  mkdirSync(cache);
  const executable = (path, body) => writeFileSync(path, `#!${process.execPath}\n${body}`, {mode: 0o755});
  executable(join(bin, 'node'), "console.log('v0');");
  executable(join(bin, 'uname'), "console.log(process.env.FAKE_OS === 'other' ? 'Other' : process.argv[2] === '-s' ? 'Linux' : 'x86_64');");
  const downloaded = join(root, 'downloaded');
  const extracted = join(root, 'extracted');
  executable(join(bin, 'curl'), `const fs = require('node:fs'); fs.writeFileSync(${JSON.stringify(downloaded)}, ''); const args = process.argv.slice(2); fs.writeFileSync(args[args.indexOf('--output') + 1], 'bad archive');`);
  executable(join(bin, 'sha256sum'), 'process.stdin.resume(); process.stdin.on("end", () => process.exit(1));');
  executable(join(bin, 'tar'), `require('node:fs').writeFileSync(${JSON.stringify(extracted)}, ''); process.exit(99);`);
  if (cachedVersion) {
    const runtime = join(cache, `node-v${version}-linux-x64/bin`);
    mkdirSync(runtime, {recursive: true});
    executable(join(runtime, 'node'), `console.log(${JSON.stringify(cachedVersion === 'valid' ? 'v' + version : 'v0')});`);
  }
  return {
    cache, downloaded, extracted, version,
    run(args = ['bash', '-c', 'node --version'], extraEnv = {}) {
      return spawnSync('bash', [entry, ...args], {
        encoding: 'utf8',
        env: {...process.env, PATH: bin + ':' + process.env.PATH, TOOLING_NODE_CACHE: cache, ...extraEnv},
      });
    },
  };
}

const options = {skip: process.platform === 'win32'};
test('a verified-version cache supplies Node to the child without downloading', options, (t) => {
  const f = fixture(t, 'valid');
  const result = f.run();
  assert.equal(result.status, 0, result.stderr);
  assert.match(result.stdout, new RegExp('Tooling Node: v' + f.version.replaceAll('.', '\\.')));
  assert.ok(!existsSync(f.downloaded));
});

test('checksum failure cleans temporary files and never extracts or runs the command', options, (t) => {
  const f = fixture(t);
  const result = f.run();
  assert.equal(result.status, 1);
  assert.ok(existsSync(f.downloaded));
  assert.ok(!existsSync(f.extracted));
  assert.deepEqual(readdirSync(f.cache), []);
  assert.doesNotMatch(result.stdout, /Tooling Node:/);
});

test('wrong cached versions, unsupported platforms and missing commands fail', options, (t) => {
  const f = fixture(t, 'invalid');
  assert.equal(f.run().status, 1);
  assert.equal(f.run([], {}).status, 64);
  assert.equal(f.run(undefined, {FAKE_OS: 'other'}).status, 69);
  assert.ok(!existsSync(f.downloaded));
});

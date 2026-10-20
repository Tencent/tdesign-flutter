import assert from 'node:assert/strict';
import { test } from 'node:test';
import { demoBuildMetadata } from './demo-build-metadata.mjs';

test('new preview builds upgrade old date-based APKs and increase across runs', () => {
  const first = demoBuildMetadata('1.0.0', '1979', '1178');
  const next = demoBuildMetadata('1.0.0', '1980', '1178');
  assert.ok(Number(first.buildNumber) > 2026102001);
  assert.equal(Number(next.buildNumber), Number(first.buildNumber) + 1);
  assert.deepEqual(first, { version: '1.0.0', buildNumber: '2030001979', prNumber: '1178' });
});

test('invalid metadata and exhausted Android version codes fail before packaging', () => {
  for (const args of [
    ['1.0', '1'], ['1.0.0\ncommand', '1'], ['1.0.0', '0'],
    ['1.0.0', '1.5'], ['1.0.0', '70000001'], ['1.0.0', '1', '2\n3'],
  ]) assert.throws(() => demoBuildMetadata(...args));
  assert.equal(demoBuildMetadata('1.0.0-beta.1+4', '70000000').buildNumber, '2100000000');
});

import assert from 'node:assert/strict';
import test from 'node:test';

import { flutterExampleLiveUrl } from './live-url.mjs';

test('uses the bundled Flutter Web path in production', () => {
  assert.equal(
    flutterExampleLiveUrl('button'),
    '/flutter/example/#button',
  );
});

test('uses the colocated Flutter Web dev server in development', () => {
  assert.equal(
    flutterExampleLiveUrl('side-bar', {
      dev: true,
      hostname: 'localhost',
      devServerPort: '29001',
    }),
    'http://localhost:29001/#side-bar',
  );
});

test('encodes unsafe component names and rejects an empty name', () => {
  assert.equal(
    flutterExampleLiveUrl('name with spaces'),
    '/flutter/example/#name%20with%20spaces',
  );
  assert.throws(() => flutterExampleLiveUrl(''), /Missing Flutter example component name/);
});

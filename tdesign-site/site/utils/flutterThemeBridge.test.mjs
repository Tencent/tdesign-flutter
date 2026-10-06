import assert from 'node:assert/strict';
import test from 'node:test';
import {readFileSync} from 'node:fs';
import { loadControllerBaseline } from './controllerBaseline.mjs';
import { createFlutterCssThemeMessage, ensureFlutterThemeTokenCoverage } from './flutterThemeBridge.mjs';

test('completes controller CSS idempotently without replacing provided values', () => {
  const css = ':root { --td-size-6: 24px; --td-line-height-body-medium: 30px; }';
  const completed = ensureFlutterThemeTokenCoverage(css);
  assert.equal(ensureFlutterThemeTokenCoverage(completed), completed);
  assert.match(completed, /--td-size-6: 24px/);
  assert.match(completed, /--td-size-16: 72px/);
  assert.match(completed, /--td-line-height-body-medium: 30px/);
});

test('sends raw CSS and pristine baseline for conversion in Dart', () => {
  const baseline = loadControllerBaseline();
  const css = {light: '--td-brand-color:#123;',dark: '--td-brand-color:#abc;',extra:''};
  const message = createFlutterCssThemeMessage(css, 'dark', baseline);
  assert.equal(message.type, 'flutter-css-theme-update');
  assert.equal(message.themeMode, 'dark');
  assert.equal(message.css.light, css.light);
  assert.equal(message.css.dark, css.dark);
  assert.equal(message.baseline.light, baseline.light);
  assert.equal(message.baseline.dark, baseline.dark);
  assert.equal('theme' in message, false);
  assert.deepEqual(JSON.parse(JSON.stringify(message)), message);
  assert.equal(css.extra, '');
});

test('default CSS and baseline receive identical controller completion', () => {
  const baseline = loadControllerBaseline();
  const message = createFlutterCssThemeMessage(baseline, 'light', baseline);
  assert.deepEqual(message.css, message.baseline);
  assert.equal(createFlutterCssThemeMessage(baseline, 'system', baseline).themeMode, 'light');
});

test('Dart integration fixture matches the installed controller version', () => {
  const fixture = JSON.parse(readFileSync(new URL('../../../packages/css2token/test/fixtures/controller-defaults.json', import.meta.url), 'utf8'));
  assert.deepEqual(fixture, loadControllerBaseline());
});

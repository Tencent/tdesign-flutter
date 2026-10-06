import assert from 'node:assert/strict';
import test from 'node:test';
import {readFileSync} from 'node:fs';
import { loadControllerBaseline, loadControllerExtraDefaults } from './controllerBaseline.mjs';
import { createFlutterCssThemeMessage, ensureFlutterThemeTokenCoverage } from './flutterThemeBridge.mjs';

const extraDefaults = loadControllerExtraDefaults();

test('completes controller CSS idempotently without replacing provided values', () => {
  const css = ':root { --td-size-6: 24px; --td-line-height-body-medium: 30px; }';
  const completed = ensureFlutterThemeTokenCoverage(css, extraDefaults);
  assert.equal(ensureFlutterThemeTokenCoverage(completed, extraDefaults), completed);
  assert.match(completed, /--td-size-6: 24px/);
  assert.match(completed, /--td-size-16: 72px/);
  assert.match(completed, /--td-line-height-body-medium: 30px/);
});

test('sends raw CSS and pristine baseline for conversion in Dart', () => {
  const baseline = loadControllerBaseline();
  const css = {light: '--td-brand-color:#123;',dark: '--td-brand-color:#abc;',extra:''};
  const message = createFlutterCssThemeMessage(css, 'dark', baseline, extraDefaults);
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
  const message = createFlutterCssThemeMessage(baseline, 'light', baseline, extraDefaults);
  assert.deepEqual(message.css, message.baseline);
  assert.equal(createFlutterCssThemeMessage(baseline, 'system', baseline, extraDefaults).themeMode, 'light');
});

test('Dart integration fixture matches the installed controller version', () => {
  const fixture = JSON.parse(readFileSync(new URL('../../../packages/css2token/test/fixtures/controller-defaults.json', import.meta.url), 'utf8'));
  assert.deepEqual(fixture, loadControllerBaseline());
});

test('completion uses installed upstream declarations and preserves every mobile value', () => {
  const declarations = (css) => new Map([...css.matchAll(/(--td-[\w-]+)\s*:\s*([^;]+);/g)]
    .map((match) => [match[1], match[2].trim()]));
  const mobile = declarations(loadControllerBaseline().extra);
  const web = declarations(extraDefaults);
  const completed = declarations(ensureFlutterThemeTokenCoverage(loadControllerBaseline().extra, extraDefaults));
  assert.ok(web.size > 0);
  for (const [name, value] of web) assert.equal(completed.get(name), mobile.get(name) ?? value, name);
  for (const [name, value] of mobile) assert.equal(completed.get(name), value, name);
  assert.equal(completed.has('--td-line-height-body-extraLarge'), false);
});

test('completion follows supplied dependency defaults without a stale local copy', () => {
  assert.equal(ensureFlutterThemeTokenCoverage('', ':root { --td-size-6: 17.5px; }'),
    '\n:root {\n  --td-size-6: 17.5px;\n}\n');
});

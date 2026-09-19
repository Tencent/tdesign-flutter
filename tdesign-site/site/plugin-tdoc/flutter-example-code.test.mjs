import assert from 'node:assert/strict';
import test from 'node:test';

import {
  listFlutterExampleKeys,
  readFlutterExampleCode,
  replaceFlutterExampleDirectives,
} from './flutter-example-code.mjs';

test('resolves representative Table, Stepper and Form assets', () => {
  const cases = [
    ['table.TableBasicExample', 'class TableBasicExample'],
    ['stepper.StepperBaseExample', 'class StepperBaseExample'],
    ['form.FormBasicDemo', 'class FormBasicDemo'],
  ];

  for (const [assetKey, declaration] of cases) {
    assert.match(readFlutterExampleCode(assetKey), new RegExp(declaration));
  }
});

test('renders the generated Dart source into the Web code block', () => {
  const expected = readFlutterExampleCode('table.TableBasicExample');
  const source = replaceFlutterExampleDirectives('### 基础表格\n\n{{ flutter-example table.TableBasicExample }}');
  assert.match(source, /<td-code-block panel="Dart">/);
  assert.match(source, /lang="dart"/);
  const encoded = source.match(/<pre slot="Dart" lang="dart">(.+)<\/pre>/s)[1];
  assert.equal(decodeURIComponent(encoded), expected);
});

test('renders every generated source in a component group', () => {
  const keys = listFlutterExampleKeys('table');
  const source = replaceFlutterExampleDirectives('{{ flutter-example-group table }}');

  assert.equal(keys.length, 9);
  for (const key of keys) {
    assert.ok(source.includes(`#### \`${key.slice('table.'.length)}\``));
    assert.ok(source.includes(encodeURIComponent(readFlutterExampleCode(key))));
  }
  assert.doesNotMatch(source, /flutter-example/);
});

test('rejects unsafe, malformed and missing mappings', () => {
  assert.throws(() => readFlutterExampleCode('../secret'), /Invalid Flutter example asset key/);
  assert.throws(() => replaceFlutterExampleDirectives('{{ flutter-example }}'), /Invalid Flutter example directive/);
  assert.throws(
    () => replaceFlutterExampleDirectives('{{ flutter-example form.FormBasicDemo }}\n{{ flutter-example }}'),
    /Invalid Flutter example directive/,
  );
  assert.throws(() => readFlutterExampleCode('table.MissingExample'), /Missing Flutter example code asset/);
  assert.throws(
    () => replaceFlutterExampleDirectives('{{ flutter-example-group missing }}'),
    /Missing Flutter example code group/,
  );
});

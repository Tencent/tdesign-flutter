import assert from 'node:assert/strict';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import {
  listFlutterExampleKeys,
  readFlutterExampleCode,
  readFlutterExampleGroup,
  replaceFlutterExampleDirectives,
} from './transform.mjs';

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
  const modules = readFlutterExampleGroup('table');
  const source = replaceFlutterExampleDirectives('{{ flutter-example-group table }}');

  assert.equal(keys.length, 9);
  for (const module of modules) {
    assert.ok(source.includes(`### ${module.title}`));
    for (const item of module.items) {
      const fallback = `\`${item.assetKey.slice('table.'.length)}\``;
      assert.ok(source.includes(`#### ${item.description || fallback}`));
      assert.ok(
        source.includes(encodeURIComponent(readFlutterExampleCode(item.assetKey))),
      );
    }
  }
  assert.doesNotMatch(source, /flutter-example/);
});

test('renders Divider in its registered ExampleItem order', () => {
  const keys = listFlutterExampleKeys('divider');
  assert.deepEqual(keys, [
    'divider.DividerBaseExample',
    'divider.DividerDashedExample',
  ]);

  const source = replaceFlutterExampleDirectives('{{ flutter-example-group divider }}');
  assert.match(source, /### 组件类型/);
  assert.match(source, /#### 水平分割线/);
  assert.match(source, /### 组件状态/);
  assert.match(source, /#### 虚线样式/);
  assert.doesNotMatch(source, /#### `DividerBaseExample`/);
  assert.ok(
    source.indexOf('#### 水平分割线') < source.indexOf('#### 虚线样式'),
  );
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

test('uses strict manifest order and excludes unregistered assets', () => {
  const directory = fs.mkdtempSync(path.join(os.tmpdir(), 'flutter-example-code-'));
  try {
    fs.writeFileSync(path.join(directory, 'sample.First.txt'), 'first');
    fs.writeFileSync(path.join(directory, 'sample.Second.txt'), 'second');
    fs.writeFileSync(path.join(directory, 'sample.Unregistered.txt'), 'hidden');
    fs.writeFileSync(
      path.join(directory, 'manifest.json'),
      JSON.stringify({
        version: 1,
        groups: {
          sample: [
            {
              title: '类型',
              items: [
                { description: '第二项', assetKey: 'sample.Second' },
                { description: '第一项', assetKey: 'sample.First' },
              ],
            },
          ],
        },
        legacyGroups: [],
      }),
    );

    assert.deepEqual(listFlutterExampleKeys('sample', directory), [
      'sample.Second',
      'sample.First',
    ]);
  } finally {
    fs.rmSync(directory, { recursive: true, force: true });
  }
});

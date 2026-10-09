import assert from 'node:assert/strict';
import test from 'node:test';

import { validateComponentPage } from './page-contract.mjs';

const generatedPage = `---
title: Text 文本
isComponent: true
---

## 代码演示

{{ flutter-example-group text }}

{{ flutter-api text }}
`;

test('rejects stale handwritten snippets even when generated mappings are valid', () => {
  const staleCode = "\n## 基础用法\n\n```dart\nTText('文本', textColor: Colors.red)\n```\n";
  assert.equal(validateComponentPage(generatedPage, 'text', 'text'), null);
  assert.match(validateComponentPage(generatedPage + staleCode, 'text', 'text'), /hand-maintained code/);
});

test('rejects copied API tables, migration prose and raw Dart panels', () => {
  for (const extra of [
    '\n## Theme\n\n| 参数 | 默认值 |\n|---|---|\n| showText | true |\n',
    '\n## 迁移说明\n\n使用旧参数 textColor。\n',
    '\n<td-code-block panel="Dart">旧示例</td-code-block>\n',
  ]) {
    assert.match(validateComponentPage(generatedPage + extra, 'text', 'text'), /forbidden/);
  }
});

test('requires the generated API for the same component', () => {
  assert.match(validateComponentPage(generatedPage.replace('flutter-api text', 'flutter-api input'), 'text', 'text'), /generated example group and API/);
});

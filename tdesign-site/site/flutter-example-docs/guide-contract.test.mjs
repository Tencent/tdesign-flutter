import assert from 'node:assert/strict';
import fs from 'node:fs';
import { test } from 'node:test';
import { guideExamples, validateGuidePage } from './guide-contract.mjs';
import { replaceFlutterExampleDirectives } from './transform.mjs';

for (const slug of ['custom-theme', 'dark-mode']) {
  const source = fs.readFileSync(new URL(`../docs/${slug}.md`, import.meta.url), 'utf8');
  test(`${slug}: page maps one preview to actual generated source`, () => {
    validateGuidePage(source, slug);
    const rendered = replaceFlutterExampleDirectives(source);
    assert.equal((rendered.match(/<td-code-block\s+panel="Dart">/g) ?? []).length, 1);
    assert.ok(!rendered.includes('{{ flutter-example'));
  });
  for (const [name, mutate] of [
    ['old mount marker', (s) => s + '<div data-flutter-guide-preview></div>'],
    ['missing route', (s) => s.replace(`flutterPreview: ${slug}`, '')],
    ['wrong route', (s) => s.replace(`flutterPreview: ${slug}`, 'flutterPreview: unknown')],
    ['wrong source', (s) => s.replace(guideExamples[slug], 'theme.ThemeDemo')],
    ['old height override', (s) => s.replace('flutterPreview:', 'flutterPreviewHeight: 360\nflutterPreview:')],
  ]) {
    test(`${slug}: rejects ${name}`, () => {
      assert.throws(() => validateGuidePage(mutate(source), slug));
    });
  }
}
test('ordinary documentation does not require a Flutter preview', () => {
  assert.doesNotThrow(() => validateGuidePage('---\ntitle: Guide\n---\nText', 'internationalization'));
});

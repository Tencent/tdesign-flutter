/** Component pages keep metadata and generated entry points only. */
export function validateComponentPage(source, exampleGroup, apiSlug) {
  const metadata = source.match(/^---\r?\n[\s\S]*?\r?\n---\r?\n/);
  if (!metadata) return 'missing component metadata';
  const body = source.slice(metadata[0].length).trim();
  const expected = `## 代码演示\n\n{{ flutter-example-group ${exampleGroup} }}\n\n{{ flutter-api ${apiSlug} }}`;
  return body === expected
    ? null
    : 'component body must contain only the generated example group and API; hand-maintained code, API descriptions, and migration sections are forbidden';
}

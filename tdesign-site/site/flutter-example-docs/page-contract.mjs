/** Component pages keep generated entry points, with an optional FAQ. */
export function validateComponentPage(source, exampleGroup, apiSlug) {
  const metadata = source.match(/^---\r?\n[\s\S]*?\r?\n---\r?\n/);
  if (!metadata) return 'missing component metadata';
  const body = source.slice(metadata[0].length).trim();
  const expected = `## 代码演示\n\n{{ flutter-example-group ${exampleGroup} }}\n\n{{ flutter-api ${apiSlug} }}`;
  if (body === expected) return null;
  const faqPrefix = `${expected}\n\n## FAQ\n\n`;
  if (body.startsWith(faqPrefix)) {
    const faq = body.slice(faqPrefix.length);
    if (/^### .+\n\n\S/.test(faq)
      && !/^#{1,2} /m.test(faq)
      && !/^\s*\|/m.test(faq)
      && !/\{\{\s*flutter-|<td-code-block\b/.test(faq)) return null;
  }
  return 'component body must contain only the generated example group and API, optionally followed by FAQ; hand-maintained code, API descriptions, and migration sections outside FAQ are forbidden';
}

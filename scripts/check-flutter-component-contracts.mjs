import { existsSync, readFileSync } from 'node:fs';
import { join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = resolve(fileURLToPath(new URL('.', import.meta.url)), '..');
const siteConfig = readFileSync(
  join(root, 'tdesign-site/site/site.config.mjs'),
  'utf8',
);
const exampleConfig = readFileSync(
  join(root, 'tdesign-component/example/lib/config.dart'),
  'utf8',
);
const docsDir = join(root, 'tdesign-site/docs/components');
const apiManifest = JSON.parse(
  readFileSync(join(root, 'tdesign-component/tool/components.json'), 'utf8'),
);

const normalize = (value) => value.replace(/[-_]/g, '').toLowerCase();
const routeSource = siteConfig
  .replace(/\/\*[\s\S]*?\*\//g, '')
  .replace(/\/\/.*$/gm, '');
const routeSlugs = [
  ...routeSource.matchAll(/@component-docs\/([^']+)\/README\.md/g),
].map((match) => match[1]);
const exampleNames = new Set(
  [...exampleConfig.matchAll(/name:\s*'([^']+)'/g)].map((match) =>
    normalize(match[1]),
  ),
);
const apiBySlug = new Map(apiManifest.components.map((component) => [component.slug, component]));

const errors = [];
const seen = new Set();
for (const slug of routeSlugs) {
  if (!seen.add(slug)) {
    errors.push(`duplicate site route: ${slug}`);
  }
  if (!existsSync(join(docsDir, slug, 'README.md'))) {
    errors.push(`missing component doc: docs/components/${slug}/README.md`);
  }
  const apiComponent = apiBySlug.get(slug);
  if (!apiComponent) {
    errors.push(`missing API manifest entry for site route: ${slug}`);
  } else if (!existsSync(join(root, 'tdesign-component', apiComponent.source.path))) {
    errors.push(`missing component source for site route: ${slug}`);
  } else if (!existsSync(join(root, 'tdesign-component/example/assets/api', `${slug}_api.md`))) {
    errors.push(`missing generated API document for site route: ${slug}`);
  }
  if (!exampleNames.has(normalize(slug))) {
    errors.push(`missing Example page registration for site route: ${slug}`);
  }
}

if (errors.length > 0) {
  console.error(errors.map((error) => `[component-contracts] ${error}`).join('\n'));
  process.exitCode = 1;
} else {
  console.log(
    `[component-contracts] ${routeSlugs.length} site routes have source, Example, and docs entries`,
  );
}

import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { guideLinks } from '../../../scripts/documentation.mjs';

const root = fileURLToPath(new URL('../../../', import.meta.url));

/** Display the canonical contribution guide without maintaining a site copy. */
export function adaptRepositoryDocument(source, file) {
  if (path.resolve(file) !== path.join(root, 'CONTRIBUTING.md')) return source;
  const content = source.replace(/^# CONTRIBUTING\s*\n/, '').replace(
    /\]\((\.\.?\/[^)]+)\)/g,
    (_, target) => `](https://github.com/Tencent/tdesign-flutter/blob/develop/${target.replace(/^\.\//, '')})`,
  );
  return `---\ntitle: 贡献指南\ndescription: TDesign Flutter 开发与贡献规范。\nspline: explain\n---\n\n${content}`;
}

/** Resolve portable guide links to the existing public page routes. */
export function adaptGuideLinks(source, file) {
  const guides = path.join(root, 'tdesign-site/site/docs');
  if (path.dirname(path.resolve(file)) !== guides) return source;
  return guideLinks(source);
}

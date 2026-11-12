import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { guideLinks, migrationSource } from '../../../scripts/documentation.mjs';

const root = fileURLToPath(new URL('../../../', import.meta.url));

/** Display the canonical contribution guide without maintaining a site copy. */
export function adaptRepositoryDocument(source, file) {
  if (path.resolve(file) !== path.join(root, 'CONTRIBUTING.md')) return source;
  const content = source.replace(/^# (?:CONTRIBUTING|贡献指南)\s*\n/, '').replace(
    /\]\((\.\.?\/[^)]+)\)/g,
    (_, target) => `](https://github.com/Tencent/tdesign-flutter/blob/develop/${target.replace(/^\.\//, '')})`,
  );
  return `---\ntitle: 贡献指南\ndescription: TDesign Flutter 开发与贡献规范。\nspline: explain\n---\n\n${content}`;
}

/** Resolve portable guide links to the existing public page routes. */
export function adaptGuideLinks(source, file) {
  const guides = path.join(root, 'tdesign-site/site/docs');
  if (path.dirname(path.resolve(file)) !== guides) return source;
  const adapted = guideLinks(source);
  // The site already renders this title in td-doc-header. Keep its old fragment
  // without repeating the visible heading; the portable Markdown keeps its H1.
  return path.resolve(file) === path.join(root, migrationSource)
    ? adapted.replace(/^# 从 0\.2\.7 升级到 1\.0[ \t]*$/m, '<a id="从-0-2-7-升级到-1-0"></a>')
    : adapted;
}

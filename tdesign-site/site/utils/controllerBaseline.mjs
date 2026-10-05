import { readFileSync } from 'node:fs';
import { createRequire } from 'node:module';

const require = createRequire(import.meta.url);

// The package exposes a Web Component, but no API for its default CSS.
// Extract the three raw-loader JSON strings without executing the bundle.
// Fail visibly if a package upgrade changes this format.
export function loadControllerBaseline() {
  const source = readFileSync(require.resolve('@tdesign/theme-generator'), 'utf8');
  const result = {};
  for (const part of ['light', 'dark', 'extra']) {
    const marker = `./src/common/themes/built-in/css/mobile/TDesign/${part}.css`;
    const start = source.indexOf(marker);
    if (start < 0) throw new Error(`Missing controller baseline: ${part}`);
    const line = source.slice(source.indexOf('\n', start) + 1).split('\n', 1)[0];
    const match = line.match(/= \(("(?:[^"\\]|\\.)*")\);$/);
    if (!match) throw new Error(`Unsupported controller CSS bundle: ${part}`);
    result[part] = JSON.parse(match[1]);
  }
  return result;
}

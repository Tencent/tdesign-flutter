import { readFileSync } from 'node:fs';
import { createRequire } from 'node:module';

const require = createRequire(import.meta.url);

// The package exposes a Web Component, but no API for its default CSS.
// Extract raw-loader JSON strings without executing the bundle.
// Fail visibly if a package upgrade changes this format.
function loadControllerCss(device, parts) {
  const source = readFileSync(require.resolve('@tdesign/theme-generator'), 'utf8');
  const result = {};
  for (const part of parts) {
    const marker = `./src/common/themes/built-in/css/${device}/TDesign/${part}.css`;
    const start = source.indexOf(marker);
    if (start < 0) throw new Error(`Missing controller CSS: ${device}/${part}`);
    const line = source.slice(source.indexOf('\n', start) + 1).split('\n', 1)[0];
    const match = line.match(/= \(("(?:[^"\\]|\\.)*")\);$/);
    if (!match) throw new Error(`Unsupported controller CSS bundle: ${device}/${part}`);
    result[part] = JSON.parse(match[1]);
  }
  return result;
}

export function loadControllerBaseline() {
  return loadControllerCss('mobile', ['light', 'dark', 'extra']);
}

// Mobile panels also read size/line-height declarations defined by web extra.
// Use the installed package's declarations, never a copied default-value table.
export function loadControllerExtraDefaults() {
  return loadControllerCss('web', ['extra']).extra;
}

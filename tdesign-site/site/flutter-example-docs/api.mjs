import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

export const defaultApiDirectory = fileURLToPath(new URL('../../../tdesign-component/example/assets/api/', import.meta.url));

/** Render the same generated API used by the Flutter Demo. */
export function replaceFlutterApiDirectives(source, apiDirectory = defaultApiDirectory) {
  return source.replace(/\{\{\s*flutter-api\s+([^\s}]+)\s*\}\}/g, (_, slug) => {
    if (!/^[a-z0-9-]+$/.test(slug)) throw new Error(`Invalid Flutter API slug: ${slug}`);
    const file = path.join(apiDirectory, `${slug}_api.md`);
    if (!fs.existsSync(file)) throw new Error(`Missing generated Flutter API: ${slug}`);
    const api = fs.readFileSync(file, 'utf8');
    if (!api.startsWith('## API\n')) throw new Error(`Invalid generated Flutter API: ${slug}`);
    return api.trimEnd();
  });
}

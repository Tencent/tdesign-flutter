import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const directivePattern = /\{\{\s*flutter-example\s+([^\s}]+)\s*\}\}/g;
const groupDirectivePattern = /\{\{\s*flutter-example-group\s+([^\s}]+)\s*\}\}/g;
const assetKeyPattern = /^[A-Za-z0-9_-]+\.[A-Za-z_][A-Za-z0-9_]*$/;
const groupPattern = /^[A-Za-z0-9_-]+$/;
const pluginDirectory = path.dirname(fileURLToPath(import.meta.url));

export const defaultExampleCodeDirectory = path.resolve(
  pluginDirectory,
  '../../../tdesign-component/example/assets/code',
);

export function readFlutterExampleCode(assetKey, exampleCodeDirectory = defaultExampleCodeDirectory) {
  if (!assetKeyPattern.test(assetKey)) {
    throw new Error(`Invalid Flutter example asset key: ${assetKey}`);
  }

  const assetPath = path.join(exampleCodeDirectory, `${assetKey}.txt`);
  if (!fs.existsSync(assetPath)) {
    throw new Error(`Missing Flutter example code asset: ${assetPath}`);
  }
  return fs.readFileSync(assetPath, 'utf8');
}

export function listFlutterExampleKeys(group, exampleCodeDirectory = defaultExampleCodeDirectory) {
  if (!groupPattern.test(group)) {
    throw new Error(`Invalid Flutter example group: ${group}`);
  }

  const prefix = `${group}.`;
  const assetKeys = fs
    .readdirSync(exampleCodeDirectory)
    .filter((fileName) => fileName.startsWith(prefix) && fileName.endsWith('.txt'))
    .map((fileName) => fileName.slice(0, -'.txt'.length))
    .sort((left, right) => left.localeCompare(right));
  if (assetKeys.length === 0) {
    throw new Error(`Missing Flutter example code group: ${group}`);
  }
  return assetKeys;
}

function renderFlutterExample(assetKey, exampleCodeDirectory) {
  const code = readFlutterExampleCode(assetKey, exampleCodeDirectory);
  return `<td-code-block panel="Dart">
  <pre slot="Dart" lang="dart">${encodeURIComponent(code)}</pre>
</td-code-block>`;
}

export function replaceFlutterExampleDirectives(source, exampleCodeDirectory = defaultExampleCodeDirectory) {
  const groupsReplaced = source.replace(groupDirectivePattern, (_, group) => {
    const examples = listFlutterExampleKeys(group, exampleCodeDirectory)
      .map((assetKey) => {
        const exampleName = assetKey.slice(group.length + 1);
        return `#### \`${exampleName}\`\n\n${renderFlutterExample(assetKey, exampleCodeDirectory)}`;
      })
      .join('\n\n');
    return `\n${examples}`;
  });
  const replaced = groupsReplaced.replace(directivePattern, (_, assetKey) => {
    return `\n${renderFlutterExample(assetKey, exampleCodeDirectory)}`;
  });

  const malformedDirective = replaced.match(/\{\{\s*flutter-example(?:-group)?(?:\s[^}]*)?\}\}/);
  if (malformedDirective) {
    throw new Error(`Invalid Flutter example directive: ${malformedDirective[0]}`);
  }
  return replaced;
}

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const directivePattern = /\{\{\s*flutter-example\s+([^\s}]+)\s*\}\}/g;
const groupDirectivePattern = /\{\{\s*flutter-example-group\s+([^\s}]+)\s*\}\}/g;
const assetKeyPattern = /^[A-Za-z0-9_-]+\.[A-Za-z_][A-Za-z0-9_]*$/;
const groupPattern = /^[A-Za-z0-9_-]+$/;
const adapterDirectory = path.dirname(fileURLToPath(import.meta.url));

export const defaultExampleCodeDirectory = path.resolve(
  adapterDirectory,
  '../../../tdesign-component/example/assets/code',
);

export function readFlutterExampleManifest(exampleCodeDirectory = defaultExampleCodeDirectory) {
  const manifestPath = path.join(exampleCodeDirectory, 'manifest.json');
  if (!fs.existsSync(manifestPath)) {
    throw new Error(`Missing Flutter example manifest: ${manifestPath}`);
  }
  const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
  if (
    manifest?.version !== 1 ||
    typeof manifest.groups !== 'object' ||
    manifest.groups === null ||
    !Array.isArray(manifest.legacyGroups)
  ) {
    throw new Error(`Invalid Flutter example manifest: ${manifestPath}`);
  }
  return manifest;
}

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
  const configuredGroup = readFlutterExampleGroup(group, exampleCodeDirectory);
  return configuredGroup.flatMap((module) => module.items.map((item) => item.assetKey));
}

export function readFlutterExampleGroup(group, exampleCodeDirectory = defaultExampleCodeDirectory) {
  if (!groupPattern.test(group)) {
    throw new Error(`Invalid Flutter example group: ${group}`);
  }

  const manifest = readFlutterExampleManifest(exampleCodeDirectory);
  const configuredGroup = manifest.groups[group];
  if (configuredGroup) {
    if (!Array.isArray(configuredGroup)) {
      throw new Error(`Invalid Flutter example manifest group: ${group}`);
    }
    const assetKeys = configuredGroup.flatMap((module) => {
      if (
        typeof module?.title !== 'string' ||
        module.title.trim().length === 0 ||
        !Array.isArray(module.items)
      ) {
        throw new Error(`Invalid Flutter example manifest group: ${group}`);
      }
      return module.items.map((item) => {
        if (typeof item?.description !== 'string') {
          throw new Error(`Invalid Flutter example manifest group: ${group}`);
        }
        return item?.assetKey;
      });
    });
    const uniqueKeys = new Set(assetKeys);
    if (
      assetKeys.length === 0 ||
      uniqueKeys.size !== assetKeys.length ||
      assetKeys.some((assetKey) =>
        typeof assetKey !== 'string' ||
        !assetKeyPattern.test(assetKey) ||
        !assetKey.startsWith(`${group}.`)
      )
    ) {
      throw new Error(`Invalid Flutter example manifest group: ${group}`);
    }
    for (const assetKey of assetKeys) {
      readFlutterExampleCode(assetKey, exampleCodeDirectory);
    }
    return configuredGroup;
  }

  throw new Error(`Missing Flutter example code group: ${group}`);
}

function renderFlutterExample(assetKey, exampleCodeDirectory) {
  const code = readFlutterExampleCode(assetKey, exampleCodeDirectory);
  // @tdesign/site-components bundles its own Prism instance without the Dart
  // grammar. Use its built-in C-like grammar while keeping the public panel
  // label as Dart; requesting `dart` makes the custom element fail before it
  // can decode and render the generated source.
  return `<td-code-block panel="Dart">
  <pre slot="Dart" lang="clike">${encodeURIComponent(code)}</pre>
</td-code-block>`;
}

function headingText(value) {
  return value.replace(/\s+/g, ' ').trim();
}

function renderFlutterExampleGroup(group, exampleCodeDirectory) {
  const configuredGroup = readFlutterExampleGroup(group, exampleCodeDirectory);
  return configuredGroup
    .map((module) => {
      const examples = module.items
        .map((item) => {
          const exampleName = item.assetKey.slice(group.length + 1);
          const title = headingText(item.description) || `\`${exampleName}\``;
          return `#### ${title}\n\n${renderFlutterExample(item.assetKey, exampleCodeDirectory)}`;
        })
        .join('\n\n');
      return `### ${headingText(module.title)}\n\n${examples}`;
    })
    .join('\n\n');
}

export function replaceFlutterExampleDirectives(source, exampleCodeDirectory = defaultExampleCodeDirectory) {
  const groupsReplaced = source.replace(groupDirectivePattern, (_, group) => {
    return `\n${renderFlutterExampleGroup(group, exampleCodeDirectory)}`;
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

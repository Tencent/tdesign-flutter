import { existsSync, readFileSync } from 'node:fs';
import { dirname, resolve, sep } from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';

const toolDir = dirname(fileURLToPath(import.meta.url));
const componentRoot = resolve(toolDir, '..');
const manifestPath = resolve(toolDir, 'components.json');
const outputDir = `${resolve(componentRoot, 'example/assets/api')}${sep}`;
const cliArgs = process.argv.slice(2);
const dryRun = cliArgs.includes('--dry-run');
const unsupportedArgs = cliArgs.filter((arg) => arg !== '--dry-run');

if (unsupportedArgs.length > 0) {
  throw new Error(`Unsupported arguments: ${unsupportedArgs.join(', ')}`);
}

const manifest = JSON.parse(readFileSync(manifestPath, 'utf8'));
if (manifest.schemaVersion !== 1 || !Array.isArray(manifest.components)) {
  throw new Error('Invalid component API manifest.');
}

for (const component of manifest.components) {
  const sourcePath = resolve(componentRoot, component.source.path);
  if (!existsSync(sourcePath)) {
    throw new Error(`${component.slug}: missing ${component.source.type} ${sourcePath}`);
  }

  const args = [
    'run',
    'tdesign_flutter_tools:main',
    'generate',
    `--${component.source.type}`,
    sourcePath,
    '--name',
    component.api.names.join(','),
    '--folder-name',
    component.slug,
    '--output',
    outputDir,
    '--only-api',
  ];
  if (component.api.getComments) {
    args.push('--get-comments');
  }

  if (dryRun) {
    console.log(`dart ${args.map((arg) => JSON.stringify(arg)).join(' ')}`);
    continue;
  }

  const result = spawnSync('dart', args, {
    cwd: componentRoot,
    stdio: 'inherit',
  });
  if (result.status !== 0) {
    process.exit(result.status ?? 1);
  }
}

console.log(`[generate-api] generated ${manifest.components.length} API documents`);

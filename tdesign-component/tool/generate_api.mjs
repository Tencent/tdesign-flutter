import { existsSync, mkdtempSync, readFileSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { dirname, resolve, sep } from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';

const toolDir = dirname(fileURLToPath(import.meta.url));
const componentRoot = resolve(toolDir, '..');
const manifestPath = resolve(toolDir, 'components.json');
const outputDir = `${resolve(componentRoot, 'example/assets/api')}${sep}`;
const cliArgs = process.argv.slice(2);
const dryRun = cliArgs.includes('--dry-run');
const check = cliArgs.includes('--check');
const unsupportedArgs = cliArgs.filter((arg) => !['--dry-run', '--check'].includes(arg));

if (unsupportedArgs.length > 0) {
  throw new Error(`Unsupported arguments: ${unsupportedArgs.join(', ')}`);
}

const manifest = JSON.parse(readFileSync(manifestPath, 'utf8'));
if (manifest.schemaVersion !== 1 || !Array.isArray(manifest.components)) {
  throw new Error('Invalid component API manifest.');
}

const checkDir = check && !dryRun ? mkdtempSync(resolve(tmpdir(), 'tdesign-api-check-')) : null;
const generationDir = checkDir ? `${checkDir}${sep}` : outputDir;
const stale = [];
const tasks = [];
try {
  for (const component of manifest.components) {
    if (!['file', 'folder'].includes(component.source.type)) {
      throw new Error(`${component.slug}: source.type must be file or folder`);
    }
    const sourcePath = resolve(componentRoot, component.source.path);
    if (!existsSync(sourcePath)) {
      throw new Error(`${component.slug}: missing ${component.source.type} ${sourcePath}`);
    }

    const typeNames = component.api.names;
    const functionNames = component.api.functions ?? [];
    if (!Array.isArray(typeNames) || !Array.isArray(functionNames)) {
      throw new Error(`${component.slug}: api.names and api.functions must be arrays`);
    }
    const declarationNames = [...typeNames, ...functionNames];
    if (declarationNames.length === 0 || declarationNames.some((name) => typeof name !== 'string' || name.length === 0)) {
      throw new Error(`${component.slug}: API declaration names must be non-empty strings`);
    }
    if (new Set(declarationNames).size !== declarationNames.length) {
      throw new Error(`${component.slug}: duplicate API declaration name`);
    }

    const args = [
      'run',
      'tdesign_flutter_tools:main',
      'generate',
      `--${component.source.type}`,
      sourcePath,
      '--name',
      declarationNames.join(','),
      '--folder-name',
      component.slug,
      '--output',
      generationDir,
      '--only-api',
      '--strict-names',
    ];
    if (component.api.getComments) {
      args.push('--get-comments');
    }

    if (dryRun) {
      console.log(`dart ${args.map((arg) => JSON.stringify(arg)).join(' ')}`);
      continue;
    }

    tasks.push({
      slug: component.slug,
      sourcePath,
      sourceType: component.source.type,
      names: declarationNames,
      getComments: component.api.getComments === true,
      output: generationDir,
    });
  }
  // 同一进程顺序复用原生成器，避免为每个组件重复启动 Dart / 加载分析器。
  if (!dryRun) {
    const result = spawnSync('dart', ['run', resolve(toolDir, 'generate_api_batch.dart')], {
      cwd: componentRoot,
      input: JSON.stringify(tasks),
      stdio: ['pipe', 'inherit', 'inherit'],
    });
    if (result.status !== 0) {
      throw new Error(`API generation failed (${result.status ?? 'spawn error'})`);
    }
  }
  if (checkDir) {
    for (const component of manifest.components) {
      const name = `${component.slug}_api.md`;
      const committed = resolve(outputDir, name);
      const generated = resolve(checkDir, name);
      if (!existsSync(generated) || !existsSync(committed) || readFileSync(generated, 'utf8') !== readFileSync(committed, 'utf8')) {
        stale.push(name);
      }
    }
  }
} finally {
  if (checkDir) rmSync(checkDir, { recursive: true, force: true });
}

if (stale.length) throw new Error(`Stale API documents: ${stale.join(', ')}`);
console.log(`[generate-api] ${dryRun ? 'planned' : check ? 'checked' : 'generated'} ${manifest.components.length} API documents`);

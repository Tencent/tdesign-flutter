import { access, mkdir, readFile, readdir, rm, writeFile } from 'fs/promises';
import { dirname, join, relative, resolve, sep } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const rootDir = resolve(__dirname, '..');
const sourceRoot = join(rootDir, '.harness', 'cursor');
const cursorRoot = join(rootDir, '.cursor');
const manifestPath = join(cursorRoot, '.harness-manifest.json');

const args = new Set(process.argv.slice(2));
const options = {
  check: args.has('--check'),
  clean: args.has('--clean'),
  force: args.has('--force'),
  help: args.has('--help'),
};

const targetSpecs = [
  {
    kind: 'dir',
    source: join(sourceRoot, 'rules'),
    target: join(cursorRoot, 'rules'),
  },
  {
    kind: 'dir',
    source: join(sourceRoot, 'skills'),
    target: join(cursorRoot, 'skills'),
  },
  {
    kind: 'dir',
    source: join(sourceRoot, 'agents'),
    target: join(cursorRoot, 'agents'),
  },
  {
    kind: 'file',
    source: join(sourceRoot, 'AGENTS.md'),
    target: join(rootDir, 'AGENTS.md'),
  },
];

function printUsage() {
  console.log(`Usage: node scripts/init-cursor-harness.mjs [--check] [--clean] [--force]

Options:
  --check  Validate generated files without writing changes
  --clean  Remove files tracked by the harness manifest
  --force  Overwrite unmanaged target files during sync
  --help   Show this help message`);
}

function toPortablePath(filePath) {
  return filePath.split(sep).join('/');
}

function fromPortablePath(filePath) {
  return filePath.split('/').join(sep);
}

async function pathExists(filePath) {
  try {
    await access(filePath);
    return true;
  } catch {
    return false;
  }
}

function isWithin(baseDir, targetDir) {
  const rel = relative(baseDir, targetDir);
  return rel === '' || (!rel.startsWith('..') && rel !== '');
}

async function collectFiles(dirPath) {
  if (!(await pathExists(dirPath))) {
    return [];
  }

  const entries = await readdir(dirPath, { withFileTypes: true });
  entries.sort((left, right) => left.name.localeCompare(right.name));

  const files = [];
  for (const entry of entries) {
    const fullPath = join(dirPath, entry.name);
    if (entry.isDirectory()) {
      files.push(...(await collectFiles(fullPath)));
      continue;
    }

    if (entry.isFile()) {
      files.push(fullPath);
    }
  }

  return files;
}

async function loadManifest() {
  if (!(await pathExists(manifestPath))) {
    return { files: new Set() };
  }

  const raw = await readFile(manifestPath, 'utf8');
  const parsed = JSON.parse(raw);
  const files = Array.isArray(parsed.files) ? parsed.files : [];
  return { files: new Set(files) };
}

async function buildDesiredFiles() {
  if (!(await pathExists(sourceRoot))) {
    throw new Error(`Harness source directory not found: ${toPortablePath(relative(rootDir, sourceRoot))}`);
  }

  const desiredFiles = [];
  for (const spec of targetSpecs) {
    if (spec.kind === 'dir') {
      const sourceFiles = await collectFiles(spec.source);
      for (const sourceFile of sourceFiles) {
        const rel = relative(spec.source, sourceFile);
        const targetPath = join(spec.target, rel);
        desiredFiles.push({
          sourcePath: sourceFile,
          targetPath,
          relativeTarget: toPortablePath(relative(rootDir, targetPath)),
        });
      }
      continue;
    }

    if (await pathExists(spec.source)) {
      desiredFiles.push({
        sourcePath: spec.source,
        targetPath: spec.target,
        relativeTarget: toPortablePath(relative(rootDir, spec.target)),
      });
    }
  }

  desiredFiles.sort((left, right) => left.relativeTarget.localeCompare(right.relativeTarget));
  return desiredFiles;
}

async function inspectFile(record, previousFiles) {
  const sourceContent = await readFile(record.sourcePath, 'utf8');
  const targetExists = await pathExists(record.targetPath);

  if (!targetExists) {
    return { status: 'missing', sourceContent };
  }

  const targetContent = await readFile(record.targetPath, 'utf8');
  if (targetContent === sourceContent) {
    return { status: 'in-sync', sourceContent };
  }

  if (previousFiles.has(record.relativeTarget)) {
    return { status: 'managed-drift', sourceContent };
  }

  return { status: 'unmanaged-conflict', sourceContent };
}

async function writeManagedFile(record, content) {
  await mkdir(dirname(record.targetPath), { recursive: true });
  await writeFile(record.targetPath, content, 'utf8');
}

async function pruneEmptyDirsUpwards(startDir, stopDir) {
  let currentDir = startDir;

  while (isWithin(stopDir, currentDir)) {
    if (!(await pathExists(currentDir))) {
      break;
    }

    const entries = await readdir(currentDir);
    if (entries.length > 0) {
      break;
    }

    await rm(currentDir, { recursive: false, force: true });
    if (currentDir === stopDir) {
      break;
    }

    currentDir = dirname(currentDir);
  }
}

async function removeManagedTargets(relativeTargets) {
  let removed = 0;

  for (const relativeTarget of relativeTargets) {
    const targetPath = join(rootDir, fromPortablePath(relativeTarget));
    if (!(await pathExists(targetPath))) {
      continue;
    }

    await rm(targetPath, { force: true });
    removed += 1;

    if (isWithin(cursorRoot, dirname(targetPath))) {
      await pruneEmptyDirsUpwards(dirname(targetPath), cursorRoot);
    }
  }

  return removed;
}

async function writeManifest(relativeTargets) {
  await mkdir(cursorRoot, { recursive: true });

  const manifest = {
    version: 1,
    sourceRoot: '.harness/cursor',
    generatedAt: new Date().toISOString(),
    files: [...relativeTargets].sort(),
  };

  await writeFile(manifestPath, `${JSON.stringify(manifest, null, 2)}\n`, 'utf8');
}

async function cleanManifestFiles() {
  const manifest = await loadManifest();

  if (manifest.files.size === 0) {
    console.log('No manifest-managed Cursor harness files to clean.');
    return;
  }

  const removed = await removeManagedTargets(manifest.files);

  if (await pathExists(manifestPath)) {
    await rm(manifestPath, { force: true });
  }

  await pruneEmptyDirsUpwards(cursorRoot, cursorRoot);
  console.log(`Removed ${removed} managed file(s).`);
}

async function checkHarness() {
  const desiredFiles = await buildDesiredFiles();
  const previousManifest = await loadManifest();
  const desiredTargets = new Set(desiredFiles.map((file) => file.relativeTarget));
  const issues = [];

  for (const record of desiredFiles) {
    const inspection = await inspectFile(record, previousManifest.files);
    if (inspection.status === 'missing') {
      issues.push(`Missing generated file: ${record.relativeTarget}`);
    } else if (inspection.status === 'managed-drift') {
      issues.push(`Managed file is out of sync: ${record.relativeTarget}`);
    } else if (inspection.status === 'unmanaged-conflict') {
      issues.push(`Unmanaged file conflicts with harness output: ${record.relativeTarget}`);
    }
  }

  for (const previousTarget of previousManifest.files) {
    if (!desiredTargets.has(previousTarget) && (await pathExists(join(rootDir, fromPortablePath(previousTarget))))) {
      issues.push(`Stale managed file still exists: ${previousTarget}`);
    }
  }

  if (issues.length > 0) {
    console.error('Cursor harness check failed:');
    for (const issue of issues) {
      console.error(`- ${issue}`);
    }
    process.exitCode = 1;
    return;
  }

  console.log('Cursor harness is in sync.');
}

async function syncHarness() {
  const desiredFiles = await buildDesiredFiles();
  const previousManifest = await loadManifest();
  const desiredTargets = new Set(desiredFiles.map((file) => file.relativeTarget));
  const conflicts = [];

  const inspections = new Map();
  for (const record of desiredFiles) {
    const inspection = await inspectFile(record, previousManifest.files);
    inspections.set(record.relativeTarget, inspection);
    if (inspection.status === 'unmanaged-conflict' && !options.force) {
      conflicts.push(record.relativeTarget);
    }
  }

  if (conflicts.length > 0) {
    throw new Error(
      `Refusing to overwrite unmanaged file(s):\n- ${conflicts.join('\n- ')}\nRe-run with --force to overwrite them.`
    );
  }

  let created = 0;
  let updated = 0;
  let unchanged = 0;

  for (const record of desiredFiles) {
    const inspection = inspections.get(record.relativeTarget);
    if (inspection.status === 'in-sync') {
      unchanged += 1;
      continue;
    }

    await writeManagedFile(record, inspection.sourceContent);
    if (inspection.status === 'missing') {
      created += 1;
    } else {
      updated += 1;
    }
  }

  const staleTargets = [...previousManifest.files].filter((file) => !desiredTargets.has(file));
  const removed = await removeManagedTargets(staleTargets);

  await writeManifest(desiredTargets);

  console.log('Cursor harness synced successfully.');
  console.log(`Created: ${created}`);
  console.log(`Updated: ${updated}`);
  console.log(`Unchanged: ${unchanged}`);
  console.log(`Removed stale: ${removed}`);
}

async function main() {
  if (options.help) {
    printUsage();
    return;
  }

  if (options.check && options.clean) {
    throw new Error('Choose either --check or --clean, not both.');
  }

  if (options.clean) {
    await cleanManifestFiles();
    return;
  }

  if (options.check) {
    await checkHarness();
    return;
  }

  await syncHarness();
}

main().catch((error) => {
  console.error(error.message);
  process.exitCode = 1;
});

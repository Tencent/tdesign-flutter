import { mkdir, readdir, readFile, writeFile } from 'fs/promises';
import { dirname, join, relative, resolve } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const rootDir = resolve(__dirname, '../..');
const templateDir = join(rootDir, '.harness', 'templates', 'issue-fix');

function parseArgs(argv) {
  const args = {};
  for (let index = 0; index < argv.length; index += 1) {
    const token = argv[index];
    if (!token.startsWith('--')) {
      continue;
    }
    const key = token.slice(2);
    const next = argv[index + 1];
    if (!next || next.startsWith('--')) {
      args[key] = true;
      continue;
    }
    args[key] = next;
    index += 1;
  }
  return args;
}

function printUsage() {
  console.log(`Usage:
  node scripts/issue-workflow/init-issue-fix.mjs \\
    --issue-number 924 \\
    --issue-url https://github.com/Tencent/tdesign-flutter/issues/924 \\
    --issue-title "TDFab 暴露 onLongPress 方法" \\
    --slug fab-on-long-press \\
    --component TFab \\
    --branch fix/issue-924-fab-on-long-press

Options:
  --issue-number     必填，issue 编号
  --issue-url        issue 链接，未提供时会按 GitHub 默认格式生成
  --issue-title      issue 标题，未提供时默认"待补充标题"
  --slug             必填，requirements 目录 slug
  --component        必填，组件名或问题主体
  --branch           选填，默认 fix/issue-<number>-<slug>
  --requirements-dir 选填，默认 requirements/issue-<number>-<slug>
  --force            覆盖已存在文件
  --dry-run          只输出将要生成的文件，不落盘
  --help             显示帮助`);
}

function sanitizeSlug(input) {
  return input
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9-]+/g, '-')
    .replace(/-{2,}/g, '-')
    .replace(/^-|-$/g, '');
}

async function loadTemplates() {
  const entries = await readdir(templateDir, { withFileTypes: true });
  const templates = [];

  for (const entry of entries) {
    if (!entry.isFile() || !entry.name.endsWith('.tpl')) {
      continue;
    }

    const fullPath = join(templateDir, entry.name);
    const content = await readFile(fullPath, 'utf8');
    templates.push({
      sourcePath: fullPath,
      fileName: entry.name.replace(/\.tpl$/, ''),
      content,
    });
  }

  return templates.sort((left, right) => left.fileName.localeCompare(right.fileName));
}

async function fileExists(targetPath) {
  try {
    await readFile(targetPath, 'utf8');
    return true;
  } catch {
    return false;
  }
}

async function main() {
  const args = parseArgs(process.argv.slice(2));

  if (args.help) {
    printUsage();
    return;
  }

  if (!args['issue-number'] || !args.slug || !args.component) {
    printUsage();
    process.exitCode = 1;
    return;
  }

  const issueNumber = String(args['issue-number']).trim();
  const slug = sanitizeSlug(String(args.slug));
  const branchName = args.branch || `fix/issue-${issueNumber}-${slug}`;
  const issueUrl =
    args['issue-url'] ||
    `https://github.com/Tencent/tdesign-flutter/issues/${issueNumber}`;
  const issueTitle = args['issue-title'] || '待补充标题';
  const requirementsDir =
    args['requirements-dir'] || `requirements/issue-${issueNumber}-${slug}`;
  const requirementsAbsDir = join(rootDir, requirementsDir);

  const replacements = {
    '{{ISSUE_NUMBER}}': issueNumber,
    '{{ISSUE_URL}}': issueUrl,
    '{{ISSUE_TITLE}}': issueTitle,
    '{{COMPONENT_NAME}}': args.component,
    '{{BRANCH_NAME}}': branchName,
    '{{REQUIREMENTS_DIR}}': requirementsDir,
  };

  const templates = await loadTemplates();
  if (templates.length === 0) {
    throw new Error(`No issue-fix templates found in ${templateDir}`);
  }

  if (args['dry-run']) {
    console.log(`Requirements 目录：${requirementsDir}`);
    console.log(`建议分支：${branchName}`);
    console.log('将生成以下文件：');
    for (const template of templates) {
      console.log(`- ${join(requirementsDir, template.fileName)}`);
    }
    return;
  }

  await mkdir(requirementsAbsDir, { recursive: true });

  for (const template of templates) {
    const targetPath = join(requirementsAbsDir, template.fileName);
    if (!args.force && (await fileExists(targetPath))) {
      throw new Error(
        `Target already exists: ${relative(rootDir, targetPath)}. Re-run with --force to overwrite.`
      );
    }

    let rendered = template.content;
    for (const [placeholder, value] of Object.entries(replacements)) {
      rendered = rendered.replaceAll(placeholder, value);
    }

    await writeFile(targetPath, rendered, 'utf8');
    console.log(`Created ${relative(rootDir, targetPath)}`);
  }

  console.log(`Done. Requirements 目录：${requirementsDir}`);
  console.log(`建议分支：${branchName}`);
}

main().catch((error) => {
  console.error(error.message);
  process.exitCode = 1;
});

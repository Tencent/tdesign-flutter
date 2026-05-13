import { readFile } from 'fs/promises';
import { dirname, join, relative, resolve } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const rootDir = resolve(__dirname, '../..');

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
  node scripts/issue-workflow/check-issue-fix.mjs \\
    --requirements-dir requirements/issue-924-fab-on-long-press \\
    --component-file tdesign-component/lib/src/components/fab/t_fab.dart \\
    --class-name TFab \\
    --all-build tdesign-component/demo_tool/all_build.sh \\
    --require-all-build-class

Options:
  --requirements-dir        必填，requirements 目录
  --component-file          选填，待检查的组件文件
  --class-name              选填，组件类名
  --all-build               选填，all_build.sh 路径
  --require-all-build-class 选填，强制检查类名是否出现在 all_build.sh 中
  --help                    显示帮助`);
}

async function readText(relativePath) {
  return readFile(join(rootDir, relativePath), 'utf8');
}

function extractHeadings(markdown) {
  return markdown
    .split('\n')
    .map((line) => line.trimEnd())
    .filter((line) => /^#{2,6}\s+/.test(line));
}

function validatePrBodyTemplate({ prBodyContent, templateContent, failures, relativePath }) {
  const allowedHeadings = new Set(extractHeadings(templateContent));
  const prHeadings = extractHeadings(prBodyContent);

  // 1) 必须包含模板里的全部标题（且标题文本需一致）
  for (const requiredHeading of allowedHeadings) {
    if (!prBodyContent.includes(requiredHeading)) {
      failures.push(`${relativePath} 缺少模板标题：${requiredHeading}`);
    }
  }

  // 2) 禁止出现模板之外的自定义标题（如 ## Summary / ## Root Cause 等）
  const extraHeadings = prHeadings.filter((heading) => !allowedHeadings.has(heading));
  if (extraHeadings.length > 0) {
    failures.push(
      `${relativePath} 出现模板之外的标题，请严格按 pr-body.md.tpl 结构填写：${extraHeadings.join(
        ', '
      )}`
    );
  }

  // 3) 标题顺序必须与模板一致（允许在栏目内补充内容，但不允许打乱栏目顺序）
  const orderedTemplateHeadings = extractHeadings(templateContent);
  let lastIndex = -1;
  for (const heading of orderedTemplateHeadings) {
    const index = prBodyContent.indexOf(heading);
    if (index === -1) {
      continue;
    }
    if (index < lastIndex) {
      failures.push(`${relativePath} 标题顺序与模板不一致，请不要调整栏目顺序`);
      break;
    }
    lastIndex = index;
  }
}

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

function collectLineMatches(content, pattern) {
  return content
    .split('\n')
    .map((line, index) => ({ line, lineNumber: index + 1 }))
    .filter(({ line }) => pattern.test(line))
    .map(({ lineNumber }) => lineNumber);
}

async function main() {
  const args = parseArgs(process.argv.slice(2));

  if (args.help) {
    printUsage();
    return;
  }

  if (!args['requirements-dir']) {
    printUsage();
    process.exitCode = 1;
    return;
  }

  const failures = [];
  const warnings = [];
  const requirementsDir = String(args['requirements-dir']);
  const prBodyTemplate = await readText('.harness/templates/issue-fix/pr-body.md.tpl');
  const requiredDocs = {
    'TaskContract.md': [
      '## 基本信息',
      '## 问题描述',
      '## 根因分析',
      '## 修复方案',
      '## 贡献指南对照',
      '## 交付物清单',
    ],
    'test-cases.md': ['# 测试用例', '## TC-01'],
    'code-review-report.md': ['## 审查结论', '## 修改范围', '## 规范检查'],
    'acceptance-report.md': ['## 验收结论', '## 需求对照', '## 执行检查', '## 人工验收指引'],
    // PR body 必须严格遵循模板结构（见 .harness/templates/issue-fix/pr-body.md.tpl）
    'pr-body.md': [
      '### 🤔 这个 PR 的性质是？',
      '### 🔗 相关 Issue',
      '### 💡 需求背景和解决方案',
      '### 📝 更新日志',
      '### ☑️ 请求合并前的自查清单',
    ],
  };

  for (const [fileName, headings] of Object.entries(requiredDocs)) {
    const relativePath = join(requirementsDir, fileName);
    let content = '';
    try {
      content = await readText(relativePath);
    } catch {
      failures.push(`缺少必需文档：${relativePath}`);
      continue;
    }

    for (const heading of headings) {
      if (!content.includes(heading)) {
        failures.push(`${relativePath} 缺少章节：${heading}`);
      }
    }

    if (fileName === 'pr-body.md') {
      validatePrBodyTemplate({
        prBodyContent: content,
        templateContent: prBodyTemplate,
        failures,
        relativePath,
      });
    }

    if (content.includes('待补充')) {
      failures.push(`${relativePath} 仍包含“待补充”占位内容`);
    }
  }

  if (args['component-file']) {
    const componentPath = String(args['component-file']);
    let componentContent = '';
    try {
      componentContent = await readText(componentPath);
    } catch {
      failures.push(`无法读取组件文件：${componentPath}`);
      componentContent = '';
    }

    if (componentContent) {
      const lineCommentLines = collectLineMatches(componentContent, /^\s*\/\/(?!\/)/);
      if (lineCommentLines.length > 0) {
        failures.push(
          `${componentPath} 存在 \`//\` 注释，请改用 \`///\`。行号：${lineCommentLines.join(', ')}`
        );
      }

      const hardcodedColorLines = collectLineMatches(
        componentContent,
        /\bColors\.[A-Za-z_]+|(?<![A-Za-z])Color\s*\(/
      );
      if (hardcodedColorLines.length > 0) {
        failures.push(
          `${componentPath} 存在疑似硬编码颜色，请改用 TTheme 字段。行号：${hardcodedColorLines.join(', ')}`
        );
      }

      const hardcodedChineseCopyLines = collectLineMatches(
        componentContent,
        /['"`][^'"`]*[\u4e00-\u9fa5]+[^'"`]*['"`]/
      );
      if (hardcodedChineseCopyLines.length > 0) {
        failures.push(
          `${componentPath} 存在疑似硬编码中文文案，请评估是否应抽离到 TResourceDelegate。行号：${hardcodedChineseCopyLines.join(', ')}`
        );
      }

      if (args['class-name']) {
        const className = String(args['class-name']);
        const lines = componentContent.split('\n');
        const classPattern = new RegExp(`^\\s*class\\s+${escapeRegExp(className)}(?:\\s|<|\\{)`);
        const constructorPattern = new RegExp(`^\\s*(const\\s+)?${escapeRegExp(className)}\\(`);
        const fieldPattern = /^\s*(final|late|var|static)\b/;

        const classIndex = lines.findIndex((line) => classPattern.test(line));
        if (classIndex === -1) {
          failures.push(`${componentPath} 中未找到类 ${className}`);
        } else {
          let constructorIndex = -1;
          let firstFieldIndex = -1;
          for (let index = classIndex + 1; index < lines.length; index += 1) {
            const line = lines[index];
            if (constructorIndex === -1 && constructorPattern.test(line)) {
              constructorIndex = index;
            }
            if (firstFieldIndex === -1 && fieldPattern.test(line)) {
              firstFieldIndex = index;
            }
            if (constructorIndex !== -1 && firstFieldIndex !== -1) {
              break;
            }
          }

          if (constructorIndex === -1) {
            failures.push(`${componentPath} 中未找到 ${className} 构造方法`);
          }
          if (
            constructorIndex !== -1 &&
            firstFieldIndex !== -1 &&
            firstFieldIndex < constructorIndex
          ) {
            failures.push(
              `${componentPath} 中字段出现在构造方法之前，请先写构造方法再声明字段`
            );
          }
        }
      }
    }
  }

  if (args['require-all-build-class']) {
    if (!args['all-build'] || !args['class-name']) {
      failures.push('启用 --require-all-build-class 时，必须同时提供 --all-build 和 --class-name');
    } else {
      const allBuildPath = String(args['all-build']);
      const className = String(args['class-name']);
      try {
        const content = await readText(allBuildPath);
        if (!content.includes(className)) {
          failures.push(`${allBuildPath} 中未找到类名 ${className} 的配置`);
        }
      } catch {
        failures.push(`无法读取 all_build 配置文件：${allBuildPath}`);
      }
    }
  }

  if (warnings.length > 0) {
    console.log('Warnings:');
    for (const warning of warnings) {
      console.log(`- ${warning}`);
    }
  }

  if (failures.length > 0) {
    console.error('Issue workflow check failed:');
    for (const failure of failures) {
      console.error(`- ${failure}`);
    }
    process.exitCode = 1;
    return;
  }

  console.log(`Issue workflow check passed for ${relative(rootDir, join(rootDir, requirementsDir))}`);
}

main().catch((error) => {
  console.error(error.message);
  process.exitCode = 1;
});

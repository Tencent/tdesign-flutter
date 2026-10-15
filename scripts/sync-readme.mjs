import { readFileSync, writeFileSync, existsSync } from 'fs';
import { dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const rootDir = `${__dirname}/..`;

// ============================================================
// 同步配置
// ============================================================
// source: 被监听的源文件
// targets: 同步目标列表
//   - path: 目标文件路径
//   - transform: 可选，内容转换函数名
// ============================================================

const transforms = {
  // 移除语言切换链接: [English](./README.md) | 简体中文
  removeLangLink: (content) => {
    return content.replaceAll('./MIGRATION_1_0.md', '/flutter/migration-1-0').replace(/\[English\]\(\.\/README\.md\) \| 简体中文\n?/g, '')
      .replace('https://raw.githubusercontent.com/Tencent/tdesign-flutter/develop/tdesign-site/site/public/assets/qrcode/t_apk_qrcode.png', `data:image/png;base64,${readFileSync(`${rootDir}/tdesign-site/site/public/assets/qrcode/t_apk_qrcode.png`).toString('base64')}`);
  },
};

const syncConfig = [
  {
    source: 'MIGRATION_1_0.md',
    targets: [
      { path: 'tdesign-component/MIGRATION_1_0.md' },
      { path: 'tdesign-site/site/docs/migration-1-0.md' },
    ],
  },
  {
    source: 'README.md',
    targets: [
      { path: 'tdesign-component/README.md' },
    ],
  },
  {
    source: 'README_zh_CN.md',
    targets: [
      { path: 'tdesign-component/README_zh_CN.md' },
      { path: 'tdesign-site/site/docs/getting-started.md', transform: 'removeLangLink' },
    ],
  },
];

// ============================================================
// 同步逻辑
// ============================================================

function sync() {
  const guidePath = `${rootDir}/MIGRATION_1_0.md`;
  if (existsSync(guidePath)) {
    const examples = readFileSync(`${rootDir}/tdesign-component/tool/fixtures/token_migration/test/support/migration_027_examples.dart`, 'utf-8');
    const guide = readFileSync(guidePath, 'utf-8').replace(
      /<!-- migration-example:([a-z]+):start -->[\s\S]*?<!-- migration-example:\1:end -->/g,
      (_, name) => {
        const start = `// migration:${name}:start`;
        const end = `// migration:${name}:end`;
        const offset = examples.indexOf(start);
        const endOffset = examples.indexOf(end, offset + start.length);
        if (offset < 0 || endOffset < 0) {
          throw new Error(`Missing migration example: ${name}`);
        }
        const source = examples.slice(offset + start.length, endOffset).trim();
        return `<!-- migration-example:${name}:start -->\n\`\`\`dart\n${source}\n\`\`\`\n<!-- migration-example:${name}:end -->`;
      },
    );
    writeFileSync(guidePath, guide, 'utf-8');
  }
  for (const { source, targets } of syncConfig) {
    const sourcePath = `${rootDir}/${source}`;

    if (!existsSync(sourcePath)) {
      console.log(`[Skip] Source not found: ${source}`);
      continue;
    }

    const sourceContent = readFileSync(sourcePath, 'utf-8');
    console.log(`[Read] ${source}`);

    for (const { path, transform } of targets) {
      let content = sourceContent;

      if (transform) {
        const transformFn = transforms[transform];
        if (transformFn) {
          content = transformFn(content);
          console.log(`  [Transform: ${transform}]`);
        } else {
          console.log(`  [Warn] Unknown transform: ${transform}`);
        }
      }

      writeFileSync(`${rootDir}/${path}`, content, 'utf-8');
      console.log(`  [Sync] -> ${path}`);
    }
  }

  console.log('\nDone!');
}

sync();

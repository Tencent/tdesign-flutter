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
    return content.replace(/\[English\]\(\.\/README\.md\) \| 简体中文\n?/g, '');
  },
};

const syncConfig = [
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

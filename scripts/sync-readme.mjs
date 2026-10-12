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
  gettingStarted: (content) => {
    const start = '<!-- getting-started:start -->';
    const end = '<!-- getting-started:end -->';
    if (content.split(start).length !== 2 || content.split(end).length !== 2) {
      throw new Error('README_zh_CN.md must contain one getting-started start and end marker.');
    }
    const startIndex = content.indexOf(start) + start.length;
    const endIndex = content.indexOf(end);
    const body = content.slice(startIndex, endIndex).trim()
      .replaceAll('https://tdesign.tencent.com/flutter/', '/flutter/');
    if (endIndex < startIndex || !body) {
      throw new Error('README_zh_CN.md getting-started markers must enclose non-empty content in order.');
    }
    return `---
title: 快速开始
description: 安装并运行第一个 TDesign Flutter 应用，再按需求继续配置。
spline: explain
---

${body}
`;
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
      { path: 'tdesign-site/site/docs/getting-started.md', transform: 'gettingStarted' },
    ],
  },
];

// ============================================================
// 同步逻辑
// ============================================================

function sync() {
  const outputs = [];
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
          throw new Error(`Unknown transform: ${transform}`);
        }
      }

      outputs.push({ path, content });
    }
  }

  for (const { path, content } of outputs) {
    writeFileSync(`${rootDir}/${path}`, content, 'utf-8');
    console.log(`  [Sync] -> ${path}`);
  }

  console.log('\nDone!');
}

sync();

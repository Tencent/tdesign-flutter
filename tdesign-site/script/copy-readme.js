const fs = require('fs');
const path = require('path');

const sourcePath = path.resolve(__dirname, '../../README_zh_CN.md');
const targetPath = path.resolve(__dirname, '../site/docs/getting-started.md');

fs.copyFileSync(sourcePath, targetPath);

console.log('✅ README_zh_CN.md 已复制到 site/docs/getting-started.md');

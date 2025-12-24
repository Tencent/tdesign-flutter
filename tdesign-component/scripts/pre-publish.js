const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const sourcePath = path.resolve(__dirname, '../../README.md');
const targetPath = path.resolve(__dirname, '../README.md');

// 复制 README
fs.copyFileSync(sourcePath, targetPath);
console.log('✅ README.md 已复制');

// 执行 flutter 命令（传递所有参数）
const args = process.argv.slice(2).join(' ');
const command = args || 'pub publish --dry-run';

console.log(`🚀 执行: flutter ${command}`);
execSync(`flutter ${command}`, { stdio: 'inherit', cwd: path.resolve(__dirname, '..') });

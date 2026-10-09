// Keep site and package README copies consistent with the repository generator.
const { execFileSync } = require('node:child_process');
const path = require('node:path');

execFileSync(process.execPath, [path.resolve(__dirname, '../../scripts/sync-readme.mjs')], { stdio: 'inherit' });

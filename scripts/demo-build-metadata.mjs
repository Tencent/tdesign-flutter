import { appendFileSync, readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { resolve } from 'node:path';

export function demoBuildMetadata(version, runNumber, prNumber = '0') {
  if (!/^\d+\.\d+\.\d+(-[0-9A-Za-z.-]+)?(\+[0-9A-Za-z.-]+)?$/.test(version)) {
    throw new Error('Invalid Demo version');
  }
  if (!/^[1-9]\d*$/.test(runNumber) || !/^(0|[1-9]\d*)$/.test(prNumber)) {
    throw new Error('Invalid workflow run or PR number');
  }
  // Preserve upgrades from the former yyyyMMdd * 100 + 1 versionCode.
  // Only PREVIEW_BUILD APKs are distributed as one ordered release sequence.
  const buildNumber = 2030000000 + Number(runNumber);
  if (!Number.isSafeInteger(buildNumber) || buildNumber > 2100000000) {
    throw new Error('Android versionCode is exhausted');
  }
  return { version, buildNumber: String(buildNumber), prNumber };
}

if (process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  const version = readFileSync('tdesign-component/example/assets/version', 'utf8').trim();
  const metadata = demoBuildMetadata(version, process.env.GITHUB_RUN_NUMBER, process.env.PR_NUMBER);
  writeFileSync('build-env.txt', `PR_NUMBER=${metadata.prNumber}\nVERSION=${metadata.version}\nBUILD_NUMBER=${metadata.buildNumber}\n`);
  appendFileSync(process.env.GITHUB_OUTPUT, `version=${metadata.version}\nbuild-number=${metadata.buildNumber}\n`);
}

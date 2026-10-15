import { createHash } from 'node:crypto';
import { existsSync, readFileSync, writeFileSync } from 'node:fs';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { execFileSync } from 'node:child_process';

// Verifies this resolution batch while preserving the original Spec059 target.
const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const logs = process.argv[2];
if (!logs) throw new Error('Usage: node tool/verify_token_difference_resolutions.mjs <log-directory>');
const output = join(root, 'specs/060-token-difference-resolution');
const read = path => JSON.parse(readFileSync(path, 'utf8'));
const sha = bytes => createHash('sha256').update(bytes).digest('hex');
const baselinePath = join(root, 'specs/059-component-token-runtime-evidence/runtime-review.json');
const baseline = read(baselinePath);
const rules = read(join(output, 'resolution-rules.json'));
const expectedNames = baseline.rows.filter(row => ['runtime-difference-needs-resolution', 'platform-geometry-review-pending'].includes(row.stage)).map(row => row.name).sort();
if (JSON.stringify(rules.rows.map(row => row.name).sort()) !== JSON.stringify(expectedNames)) throw new Error('Every one of the 32 original items must have exactly one disposition');
function observations(text) {
  return text.split('\n').flatMap(line => {
    const offset = line.indexOf('TOKEN_EVIDENCE ');
    return offset < 0 ? [] : [JSON.parse(line.slice(offset + 15))];
  }).sort((a, b) => JSON.stringify(a).localeCompare(JSON.stringify(b)));
}
const envs = ['low', 'high'].map(sdk => {
  const before = read(join(logs, `source-${sdk}-before.json`));
  const after = read(join(logs, `source-${sdk}-after.json`));
  if (JSON.stringify(before) !== JSON.stringify(after)) throw new Error(`${sdk} source or lock changed during validation`);
  for (const file of after.files) {
    if (sha(readFileSync(join(root, 'tdesign-component', file.file))) !== file.sha256) throw new Error(`Current source differs from ${sdk} test snapshot: ${file.file}`);
  }
  const focusText = readFileSync(join(logs, `focus-${sdk}.log`), 'utf8');
  const fullText = readFileSync(join(logs, `full-${sdk}.log`), 'utf8');
  const analysisText = readFileSync(join(logs, `analyze-${sdk}.log`), 'utf8');
  const migrationFile = sdk === 'high' && existsSync(join(logs, 'migration-high-retry.log')) ? 'migration-high-retry.log' : `migration-${sdk}.log`;
  const migrationText = readFileSync(join(logs, migrationFile), 'utf8');
  if (!/\+47: All tests passed!/.test(focusText) || !/\+440: All tests passed!/.test(fullText) || !/No issues found!/.test(analysisText) || !/\+21: All tests passed!/.test(migrationText) || !/No issues found!/.test(migrationText)) throw new Error(`${sdk} validation did not complete`);
  const coverage = ['button', 'switch', 'input', 'link', 'avatar', 'empty', 'progress'].map(component => {
    const text = readFileSync(join(logs, `coverage-${sdk}-${component}.log`), 'utf8');
    const match = text.match(/production LH\/LF = (\d+)\/(\d+) = ([\d.]+)%/);
    if (!match || text.includes('ERROR:') || Number(match[3]) < 95) throw new Error(`${sdk} ${component} coverage failed`);
    return { component, hit: Number(match[1]), found: Number(match[2]), percent: Number(match[3]), logSha256: sha(text) };
  });
  const samples = observations(focusText);
  if (samples.some(sample => sample.enforced && !sample.matches)) throw new Error(`${sdk} enforced contract failed`);
  return { sdk: read(join(logs, `sdk-${sdk}.json`)), snapshot: after,
    focusCount: 47, regressionCount: 440, migrationCount: 21, coverage,
    migrationRetryUsed: sdk === 'high' && migrationFile.includes('retry'),
    logHashes: { focus: sha(focusText), full: sha(fullText), analysis: sha(analysisText), migration: sha(migrationText) }, samples };
});
if (JSON.stringify(envs[0].snapshot.files) !== JSON.stringify(envs[1].snapshot.files) || JSON.stringify(envs[0].samples) !== JSON.stringify(envs[1].samples)) throw new Error('The two SDKs did not verify identical source/observations');
const samples = envs[0].samples;
const byName = new Map();
for (const sample of samples) {
  const list = byName.get(sample.name) ?? [];
  list.push(sample); byName.set(sample.name, list);
}
const originalObservations = read(join(root, 'specs/059-component-token-runtime-evidence/runtime-observations.json')).observations;
const rows = rules.rows.map(rule => {
  const all = byName.get(rule.name) ?? [];
  const raw = all.filter(sample => !sample.scenario.startsWith('contract/'));
  const contract = all.filter(sample => sample.scenario.startsWith('contract/'));
  if (rule.disposition.startsWith('fixed-') && (!raw.length || raw.some(sample => !sample.matches || !sample.enforced))) throw new Error(`${rule.name} fix is not fully asserted`);
  if (rule.disposition.startsWith('existing-contract-') && (!contract.length || contract.some(sample => !sample.matches || !sample.enforced))) throw new Error(`${rule.name} contract has no enforced live witness`);
  const references = (rule.contractReferences ?? []).map(reference => {
    const text = readFileSync(join(root, reference.file), 'utf8');
    const line = text.split('\n').findIndex(line => line.includes(reference.quote)) + 1;
    if (!line) throw new Error(`${rule.name} cited contract no longer exists`);
    return { ...reference, line, sha256: sha(text) };
  });
  return { ...rule, contractReferences: references,
    beforeExamples: originalObservations.filter(sample => sample.name === rule.name && !sample.matches),
    afterRawComparisons: raw, currentContractWitnesses: contract,
    runtimeResolved: rule.disposition.startsWith('fixed-') || rule.disposition.startsWith('existing-contract-'),
    finalPaintVerified: false };
});
const counts = {};
for (const row of rows) counts[row.disposition] = (counts[row.disposition] ?? 0) + 1;
if (counts['fixed-runtime-verified-visual-pending'] !== 2 || counts['existing-contract-verified-visual-pending'] !== 8 || counts['implementation-plan-pending'] !== 21 || counts['platform-geometry-plan-pending'] !== 1) throw new Error('Unexpected resolution counts');
const patch = join(output, 'proposed-visual-fixes.patch');
execFileSync('git', ['apply', '--check', patch], { cwd: root });
const prototypeBefore = read(join(logs, 'proposed-source-before.json'));
const prototypeAfter = read(join(logs, 'proposed-source-after.json'));
if (JSON.stringify(prototypeBefore) !== JSON.stringify(prototypeAfter)) throw new Error('Prototype source or lock changed during testing');
const patchedFiles = new Set(['lib/src/components/button/t_button_resolve.dart', 'lib/src/components/switch/t_switch_resolve.dart', 'lib/src/components/switch/t_switch_theme_data.dart', 'lib/src/components/input/t_input.dart']);
for (const file of prototypeAfter.files) {
  if (!patchedFiles.has(file.file) && envs[1].snapshot.files.find(other => other.file === file.file)?.sha256 !== file.sha256) throw new Error(`Unexpected prototype change: ${file.file}`);
}
if (prototypeAfter.lockSha256 !== envs[1].snapshot.lockSha256) throw new Error('Prototype dependency lock differs from the high SDK checkpoint');
const prototypeText = readFileSync(join(logs, 'proposed-focus-high.log'), 'utf8');
if (!/\+47: All tests passed!/.test(prototypeText)) throw new Error('The isolated prototype did not pass');
const prototype = observations(prototypeText);
const targets = ['buttonDefaultActiveBgColor', 'buttonLightActiveBgColor', 'switchLabelColor', 'inputBorderColor'];
for (const name of targets) {
  const evidence = prototype.filter(sample => sample.name === name);
  if (!evidence.length || evidence.some(sample => !sample.matches)) throw new Error(`Prototype did not resolve ${name}`);
}
const report = {
  date: '2026-10-15', baselineCommit: baseline.baseline, baselineEvidenceSha256: sha(readFileSync(baselinePath)),
  counts, unchangedRuntimePending: 524,
  globalStages: { 'runtime-evidence-pending': 524, 'runtime-default-verified-visual-pending': 116,
    'fixed-runtime-verified-visual-pending': 2, 'existing-contract-verified-visual-pending': 8,
    'implementation-plan-pending': 21, 'platform-geometry-plan-pending': 1, 'no-frozen-source-consumer-found': 5 },
  scope: '32 previously disputed rows; contract support is not final visual acceptance. No claim that the remaining 524 rows are verified.',
  sourceFilesSha256: sha(JSON.stringify(envs[0].snapshot.files)), fingerprints: envs[0].snapshot.files,
  evidenceTools: [{ file: 'tool/verify_token_difference_resolutions.mjs', sha256: sha(readFileSync(fileURLToPath(import.meta.url))) }],
  checkpoints: envs.map(({ samples, snapshot, ...metadata }) => ({ ...metadata, lockSha256: snapshot.lockSha256 })),
  proposal: { appliedToMainWorkspace: false, patchSha256: sha(readFileSync(patch)), appliesCleanly: true,
    isolatedFunctionalSdk: envs[1].sdk.frameworkVersion, isolatedFocusCount: 47,
    isolatedLogSha256: sha(prototypeText), isolatedSourceSnapshot: prototypeAfter, targetObservations: prototype.filter(sample => targets.includes(sample.name)),
    limitations: ['Not a full regression of the prototype', 'Low SDK prototype not run', 'Linux Golden and design/host verification remain pending'] },
  rows,
};
if (Object.values(report.globalStages).reduce((a, b) => a + b, 0) !== 677) throw new Error('677 row totals are inconsistent');
writeFileSync(join(output, 'resolution-report.json'), `${JSON.stringify(report, null, 2)}\n`);
writeFileSync(join(output, 'runtime-observations.json'), `${JSON.stringify({ identicalAcrossSdks: true, observations: samples }, null, 2)}\n`);
const implemented = execFileSync('git', ['diff', '--', 'tdesign-component/lib/src/components/button/t_button_resolve.dart'], { cwd: root, encoding: 'utf8' });
writeFileSync(join(output, 'implemented-fix.patch'), implemented);
const labels = { 'fixed-runtime-verified-visual-pending': '已修复，运行通过，视觉待验收', 'existing-contract-verified-visual-pending': '已有契约支持，运行通过，视觉待验收', 'implementation-plan-pending': '具体实施方案待执行', 'platform-geometry-plan-pending': '平台几何方案待取证' };
const text = ['# 32项差异处置结果', '', '本记录保留Spec059的原始比较；按现有契约区分缺陷与已批准设计，未将所有差异强行改成旧小程序值。', '', '| 处置 | 项数 |', '|---|---:|', ...Object.entries(counts).map(([key, value]) => `| ${labels[key]} | ${value} |`), '', '双SDK严格分析0问题，相关完整功能回归各440项、仓库外迁移consumer各21项通过；每组件覆盖率均≥95%。47项聚焦检查包含在440项中。', '', '## 逐项方案', ''];
for (const row of rows) {
  text.push(`### ${row.name}`, '', `**${labels[row.disposition]}**`, '', row.action, '');
  if (row.risk) text.push(`影响与边界：${row.risk}`, '');
  text.push(`验证：${row.validation}`, '');
  if (row.contractReferences.length) text.push(...row.contractReferences.map(ref => `- [已有契约](../../${ref.file}#L${ref.line})：${ref.quote}`), '');
}
text.push('## 可审查补丁', '', '- [已实施的Ghost修复](implemented-fix.patch)：一个语义回退源修正，覆盖文字/描边两个观察项。', '- [四项视觉修复候选补丁](proposed-visual-fixes.patch)：未应用到主工作区；在隔离工程Flutter3.47.7的47项聚焦检查通过，20条目标观察全部匹配。仍需完整回归、低SDK、设计及Linux视觉验收。', '', '## 全量边界', '', '其余524项运行队列未减去。所有条目的finalPaintVerified仍为false；已修复或已有契约支持只关闭本次运行/契约问题，不等于最终像素验收。CI/工作流/测试清单、正式版本及Golden均未修改，未发布。', '');
writeFileSync(join(output, 'solutions.md'), text.join('\n'));
console.log(JSON.stringify({ counts, regression: [440, 440], migration: [21, 21], observationsPerSdk: samples.length, prototypeTargetsMatched: 20 }));

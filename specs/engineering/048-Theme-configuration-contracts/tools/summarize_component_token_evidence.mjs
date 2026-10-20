import { createHash } from 'node:crypto';
import { existsSync, readFileSync, readdirSync, writeFileSync } from 'node:fs';
import { dirname, join, relative, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { execFileSync } from 'node:child_process';

// Usage: node specs/engineering/048-Theme-configuration-contracts/tools/summarize_component_token_evidence.mjs <validation-log-directory>
// Stage results do not mean that visual acceptance or all 677 rows are complete.
const repo = resolve(dirname(fileURLToPath(import.meta.url)), '../../../..');
const logs = process.argv[2];
if (!logs) throw new Error('Provide the validation log directory');
const target = join(repo, 'specs/engineering/048-Theme-configuration-contracts/evidence/runtime');
const read = file => JSON.parse(readFileSync(file, 'utf8'));
const sha = data => createHash('sha256').update(data).digest('hex');
const audit = read(join(repo, 'specs/engineering/048-Theme-configuration-contracts/evidence/consumption/component-consumption-audit.json'));
const compiled = read(join(target, 'compiled-consumption.json'));
if (compiled.miniprogramCommit !== audit.miniprogramCommit || compiled.failures.length) {
  throw new Error('Frozen compilation evidence is incomplete or from a different revision');
}
function observations(sdk) {
  const text = readFileSync(join(logs, `focus-${sdk}.log`), 'utf8');
  if (!/\+46: All tests passed!/.test(text)) throw new Error(`${sdk} focus suite did not pass 46 tests`);
  return text.split('\n').flatMap(line => {
    const offset = line.indexOf('TOKEN_EVIDENCE ');
    return offset < 0 ? [] : [JSON.parse(line.slice(offset + 15))];
  }).sort((a, b) => JSON.stringify(a).localeCompare(JSON.stringify(b)));
}
const low = observations('low');
const high = observations('high');
if (JSON.stringify(low) !== JSON.stringify(high)) throw new Error('SDK observations differ; review before summarizing');
if (low.some(row => row.enforced && !row.matches)) throw new Error('An enforced contract failed');
const byName = new Map();
for (const row of low) {
  const list = byName.get(row.name) ?? [];
  list.push(row); byName.set(row.name, list);
}
const sourceLocators = read(join(repo, 'specs/engineering/048-Theme-configuration-contracts/evidence/runtime/validation-baseline.json'));
const globals = read(join(repo, 'specs/engineering/048-Theme-configuration-contracts/evidence/token-source/token-audit.json'));
const approved = globals.allowedGlobalValueExceptions;
const notes = {
  buttonBorderWidth: 'Flutter outline/ghost width is 1dp. Frozen Less declares 4rpx on a WeChat button pseudo-element. Native pseudo-element geometry/design evidence is still required; do not infer a 2dp Flutter border from the raw declaration.',
  buttonPrimaryDisabledColor: 'Dark primary fill foreground is an existing explicit Spec048 adjudication (fontWhite4), overriding the older frozen CSS default. This audit does not reverse it.',
  avatarCircleBorderRadius: 'Existing approved radiusCircle exception: CSS 50% versus Flutter 9999dp; custom radius forwarding is exercised.',
  avatarBorderColor: 'Frozen avatar border default is literal white; Flutter avatar groups use bgColorContainer. Light default matches, dark/custom differ. Needs recorded design disposition.',
  inputVerticalPadding: 'Standalone Flutter padding is documented as a fixed 16dp; frozen Less falls back to spacer2. Default matches, custom spacing does not. Decide the supported fallback contract before changing behavior.',
  buttonIconSpacer: 'The declaration has no consumer in compiled frozen CSS or other frozen source. The observed Flutter 4dp gap versus declared 8dp alone is not a defect; inspect actual upstream markup/global spacer use before making a visual change.',
  progressCircleInnerBgColor: 'Dark frozen CSS forwards undefined --bg-color-page; transparent without host definition is the existing documented adjudication. Host CSS overrides are outside this Flutter default test.',
};
const rows = audit.rows.filter(row => row.reviewDecision === 'pending').map(row => {
  const mini = compiled.rows.find(item => item.name === row.name);
  const samples = byName.get(row.name) ?? [];
  const locators = sourceLocators.components.find(item => item.name === row.name);
  let stage;
  if (mini.conclusion === 'no-consumer-in-compiled-css-or-other-source') stage = 'no-frozen-source-consumer-found';
  else if (!samples.length) stage = 'runtime-evidence-pending';
  else if (row.name === 'buttonBorderWidth') stage = 'platform-geometry-review-pending';
  else if (samples.some(sample => !sample.matches)) stage = 'runtime-difference-needs-resolution';
  else stage = 'runtime-default-verified-visual-pending';
  const requiredEvidence = [];
  if (stage === 'runtime-evidence-pending') requiredEvidence.push('Mount the matching supported public scenario and assert its final Widget/layout/Painter value, not only a getter.');
  if (stage === 'runtime-difference-needs-resolution') requiredEvidence.push('Resolve recorded target/runtime differences through an implementation fix or documented design/contract adjudication.');
  if (stage === 'platform-geometry-review-pending') requiredEvidence.push(notes.buttonBorderWidth);
  if (stage !== 'no-frozen-source-consumer-found') {
    if (!samples.some(sample => sample.scenario.includes('custom=true'))) requiredEvidence.push('Exercise applicable custom global Token and existing public override paths; do not invent a new Theme API.');
    requiredEvidence.push('Check applicable existing Theme/instance override paths per slot; a custom observation is not proof of every public branch.');
    requiredEvidence.push('Complete applicable Linux 3.32 Golden/design/state review and device evidence; no final pixel approval is asserted here.');
  }
  const directory = row.flutterDirectory?.split('/').at(-1);
  const candidateDirectory = directory ? join(repo, 'tdesign-component/test/components', directory) : null;
  const candidateExistingTests = [];
  if (candidateDirectory && existsSync(candidateDirectory) && !samples.length) {
    const getter = row.globalFallbackGetter;
    if (getter) {
      const pattern = new RegExp(`\\.\\s*${getter}\\b`);
      for (const file of files(candidateDirectory).filter(file => file.endsWith('.dart'))) {
        readFileSync(file, 'utf8').split('\n').forEach((line, index) => {
          if (candidateExistingTests.length < 6 && pattern.test(line)) {
            candidateExistingTests.push({ file: `${relative(repo, file)}:${index + 1}`, text: line.trim(), candidateOnly: true });
          }
        });
      }
    }
  }
  if (row.name.includes('Dashed')) requiredEvidence.unshift('Current TButtonVariant has no dashed case: resolve the supported capability/migration contract, then test the chosen behavior. Outline is not equivalent evidence.');
  if (/^input(?:Label|.*Tips)/.test(row.name)) requiredEvidence.unshift('Review TFormItem + TInput composition and the standalone Input contract before deciding which owner supplies this slot.');
  if (/^button.*BorderColor$/.test(row.name) && !samples.length) requiredEvidence.unshift('Check whether the frozen fill border is visually represented by the Flutter fill; color equality alone does not prove border geometry.');
  const component = samples.length ? directory : null;
  const testFile = component ? `tdesign-component/test/components/${component}/t_${component}_test.dart` : null;
  const testLine = testFile ? readFileSync(join(repo, testFile), 'utf8').split('\n').findIndex(line => line.startsWith(`void ${component}TokenConsumptionTests()`)) + 1 : null;
  return { name: row.name, component: row.miniComponent, previousDecision: row.reviewDecision,
    frozenTarget: { light: row.miniLightDefault, dark: row.miniDarkDefault, expressions: row.fallbackExpressions, source: row.sourceLocations },
    compiledSource: { conclusion: mini.conclusion, selectors: mini.compiledUses, nonLessReferences: mini.nonLessReferences },
    flutterNameLocators: locators?.currentNameLocators ?? {},
    approvedGlobalException: approved[row.globalFallbackGetter] ?? null,
    stage, runtimeDefaultVerified: stage === 'runtime-default-verified-visual-pending',
    testEntry: testFile ? `${testFile}:${testLine}` : null,
    observedScenariosPerSdk: samples.length,
    hasCustomTokenObservation: samples.some(sample => sample.scenario.includes('custom=true')),
    observationsFile: samples.length ? 'runtime-observations.json' : null,
    notes: notes[row.name] ?? null, candidateExistingTests, requiredEvidence,
    finalPaintVerified: false,
  };
});
if (rows.length !== 677) throw new Error(`Expected the frozen 677 pending rows, got ${rows.length}`);
const counts = {};
for (const row of rows) counts[row.stage] = (counts[row.stage] ?? 0) + 1;
function files(path) {
  return readdirSync(path, { withFileTypes: true }).sort((a, b) => a.name.localeCompare(b.name))
    .flatMap(entry => entry.isDirectory() ? files(join(path, entry.name)) : [join(path, entry.name)]);
}
const relevantTests = readFileSync(join(logs, 'manifest-files.txt'), 'utf8').trim().split('\n').map(file => `tdesign-component/${file}`);
const fingerprintFiles = [
  ...files(join(repo, 'tdesign-component/lib')),
  ...files(join(repo, 'tdesign-component/assets')),
  ...relevantTests.map(file => join(repo, file)),
  join(repo, 'tdesign-component/test/support/token_consumption_evidence.dart'),
  join(repo, 'tdesign-component/tool/component_test_manifest.dart'),
  join(repo, 'tdesign-component/pubspec.yaml'),
];
const fingerprints = fingerprintFiles.map(file => ({ file: relative(repo, file), sha256: sha(readFileSync(file)) }));
const checkpoints = ['low', 'high'].map(sdk => {
  const regression = readFileSync(join(logs, `full-${sdk}.log`), 'utf8');
  const analysis = readFileSync(join(logs, `analyze-${sdk}.log`), 'utf8');
  if (!/All tests passed!/.test(regression) || !/No issues found!/.test(analysis)) throw new Error(`${sdk} final validation failed`);
  const coverage = ['button', 'switch', 'input', 'link', 'avatar', 'empty', 'progress'].map(component => {
    const text = readFileSync(join(logs, `coverage-${sdk}-${component}.log`), 'utf8');
    const match = text.match(/production LH\/LF = (\d+)\/(\d+) = ([\d.]+)%/);
    if (!match || text.includes('ERROR:') || Number(match[3]) < 95) throw new Error(`${sdk} ${component} coverage failed`);
    return { component, hit: Number(match[1]), found: Number(match[2]), percent: Number(match[3]), logSha256: sha(text) };
  });
  return { sdk: read(join(logs, `sdk-${sdk}.json`)),
    lockSha256: sha(readFileSync(sdk === 'low' ? join(repo, 'tdesign-component/pubspec.lock') : join(logs, 'pubspec-high.lock'))),
    regressionCount: Number(regression.match(/\+(\d+): All tests passed!/)[1]),
    regressionLogSha256: sha(regression), analysisLogSha256: sha(analysis),
    focusCount: 46, focusLogSha256: sha(readFileSync(join(logs, `focus-${sdk}.log`))), coverage };
});
const summary = { date: '2026-10-15', baseline: execFileSync('git', ['rev-parse', 'HEAD'], { cwd: repo, encoding: 'utf8' }).trim(),
  miniprogramCommit: audit.miniprogramCommit, frozenArchive: {
    url: `https://codeload.github.com/Tencent/tdesign-miniprogram/tar.gz/${audit.miniprogramCommit}`,
    sha256: sha(readFileSync(join(logs, 'frozen-source.tar.gz'))),
  }, scope: '677 historical pending rows; runtime default evidence and frozen source applicability are separate from final visual acceptance.',
  counts, observationNames: byName.size, observationsPerSdk: low.length, identicalAcrossSdks: true,
  checkpoints, evidenceTools: ['specs/engineering/048-Theme-configuration-contracts/tools/audit_compiled_token_consumption.mjs', 'specs/engineering/048-Theme-configuration-contracts/tools/summarize_component_token_evidence.mjs'].map(file => ({ file, sha256: sha(readFileSync(join(repo, file))) })), sourceFingerprintSha256: sha(JSON.stringify(fingerprints)), fingerprints, rows };
writeFileSync(join(target, 'runtime-observations.json'), `${JSON.stringify({ lowSdk: checkpoints[0].sdk.frameworkVersion, highSdk: checkpoints[1].sdk.frameworkVersion, identicalAcrossSdks: true, observations: low }, null, 2)}\n`);
writeFileSync(join(target, 'runtime-review.json'), `${JSON.stringify(summary, null, 2)}\n`);
console.log(JSON.stringify({ counts, observationNames: byName.size, observationsPerSdk: low.length, regressions: checkpoints.map(item => item.regressionCount) }));

const labels = {
  'runtime-evidence-pending': '待补运行证据',
  'runtime-default-verified-visual-pending': '默认运行已验证，视觉待验收',
  'runtime-difference-needs-resolution': '运行差异待处理',
  'platform-geometry-review-pending': '平台几何待裁定',
  'no-frozen-source-consumer-found': '冻结源码未找到消费者',
};
const totals = new Map();
for (const row of rows) {
  const item = totals.get(row.component) ?? {};
  item[row.stage] = (item[row.stage] ?? 0) + 1;
  totals.set(row.component, item);
}
const output = [
  '# 677项组件消费队列：冻结运行检查点', '',
  '这是运行检查点，不是当前候选发布批准。后续差异处置见 [处置报告](../differences/solutions.md)，当前工作统一见 [tasks.md](../../tasks.md)；原始观察不回写成后续通过。', '',
  '| 状态 | 项数 |', '|---|---:|',
  ...Object.entries(counts).map(([key, value]) => `| ${labels[key]} | ${value} |`), '',
  `两套SDK各46项新增检查，逐SDK采集${low.length}条观察，涉及${byName.size}个变量名（含1项既有已审变量）；两套观察逐条相同。46项是各439项完整相关功能回归的子集，不重复相加。`, '',
  '## 证据解释', '',
  '- 默认运行已验证只关闭该层证据；不表示每个公开覆盖路径、所有状态、设计像素或真机已通过。',
  '- enforce=false是差异诊断，不是通过断言；这些观察进入差异队列，不冒充绿色对齐用例。既有及新增已确认契约的assert仍由普通测试执行。',
  '- 31项是变量级差异，可能共用根因，不等于31个独立缺陷。固定规格、语义Token别名与设计例外需要契约裁定。',
  '- 已批准的grayColor3/radiusCircle等全局差异沿用Spec047，主色填充按钮深色禁用文字沿用Spec048；不反向覆盖已批准决策。',
  '- 5项只关闭冻结版本的消费者查找，不删除公开CSS变量，也不推定未来版本无消费者。',
  '- 未验证或发现差异的条目没有修改finalPaintVerified。当前未改生产行为、CI、测试清单、版本号或Golden。', '',
  '## 实测差异', '',
  '| 变量 | 代表场景 | 实际值 | 比较目标 |', '|---|---|---|---|',
];
for (const row of rows.filter(row => row.stage === 'runtime-difference-needs-resolution')) {
  const sample = byName.get(row.name).find(sample => !sample.matches && sample.scenario.includes('custom=false')) ?? byName.get(row.name).find(sample => !sample.matches);
  output.push(`| ${row.name} | ${sample.scenario} | ${sample.actual} | ${sample.expected} |`);
}
output.push('', '完整浅/暗、正常/按压/禁用、默认/自定义观察见[runtime-observations.json](runtime-observations.json)，目标源码、现有测试候选和每项缺口见[runtime-review.json](runtime-review.json)。', '', '## 逐组件分布', '', '| 组件 | 默认运行已验证 | 差异待处理 | 平台几何 | 无消费者 | 待补运行 |', '|---|---:|---:|---:|---:|---:|');
for (const [component, item] of [...totals].sort(([a], [b]) => a.localeCompare(b))) {
  output.push(`| ${component} | ${item['runtime-default-verified-visual-pending'] ?? 0} | ${item['runtime-difference-needs-resolution'] ?? 0} | ${item['platform-geometry-review-pending'] ?? 0} | ${item['no-frozen-source-consumer-found'] ?? 0} | ${item['runtime-evidence-pending'] ?? 0} |`);
}
output.push('', '## 本批默认运行通过清单', '', '| 变量 | 测试入口 | 观察数/SDK |', '|---|---|---:|');
for (const row of rows.filter(row => row.runtimeDefaultVerified)) {
  const [file, line] = row.testEntry.split(':');
  output.push(`| ${row.name} | [测试函数](../../../../../${file}#L${line}) | ${row.observedScenariosPerSdk} |`);
}
output.push('', '## 冻结源码无消费者', '', ...rows.filter(row => row.stage === 'no-frozen-source-consumer-found').map(row => `- ${row.name}：声明存在，但本次冻结源码的编译CSS和其他源文件均未找到消费；保留声明，后续源版本变化重审。`), '');
writeFileSync(join(target, 'runtime-review.md'), output.join('\n'));
if (process.argv.includes('--require-complete')) {
  const unresolved = rows.filter(row => row.stage !== 'no-frozen-source-consumer-found' && !row.finalPaintVerified).length;
  if (unresolved) {
    console.error(`NOT COMPLETE: ${unresolved} rows still need applicable runtime/contract/visual acceptance.`);
    process.exitCode = 1;
  }
}

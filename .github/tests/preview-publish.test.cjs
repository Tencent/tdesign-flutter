const assert = require('node:assert/strict');
const { execFileSync } = require('node:child_process');
const path = require('node:path');

// Parse the workflow as YAML instead of depending on indentation or line numbers.
const workflowPath = path.join(__dirname, '../workflows/preview-publish.yml');
const workflow = JSON.parse(execFileSync('ruby', [
  '-r', 'yaml', '-r', 'json', '-e', 'puts JSON.generate(YAML.load_file(ARGV.fetch(0)))', workflowPath,
], { encoding: 'utf8' }));
const jobs = workflow.jobs;
const resolver = (job) => jobs[job].steps.find((step) => step.id === 'pr').with.script;
const scripts = [resolver('preview-success'), resolver('preview-failed')];
assert.equal(scripts[0], scripts[1], 'Both paths must use the same PR resolution');
const report = jobs['preview-success'].steps.find((step) => step.name === 'Report publish failure');
assert.match(report.if, /steps\.pr\.outcome == 'success'/);

const AsyncFunction = Object.getPrototypeOf(async function () {}).constructor;
const run = {
  head_repository: { full_name: 'runoob-coder/tdesign-flutter' },
  head_branch: 'fix/slider-capsule-thumb-travel',
  head_sha: 'abc',
};
const context = { repo: { owner: 'Tencent', repo: 'tdesign-flutter' }, payload: { workflow_run: run } };
const pull = (changes = {}) => ({
  number: 1212,
  base: { repo: { full_name: 'Tencent/tdesign-flutter' }, ref: 'develop' },
  head: { repo: { full_name: run.head_repository.full_name }, ref: run.head_branch, sha: run.head_sha },
  ...changes,
});
async function resolve(pulls, event = run) {
  let query;
  let failure;
  const list = () => {};
  const github = {
    rest: { pulls: { list } },
    paginate: async (method, params) => {
      assert.equal(method, list);
      query = params;
      return pulls;
    },
  };
  const core = { setFailed: (message) => { failure = message; } };
  const number = await new AsyncFunction('github', 'context', 'core', scripts[0])(
    github, { ...context, payload: { workflow_run: event } }, core,
  );
  return { number, query, failure };
}
async function main() {
  let result = await resolve([pull()]);
  assert.equal(result.number, '1212');
  assert.deepEqual(result.query, {
    owner: 'Tencent', repo: 'tdesign-flutter', state: 'open',
    head: 'runoob-coder:fix/slider-capsule-thumb-travel', per_page: 100,
  });
  const sameRepo = { ...run, head_repository: { full_name: 'Tencent/tdesign-flutter' } };
  const sameHead = { ...pull().head, repo: { full_name: sameRepo.head_repository.full_name } };
  assert.equal((await resolve([pull({ head: sameHead })], sameRepo)).number, '1212');
  const wrongRepo = { ...pull().head, repo: { full_name: 'other/tdesign-flutter' } };
  const stale = { ...pull().head, sha: 'new' };
  const wrongBranch = { ...pull().head, ref: 'other' };
  const wrongBase = { repo: { full_name: 'Tencent/tdesign-flutter' }, ref: 'other' };
  for (const candidates of [
    [], [pull({ head: wrongRepo })], [pull({ head: stale })], [pull({ head: wrongBranch })],
    [pull({ base: wrongBase })], [pull(), pull({ number: 1213 })], [pull({ number: 0 })],
  ]) {
    result = await resolve(candidates);
    assert.equal(result.number, undefined);
    assert.match(result.failure, /Expected one source PR/);
  }
  assert.equal((await resolve([pull({ base: wrongBase }), pull()])).number, '1212');
  const mainBase = { repo: { full_name: 'Tencent/tdesign-flutter' }, ref: 'main' };
  assert.equal((await resolve([pull({ base: mainBase })])).number, '1212');
  assert.equal((await resolve([...Array(100).fill(pull({ base: wrongBase })), pull()])).number, '1212');
  await assert.rejects(resolve([], { ...run, head_branch: '' }), /missing/);
  console.log('Preview PR resolution checks passed');
}
main().catch((error) => { console.error(error); process.exit(1); });

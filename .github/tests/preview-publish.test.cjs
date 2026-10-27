const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');

// Run the scripts in the workflow itself so this test exercises the shipped logic.
const yaml = fs.readFileSync(path.join(__dirname, '../workflows/preview-publish.yml'), 'utf8');
function scriptFor(id) {
  const step = yaml.split(/\n      - name: /).find((part) => part.includes(`\n        id: ${id}\n`));
  assert.ok(step, `Missing step ${id}`);
  const block = step.split('          script: |\n')[1];
  assert.ok(block, `Missing script for ${id}`);
  return block.split('\n')
    .filter((line) => line.startsWith('            '))
    .map((line) => line.slice(12)).join('\n');
}
const checkIds = ['before_deploy', 'before_comment', 'before_publish_failure', 'before_failure_comment'];
const scripts = Object.fromEntries(['pr', ...checkIds].map((id) => [id, scriptFor(id)]));
const AsyncFunction = Object.getPrototypeOf(async function () {}).constructor;
const run = {
  head_repository: { full_name: 'runoob-coder/tdesign-flutter' },
  head_branch: 'fix/slider-capsule-thumb-travel',
  head_sha: 'abc',
};
const context = { repo: { owner: 'Tencent', repo: 'tdesign-flutter' }, payload: { workflow_run: run } };
const pull = (changes = {}) => ({
  number: 1212,
  state: 'open',
  base: { repo: { full_name: 'Tencent/tdesign-flutter' }, ref: 'develop' },
  head: { repo: { full_name: run.head_repository.full_name }, ref: run.head_branch, sha: run.head_sha },
  ...changes,
});
async function resolve(pulls, event = run) {
  const outputs = {};
  const notices = [];
  let query;
  const github = {
    rest: { pulls: { list: () => {} } },
    paginate: async (_, params) => { query = params; return pulls; },
  };
  const core = { setOutput: (key, value) => { outputs[key] = value; }, notice: (value) => notices.push(value) };
  await new AsyncFunction('github', 'context', 'core', scripts.pr)(
    github, { ...context, payload: { workflow_run: event } }, core,
  );
  return { outputs, notices, query };
}

async function main() {
  let result = await resolve([pull()]);
  assert.equal(result.outputs.number, '1212');
  assert.equal(result.query.head, 'runoob-coder:fix/slider-capsule-thumb-travel');
  assert.equal(result.query.per_page, 100);
  assert.equal(result.query.state, 'all');

  const same = { ...run, head_repository: { full_name: 'Tencent/tdesign-flutter' } };
  const sameHead = { repo: { full_name: same.head_repository.full_name }, ref: run.head_branch, sha: 'abc' };
  result = await resolve([pull({ head: sameHead })], same);
  assert.equal(result.outputs.number, '1212');

  const changedHead = { repo: { full_name: run.head_repository.full_name }, ref: run.head_branch, sha: 'new' };
  result = await resolve([pull({ head: changedHead })]);
  assert.equal(result.outputs.number, undefined);
  assert.equal(result.notices.length, 1);
  assert.equal((await resolve([pull({ state: 'closed' })])).outputs.number, undefined);
  await assert.rejects(resolve([]), /No open source PR/);
  await assert.rejects(resolve([], { ...run, head_branch: '' }), /missing/);
  await assert.rejects(resolve([pull(), pull({ number: 1213 })]), /Multiple source PRs/);
  await assert.rejects(resolve([pull({ head: { ...sameHead, repo: { full_name: 'other/tdesign-flutter' } } })]), /No open source PR/);
  await assert.rejects(resolve([pull({ base: { repo: { full_name: 'other/tdesign-flutter' }, ref: 'develop' } })]), /No open source PR/);
  const otherBase = { repo: { full_name: 'Tencent/tdesign-flutter' }, ref: 'other' };
  assert.equal((await resolve([pull({ base: otherBase }), pull()])).outputs.number, '1212');

  for (const id of checkIds) {
    const cases = [
      [pull(), 'true'],
      [pull({ state: 'closed' }), 'false'],
      [pull({ base: otherBase }), 'false'],
      [pull({ head: changedHead }), 'false'],
    ];
    for (const [candidate, expected] of cases) {
      const outputs = {};
      process.env.PR_NUMBER = '1212';
      const github = { rest: { pulls: { get: async () => ({ data: candidate }) } } };
      const core = { setOutput: (key, value) => { outputs[key] = value; }, notice: () => {} };
      await new AsyncFunction('github', 'context', 'core', scripts[id])(github, context, core);
      assert.equal(outputs.current, expected, id);
    }
  }
  console.log('Preview PR resolution and freshness checks passed');
}
main().catch((error) => { console.error(error); process.exit(1); });

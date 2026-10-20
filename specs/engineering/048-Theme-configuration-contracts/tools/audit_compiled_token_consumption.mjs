import { readFileSync, readdirSync, writeFileSync } from 'node:fs';
import { createHash } from 'node:crypto';
import { createRequire } from 'node:module';
import { dirname, join, relative, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

// Compile frozen Less so @@ lookups are resolved instead of treating every
// declaration in a component containing @@ as a possible dynamic consumer.
const repo = resolve(dirname(fileURLToPath(import.meta.url)), '../../../..');
const miniRoot = process.argv[2];
if (!miniRoot) throw new Error('Usage: node specs/engineering/048-Theme-configuration-contracts/tools/audit_compiled_token_consumption.mjs <frozen-miniprogram-root>');
const require = createRequire(join(repo, 'tdesign-site/package.json'));
const less = require('less');
const audit = JSON.parse(readFileSync(join(repo, 'specs/engineering/048-Theme-configuration-contracts/evidence/consumption/component-consumption-audit.json')));
const source = join(miniRoot, 'packages/components');
function files(path) {
  return readdirSync(path, { withFileTypes: true }).sort((a, b) => a.name.localeCompare(b.name))
    .flatMap(entry => entry.isDirectory() ? files(join(path, entry.name)) : [join(path, entry.name)]);
}
const inputs = files(source);
const uses = new Map();
const failures = [];
const compiled = [];
const byHash = new Map();
for (const file of inputs.filter(file => file.endsWith('.less'))) {
  const text = readFileSync(file, 'utf8');
  const path = relative(miniRoot, file);
  try {
    const result = await less.render(text, { filename: file, javascriptEnabled: false });
    compiled.push({ file: path, sha256: createHash('sha256').update(text).digest('hex'), cssSha256: createHash('sha256').update(result.css).digest('hex') });
    for (const block of result.css.matchAll(/([^{}]+)\{([^{}]*)\}/g)) {
      const selector = block[1].trim();
      for (const declaration of block[2].split(';')) {
        const match = declaration.trim().match(/^([\w-]+)\s*:\s*([\s\S]+)$/);
        if (!match) continue;
        for (const variable of match[2].matchAll(/var\(\s*(--td-[\w-]+)/g)) {
          const record = { file: path, selector, property: match[1], kind: match[1].startsWith('--') ? 'custom-property-forward' : 'render-property', value: match[2].trim() };
          const key = `${variable[1]}:${JSON.stringify(record)}`;
          if (byHash.has(key)) continue;
          byHash.set(key, true);
          const list = uses.get(variable[1]) ?? [];
          list.push(record); uses.set(variable[1], list);
        }
      }
    }
  } catch (error) {
    failures.push({ file: path, error: String(error) });
  }
}
const external = inputs.filter(file => /\.(?:wxss|wxml|wxs|js|ts)$/.test(file)).map(file => ({ file: relative(miniRoot, file), lines: readFileSync(file, 'utf8').split('\n') }));
const rows = audit.rows.map(row => {
  const nonLessReferences = external.flatMap(({ file, lines }) => lines.flatMap((line, index) => line.includes(row.miniCssName) ? [{ file, line: index + 1, text: line.trim() }] : []));
  const compiledUses = uses.get(row.miniCssName) ?? [];
  const relatedFailures = failures.filter(failure => failure.file.startsWith(`packages/components/${row.miniComponent}/`) || failure.file.startsWith('packages/components/common/'));
  return { name: row.name, miniComponent: row.miniComponent, cssName: row.miniCssName,
    previousDecision: row.reviewDecision, compiledUses, nonLessReferences, relatedFailures,
    conclusion: compiledUses.length ? 'compiled-css-consumer-found'
      : nonLessReferences.length ? 'non-less-reference-needs-review'
      : relatedFailures.length ? 'compilation-incomplete'
      : 'no-consumer-in-compiled-css-or-other-source',
    // Absence is limited to this frozen archive; not a promise about all hosts.
    finalPaintVerified: false,
  };
});
const counts = {};
for (const row of rows) counts[row.conclusion] = (counts[row.conclusion] ?? 0) + 1;
const output = { miniprogramCommit: audit.miniprogramCommit, lessVersion: less.version.join('.'),
  caveat: 'Compilation proves selector/property consumption, not browser runtime, CSS host overrides, Flutter parity or design pixels. Source root must be the recorded frozen archive.',
  compiled, failures, counts, rows };
writeFileSync(join(repo, 'specs/engineering/048-Theme-configuration-contracts/evidence/runtime/compiled-consumption.json'), `${JSON.stringify(output, null, 2)}\n`);
console.log(JSON.stringify({ compiledFiles: compiled.length, failures: failures.length, counts }));

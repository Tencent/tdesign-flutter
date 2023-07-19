import test from 'ava';
import unescapeJs from '../dist/index.js';

test('usual escape sequences', t => {
    t.is(unescapeJs('---\\0---'), '---\0---');
    t.is(unescapeJs('---\\b---'), '---\b---');
    t.is(unescapeJs('---\\f---'), '---\f---');
    t.is(unescapeJs('---\\n---'), '---\n---');
    t.is(unescapeJs('---\\r---'), '---\r---');
    t.is(unescapeJs('---\\t---'), '---\t---');
    t.is(unescapeJs('---\\v---'), '---\v---');
    t.is(unescapeJs("---\\'---"), '---\'---');
    t.is(unescapeJs('---\\"---'), '---\"---');
    t.is(unescapeJs('---\\\\---'), '---\\---');
});

test('octal escape sequences', t => {
    // '---S---' instead of '---\123---' because octal literals are prohibited in strict mode
    t.is(unescapeJs('---\\123---'), '---S---');
    t.is(unescapeJs('---\\040---'), '--- ---');
    t.is(unescapeJs('---\\54---'), '---,---');
    t.is(unescapeJs('---\\4---'), '---\u{4}---');
});

test('short hex escape sequences', t => {
    t.is(unescapeJs('---\\xAC---'), '---\xAC---');
});

test('long hex escape sequences', t => {
    t.is(unescapeJs('---\\u00A9---'), '---\u00A9---');
});

test('variable hex escape sequences', t => {
    t.is(unescapeJs('---\\u{A9}---'), '---\u{A9}---');
    t.is(unescapeJs('---\\u{2F804}---'), '---\u{2F804}---');
});

test('avoids double unescape cascade', t => {
    t.is(unescapeJs('---\\\\x41---'), '---\\x41---');
    t.is(unescapeJs('---\\x5cx41---'), '---\\x41---');
});

test('python hex escape sequences', t => {
    t.is(unescapeJs('---\\U000000A9---'), '---\u00A9---');
    t.is(unescapeJs('---\\U0001F3B5---'), '---\uD83C\uDFB5---');
});

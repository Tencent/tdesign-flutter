import assert from 'node:assert/strict';
import test from 'node:test';
import { createDocumentNavigation, revealDocumentAnchor } from './documentAnchor.mjs';

function fixture() {
  const outer = { tagName: 'DETAILS', open: false, parentElement: null };
  const inner = { tagName: 'DETAILS', open: false, parentElement: outer };
  const target = { parentElement: inner };
  const root = {
    getElementById: id => id === '按钮' ? target : null,
    querySelectorAll: () => [outer, inner],
  };
  let entryPosition = 0;
  return {
    root, inner, outer, target,
    setEntryPosition: value => { entryPosition = value; },
    navigation: createDocumentNavigation(() => root, () => entryPosition),
  };
}
const start = { path: '/', fullPath: '/' };
const guide = { path: '/guide', fullPath: '/guide#按钮', hash: '#%E6%8C%89%E9%92%AE' };
const other = { path: '/other', fullPath: '/other', hash: '' };

test('encoded anchors reveal every folded ancestor and preserve open sections', () => {
  const { root, inner, outer, target } = fixture();
  inner.open = true;
  assert.equal(revealDocumentAnchor(guide.hash, root), target);
  assert.equal(inner.open, true);
  assert.equal(outer.open, true);
});

test('invalid and missing fragments do not open unrelated sections', () => {
  for (const hash of ['', '#', '#%ZZ', '#missing']) {
    const { root, inner, outer } = fixture();
    assert.equal(revealDocumentAnchor(hash, root), null);
    assert.equal(inner.open, false);
    assert.equal(outer.open, false);
  }
});

test('group and appendix links open the target details itself', () => {
  for (const id of ['migration-group-basic', 'migration-legacy-types']) {
    const target = { tagName: 'DETAILS', open: false, parentElement: null };
    assert.equal(revealDocumentAnchor(`#${id}`, { getElementById: () => target }), target);
    assert.equal(target.open, true);
  }
});

test('cross-page anchors wait for rendered content and reserve 80px', async () => {
  const { navigation, inner, target } = fixture();
  navigation.begin(guide, start);
  let resolved = false;
  const pending = navigation.scroll(guide, null);
  pending.then(() => { resolved = true; });
  await Promise.resolve();
  assert.equal(resolved, false);
  assert.equal(inner.open, false);
  navigation.ready(guide.fullPath);
  assert.deepEqual(await pending, { el: target, top: 80 });
  assert.equal(inner.open, true);
});

test('history restores folds before returning the saved reading position', async () => {
  const { navigation, inner, outer, setEntryPosition } = fixture();
  navigation.begin(guide, start);
  const initial = navigation.scroll(guide, null);
  navigation.ready(guide.fullPath);
  await initial;
  outer.open = true;
  inner.open = false; // A manually closed section must not be reopened just because it holds the hash.
  navigation.begin(other, guide);
  setEntryPosition(1);
  const outgoing = navigation.scroll(other, null);
  navigation.ready(other.fullPath);
  await outgoing;
  outer.open = false;
  inner.open = true; // Simulate fresh destination DOM with different default folds.
  setEntryPosition(0); // popstate updates browser history before the guard.
  navigation.begin(guide, other);
  const saved = { left: 0, top: 2866 };
  const pending = navigation.scroll(guide, saved);
  navigation.ready(guide.fullPath);
  assert.equal(await pending, saved);
  assert.equal(outer.open, true);
  assert.equal(inner.open, false);
});

test('same-page hash navigation resolves without another mounted event', () => {
  const { navigation, target } = fixture();
  navigation.begin(guide, start);
  navigation.ready(guide.fullPath);
  const next = { ...guide, fullPath: '/guide#%E6%8C%89%E9%92%AE' };
  navigation.begin(next, guide);
  assert.deepEqual(navigation.scroll(next, null), { el: target, top: 80 });
});

test('ready-before-scroll and top-zero history positions are retained', () => {
  const { navigation } = fixture();
  navigation.begin(other, start);
  navigation.ready(other.fullPath);
  assert.deepEqual(navigation.scroll(other, null), { top: 0 });
  const saved = { left: 0, top: 0 };
  assert.equal(navigation.scroll(other, saved), saved);
});

test('superseded navigation resolves false and ignores stale content events', async () => {
  const { navigation } = fixture();
  navigation.begin(guide, start);
  const old = navigation.scroll(guide, null);
  navigation.begin(other, guide);
  assert.equal(await old, false);
  navigation.ready(guide.fullPath);
  assert.equal(navigation.scroll(guide, null), false);
  const current = navigation.scroll(other, null);
  navigation.ready(other.fullPath);
  assert.deepEqual(await current, { top: 0 });
});

test('repeated visits to one URL restore each history entry on back and forward', async () => {
  const { navigation, inner, outer, setEntryPosition } = fixture();
  let current = start;
  const visit = async (to, entry, saved = null) => {
    // On pop the destination position is already visible during beforeEach.
    if (saved) setEntryPosition(entry);
    navigation.begin(to, current);
    setEntryPosition(entry);
    const result = navigation.scroll(to, saved);
    navigation.ready(to.fullPath);
    assert.deepEqual(await result, saved ?? { top: 0 });
    current = to;
  };
  const page = { path: '/guide', fullPath: '/guide', hash: '' };
  const third = { path: '/third', fullPath: '/third', hash: '' };
  await visit(page, 0);
  outer.open = true;
  inner.open = false;
  await visit(other, 1);
  await visit(page, 2);
  outer.open = false;
  inner.open = true;
  await visit(third, 3);
  await visit(page, 2, { top: 720, left: 0 });
  assert.deepEqual([outer.open, inner.open], [false, true]);
  await visit(other, 1, { top: 0, left: 0 });
  await visit(page, 0, { top: 2866, left: 0 });
  assert.deepEqual([outer.open, inner.open], [true, false]);
  await visit(other, 1, { top: 0, left: 0 });
  await visit(page, 2, { top: 720, left: 0 });
  assert.deepEqual([outer.open, inner.open], [false, true]);
});

test('new navigation discards the fold snapshot of a replaced forward entry', async () => {
  const { navigation, inner, outer, setEntryPosition } = fixture();
  const page = { path: '/guide', fullPath: '/guide', hash: '' };
  const visit = async (to, from, entry, saved = null) => {
    navigation.begin(to, from);
    setEntryPosition(entry);
    const result = navigation.scroll(to, saved);
    navigation.ready(to.fullPath);
    await result;
  };
  await visit(other, start, 0);
  await visit(page, other, 1);
  outer.open = true;
  inner.open = true;
  await visit(other, page, 0, { top: 0 });
  outer.open = false;
  inner.open = false;
  // A new push replaces the forward slot at position 1, even with the same URL.
  await visit(page, other, 1);
  assert.deepEqual([outer.open, inner.open], [false, false]);
  await visit(other, page, 2);
  await visit(page, other, 1, { top: 0 });
  assert.deepEqual([outer.open, inner.open], [false, false]);
});

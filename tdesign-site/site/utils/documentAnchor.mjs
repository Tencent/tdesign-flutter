/** Reveal folded guide sections before measuring an anchor. */
export function revealDocumentAnchor(hash, root = document) {
  if (!hash || hash === '#') return null;
  let id;
  try { id = decodeURIComponent(hash.slice(1)); } catch { return null; }
  const target = root.getElementById(id);
  if (!target) return null;
  const sectionId = target.getAttribute?.('data-expand-details');
  const explicitSection = sectionId && root.getElementById(sectionId);
  if (explicitSection?.tagName === 'DETAILS') explicitSection.open = true;
  for (let parent = target; parent; parent = parent.parentElement) {
    if (parent.tagName === 'DETAILS') parent.open = true;
  }
  return target;
}

/** Reveal on every ordinary click, including an unchanged URL fragment. */
export function revealClickedDocumentAnchor(event, root = document) {
  if (event.defaultPrevented || event.button !== 0 || event.ctrlKey || event.metaKey || event.shiftKey || event.altKey) return null;
  const link = event.target?.closest?.('a[href]');
  if (!link || link.hasAttribute('download') || (link.target && link.target !== '_self')) return null;
  const href = link.getAttribute('href');
  return href?.startsWith('#') ? revealDocumentAnchor(href, root) : null;
}

/** Wait for rendered content before resolving either a history position or an anchor. */
export function createDocumentNavigation(
  getRoot = () => document,
  getEntryPosition = () => globalThis.history?.state?.position,
) {
  const folds = new Map();
  let navigation = { fullPath: null, path: null, ready: false, pending: null, entryPosition: null };
  const details = () => [...getRoot().querySelectorAll('td-doc-content details')];

  function position(to, savedPosition) {
    if (savedPosition) {
      const snapshot = folds.get(navigation.entryPosition);
      if (snapshot?.fullPath === to.fullPath) {
        details().forEach((detail, index) => {
          detail.open = snapshot.folds[index] ?? detail.open;
        });
      } else {
        revealDocumentAnchor(to.hash, getRoot());
      }
      return savedPosition;
    }
    if (!to.hash) return { top: 0 };
    const target = revealDocumentAnchor(to.hash, getRoot());
    return target ? { el: target } : false;
  }

  return {
    begin(to, from) {
      if (navigation.ready && navigation.path === from.path && navigation.entryPosition != null) {
        folds.set(navigation.entryPosition, {
          fullPath: from.fullPath,
          folds: details().map(detail => detail.open),
        });
      }
      navigation.pending?.(false);
      navigation = {
        fullPath: to.fullPath,
        path: to.path,
        ready: to.path === from.path && navigation.ready,
        pending: null,
        entryPosition: null,
      };
    },
    ready(fullPath) {
      if (fullPath !== navigation.fullPath) return;
      navigation.ready = true;
      navigation.pending?.(true);
      navigation.pending = null;
    },
    scroll(to, savedPosition) {
      if (to.fullPath !== navigation.fullPath) return false;
      // Vue Router has committed push/replace/pop by scrollBehavior; beforeEach
      // can still see the outgoing entry on push and the destination on pop.
      navigation.entryPosition = getEntryPosition();
      if (!savedPosition) folds.delete(navigation.entryPosition);
      if (navigation.ready) return position(to, savedPosition);
      return new Promise(resolve => {
        navigation.pending = ready => resolve(ready ? position(to, savedPosition) : false);
      });
    },
  };
}

export const documentNavigation = createDocumentNavigation();

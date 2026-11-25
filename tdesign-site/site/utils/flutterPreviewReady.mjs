/** Notify the shared theme controller on first mount and each iframe reload. */
export function setupFlutterPreviewReadyListener(iframe, eventTarget = window) {
  const notifyReady = () => {
    eventTarget.dispatchEvent(new CustomEvent('flutter-demo-ready', { detail: { iframe } }));
  };
  iframe.addEventListener('load', notifyReady);
  if (iframe.contentWindow) notifyReady();
  return () => iframe.removeEventListener('load', notifyReady);
}

export const defaultFlutterDevServerPort = '19001';

export function flutterExampleLiveUrl(
  componentName,
  { dev = false, hostname = '127.0.0.1', devServerPort = defaultFlutterDevServerPort } = {},
) {
  if (!componentName) {
    throw new Error('Missing Flutter example component name');
  }

  const base = dev
    ? `http://${hostname}:${devServerPort}/`
    : '/flutter/example/';
  return `${base}#${encodeURIComponent(componentName)}`;
}

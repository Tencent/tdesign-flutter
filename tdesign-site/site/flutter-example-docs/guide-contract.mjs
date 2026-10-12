import matter from 'gray-matter';
import { readFlutterExampleManifest } from './transform.mjs';

export const guideExamples = Object.freeze(readFlutterExampleManifest().guides ?? {});

/** Validate before rendering so a broken guide cannot produce a successful build. */
export function validateGuidePage(source, slug) {
  const { data, content } = matter(source);
  if (!data.flutterPreview && !guideExamples[slug]) return;
  if (!guideExamples[slug] || data.flutterPreview !== slug) {
    throw new Error(`${slug}: unknown or mismatched Flutter guide route`);
  }
  if ('flutterPreviewHeight' in data || content.includes('data-flutter-guide-preview')) {
    throw new Error(`${slug}: guide must use the shared Flutter preview container`);
  }
  const keys = [...content.matchAll(/\{\{\s*flutter-example\s+([^\s}]+)\s*\}\}/g)].map((match) => match[1]);
  if (keys.length !== 1 || keys[0] !== guideExamples[slug]) {
    throw new Error(`${slug}: preview must use its actual generated example source`);
  }
}

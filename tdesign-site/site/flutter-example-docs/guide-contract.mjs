import matter from 'gray-matter';
import { readFlutterExampleManifest } from './transform.mjs';

export const guideExamples = Object.freeze(readFlutterExampleManifest().guides ?? {});
export const guidePreviewMarker = '<div data-flutter-guide-preview></div>';

/** Validate before rendering so a broken guide cannot produce a successful build. */
export function validateGuidePage(source, slug) {
  const { data, content } = matter(source);
  if (!data.flutterPreview && !guideExamples[slug]) return;
  if (!guideExamples[slug] || data.flutterPreview !== slug) {
    throw new Error(`${slug}: unknown or mismatched Flutter guide route`);
  }
  if (content.split(guidePreviewMarker).length !== 2) {
    throw new Error(`${slug}: expected one Flutter guide preview marker`);
  }
  const keys = [...content.matchAll(/\{\{\s*flutter-example\s+([^\s}]+)\s*\}\}/g)].map((match) => match[1]);
  if (keys.length !== 1 || keys[0] !== guideExamples[slug]) {
    throw new Error(`${slug}: preview must use its actual generated example source`);
  }
  const height = data.flutterPreviewHeight ?? 520;
  if (!Number.isInteger(height) || height < 240 || height > 800) {
    throw new Error(`${slug}: invalid Flutter guide preview height`);
  }
}

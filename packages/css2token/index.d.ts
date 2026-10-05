/** Flutter colors use #RRGGBB or #AARRGGBB (CSS eight-digit hex uses RGBA). */
export interface FlutterFont {
  size: number;
  lineHeight: number;
  fontWeight: number;
}
export interface FlutterShadow {
  color: string;
  blurRadius: number;
  spreadRadius: number;
  offset: { x: number; y: number };
}
/** Partial overrides, to be merged into the receiver's Flutter defaults. */
export interface FlutterThemeTokens {
  ref: Record<string, string>;
  color: Record<string, string>;
  font: Record<string, FlutterFont>;
  fontMetric: Record<string, number>;
  radius: Record<string, number>;
  shadow: Record<string, FlutterShadow[]>;
  insetShadow: Record<string, { color: string; width: number }>;
  margin: Record<string, number>;
}
export interface CssThemeParts {
  light: string;
  dark: string;
  extra: string;
}
export interface FlutterTheme {
  light: FlutterThemeTokens;
  dark: FlutterThemeTokens;
}
/** Reads td declarations in source order; does not evaluate the CSS cascade. */
export function parseCssVariables(cssText: string): Map<string, string>;
/** Unsupported colors return null. */
export function normalizeCssColor(
  value: string | null | undefined
): string | null;
/** Without a baseline, converts supplied tokens; with one, emits only differences. */
export function parseCssToFlutterTheme(
  cssText: string,
  baselineCssText?: string | null
): FlutterThemeTokens;
/** extra overrides each mode's declarations. Baseline must be the pristine full CSS. */
export function generateFlutterThemeFromParts(
  lightCss: string,
  darkCss: string,
  extraCss: string,
  baseline?: CssThemeParts | null
): FlutterTheme;
export const flutterThemeContract: Readonly<{
  fontTokens: readonly string[];
  radiusTokens: readonly string[];
  shadowTokens: readonly string[];
  insetShadowTokens: readonly string[];
  spacerTokens: readonly string[];
}>;

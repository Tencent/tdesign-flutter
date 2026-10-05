import {
  generateFlutterThemeFromParts,
  parseCssToFlutterTheme,
  flutterThemeContract,
} from "../index";
import type { CssThemeParts, FlutterThemeTokens } from "../index";
const baseline: CssThemeParts = { light: "", dark: "", extra: "" };
const tokens: FlutterThemeTokens = parseCssToFlutterTheme(
  "--td-radius-small:2px;",
  ""
);
const output = generateFlutterThemeFromParts("", "", "", baseline);
const size: number | undefined = output.dark.font.fontBodyMedium?.size;
const names: readonly string[] = flutterThemeContract.fontTokens;
void [tokens, size, names];

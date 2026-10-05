import assert from "node:assert/strict";
import test from "node:test";
import {
  generateFlutterThemeFromParts,
  normalizeCssColor,
  parseCssToFlutterTheme,
} from "../index.mjs";
import { cases } from "./cases.mjs";

for (const [name, css, check] of cases) {
  test(name, () => {
    const output = generateFlutterThemeFromParts(css, css, "");
    for (const mode of ["light", "dark"])
      assert.ok(
        check(output[mode]),
        `${mode}: ${JSON.stringify(output[mode])}`
      );
  });
}

test("mode separation, shared precedence and baseline restore", () => {
  const baseline = {
    light: "--td-brand-color-7:#123;",
    dark: "--td-brand-color-7:#abc;",
    extra: "--td-radius-small:2px;",
  };
  const unchanged = generateFlutterThemeFromParts(
    baseline.light,
    baseline.dark,
    baseline.extra,
    baseline
  );
  for (const mode of ["light", "dark"])
    for (const group of Object.values(unchanged[mode]))
      assert.deepEqual(group, {});
  const updated = generateFlutterThemeFromParts(
    "--td-brand-color-7:#456;",
    baseline.dark,
    "--td-radius-small:4px;",
    baseline
  );
  assert.deepEqual(updated.light.color, { brandColor7: "#445566" });
  assert.deepEqual(updated.dark.color, {});
  assert.equal(updated.dark.radius.radiusSmall, 4);
  assert.equal(
    generateFlutterThemeFromParts(
      "--td-radius-small:1px;",
      "",
      "--td-radius-small:5px;"
    ).light.radius.radiusSmall,
    5
  );
});

test("baseline follows changes in fallback dependencies", () => {
  const baseline =
    "--td-text-color-primary:var(--td-missing,var(--td-a)); --td-a:#123;";
  assert.equal(
    parseCssToFlutterTheme(baseline.replace("#123", "#456"), baseline).color
      .textColorPrimary,
    "#445566"
  );
});

test("color normalization rejects malformed values and supports percentage channels", () => {
  assert.equal(normalizeCssColor("rgb(100% 0% 0% / 50%)"), "#80FF0000");
  assert.equal(normalizeCssColor("rgba(..., 2, 3, 1)"), null);
  assert.equal(normalizeCssColor("#xyz"), null);
});

test("separate declaration blocks can omit their final semicolon", () => {
  const theme = generateFlutterThemeFromParts(
    "--td-brand-color-7:#123",
    "--td-brand-color-7:#abc",
    "--td-radius-small:2px"
  );
  assert.equal(theme.light.color.brandColor7, "#112233");
  assert.equal(theme.dark.color.brandColor7, "#AABBCC");
  assert.equal(theme.light.radius.radiusSmall, 2);
});

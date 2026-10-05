const COLOR_TOKEN_PREFIXES = [
  "primary",
  "brand",
  "warning",
  "error",
  "success",
  "gray",
];

const SEMANTIC_COLOR_TOKENS = {
  "--td-brand-color": ["brandColor"],
  "--td-brand-color-focus": ["brandColorFocus"],
  "--td-brand-color-active": ["brandColorActive"],
  "--td-brand-color-disabled": ["brandColorDisabled"],
  "--td-brand-color-light": ["brandColorLight"],
  "--td-brand-color-light-hover": ["brandColorLightActive"],
  "--td-brand-color-light-active": ["brandColorLightActive"],
  "--td-warning-color": ["warningColor"],
  "--td-warning-color-focus": ["warningColorFocus"],
  "--td-warning-color-active": ["warningColorActive"],
  "--td-warning-color-disabled": ["warningColorDisabled"],
  "--td-warning-color-light": ["warningColorLight"],
  "--td-warning-color-light-hover": ["warningColorLightActive"],
  "--td-warning-color-light-active": ["warningColorLightActive"],
  "--td-error-color": ["errorColor"],
  "--td-error-color-focus": ["errorColorFocus"],
  "--td-error-color-active": ["errorColorActive"],
  "--td-error-color-disabled": ["errorColorDisabled"],
  "--td-error-color-light": ["errorColorLight"],
  "--td-error-color-light-hover": ["errorColorLightActive"],
  "--td-error-color-light-active": ["errorColorLightActive"],
  "--td-success-color": ["successColor"],
  "--td-success-color-focus": ["successColorFocus"],
  "--td-success-color-active": ["successColorActive"],
  "--td-success-color-disabled": ["successColorDisabled"],
  "--td-success-color-light": ["successColorLight"],
  "--td-success-color-light-hover": ["successColorLightActive"],
  "--td-success-color-light-active": ["successColorLightActive"],
  "--td-bg-color-page": ["bgColorPage"],
  "--td-bg-color-container": ["bgColorContainer"],
  "--td-bg-color-container-active": ["bgColorContainerActive"],
  "--td-bg-color-secondarycontainer": ["bgColorSecondaryContainer"],
  "--td-bg-color-secondarycontainer-active": [
    "bgColorSecondaryContainerActive",
  ],
  "--td-bg-color-component": ["bgColorComponent"],
  "--td-bg-color-component-active": ["bgColorComponentActive"],
  "--td-bg-color-component-disabled": ["bgColorComponentDisabled"],
  "--td-bg-color-secondarycomponent": ["bgColorSecondaryComponent"],
  "--td-bg-color-secondarycomponent-active": [
    "bgColorSecondaryComponentActive",
  ],
  "--td-bg-color-specialcomponent": ["bgColorSpecialComponent"],
  "--td-text-color-primary": ["textColorPrimary"],
  "--td-text-color-secondary": ["textColorSecondary"],
  "--td-text-color-placeholder": ["textColorPlaceholder"],
  "--td-text-color-disabled": ["textColorDisabled"],
  "--td-text-color-brand": ["textColorBrand"],
  "--td-text-color-link": ["textColorLink"],
  "--td-text-color-anti": ["textColorAnti"],
  "--td-mask-active": ["maskActive"],
  "--td-mask-disabled": ["maskDisabled"],
  "--td-component-stroke": ["componentStroke"],
  "--td-component-border": ["componentBorder"],
  "--td-border-level-1-color": ["borderLevel1Color"],
  "--td-border-level-2-color": ["borderLevel2Color"],
};

const FONT_SPECS = [
  ["fontDisplayLarge", "display-large", 0, 64, "display-large", 72, 6],
  ["fontDisplayMedium", "display-medium", 0, 48, "display-medium", 56, 6],
  ["fontHeadlineLarge", "headline-large", 0, 36, "headline-large", 44, 6],
  ["fontHeadlineMedium", "headline-medium", 0, 28, "headline-medium", 36, 6],
  ["fontHeadlineSmall", "headline-small", 0, 24, "headline-small", 32, 6],
  // Mobile CSS has fewer typography levels than Flutter. Keep every Flutter
  // token controllable by deriving the adjacent level from the same slider.
  ["fontTitleExtraLarge", "title-large", 0, 20, "title-extraLarge", 28, 6],
  ["fontTitleLarge", "title-large", -2, 18, "title-large", 26, 6],
  ["fontTitleMedium", "title-medium", 0, 16, "title-medium", 24, 6],
  ["fontTitleSmall", "title-small", 0, 14, "title-small", 22, 4],
  ["fontBodyLarge", "body-large", 0, 16, "body-large", 24, 4],
  ["fontBodyMedium", "body-medium", 0, 14, "body-medium", 22, 4],
  ["fontBodySmall", "body-small", 0, 12, "body-small", 20, 4],
  ["fontBodyExtraSmall", "body-small", -2, 10, "body-extraSmall", 16, 4],
  ["fontMarkLarge", "mark-medium", 2, 16, "mark-large", 24, 6],
  ["fontMarkMedium", "mark-medium", 0, 14, "mark-medium", 22, 6],
  ["fontMarkSmall", "mark-small", 0, 12, "mark-small", 20, 6],
  ["fontMarkExtraSmall", "mark-small", -2, 10, "mark-extraSmall", 16, 6],
  ["fontLinkLarge", "link-large", 0, 16, "link-large", 24, 4],
  ["fontLinkMedium", "link-medium", 0, 14, "link-medium", 22, 4],
  ["fontLinkSmall", "link-small", 0, 12, "link-small", 20, 4],
];

const RADIUS_TOKENS = {
  radiusSmall: "--td-radius-small",
  radiusDefault: "--td-radius-default",
  radiusLarge: "--td-radius-large",
  radiusExtraLarge: "--td-radius-extraLarge",
  radiusRound: "--td-radius-round",
  radiusCircle: "--td-radius-circle",
};

const SHADOW_TOKENS = {
  shadow1: "--td-shadow-1",
  shadow2: "--td-shadow-2",
  shadow3: "--td-shadow-3",
  shadow4: "--td-shadow-4",
};

const SPACER_SOURCES = {
  spacer: ["--td-spacer", "--td-size-4"],
  spacer1: ["--td-spacer-1", "--td-size-5"],
  spacer2: ["--td-spacer-2", "--td-size-6"],
  spacer3: ["--td-spacer-3", "--td-size-8"],
  spacer4: ["--td-spacer-4", "--td-size-10"],
  spacer5: ["--td-spacer-5", "--td-size-13"],
  spacer6: ["--td-spacer-6", "--td-size-15", 1.25],
};

const INSET_SHADOW_TOKENS = {
  shadowInsetTop: "--td-shadow-inset-top",
  shadowInsetRight: "--td-shadow-inset-right",
  shadowInsetBottom: "--td-shadow-inset-bottom",
  shadowInsetLeft: "--td-shadow-inset-left",
};

/** Read td declarations in source order; selectors and cascade are caller-owned. */
export function parseCssVariables(cssText) {
  const variables = new Map();
  const expression = /(--td-[\w-]+)\s*:\s*([^;}]+)(?:;|(?=})|$)/g;
  const source = (cssText || "").replace(/\/\*[\s\S]*?\*\//g, "");
  let match;
  while ((match = expression.exec(source)) !== null) {
    variables.set(match[1], match[2].replace(/\s*!important\s*$/, "").trim());
  }
  return variables;
}

function cssNameToFlutterColor(cssName) {
  const palette = cssName.match(
    /^--td-(primary|brand|warning|error|success|gray)-color-(\d+)$/
  );
  if (palette && COLOR_TOKEN_PREFIXES.includes(palette[1])) {
    return `${palette[1]}Color${palette[2]}`;
  }
  const white = cssName.match(/^--td-font-white-(\d+)$/);
  if (white) return `fontWhite${white[1]}`;
  const gray = cssName.match(/^--td-font-gray-(\d+)$/);
  if (gray) return `fontGray${gray[1]}`;
  return null;
}

function clampChannel(value) {
  return Math.min(255, Math.max(0, Math.round(value)));
}

function hexByte(value) {
  return clampChannel(value).toString(16).padStart(2, "0").toUpperCase();
}

/** Convert supported CSS colors to Flutter hex; unsupported values return null. */
export function normalizeCssColor(value) {
  const input = value?.trim();
  if (!input) return null;
  if (input.toLowerCase() === "transparent") return "#00000000";
  const hex = input.match(/^#([\da-f]+)$/i)?.[1];
  if (hex) {
    if (hex.length === 3)
      return `#${[...hex]
        .map((part) => part + part)
        .join("")
        .toUpperCase()}`;
    if (hex.length === 4) {
      const [r, g, b, a] = [...hex].map((part) => part + part);
      return `#${a}${r}${g}${b}`.toUpperCase();
    }
    if (hex.length === 6) return `#${hex.toUpperCase()}`;
    if (hex.length === 8)
      return `#${hex.slice(6)}${hex.slice(0, 6)}`.toUpperCase();
    return null;
  }
  const rgb = input.match(
    /^rgba?\(\s*((?:\d+(?:\.\d*)?|\.\d+)%?)[,\s]+((?:\d+(?:\.\d*)?|\.\d+)%?)[,\s]+((?:\d+(?:\.\d*)?|\.\d+)%?)(?:\s*[,/]\s*((?:\d+(?:\.\d*)?|\.\d+)%?))?\s*\)$/i
  );
  if (!rgb) return null;
  if (
    rgb
      .slice(1)
      .some(
        (part) =>
          part !== undefined && !Number.isFinite(Number(part.replace("%", "")))
      )
  )
    return null;
  const channel = (part) =>
    Number.parseFloat(part) * (part.endsWith("%") ? 255 / 100 : 1);
  const alphaText = rgb[4] ?? "1";
  const alpha = alphaText.endsWith("%")
    ? (Number.parseFloat(alphaText) * 255) / 100
    : Number.parseFloat(alphaText) * 255;
  return `#${hexByte(alpha)}${hexByte(channel(rgb[1]))}${hexByte(
    channel(rgb[2])
  )}${hexByte(channel(rgb[3]))}`;
}

function referencedVariable(value) {
  return value?.match(/^var\(\s*(--td-[\w-]+)/)?.[1] ?? null;
}

function resolveExpression(value, variables, seen = new Set()) {
  if (!value) return null;
  let result = value;
  while (result.includes("var(")) {
    const start = result.indexOf("var(");
    let depth = 1;
    let end = start + 4;
    for (; end < result.length && depth > 0; end += 1) {
      if (result[end] === "(") depth += 1;
      if (result[end] === ")") depth -= 1;
    }
    if (depth !== 0) return null;
    const parts = splitTopLevel(result.slice(start + 4, end - 1));
    const name = parts.shift().trim();
    if (!/^--td-[\w-]+$/.test(name)) return null;
    const resolved =
      resolveValue(name, variables, new Set(seen)) ??
      resolveExpression(parts.join(",").trim(), variables, new Set(seen));
    if (resolved === null) return null;
    result = result.slice(0, start) + resolved + result.slice(end);
  }
  return result;
}

function resolveValue(name, variables, seen = new Set()) {
  if (!name || seen.has(name)) return null;
  seen.add(name);
  return resolveExpression(variables.get(name), variables, seen);
}

function resolveLeafColorToken(name, variables, seen = new Set()) {
  if (!name || seen.has(name) || !variables.has(name)) return null;
  const flutterName = cssNameToFlutterColor(name);
  if (flutterName) return flutterName;
  const reference = referencedVariable(variables.get(name));
  if (!reference) return null;
  seen.add(name);
  return resolveLeafColorToken(reference, variables, seen);
}

function variableChainChanged(
  name,
  variables,
  baselineVariables,
  seen = new Set()
) {
  if (!baselineVariables || !name || seen.has(name)) return !baselineVariables;
  if (variables.get(name) !== baselineVariables.get(name)) return true;
  const references = [
    ...(variables.get(name) || "").matchAll(/var\(\s*(--td-[\w-]+)/g),
  ];
  seen.add(name);
  return references.some(([, reference]) =>
    variableChainChanged(reference, variables, baselineVariables, new Set(seen))
  );
}

function parseLength(name, variables) {
  const value = resolveValue(name, variables);
  if (!value || value.endsWith("%")) return null;
  const match = value.match(/^(-?(?:\d+(?:\.\d*)?|\.\d+))(?:px)?$/i);
  const length = match ? Number(match[1]) : NaN;
  return Number.isFinite(length) ? length : null;
}

function splitTopLevel(value) {
  const parts = [];
  let depth = 0;
  let start = 0;
  for (let index = 0; index < value.length; index += 1) {
    if (value[index] === "(") depth += 1;
    if (value[index] === ")") depth -= 1;
    if (value[index] === "," && depth === 0) {
      parts.push(value.slice(start, index));
      start = index + 1;
    }
  }
  parts.push(value.slice(start));
  return parts;
}

function parseShadow(value, variables) {
  if (!value || value === "none") return [];
  return splitTopLevel(value).flatMap((part) => {
    const input = part.trim();
    if (input.startsWith("inset")) return [];
    const match = input.match(
      /^(-?(?:\d+(?:\.\d*)?|\.\d+))(?:px)?\s+(-?(?:\d+(?:\.\d*)?|\.\d+))(?:px)?\s+((?:\d+(?:\.\d*)?|\.\d+))(?:px)?(?:\s+(-?(?:\d+(?:\.\d*)?|\.\d+))(?:px)?)?\s+(.+)$/
    );
    if (!match) return [];
    const colorValue = resolveExpression(match[5], variables);
    const color = normalizeCssColor(colorValue);
    if (!color) return [];
    return [
      {
        color,
        blurRadius: Number(match[3]),
        spreadRadius: Number(match[4] ?? 0),
        offset: { x: Number(match[1]), y: Number(match[2]) },
      },
    ];
  });
}

/** Convert supplied tokens, optionally emitting only overrides against a full baseline. */
export function parseCssToFlutterTheme(cssText, baselineCssText = null) {
  const variables = parseCssVariables(cssText);
  const baselineVariables =
    baselineCssText === null ? null : parseCssVariables(baselineCssText);
  const changed = (name) =>
    variableChainChanged(name, variables, baselineVariables);
  const color = {};
  const ref = {};

  variables.forEach((value, cssName) => {
    const flutterName = cssNameToFlutterColor(cssName);
    if (!flutterName || !changed(cssName)) return;
    const normalized = normalizeCssColor(resolveValue(cssName, variables));
    if (normalized) color[flutterName] = normalized;
  });

  Object.entries(SEMANTIC_COLOR_TOKENS).forEach(([cssName, flutterNames]) => {
    if (!variables.has(cssName) || !changed(cssName)) return;
    const leaf = resolveLeafColorToken(cssName, variables);
    const directColor = normalizeCssColor(resolveValue(cssName, variables));
    flutterNames.forEach((flutterName) => {
      if (
        cssName.startsWith("--td-border-level-") &&
        (ref[flutterName] || color[flutterName])
      )
        return;
      if (leaf && directColor) {
        ref[flutterName] = leaf;
      } else if (directColor) {
        color[flutterName] = directColor;
        ref[flutterName] = flutterName;
      }
    });
  });

  const font = {};
  const fontMetric = {};
  FONT_SPECS.forEach(
    ([
      name,
      sizeSuffix,
      sizeOffset,
      defaultSize,
      lineHeightSuffix,
      defaultLineHeight,
      fontWeight,
    ]) => {
      const sizeToken = `--td-font-size-${sizeSuffix}`;
      const lineHeightToken = `--td-line-height-${lineHeightSuffix}`;
      if (!variables.has(sizeToken) && !variables.has(lineHeightToken)) return;
      if (!changed(sizeToken) && !changed(lineHeightToken)) return;
      const sourceSize = parseLength(sizeToken, variables);
      const sourceLineHeight = parseLength(lineHeightToken, variables);
      if (
        (variables.has(sizeToken) && sourceSize === null) ||
        (variables.has(lineHeightToken) && sourceLineHeight === null)
      )
        return;
      const size = sourceSize === null ? defaultSize : sourceSize + sizeOffset;
      const lineHeight = sourceLineHeight ?? defaultLineHeight;
      if (!(size > 0) || !(lineHeight > 0)) return;
      font[name] = { size, lineHeight, fontWeight };
      const suffix = name.slice("font".length);
      fontMetric[`fontSize${suffix}`] = size;
      fontMetric[`lineHeight${suffix}`] = lineHeight;
    }
  );

  const radius = {};
  Object.entries(RADIUS_TOKENS).forEach(([name, cssName]) => {
    if (!changed(cssName)) return;
    const rawValue = resolveValue(cssName, variables);
    const value = parseLength(cssName, variables);
    if (
      name === "radiusCircle" &&
      /^(?:\d+(?:\.\d*)?|\.\d+)%$/.test(rawValue || "")
    ) {
      radius[name] = 9999;
    } else if (value !== null && value >= 0) {
      radius[name] = value;
    }
  });

  const shadow = {};
  Object.entries(SHADOW_TOKENS).forEach(([name, cssName]) => {
    if (!changed(cssName)) return;
    const parsed = parseShadow(resolveValue(cssName, variables), variables);
    if (parsed.length > 0 || resolveValue(cssName, variables) === "none")
      shadow[name] = parsed;
  });

  const insetShadow = {};
  Object.entries(INSET_SHADOW_TOKENS).forEach(([name, cssName]) => {
    if (!changed(cssName)) return;
    const raw = resolveValue(cssName, variables);
    if (raw === "none") {
      insetShadow[name] = { color: "#00000000", width: 0 };
      return;
    }
    const parsed = parseShadow(raw?.replace(/^inset\s+/, ""), variables);
    const edge = parsed[0];
    if (
      parsed.length === 1 &&
      edge.blurRadius === 0 &&
      edge.spreadRadius === 0
    ) {
      insetShadow[name] = {
        color: edge.color,
        width: Math.abs(edge.offset.x || edge.offset.y),
      };
    }
  });

  const margin = {};
  Object.entries(SPACER_SOURCES).forEach(
    ([name, [nativeCss, controllerCss, scale = 1]]) => {
      const explicit = variables.has(nativeCss);
      const cssName = explicit ? nativeCss : controllerCss;
      if (!changed(cssName)) return;
      const value = parseLength(cssName, variables);
      if (value !== null && value >= 0)
        margin[name] = value * (explicit ? 1 : scale);
    }
  );

  return { ref, color, font, fontMetric, radius, shadow, insetShadow, margin };
}

/** Convert independent modes with shared declarations appended to each mode. */
export function generateFlutterThemeFromParts(
  lightCss,
  darkCss,
  extraCss,
  baseline = null
) {
  const sharedCss = extraCss || "";
  const baselineSharedCss = baseline ? baseline.extra || "" : null;
  return {
    light: parseCssToFlutterTheme(
      `${lightCss || ""}\n;\n${sharedCss}`,
      baseline ? `${baseline.light || ""}\n;\n${baselineSharedCss}` : null
    ),
    dark: parseCssToFlutterTheme(
      `${darkCss || ""}\n;\n${sharedCss}`,
      baseline ? `${baseline.dark || ""}\n;\n${baselineSharedCss}` : null
    ),
  };
}

export const flutterThemeContract = Object.freeze({
  fontTokens: Object.freeze(FONT_SPECS.map(([name]) => name)),
  radiusTokens: Object.freeze(Object.keys(RADIUS_TOKENS)),
  shadowTokens: Object.freeze(Object.keys(SHADOW_TOKENS)),
  insetShadowTokens: Object.freeze(Object.keys(INSET_SHADOW_TOKENS)),
  spacerTokens: Object.freeze(Object.keys(SPACER_SOURCES)),
});

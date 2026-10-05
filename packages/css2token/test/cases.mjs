// Shared Node/browser contract cases; no test runner or DOM dependency.
export const cases = [
  [
    "missing tokens preserve defaults",
    "",
    (t) => Object.values(t).every((g) => Object.keys(g).length === 0),
  ],
  [
    "palette and semantic reference",
    "--td-brand-color-7:#123; --td-brand-color:var(--td-brand-color-7);",
    (t) =>
      t.color.brandColor7 === "#112233" && t.ref.brandColor === "brandColor7",
  ],
  [
    "direct semantic color",
    "--td-text-color-primary:#1234;",
    (t) =>
      t.color.textColorPrimary === "#44112233" &&
      t.ref.textColorPrimary === "textColorPrimary",
  ],
  [
    "reference chain",
    "--td-a:var(--td-b); --td-b:#abc; --td-bg-color-page:var(--td-a);",
    (t) => t.color.bgColorPage === "#AABBCC",
  ],
  [
    "nested fallback",
    "--td-brand-color:var(--td-missing,var(--td-other,rgba(1,2,3,.5)));",
    (t) =>
      t.color.brandColor === "#80010203" && t.ref.brandColor === "brandColor",
  ],
  [
    "cycle and missing reference",
    "--td-a:var(--td-b); --td-b:var(--td-a); --td-brand-color:var(--td-a); --td-text-color-primary:var(--td-font-gray-1);",
    (t) => Object.keys(t.ref).length === 0 && Object.keys(t.color).length === 0,
  ],
  [
    "sparse font and derived level",
    "--td-font-size-title-large:22px;",
    (t) =>
      t.font.fontTitleLarge.size === 20 &&
      t.font.fontTitleExtraLarge.size === 22 &&
      Object.keys(t.font).length === 2,
  ],
  [
    "line height and font metric",
    "--td-line-height-body-medium:30px;",
    (t) =>
      t.font.fontBodyMedium.size === 14 &&
      t.fontMetric.lineHeightBodyMedium === 30,
  ],
  [
    "all twenty font levels",
    [
      "display-large",
      "display-medium",
      "headline-large",
      "headline-medium",
      "headline-small",
      "title-large",
      "title-medium",
      "title-small",
      "body-large",
      "body-medium",
      "body-small",
      "mark-medium",
      "mark-small",
      "link-large",
      "link-medium",
      "link-small",
    ]
      .map((n) => `--td-font-size-${n}:20px;`)
      .join(""),
    (t) =>
      Object.keys(t.font).length === 20 &&
      Object.keys(t.fontMetric).length === 40 &&
      t.font.fontMarkLarge.size === 22 &&
      t.font.fontBodyExtraSmall.size === 18,
  ],
  [
    "all radii",
    "--td-radius-small:0; --td-radius-default:2px; --td-radius-large:4px; --td-radius-extraLarge:8px; --td-radius-round:25px; --td-radius-circle:50%;",
    (t) =>
      Object.keys(t.radius).length === 6 &&
      t.radius.radiusRound === 25 &&
      t.radius.radiusCircle === 9999,
  ],
  [
    "four outer shadows",
    Array.from(
      { length: 4 },
      (_, i) =>
        `--td-shadow-${i + 1}:0 2px 4px -1px rgba(0,0,0,.5), 1px 0 2px #123;`
    ).join(""),
    (t) =>
      Object.values(t.shadow).length === 4 &&
      Object.values(t.shadow).every(
        (s) =>
          s.length === 2 &&
          s[0].spreadRadius === -1 &&
          s[0].color === "#80000000"
      ),
  ],
  [
    "four inset shadows",
    ["top", "right", "bottom", "left"]
      .map((e) => `--td-shadow-inset-${e}:inset 0 2px 0 0 #123;`)
      .join(""),
    (t) =>
      Object.values(t.insetShadow).length === 4 &&
      Object.values(t.insetShadow).every((s) => s.width === 2),
  ],
  [
    "clear shadows",
    "--td-shadow-1:none; --td-shadow-inset-top:none;",
    (t) =>
      t.shadow.shadow1.length === 0 && t.insetShadow.shadowInsetTop.width === 0,
  ],
  [
    "seven spacers",
    [4, 5, 6, 8, 10, 13, 15].map((n) => `--td-size-${n}:${n}px;`).join(""),
    (t) => Object.keys(t.margin).length === 7 && t.margin.spacer6 === 18.75,
  ],
  [
    "explicit spacer wins",
    "--td-size-15:80px; --td-spacer-6:7px;",
    (t) => t.margin.spacer6 === 7,
  ],
  [
    "invalid and unsupported values",
    "--td-font-size-body-medium:0px; --td-radius-small:3rem; --td-spacer:..px; --td-brand-color:hsl(0 0% 0%);",
    (t) => Object.values(t).every((g) => Object.keys(g).length === 0),
  ],
  [
    "invalid font and shadow numbers",
    "--td-font-size-body-large:bad; --td-line-height-link-large:3rem; --td-shadow-1:0 2px ..px #123;",
    (t) =>
      Object.keys(t.font).length === 0 && Object.keys(t.shadow).length === 0,
  ],
  [
    "comments, important and last declaration",
    "/* --td-radius-small:99px; */ --td-radius-small:1px; --td-radius-small:3px !important",
    (t) => t.radius.radiusSmall === 3,
  ],
];

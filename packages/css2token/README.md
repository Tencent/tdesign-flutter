# css2token

将 TDesign CSS 自定义属性转换为 TDesign Flutter 主题 JSON 的独立 ESM 库。零运行时依赖，可在浏览器和 Node.js 使用；不依赖 Vue、DOM、Flutter SDK 或主题控制器。

目前 `private: true`，版本 `0.0.0`，仅在仓库内使用，未发布。未来可整体移出本目录；正式发布前需确定包名、版本和兼容的 Flutter Token 契约，再移除 private。没有 CommonJS 入口。

## 使用

```js
import { generateFlutterThemeFromParts, parseCssToFlutterTheme } from './index.mjs';

const tokens = parseCssToFlutterTheme(`:root {
  --td-brand-color-7: #0052d9;
  --td-brand-color: var(--td-brand-color-7);
  --td-font-size-body-medium: 18px;
}`);
// tokens.color.brandColor7 === '#0052D9'
// tokens.ref.brandColor === 'brandColor7'
// tokens.fontMetric.fontSizeBodyMedium === 18

const theme = generateFlutterThemeFromParts(lightCss, darkCss, extraCss);
// { light: { ref, color, font, fontMetric, radius, shadow, insetShadow, margin }, dark: ... }
```

只输出输入中存在且可转换的 Token；未知属性和无效值跳过。接收端把每次结果与自己的默认主题合并，不累加上一轮覆盖值，才能在恢复默认时清除旧覆盖。

控制器默认 CSS 与 Flutter 默认值可能不同。需要保留 Flutter 默认外观时，由调用方提供控制器的**原始完整默认 CSS**：

```js
const baseline = { light: defaultLightCss, dark: defaultDarkCss, extra: defaultExtraCss };
const overrides = generateFlutterThemeFromParts(lightCss, darkCss, extraCss, baseline);
// 未改变的字段输出为空；引用链中依赖的值改变也会输出覆盖。
```

基线只用于比较，不补齐当前输入。light/dark 应各自包含完整声明集合，extra 为共享集合，按最后声明优先合并到每个模式。`parseCssToFlutterTheme(css, baselineCss?)` 可单独处理一个模式。重复调用没有状态。

## 格式与映射

- 颜色支持 `#RGB`、`#RGBA`、`#RRGGBB`、`#RRGGBBAA`、rgb/rgba 数值或百分比、transparent；输出 `#RRGGBB` 或 Flutter 使用的 `#AARRGGBB`。不支持命名色、hsl、color-mix。
- 支持 `var(--td-name)`、嵌套 fallback 及阴影内部的颜色引用；无法解析的引用及无 fallback 的循环不输出。
- 长度支持 px 和无单位数值，不计算 rem、em、calc、视口单位。圆角 circle 百分比映射为 Flutter 的 9999；其他百分比长度不转换。
- 色阶 primary/brand/warning/error/success/gray、font-white/font-gray 映射到同名 Flutter color；语义颜色引用映射到 ref，直接颜色同时输出 color 和自引用。
- 字体输出复合 font 和独立 fontMetric。weight 使用 Flutter 索引（4 = w400，6 = w600）。只有字号或行高时另一维采用当前 Flutter 映射默认值；未出现的层级不输出。
- mobile 字体层级桥接：title-large → TitleExtraLarge 与 TitleLarge（字号 -2）；body-small → BodySmall 与 BodyExtraSmall（-2）；mark-medium → MarkMedium 与 MarkLarge（+2）；mark-small → MarkSmall 与 MarkExtraSmall（-2）。其余支持的层级保持同名映射，列表见 `flutterThemeContract.fontTokens`。
- 六个圆角：small/default/large/extraLarge/round/circle；不生成 Flutter 没有的 radiusMedium。
- shadow-1..4 支持多层外阴影，输出 color、blurRadius、spreadRadius、offset。none 输出空数组；不把 inset 层转换成外阴影。
- shadow-inset-top/right/bottom/left 仅支持单层、零 blur/spread 的边缘阴影，转成 Flutter BorderSide 的 color/width；none 输出透明且 width=0。不能表达的内阴影跳过。
- spacer/spacer-1..6 优先使用显式同名 CSS；否则依次使用 size-4/5/6/8/10/13/15，末项乘 1.25 对齐 Flutter 80 的默认值。组件专属大小或边距不会直接转换成 Flutter 全局 Token。

这不是完整 CSS 引擎：读取声明集合并按源顺序取最后值（忽略注释，移除 important），不计算选择器、媒体查询、优先级或浏览器计算样式。调用方须先分离 light/dark，不能把两种模式的完整样式表作为单模式输入。

控制器选项、存储、样式补齐、默认 CSS 提取和 postMessage 均属于应用适配层。库不读写这些状态，也不发送消息。当前站点适配器位于 `tdesign-site/site/utils/flutterThemeBridge.mjs`。

## 验证

```sh
node --test test/*.test.mjs
# 浏览器契约测试（无需站点）：
python3 -m http.server 19002
# 打开 http://127.0.0.1:19002/test/browser.html，分别检查 Light / Dark。
```

浏览器页面验证转换 JSON；实际 Flutter 布局与颜色应用还需要站点 iframe 集成验收，不能用该页面替代 Flutter 视觉测试。

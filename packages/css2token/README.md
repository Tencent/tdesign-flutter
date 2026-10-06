# css2token

纯 Dart 的 TDesign CSS → Flutter Token 转换库，零运行时依赖，不引用 Flutter、DOM 或主题控制器。目前 `publish_to: none`、版本 0.0.0，未发布；未来可整体移出该目录，确定包名和兼容版本后独立发布到 pub.dev。

## 接入

Flutter 官网 Example 通过 path 依赖使用该库：

```yaml
dependencies:
  css2token:
    path: ../../packages/css2token
```

```dart
import 'package:css2token/css2token.dart';

final theme = cssToFlutterTokens(
  lightCss: '--td-brand-color-7:#123; --td-brand-color:var(--td-brand-color-7);',
  darkCss: '--td-brand-color-7:#abc; --td-brand-color:var(--td-brand-color-7);',
  extraCss: '--td-font-size-body-medium:18px;',
);
final json = theme.toJson(); // {light: {...}, dark: {...}}
```

单模式使用 `parseCssToFlutterTokens(css, baselineCss: baseline)`。输出含 ref、color、font、fontMetric、radius、shadow、insetShadow、margin，均为可 JSON 序列化的数据，不含 Flutter 对象。

保留 Flutter 默认外观时传入控制器原始完整 CSS 基线：

```dart
final theme = cssToFlutterTokens(
  lightCss: currentLight,
  darkCss: currentDark,
  extraCss: currentExtra,
  baseline: CssThemeParts(light: defaultLight, dark: defaultDark, extra: defaultExtra),
);
```

基线只用于比较，不补齐当前输入。每次结果与接收端自己的原始默认主题合并，不能累加上次覆盖，否则恢复默认时会保留旧值。

官网 JS 负责观察、补齐控制器需要的 CSS 和发送 `flutter-css-theme-update`（css、baseline、themeMode）；Example 收到后调用本库，再适配为 TThemeData 并更新界面。核心映射只有 Dart 一份。原生 Dart/Flutter 使用方可以直接调用转换函数，不需要浏览器。

## 转换边界

- 按声明源顺序取最后值，忽略注释并移除 important；不计算选择器、媒体查询或 CSS 优先级。light/dark 必须由调用方分离，共享 extra 声明优先。
- 支持 td 变量引用、嵌套 fallback、循环检测。未知属性、无效值或无法解析的引用跳过，未提供的 Token 不生成默认覆盖。
- 颜色支持 #RGB/#RGBA/#RRGGBB/#RRGGBBAA、rgb/rgba 数值和百分比、transparent。CSS RGBA 转 Flutter ARGB；不支持命名色、hsl、color-mix。
- 长度支持 px 和无单位数值；不计算 rem、em、calc。圆角 circle 百分比映射为 Flutter 的 9999；其他百分比长度不转换。
- 品牌、功能色、primary/gray 色阶与现有语义色映射为 color/ref。直接语义颜色同时输出自引用。
- 字体输出复合 font 与独立 fontMetric。只提供字号或行高时另一维取当前 Flutter 映射默认值；小数字号与行高保留精度，Example 的 Font 适配层负责处理；weight 使用 Flutter 索引（4=w400，6=w600）。mobile title-large 派生 TitleExtraLarge/TitleLarge(-2)，body-small 派生 BodySmall/BodyExtraSmall(-2)，mark-medium 派生 MarkMedium/MarkLarge(+2)，mark-small 派生 MarkSmall/MarkExtraSmall(-2)。其余支持层级按同名映射。
- 圆角支持 small/default/large/extraLarge/round/circle。shadow-1..4 支持多层外阴影与 none 清除；四方向 inset 仅支持单层、零 blur/spread 的边缘阴影，转成 color/width。
- 显式 spacer/spacer-1..6 优先，否则使用 size-4/5/6/8/10/13/15，末项乘1.25。组件专属尺寸不机械扩展为 Flutter 全局 Token。

## 验证

在包目录执行 `dart pub get`、`dart test` 和 `dart analyze --fatal-infos`。
测试样本包括迁移前转换结果以及主题控制器 1.2.6 的真实 CSS。

浏览器验证实际运行 Dart 编译产物（Light/Dark 共 42 项）：

```sh
mkdir -p /tmp/css2token-browser
dart compile js -O1 -o /tmp/css2token-browser/browser_probe.js test/browser_probe.dart
cp test/browser.html /tmp/css2token-browser/
cp test/fixtures/themes.json /tmp/css2token-browser/
python3 -m http.server 19002 --bind 127.0.0.1 --directory /tmp/css2token-browser
```

打开 `http://127.0.0.1:19002/browser.html`。
HTML 中的 JavaScript 仅加载样本与编译产物、切换页面展示模式；转换逻辑来自 Dart。

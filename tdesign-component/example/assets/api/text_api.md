## API

默认值列展示源码声明的默认值；`-` 表示未显式声明。运行时的 Theme / Token 回退见说明，参数是否必填见「必填」列。

### TText
#### 简介
Flutter `Text` 的 TDesign Token 薄封装。
文字布局、字体 fallback、无障碍缩放和语义均由 Flutter 原生 Text 负责。
子树级默认文字样式通过 `TTextThemeData.textStyle` 配置；单实例完整样式通过 `style` 覆盖。
固定容器居中与图文 baseline 应由父布局表达。

#### 声明

```dart
class TText extends StatelessWidget
```


#### 命名构造方法

##### TText.rich

```dart
const TText.rich(
  InlineSpan this.textSpan, {
  this.font,
  this.style,
  this.strutStyle,
  this.textAlign,
  this.textDirection,
  this.locale,
  this.softWrap,
  this.overflow,
  this.textScaler,
  this.maxLines,
  this.semanticsLabel,
  this.semanticsIdentifier,
  this.textWidthBasis,
  this.textHeightBehavior,
  this.selectionColor,
  super.key,
})
```


创建 TDesign 富文本。

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| textSpan | InlineSpan | - | 富文本内容。 | 是 |
| font | Font? | - | TDesign 字体 Token 预设，包含字号、行高和字重；`style` 的显式字段优先。 | 否 |
| style | TextStyle? | - | 当前实例的完整文字样式；仅覆盖显式字段，优先于 `font` 和子树组件 Theme。 | 否 |
| strutStyle | StrutStyle? | - | 透传至 `Text.strutStyle`。 | 否 |
| textAlign | TextAlign? | - | 透传至 `Text.textAlign`。 | 否 |
| textDirection | TextDirection? | - | 透传至 `Text.textDirection`。 | 否 |
| locale | Locale? | - | 透传至 `Text.locale`。 | 否 |
| softWrap | bool? | - | 透传至 `Text.softWrap`。 | 否 |
| overflow | TextOverflow? | - | 透传至 `Text.overflow`。 | 否 |
| textScaler | TextScaler? | - | Flutter 原生文字缩放器；为 null 时继承 MediaQuery。 | 否 |
| maxLines | int? | - | 透传至 `Text.maxLines`。 | 否 |
| semanticsLabel | String? | - | 透传至 `Text.semanticsLabel`。 | 否 |
| semanticsIdentifier | String? | - | 透传至 `Text.semanticsIdentifier`。 | 否 |
| textWidthBasis | TextWidthBasis? | - | 透传至 `Text.textWidthBasis`。 | 否 |
| textHeightBehavior | ui.TextHeightBehavior? | - | 透传至 `Text.textHeightBehavior`。 | 否 |
| selectionColor | Color? | - | 透传至 `Text.selectionColor`。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |

#### 默认构造方法


```dart
const TText(
  String this.data, {
  this.font,
  this.style,
  this.strutStyle,
  this.textAlign,
  this.textDirection,
  this.locale,
  this.softWrap,
  this.overflow,
  this.textScaler,
  this.maxLines,
  this.semanticsLabel,
  this.semanticsIdentifier,
  this.textWidthBasis,
  this.textHeightBehavior,
  this.selectionColor,
  super.key,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| data | String | - | 文本内容。 | 是 |
| font | Font? | - | TDesign 字体 Token 预设，包含字号、行高和字重；`style` 的显式字段优先。 | 否 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 | 否 |
| locale | Locale? | - | 透传至 `Text.locale`。 | 否 |
| maxLines | int? | - | 透传至 `Text.maxLines`。 | 否 |
| overflow | TextOverflow? | - | 透传至 `Text.overflow`。 | 否 |
| selectionColor | Color? | - | 透传至 `Text.selectionColor`。 | 否 |
| semanticsIdentifier | String? | - | 透传至 `Text.semanticsIdentifier`。 | 否 |
| semanticsLabel | String? | - | 透传至 `Text.semanticsLabel`。 | 否 |
| softWrap | bool? | - | 透传至 `Text.softWrap`。 | 否 |
| strutStyle | StrutStyle? | - | 透传至 `Text.strutStyle`。 | 否 |
| style | TextStyle? | - | 当前实例的完整文字样式；仅覆盖显式字段，优先于 `font` 和子树组件 Theme。 | 否 |
| textAlign | TextAlign? | - | 透传至 `Text.textAlign`。 | 否 |
| textDirection | TextDirection? | - | 透传至 `Text.textDirection`。 | 否 |
| textHeightBehavior | ui.TextHeightBehavior? | - | 透传至 `Text.textHeightBehavior`。 | 否 |
| textScaler | TextScaler? | - | Flutter 原生文字缩放器；为 null 时继承 MediaQuery。 | 否 |
| textWidthBasis | TextWidthBasis? | - | 透传至 `Text.textWidthBasis`。 | 否 |

#### 公开属性（字段与访问器）

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| textSpan | InlineSpan? | - | 富文本内容。 |


#### 实例方法

##### TText.getRawText

```dart
Text getRawText({required BuildContext context})
```


获取与当前 TText 配置等价的 Flutter 原生 `Text`。

返回类型：`Text`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 当前构建上下文，用于读取祖先配置。 | 是 |


##### TText.getTextStyle

```dart
TextStyle getTextStyle(BuildContext context)
```


获取最终 Flutter `TextStyle`。

返回类型：`TextStyle`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | 当前构建上下文，用于读取祖先配置。 | 是 |


### TTextSpan
#### 简介
使用原生 `TextStyle` 配置局部样式的 Flutter `TextSpan`。
未显式配置的字段保持为空，并继承父 Span 样式。

#### 声明

```dart
class TTextSpan extends TextSpan
```

#### 默认构造方法


```dart
const TTextSpan({
  String? text,
  List<InlineSpan>? children,
  TextStyle? style,
  GestureRecognizer? recognizer,
  MouseCursor? mouseCursor,
  PointerEnterEventListener? onEnter,
  PointerExitEventListener? onExit,
  String? semanticsLabel,
  String? semanticsIdentifier,
  Locale? locale,
  bool? spellOut,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| children | List&lt;InlineSpan&gt;? | - | 透传至 `TextSpan.children`。 | 否 |
| locale | Locale? | - | 透传至 `TextSpan.locale`。 | 否 |
| mouseCursor | MouseCursor? | - | 透传至 `TextSpan.mouseCursor`。 | 否 |
| onEnter | PointerEnterEventListener? | - | 透传至 `TextSpan.onEnter`。 | 否 |
| onExit | PointerExitEventListener? | - | 透传至 `TextSpan.onExit`。 | 否 |
| recognizer | GestureRecognizer? | - | 透传至 `TextSpan.recognizer`。 | 否 |
| semanticsIdentifier | String? | - | 透传至 `TextSpan.semanticsIdentifier`。 | 否 |
| semanticsLabel | String? | - | 透传至 `TextSpan.semanticsLabel`。 | 否 |
| spellOut | bool? | - | 透传至 `TextSpan.spellOut`。 | 否 |
| style | TextStyle? | - | Span 的唯一文字样式入口；未设置的字段继承父 Span。 | 否 |
| text | String? | - | 透传至 `TextSpan.text`。 | 否 |


### TTextThemeData
#### 简介
TText 子树的组件默认值。
仅在对应实例参数未指定时生效；实例字体预设和段落参数
优先于这里的默认值。外部 Flutter `DefaultTextStyle` 不会自动覆盖 TDesign 文字。

#### 声明

```dart
class TTextThemeData extends ThemeExtension<TTextThemeData>
```

#### 默认构造方法


```dart
const TTextThemeData({
  this.textStyle,
  this.strutStyle,
  this.textWidthBasis,
  this.textHeightBehavior,
})
```

##### 参数

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| strutStyle | StrutStyle? | - | 子树的段落支柱样式默认值；实例 `TText.strutStyle` 优先。 | 否 |
| textHeightBehavior | ui.TextHeightBehavior? | - | 子树的文字高度行为默认值；实例 `TText.textHeightBehavior` 优先。 | 否 |
| textStyle | TextStyle? | - | 子树的完整文字样式；字号、行高和字重也由本字段统一设置。 TText 实例的显式字体参数仍优先于本默认值。 | 否 |
| textWidthBasis | TextWidthBasis? | - | 子树的文字宽度计算默认值；实例 `TText.textWidthBasis` 优先。 | 否 |


#### 实例方法

##### TTextThemeData.copyWith

```dart
TTextThemeData copyWith({
  TextStyle? textStyle,
  StrutStyle? strutStyle,
  TextWidthBasis? textWidthBasis,
  ui.TextHeightBehavior? textHeightBehavior,
})
```


返回主题副本；非空参数替换对应配置，null 参数保留当前配置。

返回类型：`TTextThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| textStyle | TextStyle? | - | 子树的完整文字样式；字号、行高和字重也由本字段统一设置。 TText 实例的显式字体参数仍优先于本默认值。 | 否 |
| strutStyle | StrutStyle? | - | 子树的段落支柱样式默认值；实例 `TText.strutStyle` 优先。 | 否 |
| textWidthBasis | TextWidthBasis? | - | 子树的文字宽度计算默认值；实例 `TText.textWidthBasis` 优先。 | 否 |
| textHeightBehavior | ui.TextHeightBehavior? | - | 子树的文字高度行为默认值；实例 `TText.textHeightBehavior` 优先。 | 否 |


##### TTextThemeData.lerp

```dart
TTextThemeData lerp(ThemeExtension<TTextThemeData>? other, double t)
```


按 t 在当前主题和目标主题之间生成过渡主题。
other 为空或类型不匹配时返回当前主题；字段各自采用其类型的插值规则。

返回类型：`TTextThemeData`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TTextThemeData&gt;? | - | 目标主题；为空或类型不匹配时保留当前主题。 | 是 |
| t | double | - | 插值进度；通常 0 表示当前主题，1 表示目标主题。 | 是 |


### TFontLoader
#### 简介
Flutter 动态字体注册工具。
字体应在构建 Text 前加载完成；组件不会在绘制过程中隐式下载字体。

#### 声明

```dart
class TFontLoader
```


#### 静态方法

##### TFontLoader.load

```dart
static Future<bool> load({
  required String name,
  required String fontFamilyUrl,
})
```


下载并注册字体。
同一 `name` 和 `fontFamilyUrl` 的并发调用共享同一个 Future。加载失败会
清除缓存并允许重试；已经注册或正在注册的字体不能切换 URL。

返回类型：`Future<bool>`

| 参数 | 类型 | 默认值 | 说明 | 必填 |
| --- | --- | --- | --- | --- |
| name | String | - | 注册到 Flutter 字体系统中的字体族名称。 | 是 |
| fontFamilyUrl | String | - | 可直接下载的字体资源 URL。 | 是 |

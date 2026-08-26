## API
### TText

#### 工厂构造方法

##### TText.rich

创建 TDesign 富文本。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| textSpan | InlineSpan | - | 富文本内容。 |
| font | Font? | - | TDesign 字体 Token，包含字号、行高和字重。 |
| fontWeight | FontWeight? | - | 字体粗细。 |
| fontFamily | FontFamily? | - | 字体族及可选资源 package。 |
| textColor | Color? | - | 文字颜色。 |
| isTextThrough | bool? | - | 是否显示删除线。为 null 时继承 Theme 或父级样式。 |
| lineThroughColor | Color? | - | 删除线颜色。 |
| style | TextStyle? | - | Flutter 原生文字样式，具有最高优先级。 |
| strutStyle | StrutStyle? | - | 透传至 `Text.strutStyle`。 |
| textAlign | TextAlign? | - | 透传至 `Text.textAlign`。 |
| textDirection | TextDirection? | - | 透传至 `Text.textDirection`。 |
| locale | Locale? | - | 透传至 `Text.locale`。 |
| softWrap | bool? | - | 透传至 `Text.softWrap`。 |
| overflow | TextOverflow? | - | 透传至 `Text.overflow`。 |
| textScaler | TextScaler? | - | Flutter 原生文字缩放器；为 null 时继承 MediaQuery。 |
| maxLines | int? | - | 透传至 `Text.maxLines`。 |
| semanticsLabel | String? | - | 透传至 `Text.semanticsLabel`。 |
| semanticsIdentifier | String? | - | 透传至 `Text.semanticsIdentifier`。 |
| textWidthBasis | TextWidthBasis? | - | 透传至 `Text.textWidthBasis`。 |
| textHeightBehavior | ui.TextHeightBehavior? | - | 透传至 `Text.textHeightBehavior`。 |
| selectionColor | Color? | - | 透传至 `Text.selectionColor`。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| data | String | - | 文本内容。 |
| font | Font? | - | TDesign 字体 Token，包含字号、行高和字重。 |
| fontFamily | FontFamily? | - | 字体族及可选资源 package。 |
| fontWeight | FontWeight? | - | 字体粗细。 |
| isTextThrough | bool? | - | 是否显示删除线。为 null 时继承 Theme 或父级样式。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| lineThroughColor | Color? | - | 删除线颜色。 |
| locale | Locale? | - | 透传至 `Text.locale`。 |
| maxLines | int? | - | 透传至 `Text.maxLines`。 |
| overflow | TextOverflow? | - | 透传至 `Text.overflow`。 |
| selectionColor | Color? | - | 透传至 `Text.selectionColor`。 |
| semanticsIdentifier | String? | - | 透传至 `Text.semanticsIdentifier`。 |
| semanticsLabel | String? | - | 透传至 `Text.semanticsLabel`。 |
| softWrap | bool? | - | 透传至 `Text.softWrap`。 |
| strutStyle | StrutStyle? | - | 透传至 `Text.strutStyle`。 |
| style | TextStyle? | - | Flutter 原生文字样式，具有最高优先级。 |
| textAlign | TextAlign? | - | 透传至 `Text.textAlign`。 |
| textColor | Color? | - | 文字颜色。 |
| textDirection | TextDirection? | - | 透传至 `Text.textDirection`。 |
| textHeightBehavior | ui.TextHeightBehavior? | - | 透传至 `Text.textHeightBehavior`。 |
| textScaler | TextScaler? | - | Flutter 原生文字缩放器；为 null 时继承 MediaQuery。 |
| textWidthBasis | TextWidthBasis? | - | 透传至 `Text.textWidthBasis`。 |

#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| textSpan | InlineSpan? | - | 富文本内容。 |


### TTextSpan
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | List<InlineSpan>? | - | 透传至 `TextSpan.children`。 |
| font | Font? | - | TDesign 字体 Token，包含字号、行高和字重。 |
| fontFamily | FontFamily? | - | 字体族及可选资源 package。 |
| fontWeight | FontWeight? | - | 字体粗细。 |
| isTextThrough | bool? | - | 是否显示删除线。为 null 时继承父 Span。 |
| lineThroughColor | Color? | - | 删除线颜色。 |
| locale | Locale? | - | 透传至 `TextSpan.locale`。 |
| mouseCursor | MouseCursor? | - | 透传至 `TextSpan.mouseCursor`。 |
| onEnter | PointerEnterEventListener? | - | 透传至 `TextSpan.onEnter`。 |
| onExit | PointerExitEventListener? | - | 透传至 `TextSpan.onExit`。 |
| recognizer | GestureRecognizer? | - | 透传至 `TextSpan.recognizer`。 |
| semanticsIdentifier | String? | - | 透传至 `TextSpan.semanticsIdentifier`。 |
| semanticsLabel | String? | - | 透传至 `TextSpan.semanticsLabel`。 |
| spellOut | bool? | - | 透传至 `TextSpan.spellOut`。 |
| style | TextStyle? | - | Flutter 原生文字样式，具有最高优先级。 |
| text | String? | - | 透传至 `TextSpan.text`。 |
| textColor | Color? | - | 文字颜色。 |


### TTextThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| font | Font? | - | 默认 TDesign 字体 Token。 |
| strutStyle | StrutStyle? | - | 默认段落支柱样式。 |
| textHeightBehavior | ui.TextHeightBehavior? | - | 默认文本高度行为。 |
| textStyle | TextStyle? | - | 默认 Flutter 文字样式。 |
| textWidthBasis | TextWidthBasis? | - | 默认文本宽度计算方式。 |


### TFontLoader

#### 静态方法

##### TFontLoader.load

下载并注册字体。
同一 `name` 和 `fontFamilyUrl` 的并发调用共享同一个 Future。加载失败会
清除缓存并允许重试；已经注册或正在注册的字体不能切换 URL。

返回类型：`Future<bool>`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| name | String | - | - |
| fontFamilyUrl | String | - | - |

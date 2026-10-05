## API
### TText

#### 工厂构造方法

##### TText.rich

创建 TDesign 富文本。

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| textSpan | InlineSpan | - | 富文本内容。 |
| font | Font? | - | TDesign 字体 Token 预设，包含字号、行高和字重；`style` 的显式字段优先。 |
| style | TextStyle? | - | 当前实例的完整文字样式；仅覆盖显式字段，优先于 `font` 和子树组件 Theme。 |
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
| font | Font? | - | TDesign 字体 Token 预设，包含字号、行高和字重；`style` 的显式字段优先。 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| locale | Locale? | - | 透传至 `Text.locale`。 |
| maxLines | int? | - | 透传至 `Text.maxLines`。 |
| overflow | TextOverflow? | - | 透传至 `Text.overflow`。 |
| selectionColor | Color? | - | 透传至 `Text.selectionColor`。 |
| semanticsIdentifier | String? | - | 透传至 `Text.semanticsIdentifier`。 |
| semanticsLabel | String? | - | 透传至 `Text.semanticsLabel`。 |
| softWrap | bool? | - | 透传至 `Text.softWrap`。 |
| strutStyle | StrutStyle? | - | 透传至 `Text.strutStyle`。 |
| style | TextStyle? | - | 当前实例的完整文字样式；仅覆盖显式字段，优先于 `font` 和子树组件 Theme。 |
| textAlign | TextAlign? | - | 透传至 `Text.textAlign`。 |
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
| locale | Locale? | - | 透传至 `TextSpan.locale`。 |
| mouseCursor | MouseCursor? | - | 透传至 `TextSpan.mouseCursor`。 |
| onEnter | PointerEnterEventListener? | - | 透传至 `TextSpan.onEnter`。 |
| onExit | PointerExitEventListener? | - | 透传至 `TextSpan.onExit`。 |
| recognizer | GestureRecognizer? | - | 透传至 `TextSpan.recognizer`。 |
| semanticsIdentifier | String? | - | 透传至 `TextSpan.semanticsIdentifier`。 |
| semanticsLabel | String? | - | 透传至 `TextSpan.semanticsLabel`。 |
| spellOut | bool? | - | 透传至 `TextSpan.spellOut`。 |
| style | TextStyle? | - | Span 的唯一文字样式入口；未设置的字段继承父 Span。 |
| text | String? | - | 透传至 `TextSpan.text`。 |


### TTextThemeData
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| strutStyle | StrutStyle? | - | 子树的段落支柱样式默认值；实例 `TText.strutStyle` 优先。 |
| textHeightBehavior | ui.TextHeightBehavior? | - | 子树的文字高度行为默认值；实例 `TText.textHeightBehavior` 优先。 |
| textStyle | TextStyle? | - | 子树的完整文字样式；字号、行高和字重也由本字段统一设置。 TText 实例的显式字体参数仍优先于本默认值。 |
| textWidthBasis | TextWidthBasis? | - | 子树的文字宽度计算默认值；实例 `TText.textWidthBasis` 优先。 |


### TFontLoader

#### 静态方法

##### TFontLoader.load

下载并注册字体。
同一 `name` 和 `fontFamilyUrl` 的并发调用共享同一个 Future。加载失败会
清除缓存并允许重试；已经注册或正在注册的字体不能切换 URL。

返回类型：`Future<bool>`

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| name | String | - | 注册到 Flutter 的字体族名称。 |
| fontFamilyUrl | String | - | 可下载的字体资源 URL；同名字体不能切换 URL。 |

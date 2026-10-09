## API

### TText

#### 构造方法

##### TText

位置参数：`data`


| 名称 | 类型 | 默认值 | 说明 | 必传 |
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


##### TText.rich

位置参数：`textSpan`


创建 TDesign 富文本。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
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


#### 属性

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| textSpan | InlineSpan? | - | 富文本内容。 | - |


#### 实例方法

##### TText.getRawText

获取与当前 TText 配置等价的 Flutter 原生 `Text`。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | - | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Text | - | - | - |


##### TText.getTextStyle

位置参数：`context`


获取最终 Flutter `TextStyle`。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| context | BuildContext | - | - | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TextStyle | - | - | - |


### TTextSpan

#### 构造方法

##### TTextSpan

| 名称 | 类型 | 默认值 | 说明 | 必传 |
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

#### 构造方法

##### TTextThemeData

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| strutStyle | StrutStyle? | - | 子树的段落支柱样式默认值；实例 `TText.strutStyle` 优先。 | 否 |
| textHeightBehavior | ui.TextHeightBehavior? | - | 子树的文字高度行为默认值；实例 `TText.textHeightBehavior` 优先。 | 否 |
| textStyle | TextStyle? | - | 子树的完整文字样式；字号、行高和字重也由本字段统一设置。 TText 实例的显式字体参数仍优先于本默认值。 | 否 |
| textWidthBasis | TextWidthBasis? | - | 子树的文字宽度计算默认值；实例 `TText.textWidthBasis` 优先。 | 否 |


#### 实例方法

##### TTextThemeData.copyWith

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| textStyle | TextStyle? | - | 字段含义：子树的完整文字样式；字号、行高和字重也由本字段统一设置。 TText 实例的显式字体参数仍优先于本默认值。 调用时的空值行为见方法说明。 | 否 |
| strutStyle | StrutStyle? | - | 字段含义：子树的段落支柱样式默认值；实例 `TText.strutStyle` 优先。 调用时的空值行为见方法说明。 | 否 |
| textWidthBasis | TextWidthBasis? | - | 字段含义：子树的文字宽度计算默认值；实例 `TText.textWidthBasis` 优先。 调用时的空值行为见方法说明。 | 否 |
| textHeightBehavior | ui.TextHeightBehavior? | - | 字段含义：子树的文字高度行为默认值；实例 `TText.textHeightBehavior` 优先。 调用时的空值行为见方法说明。 | 否 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TTextThemeData | - | - | - |


##### TTextThemeData.lerp

位置参数：`other, t`


| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| other | ThemeExtension&lt;TTextThemeData&gt;? | - | - | 是 |
| t | double | - | - | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | TTextThemeData | - | - | - |


### TFontLoader

#### 静态方法

##### TFontLoader.load

下载并注册字体。

同一 `name` 和 `fontFamilyUrl` 的并发调用共享同一个 Future。加载失败会
清除缓存并允许重试；已经注册或正在注册的字体不能切换 URL。

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| name | String | - | 注册到 Flutter 字体系统中的字体族名称。 | 是 |
| fontFamilyUrl | String | - | 可直接下载的字体资源 URL。 | 是 |


###### 返回值

| 名称 | 类型 | 默认值 | 说明 | 必传 |
| --- | --- | --- | --- | --- |
| 返回值 | Future&lt;bool&gt; | - | - | - |

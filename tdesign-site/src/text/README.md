---
title: Text 文本
description: 
spline: base
isComponent: true
---

<span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20lines-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20functions-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20statements-100%25-blue" /></span><span class="coverages-badge" style="margin-right: 10px"><img src="https://img.shields.io/badge/coverages%3A%20branches-83%25-blue" /></span>
## 引入

在tdesign_flutter/tdesign_flutter.dart中有所有组件的路径。

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

[td_text_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_text_page.dart)

### 1 使用示例

系统Text:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSystemText(BuildContext context) {
    return Text(
      exampleTxt,
    );
  }</pre>

</td-code-block>
                                  

普通TText:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildNormalTText(BuildContext context) {
    return TText(
      exampleTxt,
    );
  }</pre>

</td-code-block>
                                  

指定常用属性:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildGeneralProp(BuildContext context) {
    return TText(
      exampleTxt,
      font: TTheme.of(context).fontHeadlineLarge,
      textColor: TTheme.of(context).brandNormalColor,
      backgroundColor: TTheme.of(context).brandFocusColor,
    );
  }</pre>

</td-code-block>
                                  

style覆盖textColor,不覆盖font:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildStyleCoverColor(BuildContext context) {
    return TText(
      exampleTxt,
      font: TTheme.of(context).fontBodyLarge,
      textColor: TTheme.of(context).brandNormalColor,
      style: TextStyle(color: TTheme.of(context).errorNormalColor),
    );
  }</pre>

</td-code-block>
                                  

style覆盖textColor和font:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildStyleCoverColorAndFont(BuildContext context) {
    return TText(
      exampleTxt,
      font: TTheme.of(context).fontBodyLarge,
      textColor: TTheme.of(context).brandNormalColor,
    );
  }</pre>

</td-code-block>
                                  

TText.rich测试:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildRichText(BuildContext context) {
    return TText.rich(
      TextSpan(children: [
        TTextSpan(
            text: 'TTextSpan1',
            font: TTheme.of(context).fontTitleExtraLarge,
            textColor: TTheme.of(context).warningNormalColor,
            isTextThrough: true,
            lineThroughColor: TTheme.of(context).brandNormalColor,
            style: TextStyle(color: TTheme.of(context).errorNormalColor)),
        TextSpan(
            text: 'TextSpan2',
            style: TextStyle(
                fontSize: 14, color: TTheme.of(context).brandNormalColor)),
        const WidgetSpan(
            child: Icon(
          TIcons.setting,
          size: 24,
        )),
      ]),
      font: TTheme.of(context).fontBodyLarge,
      textColor: TTheme.of(context).brandNormalColor,
      style:
          TextStyle(color: TTheme.of(context).errorNormalColor, fontSize: 32),
    );
  }</pre>

</td-code-block>
                                  

获取系统Text:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _getSystemText(BuildContext context) {
    return TText(
      exampleTxt,
      backgroundColor: TTheme.of(context).brandFocusColor,
    ).getRawText(context: context);
  }</pre>

</td-code-block>
                                  

中文居中:（带有英文可能不居中）
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVerticalCenterText(BuildContext context) {
    return TText(
      '中华人民共和国腾讯科技',
      // font: Font(size: 100, lineHeight: 100),
      forceVerticalCenter: true,
      backgroundColor: TTheme.of(context).brandFocusColor,
    );
  }</pre>

</td-code-block>
                                  

自定义内部padding:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCustomPaddingText(BuildContext context) {
    return TTextConfiguration(
      paddingConfig: CustomTextPaddingConfig(),
      child: const CustomPaddingText(),
    );
  }</pre>

</td-code-block>
                                  

删除线:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTextThrough(BuildContext context) {
    return TText(exampleTxt, isTextThrough: true);
  }</pre>

</td-code-block>
                                  


## API
### TText
#### 简介
文本控件
设计原则：
1. 为了使用更方便，所以对系统组件进行的扩展，需兼容系统控件所有功能，不能让用户使用 TDesign 时，因不能满足系统功能而弃用。
2. 非系统已有属性，尽量添加注释
需求：把一部分在 TextStyle 中的属性扁平化，放到外层。
1. 暴露系统的所有属性，支持系统所有操作
2. 约束使用主题配置的几种字体
3. 提供转换为系统 Text 的方法，以使某些系统组件指定接收系统 Text 时可使用。（Image 组件同理）
4. 支持自定义 TextStyle
5. 兼容 TextSpan 形式
技巧：
命名参数替换属性的正则：
第一步，把 Text 中的可选参数拷贝过来，变成如下格式：
Text(data,
this.style,
this.strutStyle,
……)
第二步，正则替换如下：
匹配(前半有默认值，后半无默认值)：this\.(`a-z|A-Z`+)[]*`\=`+[]*`a-z|A-Z`+\,|this\.(`a-z|A-Z`+)\,
替换：$1$2: this.$1$2,

#### 工厂构造方法

##### TText.rich

富文本构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| textSpan | InlineSpan? | - | - |
| font | Font? | - | 字体尺寸，包含 大小size 和 行高height |
| fontWeight | FontWeight? | - | 字体粗细 |
| fontFamily | FontFamily? | - | 字体ttf |
| textColor | Color? | - | 文本颜色 |
| backgroundColor | Color? | - | 背景颜色 |
| isTextThrough | bool? | false | 是否是横线穿过样式（删除线） |
| lineThroughColor | Color? | - | 删除线颜色，对应 TestStyle 的 decorationColor |
| package | String? | - | 字体包名 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| style | TextStyle? | - | 自定义的 TextStyle，其中指定的属性，将覆盖扩展的外层属性 |
| strutStyle | StrutStyle? | - | - |
| textAlign | TextAlign? | - | - |
| textDirection | TextDirection? | - | - |
| locale | Locale? | - | - |
| softWrap | bool? | - | - |
| overflow | TextOverflow? | - | - |
| textScaleFactor | double? | - | - |
| maxLines | int? | - | - |
| semanticsLabel | String? | - | - |
| textWidthBasis | TextWidthBasis? | - | - |
| textHeightBehavior | ui.TextHeightBehavior? | - | - |
| forceVerticalCenter | bool | false | 是否强制居中 |
| isInFontLoader | bool | false | 是否在 FontLoader 中使用 |
| fontFamilyUrl | String? | - | 是否禁用懒加载 FontFamily 的能力 |

#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| data | - | - | 以下系统 text 属性，释义请参考系统 `Text` 中注释 |
| backgroundColor | Color? | - | 背景颜色 |
| font | Font? | - | 字体尺寸，包含 大小size 和 行高height |
| fontFamily | FontFamily? | - | 字体ttf |
| fontFamilyUrl | String? | - | 是否禁用懒加载 FontFamily 的能力 |
| fontWeight | FontWeight? | - | 字体粗细 |
| forceVerticalCenter | bool | false | 是否强制居中 |
| isInFontLoader | bool | false | 是否在 FontLoader 中使用 |
| isTextThrough | bool? | false | 是否是横线穿过样式（删除线） |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| lineThroughColor | Color? | - | 删除线颜色，对应 TestStyle 的 decorationColor |
| locale | Locale? | - | - |
| maxLines | int? | - | - |
| overflow | TextOverflow? | - | - |
| package | String? | - | 字体包名 |
| semanticsLabel | String? | - | - |
| softWrap | bool? | - | - |
| strutStyle | StrutStyle? | - | - |
| style | TextStyle? | - | 自定义的 TextStyle，其中指定的属性，将覆盖扩展的外层属性 |
| textAlign | TextAlign? | - | - |
| textColor | Color? | - | 文本颜色 |
| textDirection | TextDirection? | - | - |
| textHeightBehavior | ui.TextHeightBehavior? | - | - |
| textScaleFactor | double? | - | - |
| textWidthBasis | TextWidthBasis? | - | - |

#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| textSpan | InlineSpan? | - | - |


### TTextSpan
#### 简介
TextSpan 的 TDesign 扩展，将部分 TextStyle 中的参数扁平化。
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children | List<InlineSpan>? | - | - |
| context | BuildContext? | - | - |
| font | Font? | - | - |
| fontFamily | FontFamily? | - | - |
| fontWeight | FontWeight? | - | - |
| isTextThrough | bool? | false | - |
| lineThroughColor | Color? | - | - |
| mouseCursor | MouseCursor? | - | - |
| onEnter | PointerEnterEventListener? | - | - |
| onExit | PointerExitEventListener? | - | - |
| package | String? | - | - |
| recognizer | GestureRecognizer? | - | - |
| semanticsLabel | String? | - | - |
| style | TextStyle? | - | - |
| text | String? | - | - |
| textColor | Color? | - | - |


### TTextConfiguration
#### 简介
存储可以自定义 TText 居中算法数据的内部控件
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget | - | - |
| globalFontFamily | FontFamily? | - | 全局字体，kTextNeedGlobalFontFamily=true 时生效 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| paddingConfig | TTextPaddingConfig? | - | forceVerticalCenter=true 时，内置 padding 配置 |


  
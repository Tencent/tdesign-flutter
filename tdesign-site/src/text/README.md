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
                                  

普通TDText:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildNormalTDText(BuildContext context) {
    return TDText(
      exampleTxt,
    );
  }</pre>

</td-code-block>
                                  

指定常用属性:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildGeneralProp(BuildContext context) {
    return TDText(
      exampleTxt,
      font: TDTheme.of(context).fontHeadlineLarge,
      textColor: TDTheme.of(context).brandNormalColor,
      backgroundColor: TDTheme.of(context).brandFocusColor,
    );
  }</pre>

</td-code-block>
                                  

style覆盖textColor,不覆盖font:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildStyleCoverColor(BuildContext context) {
    return TDText(
      exampleTxt,
      font: TDTheme.of(context).fontBodyLarge,
      textColor: TDTheme.of(context).brandNormalColor,
      style: TextStyle(color: TDTheme.of(context).errorNormalColor),
    );
  }</pre>

</td-code-block>
                                  

style覆盖textColor和font:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildStyleCoverColorAndFont(BuildContext context) {
    return TDText(
      exampleTxt,
      font: TDTheme.of(context).fontBodyLarge,
      textColor: TDTheme.of(context).brandNormalColor,
    );
  }</pre>

</td-code-block>
                                  

TDText.rich测试:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildRichText(BuildContext context) {
    return TDText.rich(
      TextSpan(children: [
        TDTextSpan(
            text: 'TDTextSpan1',
            font: TDTheme.of(context).fontTitleExtraLarge,
            textColor: TDTheme.of(context).warningNormalColor,
            isTextThrough: true,
            lineThroughColor: TDTheme.of(context).brandNormalColor,
            style: TextStyle(color: TDTheme.of(context).errorNormalColor)),
        TextSpan(
            text: 'TextSpan2',
            style: TextStyle(
                fontSize: 14, color: TDTheme.of(context).brandNormalColor)),
        const WidgetSpan(
            child: Icon(
          TDIcons.setting,
          size: 24,
        )),
      ]),
      font: TDTheme.of(context).fontBodyLarge,
      textColor: TDTheme.of(context).brandNormalColor,
      style:
          TextStyle(color: TDTheme.of(context).errorNormalColor, fontSize: 32),
    );
  }</pre>

</td-code-block>
                                  

获取系统Text:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _getSystemText(BuildContext context) {
    return TDText(
      exampleTxt,
      backgroundColor: TDTheme.of(context).brandFocusColor,
    ).getRawText(context: context);
  }</pre>

</td-code-block>
                                  

中文居中:（带有英文可能不居中）
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildVerticalCenterText(BuildContext context) {
    return TDText(
      '中华人民共和国腾讯科技',
      // font: Font(size: 100, lineHeight: 100),
      forceVerticalCenter: true,
      backgroundColor: TDTheme.of(context).brandFocusColor,
    );
  }</pre>

</td-code-block>
                                  

自定义内部padding:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCustomPaddingText(BuildContext context) {
    return TDTextConfiguration(
      paddingConfig: CustomTextPaddingConfig(),
      child: const CustomPaddingText(),
    );
  }</pre>

</td-code-block>
                                  

删除线:
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTextThrough(BuildContext context) {
    return TDText(exampleTxt, isTextThrough: true);
  }</pre>

</td-code-block>
                                  


## API
### TDText
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| data | null | data | 以下系统 text 属性，释义请参考系统 [Text] 中注释 |
| font | Font? | - | 字体尺寸，包含 大小size 和 行高height |
| fontFamily | FontFamily? | - | 字体ttf |
| fontFamilyUrl | String? | - | 是否禁用懒加载 FontFamily 的能力 |
| fontWeight | FontWeight? | - | 字体粗细 |
| forceVerticalCenter | bool | false | 是否强制居中 |
| isInFontLoader | bool | false | 是否在 FontLoader 中使用 |
| isTextThrough | bool? | false | 是否是横线穿过样式（删除线） |
| key |  | - |  |
| lineThroughColor | Color? | - | 删除线颜色，对应 TestStyle 的 decorationColor |
| locale |  | - |  |
| maxLines |  | - |  |
| overflow |  | - |  |
| package | String? | - | 字体包名 |
| semanticsLabel |  | - |  |
| softWrap |  | - |  |
| strutStyle |  | - |  |
| style | TextStyle? | - | 自定义的 TextStyle，其中指定的属性，将覆盖扩展的外层属性 |
| textAlign |  | - |  |
| textColor | Color? | - | 文本颜色 |
| textDirection |  | - |  |
| textHeightBehavior |  | - |  |
| textScaleFactor |  | - |  |
| textWidthBasis |  | - |  |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TDText.rich  | 富文本构造方法 |

```
```
 ### TDTextSpan
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| children |  | - |  |
| context |  | - |  |
| font |  | - |  |
| fontFamily |  | - |  |
| fontWeight |  | - |  |
| isTextThrough |  | false |  |
| lineThroughColor |  | - |  |
| mouseCursor |  | - |  |
| onEnter |  | - |  |
| onExit |  | - |  |
| package |  | - |  |
| recognizer |  | - |  |
| semanticsLabel |  | - |  |
| style |  | - |  |
| text |  | - |  |
| textColor |  | - |  |

```
```
 ### TDTextConfiguration
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child |  | - |  |
| globalFontFamily | FontFamily? | - | 全局字体，kTextNeedGlobalFontFamily=true 时生效 |
| key |  | - |  |
| paddingConfig | TDTextPaddingConfig? | - | forceVerticalCenter=true 时，内置 padding 配置 |


  
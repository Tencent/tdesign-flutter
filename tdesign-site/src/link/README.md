---
title: Link 链接
description: 文字超链接用于跳转一个新页面，如当前项目跳转，友情链接等。
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

[td_link_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_link_page.dart)

### 1 组件类型

基础文字链接
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _basicTypeBasic(BuildContext context) {
    return Container(
        height: 48,
        color: TTheme.of(context).bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildLinksWithType(TLinkType.basic),
        ));
  }</pre>

</td-code-block>
                                  

下划线文字链接
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _withUnderline(BuildContext context) {
    return Container(
        height: 48,
        color: TTheme.of(context).bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildLinksWithType(TLinkType.withUnderline),
        ));
  }</pre>

</td-code-block>
                                  

前置图标文字链接
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _withPrefixIcon(BuildContext context) {
    return Container(
        height: 48,
        color: TTheme.of(context).bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildLinksWithType(TLinkType.withPrefixIcon),
        ));
  }</pre>

</td-code-block>
                                  

后置图标文字链接
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _withSuffixIcon(BuildContext context) {
    return Container(
        height: 48,
        color: TTheme.of(context).bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildLinksWithType(TLinkType.withSuffixIcon),
        ));
  }</pre>

</td-code-block>
                                  
### 1 组件状态

不同主题
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLinkStats(BuildContext context) {
    return _buildLinkWithStyles(TLinkState.normal);
  }</pre>

</td-code-block>
                                  

禁用状态
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildDisabledLinkStats(BuildContext context) {
    return _buildLinkWithStyles(TLinkState.disabled);
  }</pre>

</td-code-block>
                                  
### 1 组件样式

链接尺寸
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLinkSizes(BuildContext context) {
    return Container(
        height: 48,
        color: TTheme.of(context).bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildLinkWithSizeAndStyle(TLinkStyle.primary, TLinkSize.small),
            _buildLinkWithSizeAndStyle(TLinkStyle.primary, TLinkSize.medium),
            _buildLinkWithSizeAndStyle(TLinkStyle.primary, TLinkSize.large),
          ],
        ));
  }</pre>

</td-code-block>
                                  


## API
### TLink
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| color | Color? | - | link 文本的颜色，如果不设置则根据状态和风格进行计算 |
| fontSize | double? | - | link 文本的字体大小，如果不设置则根据状态和风格进行计算 |
| iconSize | double? | - | link icon 大小，如果不设置则根据状态和风格进行计算 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| label | String | - | link 展示的文本 |
| leftGapWithIcon | double? | - | 前置icon和文本之间的间隔，如果不设置则根据状态和风格进行计算 |
| linkClick | LinkClick? | - | link 被点击之后所采取的动作，会将uri当做参数传入到该方法当中 |
| prefixIcon | Icon? | - | 前置 icon |
| rightGapWithIcon | double? | - | 后置icon和文本之间的间隔，如果不设置则根据状态和风格进行计算 |
| size | TLinkSize | TLinkSize.medium | link 大小 |
| state | TLinkState | TLinkState.normal | link 状态 |
| style | TLinkStyle | TLinkStyle.defaultStyle | link 风格 |
| suffixIcon | Icon? | - | 后置 icon |
| type | TLinkType | TLinkType.basic | link 类型 |
| uri | Uri? | - | link 跳转的uri |


### TLinkType
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| basic | - |
| withUnderline | - |
| withPrefixIcon | - |
| withSuffixIcon | - |


### TLinkStyle
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| primary | - |
| defaultStyle | - |
| danger | - |
| warning | - |
| success | - |


### TLinkState
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| normal | - |
| active | - |
| disabled | - |


### TLinkSize
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| small | - |
| medium | - |
| large | - |


### LinkClick
#### 类型定义

```dart
typedef LinkClick =  Function(Uri? uri);
```


  
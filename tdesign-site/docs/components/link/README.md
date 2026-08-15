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
  Widget _buildBasicLinks(BuildContext context) {
    return Container(
        color: context.tTheme.bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildLinksWithVariant(TLinkVariant.basic),
        ));
  }</pre>

</td-code-block>
                                  

下划线文字链接
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildUnderlineLinks(BuildContext context) {
    return Container(
        color: context.tTheme.bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildLinksWithVariant(TLinkVariant.underline),
        ));
  }</pre>

</td-code-block>
                                  

前置图标文字链接
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPrefixLinks(BuildContext context) {
    return Container(
        color: context.tTheme.bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildLinksWithVariant(
            TLinkVariant.icon,
            prefixIconBuilder: _linkIcon,
          ),
        ));
  }</pre>

</td-code-block>
                                  

后置图标文字链接
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSuffixLinks(BuildContext context) {
    return Container(
        color: context.tTheme.bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildLinksWithVariant(
            TLinkVariant.icon,
            suffixIconBuilder: _jumpIcon,
          ),
        ));
  }</pre>

</td-code-block>
                                  
### 2 组件状态

不同主题
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildColorSchemeLinks(BuildContext context) {
    return Column(
      children: [
        Container(
          color: context.tTheme.bgColorContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLink(TLinkColorScheme.primary, TLinkVariant.icon,
                  suffixIconBuilder: _jumpIcon),
              _buildLink(TLinkColorScheme.defaultTheme, TLinkVariant.icon,
                  suffixIconBuilder: _jumpIcon),
              _buildLink(TLinkColorScheme.danger, TLinkVariant.icon,
                  suffixIconBuilder: _jumpIcon),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          color: context.tTheme.bgColorContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLink(TLinkColorScheme.warning, TLinkVariant.icon,
                  suffixIconBuilder: _jumpIcon),
              _buildLink(TLinkColorScheme.success, TLinkVariant.icon,
                  suffixIconBuilder: _jumpIcon),
            ],
          ),
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  

禁用状态
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildDisabledLinks(BuildContext context) {
    return Column(
      children: [
        Container(
          color: context.tTheme.bgColorContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLink(TLinkColorScheme.primary, TLinkVariant.icon,
                  suffixIconBuilder: _jumpIcon, disabled: true),
              _buildLink(TLinkColorScheme.defaultTheme, TLinkVariant.icon,
                  suffixIconBuilder: _jumpIcon, disabled: true),
              _buildLink(TLinkColorScheme.danger, TLinkVariant.icon,
                  suffixIconBuilder: _jumpIcon, disabled: true),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          color: context.tTheme.bgColorContainer,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLink(TLinkColorScheme.warning, TLinkVariant.icon,
                  suffixIconBuilder: _jumpIcon, disabled: true),
              _buildLink(TLinkColorScheme.success, TLinkVariant.icon,
                  suffixIconBuilder: _jumpIcon, disabled: true),
            ],
          ),
        ),
      ],
    );
  }</pre>

</td-code-block>
                                  
### 3 组件样式

链接尺寸
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLinkSizes(BuildContext context) {
    return Container(
        color: context.tTheme.bgColorContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSizeLink(TLinkSize.small),
            _buildSizeLink(TLinkSize.medium),
            _buildSizeLink(TLinkSize.large),
          ],
        ));
  }</pre>

</td-code-block>
                                  


## API
### TLink
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| child | Widget? | - | 链接内容，一般是 `Text` |
| colorScheme | TLinkColorScheme? | - | 语义颜色方案 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onPressed | VoidCallback? | - | 点击回调。为 null 时链接为禁用态 |
| prefixIcon | Widget? | - | 前置图标（仅在 `variant` 为 `TLinkVariant.icon` 时生效） |
| semanticLabel | String? | - | 语义标签（无障碍） |
| size | TLinkSize? | - | 尺寸；未传时读取 `TLinkThemeData.defaultSize`，再回退 medium。 |
| suffixIcon | Widget? | - | 后置图标（仅在 `variant` 为 `TLinkVariant.icon` 时生效） |
| tooltip | String? | - | 悬浮提示 |
| variant | TLinkVariant? | - | 链接形态；未传时读取 `TLinkThemeData.defaultVariant`，再回退 basic。 |


### TLinkVariant
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| basic | 纯文本链接 |
| underline | 下划线链接 |
| icon | 带图标链接（通过 prefixIcon / suffixIcon 区分前后） |


### TLinkColorScheme
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| primary | 品牌主色链接 |
| defaultTheme | 默认文本色链接 |
| danger | 危险操作链接 |
| warning | 警告提示链接 |
| success | 成功状态链接 |


### TLinkSize
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| small | 小尺寸链接 |
| medium | 中尺寸链接 |
| large | 大尺寸链接 |

---
title: Tag 标签
description: 用于表明主体的类目，属性或状态
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

[td_tag_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_tag_page.dart)

### 1 组件类型

基础标签

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TTag _buildSimpleFillTag(BuildContext context) {
    return const TTag('标签文字');
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TTag _buildSimpleOutlineTag(BuildContext context) {
    return const TTag(
      '标签文字',
      isOutline: true,
    );
  }</pre>

</td-code-block>
                

圆弧标签

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCircleFillTag(BuildContext context) {
    return const TTag(
      '标签文字',
      shape: TTagShape.round,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCircleOutlineTag(BuildContext context) {
    return const TTag(
      '标签文字',
      shape: TTagShape.round,
      isOutline: true,
    );
  }</pre>

</td-code-block>
                

Mark标签

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildMarkFillTag(BuildContext context) {
    return const TTag(
      '标签文字',
      shape: TTagShape.mark,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildMarkOutlineTag(BuildContext context) {
    return const TTag(
      '标签文字',
      shape: TTagShape.mark,
      isOutline: true,
    );
  }</pre>

</td-code-block>
                

带图标的标签

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildIconFillTag(BuildContext context) {
    return const TTag(
      '标签文字',
      icon: TIcons.discount,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildIconOutlineTag(BuildContext context) {
    return const TTag(
      '标签文字',
      icon: TIcons.discount,
      isOutline: true,
    );
  }</pre>

</td-code-block>
                

可关闭的标签

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCloseFillTag(BuildContext context) {
    return TTag(
      '标签文字',
      needCloseIcon: true,
      onCloseTap: () {
        TToast.showText('点击关闭', context: context);
      },
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCloseOutlineTag(BuildContext context) {
    return TTag('标签文字', needCloseIcon: true, isOutline: true, onCloseTap: () {
      TToast.showText('点击关闭', context: context);
    });
  }</pre>

</td-code-block>
                

可选中的标签

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildDarkSelectTags(BuildContext context) {
    return const Wrap(spacing: 8, children: [
      TSelectTag(
        '未选中态',
        theme: TTagTheme.primary,
      ),
      TSelectTag(
        '已选中态',
        theme: TTagTheme.primary,
        isSelected: true,
      ),
      TSelectTag(
        '不可选态',
        theme: TTagTheme.primary,
        disableSelect: true,
      ),
    ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLightSelectTags(BuildContext context) {
    return const Wrap(spacing: 8, children: [
      TSelectTag(
        '未选中态',
        theme: TTagTheme.primary,
        isLight: true,
      ),
      TSelectTag(
        '已选中态',
        theme: TTagTheme.primary,
        isLight: true,
        isSelected: true,
      ),
      TSelectTag(
        '不可选态',
        theme: TTagTheme.primary,
        isLight: true,
        disableSelect: true,
      ),
    ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildOutlineSelectTags(BuildContext context) {
    return const Wrap(spacing: 8, children: [
      TSelectTag(
        '未选中态',
        theme: TTagTheme.primary,
        isOutline: true,
      ),
      TSelectTag(
        '已选中态',
        theme: TTagTheme.primary,
        isOutline: true,
        isSelected: true,
      ),
      TSelectTag(
        '不可选态',
        theme: TTagTheme.primary,
        isOutline: true,
        disableSelect: true,
      ),
    ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLightOutlineSelectTags(BuildContext context) {
    return const Wrap(spacing: 8, children: [
      TSelectTag(
        '未选中态',
        theme: TTagTheme.primary,
        isOutline: true,
        isLight: true,
      ),
      TSelectTag(
        '已选中态',
        theme: TTagTheme.primary,
        isOutline: true,
        isLight: true,
        isSelected: true,
      ),
      TSelectTag(
        '不可选态',
        theme: TTagTheme.primary,
        isOutline: true,
        isLight: true,
        disableSelect: true,
      ),
    ]);
  }</pre>

</td-code-block>
                
### 1 组件状态（主题）

展示型标签

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLightShowTags(BuildContext context) {
    return const Wrap(
      spacing: 8,
      children: [
        TTag('默认', isLight: true),
        TTag(
          '主要',
          isLight: true,
          theme: TTagTheme.primary,
        ),
        TTag(
          '警告',
          isLight: true,
          theme: TTagTheme.warning,
        ),
        TTag(
          '危险',
          isLight: true,
          theme: TTagTheme.danger,
        ),
        TTag(
          '成功',
          isLight: true,
          theme: TTagTheme.success,
        ),
      ],
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildDarkShowTags(BuildContext context) {
    return const Wrap(
      spacing: 8,
      children: [
        TTag('默认'),
        TTag(
          '主要',
          theme: TTagTheme.primary,
        ),
        TTag(
          '警告',
          theme: TTagTheme.warning,
        ),
        TTag(
          '危险',
          theme: TTagTheme.danger,
        ),
        TTag(
          '成功',
          theme: TTagTheme.success,
        ),
      ],
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildOutlineShowTags(BuildContext context) {
    return const Wrap(
      spacing: 8,
      children: [
        TTag('默认', isOutline: true),
        TTag(
          '主要',
          isOutline: true,
          theme: TTagTheme.primary,
        ),
        TTag(
          '警告',
          isOutline: true,
          theme: TTagTheme.warning,
        ),
        TTag(
          '危险',
          isOutline: true,
          theme: TTagTheme.danger,
        ),
        TTag(
          '成功',
          isOutline: true,
          theme: TTagTheme.success,
        ),
      ],
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLightOutlineShowTags(BuildContext context) {
    return const Wrap(
      spacing: 8,
      children: [
        TTag('默认', isOutline: true, isLight: true),
        TTag(
          '主要',
          isOutline: true,
          isLight: true,
          theme: TTagTheme.primary,
        ),
        TTag(
          '警告',
          isOutline: true,
          isLight: true,
          theme: TTagTheme.warning,
        ),
        TTag(
          '危险',
          isOutline: true,
          isLight: true,
          theme: TTagTheme.danger,
        ),
        TTag(
          '成功',
          isOutline: true,
          isLight: true,
          theme: TTagTheme.success,
        ),
      ],
    );
  }</pre>

</td-code-block>
                
### 1 组件尺寸



          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildAllSizeTags(BuildContext context) {
    return const Wrap(spacing: 8, children: [
      TTag(
        '加大尺寸',
        size: TTagSize.extraLarge,
      ),
      TTag(
        '大尺寸',
        size: TTagSize.large,
      ),
      TTag(
        '中尺寸',
        size: TTagSize.medium,
      ),
      TTag(
        '小尺寸',
        size: TTagSize.small,
      ),
    ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildAllSizeCloseTags(BuildContext context) {
    return const Wrap(spacing: 8, children: [
      TTag(
        '加大尺寸',
        needCloseIcon: true,
        size: TTagSize.extraLarge,
      ),
      TTag(
        '大尺寸',
        needCloseIcon: true,
        size: TTagSize.large,
      ),
      TTag(
        '中尺寸',
        needCloseIcon: true,
        size: TTagSize.medium,
      ),
      TTag(
        '小尺寸',
        needCloseIcon: true,
        size: TTagSize.small,
      ),
    ]);
  }</pre>

</td-code-block>
                


## API
### TTag
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String | - | 标签内容 |
| backgroundColor | Color? | - | 背景颜色，优先级高于style的backgroundColor |
| disable | bool | false | 是否为禁用状态 |
| fixedWidth | double? | - | 标签的固定宽度 |
| font | Font? | - | 字体尺寸，优先级高于style的font |
| fontWeight | FontWeight? | - | 字体粗细，优先级高于style的fontWeight |
| forceVerticalCenter | bool | true | 是否强制中文文字居中 |
| icon | IconData? | - | 图标内容，可随状态改变颜色 |
| iconWidget | Widget? | - | 自定义图标内容，需自处理颜色 |
| isLight | bool | false | 是否为浅色 |
| isOutline | bool | false | 是否为描边类型，默认不是 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| needCloseIcon | bool | false | 关闭图标 |
| onCloseTap | GestureTapCallback? | - | 关闭图标点击事件 |
| overflow | TextOverflow? | - | 文字溢出处理 |
| padding | EdgeInsets? | - | 自定义模式下的间距 |
| shape | TTagShape | TTagShape.square | 标签形状 |
| size | TTagSize | TTagSize.medium | 标签大小 |
| style | TTagStyle? | - | 标签样式 |
| textColor | Color? | - | 文字颜色，优先级高于style的textColor |
| theme | TTagTheme? | - | 主题 |


### TSelectTag
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String | - | 标签内容 |
| disableSelect | bool | false | 是否禁用选择 |
| disableSelectStyle | TTagStyle? | - | 不可选标签样式 |
| fixedWidth | double? | - | 标签的固定宽度 |
| forceVerticalCenter | bool | true | 是否强制中文文字居中 |
| icon | IconData? | - | 图标内容，可随状态改变颜色 |
| iconWidget | Widget? | - | 自定义图标内容，需自处理颜色 |
| isLight | bool | false | 是否为浅色 |
| isOutline | bool | false | 是否为描边类型，默认不是 |
| isSelected | bool | false | 是否选中 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| needCloseIcon | bool | false | 关闭图标 |
| onCloseTap | GestureTapCallback? | - | 关闭图标点击事件 |
| onSelectChanged | ValueChanged<bool>? | - | 标签点击，选中状态改变时的回调 |
| padding | EdgeInsets? | - | 自定义模式下的间距 |
| selectStyle | TTagStyle? | - | 选中的标签样式 |
| shape | TTagShape | TTagShape.square | 标签形状 |
| size | TTagSize | TTagSize.medium | 标签大小 |
| theme | TTagTheme? | - | 主题 |
| unSelectStyle | TTagStyle? | - | 未选中标签样式 |


### TTagStyle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| backgroundColor | Color? | - | 背景颜色 |
| border | double | 0 | 线框粗细 |
| borderColor | Color? | - | 边框颜色 |
| borderRadius | BorderRadiusGeometry? | - | 圆角 |
| context | BuildContext? | - | 上下文，方便获取主题内容 |
| font | Font? | - | 字体尺寸 |
| fontWeight | FontWeight? | - | 字体粗细 |
| textColor | Color? | - | 文字颜色 |

#### 公开属性

| 属性 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| closeIconColor | Color? | - | 关闭图标颜色 |


#### 工厂构造方法

##### TTagStyle.generateDisableSelectStyle

根据主题生成禁用Tag样式

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文，方便获取主题内容 |
| isLight | bool | - | - |
| isOutline | bool | - | - |
| shape | TTagShape | - | - |


##### TTagStyle.generateFillStyleByTheme

根据主题生成填充Tag样式

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文，方便获取主题内容 |
| theme | TTagTheme? | - | - |
| light | bool | - | - |
| shape | TTagShape | - | - |


##### TTagStyle.generateOutlineStyleByTheme

根据主题生成描边Tag样式

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext | - | 上下文，方便获取主题内容 |
| theme | TTagTheme? | - | - |
| light | bool | - | - |
| shape | TTagShape | - | - |


### TTagTheme
#### 简介
Tag展示类型
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| defaultTheme | 默认 |
| primary | 常规 |
| warning | 警告 |
| danger | 危险 |
| success | 成功 |


### TTagSize
#### 简介
标签尺寸
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| extraLarge | - |
| large | - |
| medium | - |
| small | - |
| custom | - |


### TTagShape
#### 简介
标签形状
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| square | - |
| round | - |
| mark | - |


  
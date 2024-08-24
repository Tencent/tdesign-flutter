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
  TDTag _buildSimpleFillTag(BuildContext context) {
    return const TDTag('标签文字');
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  TDTag _buildSimpleOutlineTag(BuildContext context) {
    return const TDTag(
      '标签文字',
      isOutline: true,
    );
  }</pre>

</td-code-block>
                

圆弧标签

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCircleFillTag(BuildContext context) {
    return const TDTag(
      '标签文字',
      shape: TDTagShape.round,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCircleOutlineTag(BuildContext context) {
    return const TDTag(
      '标签文字',
      shape: TDTagShape.round,
      isOutline: true,
    );
  }</pre>

</td-code-block>
                

Mark标签

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildMarkFillTag(BuildContext context) {
    return const TDTag(
      '标签文字',
      shape: TDTagShape.mark,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildMarkOutlineTag(BuildContext context) {
    return const TDTag(
      '标签文字',
      shape: TDTagShape.mark,
      isOutline: true,
    );
  }</pre>

</td-code-block>
                

带图标的标签

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildIconFillTag(BuildContext context) {
    return const TDTag(
      '标签文字',
      icon: TDIcons.discount,
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildIconOutlineTag(BuildContext context) {
    return const TDTag(
      '标签文字',
      icon: TDIcons.discount,
      isOutline: true,
    );
  }</pre>

</td-code-block>
                

可关闭的标签

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCloseFillTag(BuildContext context) {
    return TDTag(
      '标签文字',
      needCloseIcon: true,
      onCloseTap: () {
        TDToast.showText('点击关闭', context: context);
      },
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCloseOutlineTag(BuildContext context) {
    return TDTag('标签文字', needCloseIcon: true, isOutline: true, onCloseTap: () {
      TDToast.showText('点击关闭', context: context);
    });
  }</pre>

</td-code-block>
                

可选中的标签

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildDarkSelectTags(BuildContext context) {
    return Wrap(spacing: 8, children: const [
      TDSelectTag(
        '未选中态',
        theme: TDTagTheme.primary,
      ),
      TDSelectTag(
        '已选中态',
        theme: TDTagTheme.primary,
        isSelected: true,
      ),
      TDSelectTag(
        '不可选态',
        theme: TDTagTheme.primary,
        disableSelect: true,
      ),
    ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLightSelectTags(BuildContext context) {
    return Wrap(spacing: 8, children: const [
      TDSelectTag(
        '未选中态',
        theme: TDTagTheme.primary,
        isLight: true,
      ),
      TDSelectTag(
        '已选中态',
        theme: TDTagTheme.primary,
        isLight: true,
        isSelected: true,
      ),
      TDSelectTag(
        '不可选态',
        theme: TDTagTheme.primary,
        isLight: true,
        disableSelect: true,
      ),
    ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildOutlineSelectTags(BuildContext context) {
    return Wrap(spacing: 8, children: const [
      TDSelectTag(
        '未选中态',
        theme: TDTagTheme.primary,
        isOutline: true,
      ),
      TDSelectTag(
        '已选中态',
        theme: TDTagTheme.primary,
        isOutline: true,
        isSelected: true,
      ),
      TDSelectTag(
        '不可选态',
        theme: TDTagTheme.primary,
        isOutline: true,
        disableSelect: true,
      ),
    ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLightOutlineSelectTags(BuildContext context) {
    return Wrap(spacing: 8, children: const [
      TDSelectTag(
        '未选中态',
        theme: TDTagTheme.primary,
        isOutline: true,
        isLight: true,
      ),
      TDSelectTag(
        '已选中态',
        theme: TDTagTheme.primary,
        isOutline: true,
        isLight: true,
        isSelected: true,
      ),
      TDSelectTag(
        '不可选态',
        theme: TDTagTheme.primary,
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
    return Wrap(
      spacing: 8,
      children: const [
        TDTag('默认', isLight: true),
        TDTag(
          '主要',
          isLight: true,
          theme: TDTagTheme.primary,
        ),
        TDTag(
          '警告',
          isLight: true,
          theme: TDTagTheme.warning,
        ),
        TDTag(
          '危险',
          isLight: true,
          theme: TDTagTheme.danger,
        ),
        TDTag(
          '成功',
          isLight: true,
          theme: TDTagTheme.success,
        ),
      ],
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildDarkShowTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: const [
        TDTag('默认'),
        TDTag(
          '主要',
          theme: TDTagTheme.primary,
        ),
        TDTag(
          '警告',
          theme: TDTagTheme.warning,
        ),
        TDTag(
          '危险',
          theme: TDTagTheme.danger,
        ),
        TDTag(
          '成功',
          theme: TDTagTheme.success,
        ),
      ],
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildOutlineShowTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: const [
        TDTag('默认', isOutline: true),
        TDTag(
          '主要',
          isOutline: true,
          theme: TDTagTheme.primary,
        ),
        TDTag(
          '警告',
          isOutline: true,
          theme: TDTagTheme.warning,
        ),
        TDTag(
          '危险',
          isOutline: true,
          theme: TDTagTheme.danger,
        ),
        TDTag(
          '成功',
          isOutline: true,
          theme: TDTagTheme.success,
        ),
      ],
    );
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildLightOutlineShowTags(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: const [
        TDTag('默认', isOutline: true, isLight: true),
        TDTag(
          '主要',
          isOutline: true,
          isLight: true,
          theme: TDTagTheme.primary,
        ),
        TDTag(
          '警告',
          isOutline: true,
          isLight: true,
          theme: TDTagTheme.warning,
        ),
        TDTag(
          '危险',
          isOutline: true,
          isLight: true,
          theme: TDTagTheme.danger,
        ),
        TDTag(
          '成功',
          isOutline: true,
          isLight: true,
          theme: TDTagTheme.success,
        ),
      ],
    );
  }</pre>

</td-code-block>
                
### 1 组件尺寸



          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildAllSizeTags(BuildContext context) {
    return Wrap(spacing: 8, children: const [
      TDTag(
        '加大尺寸',
        size: TDTagSize.extraLarge,
      ),
      TDTag(
        '大尺寸',
        size: TDTagSize.large,
      ),
      TDTag(
        '中尺寸',
        size: TDTagSize.medium,
      ),
      TDTag(
        '小尺寸',
        size: TDTagSize.small,
      ),
    ]);
  }</pre>

</td-code-block>
                

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildAllSizeCloseTags(BuildContext context) {
    return Wrap(spacing: 8, children: const [
      TDTag(
        '加大尺寸',
        needCloseIcon: true,
        size: TDTagSize.extraLarge,
      ),
      TDTag(
        '大尺寸',
        needCloseIcon: true,
        size: TDTagSize.large,
      ),
      TDTag(
        '中尺寸',
        needCloseIcon: true,
        size: TDTagSize.medium,
      ),
      TDTag(
        '小尺寸',
        needCloseIcon: true,
        size: TDTagSize.small,
      ),
    ]);
  }</pre>

</td-code-block>
                


## API
### TDSelectTag
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String | text | 标签内容 |
| theme | TDTagTheme? | - | 主题 |
| icon | IconData? | - | 图标内容，可随状态改变颜色 |
| iconWidget | Widget? | - | 自定义图标内容，需自处理颜色 |
| selectStyle | TDTagStyle? | - | 选中的标签样式 |
| unSelectStyle | TDTagStyle? | - | 未选中标签样式 |
| disableSelectStyle | TDTagStyle? | - | 不可选标签样式 |
| onSelectChanged | ValueChanged<bool>? | - | 标签点击，选中状态改变时的回调 |
| isSelected | bool | false | 是否选中 |
| disableSelect | bool | false | 是否禁用选择 |
| size | TDTagSize | TDTagSize.medium | 标签大小 |
| padding | EdgeInsets? | - | 自定义模式下的间距 |
| forceVerticalCenter | bool | true | 是否强制中文文字居中 |
| isOutline | bool | false | 是否为描边类型，默认不是 |
| shape | TDTagShape | TDTagShape.square | 标签形状 |
| isLight | bool | false | 是否为浅色 |
| needCloseIcon | bool | false | 关闭图标 |
| onCloseTap | GestureTapCallback? | - | 关闭图标点击事件 |
| key |  | - |  |

```
```
 ### TDTagStyle
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| context | BuildContext? | - | 上下文，方便获取主题内容 |
| textColor | Color? | - | 文字颜色 |
| backgroundColor | Color? | - | 背景颜色 |
| font | Font? | - | 字体尺寸 |
| fontWeight | FontWeight? | - | 字体粗细 |
| border | double | 0 | 线框粗细 |
| borderColor | Color? | - | 边框颜色 |
| borderRadius | BorderRadiusGeometry? | - | 圆角 |


#### 工厂构造方法

| 名称  | 说明 |
| --- |  --- |
| TDTagStyle.generateFillStyleByTheme  | 根据主题生成填充Tag样式 |
| TDTagStyle.generateOutlineStyleByTheme  | 根据主题生成描边Tag样式 |
| TDTagStyle.generateDisableSelectStyle  | 根据主题生成禁用Tag样式 |

```
```
 ### TDTag
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String | text | 标签内容 |
| theme | TDTagTheme? | - | 主题 |
| icon | IconData? | - | 图标内容，可随状态改变颜色 |
| iconWidget | Widget? | - | 自定义图标内容，需自处理颜色 |
| textColor | Color? | - | 文字颜色, 优先级高于style的textColor |
| backgroundColor | Color? | - | 背景颜色, 优先级高于style的backgroundColor |
| font | Font? | - | 字体尺寸, 优先级高于style的font |
| fontWeight | FontWeight? | - | 字体粗细, 优先级高于style的fontWeight |
| style | TDTagStyle? | - | 标签样式 |
| size | TDTagSize | TDTagSize.medium | 标签大小 |
| padding | EdgeInsets? | - | 自定义模式下的间距 |
| forceVerticalCenter | bool | true | 是否强制中文文字居中 |
| isOutline | bool | false | 是否为描边类型，默认不是 |
| shape | TDTagShape | TDTagShape.square | 标签形状 |
| isLight | bool | false | 是否为浅色 |
| disable | bool | false | 是否为禁用状态 |
| needCloseIcon | bool | false | 关闭图标 |
| onCloseTap | GestureTapCallback? | - | 关闭图标点击事件 |
| overflow | TextOverflow? | - | 文字溢出处理 |
| key |  | - |  |


  
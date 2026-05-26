---
title: Fab 悬浮按钮
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

[td_fab_page.dart](https://github.com/Tencent/tdesign-flutter/blob/main/tdesign-component/example/lib/page/td_fab_page.dart)

### 1 组件类型

Icon Fab 纯图标悬浮按钮
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildPureIconFab(BuildContext context) {
    return _buildRowDemo([
      const TFab(
        theme: TFabTheme.primary,
      )
    ]);
  }</pre>

</td-code-block>
                                  

Icon Fab with Text 图标加文字悬浮按钮
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTextFab(BuildContext context) {
    return _buildRowDemo([
      const TFab(
        theme: TFabTheme.primary,
        text: 'Floating',
      )
    ]);
  }</pre>

</td-code-block>
                                  
### 1 组件状态

Fab Theme 悬浮按钮主题
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildThemeFab(BuildContext context) {
    return _buildRowDemoWidthDescription([
      {
        'component': const TFab(
          theme: TFabTheme.primary,
        ),
        'desc': 'Primary'
      },
      {
        'component': const TFab(
          theme: TFabTheme.defaultTheme,
        ),
        'desc': 'Default'
      },
      {
        'component': const TFab(
          theme: TFabTheme.light,
        ),
        'desc': 'Light'
      },
      {
        'component': const TFab(
          theme: TFabTheme.danger,
        ),
        'desc': 'Danger'
      },
    ]);
  }</pre>

</td-code-block>
                                  

Fab Shape 悬浮按钮形状
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildShapeFab(BuildContext context) {
    return _buildRowDemoWidthDescription([
      {
        'component': const TFab(
          theme: TFabTheme.primary,
          shape: TFabShape.circle,
        ),
        'desc': 'Circle'
      },
      {
        'component': const TFab(
          theme: TFabTheme.primary,
          shape: TFabShape.square,
        ),
        'desc': 'Square'
      },
    ]);
  }</pre>

</td-code-block>
                                  

Fab Size 悬浮按钮尺寸
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSizeFab(BuildContext context) {
    return _buildRowDemoWidthDescription([
      {
        'component': const TFab(
          theme: TFabTheme.primary,
          size: TFabSize.large,
        ),
        'desc': 'Large'
      },
      {
        'component': const TFab(
          theme: TFabTheme.primary,
          size: TFabSize.medium,
        ),
        'desc': 'Medium'
      },
      {
        'component': const TFab(
          theme: TFabTheme.primary,
          size: TFabSize.small,
        ),
        'desc': 'Small'
      },
      {
        'component': const TFab(
          theme: TFabTheme.primary,
          size: TFabSize.extraSmall,
        ),
        'desc': 'extraSmall'
      },
    ]);
  }</pre>

</td-code-block>
                                  


## API
### TFab
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| icon | Icon? | - | 图标 |
| key | Key? | - | 组件标识，用于区分或保留组件状态。 |
| onClick | VoidCallback? | - | 点击事件 |
| shape | TFabShape | TFabShape.circle | 形状 |
| size | TFabSize | TFabSize.large | 大小 |
| text | String? | - | 文本 |
| theme | TFabTheme | TFabTheme.defaultTheme | 主题 |


### TFabTheme
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| primary | - |
| defaultTheme | - |
| light | - |
| danger | - |


### TFabShape
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| circle | - |
| square | - |


### TFabSize
#### 枚举值


| 名称 | 说明 |
| --- | --- |
| large | - |
| medium | - |
| small | - |
| extraSmall | - |


  
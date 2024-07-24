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
      const TDFab(
        theme: TDFabTheme.primary,
      )
    ]);
  }</pre>

</td-code-block>
                                  

Icon Fab with Text 图标加文字悬浮按钮
            
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildTextFab(BuildContext context) {
    return _buildRowDemo([
      const TDFab(
        theme: TDFabTheme.primary,
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
        'component': const TDFab(
          theme: TDFabTheme.primary,
        ),
        'desc': 'Primary'
      },
      {
        'component': const TDFab(
          theme: TDFabTheme.defaultTheme,
        ),
        'desc': 'Default'
      },
      {
        'component': const TDFab(
          theme: TDFabTheme.light,
        ),
        'desc': 'Light'
      },
      {
        'component': const TDFab(
          theme: TDFabTheme.danger,
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
        'component': const TDFab(
          theme: TDFabTheme.primary,
          shape: TDFabShape.circle,
        ),
        'desc': 'Circle'
      },
      {
        'component': const TDFab(
          theme: TDFabTheme.primary,
          shape: TDFabShape.square,
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
        'component': const TDFab(
          theme: TDFabTheme.primary,
          size: TDFabSize.large,
        ),
        'desc': 'Large'
      },
      {
        'component': const TDFab(
          theme: TDFabTheme.primary,
          size: TDFabSize.medium,
        ),
        'desc': 'Medium'
      },
      {
        'component': const TDFab(
          theme: TDFabTheme.primary,
          size: TDFabSize.small,
        ),
        'desc': 'Small'
      },
      {
        'component': const TDFab(
          theme: TDFabTheme.primary,
          size: TDFabSize.extraSmall,
        ),
        'desc': 'extraSmall'
      },
    ]);
  }</pre>

</td-code-block>
                                  


## API
### TDFab
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| key |  | - |  |
| theme | TDFabTheme | TDFabTheme.defaultTheme | 主题 |
| shape | TDFabShape | TDFabShape.circle | 形状 |
| size | TDFabSize | TDFabSize.large | 大小 |
| text | String? | - | 文本 |
| onClick | VoidCallback? | - | 点击事件 |
| icon | Icon? | - | 图标 |


  
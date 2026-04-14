---
title: Watermark 水印
description: 给页面的某个区域加上水印，常用于防止信息截图泄露。
spline: base
isComponent: true
---

## 引入

在tdesign_flutter/tdesign_flutter.dart中有所有组件的路径。

```dart
import 'package:tdesign_flutter/tdesign_flutter.dart';
```

## 代码演示

### 基础水印

默认使用多行文本和网格排列的水印。

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildBasicWatermark() {
    return const TWatermark(
      text: 'TDesign Watermark',
    );
  }</pre>

</td-code-block>
                

### 单行水印

使用单行文本类型的水印。

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildSingleLineWatermark() {
    return const TWatermark(
      text: 'TDesign Watermark',
      type: TWatermarkType.singleLine,
    );
  }</pre>

</td-code-block>
                

### 自定义样式

自定义水印的颜色、大小、透明度和旋转角度。

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCustomStyleWatermark(BuildContext context) {
    return TWatermark(
      text: '机密信息',
      textColor: Colors.red,
      textSize: 16,
      opacity: 0.2,
      rotate: -30,
      fontWeight: FontWeight.bold,
    );
  }</pre>

</td-code-block>
                

### 自定义间距

调整水印之间的水平和垂直间距。

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildCustomGapWatermark() {
    return const TWatermark(
      text: 'TDesign Watermark',
      gapX: 150,
      gapY: 150,
    );
  }</pre>

</td-code-block>
                

### 带内容的水印

在子组件上方添加水印。

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildWatermarkWithContent(BuildContext context) {
    return TWatermark(
      text: '内部资料',
      child: Container(
        padding: const EdgeInsets.all(16),
        color: TTheme.of(context).bgColorContainer,
        child: Column(
          children: [
            Text('这是一段重要内容', style: TTheme.of(context).fontTitleLarge),
            const SizedBox(height: 8),
            Text('水印会覆盖在这段内容上方', style: TTheme.of(context).fontBodyMedium),
          ],
        ),
      ),
    );
  }</pre>

</td-code-block>
                

### 不同排列方式

使用水平、垂直和网格排列。

          
<td-code-block panel="Dart">

  <pre slot="Dart" lang="javascript">
  Widget _buildHorizontalWatermark() {
    return const TWatermark(
      text: 'TDesign Watermark',
      layout: TWatermarkLayout.horizontal,
    );
  }

  Widget _buildVerticalWatermark() {
    return const TWatermark(
      text: 'TDesign Watermark',
      layout: TWatermarkLayout.vertical,
    );
  }

  Widget _buildGridWatermark() {
    return const TWatermark(
      text: 'TDesign Watermark',
      layout: TWatermarkLayout.grid,
    );
  }</pre>

</td-code-block>
                

## API
### TWatermark
#### 默认构造方法

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| text | String | required | 水印文本内容 |
| type | TWatermarkType | TWatermarkType.multiLine | 水印类型（单行/多行） |
| layout | TWatermarkLayout | TWatermarkLayout.grid | 水印排列方式（水平/垂直/网格） |
| textColor | Color? | theme.textColorPlaceholder | 水印文字颜色 |
| textSize | double | 14 | 水印文字大小 |
| fontWeight | FontWeight | FontWeight.normal | 水印文字粗细 |
| opacity | double | 0.15 | 水印透明度 (0.0 - 1.0) |
| rotate | double | -20 | 水印旋转角度（度） |
| gapX | double | 100 | 水平间距 |
| gapY | double | 100 | 垂直间距 |
| offsetX | double | 0 | 水平偏移量 |
| offsetY | double | 0 | 垂直偏移量 |
| zIndex | int | 1 | z-index层级 |
| width | double? | null | 水印区域宽度 |
| height | double? | null | 水印区域高度 |
| child | Widget? | null | 子组件（水印将覆盖在此组件上方） |

### TWatermarkType
水印类型枚举

| 值 | 说明 |
| --- | --- |
| singleLine | 单行文本 |
| multiLine | 多行文本 |

### TWatermarkLayout
水印排列方式枚举

| 值 | 说明 |
| --- | --- |
| horizontal | 水平排列 |
| vertical | 垂直排列 |
| grid | 网格排列 |

